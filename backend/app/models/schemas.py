"""Pydantic models for API requests and responses."""
from typing import List, Optional, Dict, Any
from pydantic import BaseModel, Field


class LawArticle(BaseModel):
    """Model for a law article."""
    number: str
    title: Optional[str] = None
    content: str
    norm_type: Optional[str] = None
    subjects: List[str] = Field(default_factory=list)
    legal_concepts: List[str] = Field(default_factory=list)
    sanctions: Optional[Dict[str, Any]] = None


class LawChapter(BaseModel):
    """Model for a law chapter."""
    number: str
    title: str
    articles: List[LawArticle]


class Law(BaseModel):
    """Model for complete law document."""
    name: str
    chapters: List[LawChapter]
    total_articles: int


class VerdictMetadata(BaseModel):
    """Model for verdict metadata."""
    case_id: str
    case_number: Optional[str] = None
    court_name: Optional[str] = None
    date: Optional[str] = None
    judges: List[str] = Field(default_factory=list)
    summary: Optional[str] = None
    legal_issues: List[str] = Field(default_factory=list)
    applied_laws: List[str] = Field(default_factory=list)
    applied_articles: List[str] = Field(default_factory=list)
    decision: Optional[str] = None
    outcome: Optional[str] = None
    legal_concepts: List[str] = Field(default_factory=list)
    parties: Dict[str, List[str]] = Field(default_factory=dict)
    factual_state: Dict[str, List[str]] = Field(default_factory=dict)


class VerdictDetail(VerdictMetadata):
    """Extended verdict model with full content."""
    legal_reasoning: Optional[str] = None
    precedent_value: Optional[str] = None
    confidence: Optional[float] = None
    full_text: Optional[str] = None


class VerdictList(BaseModel):
    """Model for list of verdicts."""
    total: int
    verdicts: List[VerdictMetadata]


class SearchRequest(BaseModel):
    """Model for search request."""
    query: str
    filter_by: Optional[str] = None


class SearchResponse(BaseModel):
    """Model for search response."""
    total_results: int
    results: List[VerdictMetadata]
