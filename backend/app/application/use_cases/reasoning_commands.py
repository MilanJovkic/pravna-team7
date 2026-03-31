"""Application use case for hybrid reasoning orchestration."""
from __future__ import annotations

import logging

from backend.app.bootstrap.telemetry import start_span
from backend.app.application.services.reasoning_decision_strategies import VerdictDecisionStrategySelector
from backend.app.domain.reasoning.policies import ReasoningPolicy
from backend.app.domain.shared.errors import ExternalServiceError
from backend.app.models.schemas import CbrResult, ReasoningRequest, ReasoningResponse, RuleReasoningResult
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
    ) -> None:
        self._rule_engine = rule_engine
        self._cbr_engine = cbr_engine
        self._explain_service = explain_service
        self._decision_selector = decision_selector
        self._reasoning_policy = reasoning_policy
        self._logger = logging.getLogger(__name__)

    def execute(self, request: ReasoningRequest) -> ReasoningResponse:
        with start_span("run_reasoning"):
            subsystem_status: dict[str, str] = {}

            rule_error: str | None = None
            cbr_error: str | None = None

            try:
                rule_result = self._rule_engine.run(request.facts, strict_mode=request.strict_mode)
                subsystem_status["rule"] = "ok"
            except Exception as exc:
                rule_error = str(exc)
                self._logger.exception("Rule reasoning failed")
                rule_result = RuleReasoningResult(
                    applied_norms=[],
                    proofs=[],
                    strict_mode=request.strict_mode,
                    status="error",
                )
                subsystem_status["rule"] = "error"

            try:
                cbr_result = self._cbr_engine.query(request.facts, request.top_k)
                subsystem_status["cbr"] = "ok"
            except Exception as exc:
                cbr_error = str(exc)
                self._logger.exception("CBR reasoning failed")
                cbr_result = CbrResult(matches=[])
                subsystem_status["cbr"] = "error"

            if rule_error and cbr_error:
                raise ExternalServiceError(f"rule_error={rule_error}; cbr_error={cbr_error}")

            applied_articles = self._explain_service.map_norms_to_articles(rule_result.applied_norms)
            applied_texts = self._explain_service.get_applied_law_texts(
                applied_articles,
                norms=rule_result.applied_norms,
            )
            if subsystem_status.get("rule") == "error":
                suggested_verdict = "manual_review"
            else:
                suggested_verdict = self._decision_selector.decide(
                    rule_result.applied_norms,
                    cbr_result,
                    rule_available=subsystem_status.get("rule") != "error",
                    cbr_available=subsystem_status.get("cbr") != "error",
                )
            suggested_sanction = self._reasoning_policy.suggest_sanction(
                applied_articles,
                facts=request.facts,
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
