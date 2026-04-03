"""Unit tests for reasoning decision strategies and domain policies."""
from __future__ import annotations

import unittest

from backend.app.application.services.reasoning_decision_strategies import VerdictDecisionStrategySelector
from backend.app.application.services.reasoning_input_validator import ReasoningInputValidator
from backend.app.domain.reasoning.policies import ReasoningPolicy
from backend.app.domain.shared.errors import ValidationError
from backend.app.models.schemas import CbrMatch, CbrResult, CaseFacts, ReasoningRequest


class TestReasoningDecisionStrategies(unittest.TestCase):
    """Validate rule-only verdict decision behavior."""

    def setUp(self) -> None:
        self.selector = VerdictDecisionStrategySelector()

    def test_rule_only_when_cbr_unavailable(self) -> None:
        verdict = self.selector.decide(norms=["crime_art151_1"], cbr=CbrResult(matches=[]))
        self.assertEqual("osudjen", verdict)

    def test_hybrid_consensus_prefers_high_confidence_cbr(self) -> None:
        cbr = CbrResult(matches=[CbrMatch(case_number="K-1", similarity=0.9, outcome="osudjen")])
        verdict = self.selector.decide(norms=["crime_art151_1"], cbr=cbr)
        self.assertEqual("osudjen", verdict)

    def test_conflicting_cbr_does_not_override_rule_verdict(self) -> None:
        cbr = CbrResult(matches=[CbrMatch(case_number="K-1", similarity=0.95, outcome="odbijeno")])
        verdict = self.selector.decide(norms=["crime_art151_1"], cbr=cbr)
        self.assertEqual("osudjen", verdict)


class TestReasoningPolicy(unittest.TestCase):
    """Validate confidence and sanction domain policy behavior."""

    def setUp(self) -> None:
        self.policy = ReasoningPolicy()

    def test_confidence_report_uses_manual_review_when_rule_fails(self) -> None:
        cbr = CbrResult(matches=[CbrMatch(case_number="K-1", similarity=0.8, outcome="osudjen")])
        report = self.policy.build_confidence_report(
            norms=[],
            cbr=cbr,
            suggested_verdict="osudjen",
            subsystem_status={"rule": "error", "cbr": "ok"},
        )
        self.assertEqual("manual_review", report.decision_basis)

    def test_sanction_manual_review(self) -> None:
        sanction = self.policy.suggest_sanction(article_numbers=["151"], facts=None, verdict="manual_review")
        self.assertEqual("manualna procjena sankcije", sanction)

    def test_sanction_returns_none_for_rejection(self) -> None:
        sanction = self.policy.suggest_sanction(article_numbers=["151"], facts=None, verdict="odbijeno")
        self.assertEqual("bez sankcije", sanction)

    def test_sanction_is_derived_from_applied_norm(self) -> None:
        facts = CaseFacts(death_result=True, injury_severity_level="teska")
        sanction = self.policy.suggest_sanction(
            article_numbers=["151"],
            facts=facts,
            norms=["crime_art151_3"],
            verdict="osudjen",
        )
        self.assertEqual("kazna zatvora 2 do 12 godina (predlog)", sanction)


class TestReasoningInputValidator(unittest.TestCase):
    def setUp(self) -> None:
        self.validator = ReasoningInputValidator()

    def test_sparse_facts_are_allowed(self) -> None:
        request = ReasoningRequest(facts=CaseFacts(), top_k=5, strict_mode=True)
        self.validator.validate(request)

    def test_non_physical_legal_tension_is_allowed(self) -> None:
        request = ReasoningRequest(
            facts=CaseFacts(life_consequence_type="smrt_nastupila", injury_severity_level="laka"),
            top_k=5,
            strict_mode=True,
        )
        self.validator.validate(request)

    def test_physical_absurdity_is_rejected(self) -> None:
        request = ReasoningRequest(
            facts=CaseFacts(life_consequence_type="smrt_nastupila", injury_type="nema povrede"),
            top_k=5,
            strict_mode=True,
        )
        with self.assertRaises(ValidationError):
            self.validator.validate(request)


if __name__ == "__main__":
    unittest.main()
