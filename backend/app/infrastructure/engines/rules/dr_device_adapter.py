"""Infrastructure adapter for the dr-device rule engine."""
from __future__ import annotations

import logging

from backend.app.bootstrap.telemetry import start_span
from backend.app.models.schemas import CaseFacts, RuleReasoningResult
from backend.app.infrastructure.engines.policies import CircuitBreaker, ExternalEnginePolicy
from backend.app.ports.outbound.rule_engine import RuleEngine
from backend.app.services.rule_reasoning_service import RuleReasoningService


class DrDeviceRuleEngineAdapter(RuleEngine):
    """Hexagonal adapter delegating to legacy dr-device service."""

    def __init__(
        self,
        service: RuleReasoningService | None = None,
        policy: ExternalEnginePolicy | None = None,
    ) -> None:
        self._service = service or RuleReasoningService()
        self._policy = policy or ExternalEnginePolicy()
        self._breaker = CircuitBreaker(self._policy)
        self._logger = logging.getLogger(__name__)

    def run(self, facts: CaseFacts, strict_mode: bool = True) -> RuleReasoningResult:
        with start_span("rule_run"):
            self._breaker.before_call("rule")

            last_error: Exception | None = None
            attempts = self._policy.max_retries + 1
            for attempt in range(1, attempts + 1):
                try:
                    result = self._service.run(facts=facts, strict_mode=strict_mode)
                    self._breaker.on_success()
                    return result
                except Exception as exc:
                    last_error = exc
                    self._breaker.on_failure()
                    if attempt >= attempts:
                        break
                    self._logger.warning(
                        "rule engine call failed; retrying", extra={"attempt": attempt}
                    )

            assert last_error is not None
            raise last_error
