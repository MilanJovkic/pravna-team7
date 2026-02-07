"""Interface for legal text parsing."""

from abc import ABC, abstractmethod
from typing import List
from ..entities.legal_document import LegalDocument, LegalChapter, LegalArticle


class ILegalTextParser(ABC):
    """
    Interface for parsing legal text into structured format.
    
    Follows Interface Segregation Principle (SOLID).
    Implementations can vary (regex-based, NLP-based, etc.).
    """
    
    @abstractmethod
    def parse(self, text: str) -> LegalDocument:
        """
        Parse legal text into structured document.
        
        Args:
            text: Raw legal text
            
        Returns:
            Structured LegalDocument
            
        Raises:
            ParseError: If text cannot be parsed
        """
        pass
    
    @abstractmethod
    def parse_chapters(self, text: str) -> List[LegalChapter]:
        """
        Parse only chapters from legal text.
        
        Args:
            text: Raw legal text
            
        Returns:
            List of LegalChapter objects
        """
        pass
    
    @abstractmethod
    def validate_structure(self, document: LegalDocument) -> bool:
        """
        Validate document structure.
        
        Args:
            document: Document to validate
            
        Returns:
            True if structure is valid
        """
        pass
