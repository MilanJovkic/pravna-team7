from __future__ import annotations

import json
import os
from typing import Any

from fastapi.testclient import TestClient

from backend.app.main import app


def _format_match(item: dict[str, Any]) -> dict[str, Any]:
    return {
        "case_number": item.get("case_number"),
        "similarity": round(float(item.get("similarity") or 0.0), 4),
        "outcome": item.get("outcome"),
    }


def main() -> int:
    os.environ.setdefault("DB_HOST", "127.0.0.1")
    os.environ.setdefault("DB_PORT", "5433")
    os.environ.setdefault("DB_NAME", "pravna_cbr")
    os.environ.setdefault("DB_USER", "pravna_user")
    os.environ.setdefault("DB_PASSWORD", "pravna_pass")

    client = TestClient(app)

    scenarios = [
        {
            "name": "Teska povreda + noz + Podgorica",
            "payload": {
                "facts": {
                    "injury_type": "teska tjelesna povreda",
                    "location": "Podgorica",
                    "weapon": "noz",
                    "weapon_used": True,
                    "severe_consequence": True,
                },
                "top_k": 5,
                "strict_mode": True,
            },
        },
        {
            "name": "Laka povreda + flasa + Podgorica",
            "payload": {
                "facts": {
                    "injury_type": "laka tjelesna povreda",
                    "location": "Podgorica",
                    "weapon": "staklena flasa",
                    "weapon_used": True,
                },
                "top_k": 5,
                "strict_mode": True,
            },
        },
        {
            "name": "Sparse input: samo lokacija",
            "payload": {
                "facts": {
                    "location": "Podgorica",
                },
                "top_k": 5,
                "strict_mode": True,
            },
        },
    ]

    output: list[dict[str, Any]] = []

    for scenario in scenarios:
        response = client.post("/api/reasoning/", json=scenario["payload"])
        data = response.json()
        output.append(
            {
                "scenario": scenario["name"],
                "status_code": response.status_code,
                "subsystem_status": data.get("subsystem_status"),
                "suggested_verdict": data.get("suggested_verdict"),
                "reasoning_confidence": {
                    "decision_basis": (data.get("reasoning_confidence") or {}).get("decision_basis"),
                    "final_confidence": (data.get("reasoning_confidence") or {}).get("final_confidence"),
                    "cbr_top_similarity": (data.get("reasoning_confidence") or {}).get("cbr_top_similarity"),
                    "cbr_confidence": (data.get("reasoning_confidence") or {}).get("cbr_confidence"),
                },
                "top_matches": [_format_match(m) for m in (data.get("cbr", {}).get("matches", [])[:3])],
            }
        )

    print(json.dumps(output, ensure_ascii=False, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
