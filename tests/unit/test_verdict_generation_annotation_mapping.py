import unittest

from backend.app.models.schemas import ReasoningResponse, RuleReasoningResult, CbrResult
from backend.app.services.verdict_generation_service import VerdictGenerationService
from src.verdict_annotation.verdict_parser import VerdictMetadata


class TestVerdictGenerationAnnotationMapping(unittest.TestCase):
    def test_structured_annotation_uses_normalize_outcome_without_name_error(self):
        service = VerdictGenerationService()
        metadata = VerdictMetadata(
            case_number="GEN-TEST",
            legal_references=["Krivicni zakonik Crne Gore"],
            article_references=["Clan 151"],
            factual_state={"injury_type": ["teska tjelesna povreda"]},
        )
        reasoning = ReasoningResponse(
            rule_reasoning=RuleReasoningResult(applied_norms=["crime_art151_2"], proofs=[]),
            cbr=CbrResult(matches=[]),
            applied_articles=["151"],
            applied_law_texts=[],
            suggested_verdict="osudjen",
            suggested_sanction="kazna zatvora 1 do 8 godina (predlog)",
        )

        annotation = service._build_structured_annotation(metadata, reasoning)

        self.assertIn(annotation.case_outcome, {"osudjen", "odbijeno", "oslobodjen", "delimicno usvojeno", "usvojeno"})
        self.assertTrue(annotation.decision)


if __name__ == "__main__":
    unittest.main()
