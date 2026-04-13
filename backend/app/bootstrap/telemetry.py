"""Telemetry helpers with optional OpenTelemetry spans and safe fallback."""

from __future__ import annotations

from contextlib import contextmanager
from time import perf_counter
import logging

from backend.app.bootstrap.error_handling import correlation_id_ctx_var

try:
    from opentelemetry import trace as ot_trace  # type: ignore
except Exception:  # pragma: no cover - optional dependency path
    ot_trace = None


LOGGER = logging.getLogger("backend.telemetry")


@contextmanager
def start_span(name: str, attributes: dict | None = None):
    """Start a telemetry span; fallback to debug timing log when OTel is unavailable."""
    attrs = dict(attributes or {})
    correlation_id = correlation_id_ctx_var.get("")
    if correlation_id:
        attrs.setdefault("correlation_id", correlation_id)

    if ot_trace is not None:
        tracer = ot_trace.get_tracer("pravna.backend")
        with tracer.start_as_current_span(name) as span:
            for key, value in attrs.items():
                span.set_attribute(key, value)
            yield
        return

    started = perf_counter()
    try:
        yield
    finally:
        elapsed_ms = (perf_counter() - started) * 1000
        LOGGER.debug("span=%s duration_ms=%.2f", name, elapsed_ms, extra={"span": name, **attrs})