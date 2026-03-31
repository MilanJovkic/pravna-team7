from __future__ import annotations

import json
from pathlib import Path
from tempfile import TemporaryDirectory
import unittest

from backend.app.application.services.generation_audit_logger import GenerationAuditLogger
from backend.app.application.services.generation_identity_policy import GenerationIdentityPolicy
from backend.app.application.services.text_generation_gateway import TextGenerationGateway
from backend.app.models.schemas import CaseFacts, CbrResult, ReasoningResponse, RuleReasoningResult, VerdictGenerationRequest


class _OfflineGenerator:
    offline = True

    def generate(self, prompt: str) -> str:
        raise RuntimeError("should not be called")


class _FailingGenerator:
    offline = False

    def generate(self, prompt: str) -> str:
        raise RuntimeError("provider down")


class TestGenerationIdentityAndGateway(unittest.TestCase):
    def _request(self) -> VerdictGenerationRequest:
        facts = CaseFacts(
            injury_type="teska tjelesna povreda",
            location="Podgorica",
            weapon="noz",
            weapon_used=True,
            severe_consequence=True,
            death_result=False,
            negligence=False,
            provocation=False,
            fight_participation=False,
            left_without_help=False,
            defendant="P. P.",
        )
        reasoning = ReasoningResponse(
            rule_reasoning=RuleReasoningResult(applied_norms=["crime_art151_2"], proofs=[]),
            cbr=CbrResult(matches=[]),
            applied_articles=["151"],
            applied_law_texts=[],
            suggested_verdict="osudjen",
            suggested_sanction="kazna zatvora",
        )
        return VerdictGenerationRequest(facts=facts, reasoning=reasoning, case_number="GEN-TEST")

    def test_identity_policy_is_deterministic(self):
        policy = GenerationIdentityPolicy()
        req = self._request()

        key1 = policy.compute_idempotency_key(req, "GEN-TEST", "Osnovni sud", "2026-03-31", ["Sudija"], "osudjen", "kazna")
        key2 = policy.compute_idempotency_key(req, "GEN-TEST", "Osnovni sud", "2026-03-31", ["Sudija"], "osudjen", "kazna")

        self.assertEqual(key1, key2)

    def test_identity_policy_uses_hash_suffix_on_collision(self):
        policy = GenerationIdentityPolicy()
        with TemporaryDirectory() as tmp_dir:
            verdicts_dir = Path(tmp_dir)
            (verdicts_dir / "GEN-TEST.xml").write_text("existing", encoding="utf-8")
            case_id = policy.resolve_case_id(verdicts_dir, "GEN-TEST", "abcdef123456")
            self.assertEqual(case_id, "GEN-TEST-abcdef12")

    def test_text_gateway_fallback_for_offline_or_failure(self):
        offline_gateway = TextGenerationGateway(_OfflineGenerator())
        text, used_fallback, reason = offline_gateway.generate("prompt", lambda: "fallback")
        self.assertEqual(text, "fallback")
        self.assertTrue(used_fallback)
        self.assertEqual(reason, "offline_mode")

        failing_gateway = TextGenerationGateway(_FailingGenerator())
        text2, used_fallback2, reason2 = failing_gateway.generate("prompt", lambda: "fallback2")
        self.assertEqual(text2, "fallback2")
        self.assertTrue(used_fallback2)
        self.assertIn("provider down", reason2)

    def test_generation_audit_logger_writes_jsonl(self):
        with TemporaryDirectory() as tmp_dir:
            logger = GenerationAuditLogger(Path(tmp_dir))
            logger.log_event("GEN-1", "quality_status", {"overall_quality": "pass"})

            audit_file = Path(tmp_dir) / "generation_audit.jsonl"
            self.assertTrue(audit_file.exists())
            lines = audit_file.read_text(encoding="utf-8").strip().splitlines()
            self.assertEqual(len(lines), 1)
            event = json.loads(lines[0])
            self.assertEqual(event["case_id"], "GEN-1")
            self.assertEqual(event["event_type"], "quality_status")


if __name__ == "__main__":
    unittest.main()