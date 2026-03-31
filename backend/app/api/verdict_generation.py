"""API endpoints for generating new verdicts."""
from fastapi import APIRouter, Depends
from starlette.concurrency import run_in_threadpool

from backend.app.bootstrap.error_handling import map_exception_to_http
from backend.app.application.use_cases.verdict_generation_commands import GenerateVerdictUseCase
from backend.app.models.schemas import VerdictGenerationRequest, VerdictGenerationResponse
from backend.app.services.verdict_generation_service import VerdictGenerationService


router = APIRouter()


def get_verdict_generation_service() -> VerdictGenerationService:
    """Provide verdict generation service dependency."""
    return VerdictGenerationService()


def get_generate_verdict_use_case(
    service: VerdictGenerationService = Depends(get_verdict_generation_service),
) -> GenerateVerdictUseCase:
    return GenerateVerdictUseCase(service)


@router.post("/", response_model=VerdictGenerationResponse)
async def generate_verdict(
    payload: VerdictGenerationRequest,
    use_case: GenerateVerdictUseCase = Depends(get_generate_verdict_use_case),
):
    """Generate a new verdict using LLM, annotate, and export XML."""
    try:
        return await run_in_threadpool(use_case.execute, payload)
    except Exception as exc:
        raise map_exception_to_http(exc)
