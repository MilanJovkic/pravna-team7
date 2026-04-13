"""Error handling and request correlation middleware."""
from __future__ import annotations

import logging
import uuid
from contextvars import ContextVar

from fastapi import FastAPI, HTTPException, Request
from fastapi.responses import JSONResponse

from backend.app.domain.shared.errors import (
    DomainError,
    ExternalServiceError,
    InfrastructureError,
    ValidationError,
)


correlation_id_ctx_var: ContextVar[str] = ContextVar("correlation_id", default="")


class CorrelationIdFilter(logging.Filter):
    """Inject correlation_id into all log records."""

    def filter(self, record: logging.LogRecord) -> bool:
        record.correlation_id = correlation_id_ctx_var.get("")
        return True


def _error_envelope(*, detail: str, status_code: int, correlation_id: str) -> dict:
    return {
        "detail": detail,
        "status_code": status_code,
        "correlation_id": correlation_id,
    }


def map_exception_to_http(exc: Exception) -> HTTPException:
    """Centralized exception taxonomy -> HTTP mapping for stable API contracts."""
    if isinstance(exc, HTTPException):
        return exc
    if isinstance(exc, ValidationError):
        return HTTPException(status_code=422, detail=str(exc))
    if isinstance(exc, (ExternalServiceError, InfrastructureError, DomainError)):
        # Keep legacy API behavior: infrastructure/external failures are surfaced as 500.
        return HTTPException(status_code=500, detail=str(exc))
    return HTTPException(status_code=500, detail=str(exc))


def configure_error_handling(app: FastAPI) -> None:
    """Install middleware and handlers with stable error envelope."""

    logger = logging.getLogger("backend.error")
    logging.getLogger().addFilter(CorrelationIdFilter())

    @app.middleware("http")
    async def correlation_middleware(request: Request, call_next):
        correlation_id = request.headers.get("X-Correlation-ID", str(uuid.uuid4()))
        token = correlation_id_ctx_var.set(correlation_id)
        request.state.correlation_id = correlation_id
        try:
            response = await call_next(request)
            response.headers["X-Correlation-ID"] = correlation_id
            return response
        finally:
            correlation_id_ctx_var.reset(token)

    @app.exception_handler(HTTPException)
    async def http_exception_handler(request: Request, exc: HTTPException):
        correlation_id = getattr(request.state, "correlation_id", "")
        if isinstance(exc.detail, str):
            detail = exc.detail
        else:
            detail = "Request failed"
        body = _error_envelope(
            detail=detail,
            status_code=exc.status_code,
            correlation_id=correlation_id,
        )
        return JSONResponse(status_code=exc.status_code, content=body)

    @app.exception_handler(DomainError)
    async def domain_error_handler(request: Request, exc: DomainError):
        correlation_id = getattr(request.state, "correlation_id", "")
        status_code = map_exception_to_http(exc).status_code

        body = _error_envelope(
            detail=str(exc),
            status_code=status_code,
            correlation_id=correlation_id,
        )
        return JSONResponse(status_code=status_code, content=body)

    @app.exception_handler(Exception)
    async def unhandled_exception_handler(request: Request, exc: Exception):
        correlation_id = getattr(request.state, "correlation_id", "")
        logger.exception("Unhandled exception", extra={"correlation_id": correlation_id})
        body = _error_envelope(
            detail="Internal server error",
            status_code=500,
            correlation_id=correlation_id,
        )
        return JSONResponse(status_code=500, content=body)
