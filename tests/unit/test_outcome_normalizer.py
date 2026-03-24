import unittest

from src.verdict_annotation.outcome_normalizer import normalize_outcome


class TestOutcomeNormalizer(unittest.TestCase):
    def test_normalizes_latin_and_cyrillic_variants(self):
        self.assertEqual(normalize_outcome("usvojeno"), "usvojeno")
        self.assertEqual(normalize_outcome("усвојено"), "usvojeno")
        self.assertEqual(normalize_outcome("усvojено"), "usvojeno")

    def test_normalizes_known_outcomes(self):
        self.assertEqual(normalize_outcome("odbijeno"), "odbijeno")
        self.assertEqual(normalize_outcome("osudjen"), "osudjen")
        self.assertEqual(normalize_outcome("oslobodjen"), "oslobodjen")

    def test_unknown_value_maps_to_nepoznato(self):
        self.assertEqual(normalize_outcome(""), "nepoznato")
        self.assertEqual(normalize_outcome("nesto-trece"), "nepoznato")


if __name__ == "__main__":
    unittest.main()
