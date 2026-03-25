import unittest

from backend.app.services.reasoning_explain_service import ReasoningExplainService


class TestReasoningAppliedLawTextFilter(unittest.TestCase):
    def test_filters_only_selected_paragraphs_when_norms_target_subparagraphs(self):
        service = ReasoningExplainService()
        service._law_service.get_article = lambda _: {
            "number": "151",
            "title": "Clan 151",
            "content": "(1) Prvi stav.\n(2) Drugi stav.\n(3) Treci stav.",
        }

        texts = service.get_applied_law_texts(["151"], norms=["crime_art151_2"])

        self.assertEqual(1, len(texts))
        self.assertIn("(2) Drugi stav.", texts[0]["content"])
        self.assertNotIn("(1) Prvi stav.", texts[0]["content"])
        self.assertNotIn("(3) Treci stav.", texts[0]["content"])

    def test_keeps_full_article_when_no_subparagraph_is_explicit(self):
        service = ReasoningExplainService()
        content = "(1) Prvi stav.\n(2) Drugi stav."
        service._law_service.get_article = lambda _: {
            "number": "153",
            "title": "Clan 153",
            "content": content,
        }

        texts = service.get_applied_law_texts(["153"], norms=["crime_art153"])

        self.assertEqual(content, texts[0]["content"])


if __name__ == "__main__":
    unittest.main()
