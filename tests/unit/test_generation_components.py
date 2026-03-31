import unittest

from backend.app.application.services.post_generation_validator import PostGenerationValidator
from backend.app.application.services.prompt_builder import PromptBuilder
from backend.app.models.schemas import CaseFacts, CbrResult, CbrMatch, ReasoningResponse, RuleReasoningResult


class TestGenerationComponents(unittest.TestCase):
    def setUp(self):
        self.facts = CaseFacts(
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
            fight_consequence="teska povreda",
        )
        self.reasoning = ReasoningResponse(
            rule_reasoning=RuleReasoningResult(applied_norms=["crime_art151_2"], proofs=[]),
            cbr=CbrResult(matches=[CbrMatch(case_number="K-123/23", similarity=0.81)]),
            applied_articles=["151"],
            applied_law_texts=[{"article_number": "151", "content": "Ko drugome nanese tesku telesnu povredu..."}],
            suggested_verdict="osudjen",
            suggested_sanction="kazna zatvora",
        )

    def test_prompt_builder_includes_core_fields(self):
        builder = PromptBuilder()

        prompt = builder.build(
            case_number="K-1/26",
            court_name="Osnovni sud",
            date_value="2026-03-31",
            judges=["Sudija 1"],
            facts=self.facts,
            reasoning=self.reasoning,
            selected_verdict="osudjen",
            selected_sanction="kazna zatvora",
        )

        self.assertIn("Broj predmeta: K-1/26", prompt)
        self.assertIn("Predlog presude: osudjen", prompt)
        self.assertIn("Primenjeni clanci: 151", prompt)
        self.assertIn("Slicni slucajevi: K-123/23 (81%)", prompt)

    def test_post_generation_validator_reports_missing_legal_reference(self):
        validator = PostGenerationValidator()
        result = validator.validate(
            verdict_text="Presuda je doneta i odredjena je kazna zatvora.",
            facts=self.facts,
            reasoning=self.reasoning,
            generation_plan={"case_summary": {}, "key_facts": {}},
        )

        self.assertEqual(result["overall_quality"], "warning")
        self.assertFalse(result["post_validation"]["legal_references_valid"])
        self.assertIn("Missing legal article references in verdict text", result["post_validation"]["errors"])


if __name__ == "__main__":
    unittest.main()