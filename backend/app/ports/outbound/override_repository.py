"""Outbound port for verdict override and audit persistence."""
from __future__ import annotations

from typing import Any, Protocol


class OptimisticLockConflictError(Exception):
    """Raised when expected revision no longer matches current file revision."""


class OverrideRepository(Protocol):
    """Persistence contract for overrides and override audit history."""

    @property
    def overrides_file_path(self) -> str:
        """Absolute overrides file path."""

    @property
    def audit_file_path(self) -> str:
        """Absolute override audit file path."""

    def load_overrides(self) -> tuple[dict[str, Any], str]:
        """Return overrides map and current revision token."""

    def save_overrides(self, data: dict[str, Any], expected_revision: str) -> str:
        """Persist overrides map with optimistic lock and return new revision token."""

    def load_audit(self) -> tuple[dict[str, Any], str]:
        """Return audit map and current revision token."""

    def save_audit(self, data: dict[str, Any], expected_revision: str) -> str:
        """Persist audit map with optimistic lock and return new revision token."""
