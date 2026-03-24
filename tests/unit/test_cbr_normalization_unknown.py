import unittest

from backend.app.services.cbr_normalization import parse_bool


class TestCbrNormalizationUnknown(unittest.TestCase):
    def test_parse_bool_keeps_unknown(self):
        self.assertIsNone(parse_bool(None))
        self.assertIsNone(parse_bool("unknown"))
        self.assertIsNone(parse_bool("n/a"))

    def test_parse_bool_recognizes_values(self):
        self.assertTrue(parse_bool("true"))
        self.assertTrue(parse_bool("da"))
        self.assertFalse(parse_bool("false"))
        self.assertFalse(parse_bool("ne"))


if __name__ == "__main__":
    unittest.main()
