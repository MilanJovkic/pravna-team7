"""Service for generating new court verdicts using LLM and exporting XML."""
from __future__ import annotations

from dataclasses import asdict
from datetime import datetime
from pathlib import Path
from typing import Optional
import json
import os
import time
from collections import deque

import requests
from dotenv import load_dotenv

from backend.app.models.schemas import (
    CaseFacts,
    ReasoningResponse,
    VerdictGenerationRequest,
    VerdictGenerationResponse,
)
from src.verdict_annotation.verdict_parser import VerdictMetadata
from src.verdict_annotation.verdict_annotator import VerdictAnnotator, VerdictAnnotation
from src.verdict_annotation.verdict_exporter import VerdictAkomaExporter


ROOT = Path(__file__).resolve().parents[3]
VERDICTS_DIR = ROOT / "data" / "verdicts_xml"


class VerdictTextGenerator:
    """LLM-based generator for verdict texts."""

    def __init__(self, api_token: Optional[str] = None, model: str = "gpt-5-nano", provider: str = "openai"):
        load_dotenv()
        self.provider = provider.lower()
        self.offline = False

        if self.provider == "openrouter":
            self.api_token = api_token or os.getenv("OPENROUTER_API_KEY")
            self.api_url = "https://openrouter.ai/api/v1/chat/completions"
            if not self.api_token:
                self.offline = True
        elif self.provider == "openai":
            self.api_token = api_token or os.getenv("OPENAI_API_KEY")
            self.api_url = "https://api.openai.com/v1/responses"
            if not self.api_token:
                self.offline = True
        else:
            self.api_token = api_token or os.getenv("GITHUB_TOKEN")
            self.api_url = "https://models.inference.ai.azure.com/chat/completions"
            if not self.api_token:
                self.offline = True

        self.model = model
        self.max_retries = 2
        self.retry_delay = 2
        self.max_requests_per_minute = 8
        self.request_timestamps = deque()
        self.min_delay_between_requests = 7.0

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

    def _extract_openai_text(self, result: dict) -> str:
        raw_content = ""
        for output_item in result.get("output", []):
            for content_item in output_item.get("content", []):
                text_value = content_item.get("text") or content_item.get("output_text")
                if text_value:
                    raw_content = text_value.strip()
                    break
            if raw_content:
                break
        if not raw_content:
            raw_content = (result.get("output_text") or "").strip()
        if not raw_content:
            choices = result.get("choices") or []
            if choices:
                message = choices[0].get("message") or {}
                content = message.get("content") or choices[0].get("text")
                if content:
                    raw_content = str(content).strip()
        return raw_content

    def _generate_via_chat_completions(self, prompt: str) -> str:
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
            "max_tokens": 2000,
        }
        response = requests.post(
            "https://api.openai.com/v1/chat/completions",
            headers={
                "Content-Type": "application/json",
                "Authorization": f"Bearer {self.api_token}",
            },
            json=payload,
            timeout=90,
        )
        if response.status_code != 200 and self.model.startswith("gpt-5"):
            payload["model"] = "gpt-4o-mini"
            response = requests.post(
                "https://api.openai.com/v1/chat/completions",
                headers={
                    "Content-Type": "application/json",
                    "Authorization": f"Bearer {self.api_token}",
                },
                json=payload,
                timeout=90,
            )

        if response.status_code != 200:
            raise RuntimeError(f"LLM API error {response.status_code}: {response.text}")

        result = response.json()
        text = (result.get("choices") or [{}])[0].get("message", {}).get("content", "")
        return text.strip()

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
                "input": [
                    {
                        "role": "system",
                        "content": [
                            {
                                "type": "input_text",
                                "text": "Pises sudske presude. Vracas samo tekst presude, bez dodatnog teksta.",
                            }
                        ],
                    },
                    {
                        "role": "user",
                        "content": [
                            {
                                "type": "input_text",
                                "text": prompt,
                            }
                        ],
                    },
                ],
                "max_output_tokens": 1200,
            }
            if self.model.startswith("gpt-5"):
                payload["service_tier"] = "flex"
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

        response = requests.post(self.api_url, headers=headers, json=payload, timeout=90)
        if response.status_code != 200:
            if retry_count < self.max_retries:
                time.sleep(self.retry_delay)
                return self.generate(prompt, retry_count + 1)
            raise RuntimeError(f"LLM API error {response.status_code}: {response.text}")

        result = response.json()
        if self.provider == "openai":
            text = self._extract_openai_text(result)
            if not text:
                try:
                    text = self._generate_via_chat_completions(prompt)
                except Exception:
                    text = ""
        else:
            text = result["choices"][0]["message"]["content"].strip()

        if not text:
            if retry_count < self.max_retries:
                time.sleep(self.retry_delay)
                return self.generate(prompt, retry_count + 1)
            raise RuntimeError("Prazan odgovor LLM-a pri generisanju presude.")

        return text.strip()


