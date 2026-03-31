"""LLM-based semantic annotation for court verdicts."""
import json
import time
from collections import deque
from dataclasses import dataclass
from datetime import datetime, timedelta
from typing import Any, Dict, List, Optional

import requests

from src.config.llm_config import get_llm_config, DEFAULT_MODEL, is_gpt5_model


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
    needs_review: bool = False
    review_reason: Optional[str] = None
    extraction_method: str = "hybrid_regex_llm"
    metadata: Optional[Dict[str, Any]] = None
    factual_state: Optional[Dict[str, List[str]]] = None
    raw_response: Optional[str] = None


class VerdictAnnotator:
    """Annotates court verdicts using LLM."""

    def __init__(self, api_token: Optional[str] = None, model: Optional[str] = None, provider: Optional[str] = None):
        # Use centralized config
        config = get_llm_config(model=model, provider=provider, api_token=api_token)
        
        self.provider = config.provider
        self.api_token = config.api_token
        self.api_url = config.api_url
        self.openai_chat_url = "https://api.openai.com/v1/chat/completions"
        self.offline = config.is_offline
        self.model = config.model
        self.max_retries = config.max_retries
        self.retry_delay = config.retry_delay
        self.max_requests_per_minute = config.max_requests_per_minute
        self.request_timestamps = deque()
        self.min_delay_between_requests = config.min_delay_between_requests
        self.http_timeout = config.http_timeout
        self.openai_service_tier = config.openai_service_tier

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
        return (
            "Analiziraj presudu i vrati iskljucivo validan JSON bez markdowna. "
            "Drzi polja kratkim i listama do 3 stavke. "
            "Obavezna polja: verdict_summary, legal_issues, applied_laws, applied_articles, "
            "legal_reasoning, decision, case_outcome, legal_concepts, precedent_value, confidence, metadata, factual_state.\n\n"
            f"PRESUDA {case_number}:\n{verdict_text[:2200]}"
        )

    def annotate_verdict(
        self,
        verdict_text: str,
        case_number: str,
        retry_count: int = 0
    ) -> Optional[VerdictAnnotation]:
        """Anotira jednu presudu."""
        if self.offline:
            return None
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
                "messages": [
                    {
                        "role": "system",
                        "content": "Ti si ekspert za analizu sudskih presuda. Vrati samo validan JSON objekat bez dodatnog teksta."
                    },
                    {
                        "role": "user",
                        "content": prompt
                    }
                ],
                "temperature": 0.1,
                "response_format": {"type": "json_object"},
            }
            if is_gpt5_model(self.model):
                payload["max_completion_tokens"] = 1400
            else:
                payload["max_tokens"] = 1400
            if self.openai_service_tier:
                payload["service_tier"] = self.openai_service_tier
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
            request_url = self.openai_chat_url if self.provider == "openai" else self.api_url
            response = requests.post(request_url, headers=headers, json=payload, timeout=self.http_timeout)

            if response.status_code != 200:
                print(f"[!] LLM API error {response.status_code}: {response.text[:200]}")
                if retry_count < self.max_retries:
                    time.sleep(self.retry_delay)
                    return self.annotate_verdict(verdict_text, case_number, retry_count + 1)
                return None

            result = response.json()
            if self.provider == "openai":
                raw_content = (result.get("choices") or [{}])[0].get("message", {}).get("content", "").strip()
                if not raw_content:
                    print(f"[!] Prazan OpenAI odgovor: {json.dumps(result)[:400]}...")
            else:
                raw_content = result['choices'][0]['message']['content'].strip()
            json_content = self._extract_json(raw_content)

            if not json_content:
                safe_case = case_number.encode('ascii', 'replace').decode('ascii') if case_number else 'unknown'
                print(f"[!] Nevalidan JSON odgovor za {safe_case}")
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
            safe_case = case_number.encode('ascii', 'replace').decode('ascii') if case_number else 'unknown'
            print(f"[!] Greska pri anotaciji {safe_case}: {e}")
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
        confidence_raw = data.get("confidence")
        confidence = None
        if isinstance(confidence_raw, (int, float)):
            confidence = float(confidence_raw)
        elif isinstance(confidence_raw, str):
            try:
                confidence = float(confidence_raw.strip())
            except ValueError:
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
            safe_case = case_number.encode('ascii', 'replace').decode('ascii')
            print(f"[{idx}/{total}] Anotiram: {safe_case}")
            annotation = self.annotate_verdict(verdict_text, case_number)
            if annotation:
                annotations[case_number] = annotation
                print(f"  [OK] Uspesno: {len(annotation.legal_issues)} pravnih pitanja")
            else:
                print(f"  [X] Neuspesno")

        return annotations
