"""Outbound port for CBR engine integration."""
from __future__ import annotations

from typing import Protocol

from backend.app.models.schemas import CaseFacts, CbrResult


class CbrEngine(Protocol):
    """Contract for running case-based retrieval and similarity ranking."""

    def sync_case_base(self) -> None:
        """Ensure case base is initialized/synchronized before retrieval."""

    def query(self, facts: CaseFacts, top_k: int) -> CbrResult:
        """Execute retrieval and return ranked CBR matches."""
