import unittest
from pathlib import Path

from backend.app.services.rule_artifact_validator import validate_rule_artifacts


class TestRuleArtifactValidator(unittest.TestCase):
    def test_rule_artifacts_are_valid(self):
        dr_dir = Path(__file__).resolve().parents[2] / "dr-device" / "dr-device"
        errors = validate_rule_artifacts(dr_dir)
        self.assertEqual([], errors, f"Rule artifacts validation failed: {errors}")


if __name__ == "__main__":
    unittest.main()
