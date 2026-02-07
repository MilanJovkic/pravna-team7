"""Domain layer - core business logic."""

from .entities import (
    LegalPoint,
    LegalParagraph,
    LegalArticle,
    LegalChapter,
    LegalDocument,
    SemanticAnnotation,
    NormType,
    SanctionType
)

__all__ = [
    'LegalPoint',
    'LegalParagraph',
    'LegalArticle',
    'LegalChapter',
    'LegalDocument',
    'SemanticAnnotation',
    'NormType',
    'SanctionType'
]
