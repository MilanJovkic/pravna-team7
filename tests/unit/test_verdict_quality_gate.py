import unittest
from pathlib import Path

from src.verdict_annotation.verdict_quality_gate import validate_verdict_corpus


class TestVerdictQualityGate(unittest.TestCase):
    def test_verdict_corpus_meets_phase2_gate(self):
        verdict_dir = Path(__file__).resolve().parents[2] / "data" / "verdicts_xml"
        problems = validate_verdict_corpus(str(verdict_dir), min_count=5)
        self.assertEqual({}, problems, f"Verdict corpus quality gate failed: {problems}")


if __name__ == "__main__":
    unittest.main()
