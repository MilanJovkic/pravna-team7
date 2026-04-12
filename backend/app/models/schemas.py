"""Pydantic models for API requests and responses."""
from typing import List, Optional, Dict, Any
from pydantic import BaseModel, Field


class LawArticle(BaseModel):
    """Model for a law article."""
    number: str
    chapter_number: Optional[str] = None
    title: Optional[str] = None
    content: str
    norm_type: Optional[str] = None
    subjects: List[str] = Field(default_factory=list)
    legal_concepts: List[str] = Field(default_factory=list)
    sanctions: Optional[Dict[str, Any]] = None
    conditions: List[str] = Field(default_factory=list)
    references: List[Dict[str, Any]] = Field(default_factory=list)


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


class VerdictOverrideUpdate(BaseModel):
    """Overrides for verdict metadata and extracted facts."""
    summary: Optional[str] = None
    legal_issues: Optional[List[str]] = None
    applied_laws: Optional[List[str]] = None
    applied_articles: Optional[List[str]] = None
    decision: Optional[str] = None
    outcome: Optional[str] = None
    legal_concepts: Optional[List[str]] = None
    legal_reasoning: Optional[str] = None
    court_name: Optional[str] = None
    date: Optional[str] = None
    judges: Optional[List[str]] = None
    parties: Optional[Dict[str, List[str]]] = None
    factual_state: Optional[Dict[str, List[str]]] = None


class VerdictList(BaseModel):
    """Model for list of verdicts."""
    total: int
    page: int = 1
    page_size: int = 20
    total_pages: int = 1
    verdicts: List[VerdictMetadata]


class SearchRequest(BaseModel):
    """Model for search request."""
    query: str
    filter_by: Optional[str] = None


class SearchResponse(BaseModel):
    """Model for search response."""
    total_results: int
    results: List[VerdictMetadata]


class CaseFacts(BaseModel):
    """Model for case facts used in reasoning."""
    defendant: Optional[str] = None
    injury_type: Optional[str] = None
    location: Optional[str] = None
    weapon: Optional[str] = None
    weapon_used: Optional[bool] = None
    severe_consequence: Optional[bool] = None
    death_result: Optional[bool] = None
    negligence: Optional[bool] = None
    provocation: Optional[bool] = None
    fight_participation: Optional[bool] = None
    fight_consequence: Optional[str] = None
    left_without_help: Optional[bool] = None


class ReasoningRequest(BaseModel):
    """Request model for rule and case-based reasoning."""
    facts: CaseFacts
    top_k: int = 5


class RuleReasoningResult(BaseModel):
    """Result model for rule-based reasoning."""
    applied_norms: List[str] = Field(default_factory=list)
    proofs: List[str] = Field(default_factory=list)


class CbrMatch(BaseModel):
    """Single CBR match result."""
    case_number: Optional[str] = None
    similarity: float
    outcome: Optional[str] = None


class CbrResult(BaseModel):
    """CBR response model."""
    matches: List[CbrMatch] = Field(default_factory=list)


class AppliedLawText(BaseModel):
    """Applied law text for explanation."""
    article_number: str
    title: Optional[str] = None
    content: Optional[str] = None


class ReasoningResponse(BaseModel):
    """Combined reasoning response."""
    rule_reasoning: RuleReasoningResult
    cbr: CbrResult
    applied_articles: List[str] = Field(default_factory=list)
    applied_law_texts: List[AppliedLawText] = Field(default_factory=list)
    suggested_verdict: Optional[str] = None
    suggested_sanction: Optional[str] = None


class VerdictGenerationRequest(BaseModel):
    """Request model for generating a new verdict."""
    facts: CaseFacts
    reasoning: ReasoningResponse
    case_number: Optional[str] = None
    court_name: Optional[str] = None
    date: Optional[str] = None
    judges: List[str] = Field(default_factory=list)
    selected_verdict: Optional[str] = None
    selected_sanction: Optional[str] = None


class VerdictGenerationResponse(BaseModel):
    """Response model for generated verdict."""
    case_id: str
    case_number: str
    xml_file: str
    verdict_text: str


class NewCaseRequest(BaseModel):
    """Request model for inserting a new case."""
    case_number: Optional[str] = None
    outcome: Optional[str] = None
    verdict_type: Optional[str] = None
    sanction: Optional[str] = None
    facts: CaseFacts


class NewCaseResponse(BaseModel):
    """Response model for inserting a new case."""
    id: int
    case_number: str
