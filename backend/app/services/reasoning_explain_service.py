"""Service for mapping norms to law texts and suggesting outcomes."""
from __future__ import annotations

import json
import re
from pathlib import Path

from backend.app.models.schemas import CbrResult
from backend.app.services.law_service import LawService


ROOT = Path(__file__).resolve().parents[3]
DEFAULT_MAP_PATH = ROOT / "backend" / "app" / "resources" / "norms_to_articles.json"


class ReasoningExplainService:
    """Builds explanations and suggestions from reasoning results."""

    def __init__(self, map_path: Path | None = None):
        self.map_path = map_path or DEFAULT_MAP_PATH
        self._mapping = None
        self._law_service = LawService()

    def map_norms_to_articles(self, norms: list[str]) -> list[str]:
        mapping = self._load_mapping()
        articles = []
        for norm in norms:
            article = mapping.get(norm)
            if not article:
                article = self._infer_article(norm)
            if article and article not in articles:
                articles.append(article)
        return articles

    def get_applied_law_texts(self, article_numbers: list[str]) -> list[dict]:
        texts = []
        for number in article_numbers:
            article = self._law_service.get_article(number)
            if not article:
                continue
            texts.append(
                {
                    "article_number": article["number"],
                    "title": article.get("title"),
                    "content": article.get("content"),
                }
            )
        return texts

    def suggest_verdict(self, norms: list[str], cbr: CbrResult | None) -> str | None:
        if cbr and cbr.matches:
            top = cbr.matches[0]
            if top.outcome:
                return top.outcome
        if norms:
            return "osudjen"
        return "odbijeno"

    def suggest_sanction(self, article_numbers: list[str]) -> str | None:
        if not article_numbers:
            return "bez sankcije"
        return "kazna zatvora (predlog)"

    def _load_mapping(self) -> dict:
        if self._mapping is None:
            if self.map_path.exists():
                self._mapping = json.loads(self.map_path.read_text(encoding="utf-8"))
            else:
                self._mapping = {}
        return self._mapping

    def _infer_article(self, norm: str) -> str | None:
        match = re.search(r"crime_art(\d+[a-z]?)", norm, re.IGNORECASE)
        if not match:
            return None
        return match.group(1)
