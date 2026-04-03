"""API resilience and contract tests for reasoning and case-save endpoints."""
from __future__ import annotations

import unittest
from unittest.mock import patch
from unittest.mock import Mock

from fastapi.testclient import TestClient

from backend.app.api import cases, reasoning
from backend.app.main import app


class TestCasesApiContract(unittest.TestCase):
    """Validate case save payload handling and mandatory confirmation."""

    def setUp(self) -> None:
        self.client = TestClient(app)

    def tearDown(self) -> None:
        app.dependency_overrides.clear()

    def test_create_case_requires_selected_fields(self) -> None:
        payload = {
            "facts": {
                "defendant": "Test",
                "injury_type": "teska tjelesna povreda",
                "weapon_used": True,
                "severe_consequence": True,
            },
            "user_confirmation": True,
        }

        response = self.client.post("/api/cases/", json=payload)
        self.assertEqual(422, response.status_code)
        self.assertIn("selected_verdict", response.json().get("detail", ""))

    def test_create_case_accepts_explicit_selected_fields(self) -> None:
        payload = {
            "facts": {
                "defendant": "Test",
                "injury_type": "teska tjelesna povreda",
                "weapon_used": True,
                "severe_consequence": True,
            },
            "selected_verdict": "osudjen",
            "selected_sanction": "kazna zatvora (predlog)",
            "user_confirmation": True,
        }

        mocked_case_service = Mock()
        mocked_case_service.insert_case.return_value = {
            "id": 1,
            "case_number": "USER-TEST-1",
            "reused_existing": False,
            "version": 1,
        }
        app.dependency_overrides[cases.get_case_service] = lambda: mocked_case_service
        response = self.client.post("/api/cases/", json=payload)

        self.assertEqual(200, response.status_code)
        body = response.json()
        self.assertEqual("USER-TEST-1", body["case_number"])

    def test_create_case_requires_explicit_confirmation(self) -> None:
        payload = {
            "facts": {"defendant": "Test"},
            "selected_verdict": "osudjen",
            "selected_sanction": "kazna zatvora (predlog)",
            "user_confirmation": False,
        }

        response = self.client.post("/api/cases/", json=payload)
        self.assertEqual(422, response.status_code)
        self.assertIn("explicit user confirmation", response.json().get("detail", ""))


class TestReasoningApiResilience(unittest.TestCase):
    """Validate reasoning endpoint behavior under subsystem failures."""

    def setUp(self) -> None:
        self.client = TestClient(app)

    def tearDown(self) -> None:
        app.dependency_overrides.clear()

    def test_reasoning_returns_http_500_when_both_subsystems_fail(self) -> None:
        payload = {
            "facts": {
                "defendant": "Test",
                "injury_type": "teska tjelesna povreda",
                "weapon_used": True,
                "severe_consequence": True,
                "death_result": True,
                "left_without_help": True,
            },
            "top_k": 5,
            "strict_mode": True,
        }

        mocked_rule_service = Mock()
        mocked_rule_service.run.side_effect = RuntimeError("rule failed")
        mocked_cbr_service = Mock()
        mocked_cbr_service.query.side_effect = RuntimeError("cbr failed")
        app.dependency_overrides[reasoning.get_rule_reasoning_service] = lambda: mocked_rule_service
        app.dependency_overrides[reasoning.get_cbr_service] = lambda: mocked_cbr_service
        response = self.client.post("/api/reasoning/", json=payload)

        self.assertEqual(500, response.status_code)
        self.assertIn("rule_error=", response.json().get("detail", ""))


if __name__ == "__main__":
    unittest.main()
