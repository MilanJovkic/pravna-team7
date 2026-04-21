"""Application use cases for verdict queries and overrides."""
from __future__ import annotations

from typing import Any

from backend.app.bootstrap.telemetry import start_span
from backend.app.services.verdict_service import VerdictService


class ListVerdictsUseCase:
    """Return list of verdict metadata."""

    def __init__(self, service: VerdictService) -> None:
        self._service = service

    def execute(self) -> dict[str, Any]:
        verdicts = self._service.get_all_verdicts()
        return {"total": len(verdicts), "verdicts": verdicts}


class GetVerdictDetailUseCase:
    """Return single verdict details."""

    def __init__(self, service: VerdictService) -> None:
        self._service = service

    def execute(self, case_id: str):
        return self._service.get_verdict(case_id)


class GetVerdictOverridesUseCase:
    """Return manual overrides for verdict."""

    def __init__(self, service: VerdictService) -> None:
        self._service = service

    def execute(self, case_id: str) -> dict[str, Any]:
        overrides = self._service.get_overrides(case_id)
        return {"case_id": case_id, "overrides": overrides}


class UpdateVerdictOverridesUseCase:
    """Update manual overrides for verdict."""

    def __init__(self, service: VerdictService) -> None:
        self._service = service

    def execute(self, case_id: str, data: dict[str, Any]) -> dict[str, Any]:
        with start_span("update_overrides"):
            overrides = self._service.update_overrides(case_id, data)
            return {"case_id": case_id, "overrides": overrides}


class GetVerdictOverrideHistoryUseCase:
    """Return override audit trail for verdict."""

    def __init__(self, service: VerdictService) -> None:
        self._service = service

    def execute(self, case_id: str) -> dict[str, Any]:
        history = self._service.get_override_history(case_id)
        return {"case_id": case_id, "history": history}


class SearchVerdictsUseCase:
    """Search verdict metadata by query and optional filter."""

    def __init__(self, service: VerdictService) -> None:
        self._service = service

    def execute(self, query: str, filter_by: str | None) -> dict[str, Any]:
        results = self._service.search_verdicts(query, filter_by)
        return {"total_results": len(results), "results": results}
