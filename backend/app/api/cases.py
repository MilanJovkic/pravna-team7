"""API endpoints for case insertion."""
from fastapi import APIRouter, Depends
from starlette.concurrency import run_in_threadpool

from backend.app.bootstrap.error_handling import map_exception_to_http
from backend.app.application.use_cases.case_commands import CreateCaseUseCase
from backend.app.models.schemas import NewCaseRequest, NewCaseResponse
from backend.app.services.case_service import CaseService


router = APIRouter()


def get_case_service() -> CaseService:
    """Provide case service dependency."""
    return CaseService()


def get_create_case_use_case(
    service: CaseService = Depends(get_case_service),
) -> CreateCaseUseCase:
    return CreateCaseUseCase(service)


@router.post("/", response_model=NewCaseResponse)
async def create_case(
    payload: NewCaseRequest,
    use_case: CreateCaseUseCase = Depends(get_create_case_use_case),
):
    """Insert a new case into the CBR database."""
    try:
        result = await run_in_threadpool(use_case.execute, payload)
        return NewCaseResponse(**result)
    except Exception as e:
        raise map_exception_to_http(e)
