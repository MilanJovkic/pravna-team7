import re
import unittest
from pathlib import Path


class TestRuleNormTraceability(unittest.TestCase):
    def test_rule_norm_mapping_complete(self):
        path = Path(__file__).resolve().parents[2] / "dr-device" / "dr-device" / "rulebase.clp"
        content = path.read_text(encoding="utf-8")

        mappings = re.findall(r"\(defeasiblerule\s+(rule\d+).*?=>\s*\((crime_art[0-9a-zA-Z_]+)", content, flags=re.S)
        self.assertGreaterEqual(len(mappings), 30)

        norms = {norm for _, norm in mappings}
        rule_ids = {rule_id for rule_id, _ in mappings}
        self.assertIn("crime_art143", norms)
        self.assertIn("crime_art150", norms)
        self.assertIn("crime_art151a", norms)
        self.assertIn("crime_art151b", norms)
        self.assertIn("crime_art156", norms)
        self.assertIn("crime_art157", norms)
        self.assertIn("crime_art151_1", norms)
        self.assertIn("crime_art155_1", norms)
        self.assertEqual({f"rule{i}" for i in range(1, 35)}, rule_ids)


if __name__ == "__main__":
    unittest.main()
