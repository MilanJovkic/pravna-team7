"""Reasoning quality matrix: deterministic + random scenario validation.

Goals:
- detect false-positive homicide suggestions
- detect sanction inconsistency
- validate physical-impossibility gate
- provide qualitative analysis report for positive/negative/edge cases
"""
from __future__ import annotations

import logging
import json
import random
import sys
from dataclasses import dataclass, asdict
from datetime import datetime, timezone
from pathlib import Path
from typing import Any

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from fastapi.testclient import TestClient

from backend.app.main import app

OUT_JSON = ROOT / "output" / "reasoning_quality_report.json"
OUT_MD = ROOT / "output" / "reasoning_quality_report.md"


@dataclass
class ScenarioResult:
    name: str
    category: str
    expected_status: int
    status: int
    passed: bool
    notes: str
    applied_norms: list[str]
    applied_articles: list[str]
    suggested_verdict: str
    suggested_sanction: str
    rule_status: str
    detail: str


def post_reasoning(client: TestClient, facts: dict[str, Any]) -> tuple[int, dict[str, Any]]:
    payload = {"facts": facts, "top_k": 5, "strict_mode": True}
    response = client.post("/api/reasoning/", json=payload)
    try:
        body = response.json()
    except Exception:
        body = {"detail": response.text}
    return response.status_code, body


def is_physical_absurd(facts: dict[str, Any]) -> bool:
    no_injury_markers = {
        "nema",
        "nema povrede",
        "nema_povrede",
        "bez povrede",
        "bez_povrede",
        "nema nikakve povrede",
        "nema_nikakve_povrede",
        "none",
        "no_injury",
    }
    death_flag = facts.get("life_consequence_type") == "smrt_nastupila" or facts.get("death_result") is True
    injury_type = str(facts.get("injury_type") or "").strip().lower()
    injury_level = str(facts.get("injury_severity_level") or "").strip().lower()
    return bool(death_flag and (injury_type in no_injury_markers or injury_level in no_injury_markers))


def build_curated_cases() -> list[dict[str, Any]]:
    return [
        {
            "name": "POS-EXPLICIT-DEATH-01",
            "category": "positive",
            "facts": {
                "defendant": "POS-EXPLICIT-DEATH-01",
                "life_consequence_type": "smrt_nastupila",
                "guilt_form": "umisljaj_direktni",
                "injury_severity_level": "teska",
            },
        },
        {
            "name": "POS-EXPLICIT-DEATH-02",
            "category": "positive",
            "facts": {
                "defendant": "POS-EXPLICIT-DEATH-02",
                "life_consequence_type": "smrt_nastupila",
                "victim_status": ["dijete"],
            },
        },
        {
            "name": "POS-SEVERE-INJURY-01",
            "category": "positive",
            "facts": {
                "defendant": "POS-SEVERE-INJURY-01",
                "injury_severity_level": "teska",
                "injury_type": "teska tjelesna povreda",
                "weapon_used": True,
                "severe_consequence": True,
            },
        },
        {
            "name": "POS-LIGHT-INJURY-01",
            "category": "positive",
            "facts": {
                "defendant": "POS-LIGHT-INJURY-01",
                "injury_severity_level": "laka",
                "injury_type": "laka tjelesna povreda",
            },
        },
        {
            "name": "POS-FIGHT-01",
            "category": "positive",
            "facts": {
                "defendant": "POS-FIGHT-01",
                "fight_participation": True,
            },
        },
        {
            "name": "POS-ABANDON-01",
            "category": "positive",
            "facts": {
                "defendant": "POS-ABANDON-01",
                "left_without_help": True,
                "injury_type": "teska tjelesna povreda",
            },
        },
        {
            "name": "NEG-NO-DEATH-SPARSE-01",
            "category": "negative",
            "facts": {
                "defendant": "NEG-NO-DEATH-SPARSE-01",
            },
        },
        {
            "name": "NEG-NO-DEATH-LIGHT-01",
            "category": "negative",
            "facts": {
                "defendant": "NEG-NO-DEATH-LIGHT-01",
                "injury_severity_level": "laka",
                "injury_type": "laka tjelesna povreda",
                "life_consequence_type": "",
                "death_result": False,
            },
        },
        {
            "name": "NEG-NO-DEATH-SUICIDE-FLAG-01",
            "category": "negative",
            "facts": {
                "defendant": "NEG-NO-DEATH-SUICIDE-FLAG-01",
                "suicide_outcome": "izvrseno",
                "death_result": True,
                "life_consequence_type": "",
            },
        },
        {
            "name": "NEG-ATTEMPT-ONLY-01",
            "category": "negative",
            "facts": {
                "defendant": "NEG-ATTEMPT-ONLY-01",
                "life_consequence_type": "pokusaj",
                "guilt_form": "umisljaj_direktni",
            },
        },
        {
            "name": "EDGE-PHYSICAL-ABSURD-01",
            "category": "edge",
            "facts": {
                "defendant": "EDGE-PHYSICAL-ABSURD-01",
                "life_consequence_type": "smrt_nastupila",
                "injury_type": "nema povrede",
            },
        },
        {
            "name": "EDGE-PHYSICAL-ABSURD-02",
            "category": "edge",
            "facts": {
                "defendant": "EDGE-PHYSICAL-ABSURD-02",
                "death_result": True,
                "injury_severity_level": "none",
            },
        },
        {
            "name": "EDGE-NONPHYSICAL-TENSION-01",
            "category": "edge",
            "facts": {
                "defendant": "EDGE-NONPHYSICAL-TENSION-01",
                "life_consequence_type": "smrt_nastupila",
                "injury_severity_level": "laka",
            },
        },
        {
            "name": "EDGE-BOOLEAN-MIX-01",
            "category": "edge",
            "facts": {
                "defendant": "EDGE-BOOLEAN-MIX-01",
                "weapon_used": False,
                "severe_consequence": True,
                "death_result": False,
                "negligence": True,
                "provocation": True,
            },
        },
        {
            "name": "EDGE-BOOLEAN-MIX-02",
            "category": "edge",
            "facts": {
                "defendant": "EDGE-BOOLEAN-MIX-02",
                "weapon_used": True,
                "severe_consequence": False,
                "death_result": False,
                "negligence": False,
                "provocation": False,
                "fight_participation": True,
            },
        },
        {
            "name": "POS-SUICIDE-LAW-SHAPE-01",
            "category": "positive",
            "facts": {
                "defendant": "POS-SUICIDE-LAW-SHAPE-01",
                "suicide_outcome": "izvrseno",
                "special_action_types": ["navodjenje_na_samoubistvo"],
            },
        },
        {
            "name": "POS-ABORTION-LAW-SHAPE-01",
            "category": "positive",
            "facts": {
                "defendant": "POS-ABORTION-LAW-SHAPE-01",
                "special_action_types": ["nelegalni_pobacaj"],
                "abortion_outcomes": ["pobacaj_izvrsen"],
            },
        },
        {
            "name": "NEG-NO-DEATH-WEAPON-ONLY-01",
            "category": "negative",
            "facts": {
                "defendant": "NEG-NO-DEATH-WEAPON-ONLY-01",
                "weapon_used": True,
            },
        },
        {
            "name": "NEG-NO-DEATH-PROVOCATION-ONLY-01",
            "category": "negative",
            "facts": {
                "defendant": "NEG-NO-DEATH-PROVOCATION-ONLY-01",
                "provocation": True,
            },
        },
        {
            "name": "EDGE-DEATH-RESULT-TRUE-WITHOUT-LIFE-CONSEQUENCE-01",
            "category": "edge",
            "facts": {
                "defendant": "EDGE-DEATH-RESULT-TRUE-WITHOUT-LIFE-CONSEQUENCE-01",
                "death_result": True,
                "life_consequence_type": "",
                "injury_type": "teska tjelesna povreda",
            },
        },
    ]


