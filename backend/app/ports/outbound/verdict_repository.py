"""Outbound port for verdict document and annotation persistence."""
from __future__ import annotations

from typing import Any, Protocol


class VerdictRepository(Protocol):
    """Persistence contract for reading verdict XML artifacts and annotations."""

    def load_verdict_documents(self) -> dict[str, dict[str, Any]]:
        """Return verdict XML document map keyed by case_id."""

    def iter_verdict_documents(self):
        """Yield verdict documents as (case_id, document) for lazy processing."""

    def load_annotations(self) -> dict[str, Any]:
        """Return verdict annotations keyed by case_id."""