class VerdictGenerationService:
    """Creates a verdict text, annotates it, and exports Akoma Ntoso XML."""

    def __init__(self, provider: Optional[str] = None, model: Optional[str] = None) -> None:
        provider = provider or os.getenv("VERDICT_LLM_PROVIDER", "openai")
        model = model or os.getenv("VERDICT_LLM_MODEL", "gpt-5-nano")
        self.allow_fallback = os.getenv("VERDICT_ALLOW_FALLBACK", "false").lower() in {"1", "true", "yes"}
        self.generator = VerdictTextGenerator(model=model, provider=provider)
        self.annotator = VerdictAnnotator(model=model, provider=provider)
        self.exporter = VerdictAkomaExporter(enable_db_insert=True)

    def generate(self, payload: VerdictGenerationRequest) -> VerdictGenerationResponse:
        case_number = payload.case_number or self._generate_case_number()
        case_id = self._sanitize_case_id(case_number)
        if (VERDICTS_DIR / f"{case_id}.xml").exists():
            case_id = f"{case_id}-{datetime.now().strftime('%H%M%S')}"

        court_name = payload.court_name or "Osnovni sud u Podgorici"
        date_value = payload.date or datetime.now().strftime("%Y-%m-%d")
        judges = payload.judges or ["Sudija"]

        selected_verdict = payload.selected_verdict or payload.reasoning.suggested_verdict
        selected_sanction = payload.selected_sanction or payload.reasoning.suggested_sanction

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
        if self.generator.offline:
            if not self.allow_fallback:
                raise RuntimeError("LLM API kljuc nije podesen. Postavi OPENAI_API_KEY ili ukljuci VERDICT_ALLOW_FALLBACK=1.")
            verdict_text = self._build_fallback_verdict_text(
                case_number=case_number,
                court_name=court_name,
                date_value=date_value,
                judges=judges,
                facts=payload.facts,
                reasoning=payload.reasoning,
                selected_verdict=selected_verdict,
                selected_sanction=selected_sanction,
            )
        else:
            verdict_text = self.generator.generate(prompt)

        metadata = self._build_metadata(
            case_number=case_number,
            court_name=court_name,
            date_value=date_value,
            judges=judges,
            facts=payload.facts,
            reasoning=payload.reasoning,
            verdict_text=verdict_text,
        )

        annotation = None
        if not self.annotator.offline:
            annotation = self.annotator.annotate_verdict(verdict_text, case_number)
        if not annotation:
            if not self.allow_fallback:
                raise RuntimeError("LLM anotacija presude nije uspela. Omoguci VERDICT_ALLOW_FALLBACK=1 ako zelis fallback.")
            annotation = self._build_fallback_annotation(metadata, payload.reasoning)
        self._fill_annotation_defaults(annotation, metadata, payload.reasoning)

        VERDICTS_DIR.mkdir(parents=True, exist_ok=True)
        output_file = VERDICTS_DIR / f"{case_id}.xml"
        self.exporter.export(metadata, annotation, str(output_file), case_id)
        self._update_annotations_json(case_id, annotation)

        return VerdictGenerationResponse(
            case_id=case_id,
            case_number=case_number,
            xml_file=str(output_file),
            verdict_text=verdict_text,
        )

    def _build_fallback_verdict_text(
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
        applied_articles = ", ".join(reasoning.applied_articles or []) or "nepoznato"
        applied_laws = "Krivicni zakonik Crne Gore"
        suggested_verdict = selected_verdict or reasoning.suggested_verdict or "kriv"
        suggested_sanction = selected_sanction or reasoning.suggested_sanction or "sankcija po zakonu"

        return (
            f"{court_name}\n"
            f"Broj predmeta: {case_number}\n"
            f"Datum: {date_value}\n"
            f"Sudija/e: {', '.join(judges)}\n\n"
            "U IME CRNE GORE\n"
            "P R E S U D U\n\n"
            f"Okrivljeni: {facts.defendant or 'nepoznato'}\n\n"
            "Izreka:\n"
            f"Okrivljeni se oglasava {suggested_verdict}. "
            f"Primenjuju se cl. {applied_articles} ({applied_laws}).\n\n"
            "Sankcija:\n"
            f"{suggested_sanction}.\n\n"
            "Obrazlozenje:\n"
            "Sud je utvrdio cinjenicno stanje na osnovu raspolozivih dokaza "
            "i primenio relevantne zakonske odredbe.\n\n"
            "Pravna pouka:\n"
            "Protiv ove presude dozvoljena je zalba u zakonskom roku."
        )

    def _generate_case_number(self) -> str:
        stamp = datetime.now().strftime("%Y%m%d-%H%M%S")
        return f"GEN-{stamp}"

    def _sanitize_case_id(self, value: str) -> str:
        return (
            value.replace("/", "_")
            .replace("\\", "_")
            .replace(":", "_")
            .replace(" ", "_")
        )

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
        applied_articles = ", ".join(reasoning.applied_articles or [])
        applied_laws = ", ".join(
            {
                "Krivicni zakonik Crne Gore",
                *["Krivicni zakonik Crne Gore" for _ in (reasoning.applied_law_texts or [])],
            }
        )
        law_snippets = []
        for law in reasoning.applied_law_texts or []:
            if isinstance(law, dict):
                article_number = law.get("article_number")
                content = law.get("content")
            else:
                article_number = getattr(law, "article_number", None)
                content = getattr(law, "content", None)
            content = (content or "").strip()
            if content:
                law_snippets.append(f"Clan {article_number}: {content[:220]}")

        law_text_block = "\n".join(law_snippets[:3]) if law_snippets else "Nema dodatnih izvoda."
        similar_cases = ", ".join(
            [f"{m.case_number} ({m.similarity:.0%})" for m in (reasoning.cbr.matches or [])[:3] if m.case_number]
        )

        verdict_line = selected_verdict or reasoning.suggested_verdict or "nepoznato"
        sanction_line = selected_sanction or reasoning.suggested_sanction or "nepoznato"

        return (
            "Generisi novu sudsku presudu na srpskom (latinica, bez markdowna).\n"
            "Presuda mora da sledi strukturu crnogorskih presuda i da sadrzi:\n"
            "1) naziv suda, broj predmeta i datum\n"
            "2) izraz 'U IME CRNE GORE'\n"
            "3) naslov 'P R E S U D U'\n"
            "4) opis okrivljenog\n"
            "5) izreku (kriv je / nije kriv) sa primenjenim clancima\n"
            "6) sankciju\n"
            "7) kratko obrazlozenje\n"
            "8) pravnu pouku (kratko)\n\n"
            f"Broj predmeta: {case_number}\n"
            f"Sud: {court_name}\n"
            f"Datum: {date_value}\n"
            f"Sudija/e: {', '.join(judges)}\n"
            f"Okrivljeni: {facts.defendant or 'nepoznato'}\n"
            f"Tip povrede: {facts.injury_type or 'nepoznato'}\n"
            f"Lokacija: {facts.location or 'nepoznato'}\n"
            f"Oruzje: {facts.weapon or 'nepoznato'}\n"
            f"Oruzje upotrebljeno: {self._bool_text(facts.weapon_used)}\n"
            f"Teza posledica: {self._bool_text(facts.severe_consequence)}\n"
            f"Smrtni ishod: {self._bool_text(facts.death_result)}\n"
            f"Nehat: {self._bool_text(facts.negligence)}\n"
            f"Provokacija: {self._bool_text(facts.provocation)}\n"
            f"Ucesce u tuci: {self._bool_text(facts.fight_participation)}\n"
            f"Posledica tuce: {facts.fight_consequence or 'nepoznato'}\n"
            f"Ostavljen bez pomoci: {self._bool_text(facts.left_without_help)}\n\n"
            f"Primenjeni clanci: {applied_articles or 'nepoznato'}\n"
            f"Primenjeni zakoni: {applied_laws}\n"
            f"Predlog presude: {verdict_line}\n"
            f"Predlog sankcije: {sanction_line}\n"
            f"Slicni slucajevi: {similar_cases or 'nema'}\n\n"
            "Kratki izvodi zakona:\n"
            f"{law_text_block}\n\n"
            "Vrati samo kompletan tekst presude, bez dodatnih objasnjenja."
        )

    def _bool_text(self, value: Optional[bool]) -> str:
        if value is None:
            return "nepoznato"
        return "da" if value else "ne"

    def _facts_to_factual_state(self, facts: CaseFacts) -> dict[str, list[str]]:
        state: dict[str, list[str]] = {}

        def add(key: str, value: Optional[object]) -> None:
            if value is None:
                return
            if isinstance(value, bool):
                text = "da" if value else "ne"
            else:
                text = str(value).strip()
            if not text:
                return
            state.setdefault(key, [])
            if text not in state[key]:
                state[key].append(text)

        add("injury_type", facts.injury_type)
        add("location", facts.location)
        add("weapon", facts.weapon)
        add("weapon_used", facts.weapon_used)
        add("severe_consequence", facts.severe_consequence)
        add("death_result", facts.death_result)
        add("negligence", facts.negligence)
        add("provocation", facts.provocation)
        add("fight_participation", facts.fight_participation)
        add("fight_consequence", facts.fight_consequence)
        add("left_without_help", facts.left_without_help)
        return state

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
        applied_articles = [f"Clan {art}" for art in (reasoning.applied_articles or [])]
        legal_refs = []
        if applied_articles:
            legal_refs.append("Krivicni zakonik Crne Gore")

        parties = {}
        if facts.defendant:
            parties["defendant"] = [facts.defendant]

        return VerdictMetadata(
            case_number=case_number,
            court_name=court_name,
            date=date_value,
            judges=judges,
            parties=parties,
            organizations=[],
            legal_references=legal_refs,
            article_references=applied_articles,
            factual_state=self._facts_to_factual_state(facts),
            raw_text=verdict_text,
        )

    def _fill_annotation_defaults(
        self,
        annotation: VerdictAnnotation,
        metadata: VerdictMetadata,
        reasoning: ReasoningResponse,
    ) -> None:
        if not annotation.applied_articles:
            annotation.applied_articles = metadata.article_references or []
        if not annotation.applied_laws:
            annotation.applied_laws = metadata.legal_references or ["Krivicni zakonik Crne Gore"]
        if not annotation.factual_state:
            annotation.factual_state = metadata.factual_state or {}
        if not annotation.case_outcome and reasoning.suggested_verdict:
            annotation.case_outcome = reasoning.suggested_verdict

    def _build_fallback_annotation(
        self,
        metadata: VerdictMetadata,
        reasoning: ReasoningResponse,
    ) -> VerdictAnnotation:
        injury = None
        if metadata.factual_state.get("injury_type"):
            injury = metadata.factual_state["injury_type"][0]
        legal_issues = [injury] if injury else ["krivicno delo"]
        legal_concepts = [injury] if injury else ["krivicno delo"]

        suggested_verdict = reasoning.suggested_verdict or "kriv"
        verdict_lower = suggested_verdict.lower()
        if "odbij" in verdict_lower:
            outcome = "odbijeno"
        elif "delim" in verdict_lower:
            outcome = "delimicno usvojeno"
        elif "usvoj" in verdict_lower:
            outcome = "usvojeno"
        else:
            outcome = "usvojeno"

        return VerdictAnnotation(
            verdict_summary="Presuda doneta na osnovu utvrdjenih cinjenica i primenjenih normi.",
            legal_issues=legal_issues,
            applied_laws=metadata.legal_references or ["Krivicni zakonik Crne Gore"],
            applied_articles=metadata.article_references or [],
            legal_reasoning="Sud je primenio relevantne zakonske odredbe na utvrdjeno cinjenicno stanje.",
            decision="Okrivljeni se oglasava krivim i izrice se sankcija.",
            case_outcome=outcome,
            legal_concepts=legal_concepts,
            precedent_value="low",
            confidence=0.3,
            metadata={
                "case_number": metadata.case_number,
                "court_name": metadata.court_name,
                "date": metadata.date,
                "judges": metadata.judges,
                "parties": metadata.parties,
                "organizations": metadata.organizations,
            },
            factual_state=metadata.factual_state,
            raw_response="fallback",
        )

    def _update_annotations_json(self, case_id: str, annotation: VerdictAnnotation) -> None:
        annotations_file = VERDICTS_DIR / "verdicts_annotations.json"
        existing: dict[str, dict] = {}
        if annotations_file.exists():
            try:
                existing = json.loads(annotations_file.read_text(encoding="utf-8"))
            except Exception:
                existing = {}
        existing[case_id] = asdict(annotation)
        annotations_file.write_text(json.dumps(existing, ensure_ascii=False, indent=2), encoding="utf-8")
