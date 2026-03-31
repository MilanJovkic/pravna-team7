"""Service for generating new court verdicts using LLM and exporting XML."""
from __future__ import annotations

from datetime import datetime
from pathlib import Path
from typing import Optional
import time
from collections import deque

import requests

from backend.app.models.schemas import (
    CaseFacts,
    ReasoningResponse,
    VerdictGenerationRequest,
    VerdictGenerationResponse,
)
from backend.app.domain.verdict.annotation import VerdictAnnotation
from backend.app.domain.verdict.entities import VerdictMetadata
from backend.app.infrastructure.exporters.akoma_verdict_exporter_adapter import AkomaVerdictExporterAdapter
from backend.app.infrastructure.llm.llm_config_adapter import resolve_llm_config, uses_gpt5_model
from backend.app.application.services.generation_plan_builder import GenerationPlanBuilder
from backend.app.application.services.prompt_builder import PromptBuilder
from backend.app.application.services.post_generation_validator import PostGenerationValidator
from backend.app.application.services.annotation_assembler import AnnotationAssembler
from backend.app.application.services.export_orchestrator import ExportOrchestrator
from backend.app.application.services.generation_identity_policy import GenerationIdentityPolicy
from backend.app.application.services.text_generation_gateway import TextGenerationGateway
from backend.app.application.services.generation_audit_logger import GenerationAuditLogger


ROOT = Path(__file__).resolve().parents[3]
VERDICTS_DIR = ROOT / "data" / "verdicts_xml"


class VerdictTextGenerator:
    """LLM-based generator for verdict texts."""

    def __init__(self, api_token: Optional[str] = None, model: Optional[str] = None, provider: Optional[str] = None):
        # Use centralized config
        config = resolve_llm_config(model=model, provider=provider, api_token=api_token)
        
        self.provider = config.provider
        self.api_token = config.api_token
        self.api_url = config.api_url
        self.offline = config.is_offline
        self.model = config.model
        self.max_retries = 0
        self.retry_delay = config.retry_delay
        self.max_requests_per_minute = 8
        self.request_timestamps = deque()
        self.min_delay_between_requests = 0.0
        self.http_timeout = config.http_timeout
        self.openai_service_tier = config.openai_service_tier

    def _wait_for_rate_limit(self) -> None:
        now = datetime.now()
        while self.request_timestamps and (now - self.request_timestamps[0]).total_seconds() > 60:
            self.request_timestamps.popleft()

        if len(self.request_timestamps) >= self.max_requests_per_minute:
            oldest = self.request_timestamps[0]
            wait_for = 60 - (now - oldest).total_seconds()
            if wait_for > 0:
                time.sleep(wait_for + 0.5)
                now = datetime.now()
                while self.request_timestamps and (now - self.request_timestamps[0]).total_seconds() > 60:
                    self.request_timestamps.popleft()

        if self.request_timestamps:
            since_last = (now - self.request_timestamps[-1]).total_seconds()
            if since_last < self.min_delay_between_requests:
                time.sleep(self.min_delay_between_requests - since_last)

        self.request_timestamps.append(datetime.now())

    def generate(self, prompt: str, retry_count: int = 0) -> str:
        """Generates verdict text from a prompt."""
        if self.offline:
            raise RuntimeError("LLM API kljuc nije podesen. Postavi OPENAI_API_KEY ili promeni provajder.")
        self._wait_for_rate_limit()

        headers = {
            "Content-Type": "application/json",
            "Authorization": f"Bearer {self.api_token}",
        }
        if self.provider == "openrouter":
            headers["HTTP-Referer"] = "https://github.com/pravna-team7"
            headers["X-Title"] = "Verdict Generation"

        if self.provider == "openai":
            payload = {
                "model": self.model,
                "messages": [
                    {
                        "role": "system",
                        "content": "Pises sudske presude. Vracas samo tekst presude, bez dodatnog teksta.",
                    },
                    {
                        "role": "user",
                        "content": prompt,
                    },
                ],
                "temperature": 0.2,
            }
            if uses_gpt5_model(self.model):
                payload["max_completion_tokens"] = 1200
            else:
                payload["max_tokens"] = 1200
            if self.openai_service_tier:
                payload["service_tier"] = self.openai_service_tier
        else:
            payload = {
                "messages": [
                    {
                        "role": "system",
                        "content": "Pises sudske presude. Vracas samo tekst presude, bez dodatnog teksta.",
                    },
                    {
                        "role": "user",
                        "content": prompt,
                    },
                ],
                "model": self.model,
                "temperature": 0.2,
                "max_tokens": 2000,
            }

        response = requests.post(self.api_url, headers=headers, json=payload, timeout=self.http_timeout)
        if response.status_code != 200:
            if retry_count < self.max_retries:
                time.sleep(self.retry_delay)
                return self.generate(prompt, retry_count + 1)
            raise RuntimeError(f"LLM API error {response.status_code}: {response.text}")

        result = response.json()
        # All providers now use Chat Completions format
        text = (result.get("choices") or [{}])[0].get("message", {}).get("content", "").strip()

        if not text:
            if retry_count < self.max_retries:
                time.sleep(self.retry_delay)
                return self.generate(prompt, retry_count + 1)
            raise RuntimeError("Prazan odgovor LLM-a pri generisanju presude.")

        return text.strip()


