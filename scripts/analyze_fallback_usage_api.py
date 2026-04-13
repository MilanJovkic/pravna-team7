"""Measure fallback usage in real API flow by instrumenting RuleReasoningService."""
from __future__ import annotations

import json
import logging
import sys
from pathlib import Path
from typing import Any

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from fastapi.testclient import TestClient

from backend.app.main import app
from backend.app.services.rule_reasoning_service import RuleReasoningService
from scripts.reasoning_quality_matrix import build_curated_cases, build_random_cases


def post_reasoning(client: TestClient, facts: dict[str, Any]) -> tuple[int, dict[str, Any]]:
    response = client.post("/api/reasoning/", json={"facts": facts, "top_k": 5, "strict_mode": True})
    try:
        body = response.json()
    except Exception:
        body = {"detail": response.text}
    return response.status_code, body


def main() -> int:
    logging.getLogger("httpx").setLevel(logging.WARNING)

    with (ROOT / "tests" / "data" / "final_eval_protocol.json").open("r", encoding="utf-8") as fh:
        locked = json.load(fh)["fixed_verdicts"]
    locked_cases = [{"name": case["case_id"], "facts": case["facts"]} for case in locked]

    with (ROOT / "tests" / "data" / "final_eval_adversarial_protocol.json").open("r", encoding="utf-8") as fh:
        adversarial = json.load(fh)["fixed_verdicts"]
    adversarial_cases = [{"name": case["case_id"], "facts": case["facts"]} for case in adversarial]

    groups: dict[str, list[dict[str, Any]]] = {
        "locked_protocol": locked_cases,
        "adversarial_protocol": adversarial_cases,
        "quality_curated": build_curated_cases(),
        "quality_random_30": build_random_cases(total=30),
    }

    fallback_hits: list[str] = []
    original = RuleReasoningService._infer_legal_fallback_norms

    def wrapped(self: RuleReasoningService, facts):
        norms = original(self, facts)
        if norms:
            fallback_hits.append(str(facts.defendant or "unknown"))
        return norms

    RuleReasoningService._infer_legal_fallback_norms = wrapped

    summary: dict[str, Any] = {
        "total": 0,
        "fallback": 0,
        "primary_with_norms": 0,
        "no_proof": 0,
        "validation_rejected": 0,
        "by_set": {},
    }

    client = TestClient(app)
    try:
        for group_name, scenarios in groups.items():
            local = {
                "total": 0,
                "fallback": 0,
                "primary_with_norms": 0,
                "no_proof": 0,
                "validation_rejected": 0,
                "fallback_cases": [],
            }

            start_hits = len(fallback_hits)
            for scenario in scenarios:
                facts = scenario["facts"]
                case_name = scenario.get("name") or str(facts.get("defendant") or "unknown")
                status, body = post_reasoning(client, facts)

                local["total"] += 1
                if status == 422:
                    local["validation_rejected"] += 1
                    continue

                rule = body.get("rule_reasoning", {})
                norms = rule.get("applied_norms") or []
                rule_status = rule.get("status")

                new_hits = fallback_hits[start_hits:]
                if str(facts.get("defendant") or "unknown") in new_hits:
                    local["fallback"] += 1
                    local["fallback_cases"].append(case_name)
                elif norms and rule_status == "ok":
                    local["primary_with_norms"] += 1
                else:
                    local["no_proof"] += 1

            summary["by_set"][group_name] = local
            for key in ("total", "fallback", "primary_with_norms", "no_proof", "validation_rejected"):
                summary[key] += local[key]
    finally:
        RuleReasoningService._infer_legal_fallback_norms = original

    print(json.dumps(summary, ensure_ascii=False, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
