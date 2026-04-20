"""Outbound port for case persistence operations."""
from __future__ import annotations

from dataclasses import dataclass
from typing import Protocol

from backend.app.models.schemas import CaseFacts


@dataclass(frozen=True)
class PersistCaseRecord:
    """Normalized persistence payload for a case record."""

    case_number: str
    facts: CaseFacts
    outcome: str | None
    verdict_type: str | None
    sanction: str | None


class CaseRepository(Protocol):
    """Persistence contract for CBR case operations."""

    def find_existing_case(
        self,
        facts: CaseFacts,
        outcome: str | None,
        verdict_type: str | None,
        sanction: str | None,
    ) -> tuple[int, str] | None:
        """Return existing case id/number if semantically identical case exists."""

    def next_version(self, facts: CaseFacts) -> int:
        """Return next version number for a normalized fact signature."""

    def insert_case(self, payload: PersistCaseRecord) -> tuple[int, str]:
        """Insert new case and return database id/case_number."""
