"""Application use cases for law queries."""
from __future__ import annotations

from typing import Any

from backend.app.services.law_service import LawService


class GetLawChaptersUseCase:
    """Return chapter summaries for the law document."""

    def __init__(self, service: LawService) -> None:
        self._service = service

    def execute(self) -> dict[str, Any]:
        chapters = self._service.get_all_chapters()
        return {"chapters": chapters, "total": len(chapters)}


class GetLawChapterUseCase:
    """Return one chapter with its articles."""

    def __init__(self, service: LawService) -> None:
        self._service = service

    def execute(self, chapter_number: str):
        return self._service.get_chapter(chapter_number)


class GetLawArticleUseCase:
    """Return one law article by article number."""

    def __init__(self, service: LawService) -> None:
        self._service = service

    def execute(self, article_number: str):
        return self._service.get_article(article_number)


class SearchLawArticlesUseCase:
    """Search law articles by free-text query."""

    def __init__(self, service: LawService) -> None:
        self._service = service

    def execute(self, query: str) -> dict[str, Any]:
        results = self._service.search_articles(query)
        return {"total": len(results), "results": results}
