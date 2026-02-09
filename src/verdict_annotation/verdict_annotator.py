"""LLM-based semantic annotation for court verdicts."""
import json
import os
import time
from collections import deque
from dataclasses import dataclass
from datetime import datetime, timedelta
from typing import Any, Dict, List, Optional

import requests
from dotenv import load_dotenv


@dataclass
class VerdictAnnotation:
    """Semantic annotation for a court verdict."""
    
    verdict_summary: str
    legal_issues: List[str]  # Pravna pitanja
    applied_laws: List[str]  # Primenjeni zakoni
    applied_articles: List[str]  # Primenjeni članci
    legal_reasoning: str  # Pravno obrazloženje
    decision: str  # Odluka suda
    case_outcome: str  # Ishod (усвојено/одбијено/делимично усвојено)
    legal_concepts: List[str]  # Pravni koncepti
    precedent_value: Optional[str] = None  # Značaj kao presedana
    confidence: Optional[float] = None
    raw_response: Optional[str] = None


class VerdictAnnotator:
    """Annotates court verdicts using LLM."""

    def __init__(self, api_token: Optional[str] = None, model: str = "gpt-5-nano", provider: str = "openai"):
        load_dotenv()
        self.provider = provider.lower()

        if self.provider == "openrouter":
            self.api_token = api_token or os.getenv("OPENROUTER_API_KEY")
            self.api_url = "https://openrouter.ai/api/v1/chat/completions"
            if not self.api_token:
                raise ValueError("OpenRouter API key nije pronađen.")
        elif self.provider == "openai":
            self.api_token = api_token or os.getenv("OPENAI_API_KEY")
            self.api_url = "https://api.openai.com/v1/responses"
            if not self.api_token:
                raise ValueError("OpenAI API key nije pronađen.")
        else:
            self.api_token = api_token or os.getenv("GITHUB_TOKEN")
            self.api_url = "https://models.inference.ai.azure.com/chat/completions"
            if not self.api_token:
                raise ValueError("GitHub token nije pronađen.")

        self.model = model
        self.max_retries = 3
        self.retry_delay = 2
        self.max_requests_per_minute = 10
        self.request_timestamps = deque()
        self.min_delay_between_requests = 6.0

    def _wait_for_rate_limit(self):
        now = datetime.now()
        while self.request_timestamps and (now - self.request_timestamps[0]) > timedelta(minutes=1):
            self.request_timestamps.popleft()

        if len(self.request_timestamps) >= self.max_requests_per_minute:
            oldest_request = self.request_timestamps[0]
            time_to_wait = 60 - (now - oldest_request).total_seconds()
            if time_to_wait > 0:
                print(f"  ⏳ Rate limit: čekam {time_to_wait:.1f}s...")
                time.sleep(time_to_wait + 0.5)
                now = datetime.now()
                while self.request_timestamps and (now - self.request_timestamps[0]) > timedelta(minutes=1):
                    self.request_timestamps.popleft()

        if self.request_timestamps:
            last_request = self.request_timestamps[-1]
            time_since_last = (now - last_request).total_seconds()
            if time_since_last < self.min_delay_between_requests:
                delay = self.min_delay_between_requests - time_since_last
                time.sleep(delay)

        self.request_timestamps.append(datetime.now())

    def _create_annotation_prompt(self, verdict_text: str, case_number: str) -> str:
        return f"""Ti si ekspert za pravnu informatiku. Analiziraj sudsku presudu i vrati semantičku anotaciju.

    Odgovor mora biti KRATAK i KOMPAKTAN (bez objašnjenja, bez dodatnog teksta, bez navodnika oko celog JSON-a). Ograniči liste na najviše 3 stavke.

PRESUDA {case_number}:
{verdict_text[:3000]}

Vrati SAMO JSON u sledećem formatu:

{{
    "verdict_summary": "<kratak rezime presude (2-3 rečenice)>",
    "legal_issues": ["<pravno pitanje 1>", "<pravno pitanje 2>"],
    "applied_laws": ["<Krivični zakonik>", "<Zakon o ...>"],
    "applied_articles": ["Član 143", "Član 144"],
    "legal_reasoning": "<obrazloženje suda (kratak izvod)>",
    "decision": "<odluka suda (npr. 'Optuženi se oglašava krivim')>",
    "case_outcome": "<усвојено|одбијено|делимично усвојено>",
    "legal_concepts": ["murder", "self_defense", "mitigating_circumstances"],
    "precedent_value": "<low|medium|high>",
    "confidence": <0.0-1.0>
}}

Vrati SAMO validan JSON bez dodatnog teksta!"""

    def annotate_verdict(
        self,
        verdict_text: str,
        case_number: str,
        retry_count: int = 0
    ) -> Optional[VerdictAnnotation]:
        """Anotira jednu presudu."""
        self._wait_for_rate_limit()
        prompt = self._create_annotation_prompt(verdict_text, case_number)

        headers = {
            "Content-Type": "application/json",
            "Authorization": f"Bearer {self.api_token}"
        }
        if self.provider == "openrouter":
            headers["HTTP-Referer"] = "https://github.com/pravna-team7"
            headers["X-Title"] = "Legal Verdict Annotation"

        if self.provider == "openai":
            payload = {
                "model": self.model,
                "input": [
                    {
                        "role": "system",
                        "content": [
                            {
                                "type": "input_text",
                                "text": "Ti si ekspert za analizu sudskih presuda. Vraćaš ISKLJUČIVO validne JSON odgovore."
                            }
                        ]
                    },
                    {
                        "role": "user",
                        "content": [
                            {
                                "type": "input_text",
                                "text": prompt
                            }
                        ]
                    }
                ],
                "max_output_tokens": 800
            }
            if self.model.startswith("gpt-5"):
                payload["service_tier"] = "flex"
        else:
            payload = {
                "messages": [
                    {
                        "role": "system",
                        "content": "Ti si ekspert za analizu sudskih presuda. Vraćaš ISKLJUČIVO validne JSON odgovore."
                    },
                    {
                        "role": "user",
                        "content": prompt
                    }
                ],
                "model": self.model,
                "temperature": 0.1,
                "max_tokens": 2000
            }

        try:
            response = requests.post(self.api_url, headers=headers, json=payload, timeout=60)

            if response.status_code != 200:
                print(f"⚠ LLM API error {response.status_code}: {response.text}")
                if retry_count < self.max_retries:
                    time.sleep(self.retry_delay)
                    return self.annotate_verdict(verdict_text, case_number, retry_count + 1)
                return None

            result = response.json()
            if self.provider == "openai" and result.get("status") == "incomplete":
                reason = (result.get("incomplete_details") or {}).get("reason")
                if reason == "max_output_tokens" and retry_count < self.max_retries:
                    print("⚠ OpenAI odgovor predugačak. Pokušavam sa manjim modelom (gpt-4o-mini)...")
                    original_model = self.model
                    if self.model == "gpt-5-nano":
                        self.model = "gpt-4o-mini"
                    try:
                        time.sleep(self.retry_delay)
                        return self.annotate_verdict(verdict_text, case_number, retry_count + 1)
                    finally:
                        self.model = original_model
            if self.provider == "openai":
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
                    print(f"⚠ Prazan OpenAI odgovor: {json.dumps(result)[:400]}...")
            else:
                raw_content = result['choices'][0]['message']['content'].strip()
            json_content = self._extract_json(raw_content)

            if not json_content:
                print(f"⚠ Nevalidan JSON odgovor za {case_number}")
                if raw_content:
                    print(f"  Raw: {raw_content[:200]}...")
                if retry_count < self.max_retries:
                    time.sleep(self.retry_delay)
                    return self.annotate_verdict(verdict_text, case_number, retry_count + 1)
                return None

            annotation_data = json.loads(json_content)
            annotation = self._validate_and_build_annotation(annotation_data, raw_content)
            return annotation

        except Exception as e:
            print(f"⚠ Greška pri anotaciji {case_number}: {e}")
            if retry_count < self.max_retries:
                time.sleep(self.retry_delay)
                return self.annotate_verdict(verdict_text, case_number, retry_count + 1)
            return None

    def _extract_json(self, text: str) -> Optional[str]:
        text = text.strip()
        if text.startswith("```json"):
            text = text[7:]
        elif text.startswith("```"):
            text = text[3:]
        if text.endswith("```"):
            text = text[:-3]
        text = text.strip()
        if not text.startswith("{"):
            start_idx = text.find("{")
            if start_idx == -1:
                return None
            text = text[start_idx:]
        if not text.endswith("}"):
            end_idx = text.rfind("}")
            if end_idx == -1:
                return None
            text = text[:end_idx + 1]
        return text

    def _validate_and_build_annotation(self, data: Dict[str, Any], raw_response: str) -> VerdictAnnotation:
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
            confidence=data.get("confidence"),
            raw_response=raw_response
        )

    def annotate_batch(self, verdicts: dict[str, str]) -> dict[str, VerdictAnnotation]:
        """
        Anotira batch presuda.
        
        Args:
            verdicts: Dict {case_number: verdict_text}
            
        Returns:
            Dict {case_number: VerdictAnnotation}
        """
        annotations = {}
        total = len(verdicts)

        print(f"\n⚙ Rate limit: {self.max_requests_per_minute} zahteva/minut")
        print(f"  Procenjeno vreme: {total * self.min_delay_between_requests / 60:.1f} minuta\n")

        for idx, (case_number, verdict_text) in enumerate(verdicts.items(), 1):
            print(f"[{idx}/{total}] Anotiram: {case_number}")
            annotation = self.annotate_verdict(verdict_text, case_number)
            if annotation:
                annotations[case_number] = annotation
                print(f"  ✓ Uspešno: {len(annotation.legal_issues)} pravnih pitanja")
            else:
                print(f"  ✗ Neuspešno")

        return annotations
