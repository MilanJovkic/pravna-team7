"""Service for loading and processing law documents."""
from typing import Optional

from backend.app.infrastructure.persistence.filesystem.law_repository_fs import (
    FileSystemLawRepository,
)
from backend.app.infrastructure.parsers.legal_text_parser_adapter import LegalTextParserAdapter
from backend.app.ports.outbound.law_repository import LawRepository


class LawService:
    """Service for law document operations."""

    def __init__(self, repository: LawRepository | None = None):
        self.parser = LegalTextParserAdapter()
        self.repository = repository or FileSystemLawRepository()
        self._chapters = None
        self._annotations = None
        self._xml_references = None
        self._article_cache: dict[str, dict] = {}
        self._cache_version: str | None = None

    def _refresh_cache_if_stale(self):
        """Invalidate in-memory cache when law source files change."""
        version = self.repository.get_cache_version()
        if self._cache_version is None:
            self._cache_version = version
            return
        if version != self._cache_version:
            self._cache_version = version
            self._chapters = None
            self._annotations = None
            self._xml_references = None
            self._article_cache.clear()

    def _load_law(self):
        """Load and parse law document."""
        self._refresh_cache_if_stale()
        if self._chapters is None:
            text = self.repository.load_law_text()
            self._chapters = self.parser.parse(text)
        return self._chapters

    def _load_annotations(self):
        """Load annotations if available."""
        self._refresh_cache_if_stale()
        if self._annotations is None:
            try:
                self._annotations = self.repository.load_annotations()
            except Exception:
                self._annotations = {}
        return self._annotations

    def _load_xml_references(self):
        """Load references from XML file."""
        self._refresh_cache_if_stale()
        if self._xml_references is None:
            try:
                self._xml_references = self.repository.load_xml_references()
            except Exception:
                self._xml_references = {}
                
        return self._xml_references

    def get_all_chapters(self):
        """Get all law chapters."""
        chapters = self._load_law()
        return [
            {
                "number": ch.number,
                "title": ch.title,
                "article_count": len(ch.articles)
            }
            for ch in chapters
        ]

    def get_chapter(self, chapter_number: str):
        """Get specific chapter with articles."""
        chapters = self._load_law()
        annotations = self._load_annotations()

        for chapter in chapters:
            if chapter.number == chapter_number:
                return {
                    "number": chapter.number,
                    "title": chapter.title,
                    "articles": [
                        self._format_article(art, annotations, chapter.number)
                        for art in chapter.articles
                    ]
                }
        return None

    def get_article(self, article_number: str):
        """Get specific article."""
        self._refresh_cache_if_stale()
        cached = self._article_cache.get(article_number)
        if cached is not None:
            return cached

        chapters = self._load_law()
        annotations = self._load_annotations()

        for chapter in chapters:
            for article in chapter.articles:
                if article.number == article_number:
                    formatted = self._format_article(article, annotations, chapter.number)
                    self._article_cache[article_number] = formatted
                    return formatted
        return None

    def _format_article(self, article, annotations, chapter_number: Optional[str] = None):
        """Format article with annotations."""
        content = self.parser.get_article_full_text(article)
        annotation = annotations.get(article.number, {})
        xml_references = self._load_xml_references()
        article_references = xml_references.get(article.number, [])

        return {
            "number": article.number,
            "chapter_number": chapter_number,
            "title": article.title,
            "content": content,
            "norm_type": annotation.get("norm_type"),
            "subjects": annotation.get("subjects", []),
            "legal_concepts": annotation.get("legal_concepts", []),
            "sanctions": annotation.get("sanctions"),
            "conditions": annotation.get("conditions", []),
            "references": article_references if article_references else annotation.get("references", [])
        }

    def search_articles(self, query: str):
        """Search articles by text or concept."""
        chapters = self._load_law()
        annotations = self._load_annotations()
        results = []

        query_lower = query.lower()

        for chapter in chapters:
            for article in chapter.articles:
                # Search in content
                content = self.parser.get_article_full_text(article)
                if query_lower in content.lower():
                    results.append(self._format_article(article, annotations, chapter.number))
                    continue

                # Search in concepts
                annotation = annotations.get(article.number, {})
                concepts = annotation.get("legal_concepts", [])
                if any(query_lower in c.lower() for c in concepts):
                    results.append(self._format_article(article, annotations, chapter.number))
                    continue

        return results
