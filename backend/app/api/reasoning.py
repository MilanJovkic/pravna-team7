"""API endpoints for combined reasoning."""
from fastapi import APIRouter, Depends
from starlette.concurrency import run_in_threadpool

from backend.app.application.services.reasoning_decision_strategies import VerdictDecisionStrategySelector
from backend.app.application.services.reasoning_input_validator import ReasoningInputValidator
from backend.app.application.use_cases.reasoning_commands import RunHybridReasoningUseCase
from backend.app.bootstrap.dependencies import provide_cbr_engine, provide_rule_engine
from backend.app.bootstrap.error_handling import map_exception_to_http
from backend.app.domain.reasoning.policies import ReasoningPolicy
from backend.app.models.schemas import ReasoningRequest, ReasoningResponse
from backend.app.ports.outbound.cbr_engine import CbrEngine
from backend.app.ports.outbound.rule_engine import RuleEngine
from backend.app.services.reasoning_explain_service import ReasoningExplainService


router = APIRouter()


def get_reasoning_use_case(
    rule_engine: RuleEngine = Depends(provide_rule_engine),
    cbr_engine: CbrEngine = Depends(provide_cbr_engine),
) -> RunHybridReasoningUseCase:
    return RunHybridReasoningUseCase(
        rule_engine=rule_engine,
        cbr_engine=cbr_engine,
        explain_service=ReasoningExplainService(),
        decision_selector=VerdictDecisionStrategySelector(),
        reasoning_policy=ReasoningPolicy(),
        input_validator=ReasoningInputValidator(),
    )


@router.post("/", response_model=ReasoningResponse)
async def run_reasoning(
    request: ReasoningRequest,
    use_case: RunHybridReasoningUseCase = Depends(get_reasoning_use_case),
):
    """Run rule-based and case-based reasoning for provided facts."""
    try:
        return await run_in_threadpool(use_case.execute, request)
    except Exception as exc:
        raise map_exception_to_http(exc)
