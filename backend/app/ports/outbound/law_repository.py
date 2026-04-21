"""Outbound port for law document persistence operations."""
from __future__ import annotations

from typing import Any, Protocol


class LawRepository(Protocol):
    """Persistence contract for law text/annotation/reference sources."""

    def load_law_text(self) -> str:
        """Return raw law text used by parser."""

    def load_annotations(self) -> dict[str, Any]:
        """Return annotation map keyed by article number."""

    def load_xml_references(self) -> dict[str, list[dict[str, Any]]]:
        """Return extracted references keyed by article number."""

    def get_cache_version(self) -> str:
        """Return deterministic source version used for cache invalidation."""
