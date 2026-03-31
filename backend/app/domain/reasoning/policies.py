"""Domain policies for reasoning confidence and sanction suggestions."""
from __future__ import annotations

from backend.app.models.schemas import CbrResult, ReasoningConfidence
from backend.app.domain.shared.outcome_normalization import normalize_outcome


class ReasoningPolicy:
    """Domain policy module for confidence and sanction heuristics."""

    def build_confidence_report(
        self,
        norms: list[str],
        cbr: CbrResult | None,
        suggested_verdict: str | None,
        subsystem_status: dict[str, str] | None = None,
    ) -> ReasoningConfidence:
        _ = suggested_verdict
        cbr_verdict, cbr_confidence = self._cbr_consensus(cbr)
        top_similarity = 0.0
        if cbr and cbr.matches:
            top_similarity = max(float(match.similarity or 0.0) for match in cbr.matches)

        rule_signal = "supports_conviction" if norms else "supports_rejection"
        cbr_signal = "unavailable"
        if cbr_verdict:
            cbr_signal = "supports_conviction" if self._is_positive(cbr_verdict) else "supports_rejection"

        conflict = cbr_signal != "unavailable" and cbr_signal != rule_signal

        decision_basis = "rule_only"
        final_confidence = 0.7 if norms else 0.6
        if cbr_signal != "unavailable":
            if conflict:
                decision_basis = "hybrid_conflict_resolution"
                final_confidence = max(0.55, min(0.88, 0.55 + (cbr_confidence * 0.25)))
            else:
                decision_basis = "hybrid_consensus"
                final_confidence = max(0.65, min(0.95, 0.65 + (cbr_confidence * 0.30)))

        if subsystem_status and subsystem_status.get("cbr") == "error":
            cbr_signal = "unavailable"
            cbr_confidence = 0.0
            top_similarity = 0.0
            decision_basis = "rule_only"

        if subsystem_status and subsystem_status.get("rule") == "error":
            rule_signal = "unavailable"
            if cbr_signal != "unavailable":
                decision_basis = "cbr_only"
                final_confidence = max(0.55, min(0.9, cbr_confidence))

        return ReasoningConfidence(
            decision_basis=decision_basis,
            final_confidence=round(final_confidence, 3),
            rule_signal=rule_signal,
            cbr_signal=cbr_signal,
            cbr_confidence=round(cbr_confidence, 3),
            cbr_top_similarity=round(top_similarity, 3),
            conflict=conflict,
        )

    def suggest_sanction(
        self,
        article_numbers: list[str],
        facts,
        verdict: str | None = None,
    ) -> str | None:
        normalized_verdict = normalize_outcome(verdict)
        if normalized_verdict in {"odbijeno", "oslobodjen", "nepoznato"}:
            return "bez sankcije"

        if not article_numbers:
            return "bez sankcije"

        article_set = {str(item).strip() for item in article_numbers if str(item).strip()}
        has_151 = "151" in article_set
        has_152 = "152" in article_set

        if facts and facts.death_result:
            return "kazna zatvora 3 do 12 godina (predlog)"

        if facts and facts.severe_consequence and facts.weapon_used:
            return "kazna zatvora 1 do 8 godina (predlog)"

        if has_151 or (facts and facts.severe_consequence):
            return "kazna zatvora 6 meseci do 5 godina (predlog)"

        if has_152 or (facts and facts.injury_type and "laka" in facts.injury_type.lower()):
            return "novcana kazna ili zatvor do 1 godine (predlog)"

        if facts and facts.negligence:
            return "uslovna osuda ili novcana kazna (predlog)"

        return "kazna zatvora (predlog)"

    def _cbr_consensus(self, cbr: CbrResult | None) -> tuple[str | None, float]:
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
        return best_outcome, (best_weight / total_weight)

    def _is_positive(self, verdict: str) -> bool:
        return normalize_outcome(verdict) in {"osudjen", "usvojeno"}
