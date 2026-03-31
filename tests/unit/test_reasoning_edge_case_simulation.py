"""Scenario simulation tests for reasoning behavior under diverse legal fact patterns."""
from __future__ import annotations

import unittest
from dataclasses import dataclass

from backend.app.application.services.reasoning_decision_strategies import VerdictDecisionStrategySelector
from backend.app.application.use_cases.reasoning_commands import RunHybridReasoningUseCase
from backend.app.domain.reasoning.policies import ReasoningPolicy
from backend.app.models.schemas import CbrMatch, CbrResult, CaseFacts, ReasoningRequest, RuleReasoningResult


class FakeRuleEngine:
    def __init__(self, scenario_map: dict[str, RuleReasoningResult | Exception]) -> None:
        self._scenario_map = scenario_map

    def run(self, facts: CaseFacts, strict_mode: bool = True) -> RuleReasoningResult:
        result = self._scenario_map.get(facts.defendant or "", RuleReasoningResult(applied_norms=[], proofs=[]))
        if isinstance(result, Exception):
            raise result
        return result


class FakeCbrEngine:
    def __init__(self, scenario_map: dict[str, CbrResult | Exception]) -> None:
        self._scenario_map = scenario_map

    def query(self, facts: CaseFacts, top_k: int) -> CbrResult:
        result = self._scenario_map.get(facts.defendant or "", CbrResult(matches=[]))
        if isinstance(result, Exception):
            raise result
        return CbrResult(matches=result.matches[:top_k])


class FakeExplainService:
    """Small deterministic explain service used for scenario simulation tests."""

    def map_norms_to_articles(self, norms: list[str]) -> list[str]:
        articles = []
        for norm in norms:
            text = str(norm)
            if "crime_art" in text:
                part = text.split("crime_art", maxsplit=1)[1]
                article = part.split("_", maxsplit=1)[0]
                if article and article not in articles:
                    articles.append(article)
        return articles

    def get_applied_law_texts(self, article_numbers: list[str], norms: list[str] | None = None) -> list[dict]:
        _ = norms
        return [
            {
                "article_number": number,
                "title": f"Clan {number}",
                "content": f"Simulirani tekst clana {number}",
            }
            for number in article_numbers
        ]


@dataclass(frozen=True)
class Scenario:
    name: str
    facts: CaseFacts
    expected_verdict: str
    expected_basis: str
    expected_confidence: float
    expect_conflict: bool
    expected_rule_status: str
    expected_cbr_status: str


