"""API endpoints for verdict documents."""
from fastapi import APIRouter, HTTPException, Query
from typing import Optional
from backend.app.models.schemas import VerdictList, VerdictDetail, SearchResponse, VerdictOverrideUpdate
from backend.app.services.verdict_service import VerdictService

router = APIRouter()
verdict_service = VerdictService()


@router.get("/", response_model=VerdictList)
async def get_verdicts():
    """Get all verdicts."""
    try:
        verdicts = verdict_service.get_all_verdicts()
        return {"total": len(verdicts), "verdicts": verdicts}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/{case_id}", response_model=VerdictDetail)
async def get_verdict(case_id: str):
    """Get specific verdict details."""
    try:
        verdict = verdict_service.get_verdict(case_id)
        if verdict is None:
            raise HTTPException(status_code=404, detail="Verdict not found")
        return verdict
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/{case_id}/overrides")
async def get_verdict_overrides(case_id: str):
    """Get manual overrides for a verdict."""
    try:
        overrides = verdict_service.get_overrides(case_id)
        return {"case_id": case_id, "overrides": overrides}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.put("/{case_id}/overrides")
async def update_verdict_overrides(case_id: str, payload: VerdictOverrideUpdate):
    """Update manual overrides for a verdict."""
    try:
        data = payload.dict(exclude_unset=True)
        overrides = verdict_service.update_overrides(case_id, data)
        return {"case_id": case_id, "overrides": overrides}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/search/", response_model=SearchResponse)
async def search_verdicts(
    q: str = Query(..., min_length=2),
    filter_by: Optional[str] = Query(None)
):
    """Search verdicts."""
    try:
        results = verdict_service.search_verdicts(q, filter_by)
        return {"total_results": len(results), "results": results}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
