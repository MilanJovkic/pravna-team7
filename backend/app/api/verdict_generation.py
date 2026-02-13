"""API endpoints for generating new verdicts."""
from fastapi import APIRouter, HTTPException

from backend.app.models.schemas import VerdictGenerationRequest, VerdictGenerationResponse
from backend.app.services.verdict_generation_service import VerdictGenerationService


router = APIRouter()
generation_service = VerdictGenerationService()


@router.post("/", response_model=VerdictGenerationResponse)
async def generate_verdict(payload: VerdictGenerationRequest):
    """Generate a new verdict using LLM, annotate, and export XML."""
    try:
        return generation_service.generate(payload)
    except Exception as exc:
        raise HTTPException(status_code=500, detail=str(exc))
