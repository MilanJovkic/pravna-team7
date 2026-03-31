import unittest

from backend.app.application.services.generation_plan_builder import GenerationPlanBuilder
from backend.app.models.schemas import CaseFacts, CbrResult, ReasoningResponse, RuleReasoningResult


class TestGenerationPlanBuilder(unittest.TestCase):
    def test_build_creates_expected_stage1_plan(self):
        builder = GenerationPlanBuilder()
        facts = CaseFacts(
            injury_type="teska tjelesna povreda",
            location="Podgorica",
            weapon="noz",
            weapon_used=True,
            severe_consequence=True,
            death_result=False,
            negligence=False,
            provocation=True,
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
            suggested_sanction="kazna zatvora 1 do 8 godina (predlog)",
        )

        plan = builder.build(
            facts=facts,
            reasoning=reasoning,
            selected_verdict="osudjen",
            selected_sanction="kazna zatvora 1 do 8 godina (predlog)",
        )

        self.assertEqual(plan["case_summary"]["defendant"], "P. P.")
        self.assertEqual(plan["applicable_laws"]["applied_norms"], ["crime_art151_2"])
        self.assertEqual(plan["applicable_laws"]["applied_articles"], ["151"])
        self.assertTrue(plan["key_facts"]["weapon_used"])
        self.assertEqual(plan["proposed_verdict"], "osudjen")
        self.assertEqual(plan["proposed_sanction"], "kazna zatvora 1 do 8 godina (predlog)")


if __name__ == "__main__":
    unittest.main()