class TestReasoningEdgeCaseSimulation(unittest.TestCase):
    """Simulate legal scenarios with strong focus on edge and false-positive cases."""

    def setUp(self) -> None:
        self.scenarios = [
            Scenario(
                name="clear_light_injury_conviction",
                facts=CaseFacts(
                    defendant="S1_CLEAR_CONVICTION",
                    injury_type="laka tjelesna povreda",
                    negligence=False,
                    provocation=False,
                ),
                expected_verdict="osudjen",
                expected_basis="rule_only",
                expected_confidence=0.7,
                expect_conflict=False,
                expected_rule_status="ok",
                expected_cbr_status="ok",
            ),
            Scenario(
                name="false_positive_guard_no_norms_high_cbr_conviction",
                facts=CaseFacts(
                    defendant="S2_FALSE_POSITIVE_GUARD",
                    injury_type="neodredjeno",
                    negligence=True,
                ),
                expected_verdict="odbijeno",
                expected_basis="rule_only",
                expected_confidence=0.6,
                expect_conflict=True,
                expected_rule_status="ok",
                expected_cbr_status="ok",
            ),
            Scenario(
                name="false_negative_guard_norms_vs_cbr_rejection",
                facts=CaseFacts(
                    defendant="S3_FALSE_NEGATIVE_GUARD",
                    injury_type="teska tjelesna povreda",
                    weapon_used=True,
                    severe_consequence=True,
                ),
                expected_verdict="osudjen",
                expected_basis="rule_only",
                expected_confidence=0.7,
                expect_conflict=True,
                expected_rule_status="ok",
                expected_cbr_status="ok",
            ),
            Scenario(
                name="contradictory_facts_death_flag_without_rule_support",
                facts=CaseFacts(
                    defendant="S4_CONTRADICTORY_FACTS",
                    death_result=True,
                    injury_type="laka tjelesna povreda",
                    negligence=True,
                ),
                expected_verdict="odbijeno",
                expected_basis="rule_only",
                expected_confidence=0.6,
                expect_conflict=False,
                expected_rule_status="ok",
                expected_cbr_status="ok",
            ),
            Scenario(
                name="unknown_outcomes_only_should_not_drive_confidence_signal",
                facts=CaseFacts(
                    defendant="S5_UNKNOWN_OUTCOME_ONLY",
                    injury_type="laka tjelesna povreda",
                ),
                expected_verdict="osudjen",
                expected_basis="rule_only",
                expected_confidence=0.7,
                expect_conflict=False,
                expected_rule_status="ok",
                expected_cbr_status="ok",
            ),
            Scenario(
                name="low_similarity_cbr_ignored",
                facts=CaseFacts(
                    defendant="S6_LOW_SIMILARITY_CBR",
                    injury_type="laka tjelesna povreda",
                ),
                expected_verdict="osudjen",
                expected_basis="rule_only",
                expected_confidence=0.7,
                expect_conflict=False,
                expected_rule_status="ok",
                expected_cbr_status="ok",
            ),
            Scenario(
                name="cbr_error_fallback_to_rule_only",
                facts=CaseFacts(
                    defendant="S7_CBR_ERROR",
                    injury_type="teska tjelesna povreda",
                    weapon_used=True,
                ),
                expected_verdict="osudjen",
                expected_basis="rule_only",
                expected_confidence=0.7,
                expect_conflict=False,
                expected_rule_status="ok",
                expected_cbr_status="error",
            ),
            Scenario(
                name="rule_error_is_explicit_manual_review",
                facts=CaseFacts(
                    defendant="S8_RULE_ERROR",
                    injury_type="teska tjelesna povreda",
                    weapon_used=True,
                ),
                expected_verdict="manual_review",
                expected_basis="manual_review",
                expected_confidence=0.2,
                expect_conflict=True,
                expected_rule_status="error",
                expected_cbr_status="ok",
            ),
        ]

        self.rule_map = {
            "S1_CLEAR_CONVICTION": RuleReasoningResult(applied_norms=["crime_art152_1"], proofs=["p1"]),
            "S2_FALSE_POSITIVE_GUARD": RuleReasoningResult(applied_norms=[], proofs=[]),
            "S3_FALSE_NEGATIVE_GUARD": RuleReasoningResult(applied_norms=["crime_art151_2"], proofs=["p2"]),
            "S4_CONTRADICTORY_FACTS": RuleReasoningResult(applied_norms=[], proofs=[]),
            "S5_UNKNOWN_OUTCOME_ONLY": RuleReasoningResult(applied_norms=["crime_art152_1"], proofs=["p3"]),
            "S6_LOW_SIMILARITY_CBR": RuleReasoningResult(applied_norms=["crime_art152_1"], proofs=["p4"]),
            "S7_CBR_ERROR": RuleReasoningResult(applied_norms=["crime_art151_1"], proofs=["p5"]),
            "S8_RULE_ERROR": RuntimeError("rule engine timeout"),
        }

        self.cbr_map = {
            "S1_CLEAR_CONVICTION": CbrResult(
                matches=[
                    CbrMatch(case_number="K-1", similarity=0.82, outcome="osudjen"),
                    CbrMatch(case_number="K-2", similarity=0.77, outcome="osudjen"),
                ]
            ),
            "S2_FALSE_POSITIVE_GUARD": CbrResult(
                matches=[
                    CbrMatch(case_number="K-3", similarity=0.91, outcome="osudjen"),
                    CbrMatch(case_number="K-4", similarity=0.85, outcome="osudjen"),
                ]
            ),
            "S3_FALSE_NEGATIVE_GUARD": CbrResult(
                matches=[
                    CbrMatch(case_number="K-5", similarity=0.90, outcome="odbijeno"),
                    CbrMatch(case_number="K-6", similarity=0.84, outcome="odbijeno"),
                ]
            ),
            "S4_CONTRADICTORY_FACTS": CbrResult(matches=[]),
            "S5_UNKNOWN_OUTCOME_ONLY": CbrResult(
                matches=[
                    CbrMatch(case_number="K-7", similarity=0.88, outcome="nepoznato"),
                    CbrMatch(case_number="K-8", similarity=0.81, outcome="nepoznato"),
                ]
            ),
            "S6_LOW_SIMILARITY_CBR": CbrResult(
                matches=[
                    CbrMatch(case_number="K-9", similarity=0.49, outcome="odbijeno"),
                    CbrMatch(case_number="K-10", similarity=0.51, outcome="osudjen"),
                ]
            ),
            "S7_CBR_ERROR": RuntimeError("cbr engine unavailable"),
            "S8_RULE_ERROR": CbrResult(
                matches=[
                    CbrMatch(case_number="K-11", similarity=0.93, outcome="osudjen"),
                    CbrMatch(case_number="K-12", similarity=0.89, outcome="osudjen"),
                ]
            ),
        }

        self.use_case = RunHybridReasoningUseCase(
            rule_engine=FakeRuleEngine(self.rule_map),
            cbr_engine=FakeCbrEngine(self.cbr_map),
            explain_service=FakeExplainService(),
            decision_selector=VerdictDecisionStrategySelector(),
            reasoning_policy=ReasoningPolicy(),
        )

    def test_edge_case_simulation_matrix(self) -> None:
        simulation_rows = []

        for scenario in self.scenarios:
            with self.subTest(scenario=scenario.name):
                response = self.use_case.execute(
                    ReasoningRequest(facts=scenario.facts, top_k=5, strict_mode=True)
                )

                self.assertEqual(scenario.expected_rule_status, response.subsystem_status.get("rule"))
                self.assertEqual(scenario.expected_cbr_status, response.subsystem_status.get("cbr"))
                self.assertEqual(scenario.expected_verdict, response.suggested_verdict)
                self.assertEqual(scenario.expected_basis, response.reasoning_confidence.decision_basis)
                self.assertAlmostEqual(
                    scenario.expected_confidence,
                    response.reasoning_confidence.final_confidence,
                    places=3,
                )
                self.assertEqual(scenario.expect_conflict, response.reasoning_confidence.conflict)

                simulation_rows.append(
                    {
                        "scenario": scenario.name,
                        "verdict": response.suggested_verdict,
                        "basis": response.reasoning_confidence.decision_basis,
                        "confidence": response.reasoning_confidence.final_confidence,
                        "conflict": response.reasoning_confidence.conflict,
                        "rule": response.subsystem_status.get("rule"),
                        "cbr": response.subsystem_status.get("cbr"),
                    }
                )

        # Keep this assertion to ensure all scenarios were executed.
        self.assertEqual(len(self.scenarios), len(simulation_rows))


if __name__ == "__main__":
    unittest.main()