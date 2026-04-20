"""Application use cases for case commands."""
from __future__ import annotations

from backend.app.domain.shared.errors import ValidationError
from backend.app.models.schemas import NewCaseRequest
from backend.app.services.case_service import CaseService


class CreateCaseUseCase:
    """Validate and persist a new CBR case."""

    def __init__(self, service: CaseService) -> None:
        self._service = service

    def execute(self, payload: NewCaseRequest) -> dict:
        if not payload.user_confirmation:
            raise ValidationError("Case save requires explicit user confirmation.")
        if not payload.selected_verdict:
            raise ValidationError("selected_verdict is required before case save.")
        if not payload.selected_sanction:
            raise ValidationError("selected_sanction is required before case save.")

        return self._service.insert_case(
            facts=payload.facts,
            outcome=payload.outcome or payload.selected_verdict,
            case_number=payload.case_number,
            verdict_type=payload.verdict_type or payload.selected_verdict,
            sanction=payload.sanction or payload.selected_sanction,
        )
