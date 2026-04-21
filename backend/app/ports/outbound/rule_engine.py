"""Outbound port for rule reasoning engine integration."""
from __future__ import annotations

from typing import Protocol

from backend.app.models.schemas import CaseFacts, RuleReasoningResult


class RuleEngine(Protocol):
    """Contract for executing rule-based reasoning over case facts."""

    def run(self, facts: CaseFacts, strict_mode: bool = True) -> RuleReasoningResult:
        """Execute reasoning and return applied norms/proofs."""
