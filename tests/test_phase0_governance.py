import unittest
from pathlib import Path


class TestPhase0Governance(unittest.TestCase):
    def setUp(self):
        self.repo_root = Path(__file__).resolve().parents[1]
        self.final_guide = self.repo_root / "docs" / "FINAL_SYSTEM_GUIDE.md"

    def test_governance_documents_exist(self):
        self.assertTrue(self.final_guide.exists(), "Missing docs/FINAL_SYSTEM_GUIDE.md")

    def test_final_guide_contains_required_sections(self):
        content = self.final_guide.read_text(encoding="utf-8")

        self.assertIn("Mission Outcome", content)
        self.assertIn("Runtime Architecture", content)
        self.assertIn("Validation Evidence", content)
        self.assertIn("Production Readiness Statement", content)

    def test_final_guide_references_core_validation_commands(self):
        content = self.final_guide.read_text(encoding="utf-8")
        self.assertIn("python scripts/run_ci_validation.py", content)
        self.assertIn("python tests/test_the_swap.py", content)


if __name__ == "__main__":
    unittest.main()
