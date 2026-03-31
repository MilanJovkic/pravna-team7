"""Unit tests for reasoning decision strategies and domain policies."""
from __future__ import annotations

import unittest

from backend.app.application.services.reasoning_decision_strategies import VerdictDecisionStrategySelector
from backend.app.domain.reasoning.policies import ReasoningPolicy
from backend.app.models.schemas import CbrMatch, CbrResult


class TestReasoningDecisionStrategies(unittest.TestCase):
    """Validate strategy selection for rule-only, consensus, and conflict flows."""

    def setUp(self) -> None:
        self.selector = VerdictDecisionStrategySelector()

    def test_rule_only_when_cbr_unavailable(self) -> None:
        verdict = self.selector.decide(norms=["crime_art151_1"], cbr=CbrResult(matches=[]))
        self.assertEqual("osudjen", verdict)

    def test_hybrid_consensus_prefers_high_confidence_cbr(self) -> None:
        cbr = CbrResult(matches=[CbrMatch(case_number="K-1", similarity=0.9, outcome="osudjen")])
        verdict = self.selector.decide(norms=["crime_art151_1"], cbr=cbr)
        self.assertEqual("osudjen", verdict)

    def test_hybrid_conflict_resolution_can_reject(self) -> None:
        cbr = CbrResult(matches=[CbrMatch(case_number="K-1", similarity=0.95, outcome="odbijeno")])
        verdict = self.selector.decide(norms=["crime_art151_1"], cbr=cbr)
        self.assertEqual("odbijeno", verdict)


class TestReasoningPolicy(unittest.TestCase):
    """Validate confidence and sanction domain policy behavior."""

    def setUp(self) -> None:
        self.policy = ReasoningPolicy()

    def test_confidence_report_marks_cbr_only_when_rule_fails(self) -> None:
        cbr = CbrResult(matches=[CbrMatch(case_number="K-1", similarity=0.8, outcome="osudjen")])
        report = self.policy.build_confidence_report(
            norms=[],
            cbr=cbr,
            suggested_verdict="osudjen",
            subsystem_status={"rule": "error", "cbr": "ok"},
        )
        self.assertEqual("cbr_only", report.decision_basis)

    def test_sanction_returns_none_for_rejection(self) -> None:
        sanction = self.policy.suggest_sanction(article_numbers=["151"], facts=None, verdict="odbijeno")
        self.assertEqual("bez sankcije", sanction)


if __name__ == "__main__":
    unittest.main()
