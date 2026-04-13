"""Resilience policies for external reasoning engines."""
from __future__ import annotations

import time
from dataclasses import dataclass


class CircuitOpenError(RuntimeError):
    """Raised when the circuit breaker is open and calls are blocked."""


@dataclass(frozen=True)
class ExternalEnginePolicy:
    """Configurable retry and circuit-breaker thresholds per subsystem."""

    max_retries: int = 1
    open_after_failures: int = 3
    reset_timeout_seconds: float = 30.0


class CircuitBreaker:
    """Small in-process circuit breaker for external engine calls."""

    def __init__(self, policy: ExternalEnginePolicy) -> None:
        self._policy = policy
        self._failures = 0
        self._opened_until = 0.0

    def before_call(self, subsystem: str) -> None:
        now = time.monotonic()
        if self._opened_until > now:
            remaining = self._opened_until - now
            raise CircuitOpenError(
                f"{subsystem} circuit is open; retry in {remaining:.1f}s"
            )
        if self._opened_until and self._opened_until <= now:
            self._opened_until = 0.0
            self._failures = 0

    def on_success(self) -> None:
        self._failures = 0
        self._opened_until = 0.0

    def on_failure(self) -> None:
        self._failures += 1
        if self._failures >= self._policy.open_after_failures:
            self._opened_until = time.monotonic() + self._policy.reset_timeout_seconds
