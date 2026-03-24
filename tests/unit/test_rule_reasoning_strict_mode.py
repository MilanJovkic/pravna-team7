import unittest

from backend.app.models.schemas import CaseFacts
from backend.app.services.rule_reasoning_service import RuleReasoningService


class TestRuleReasoningStrictMode(unittest.TestCase):
    def setUp(self):
        self.service = RuleReasoningService()

    def test_strict_mode_returns_no_proof(self):
        facts = CaseFacts(injury_type="teska tjelesna povreda")
        result = self.service._finalize_result([], [], facts, strict_mode=True)
        self.assertEqual([], result.applied_norms)
        self.assertEqual("no_proof", result.status)
        self.assertTrue(result.strict_mode)

    def test_non_strict_mode_returns_no_proof_without_heuristics(self):
        facts = CaseFacts(injury_type="teska tjelesna povreda")
        result = self.service._finalize_result([], [], facts, strict_mode=False)
        self.assertEqual([], result.applied_norms)
        self.assertEqual("no_proof", result.status)
        self.assertFalse(result.strict_mode)


if __name__ == "__main__":
    unittest.main()
