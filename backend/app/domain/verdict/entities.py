"""Canonical verdict domain entities and value objects."""
from __future__ import annotations

from dataclasses import dataclass, field
from typing import List, Optional


@dataclass(frozen=True)
class CaseNumber:
    """Value object for case number identity."""

    value: str

    def __post_init__(self) -> None:
        if not self.value or not self.value.strip():
            raise ValueError("CaseNumber must not be empty")


@dataclass(frozen=True)
class ArticleReference:
    """Value object for article references."""

    value: str

    def __post_init__(self) -> None:
        if not self.value or not self.value.strip():
            raise ValueError("ArticleReference must not be empty")


@dataclass(frozen=True)
class ConfidenceScore:
    """Value object for confidence score in range [0, 1]."""

    value: float

    def __post_init__(self) -> None:
        if self.value < 0.0 or self.value > 1.0:
            raise ValueError("ConfidenceScore must be in range [0, 1]")


@dataclass(frozen=True)
class Outcome:
    """Value object representing normalized case outcome."""

    value: str

    def __post_init__(self) -> None:
        if not self.value or not self.value.strip():
            raise ValueError("Outcome must not be empty")


@dataclass
class VerdictMetadata:
    """Metadata extracted from or used for verdict generation."""

    case_number: Optional[str] = None
    court_name: Optional[str] = None
    date: Optional[str] = None
    judges: List[str] = field(default_factory=list)
    parties: dict[str, List[str]] = field(default_factory=dict)
    organizations: List[str] = field(default_factory=list)
    legal_references: List[str] = field(default_factory=list)
    article_references: List[str] = field(default_factory=list)
    verdict_type: Optional[str] = None
    factual_state: dict[str, List[str]] = field(default_factory=dict)
    raw_text: str = ""
