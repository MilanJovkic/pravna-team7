"""Measure fallback activation rate across protocol and quality scenario sets."""
from __future__ import annotations

import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from backend.app.models.schemas import CaseFacts
from backend.app.services.rule_reasoning_service import RuleReasoningService
from scripts.reasoning_quality_matrix import build_curated_cases, build_random_cases


def run_set(service: RuleReasoningService, name: str, cases: list[dict]) -> dict[str, object]:
    local: dict[str, object] = {
        "total": 0,
        "fallback": 0,
        "primary_with_norms": 0,
        "no_proof": 0,
        "fallback_cases": [],
    }
    original = service._infer_legal_fallback_norms

    for item in cases:
        facts_dict = item["facts"] if "facts" in item else item
        case_name = item.get("name", "unknown")

        fallback_hit = {"value": False}

        def wrapped(facts):
            norms = original(facts)
            if norms:
                fallback_hit["value"] = True
            return norms

        service._infer_legal_fallback_norms = wrapped
        result = service.run(CaseFacts(**facts_dict), strict_mode=True)

        local["total"] = int(local["total"]) + 1
        if fallback_hit["value"]:
            local["fallback"] = int(local["fallback"]) + 1
            fallback_cases = local["fallback_cases"]
            assert isinstance(fallback_cases, list)
            fallback_cases.append(case_name)
        elif result.applied_norms:
            local["primary_with_norms"] = int(local["primary_with_norms"]) + 1
        else:
            local["no_proof"] = int(local["no_proof"]) + 1

    service._infer_legal_fallback_norms = original
    return local


def main() -> int:
    service = RuleReasoningService()

    with (ROOT / "tests" / "data" / "final_eval_protocol.json").open("r", encoding="utf-8") as fh:
        locked = json.load(fh)["fixed_verdicts"]
    locked_cases = [{"facts": case["facts"], "name": case["case_id"]} for case in locked]

    with (ROOT / "tests" / "data" / "final_eval_adversarial_protocol.json").open("r", encoding="utf-8") as fh:
        adversarial = json.load(fh)["fixed_verdicts"]
    adversarial_cases = [{"facts": case["facts"], "name": case["case_id"]} for case in adversarial]

    groups = {
        "locked_protocol": locked_cases,
        "adversarial_protocol": adversarial_cases,
        "quality_curated": build_curated_cases(),
        "quality_random_60": build_random_cases(total=60),
    }

    summary: dict[str, object] = {
        "total": 0,
        "fallback": 0,
        "primary_with_norms": 0,
        "no_proof": 0,
        "by_set": {},
    }

    for name, cases in groups.items():
        result = run_set(service, name, cases)
        summary["by_set"][name] = result
        for key in ("total", "fallback", "primary_with_norms", "no_proof"):
            summary[key] = int(summary[key]) + int(result[key])

    print(json.dumps(summary, ensure_ascii=False, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