def build_random_cases(total: int = 30) -> list[dict[str, Any]]:
    random.seed(20260406)
    cases: list[dict[str, Any]] = []

    life_values = ["", "smrt_nastupila", "pokusaj", "tjelesna_povreda"]
    injury_level_values = ["", "laka", "teska", "none"]
    injury_type_values = ["", "laka tjelesna povreda", "teska tjelesna povreda", "nema povrede"]
    guilt_values = ["", "umisljaj_direktni", "umisljaj_eventualni", "nehat"]
    suicide_values = ["", "izvrseno", "pokusano", "nije_primjenljivo"]
    bool_values = [None, True, False]
    special_values = [[], ["navodjenje_na_samoubistvo"], ["nelegalni_pobacaj"], ["hvatanje_oruzja_pri_svadji"]]

    for idx in range(total):
        facts = {
            "defendant": f"RND-Q-{idx:03d}",
            "life_consequence_type": random.choice(life_values),
            "injury_severity_level": random.choice(injury_level_values),
            "injury_type": random.choice(injury_type_values),
            "guilt_form": random.choice(guilt_values),
            "suicide_outcome": random.choice(suicide_values),
            "weapon_used": random.choice(bool_values),
            "severe_consequence": random.choice(bool_values),
            "death_result": random.choice(bool_values),
            "negligence": random.choice(bool_values),
            "provocation": random.choice(bool_values),
            "fight_participation": random.choice(bool_values),
            "special_action_types": random.choice(special_values),
            "abortion_outcomes": random.choice([[], ["pobacaj_izvrsen"], ["smrt_zene"]]),
        }
        cases.append({"name": f"RANDOM-{idx:03d}", "category": "random", "facts": facts})

    return cases


