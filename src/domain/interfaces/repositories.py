"""Interfaces for data repositories."""

from abc import ABC, abstractmethod
from typing import List, Optional, Dict
from ..entities.legal_document import LegalDocument, LegalArticle
from ..entities.annotation import SemanticAnnotation


class IDocumentRepository(ABC):
    """
    Interface for legal document persistence.
    
    Follows Repository Pattern and Dependency Inversion Principle.
    Implementations can use different storage mechanisms (files, databases, etc.).
    """
    
    @abstractmethod
    def save(self, document: LegalDocument) -> bool:
        """
        Save legal document.
        
        Args:
            document: Document to save
            
        Returns:
            True if successful
        """
        pass
    
    @abstractmethod
    def load(self, document_name: str) -> Optional[LegalDocument]:
        """
        Load legal document by name.
        
        Args:
            document_name: Name of document to load
            
        Returns:
            LegalDocument or None if not found
        """
        pass
    
    @abstractmethod
    def find_article(self, article_number: str) -> Optional[LegalArticle]:
        """
        Find article by number across all documents.
        
        Args:
            article_number: Article number to find
            
        Returns:
            LegalArticle or None if not found
        """
        pass
    
    @abstractmethod
    def list_all(self) -> List[str]:
        """
        List all available document names.
        
        Returns:
            List of document names
        """
        pass


class IAnnotationRepository(ABC):
    """
    Interface for annotation persistence.
    
    Follows Single Responsibility Principle - handles only annotations.
    """
    
    @abstractmethod
    def save(self, annotations: Dict[str, SemanticAnnotation]) -> bool:
        """
        Save annotations.
        
        Args:
            annotations: Dictionary of annotations
            
        Returns:
            True if successful
        """
        pass
    
    @abstractmethod
    def load(self, document_name: str) -> Dict[str, SemanticAnnotation]:
        """
        Load annotations for a document.
        
        Args:
            document_name: Document name
            
        Returns:
            Dictionary of annotations
        """
        pass
    
    @abstractmethod
    def find_by_article(self, article_number: str) -> Optional[SemanticAnnotation]:
        """
        Find annotation for specific article.
        
        Args:
            article_number: Article number
            
        Returns:
            SemanticAnnotation or None if not found
        """
        pass
