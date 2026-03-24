import unittest
from pathlib import Path

from src.akoma_annotation.law_xml_validator import validate_law_xml


class TestLawXmlValidator(unittest.TestCase):
    def test_current_law_xml_is_semantically_valid(self):
        xml_path = Path(__file__).resolve().parents[2] / "output" / "annotated_law.xml"
        errors = validate_law_xml(str(xml_path))
        self.assertEqual([], errors, f"Expected no law XML validation errors, got: {errors}")


if __name__ == "__main__":
    unittest.main()
