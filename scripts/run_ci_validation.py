#!/usr/bin/env python3
"""Single-command CI validator: starts API, runs tests, runs final evaluation."""

from __future__ import annotations

import os
import socket
import subprocess
import sys
import time
from pathlib import Path

import requests


ROOT = Path(__file__).resolve().parents[1]
PYTHON = sys.executable


def _find_available_port(preferred_port: int) -> int:
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
        sock.bind(("127.0.0.1", preferred_port))
        return preferred_port


def _reserve_ephemeral_port() -> int:
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
        sock.bind(("127.0.0.1", 0))
        return int(sock.getsockname()[1])


def choose_validation_port() -> int:
    preferred = int(os.getenv("TEST_API_PORT", "8000"))
    try:
        return _find_available_port(preferred)
    except OSError:
        return _reserve_ephemeral_port()


def run_step(name: str, command: list[str], env: dict[str, str], extra_env: dict[str, str] | None = None) -> bool:
    print("\n" + "-" * 78)
    print(f"STEP: {name}")
    print("-" * 78)
    step_env = env.copy()
    if extra_env:
        step_env.update(extra_env)
    result = subprocess.run(command, cwd=str(ROOT), env=step_env)
    if result.returncode != 0:
        print(f"[FAIL] {name} (exit={result.returncode})")
        return False
    print(f"[PASS] {name}")
    return True


def wait_for_health(health_url: str, timeout_seconds: int = 60) -> bool:
    started = time.time()
    while time.time() - started < timeout_seconds:
        try:
            response = requests.get(health_url, timeout=3)
            if response.status_code == 200 and response.json().get("status") == "healthy":
                return True
        except Exception:
            pass
        time.sleep(1)
    return False


def main() -> int:
    port = choose_validation_port()
    base_url = os.getenv("TEST_API_BASE_URL", f"http://127.0.0.1:{port}/api")
    health_url = base_url.replace("/api", "") + "/health"

    env = os.environ.copy()
    env.setdefault("PYTHONUNBUFFERED", "1")
    env["TEST_API_BASE_URL"] = base_url

    api_cmd = [
        PYTHON,
        "-m",
        "uvicorn",
        "backend.app.main:app",
        "--host",
        "127.0.0.1",
        "--port",
        str(port),
    ]

    print(f"Starting API server for CI validation on port {port}...")
    server = subprocess.Popen(api_cmd, cwd=str(ROOT), env=env)

    try:
        if not wait_for_health(health_url=health_url):
            print(f"[FAIL] API did not become healthy at {health_url}")
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
                    "tests.unit.test_architecture_boundaries",
                    "-v",
                ],
                None,
            ),
            ("API smoke", [PYTHON, "tests/api_smoke.py"], None),
            (
                "Final protocol evaluation (5 locked verdicts)",
                [PYTHON, "scripts/evaluate_final_protocol.py"],
                {
                    "EVAL_PROTOCOL_PATH": str(ROOT / "tests" / "data" / "final_eval_protocol.json"),
                    "EVAL_REPORT_JSON": str(ROOT / "output" / "final_eval_report.json"),
                    "EVAL_REPORT_MD": str(ROOT / "output" / "final_eval_report.md"),
                },
            ),
            (
                "Adversarial protocol evaluation (5 hard cases)",
                [PYTHON, "scripts/evaluate_final_protocol.py"],
                {
                    "EVAL_PROTOCOL_PATH": str(ROOT / "tests" / "data" / "final_eval_adversarial_protocol.json"),
                    "EVAL_REPORT_JSON": str(ROOT / "output" / "final_eval_adversarial_report.json"),
                    "EVAL_REPORT_MD": str(ROOT / "output" / "final_eval_adversarial_report.md"),
                },
            ),
        ]

        for name, command, extra_env in steps:
            if not run_step(name, command, env, extra_env=extra_env):
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
