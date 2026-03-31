"""LLM-based semantic annotation for court verdicts.

Refactored to use centralized LLM client following SOLID principles.
"""
import json
from dataclasses import dataclass
from typing import Any, Dict, List, Optional

from src.llm import LLMClient, LLMConfig, LLMProvider


@dataclass
class VerdictAnnotation:
    """Semantic annotation for a court verdict."""
    
    verdict_summary: str
    legal_issues: List[str]
    applied_laws: List[str]
    applied_articles: List[str]
    legal_reasoning: str
    decision: str
    case_outcome: str
    legal_concepts: List[str]
    precedent_value: Optional[str] = None
    confidence: Optional[float] = None
    needs_review: bool = False
    review_reason: Optional[str] = None
    extraction_method: str = "hybrid_regex_llm"
    metadata: Optional[Dict[str, Any]] = None
    factual_state: Optional[Dict[str, List[str]]] = None
    raw_response: Optional[str] = None


class VerdictAnnotator:
    """Annotates court verdicts using centralized LLM client."""

    SYSTEM_PROMPT = (
        "Ti si ekspert za analizu sudskih presuda. "
        "Vrati samo validan JSON objekat bez dodatnog teksta."
    )

    def __init__(
        self,
        api_token: Optional[str] = None,
        model: str = "gpt-4o-mini",
        provider: str = "openai"
    ):
        try:
            provider_enum = LLMProvider(provider.lower())
        except ValueError:
            provider_enum = LLMProvider.OPENAI
        
        self.config = LLMConfig(
            provider=provider_enum,
            model=model,
            api_key=api_token,
            temperature=0.1,
            max_tokens=1400,
            rate_limit_rpm=10,
        )
        self.client = LLMClient(self.config)
        self.offline = not self.config.resolved_api_key

    def _create_prompt(self, verdict_text: str, case_number: str) -> str:
        return (
            "Analiziraj presudu i vrati iskljucivo validan JSON bez markdowna. "
            "Drzi polja kratkim i listama do 3 stavke. "
            "Obavezna polja: verdict_summary, legal_issues, applied_laws, applied_articles, "
            "legal_reasoning, decision, case_outcome, legal_concepts, precedent_value, "
            "confidence, metadata, factual_state.\n\n"
            f"PRESUDA {case_number}:\n{verdict_text[:2200]}"
        )

    def _build_annotation(self, data: Dict[str, Any], raw: str) -> VerdictAnnotation:
        confidence = data.get("confidence")
        if isinstance(confidence, str):
            try:
                confidence = float(confidence.strip())
            except ValueError:
                confidence = None
        elif isinstance(confidence, (int, float)):
            confidence = float(confidence)
        else:
            confidence = None

        return VerdictAnnotation(
            verdict_summary=data.get("verdict_summary", ""),
            legal_issues=data.get("legal_issues", []),
            applied_laws=data.get("applied_laws", []),
            applied_articles=data.get("applied_articles", []),
            legal_reasoning=data.get("legal_reasoning", ""),
            decision=data.get("decision", ""),
            case_outcome=data.get("case_outcome", "unknown"),
            legal_concepts=data.get("legal_concepts", []),
            precedent_value=data.get("precedent_value"),
            confidence=confidence,
            metadata=data.get("metadata") or {},
            factual_state=data.get("factual_state") or {},
            raw_response=raw,
        )

    def annotate_verdict(
        self,
        verdict_text: str,
        case_number: str,
        retry_count: int = 0
    ) -> Optional[VerdictAnnotation]:
        """Annotate a single verdict using LLM."""
        if self.offline:
            return None

        prompt = self._create_prompt(verdict_text, case_number)
        response = self.client.complete_json(prompt, self.SYSTEM_PROMPT)

        if not response.success:
            print(f"⚠ LLM error for {case_number}: {response.error}")
            return None

        if not response.json_data:
            print(f"⚠ Invalid JSON response for {case_number}")
            if response.content:
                print(f"  Raw: {response.content[:200]}...")
            return None

        return self._build_annotation(response.json_data, response.content)

    def annotate_batch(self, verdicts: dict[str, str]) -> dict[str, VerdictAnnotation]:
        """Annotate multiple verdicts."""
        annotations = {}
        total = len(verdicts)

        print(f"\n⚙ Using model: {self.config.model}")
        print(f"  Rate limit: {self.config.rate_limit_rpm} req/min\n")

        for idx, (case_number, verdict_text) in enumerate(verdicts.items(), 1):
            print(f"[{idx}/{total}] Annotating: {case_number}")
            annotation = self.annotate_verdict(verdict_text, case_number)
            if annotation:
                annotations[case_number] = annotation
                print(f"  ✓ Success: {len(annotation.legal_issues)} legal issues")
            else:
                print(f"  ✗ Failed")

        return annotations

