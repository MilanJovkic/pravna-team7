"""API endpoints for verdict documents."""
from fastapi import APIRouter, Depends, HTTPException, Query
from starlette.concurrency import run_in_threadpool
from typing import Optional

from backend.app.bootstrap.error_handling import map_exception_to_http
from backend.app.application.use_cases.verdict_queries import (
    GetVerdictDetailUseCase,
    GetVerdictOverrideHistoryUseCase,
    GetVerdictOverridesUseCase,
    ListVerdictsUseCase,
    SearchVerdictsUseCase,
    UpdateVerdictOverridesUseCase,
)
from backend.app.models.schemas import VerdictList, VerdictDetail, SearchResponse, VerdictOverrideUpdate
from backend.app.services.verdict_service import VerdictService

router = APIRouter()


def get_verdict_service() -> VerdictService:
    """Provide verdict service dependency."""
    return VerdictService()


def get_list_verdicts_use_case(
    service: VerdictService = Depends(get_verdict_service),
) -> ListVerdictsUseCase:
    return ListVerdictsUseCase(service)


def get_verdict_detail_use_case(
    service: VerdictService = Depends(get_verdict_service),
) -> GetVerdictDetailUseCase:
    return GetVerdictDetailUseCase(service)


def get_verdict_overrides_use_case(
    service: VerdictService = Depends(get_verdict_service),
) -> GetVerdictOverridesUseCase:
    return GetVerdictOverridesUseCase(service)


def get_update_verdict_overrides_use_case(
    service: VerdictService = Depends(get_verdict_service),
) -> UpdateVerdictOverridesUseCase:
    return UpdateVerdictOverridesUseCase(service)


def get_verdict_override_history_use_case(
    service: VerdictService = Depends(get_verdict_service),
) -> GetVerdictOverrideHistoryUseCase:
    return GetVerdictOverrideHistoryUseCase(service)


def get_search_verdicts_use_case(
    service: VerdictService = Depends(get_verdict_service),
) -> SearchVerdictsUseCase:
    return SearchVerdictsUseCase(service)


@router.get("/", response_model=VerdictList)
async def get_verdicts(
    use_case: ListVerdictsUseCase = Depends(get_list_verdicts_use_case),
):
    """Get all verdicts."""
    try:
        return await run_in_threadpool(use_case.execute)
    except Exception as e:
        raise map_exception_to_http(e)


@router.get("/{case_id}", response_model=VerdictDetail)
async def get_verdict(
    case_id: str,
    use_case: GetVerdictDetailUseCase = Depends(get_verdict_detail_use_case),
):
    """Get specific verdict details."""
    try:
        verdict = await run_in_threadpool(use_case.execute, case_id)
        if verdict is None:
            raise HTTPException(status_code=404, detail="Verdict not found")
        return verdict
    except HTTPException:
        raise
    except Exception as e:
        raise map_exception_to_http(e)


@router.get("/{case_id}/overrides")
async def get_verdict_overrides(
    case_id: str,
    use_case: GetVerdictOverridesUseCase = Depends(get_verdict_overrides_use_case),
):
    """Get manual overrides for a verdict."""
    try:
        return await run_in_threadpool(use_case.execute, case_id)
    except Exception as e:
        raise map_exception_to_http(e)


@router.put("/{case_id}/overrides")
async def update_verdict_overrides(
    case_id: str,
    payload: VerdictOverrideUpdate,
    use_case: UpdateVerdictOverridesUseCase = Depends(get_update_verdict_overrides_use_case),
):
    """Update manual overrides for a verdict."""
    try:
        data = payload.dict(exclude_unset=True)
        return await run_in_threadpool(use_case.execute, case_id, data)
    except Exception as e:
        raise map_exception_to_http(e)


@router.get("/{case_id}/overrides/history")
async def get_verdict_override_history(
    case_id: str,
    use_case: GetVerdictOverrideHistoryUseCase = Depends(get_verdict_override_history_use_case),
):
    """Get audit trail for manual override changes."""
    try:
        return await run_in_threadpool(use_case.execute, case_id)
    except Exception as e:
        raise map_exception_to_http(e)


@router.get("/search/", response_model=SearchResponse)
async def search_verdicts(
    q: str = Query(..., min_length=2),
    filter_by: Optional[str] = Query(None),
    use_case: SearchVerdictsUseCase = Depends(get_search_verdicts_use_case),
):
    """Search verdicts."""
    try:
        return await run_in_threadpool(use_case.execute, q, filter_by)
    except Exception as e:
        raise map_exception_to_http(e)
