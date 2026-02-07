"""Domain entities for legal document processing."""

from .legal_document import (
    LegalPoint,
    LegalParagraph,
    LegalArticle,
    LegalChapter,
    LegalDocument
)
from .annotation import (
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
