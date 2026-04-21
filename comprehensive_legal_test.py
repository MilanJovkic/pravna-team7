"""Comprehensive legal permissiveness test.

Runs 100+ random fact combinations against /api/reasoning/ and verifies:
- non-physical combinations are accepted (HTTP 200)
- physically absurd combinations are rejected (HTTP 422)

Also prints a matrix of 10 weird but legally discussable combinations that should pass.
"""
from __future__ import annotations

import logging
import random
from typing import Any

from fastapi.testclient import TestClient

from backend.app.api import reasoning
from backend.app.main import app
from backend.app.models.schemas import CbrResult, RuleReasoningResult

NO_INJURY_MARKERS = {
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


def is_physical_absurd(facts: dict[str, Any]) -> bool:
    death_flag = facts.get("life_consequence_type") == "smrt_nastupila" or facts.get("death_result") is True
    injury_type = str(facts.get("injury_type") or "").strip().lower()
    injury_level = str(facts.get("injury_severity_level") or "").strip().lower()
    no_injury = injury_type in NO_INJURY_MARKERS or injury_level in NO_INJURY_MARKERS
    return bool(death_flag and no_injury)


def build_random_facts(seed_index: int) -> dict[str, Any]:
    life_consequence_values = [None, "smrt_nastupila", "tjelesna_povreda", "teska_povreda"]
    injury_level_values = [None, "laka", "teska", "nema povrede", "none"]
    injury_type_values = [None, "laka tjelesna povreda", "teska tjelesna povreda", "nema povrede", "bez_povrede"]
    bool_values = [None, True, False]
    guilt_values = [None, "umisljaj_direktni", "nehat"]
    motive_values = [[], ["koristoljublje"], ["ljubomora"], ["afekat"]]
    execution_values = [[], ["na_mah"], ["podmukao_nacin"], ["svirep_nacin"]]

    return {
        "defendant": f"RND-{seed_index:03d}",
        "life_consequence_type": random.choice(life_consequence_values),
        "death_result": random.choice(bool_values),
        "injury_severity_level": random.choice(injury_level_values),
        "injury_type": random.choice(injury_type_values),
        "weapon_used": random.choice(bool_values),
        "fight_participation": random.choice(bool_values),
        "left_without_help": random.choice(bool_values),
        "negligence": random.choice(bool_values),
        "provocation": random.choice(bool_values),
        "guilt_form": random.choice(guilt_values),
        "offender_motive": random.choice(motive_values),
        "execution_manner": random.choice(execution_values),
    }


def build_weird_but_valid_cases() -> list[dict[str, Any]]:
    return [
        {
            "defendant": "WEIRD-01",
            "life_consequence_type": "smrt_nastupila",
            "death_result": True,
            "injury_severity_level": "laka",
            "injury_type": "laka tjelesna povreda",
            "weapon_used": False,
            "fight_participation": False,
            "left_without_help": False,
            "negligence": False,
            "provocation": False,
        },
        {
            "defendant": "WEIRD-02",
            "life_consequence_type": "smrt_nastupila",
            "death_result": True,
            "injury_severity_level": "teska",
            "injury_type": "teska tjelesna povreda",
            "weapon_used": False,
            "fight_participation": False,
            "left_without_help": True,
            "negligence": True,
            "provocation": True,
        },
        {
            "defendant": "WEIRD-03",
            "life_consequence_type": "tjelesna_povreda",
            "death_result": True,
            "injury_severity_level": "teska",
            "injury_type": "teska tjelesna povreda",
            "weapon_used": None,
            "fight_participation": True,
            "left_without_help": False,
            "negligence": True,
            "provocation": False,
        },
        {
            "defendant": "WEIRD-04",
            "life_consequence_type": None,
            "death_result": True,
            "injury_severity_level": "laka",
            "injury_type": "laka tjelesna povreda",
            "weapon_used": False,
            "fight_participation": False,
            "left_without_help": True,
            "negligence": None,
            "provocation": True,
        },
        {
            "defendant": "WEIRD-05",
            "life_consequence_type": "smrt_nastupila",
            "death_result": None,
            "injury_severity_level": "teska",
            "injury_type": "teska tjelesna povreda",
            "weapon_used": True,
            "fight_participation": False,
            "left_without_help": False,
            "negligence": False,
            "provocation": True,
        },
        {
            "defendant": "WEIRD-06",
            "life_consequence_type": "smrt_nastupila",
            "death_result": True,
            "injury_severity_level": "laka",
            "injury_type": "teska tjelesna povreda",
            "weapon_used": None,
            "fight_participation": True,
            "left_without_help": None,
            "negligence": True,
            "provocation": None,
        },
        {
            "defendant": "WEIRD-07",
            "life_consequence_type": "teska_povreda",
            "death_result": True,
            "injury_severity_level": "laka",
            "injury_type": "laka tjelesna povreda",
            "weapon_used": False,
            "fight_participation": True,
            "left_without_help": True,
            "negligence": False,
            "provocation": False,
        },
        {
            "defendant": "WEIRD-08",
            "life_consequence_type": "smrt_nastupila",
            "death_result": True,
            "injury_severity_level": "teska",
            "injury_type": "laka tjelesna povreda",
            "weapon_used": False,
            "fight_participation": False,
            "left_without_help": False,
            "negligence": False,
            "provocation": True,
        },
        {
            "defendant": "WEIRD-09",
            "life_consequence_type": "smrt_nastupila",
            "death_result": True,
            "injury_severity_level": "laka",
            "injury_type": "laka tjelesna povreda",
            "weapon_used": True,
            "fight_participation": True,
            "left_without_help": False,
            "negligence": True,
            "provocation": True,
        },
        {
            "defendant": "WEIRD-10",
            "life_consequence_type": None,
            "death_result": True,
            "injury_severity_level": "teska",
            "injury_type": "teska tjelesna povreda",
            "weapon_used": False,
            "fight_participation": False,
            "left_without_help": False,
            "negligence": True,
            "provocation": False,
        },
    ]


def post_reasoning(client: TestClient, facts: dict[str, Any]) -> tuple[int, dict[str, Any]]:
    payload = {"facts": facts, "top_k": 5, "strict_mode": True}
    response = client.post("/api/reasoning/", json=payload)
    body = {}
    try:
        body = response.json()
    except Exception:
        body = {"detail": response.text}
    return response.status_code, body


class FastRuleEngine:
    """Fast deterministic rule engine used only by this stress test."""

    def run(self, facts, strict_mode: bool = True) -> RuleReasoningResult:
        _ = strict_mode
        if facts.life_consequence_type == "smrt_nastupila" or facts.death_result is True:
            norms = ["crime_art143"]
        elif facts.injury_severity_level == "teska":
            norms = ["crime_art151_1"]
        elif facts.injury_severity_level == "laka":
            norms = ["crime_art152_1"]
        else:
            norms = []
        return RuleReasoningResult(applied_norms=norms, proofs=[], status="ok", strict_mode=True)


class FastCbrEngine:
    """Return empty CBR matches to keep this test focused on validation policy."""

    def query(self, facts, top_k: int) -> CbrResult:
        _ = facts
        _ = top_k
        return CbrResult(matches=[])


class FastExplainService:
    def map_norms_to_articles(self, norms: list[str]) -> list[str]:
        articles: list[str] = []
        for norm in norms:
            if not norm.startswith("crime_art"):
                continue
            article = norm.replace("crime_art", "", 1).split("_", maxsplit=1)[0]
            if article and article not in articles:
                articles.append(article)
        return articles

    def get_applied_law_texts(self, article_numbers: list[str], norms: list[str] | None = None) -> list[dict]:
        _ = norms
        return [
            {"article_number": number, "title": f"Article {number}", "content": "Synthetic test article."}
            for number in article_numbers
        ]


def run_comprehensive_test(total_random_cases: int = 140) -> None:
    random.seed(7)

    # Keep output readable and execution fast for 100+ combinations.
    logging.getLogger("httpx").setLevel(logging.WARNING)
    app.dependency_overrides[reasoning.get_rule_reasoning_service] = lambda: FastRuleEngine()
    app.dependency_overrides[reasoning.get_cbr_service] = lambda: FastCbrEngine()
    app.dependency_overrides[reasoning.get_reasoning_explain_service] = lambda: FastExplainService()
    try:
        client = TestClient(app)

        accepted = 0
        rejected = 0
        expected_absurd = 0
        mismatches: list[tuple[str, int, int, str]] = []

        for i in range(total_random_cases):
            facts = build_random_facts(i)
            expected_422 = is_physical_absurd(facts)
            status, body = post_reasoning(client, facts)

            if expected_422:
                expected_absurd += 1
                expected_status = 422
            else:
                expected_status = 200

            if status != expected_status:
                mismatches.append((facts["defendant"], expected_status, status, str(body.get("detail", ""))))

            if status == 200:
                accepted += 1
            elif status == 422:
                rejected += 1

        print("=" * 90)
        print("COMPREHENSIVE LEGAL TEST SUMMARY")
        print("=" * 90)
        print(f"Random combinations tested: {total_random_cases}")
        print(f"Expected physical absurd (must be 422): {expected_absurd}")
        print(f"Observed accepted (200): {accepted}")
        print(f"Observed rejected (422): {rejected}")
        print(f"Expectation mismatches: {len(mismatches)}")

        if mismatches:
            print("\nMISMATCH DETAILS (up to first 10):")
            for row in mismatches[:10]:
                print(f"  case={row[0]} expected={row[1]} got={row[2]} detail={row[3]}")

        weird_cases = build_weird_but_valid_cases()
        weird_rows: list[tuple[str, int, str, list[str], str]] = []

        for facts in weird_cases:
            status, body = post_reasoning(client, facts)
            rule_status = body.get("rule_reasoning", {}).get("status", "-") if status == 200 else "-"
            norms = body.get("rule_reasoning", {}).get("applied_norms", []) if status == 200 else []
            detail = body.get("detail", "") if status != 200 else ""
            weird_rows.append((facts["defendant"], status, rule_status, norms, str(detail)))

        print("\n" + "=" * 90)
        print("WEIRD COMBINATIONS THAT SHOULD NOW PASS")
        print("=" * 90)
        print("case      status  rule_status  norms")
        for case_id, status, rule_status, norms, _ in weird_rows:
            print(f"{case_id:<9} {status:<7} {rule_status:<12} {', '.join(norms) if norms else '-'}")

        failed_weird = [row for row in weird_rows if row[1] != 200]
        if failed_weird:
            print("\nWEIRD CASE FAILURES:")
            for case_id, status, _, _, detail in failed_weird:
                print(f"  {case_id}: status={status}, detail={detail}")

        assert not mismatches, "Some random combinations did not follow permissive-vs-physical policy."
        assert not failed_weird, "One or more weird combinations did not pass with HTTP 200."
    finally:
        app.dependency_overrides.clear()


if __name__ == "__main__":
    run_comprehensive_test(total_random_cases=120)
