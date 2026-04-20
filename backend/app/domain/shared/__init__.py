"""Shared domain primitives."""

from .errors import DomainError, ExternalServiceError, InfrastructureError, ValidationError
from .result import Result

__all__ = [
    "DomainError",
    "ExternalServiceError",
    "InfrastructureError",
    "ValidationError",
    "Result",
]
