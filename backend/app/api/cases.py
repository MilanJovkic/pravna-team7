"""API endpoints for case insertion."""
from fastapi import APIRouter, HTTPException

from backend.app.models.schemas import NewCaseRequest, NewCaseResponse
from backend.app.services.case_service import CaseService


router = APIRouter()
case_service = CaseService()


@router.post("/", response_model=NewCaseResponse)
async def create_case(payload: NewCaseRequest):
    """Insert a new case into the CBR database."""
    if not payload.user_confirmation:
        raise HTTPException(status_code=400, detail="Case save requires explicit user confirmation.")
    if not payload.selected_verdict:
        raise HTTPException(status_code=400, detail="selected_verdict is required before case save.")
    if not payload.selected_sanction:
        raise HTTPException(status_code=400, detail="selected_sanction is required before case save.")

    try:
        result = case_service.insert_case(
            facts=payload.facts,
            outcome=payload.outcome or payload.selected_verdict,
            case_number=payload.case_number,
            verdict_type=payload.verdict_type or payload.selected_verdict,
            sanction=payload.sanction or payload.selected_sanction,
        )
        return NewCaseResponse(**result)
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
