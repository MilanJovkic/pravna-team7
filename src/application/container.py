"""
Dependency injection container.

Follows Dependency Inversion Principle - provides all dependencies.
"""

from ..config.app_config import ApplicationConfig
from ..domain.interfaces.parsers import ILegalTextParser
from ..domain.interfaces.annotators import ISemanticAnnotator
from ..domain.interfaces.exporters import IDocumentExporter
from ..infrastructure.parsers import RegexLegalTextParser
from ..infrastructure.llm import LLMSemanticAnnotator
from ..infrastructure.exporters import AkomaNtosoExporter
from ..application.use_cases import AnnotateLegalDocumentUseCase


class DependencyContainer:
    """
    Dependency injection container.
    
    Creates and manages all application dependencies.
    Follows Inversion of Control (IoC) pattern.
    """
    
    def __init__(self, config: ApplicationConfig):
        """
        Initialize container with configuration.
        
        Args:
            config: Application configuration
        """
        self.config = config
        self._parser: ILegalTextParser = None
        self._annotator: ISemanticAnnotator = None
        self._exporter: IDocumentExporter = None
    
    def get_parser(self) -> ILegalTextParser:
        """
        Get parser instance (singleton).
        
        Returns:
            ILegalTextParser implementation
        """
        if self._parser is None:
            self._parser = RegexLegalTextParser()
        return self._parser
    
    def get_annotator(self) -> ISemanticAnnotator:
        """
        Get annotator instance (singleton).
        
        Returns:
            ISemanticAnnotator implementation
        """
        if self._annotator is None:
            self._annotator = LLMSemanticAnnotator(
                provider=self.config.llm.provider,
                model=self.config.llm.model,
                api_token=self.config.llm.api_token,
                max_requests_per_minute=self.config.llm.max_requests_per_minute,
                max_retries=self.config.llm.max_retries
            )
        return self._annotator
    
    def get_exporter(self) -> IDocumentExporter:
        """
        Get exporter instance (singleton).
        
        Returns:
            IDocumentExporter implementation
        """
        if self._exporter is None:
            self._exporter = AkomaNtosoExporter(
                law_name=self.config.exporter.law_name,
                country_code=self.config.exporter.country_code,
                law_year=self.config.exporter.law_year
            )
        return self._exporter
    
    def get_annotate_document_use_case(self) -> AnnotateLegalDocumentUseCase:
        """
        Get annotate document use case.
        
        Returns:
            AnnotateLegalDocumentUseCase instance
        """
        return AnnotateLegalDocumentUseCase(
            parser=self.get_parser(),
            annotator=self.get_annotator(),
            exporter=self.get_exporter()
        )
