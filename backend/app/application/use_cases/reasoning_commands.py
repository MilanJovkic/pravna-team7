"""Application use case for hybrid reasoning orchestration."""
from __future__ import annotations

import logging

from backend.app.bootstrap.telemetry import start_span
from backend.app.application.services.reasoning_decision_strategies import VerdictDecisionStrategySelector
from backend.app.application.services.reasoning_input_validator import ReasoningInputValidator
from backend.app.domain.reasoning.policies import ReasoningPolicy
from backend.app.domain.shared.errors import ExternalServiceError
from backend.app.models.schemas import CbrResult, ReasoningRequest, ReasoningResponse
from backend.app.ports.outbound.cbr_engine import CbrEngine
from backend.app.ports.outbound.rule_engine import RuleEngine
from backend.app.services.reasoning_explain_service import ReasoningExplainService


class RunHybridReasoningUseCase:
    """Run rule and CBR reasoning and build an explainable response."""

    def __init__(
        self,
        rule_engine: RuleEngine,
        cbr_engine: CbrEngine,
        explain_service: ReasoningExplainService,
        decision_selector: VerdictDecisionStrategySelector,
        reasoning_policy: ReasoningPolicy,
        input_validator: ReasoningInputValidator,
    ) -> None:
        self._rule_engine = rule_engine
        self._cbr_engine = cbr_engine
        self._explain_service = explain_service
        self._decision_selector = decision_selector
        self._reasoning_policy = reasoning_policy
        self._input_validator = input_validator
        self._logger = logging.getLogger(__name__)

    def execute(self, request: ReasoningRequest) -> ReasoningResponse:
        with start_span("run_reasoning"):
            self._input_validator.validate(request)

            subsystem_status: dict[str, str] = {}
            try:
                rule_result = self._rule_engine.run(request.facts, strict_mode=request.strict_mode)
                subsystem_status["rule"] = "ok"
            except Exception as exc:
                self._logger.exception("Rule reasoning failed")
                raise ExternalServiceError(f"rule_error={exc}") from exc

            try:
                cbr_result = self._cbr_engine.query(request.facts, request.top_k)
                subsystem_status["cbr"] = "ok"
            except Exception as exc:
                self._logger.exception("CBR reasoning failed")
                raise ExternalServiceError(f"cbr_error={exc}") from exc

            cbr_result = self._apply_cbr_dampening(cbr_result, request.facts)

            applied_articles = self._explain_service.map_norms_to_articles(rule_result.applied_norms)
            applied_texts = self._explain_service.get_applied_law_texts(
                applied_articles,
                norms=rule_result.applied_norms,
            )
            suggested_verdict = self._decision_selector.decide(
                rule_result.applied_norms,
                cbr_result,
                rule_available=True,
                cbr_available=True,
            )
            suggested_sanction = self._reasoning_policy.suggest_sanction(
                applied_articles,
                facts=request.facts,
                norms=rule_result.applied_norms,
                verdict=suggested_verdict,
            )
            reasoning_confidence = self._reasoning_policy.build_confidence_report(
                norms=rule_result.applied_norms,
                cbr=cbr_result,
                suggested_verdict=suggested_verdict,
                subsystem_status=subsystem_status,
            )

            return ReasoningResponse(
                rule_reasoning=rule_result,
                cbr=cbr_result,
                subsystem_status=subsystem_status,
                applied_articles=applied_articles,
                applied_law_texts=applied_texts,
                suggested_verdict=suggested_verdict,
                suggested_sanction=suggested_sanction,
                reasoning_confidence=reasoning_confidence,
            )

    def _apply_cbr_dampening(self, cbr_result: CbrResult, facts) -> CbrResult:
        key_fact_count = self._count_key_facts(facts)
        if key_fact_count >= 6:
            factor = 1.0
        elif key_fact_count >= 4:
            factor = 0.9
        elif key_fact_count >= 2:
            factor = 0.75
        else:
            factor = 0.20

        dampened_matches = []
        for match in cbr_result.matches:
            dampened_similarity = max(0.01, float(match.similarity or 0.0) * factor)
            dampened_matches.append(match.model_copy(update={"similarity": round(dampened_similarity, 4)}))

        return CbrResult(matches=dampened_matches)

    def _count_key_facts(self, facts) -> int:
        # Count only features that are actually part of the CBR retrieval model.
        key_values = [
            facts.injury_type,
            facts.location,
            facts.weapon,
            facts.weapon_used,
            facts.severe_consequence,
            facts.death_result,
            facts.negligence,
            facts.provocation,
            facts.fight_participation,
            facts.fight_consequence,
            facts.left_without_help,
        ]

        count = 0
        for value in key_values:
            if value is None:
                continue
            if isinstance(value, str) and not value.strip():
                continue
            count += 1
        return count
