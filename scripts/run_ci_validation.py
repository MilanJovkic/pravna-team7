#!/usr/bin/env python3
"""Single-command CI validator: starts API, runs tests, runs final evaluation."""

from __future__ import annotations

import os
import subprocess
import sys
import time
from pathlib import Path

import requests


ROOT = Path(__file__).resolve().parents[1]
PYTHON = sys.executable
BASE_URL = os.getenv("TEST_API_BASE_URL", "http://127.0.0.1:8000/api")
HEALTH_URL = BASE_URL.replace("/api", "") + "/health"


def run_step(name: str, command: list[str], env: dict[str, str]) -> bool:
    print("\n" + "-" * 78)
    print(f"STEP: {name}")
    print("-" * 78)
    result = subprocess.run(command, cwd=str(ROOT), env=env)
    if result.returncode != 0:
        print(f"[FAIL] {name} (exit={result.returncode})")
        return False
    print(f"[PASS] {name}")
    return True


def wait_for_health(timeout_seconds: int = 60) -> bool:
    started = time.time()
    while time.time() - started < timeout_seconds:
        try:
            response = requests.get(HEALTH_URL, timeout=3)
            if response.status_code == 200 and response.json().get("status") == "healthy":
                return True
        except Exception:
            pass
        time.sleep(1)
    return False


def main() -> int:
    env = os.environ.copy()
    env.setdefault("PYTHONUNBUFFERED", "1")
    env.setdefault("TEST_API_BASE_URL", BASE_URL)

    api_cmd = [
        PYTHON,
        "-m",
        "uvicorn",
        "backend.app.main:app",
        "--host",
        "127.0.0.1",
        "--port",
        "8000",
    ]

    print("Starting API server for CI validation...")
    server = subprocess.Popen(api_cmd, cwd=str(ROOT), env=env)

    try:
        if not wait_for_health():
            print(f"[FAIL] API did not become healthy at {HEALTH_URL}")
            return 2

        steps = [
            (
                "Phase 0-3 verified unit governance suite",
                [
                    PYTHON,
                    "-m",
                    "unittest",
                    "tests.test_phase0_governance",
                    "tests.unit.test_law_reference_parser",
                    "tests.unit.test_law_xml_validator",
                    "tests.unit.test_outcome_normalizer",
                    "tests.unit.test_verdict_quality_gate",
                    "tests.unit.test_rule_artifact_validator",
                    "tests.unit.test_rule_reasoning_strict_mode",
                    "tests.unit.test_rule_norm_traceability",
                    "-v",
                ],
            ),
            ("API smoke", [PYTHON, "tests/api_smoke.py"]),
            ("Final protocol evaluation (5 locked verdicts)", [PYTHON, "scripts/evaluate_final_protocol.py"]),
        ]

        for name, command in steps:
            if not run_step(name, command, env):
                return 1

        print("\nAll CI validation steps passed.")
        return 0
    finally:
        server.terminate()
        try:
            server.wait(timeout=10)
        except subprocess.TimeoutExpired:
            server.kill()


if __name__ == "__main__":
    raise SystemExit(main())
