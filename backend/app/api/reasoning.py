"""API endpoints for combined reasoning."""
import logging

from fastapi import APIRouter, HTTPException

from backend.app.models.schemas import CbrResult, ReasoningRequest, ReasoningResponse, RuleReasoningResult
from backend.app.services.rule_reasoning_service import RuleReasoningService
from backend.app.services.cbr_service import CbrService
from backend.app.services.reasoning_explain_service import ReasoningExplainService


router = APIRouter()
rule_service = RuleReasoningService()
cbr_service = CbrService()
explain_service = ReasoningExplainService()
logger = logging.getLogger(__name__)


@router.post("/", response_model=ReasoningResponse)
async def run_reasoning(request: ReasoningRequest):
    """Run rule-based and case-based reasoning for provided facts."""
    subsystem_status: dict[str, str] = {}

    rule_error: str | None = None
    cbr_error: str | None = None

    try:
        rule_result = rule_service.run(request.facts, strict_mode=request.strict_mode)
        subsystem_status["rule"] = "ok"
    except Exception as exc:
        rule_error = str(exc)
        logger.exception("Rule reasoning failed")
        rule_result = RuleReasoningResult(applied_norms=[], proofs=[], strict_mode=request.strict_mode, status="error")
        subsystem_status["rule"] = "error"

    try:
        cbr_result = cbr_service.query(request.facts, request.top_k)
        subsystem_status["cbr"] = "ok"
    except Exception as exc:
        cbr_error = str(exc)
        logger.exception("CBR reasoning failed")
        cbr_result = CbrResult(matches=[])
        subsystem_status["cbr"] = "error"

    if rule_error and cbr_error:
        raise HTTPException(status_code=500, detail=f"rule_error={rule_error}; cbr_error={cbr_error}")

    applied_articles = explain_service.map_norms_to_articles(rule_result.applied_norms)
    applied_texts = explain_service.get_applied_law_texts(
        applied_articles,
        norms=rule_result.applied_norms,
    )
    suggested_verdict = explain_service.suggest_verdict(rule_result.applied_norms, cbr_result)
    suggested_sanction = explain_service.suggest_sanction(
        applied_articles,
        facts=request.facts,
        verdict=suggested_verdict,
    )
    reasoning_confidence = explain_service.build_confidence_report(
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
