import unittest

from backend.app.services.law_service import LawService


class _Article:
    def __init__(self, number: str, title: str, content: str):
        self.number = number
        self.title = title
        self.content = content


class _Chapter:
    def __init__(self, number: str, title: str, articles: list[_Article]):
        self.number = number
        self.title = title
        self.articles = articles


class _Parser:
    def parse(self, text: str):
        title = "ver1" if "v1" in text else "ver2"
        return [_Chapter("I", "Glava I", [_Article("151", title, f"content-{title}")])]

    def get_article_full_text(self, article: _Article) -> str:
        return article.content


class _Repo:
    def __init__(self):
        self.version = "v1"

    def get_cache_version(self) -> str:
        return self.version

    def load_law_text(self) -> str:
        return self.version

    def load_annotations(self) -> dict:
        return {"151": {"legal_concepts": ["teska povreda"]}}

    def load_xml_references(self) -> dict:
        return {}


class TestLawServiceCacheInvalidation(unittest.TestCase):
    def test_article_cache_invalidates_when_source_version_changes(self):
        repo = _Repo()
        service = LawService(repository=repo)
        service.parser = _Parser()

        first = service.get_article("151")
        self.assertEqual(first["title"], "ver1")

        repo.version = "v2"
        second = service.get_article("151")
        self.assertEqual(second["title"], "ver2")


if __name__ == "__main__":
    unittest.main()