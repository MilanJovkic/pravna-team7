"""Simple Result type for explicit success/failure returns."""
from __future__ import annotations

from dataclasses import dataclass
from typing import Generic, Optional, TypeVar


T = TypeVar("T")
E = TypeVar("E", bound=Exception)


@dataclass(frozen=True)
class Result(Generic[T, E]):
    """Represents either a successful value or an error."""

    value: Optional[T] = None
    error: Optional[E] = None

    @property
    def is_ok(self) -> bool:
        return self.error is None

    @property
    def is_err(self) -> bool:
        return self.error is not None

    @staticmethod
    def ok(value: T) -> "Result[T, E]":
        return Result(value=value, error=None)

    @staticmethod
    def err(error: E) -> "Result[T, E]":
        return Result(value=None, error=error)
