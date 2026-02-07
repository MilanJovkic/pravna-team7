"""Interface for document export."""

from abc import ABC, abstractmethod
from typing import Dict
from ..entities.legal_document import LegalDocument
from ..entities.annotation import SemanticAnnotation


class IDocumentExporter(ABC):
    """
    Interface for exporting legal documents to various formats.
    
    Implementations can support different formats:
    - Akoma Ntoso XML
    - LegalRuleML
    - JSON-LD
    - etc.
    
    Follows Open/Closed Principle (SOLID) - open for extension, closed for modification.
    """
    
    @abstractmethod
    def export(
        self,
        document: LegalDocument,
        annotations: Dict[str, SemanticAnnotation],
        output_path: str
    ) -> str:
        """
        Export document with annotations to file.
        
        Args:
            document: Legal document to export
            annotations: Semantic annotations
            output_path: Path to output file
            
        Returns:
            Path to created file
            
        Raises:
            ExportError: If export fails
        """
        pass
    
    @abstractmethod
    def validate_output(self, output_path: str) -> bool:
        """
        Validate exported document.
        
        Args:
            output_path: Path to exported file
            
        Returns:
            True if output is valid
        """
        pass
