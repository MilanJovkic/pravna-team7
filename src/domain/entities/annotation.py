"""
Domain entities for legal text annotations.

Semantic annotations extracted via NLP/LLM processing.
"""

from dataclasses import dataclass, field
from typing import List, Dict, Any, Optional
from enum import Enum


class NormType(Enum):
    """Types of legal norms."""
    PROHIBITION = "prohibition"
    OBLIGATION = "obligation"
    PERMISSION = "permission"
    DEFINITION = "definition"
    SANCTION = "sanction"
    PROCEDURAL = "procedural"
    UNKNOWN = "unknown"


class SanctionType(Enum):
    """Types of legal sanctions."""
    PRISON = "prison"
    FINE = "fine"
    COMMUNITY_SERVICE = "community_service"
    PROBATION = "probation"
    NONE = "none"


@dataclass
class LegalReference:
    """Reference to another legal provision."""
    reference_type: str  # "internal", "external"
    target: str  # e.g., "Član 144", "Zakon o privrednim prestupima"
    article_number: Optional[str] = None
    paragraph_number: Optional[int] = None
    
    def is_internal(self) -> bool:
        """Check if reference is internal to the same document."""
        return self.reference_type == "internal"


@dataclass
class Sanction:
    """Legal sanction specification."""
    sanction_type: SanctionType
    min_value: Optional[float] = None
    max_value: Optional[float] = None
    unit: Optional[str] = None  # "years", "months", "EUR"
    
    def __post_init__(self):
        """Validate sanction data."""
        if self.min_value is not None and self.max_value is not None:
            if self.min_value > self.max_value:
                raise ValueError("Minimum sanction cannot be greater than maximum")
    
    def to_dict(self) -> Dict[str, Any]:
        """Convert to dictionary representation."""
        return {
            "type": self.sanction_type.value,
            "min": self.min_value,
            "max": self.max_value,
            "unit": self.unit
        }


@dataclass
class SemanticAnnotation:
    """
    Semantic annotation of a legal article.
    
    Extracted via LLM or NLP processing. Contains structured semantic information
    about the legal norm, its subjects, conditions, and consequences.
    """
    article_number: str
    
    # Type of norm
    norm_type: NormType
    
    # Legal subjects involved
    subjects: List[str] = field(default_factory=list)  # perpetrator, victim, official, etc.
    
    # Conditions for norm application
    conditions: List[str] = field(default_factory=list)  # intent, negligence, consent, etc.
    
    # Sanctions
    sanctions: List[Sanction] = field(default_factory=list)
    
    # References to other articles/laws
    references: List[LegalReference] = field(default_factory=list)
    
    # Legal concepts
    legal_concepts: List[str] = field(default_factory=list)  # murder, theft, self_defense, etc.
    
    # Additional qualifiers
    qualifiers: Dict[str, Any] = field(default_factory=dict)  # aggravated, mitigated, etc.
    
    # Confidence score (0.0 - 1.0)
    confidence: Optional[float] = None
    
    # Raw LLM response for debugging
    raw_response: Optional[str] = None
    
    def __post_init__(self):
        """Validate annotation data."""
        if not self.article_number:
            raise ValueError("Annotation must have article_number")
        
        if self.confidence is not None:
            if not 0.0 <= self.confidence <= 1.0:
                raise ValueError("Confidence must be between 0.0 and 1.0")
    
    def add_sanction(self, sanction: Sanction) -> None:
        """Add a sanction to this annotation."""
        self.sanctions.append(sanction)
    
    def add_reference(self, reference: LegalReference) -> None:
        """Add a reference to this annotation."""
        self.references.append(reference)
    
    def has_sanctions(self) -> bool:
        """Check if annotation has any sanctions."""
        return len(self.sanctions) > 0
    
    def is_aggravated(self) -> bool:
        """Check if this is an aggravated form of offense."""
        return self.qualifiers.get("aggravated", False)
    
    def is_mitigated(self) -> bool:
        """Check if this is a mitigated form of offense."""
        return self.qualifiers.get("mitigated", False)
    
    def to_dict(self) -> Dict[str, Any]:
        """Convert to dictionary representation."""
        return {
            "article_number": self.article_number,
            "norm_type": self.norm_type.value,
            "subjects": self.subjects,
            "conditions": self.conditions,
            "sanctions": [s.to_dict() for s in self.sanctions],
            "references": [{"type": r.reference_type, "target": r.target} for r in self.references],
            "legal_concepts": self.legal_concepts,
            "qualifiers": self.qualifiers,
            "confidence": self.confidence
        }
