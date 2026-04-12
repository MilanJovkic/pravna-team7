"""API endpoints for combined reasoning."""
from fastapi import APIRouter, HTTPException

from backend.app.models.schemas import ReasoningRequest, ReasoningResponse
from backend.app.services.rule_reasoning_service import RuleReasoningService
from backend.app.services.cbr_service import CbrService
from backend.app.services.reasoning_explain_service import ReasoningExplainService


router = APIRouter()
rule_service = RuleReasoningService()
cbr_service = CbrService()
explain_service = ReasoningExplainService()


@router.post("/", response_model=ReasoningResponse)
async def run_reasoning(request: ReasoningRequest):
    """Run rule-based and case-based reasoning for provided facts."""
    try:
        rule_result = rule_service.run(request.facts)
        cbr_result = cbr_service.query(request.facts, request.top_k)
        applied_articles = explain_service.map_norms_to_articles(rule_result.applied_norms)
        applied_texts = explain_service.get_applied_law_texts(applied_articles)
        suggested_verdict = explain_service.suggest_verdict(rule_result.applied_norms, cbr_result)
        suggested_sanction = explain_service.suggest_sanction(applied_articles)
        return ReasoningResponse(
            rule_reasoning=rule_result,
            cbr=cbr_result,
            applied_articles=applied_articles,
            applied_law_texts=applied_texts,
            suggested_verdict=suggested_verdict,
            suggested_sanction=suggested_sanction,
        )
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
