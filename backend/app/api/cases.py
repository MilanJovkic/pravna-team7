"""API endpoints for case insertion."""
from fastapi import APIRouter, HTTPException

from backend.app.models.schemas import NewCaseRequest, NewCaseResponse
from backend.app.services.case_service import CaseService


router = APIRouter()
case_service = CaseService()


@router.post("/", response_model=NewCaseResponse)
async def create_case(payload: NewCaseRequest):
    """Insert a new case into the CBR database."""
    try:
        result = case_service.insert_case(
            facts=payload.facts,
            outcome=payload.outcome,
            case_number=payload.case_number,
        )
        return NewCaseResponse(**result)
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
