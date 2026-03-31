"""Contract lock tests for critical API endpoints in phase 0."""
from __future__ import annotations

import unittest
from unittest.mock import Mock
from unittest.mock import patch

from fastapi.testclient import TestClient

from backend.app.api import cases, laws, reasoning, verdict_generation, verdicts
from backend.app.main import app
from backend.app.models.schemas import CbrResult, ReasoningConfidence, RuleReasoningResult


class TestApiContractLock(unittest.TestCase):
    """Freeze response shapes for critical endpoints during refactor."""

    def setUp(self) -> None:
        self.client = TestClient(app)

    def tearDown(self) -> None:
        app.dependency_overrides.clear()

    def test_get_law_chapters_contract(self) -> None:
        mocked_chapters = [
            {"number": "I", "title": "Opste odredbe", "articles": []},
            {"number": "II", "title": "Krivicna dela", "articles": []},
        ]
        mocked_service = Mock()
        mocked_service.get_all_chapters.return_value = mocked_chapters
        app.dependency_overrides[laws.get_law_service] = lambda: mocked_service
        response = self.client.get("/api/laws/chapters")

        self.assertEqual(200, response.status_code)
        body = response.json()
        self.assertEqual({"chapters", "total"}, set(body.keys()))
        self.assertEqual(2, body["total"])
        self.assertEqual(mocked_chapters, body["chapters"])

    def test_get_law_article_contract(self) -> None:
        mocked_article = {
            "number": "123",
            "chapter_number": "X",
            "title": "Teska telesna povreda",
            "content": "Ko drugog tesko telesno povredi...",
            "norm_type": "kriminalna",
            "subjects": [],
            "legal_concepts": [],
            "sanctions": None,
            "conditions": [],
            "references": [],
        }
        mocked_service = Mock()
        mocked_service.get_article.return_value = mocked_article
        app.dependency_overrides[laws.get_law_service] = lambda: mocked_service
        response = self.client.get("/api/laws/articles/123")

        self.assertEqual(200, response.status_code)
        self.assertEqual(mocked_article, response.json())

    def test_get_verdicts_contract(self) -> None:
        mocked_verdicts = [
            {
                "case_id": "GEN-1",
                "case_number": "K-1",
                "court_name": "Osnovni sud",
                "date": "2026-01-01",
                "judges": [],
                "summary": None,
                "legal_issues": [],
                "applied_laws": [],
                "applied_articles": [],
                "decision": None,
                "outcome": "osudjen",
                "extraction_confidence": 0.91,
                "needs_review": False,
                "legal_concepts": [],
                "parties": {},
                "factual_state": {},
            }
        ]
        mocked_service = Mock()
        mocked_service.get_all_verdicts.return_value = mocked_verdicts
        app.dependency_overrides[verdicts.get_verdict_service] = lambda: mocked_service
        response = self.client.get("/api/verdicts/")

        self.assertEqual(200, response.status_code)
        body = response.json()
        self.assertEqual({"total", "verdicts"}, set(body.keys()))
        self.assertEqual(1, body["total"])
        self.assertEqual(mocked_verdicts, body["verdicts"])

    def test_get_verdict_detail_contract(self) -> None:
        mocked_verdict = {
            "case_id": "GEN-2",
            "case_number": "K-2",
            "court_name": "Visi sud",
            "date": "2026-01-02",
            "judges": [],
            "summary": None,
            "legal_issues": [],
            "applied_laws": [],
            "applied_articles": [],
            "decision": None,
            "outcome": "oslobodjen",
            "extraction_confidence": 0.87,
            "needs_review": False,
            "legal_concepts": [],
            "parties": {},
            "factual_state": {},
            "legal_reasoning": None,
            "precedent_value": None,
            "confidence": None,
            "full_text": "Tekst presude",
        }
        mocked_service = Mock()
        mocked_service.get_verdict.return_value = mocked_verdict
        app.dependency_overrides[verdicts.get_verdict_service] = lambda: mocked_service
        response = self.client.get("/api/verdicts/GEN-2")

        self.assertEqual(200, response.status_code)
        body = response.json()
        self.assertEqual("GEN-2", body["case_id"])
        self.assertIn("full_text", body)

    def test_post_reasoning_contract(self) -> None:
        request_payload = {
            "facts": {
                "defendant": "A B",
                "injury_type": "teska tjelesna povreda",
                "weapon_used": True,
                "severe_consequence": True,
            },
            "top_k": 3,
            "strict_mode": True,
        }
        mocked_rule = RuleReasoningResult(
            applied_norms=["123 st.1"],
            proofs=["proof"],
            strict_mode=True,
            status="ok",
        )
        mocked_cbr = CbrResult(matches=[])
        mocked_confidence = ReasoningConfidence(
            decision_basis="rule_only",
            final_confidence=0.77,
            rule_signal="strong",
            cbr_signal="none",
            cbr_confidence=0.0,
            cbr_top_similarity=0.0,
            conflict=False,
        )

        mocked_rule_service = Mock()
        mocked_rule_service.run.return_value = mocked_rule
        mocked_cbr_service = Mock()
        mocked_cbr_service.query.return_value = mocked_cbr
        mocked_explain_service = Mock()
        mocked_explain_service.map_norms_to_articles.return_value = ["123"]
        mocked_explain_service.get_applied_law_texts.return_value = []
        mocked_explain_service.suggest_verdict.return_value = "osudjen"
        mocked_explain_service.suggest_sanction.return_value = "zatvor"
        mocked_explain_service.build_confidence_report.return_value = mocked_confidence

        app.dependency_overrides[reasoning.get_rule_reasoning_service] = lambda: mocked_rule_service
        app.dependency_overrides[reasoning.get_cbr_service] = lambda: mocked_cbr_service
        app.dependency_overrides[reasoning.get_reasoning_explain_service] = lambda: mocked_explain_service
        response = self.client.post("/api/reasoning/", json=request_payload)

        self.assertEqual(200, response.status_code)
        body = response.json()
        self.assertIn("rule_reasoning", body)
        self.assertIn("cbr", body)
        self.assertIn("subsystem_status", body)
        self.assertIn("applied_articles", body)
        self.assertIn("suggested_verdict", body)
        self.assertIn("reasoning_confidence", body)

    def test_post_case_contract(self) -> None:
        request_payload = {
            "facts": {"defendant": "A B"},
            "selected_verdict": "osudjen",
            "selected_sanction": "zatvor",
            "user_confirmation": True,
        }

        mocked_result = {
            "id": 42,
            "case_number": "USER-42",
            "reused_existing": False,
            "version": 1,
        }
        mocked_service = Mock()
        mocked_service.insert_case.return_value = mocked_result
        app.dependency_overrides[cases.get_case_service] = lambda: mocked_service
        response = self.client.post("/api/cases/", json=request_payload)

        self.assertEqual(200, response.status_code)
        body = response.json()
        self.assertEqual({"id", "case_number", "reused_existing", "version"}, set(body.keys()))
        self.assertEqual("USER-42", body["case_number"])

    def test_post_verdict_generation_contract(self) -> None:
        request_payload = {
            "facts": {"defendant": "A B"},
            "reasoning": {
                "rule_reasoning": {
                    "applied_norms": [],
                    "proofs": [],
                    "strict_mode": True,
                    "status": "ok",
                },
                "cbr": {"matches": []},
                "subsystem_status": {"rule": "ok", "cbr": "ok"},
                "applied_articles": [],
                "applied_law_texts": [],
                "suggested_verdict": "osudjen",
                "suggested_sanction": "zatvor",
                "reasoning_confidence": {
                    "decision_basis": "consensus",
                    "final_confidence": 0.8,
                    "rule_signal": "strong",
                    "cbr_signal": "strong",
                    "cbr_confidence": 0.79,
                    "cbr_top_similarity": 0.81,
                    "conflict": False,
                },
            },
        }

        mocked_generation = {
            "case_id": "GEN-NEW-1",
            "case_number": "GEN-NEW-1",
            "xml_file": "data/verdicts_xml/GEN-NEW-1.xml",
            "verdict_text": "Presuda...",
            "quality_status": {"status": "ok"},
            "generation_plan": {"mode": "deterministic"},
        }
        mocked_service = Mock()
        mocked_service.generate.return_value = mocked_generation
        app.dependency_overrides[verdict_generation.get_verdict_generation_service] = lambda: mocked_service
        response = self.client.post("/api/verdict-generation/", json=request_payload)

        self.assertEqual(200, response.status_code)
        body = response.json()
        self.assertEqual({"case_id", "case_number", "xml_file", "verdict_text", "quality_status", "generation_plan"}, set(body.keys()))
        self.assertEqual("GEN-NEW-1", body["case_id"])


if __name__ == "__main__":
    unittest.main()
