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

    def test_death_flag_without_explicit_life_consequence_does_not_trigger_homicide_fallback(self):
        facts = CaseFacts(death_result=True, life_consequence_type="")
        result = self.service._finalize_result([], [], facts, strict_mode=True)
        self.assertEqual([], result.applied_norms)
        self.assertEqual("no_proof", result.status)

    def test_explicit_life_consequence_still_triggers_homicide_fallback(self):
        facts = CaseFacts(life_consequence_type="smrt_nastupila", death_result=False)
        result = self.service._finalize_result([], [], facts, strict_mode=True)
        self.assertEqual([], result.applied_norms)
        self.assertEqual("no_proof", result.status)

    def test_non_strict_opt_in_allows_fallback_for_explicit_death(self):
        facts = CaseFacts(life_consequence_type="smrt_nastupila", death_result=False)
        self.service._fallback_enabled = True
        result = self.service._finalize_result([], [], facts, strict_mode=False)
        self.assertIn("crime_art143", result.applied_norms)
        self.assertEqual("ok", result.status)


if __name__ == "__main__":
    unittest.main()