class VerdictGenerationService:
    """Creates a verdict text, annotates it, and exports Akoma Ntoso XML."""

    def __init__(self, provider: Optional[str] = None, model: Optional[str] = None) -> None:
        # Use centralized config - no need for manual env lookups
        self.generator = VerdictTextGenerator(model=model, provider=provider)
        self.exporter = AkomaVerdictExporterAdapter(enable_db_insert=True)
        self.text_generation_gateway = TextGenerationGateway(self.generator)
        self.plan_builder = GenerationPlanBuilder()
        self.prompt_builder = PromptBuilder()
        self.post_generation_validator = PostGenerationValidator()
        self.annotation_assembler = AnnotationAssembler()
        self.export_orchestrator = ExportOrchestrator(VERDICTS_DIR)
        self.identity_policy = GenerationIdentityPolicy()
        self.audit_logger = GenerationAuditLogger(VERDICTS_DIR)

    def generate(self, payload: VerdictGenerationRequest) -> VerdictGenerationResponse:
        """
        Generate a verdict using 2-stage process: plan creation then expansion.
        Stage 1: Create structured generation plan from reasoning
        Stage 2: Expand plan to full verdict text (via LLM)
        Stage 3: Post-validate structure and content
        """
        case_number = payload.case_number or self._generate_case_number()
        court_name = payload.court_name or "Osnovni sud u Podgorici"
        date_value = payload.date or datetime.now().strftime("%Y-%m-%d")
        judges = payload.judges or ["Sudija"]

        selected_verdict = payload.selected_verdict or payload.reasoning.suggested_verdict
        selected_sanction = payload.selected_sanction or payload.reasoning.suggested_sanction

        idempotency_key = self.identity_policy.compute_idempotency_key(
            payload=payload,
            case_number=case_number,
            court_name=court_name,
            date_value=date_value,
            judges=judges,
            selected_verdict=selected_verdict,
            selected_sanction=selected_sanction,
        )
        case_id = self.identity_policy.resolve_case_id(
            verdicts_dir=VERDICTS_DIR,
            case_number=case_number,
            idempotency_key=idempotency_key,
        )

        # STAGE 1: Create structured generation plan
        generation_plan = self._create_generation_plan(
            facts=payload.facts,
            reasoning=payload.reasoning,
            selected_verdict=selected_verdict,
            selected_sanction=selected_sanction
        )

        # STAGE 2: Expand plan to full verdict text
        prompt = self._build_prompt(
            case_number=case_number,
            court_name=court_name,
            date_value=date_value,
            judges=judges,
            facts=payload.facts,
            reasoning=payload.reasoning,
            selected_verdict=selected_verdict,
            selected_sanction=selected_sanction,
        )
        
        verdict_text, used_fallback, fallback_reason = self.text_generation_gateway.generate(
            prompt=prompt,
            fallback_factory=lambda: self._generate_fallback_verdict(
                case_number=case_number,
                court_name=court_name,
                date_value=date_value,
                judges=judges,
                facts=payload.facts,
                plan=generation_plan,
            ),
        )

        if used_fallback:
            self.audit_logger.log_event(
                case_id=case_id,
                event_type="generation_fallback",
                payload={
                    "reason": fallback_reason or "unknown",
                    "idempotency_key": idempotency_key,
                },
            )

        metadata = self.annotation_assembler.build_metadata(
            case_number=case_number,
            court_name=court_name,
            date_value=date_value,
            judges=judges,
            facts=payload.facts,
            reasoning=payload.reasoning,
            verdict_text=verdict_text,
        )

        annotation = self.annotation_assembler.build_structured_annotation(metadata, payload.reasoning)
        self.annotation_assembler.fill_annotation_defaults(annotation, metadata, payload.reasoning)

        output_file = self.export_orchestrator.export(
            exporter=self.exporter,
            case_id=case_id,
            metadata=metadata,
            annotation=annotation,
        )

        # STAGE 3: Post-validation of generated verdict
        quality_status = self._validate_verdict(
            verdict_text=verdict_text,
            facts=payload.facts,
            reasoning=payload.reasoning,
            generation_plan=generation_plan
        )

        self.audit_logger.log_event(
            case_id=case_id,
            event_type="quality_status",
            payload={
                "idempotency_key": idempotency_key,
                "quality_status": quality_status,
            },
        )

        return VerdictGenerationResponse(
            case_id=case_id,
            case_number=case_number,
            xml_file=str(output_file),
            verdict_text=verdict_text,
            generation_plan=generation_plan,
            quality_status=quality_status
        )

    def _create_generation_plan(
        self,
        facts: 'CaseFacts',
        reasoning: 'ReasoningResponse',
        selected_verdict: str,
        selected_sanction: str
    ) -> dict:
        """Delegates stage-1 generation plan construction to dedicated builder."""
        return self.plan_builder.build(
            facts=facts,
            reasoning=reasoning,
            selected_verdict=selected_verdict,
            selected_sanction=selected_sanction,
        )

    def _generate_fallback_verdict(
        self,
        case_number: str,
        court_name: str,
        date_value: str,
        judges: list,
        facts: 'CaseFacts',
        plan: dict
    ) -> str:
        """Generate minimal verdict structure when LLM is unavailable."""
        judge_line = ", ".join(judges) if judges else "Sudija"
        verdict = f"""ODLUKA

Predmet: {case_number}
Sud: {court_name}
Datum: {date_value}
Sudija: {judge_line}

PROCESNE STRANKE:
- Tužilac: Republika
- Optuženik: {facts.defendant}

OPIS ČINJENICA:
- Tip povrede: {facts.injury_type}
- Lokacija: {facts.location}
- Oružje: {facts.weapon}
- Teškoće: {'Ozbiljne' if facts.severe_consequence else 'Bez ozbiljnih posledica'}

PRAVNA OBRAZLOŽENJA:
Na osnovu dostavljene pravne analize i primenjenih normi, sud zastupa следeće:

ODLUKA:
{plan['proposed_verdict']}

SANKCIJA:
{plan['proposed_sanction']}

Ova odluka je doneta u skladu sa primenjivim zakonima.
"""
        return verdict

    def _validate_verdict(
        self,
        verdict_text: str,
        facts: 'CaseFacts',
        reasoning: 'ReasoningResponse',
        generation_plan: dict
    ) -> dict:
        """Delegates stage-3 quality checks to dedicated validator."""
        return self.post_generation_validator.validate(
            verdict_text=verdict_text,
            facts=facts,
            reasoning=reasoning,
            generation_plan=generation_plan,
        )

    def _generate_case_number(self) -> str:
        stamp = datetime.now().strftime("%Y%m%d-%H%M%S")
        return f"GEN-{stamp}"

    def _build_prompt(
        self,
        case_number: str,
        court_name: str,
        date_value: str,
        judges: list[str],
        facts: CaseFacts,
        reasoning: ReasoningResponse,
        selected_verdict: str | None,
        selected_sanction: str | None,
    ) -> str:
        return self.prompt_builder.build(
            case_number=case_number,
            court_name=court_name,
            date_value=date_value,
            judges=judges,
            facts=facts,
            reasoning=reasoning,
            selected_verdict=selected_verdict,
            selected_sanction=selected_sanction,
        )

    def _build_metadata(
        self,
        case_number: str,
        court_name: str,
        date_value: str,
        judges: list[str],
        facts: CaseFacts,
        reasoning: ReasoningResponse,
        verdict_text: str,
    ) -> VerdictMetadata:
        # Backward-compatible shim during decomposition rollout.
        return self.annotation_assembler.build_metadata(
            case_number=case_number,
            court_name=court_name,
            date_value=date_value,
            judges=judges,
            facts=facts,
            reasoning=reasoning,
            verdict_text=verdict_text,
        )

    def _build_structured_annotation(
        self,
        metadata: VerdictMetadata,
        reasoning: ReasoningResponse,
    ) -> VerdictAnnotation:
        # Backward-compatible shim during decomposition rollout.
        return self.annotation_assembler.build_structured_annotation(metadata, reasoning)

    def _fill_annotation_defaults(
        self,
        annotation: VerdictAnnotation,
        metadata: VerdictMetadata,
        reasoning: ReasoningResponse,
    ) -> None:
        # Backward-compatible shim during decomposition rollout.
        self.annotation_assembler.fill_annotation_defaults(annotation, metadata, reasoning)