def evaluate_case(name: str, category: str, facts: dict[str, Any], status: int, body: dict[str, Any]) -> ScenarioResult:
    expected_status = 422 if is_physical_absurd(facts) else 200
    applied_norms = body.get("rule_reasoning", {}).get("applied_norms", []) if status == 200 else []
    applied_articles = body.get("applied_articles", []) if status == 200 else []
    suggested_verdict = body.get("suggested_verdict", "") if status == 200 else ""
    suggested_sanction = body.get("suggested_sanction", "") if status == 200 else ""
    rule_status = body.get("rule_reasoning", {}).get("status", "") if status == 200 else ""
    detail = str(body.get("detail", "")) if status != 200 else ""

    checks: list[tuple[bool, str]] = []

    checks.append((status == expected_status, f"status expected {expected_status}, got {status}"))

    explicit_life_death = facts.get("life_consequence_type") == "smrt_nastupila"
    if not explicit_life_death and status == 200:
        checks.append(("crime_art143" not in applied_norms, "unexpected homicide norm without explicit life death"))
        checks.append(("143" not in applied_articles, "unexpected article 143 without explicit life death"))

    if status == 200 and "5 godina do 15 godina" in suggested_sanction:
        checks.append(("143" in applied_articles, "high homicide sanction without article 143"))

    if status == 422:
        checks.append(("Fizički apsurd" in detail, "422 without physical-absurd explanation"))

    failures = [message for ok, message in checks if not ok]
    passed = len(failures) == 0
    notes = "OK" if passed else "; ".join(failures)

    return ScenarioResult(
        name=name,
        category=category,
        expected_status=expected_status,
        status=status,
        passed=passed,
        notes=notes,
        applied_norms=list(applied_norms),
        applied_articles=[str(item) for item in applied_articles],
        suggested_verdict=str(suggested_verdict or ""),
        suggested_sanction=str(suggested_sanction or ""),
        rule_status=str(rule_status or ""),
        detail=detail,
    )


def write_reports(results: list[ScenarioResult]) -> None:
    total = len(results)
    passed = sum(1 for item in results if item.passed)
    failed = total - passed

    by_category: dict[str, dict[str, int]] = {}
    for item in results:
        stats = by_category.setdefault(item.category, {"total": 0, "passed": 0, "failed": 0})
        stats["total"] += 1
        if item.passed:
            stats["passed"] += 1
        else:
            stats["failed"] += 1

    payload = {
        "generated_at": datetime.now(timezone.utc).isoformat(),
        "summary": {
            "total": total,
            "passed": passed,
            "failed": failed,
            "pass_rate": round((passed / total) * 100, 2) if total else 0.0,
            "by_category": by_category,
        },
        "results": [asdict(item) for item in results],
    }

    OUT_JSON.parent.mkdir(parents=True, exist_ok=True)
    OUT_JSON.write_text(json.dumps(payload, ensure_ascii=False, indent=2), encoding="utf-8")

    failed_rows = [item for item in results if not item.passed]
    lines: list[str] = []
    lines.append("# Reasoning Quality Report")
    lines.append("")
    lines.append(f"- Generated at: {payload['generated_at']}")
    lines.append(f"- Total scenarios: {total}")
    lines.append(f"- Passed: {passed}")
    lines.append(f"- Failed: {failed}")
    lines.append(f"- Pass rate: {payload['summary']['pass_rate']}%")
    lines.append("")
    lines.append("## Category Summary")
    lines.append("")
    lines.append("| Category | Total | Passed | Failed |")
    lines.append("|---|---:|---:|---:|")
    for category, stats in sorted(by_category.items()):
        lines.append(f"| {category} | {stats['total']} | {stats['passed']} | {stats['failed']} |")

    lines.append("")
    lines.append("## Failed Cases")
    lines.append("")
    if not failed_rows:
        lines.append("No failed cases detected.")
    else:
        lines.append("| Name | Category | Note | Norms | Articles |")
        lines.append("|---|---|---|---|---|")
        for item in failed_rows:
            norms = ", ".join(item.applied_norms) if item.applied_norms else "-"
            arts = ", ".join(item.applied_articles) if item.applied_articles else "-"
            lines.append(f"| {item.name} | {item.category} | {item.notes} | {norms} | {arts} |")

    lines.append("")
    lines.append("## Qualitative Notes")
    lines.append("")
    lines.append("- Homicide norm crime_art143 is considered valid only when life_consequence_type is explicitly smrt_nastupila.")
    lines.append("- 422 responses are considered valid only for physical-impossibility patterns.")
    lines.append("- High homicide sanction consistency is checked against article 143 mapping.")

    OUT_MD.write_text("\n".join(lines) + "\n", encoding="utf-8")


def run_quality_matrix() -> int:
    logging.getLogger("httpx").setLevel(logging.WARNING)
    client = TestClient(app)
    scenarios = build_curated_cases() + build_random_cases(total=30)

    results: list[ScenarioResult] = []
    for scenario in scenarios:
        status, body = post_reasoning(client, scenario["facts"])
        results.append(evaluate_case(scenario["name"], scenario["category"], scenario["facts"], status, body))

    write_reports(results)

    failed = sum(1 for item in results if not item.passed)
    print("=" * 90)
    print("REASONING QUALITY MATRIX")
    print("=" * 90)
    print(f"Scenarios: {len(results)}")
    print(f"Failed: {failed}")
    print(f"Report JSON: {OUT_JSON}")
    print(f"Report MD:   {OUT_MD}")

    return 1 if failed else 0


if __name__ == "__main__":
    raise SystemExit(run_quality_matrix())
