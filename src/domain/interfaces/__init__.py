"""Domain interfaces following Dependency Inversion Principle (SOLID)."""

from .parsers import ILegalTextParser
from .annotators import ISemanticAnnotator
from .exporters import IDocumentExporter
from .repositories import IDocumentRepository, IAnnotationRepository

__all__ = [
    'ILegalTextParser',
    'ISemanticAnnotator',
    'IDocumentExporter',
    'IDocumentRepository',
    'IAnnotationRepository'
]
