"""API endpoints for generating new verdicts."""
import logging
import traceback
from fastapi import APIRouter, HTTPException

from backend.app.models.schemas import VerdictGenerationRequest, VerdictGenerationResponse
from backend.app.services.verdict_generation_service import VerdictGenerationService

logger = logging.getLogger(__name__)

router = APIRouter()
generation_service = VerdictGenerationService()


@router.post("/", response_model=VerdictGenerationResponse)
async def generate_verdict(payload: VerdictGenerationRequest):
    """Generate a new verdict using LLM, annotate, and export XML."""
    try:
        logger.info(f"Starting verdict generation for case: {payload.case_number}")
        result = generation_service.generate(payload)
        logger.info(f"Verdict generation completed: {result.case_id}")
        return result
    except Exception as exc:
        logger.error(f"Verdict generation failed: {str(exc)}")
        logger.error(f"Full traceback:\n{traceback.format_exc()}")
        raise HTTPException(status_code=500, detail=str(exc))
