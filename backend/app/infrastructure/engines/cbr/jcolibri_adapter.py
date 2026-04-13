"""Infrastructure adapter for the jColibri CBR engine."""
from __future__ import annotations

import logging

from backend.app.bootstrap.telemetry import start_span
from backend.app.infrastructure.engines.policies import CircuitBreaker, ExternalEnginePolicy
from backend.app.models.schemas import CaseFacts, CbrResult
from backend.app.ports.outbound.cbr_engine import CbrEngine
from backend.app.services.cbr_service import CbrService


class JColibriCbrEngineAdapter(CbrEngine):
    """Hexagonal adapter delegating to legacy jColibri service."""

    def __init__(
        self,
        service: CbrService | None = None,
        policy: ExternalEnginePolicy | None = None,
    ) -> None:
        self._service = service or CbrService()
        self._policy = policy or ExternalEnginePolicy()
        self._breaker = CircuitBreaker(self._policy)
        self._logger = logging.getLogger(__name__)

    def sync_case_base(self) -> None:
        self._service.sync_case_base()

    def query(self, facts: CaseFacts, top_k: int) -> CbrResult:
        with start_span("cbr_query"):
            self.sync_case_base()
            self._breaker.before_call("cbr")

            last_error: Exception | None = None
            attempts = self._policy.max_retries + 1
            for attempt in range(1, attempts + 1):
                try:
                    result = self._service.query(facts=facts, top_k=top_k)
                    self._breaker.on_success()
                    return result
                except Exception as exc:
                    last_error = exc
                    self._breaker.on_failure()
                    if attempt >= attempts:
                        break
                    self._logger.warning(
                        "cbr engine call failed; retrying", extra={"attempt": attempt}
                    )

            assert last_error is not None
            raise last_error
