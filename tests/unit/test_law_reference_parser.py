import unittest

from src.akoma_annotation.references import (
    canonical_article_href,
    canonical_paragraph_href,
    parse_reference_href,
)


class TestLawReferenceParser(unittest.TestCase):
    def test_canonical_article_href(self):
        self.assertEqual(canonical_article_href("144"), "#art_144")
        self.assertEqual(canonical_article_href("  144A "), "#art_144a")

    def test_canonical_paragraph_href(self):
        self.assertEqual(canonical_paragraph_href("144", "2"), "#art_144__para_2")

    def test_parse_internal_article_href(self):
        parsed = parse_reference_href("#art_145")
        self.assertEqual(parsed["kind"], "internal_article")
        self.assertEqual(parsed["article_number"], "145")
        self.assertEqual(parsed["normalized_href"], "#art_145")

    def test_parse_internal_paragraph_href(self):
        parsed = parse_reference_href("art_145__para_3")
        self.assertEqual(parsed["kind"], "internal_paragraph")
        self.assertEqual(parsed["article_number"], "145")
        self.assertEqual(parsed["paragraph_number"], "3")
        self.assertEqual(parsed["normalized_href"], "#art_145__para_3")

    def test_parse_external_law_href(self):
        parsed = parse_reference_href("/akn/me/act/2024/!main")
        self.assertEqual(parsed["kind"], "external_law")

    def test_parse_unknown_href(self):
        parsed = parse_reference_href("http://example.com/law")
        self.assertEqual(parsed["kind"], "unknown")


if __name__ == "__main__":
    unittest.main()
