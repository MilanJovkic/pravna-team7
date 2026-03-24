import unittest

from src.verdict_annotation.verdict_annotator import VerdictAnnotation
from src.verdict_annotation.extraction_quality import assess_annotation_quality


class TestExtractionQuality(unittest.TestCase):
    def test_low_confidence_marks_needs_review(self):
        ann = VerdictAnnotation(
            verdict_summary="x",
            legal_issues=[],
            applied_laws=["Krivični zakonik Crne Gore"],
            applied_articles=["Član 151"],
            legal_reasoning="x",
            decision="x",
            case_outcome="usvojeno",
            legal_concepts=[],
            confidence=0.3,
            factual_state={"injury_type": ["teška tjelesna povreda"]},
        )
        needs_review, reasons = assess_annotation_quality(ann, confidence_threshold=0.65)
        self.assertTrue(needs_review)
        self.assertIn("low_confidence<0.65", reasons)

    def test_complete_high_confidence_passes(self):
        ann = VerdictAnnotation(
            verdict_summary="x",
            legal_issues=[],
            applied_laws=["Krivični zakonik Crne Gore"],
            applied_articles=["Član 151"],
            legal_reasoning="x",
            decision="x",
            case_outcome="usvojeno",
            legal_concepts=[],
            confidence=0.9,
            factual_state={"injury_type": ["teška tjelesna povreda"]},
        )
        needs_review, reasons = assess_annotation_quality(ann, confidence_threshold=0.65)
        self.assertFalse(needs_review)
        self.assertEqual([], reasons)


if __name__ == "__main__":
    unittest.main()
