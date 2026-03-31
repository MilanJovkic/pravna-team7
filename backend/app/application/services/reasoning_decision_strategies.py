"""Strategy implementations for hybrid reasoning verdict decisions."""
from __future__ import annotations

from dataclasses import dataclass
from typing import Protocol

from backend.app.models.schemas import CbrResult
from backend.app.domain.shared.outcome_normalization import normalize_outcome


@dataclass(frozen=True)
class DecisionContext:
    """Decision context shared across verdict decision strategies."""

    rule_verdict: str
    cbr_verdict: str | None
    cbr_confidence: float


class VerdictDecisionStrategy(Protocol):
    """Contract for verdict decision strategy implementations."""

    def decide(self, context: DecisionContext) -> str:
        """Return a normalized criminal verdict suggestion."""


class RuleOnlyDecisionStrategy:
    """Choose the rule-derived verdict when CBR signal is unavailable."""

    def decide(self, context: DecisionContext) -> str:
        return _normalize_criminal_outcome(context.rule_verdict)


class HybridConsensusDecisionStrategy:
    """Resolve verdict when rule and CBR agree in polarity."""

    def decide(self, context: DecisionContext) -> str:
        if context.cbr_verdict and context.cbr_confidence >= 0.75:
            return _normalize_criminal_outcome(context.cbr_verdict)
        return _normalize_criminal_outcome(context.rule_verdict)


class HybridConflictResolutionStrategy:
    """Resolve verdict when rule and CBR conflict in polarity."""

    def decide(self, context: DecisionContext) -> str:
        cbr_score = context.cbr_confidence if _is_positive(context.cbr_verdict) else -context.cbr_confidence
        rule_score = 0.65 if _is_positive(context.rule_verdict) else -0.65
        fused = normalize_outcome("osudjen" if (rule_score + cbr_score) >= 0 else "odbijeno")
        return _normalize_criminal_outcome(fused)


class CbrOnlyDecisionStrategy:
    """Choose CBR verdict directly when rule signal is explicitly unavailable."""

    def decide(self, context: DecisionContext) -> str:
        if not context.cbr_verdict:
            return _normalize_criminal_outcome(context.rule_verdict)
        return _normalize_criminal_outcome(context.cbr_verdict)


class VerdictDecisionStrategySelector:
    """Selects strategy for consensus/conflict/rule-only/cbr-only decisions."""

    def __init__(self) -> None:
        self._rule_only = RuleOnlyDecisionStrategy()
        self._cbr_only = CbrOnlyDecisionStrategy()
        self._consensus = HybridConsensusDecisionStrategy()
        self._conflict = HybridConflictResolutionStrategy()

    def decide(
        self,
        norms: list[str],
        cbr: CbrResult | None,
        rule_available: bool = True,
        cbr_available: bool = True,
    ) -> str:
        rule_verdict = normalize_outcome("osudjen" if norms else "odbijeno")
        cbr_verdict, cbr_confidence = _cbr_consensus(cbr)

        context = DecisionContext(
            rule_verdict=rule_verdict,
            cbr_verdict=cbr_verdict,
            cbr_confidence=cbr_confidence,
        )

        if not rule_available and cbr_available:
            return self._cbr_only.decide(context)
        if not cbr_verdict:
            return self._rule_only.decide(context)

        if _is_positive(rule_verdict) == _is_positive(cbr_verdict):
            return self._consensus.decide(context)
        return self._conflict.decide(context)


def _cbr_consensus(cbr: CbrResult | None) -> tuple[str | None, float]:
    if not cbr or not cbr.matches:
        return None, 0.0

    weighted_scores: dict[str, float] = {}
    total_weight = 0.0
    for match in cbr.matches[:3]:
        similarity = float(match.similarity or 0.0)
        if similarity < 0.55:
            continue
        outcome = normalize_outcome(match.outcome)
        if outcome == "nepoznato":
            continue
        weighted_scores[outcome] = weighted_scores.get(outcome, 0.0) + similarity
        total_weight += similarity

    if not weighted_scores or total_weight <= 0.0:
        return None, 0.0

    best_outcome, best_weight = max(weighted_scores.items(), key=lambda item: item[1])
    confidence = best_weight / total_weight
    return best_outcome, confidence


def _is_positive(verdict: str | None) -> bool:
    return normalize_outcome(verdict) in {"osudjen", "usvojeno"}


def _normalize_criminal_outcome(verdict: str | None) -> str:
    normalized = normalize_outcome(verdict)
    if normalized == "usvojeno":
        return "osudjen"
    if normalized == "ukinuto":
        return "odbijeno"
    return normalized
