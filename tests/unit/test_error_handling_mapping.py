"""Tests for centralized error taxonomy mapping and API error envelope."""
from __future__ import annotations

from fastapi import HTTPException
from fastapi.testclient import TestClient

from backend.app.bootstrap.error_handling import map_exception_to_http
from backend.app.domain.shared.errors import ExternalServiceError, InfraError, ValidationError
from backend.app.main import app


def test_map_exception_to_http_validation_error() -> None:
    exc = map_exception_to_http(ValidationError("bad input"))
    assert exc.status_code == 422
    assert exc.detail == "bad input"


def test_map_exception_to_http_external_and_infra_errors() -> None:
    ext = map_exception_to_http(ExternalServiceError("engine unavailable"))
    infra = map_exception_to_http(InfraError("disk write failed"))
    assert ext.status_code == 500
    assert infra.status_code == 500


def test_map_exception_to_http_passthrough_http_exception() -> None:
    original = HTTPException(status_code=404, detail="missing")
    mapped = map_exception_to_http(original)
    assert mapped is original


def test_map_exception_to_http_generic_exception() -> None:
    exc = map_exception_to_http(RuntimeError("boom"))
    assert exc.status_code == 500
    assert exc.detail == "boom"


def test_error_envelope_contains_correlation_id() -> None:
    client = TestClient(app)
    payload = {
        "facts": {"defendant": "Test"},
        "selected_verdict": "osudjen",
        "selected_sanction": "kazna zatvora (predlog)",
        "user_confirmation": False,
    }

    correlation_id = "test-corr-123"
    response = client.post("/api/cases/", json=payload, headers={"X-Correlation-ID": correlation_id})

    assert response.status_code == 422
    body = response.json()
    assert body["status_code"] == 422
    assert "detail" in body
    assert body["correlation_id"] == correlation_id
    assert response.headers.get("X-Correlation-ID") == correlation_id
