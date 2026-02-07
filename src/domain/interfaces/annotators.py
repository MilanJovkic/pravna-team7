"""Interface for semantic annotation."""

from abc import ABC, abstractmethod
from typing import List, Dict, Optional
from ..entities.annotation import SemanticAnnotation
from ..entities.legal_document import LegalArticle


class ISemanticAnnotator(ABC):
    """
    Interface for semantic annotation of legal texts.
    
    Implementations can use different approaches:
    - LLM-based (GPT, Claude, etc.)
    - NLP-based (spaCy, transformers)
    - Hybrid approaches
    
    Follows Interface Segregation and Dependency Inversion (SOLID).
    """
    
    @abstractmethod
    def annotate_article(self, article: LegalArticle) -> Optional[SemanticAnnotation]:
        """
        Annotate a single legal article.
        
        Args:
            article: Legal article to annotate
            
        Returns:
            Semantic annotation or None if annotation fails
        """
        pass
    
    @abstractmethod
    def annotate_batch(
        self,
        articles: List[LegalArticle],
        batch_size: int = 1
    ) -> Dict[str, SemanticAnnotation]:
        """
        Annotate multiple articles in batch.
        
        Args:
            articles: List of articles to annotate
            batch_size: Number of articles per batch
            
        Returns:
            Dictionary mapping article_number to SemanticAnnotation
        """
        pass
    
    @abstractmethod
    def validate_annotation(self, annotation: SemanticAnnotation) -> bool:
        """
        Validate annotation structure and content.
        
        Args:
            annotation: Annotation to validate
            
        Returns:
            True if annotation is valid
        """
        pass
