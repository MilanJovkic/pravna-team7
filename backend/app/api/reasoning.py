"""API endpoints for combined reasoning."""
import logging

from fastapi import APIRouter, Depends
from starlette.concurrency import run_in_threadpool

from backend.app.bootstrap.dependencies import provide_cbr_engine, provide_rule_engine
from backend.app.bootstrap.error_handling import map_exception_to_http
from backend.app.application.services.reasoning_decision_strategies import VerdictDecisionStrategySelector
from backend.app.application.services.reasoning_input_validator import ReasoningInputValidator
from backend.app.application.use_cases.reasoning_commands import RunHybridReasoningUseCase
from backend.app.domain.reasoning.policies import ReasoningPolicy
from backend.app.models.schemas import ReasoningRequest, ReasoningResponse
from backend.app.ports.outbound.cbr_engine import CbrEngine
from backend.app.ports.outbound.rule_engine import RuleEngine
from backend.app.services.reasoning_explain_service import ReasoningExplainService


router = APIRouter()
logger = logging.getLogger(__name__)


def get_rule_reasoning_service() -> RuleEngine:
    """Provide rule reasoning engine dependency (legacy provider name preserved)."""
    return provide_rule_engine()


def get_cbr_service() -> CbrEngine:
    """Provide CBR engine dependency (legacy provider name preserved)."""
    return provide_cbr_engine()


def get_reasoning_explain_service() -> ReasoningExplainService:
    """Provide reasoning explain service dependency."""
    return ReasoningExplainService()


def get_reasoning_decision_selector() -> VerdictDecisionStrategySelector:
    """Provide hybrid verdict strategy selector dependency."""
    return VerdictDecisionStrategySelector()


def get_reasoning_policy() -> ReasoningPolicy:
    """Provide domain reasoning policy dependency."""
    return ReasoningPolicy()


def get_reasoning_input_validator() -> ReasoningInputValidator:
    """Provide pre-reasoning validator dependency."""
    return ReasoningInputValidator()


def get_run_hybrid_reasoning_use_case(
    rule_engine: RuleEngine = Depends(get_rule_reasoning_service),
    cbr_engine: CbrEngine = Depends(get_cbr_service),
    explain_service: ReasoningExplainService = Depends(get_reasoning_explain_service),
    decision_selector: VerdictDecisionStrategySelector = Depends(get_reasoning_decision_selector),
    reasoning_policy: ReasoningPolicy = Depends(get_reasoning_policy),
    input_validator: ReasoningInputValidator = Depends(get_reasoning_input_validator),
) -> RunHybridReasoningUseCase:
    return RunHybridReasoningUseCase(
        rule_engine=rule_engine,
        cbr_engine=cbr_engine,
        explain_service=explain_service,
        decision_selector=decision_selector,
        reasoning_policy=reasoning_policy,
        input_validator=input_validator,
    )


@router.post("/", response_model=ReasoningResponse)
async def run_reasoning(
    request: ReasoningRequest,
    use_case: RunHybridReasoningUseCase = Depends(get_run_hybrid_reasoning_use_case),
):
    """Run rule-based and case-based reasoning for provided facts."""
    try:
        facts_payload = request.facts.model_dump(mode="python")
        logger.info("[Reasoning][Backend] Request facts: %s", facts_payload)
        logger.info(
            "[Reasoning][Backend] Focus 153/154: defendant=%s fight_participation=%s injury_type=%s weapon_used=%s injury_means_type=%s death_result=%s",
            request.facts.defendant,
            request.facts.fight_participation,
            request.facts.injury_type,
            request.facts.weapon_used,
            request.facts.injury_means_type,
            request.facts.death_result,
        )
        print("[Reasoning][Backend] Request facts:", facts_payload, flush=True)
        print(
            "[Reasoning][Backend] Focus 153/154:",
            {
                "defendant": request.facts.defendant,
                "fight_participation": request.facts.fight_participation,
                "injury_type": request.facts.injury_type,
                "weapon_used": request.facts.weapon_used,
                "injury_means_type": request.facts.injury_means_type,
                "death_result": request.facts.death_result,
            },
            flush=True,
        )
        return await run_in_threadpool(use_case.execute, request)
    except Exception as exc:
        raise map_exception_to_http(exc)
