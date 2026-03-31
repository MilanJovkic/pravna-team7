"""Module for LLM-powered semantic annotations of legal text.

Refactored to use centralized LLM client following SOLID principles.
"""
from dataclasses import dataclass
from typing import Any, Dict, List, Optional

from src.llm import LLMClient, LLMConfig, LLMProvider


@dataclass
class SemanticAnnotation:
    """Represents LLM annotation for a legal article."""

    norm_type: str
    subjects: List[str]
    conditions: List[str]
    sanctions: Dict[str, Any]
    references: List[Dict[str, str]]
    legal_concepts: List[str]
    qualifiers: Dict[str, Any]
    confidence: Optional[float] = None
    raw_response: Optional[str] = None


class LLMAnnotator:
    """Annotates legal articles using centralized LLM client."""

    SYSTEM_PROMPT = (
        "Ti si ekspert za semantičku anotaciju pravnih tekstova. "
        "Vraćaš ISKLJUČIVO validne JSON odgovore."
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
            max_tokens=800,
            rate_limit_rpm=10,
        )
        self.client = LLMClient(self.config)

        if not self.config.resolved_api_key:
            raise ValueError(
                f"API key not found. Set {self.config.provider_config.env_key} in .env"
            )

    def _create_prompt(self, article_text: str, article_number: str) -> str:
        return f"""Ti si ekspert za pravnu informatiku. Anotiraj član {article_number}.

Analiziraj sadržaj i vrati SAMO JSON u sledećem formatu:

{{
    "norm_type": "<prohibition|obligation|permission|definition|sanction>",
    "subjects": ["<perpetrator|victim|official|minor|family_member|...>"],
    "conditions": ["<intent|negligence|consent|aggravating_circumstances|...>"],
    "sanctions": {{
        "type": "<prison|fine|both>",
        "min_value": <broj>,
        "max_value": <broj>,
        "min_unit": "<years|months|days>",
        "max_unit": "<years|months|days>",
        "details": "<opisi ako postoje>"
    }},
    "references": [...],
    "legal_concepts": [...],
    "qualifiers": {{
        "aggravated": <true|false>,
        "mitigated": <true|false>,
        "special_conditions": ["<opis>" ]
    }},
    "confidence": <0.0-1.0>
}}

TEKST ČLANA:
{article_text}

Vrati SAMO validan JSON bez dodatnog teksta."""

    def _build_annotation(self, data: Dict[str, Any], raw: str) -> SemanticAnnotation:
        return SemanticAnnotation(
            norm_type=data.get("norm_type", "unknown"),
            subjects=data.get("subjects", []) if isinstance(data.get("subjects"), list) else [],
            conditions=data.get("conditions", []) if isinstance(data.get("conditions"), list) else [],
            sanctions=data.get("sanctions", {}) if isinstance(data.get("sanctions"), dict) else {},
            references=data.get("references", []) if isinstance(data.get("references"), list) else [],
            legal_concepts=data.get("legal_concepts", []) if isinstance(data.get("legal_concepts"), list) else [],
            qualifiers=data.get("qualifiers", {}) if isinstance(data.get("qualifiers"), dict) else {},
            confidence=data.get("confidence"),
            raw_response=raw
        )

    def annotate_article(
        self,
        article_text: str,
        article_number: str,
        retry_count: int = 0
    ) -> Optional[SemanticAnnotation]:
        """Annotate a single legal article."""
        prompt = self._create_prompt(article_text, article_number)
        response = self.client.complete_json(prompt, self.SYSTEM_PROMPT)

        if not response.success:
            print(f"⚠ LLM error for Article {article_number}: {response.error}")
            return None

        if not response.json_data:
            print(f"⚠ Invalid JSON response for Article {article_number}")
            if response.content:
                print(f"  Raw: {response.content[:200]}...")
            return None

        return self._build_annotation(response.json_data, response.content)

    def annotate_batch(self, articles: List[tuple]) -> Dict[str, SemanticAnnotation]:
        """Annotate multiple legal articles."""
        annotations = {}
        total = len(articles)

        print(f"\n⚙ Using model: {self.config.model}")
        print(f"  Rate limit: {self.config.rate_limit_rpm} req/min\n")

        for idx, (article_num, article_text) in enumerate(articles, 1):
            print(f"[{idx}/{total}] Annotating Article {article_num}...")
            annotation = self.annotate_article(article_text, article_num)
            if annotation:
                annotations[article_num] = annotation
                print(f"  ✓ Success: {annotation.norm_type}, {len(annotation.legal_concepts)} concepts")
            else:
                print(f"  ✗ Failed")

        return annotations
