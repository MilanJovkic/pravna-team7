"""Infrastructure adapter wrapping legacy legal text parser."""
from __future__ import annotations

from backend.app.infrastructure.parsers.legal_text_parser import LegalTextParser


class LegalTextParserAdapter:
    """Adapter that encapsulates legacy parser usage behind infrastructure boundary."""

    def __init__(self) -> None:
        self._parser = LegalTextParser()

    def parse(self, text: str):
        return self._parser.parse(text)

    def get_article_full_text(self, article) -> str:
        return self._parser.get_article_full_text(article)
