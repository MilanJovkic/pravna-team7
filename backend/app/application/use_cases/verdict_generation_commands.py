"""Application use case for verdict generation command."""
from __future__ import annotations

from backend.app.bootstrap.telemetry import start_span
from backend.app.models.schemas import VerdictGenerationRequest
from backend.app.services.verdict_generation_service import VerdictGenerationService


class GenerateVerdictUseCase:
    """Generate and export a verdict from facts and reasoning context."""

    def __init__(self, service: VerdictGenerationService) -> None:
        self._service = service

    def execute(self, payload: VerdictGenerationRequest):
        with start_span("generate_verdict"):
            return self._service.generate(payload)
