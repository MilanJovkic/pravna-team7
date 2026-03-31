import unittest

from backend.app.services.law_service import LawService


class _FakeArticle:
    def __init__(self, number: str, title: str):
        self.number = number
        self.title = title


class _FakeChapter:
    def __init__(self, number: str, title: str, articles):
        self.number = number
        self.title = title
        self.articles = articles


class _FakeParser:
    def parse(self, _text: str):
        return [_FakeChapter("I", "Opste odredbe", [_FakeArticle("1", "Naziv")])]

    def get_article_full_text(self, article):
        return f"Sadrzaj {article.number}"


class _FakeRepository:
    def get_cache_version(self) -> str:
        return "v1"

    def load_law_text(self):
        return "dummy"

    def load_annotations(self):
        return {
            "1": {
                "norm_type": "obavezujuca",
                "subjects": ["gradjani"],
                "legal_concepts": ["krivicno delo"],
            }
        }

    def load_xml_references(self):
        return {
            "1": [
                {
                    "href": "#art_2",
                    "text": "član 2",
                    "normalized_href": "art_2",
                    "reference_kind": "article",
                    "target_article": "2",
                    "target_paragraph": None,
                    "target_point": None,
                }
            ]
        }


class TestLawServiceRepositoryPort(unittest.TestCase):
    def test_law_service_reads_from_repository_port(self):
        service = LawService(repository=_FakeRepository())
        service.parser = _FakeParser()

        chapters = service.get_all_chapters()
        article = service.get_article("1")

        self.assertEqual(len(chapters), 1)
        self.assertEqual(chapters[0]["number"], "I")
        self.assertEqual(article["number"], "1")
        self.assertEqual(article["norm_type"], "obavezujuca")
        self.assertEqual(article["references"][0]["target_article"], "2")


if __name__ == "__main__":
    unittest.main()
