#!/usr/bin/env python3
"""Final deterministic evaluation protocol over 5 locked verdict test cases."""

from __future__ import annotations

import hashlib
import json
import os
import re
import sys
from dataclasses import dataclass
from datetime import datetime, UTC
from pathlib import Path
from typing import Any

import requests


ROOT = Path(__file__).resolve().parents[1]
OUTPUT_DIR = ROOT / "output"
DEFAULT_PROTOCOL_PATH = ROOT / "tests" / "data" / "final_eval_protocol.json"
DEFAULT_REPORT_JSON = OUTPUT_DIR / "final_eval_report.json"
DEFAULT_REPORT_MD = OUTPUT_DIR / "final_eval_report.md"


@dataclass
class CriterionScore:
    name: str
    score: int
    rationale: str


class ProtocolEvaluator:
    def __init__(self, protocol: dict[str, Any], report_json: Path, report_md: Path) -> None:
        defaults = protocol["defaults"]
        self.protocol = protocol
        self.report_json = report_json
        self.report_md = report_md
        self.base_url = os.getenv(protocol.get("base_url_env", "TEST_API_BASE_URL"), defaults["base_url"]).rstrip("/")
        self.top_k = int(defaults["top_k"])
        self.stability_runs = int(defaults["stability_runs"])
        self.min_similarity = float(defaults["minimum_top_similarity"])
        self.timeout = int(defaults["request_timeout_seconds"])

        self.case_results: list[dict[str, Any]] = []
        self.global_failures: list[str] = []
        self.technical_checks: dict[str, dict[str, Any]] = {}

    def run(self) -> int:
        started = datetime.now(UTC)
        self._verify_locked_dataset()
        self._run_technical_preflight()

        for case in self.protocol["fixed_verdicts"]:
            self.case_results.append(self._evaluate_case(case))

        self._run_case_save_probe()

        overall = self._summarize()
        report = {
            "protocol_version": self.protocol["protocol_version"],
            "started_at": started.isoformat().replace("+00:00", "Z"),
            "finished_at": datetime.now(UTC).isoformat().replace("+00:00", "Z"),
            "base_url": self.base_url,
            "technical_checks": self.technical_checks,
            "global_failures": self.global_failures,
            "cases": self.case_results,
            "summary": overall,
        }

        OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
        self.report_json.write_text(json.dumps(report, ensure_ascii=False, indent=2), encoding="utf-8")
        self.report_md.write_text(self._to_markdown(report), encoding="utf-8")

        self._print_console_summary(report)
        return 0 if overall["status"] == "PASS" else 1

    def _verify_locked_dataset(self) -> None:
        for case in self.protocol["fixed_verdicts"]:
            xml_rel = case["source_xml"]
            xml_path = ROOT / xml_rel
            if not xml_path.exists():
                self.global_failures.append(f"Locked source XML missing: {xml_rel}")
                continue

            actual_hash = hashlib.sha256(xml_path.read_bytes()).hexdigest()
            expected_hash = case["source_sha256"].lower()
            if actual_hash.lower() != expected_hash:
                self.global_failures.append(
                    f"Locked XML changed for {case['case_id']} ({xml_rel}). expected={expected_hash} actual={actual_hash}"
                )

    def _run_technical_preflight(self) -> None:
        self.technical_checks["api_health"] = self._check_api_health()

    def _check_api_health(self) -> dict[str, Any]:
        url = self.base_url.replace("/api", "") + "/health"
        try:
            resp = requests.get(url, timeout=self.timeout)
            ok = resp.status_code == 200 and resp.json().get("status") == "healthy"
            return {
                "status": "PASS" if ok else "FAIL",
                "details": f"GET {url} => {resp.status_code}",
            }
        except Exception as exc:
            return {
                "status": "FAIL",
                "details": f"Health probe failed: {exc}",
            }

    def _evaluate_case(self, case: dict[str, Any]) -> dict[str, Any]:
        case_id = case["case_id"]
        facts = case["facts"]
        responses: list[dict[str, Any]] = []
        errors: list[str] = []

        for run_idx in range(self.stability_runs):
            try:
                responses.append(self._call_reasoning(facts))
            except Exception as exc:
                errors.append(f"run {run_idx + 1}: {exc}")

        if errors:
            return {
                "case_id": case_id,
                "case_number": case["case_number"],
                "status": "FAIL",
                "errors": errors,
                "red_flags": ["generic_or_useless_answer"],
                "criteria": [],
                "total_score": 0,
                "max_score": 30,
                "stability": "unstable",
            }

        stable, fingerprints = self._check_stability(responses)
        response = responses[0]

        red_flags = self._detect_red_flags(response)
        criteria = self._score_case(response, case)
        total = sum(item.score for item in criteria)
        max_score = len(criteria) * 5

        thresholds = self.protocol["thresholds"]
        critical = set(thresholds["critical_criteria"])
        critical_min = int(thresholds["critical_min_score"])
        critical_failures = [
            c.name for c in criteria if c.name in critical and c.score < critical_min
        ]

        case_pass = (
            total >= int(thresholds["per_case_min_total"])
            and not red_flags
            and not critical_failures
            and stable
        )

        if response.get("subsystem_status", {}).get("rule") != "ok":
            self.global_failures.append(f"Rule engine error for {case_id}")
        if response.get("subsystem_status", {}).get("cbr") != "ok":
            self.global_failures.append(f"CBR subsystem error for {case_id}")

        top_match = (response.get("cbr", {}).get("matches") or [{}])[0]
        top_similarity = float(top_match.get("similarity") or 0.0)
        cbr_sensible = bool(top_match.get("case_number")) and top_similarity >= self.min_similarity
        if not cbr_sensible:
            self.global_failures.append(
                f"CBR top match is not sensible for {case_id} (similarity={top_similarity:.3f})"
            )

        return {
            "case_id": case_id,
            "case_number": case["case_number"],
            "status": "PASS" if case_pass else "FAIL",
            "red_flags": red_flags,
            "criteria": [item.__dict__ for item in criteria],
            "total_score": total,
            "max_score": max_score,
            "stability": "stable" if stable else "unstable",
            "stability_fingerprints": fingerprints,
            "critical_failures": critical_failures,
            "subsystem_status": response.get("subsystem_status", {}),
            "top_match": {
                "case_number": top_match.get("case_number"),
                "similarity": top_similarity,
            },
        }

    def _run_case_save_probe(self) -> None:
        """Technical probe: save/send case + verify it can be retrieved through CBR."""
        ref_case = self.protocol["fixed_verdicts"][0]
        facts = dict(ref_case["facts"])
        facts["defendant"] = "Eval Save Probe"

        reasoning = self._call_reasoning(facts)
        payload = {
            "case_number": "CI-EVAL-PROBE",
            "facts": facts,
            "outcome": reasoning.get("suggested_verdict") or "osudjen",
            "selected_verdict": reasoning.get("suggested_verdict") or "osudjen",
            "selected_sanction": reasoning.get("suggested_sanction") or "kazna zatvora (predlog)",
            "user_confirmation": True,
        }

        check = {
            "status": "PASS",
            "details": "",
        }

        try:
            save_resp = requests.post(
                f"{self.base_url}/cases/",
                json=payload,
                timeout=self.timeout,
            )
            save_resp.raise_for_status()
            save_data = save_resp.json()
            case_number = save_data.get("case_number")

            verify = self._call_reasoning(facts)
            matches = verify.get("cbr", {}).get("matches", [])
            seen = any((m.get("case_number") or "") == case_number for m in matches)
            if not seen:
                check["status"] = "FAIL"
                check["details"] = f"Saved case {case_number} not found in CBR matches"
            else:
                check["details"] = f"Saved case {case_number} confirmed in CBR matches"
        except Exception as exc:
            check["status"] = "FAIL"
            check["details"] = f"Case save probe failed: {exc}"

        self.technical_checks["case_save_and_reuse"] = check
        if check["status"] == "FAIL":
            self.global_failures.append(check["details"])

    def _call_reasoning(self, facts: dict[str, Any]) -> dict[str, Any]:
        resp = requests.post(
            f"{self.base_url}/reasoning/",
            json={"facts": facts, "top_k": self.top_k, "strict_mode": True},
            timeout=self.timeout,
        )
        resp.raise_for_status()
        return resp.json()

    def _check_stability(self, responses: list[dict[str, Any]]) -> tuple[bool, list[str]]:
        fingerprints: list[str] = []
        for response in responses:
            norms = sorted(response.get("rule_reasoning", {}).get("applied_norms", []))
            articles = sorted(response.get("applied_articles", []))
            verdict = response.get("suggested_verdict") or ""
            sanction = response.get("suggested_sanction") or ""
            top = response.get("cbr", {}).get("matches", [])[:3]
            top_compact = [
                {
                    "case": item.get("case_number"),
                    "sim": round(float(item.get("similarity") or 0.0), 4),
                }
                for item in top
            ]
            fp = json.dumps(
                {
                    "norms": norms,
                    "articles": articles,
                    "verdict": verdict,
                    "sanction": sanction,
                    "top": top_compact,
                },
                sort_keys=True,
                ensure_ascii=False,
            )
            fingerprints.append(fp)

        return len(set(fingerprints)) == 1, fingerprints

    def _detect_red_flags(self, response: dict[str, Any]) -> list[str]:
        flags: list[str] = []
        rule = response.get("rule_reasoning", {})
        applied_norms = rule.get("applied_norms") or []
        applied_articles = response.get("applied_articles") or []
        law_texts = response.get("applied_law_texts") or []
        cbr_matches = response.get("cbr", {}).get("matches") or []

        if (
            (response.get("suggested_verdict") or response.get("suggested_sanction"))
            and not applied_norms
            and not applied_articles
        ):
            flags.append("contradiction_in_explanation")

        top_match = cbr_matches[0] if cbr_matches else {}
        top_similarity = float(top_match.get("similarity") or 0.0)
        if not top_match.get("case_number") or top_similarity < self.min_similarity:
            flags.append("nonexistent_facts_reference")

        verdict = (response.get("suggested_verdict") or "").strip().lower()
        sanction = (response.get("suggested_sanction") or "").strip().lower()
        if verdict in {"usvojeno", "osudjen"} and top_similarity < 0.65:
            flags.append("contradiction_in_explanation")
        if verdict in {"usvojeno", "osudjen"} and sanction == "kazna zatvora (predlog)":
            flags.append("generic_or_useless_answer")

        empty_explanation = not applied_norms and not law_texts and not cbr_matches
        empty_advice = not (response.get("suggested_verdict") or response.get("suggested_sanction"))
        if empty_explanation or empty_advice:
            flags.append("generic_or_useless_answer")

        return sorted(set(flags))

    def _score_case(self, response: dict[str, Any], case: dict[str, Any]) -> list[CriterionScore]:
        rule = response.get("rule_reasoning", {})
        cbr = response.get("cbr", {})
        matches = cbr.get("matches") or []
        top_match = matches[0] if matches else {}

        applied_norms = rule.get("applied_norms") or []
        applied_articles = response.get("applied_articles") or []
        expected_articles = case.get("expected", {}).get("applied_articles_any_of", [])

        legal = 0
        legal_notes: list[str] = []
        if response.get("subsystem_status", {}).get("rule") == "ok":
            legal += 1
            legal_notes.append("rule=ok")
        if applied_norms:
            legal += 2
            legal_notes.append("norme prisutne")
        if applied_articles:
            legal += 1
            legal_notes.append("clanovi prisutni")
        if self._article_overlap(applied_articles, expected_articles):
            legal += 1
            legal_notes.append("poklapanje sa ocekivanim clancima")

        consistency = 5
        consistency_notes: list[str] = []
        if response.get("subsystem_status", {}).get("rule") == "ok" and not applied_norms:
            consistency -= 2
            consistency_notes.append("rule=ok ali bez normi")
        if (response.get("suggested_verdict") or response.get("suggested_sanction")) and not applied_articles:
            consistency -= 2
            consistency_notes.append("predlog bez clanova")
        if response.get("subsystem_status", {}).get("cbr") != "ok":
            consistency -= 1
            consistency_notes.append("cbr nije ok")
        consistency = max(0, consistency)
        if not consistency_notes:
            consistency_notes.append("nema detektovanih kontradikcija")

        usefulness = 0
        usefulness_notes: list[str] = []
        if response.get("suggested_verdict"):
            usefulness += 2
            usefulness_notes.append("ima predlog vrste presude")
        if response.get("suggested_sanction"):
            usefulness += 1
            usefulness_notes.append("ima predlog sankcije")
        if matches:
            usefulness += 1
            usefulness_notes.append("vraceni slicni slucajevi")
        if (top_match.get("feature_contributions") or {}):
            usefulness += 1
            usefulness_notes.append("doprinos atributa dostupan")

        key_fact_score, key_fact_notes = self._score_key_fact_coverage(case["facts"], top_match)

        explanation = 0
        explanation_notes: list[str] = []
        law_texts = response.get("applied_law_texts") or []
        proofs = rule.get("proofs") or []
        if law_texts:
            explanation += 2
            explanation_notes.append("tekstovi primenjenih clanova")
        if any((item.get("content") or "").strip() for item in law_texts):
            explanation += 1
            explanation_notes.append("sadrzaj clanova nije prazan")
        if proofs:
            explanation += 1
            explanation_notes.append("dr-device proofs prisutni")
        if applied_norms:
            explanation += 1
            explanation_notes.append("eksplicitne primenjene norme")

        sanction_score, sanction_notes = self._score_sanction_proportionality(
            facts=case["facts"],
            verdict=response.get("suggested_verdict"),
            sanction=response.get("suggested_sanction"),
            applied_articles=applied_articles,
        )

        return [
            CriterionScore("pravna_tacnost", min(5, legal), "; ".join(legal_notes) or "n/a"),
            CriterionScore("logicka_konzistentnost", min(5, consistency), "; ".join(consistency_notes)),
            CriterionScore("korisnost_za_korisnika", min(5, usefulness), "; ".join(usefulness_notes) or "n/a"),
            CriterionScore("pokrivenost_kljucnih_cinjenica", key_fact_score, key_fact_notes),
            CriterionScore("objasnjenje_zakljucka", min(5, explanation), "; ".join(explanation_notes) or "n/a"),
            CriterionScore("proporcionalnost_sankcije", sanction_score, sanction_notes),
        ]

    def _score_sanction_proportionality(
        self,
        facts: dict[str, Any],
        verdict: str | None,
        sanction: str | None,
        applied_articles: list[str],
    ) -> tuple[int, str]:
        verdict_value = (verdict or "").strip().lower()
        sanction_value = (sanction or "").strip().lower()
        has_positive_verdict = verdict_value in {"usvojeno", "osudjen"}

        if not has_positive_verdict:
            if sanction_value == "bez sankcije":
                return 5, "odbijajuci ishod prati odsustvo sankcije"
            if not sanction_value:
                return 4, "odbijajuci ishod bez eksplicitne sankcije"
            return 1, "odbijajuci ishod sa potencijalno neadekvatnom sankcijom"

        if not sanction_value or sanction_value == "bez sankcije":
            return 0, "pozitivan ishod bez adekvatne sankcije"

        score = 1
        notes: list[str] = ["pozitivan ishod ima sankciju"]

        if re.search(r"\d", sanction_value):
            score += 2
            notes.append("sankcija sadrzi raspon/kvantifikaciju")

        if facts.get("death_result") and any(term in sanction_value for term in ("3 do 12", "5 do", "10")):
            score += 2
            notes.append("uskladjeno sa smrtnom posledicom")
        elif facts.get("severe_consequence") and any(term in sanction_value for term in ("1 do 8", "6 meseci", "5 godina")):
            score += 2
            notes.append("uskladjeno sa tezim posledicama")
        elif any("152" in str(item) for item in applied_articles) and any(
            term in sanction_value for term in ("novcana", "do 1 godine")
        ):
            score += 2
            notes.append("uskladjeno sa laksom povredom")

        return min(5, score), "; ".join(notes)

    def _score_key_fact_coverage(self, facts: dict[str, Any], top_match: dict[str, Any]) -> tuple[int, str]:
        contributions = top_match.get("feature_contributions") or {}

        important_keys = [
            "injury_type",
            "location",
            "weapon",
            "weapon_used",
            "severe_consequence",
            "fight_participation",
            "fight_consequence",
        ]
        expected = [key for key in important_keys if facts.get(key) is not None]
        if not expected:
            return 0, "nema ulaznih kljucnih cinjenica"

        covered = [key for key in expected if key in contributions]
        ratio = len(covered) / len(expected)

        if ratio >= 0.95:
            score = 5
        elif ratio >= 0.75:
            score = 4
        elif ratio >= 0.55:
            score = 3
        elif ratio >= 0.35:
            score = 2
        elif ratio > 0:
            score = 1
        else:
            score = 0

        return score, f"pokriveno {len(covered)}/{len(expected)} kljucnih cinjenica"

    def _article_overlap(self, actual_articles: list[str], expected_numbers: list[str]) -> bool:
        if not actual_articles or not expected_numbers:
            return False

        expected = set(expected_numbers)
        for article in actual_articles:
            found = re.findall(r"\d+", article)
            if any(number in expected for number in found):
                return True
        return False

    def _summarize(self) -> dict[str, Any]:
        thresholds = self.protocol["thresholds"]
        per_case_min = int(thresholds["per_case_min_total"])
        overall_min_avg = float(thresholds["overall_min_average"])

        case_failures = [c for c in self.case_results if c.get("status") != "PASS"]

        avg_score = 0.0
        if self.case_results:
            avg_score = sum(c.get("total_score", 0) for c in self.case_results) / len(self.case_results)

        tech_failures = [name for name, result in self.technical_checks.items() if result.get("status") != "PASS"]

        status = "PASS"
        reasons: list[str] = []

        if self.global_failures:
            status = "FAIL"
            reasons.append("global_failures_present")
        if case_failures:
            status = "FAIL"
            reasons.append("case_failures_present")
        if avg_score < overall_min_avg:
            status = "FAIL"
            reasons.append(f"overall_average_below_threshold ({avg_score:.2f} < {overall_min_avg:.2f})")
        if tech_failures:
            status = "FAIL"
            reasons.append(f"technical_failures: {', '.join(tech_failures)}")

        return {
            "status": status,
            "case_failures": len(case_failures),
            "per_case_min_total": per_case_min,
            "overall_min_average": overall_min_avg,
            "overall_average": round(avg_score, 3),
            "technical_failures": tech_failures,
            "reasons": reasons,
        }

    def _to_markdown(self, report: dict[str, Any]) -> str:
        summary = report["summary"]
        max_score = report["cases"][0]["max_score"] if report.get("cases") else 25
        lines = [
            "# Finalni evaluacioni izvestaj (5 zakljucanih presuda)",
            "",
            f"- Status: **{summary['status']}**",
            f"- Base URL: {report['base_url']}",
            f"- Protokol: {report['protocol_version']}",
            f"- Prosecna ocena: {summary['overall_average']} / {max_score}",
            f"- Prag proseka: {summary['overall_min_average']}",
            "",
            "## Tehnicke provere",
            "",
        ]

        for name, result in report["technical_checks"].items():
            lines.append(f"- {name}: **{result['status']}** - {result['details']}")

        if report["global_failures"]:
            lines.extend(["", "## Globalni problemi", ""])
            for item in report["global_failures"]:
                lines.append(f"- {item}")

        lines.extend(["", "## Slucajevi", ""])
        for case in report["cases"]:
            lines.append(
                f"### {case['case_id']} ({case['case_number']}) - {case['status']} ({case['total_score']}/{case['max_score']})"
            )
            lines.append(f"- Stabilnost: {case['stability']}")
            if case.get("red_flags"):
                lines.append(f"- Red flags: {', '.join(case['red_flags'])}")
            if case.get("critical_failures"):
                lines.append(f"- Critical kriterijumi ispod praga: {', '.join(case['critical_failures'])}")
            for criterion in case.get("criteria", []):
                lines.append(f"- {criterion['name']}: {criterion['score']}/5 ({criterion['rationale']})")
            lines.append("")

        return "\n".join(lines).strip() + "\n"

    def _print_console_summary(self, report: dict[str, Any]) -> None:
        summary = report["summary"]
        max_score = report["cases"][0]["max_score"] if report.get("cases") else 25
        print("\n" + "=" * 78)
        print("FINAL EVALUATION PROTOCOL")
        print("=" * 78)
        print(f"STATUS: {summary['status']}")
        print(f"AVERAGE SCORE: {summary['overall_average']} / {max_score}")
        print(f"CASE FAILURES: {summary['case_failures']}")
        print(f"TECH FAILURES: {len(summary['technical_failures'])}")
        print(f"REPORT JSON: {self.report_json}")
        print(f"REPORT MD:   {self.report_md}")

        if summary["status"] != "PASS":
            print("\nREASONS:")
            for reason in summary["reasons"]:
                print(f"- {reason}")
        print("=" * 78)


def main() -> int:
    protocol_path = Path(os.getenv("EVAL_PROTOCOL_PATH", str(DEFAULT_PROTOCOL_PATH)))
    report_json = Path(os.getenv("EVAL_REPORT_JSON", str(DEFAULT_REPORT_JSON)))
    report_md = Path(os.getenv("EVAL_REPORT_MD", str(DEFAULT_REPORT_MD)))

    if not protocol_path.exists():
        print(f"Missing protocol file: {protocol_path}")
        return 2

    report_json.parent.mkdir(parents=True, exist_ok=True)
    report_md.parent.mkdir(parents=True, exist_ok=True)

    protocol = json.loads(protocol_path.read_text(encoding="utf-8"))
    evaluator = ProtocolEvaluator(protocol, report_json=report_json, report_md=report_md)
    return evaluator.run()


if __name__ == "__main__":
    raise SystemExit(main())
