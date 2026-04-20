"""Domain and application error hierarchy."""
from __future__ import annotations


class DomainError(Exception):
    """Base class for all domain/application controlled errors."""


class ValidationError(DomainError):
    """Input validation failure in application/domain layer."""


class ExternalServiceError(DomainError):
    """External dependency failure (CBR, rules, LLM, subprocess, HTTP)."""


class InfrastructureError(DomainError):
    """Infrastructure-level failure (storage, filesystem, DB)."""


class InfraError(InfrastructureError):
    """Alias for infrastructure failures to keep API taxonomy concise."""
