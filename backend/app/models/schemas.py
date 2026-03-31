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


class VerdictMetadataDTO(BaseModel):
    """DTO model for verdict metadata."""
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
    extraction_confidence: Optional[float] = None
    needs_review: bool = False
    legal_concepts: List[str] = Field(default_factory=list)
    parties: Dict[str, List[str]] = Field(default_factory=dict)
    factual_state: Dict[str, List[str]] = Field(default_factory=dict)


class VerdictDetailDTO(VerdictMetadataDTO):
    """Extended DTO model with full content."""
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
    verdicts: List[VerdictMetadataDTO]


class SearchRequest(BaseModel):
    """Model for search request."""
    query: str
    filter_by: Optional[str] = None


class SearchResponse(BaseModel):
    """Model for search response."""
    total_results: int
    results: List[VerdictMetadataDTO]


# Compatibility aliases during phase-2 migration.
VerdictMetadata = VerdictMetadataDTO
VerdictDetail = VerdictDetailDTO


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

    # Group 1: victim data
    victim_status: List[str] = Field(default_factory=list)
    victim_health_state: Optional[str] = None
    victim_accountability: Optional[str] = None
    victim_previously_abused: Optional[bool] = None
    victim_count: Optional[str] = None
    victim_explicit_request: Optional[str] = None
    victim_subordination: Optional[bool] = None

    # Group 2: result/consequence
    life_consequence_type: Optional[str] = None
    injury_severity_level: Optional[str] = None
    severe_injury_specific_consequences: List[str] = Field(default_factory=list)
    danger_to_third_parties: Optional[bool] = None
    suicide_outcome: Optional[str] = None
    abortion_outcomes: List[str] = Field(default_factory=list)

    # Group 3: execution method and motive
    execution_manner: List[str] = Field(default_factory=list)
    offender_motive: List[str] = Field(default_factory=list)
    provocation_types: List[str] = Field(default_factory=list)
    injury_means_type: Optional[str] = None
    victim_consent: Optional[str] = None
    sterilization_goal: Optional[str] = None

    # Group 4: subjective relation (guilt)
    guilt_form: Optional[str] = None
    offender_psych_state: Optional[str] = None
    death_attributed_to_negligence: Optional[str] = None

    # Group 5: abandonment / failure to provide help
    danger_caused_by_offender: Optional[bool] = None
    offender_victim_relationship: Optional[str] = None
    help_provision_ability: Optional[str] = None
    failure_to_help_consequence: Optional[str] = None

    # Group 6: service context and special acts
    duty_connection: Optional[str] = None
    special_action_types: List[str] = Field(default_factory=list)
    inhuman_treatment: Optional[bool] = None


class ReasoningRequest(BaseModel):
    """Request model for rule and case-based reasoning."""
    facts: CaseFacts
    top_k: int = 5
    strict_mode: bool = True


class RuleReasoningResult(BaseModel):
    """Result model for rule-based reasoning."""
    applied_norms: List[str] = Field(default_factory=list)
    proofs: List[str] = Field(default_factory=list)
    strict_mode: bool = True
    status: str = "ok"


class CbrMatch(BaseModel):
    """Single CBR match result."""
    case_number: Optional[str] = None
    verdict_case_id: Optional[str] = None
    similarity: float
    outcome: Optional[str] = None
    feature_contributions: Dict[str, float] = Field(default_factory=dict)


class CbrResult(BaseModel):
    """CBR response model."""
    matches: List[CbrMatch] = Field(default_factory=list)


class AppliedLawText(BaseModel):
    """Applied law text for explanation."""
    article_number: str
    title: Optional[str] = None
    content: Optional[str] = None


class ReasoningConfidence(BaseModel):
    """Transparent confidence metadata for hybrid decision support."""
    decision_basis: str = "unknown"
    final_confidence: float = 0.0
    rule_signal: str = "unavailable"
    cbr_signal: str = "unavailable"
    cbr_confidence: float = 0.0
    cbr_top_similarity: float = 0.0
    conflict: bool = False


class ReasoningResponse(BaseModel):
    """Combined reasoning response."""
    rule_reasoning: RuleReasoningResult
    cbr: CbrResult
    subsystem_status: Dict[str, str] = Field(default_factory=dict)
    applied_articles: List[str] = Field(default_factory=list)
    applied_law_texts: List[AppliedLawText] = Field(default_factory=list)
    suggested_verdict: Optional[str] = None
    suggested_sanction: Optional[str] = None
    reasoning_confidence: ReasoningConfidence = Field(default_factory=ReasoningConfidence)


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
    """Response model for generated verdict with quality status."""
    case_id: str
    case_number: str
    xml_file: str
    verdict_text: str
    quality_status: Dict[str, Any] = Field(default_factory=dict)
    generation_plan: Optional[Dict[str, Any]] = None
    
    class Config:
        json_encoders = {
            dict: lambda v: v or {}
        }


class NewCaseRequest(BaseModel):
    """Request model for inserting a new case."""
    case_number: Optional[str] = None
    outcome: Optional[str] = None
    verdict_type: Optional[str] = None
    sanction: Optional[str] = None
    selected_verdict: Optional[str] = None
    selected_sanction: Optional[str] = None
    user_confirmation: bool = False
    facts: CaseFacts


class NewCaseResponse(BaseModel):
    """Response model for inserting a new case."""
    id: int
    case_number: str
    reused_existing: bool = False
    version: int = 1
