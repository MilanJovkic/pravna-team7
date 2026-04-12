"""Module for LLM-powered semantic annotations of legal text."""
import os
import json
import time
from collections import deque
from datetime import datetime, timedelta
from dataclasses import dataclass
from typing import Any, Dict, List, Optional

import requests
from dotenv import load_dotenv


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
    """Annotates legal articles using GitHub Models, OpenRouter, or OpenAI."""

    def __init__(
        self,
        api_token: Optional[str] = None,
        model: str = "gpt-4o-mini",
        provider: str = "openai",
        strict_mode: bool = True,
    ):
        load_dotenv()
        self.provider = provider.lower()
        self.strict_mode = strict_mode

        if self.provider == "openrouter":
            self.api_token = api_token or os.getenv("OPENROUTER_API_KEY")
            self.api_url = "https://openrouter.ai/api/v1/chat/completions"
            if not self.api_token:
                raise ValueError("OpenRouter API key nije pronađen. Postavi OPENROUTER_API_KEY u .env fajlu.")
        elif self.provider == "openai":
            self.api_token = api_token or os.getenv("OPENAI_API_KEY")
            self.api_url = "https://api.openai.com/v1/responses"
            if not self.api_token:
                raise ValueError("OpenAI API key nije pronađen. Postavi OPENAI_API_KEY u .env fajlu.")
        else:
            self.api_token = api_token or os.getenv("GITHUB_TOKEN")
            self.api_url = "https://models.inference.ai.azure.com/chat/completions"
            if not self.api_token:
                raise ValueError("GitHub token nije pronađen. Postavi GITHUB_TOKEN u .env fajlu.")

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

    def _create_annotation_prompt(self, article_text: str, article_number: str) -> str:
        return f"""Ti si ekspert za pravnu informatiku. Anotiraj član {article_number}.

Analiziraj sadržaj i vrati SAMO JSON u sledećem formatu:

{{
    \"norm_type\": \"<prohibition|obligation|permission|definition|sanction>\",
    \"subjects\": ["<perpetrator|victim|official|minor|family_member|...>"],
    \"conditions\": ["<intent|negligence|consent|aggravating_circumstances|...>"],
    \"sanctions\": {{
        \"type\": \"<prison|fine|both>\",
        \"min_value\": <broj>,
        \"max_value\": <broj>,
        \"min_unit\": \"<years|months|days>\",
        \"max_unit\": \"<years|months|days>\",
        \"details\": \"<opisi ako postoje>\"
    }},
    \"references\": [...],
    \"legal_concepts\": [...],
    \"qualifiers\": {{
        \"aggravated\": <true|false>,
        \"mitigated\": <true|false>,
        \"special_conditions\": ["<opis>" ]
    }},
    \"confidence\": <0.0-1.0>
}}

Vrati SAMO validan JSON bez dodatnog teksta."""

    def annotate_article(self, article_text: str, article_number: str, retry_count: int = 0) -> Optional[SemanticAnnotation]:
        self._wait_for_rate_limit()
        prompt = self._create_annotation_prompt(article_text, article_number)

        headers = {
            "Content-Type": "application/json",
            "Authorization": f"Bearer {self.api_token}"
        }
        if self.provider == "openrouter":
            headers["HTTP-Referer"] = "https://github.com/pravna-team7"
            headers["X-Title"] = "Legal Annotation System"

        if self.provider == "openai":
            payload = {
                "model": self.model,
                "input": [
                    {
                        "role": "system",
                        "content": [
                            {
                                "type": "input_text",
                                "text": "Ti si ekspert za semantičku anotaciju pravnih tekstova. Vraćaš ISKLJUČIVO validne JSON odgovore."
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
                "max_output_tokens": 1800
            }
            if self.model.startswith("gpt-5"):
                payload["service_tier"] = "flex"
        else:
            payload = {
                "messages": [
                    {
                        "role": "system",
                        "content": "Ti si ekspert za semantičku anotaciju pravnih tekstova. Vraćaš ISKLJUČIVO validne JSON odgovore."
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
                    print(f"  Retry {retry_count + 1}/{self.max_retries}...")
                    time.sleep(self.retry_delay)
                    return self.annotate_article(article_text, article_number, retry_count + 1)
                return None

            result = response.json()
            if self.provider == "openai" and result.get("status") == "incomplete":
                reason = (result.get("incomplete_details") or {}).get("reason")
                if reason == "max_output_tokens" and retry_count < self.max_retries:
                    print("⚠ OpenAI odgovor predugačak. Retry sa istim modelom u strict režimu...")
                    time.sleep(self.retry_delay)
                    return self.annotate_article(article_text, article_number, retry_count + 1)
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
                print(f"⚠ Nevalidan JSON odgovor za Član {article_number}")
                if raw_content:
                    print(f"  Raw: {raw_content[:200]}...")
                if retry_count < self.max_retries:
                    print(f"  Retry {retry_count + 1}/{self.max_retries}...")
                    time.sleep(self.retry_delay)
                    return self.annotate_article(article_text, article_number, retry_count + 1)
                return None

            annotation_data = json.loads(json_content)
            annotation = self._validate_and_build_annotation(annotation_data, raw_content)
            return annotation

        except requests.exceptions.Timeout:
            print(f"⚠ Timeout za Član {article_number}")
            if retry_count < self.max_retries:
                time.sleep(self.retry_delay)
                return self.annotate_article(article_text, article_number, retry_count + 1)
            return None

        except Exception as e:
            print(f"⚠ Greška pri anotaciji Člana {article_number}: {e}")
            if retry_count < self.max_retries:
                time.sleep(self.retry_delay)
                return self.annotate_article(article_text, article_number, retry_count + 1)
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

    def _validate_and_build_annotation(self, data: Dict[str, Any], raw_response: str) -> SemanticAnnotation:
        norm_type = data.get("norm_type", "unknown")
        subjects = data.get("subjects", [])
        conditions = data.get("conditions", [])
        sanctions = data.get("sanctions", {})
        references = data.get("references", [])
        legal_concepts = data.get("legal_concepts", [])
        qualifiers = data.get("qualifiers", {})
        confidence = data.get("confidence")

        return SemanticAnnotation(
            norm_type=norm_type,
            subjects=subjects if isinstance(subjects, list) else [],
            conditions=conditions if isinstance(conditions, list) else [],
            sanctions=sanctions if isinstance(sanctions, dict) else {},
            references=references if isinstance(references, list) else [],
            legal_concepts=legal_concepts if isinstance(legal_concepts, list) else [],
            qualifiers=qualifiers if isinstance(qualifiers, dict) else {},
            confidence=confidence,
            raw_response=raw_response
        )

    def annotate_batch(self, articles: List[tuple]) -> Dict[str, SemanticAnnotation]:
        annotations = {}
        total = len(articles)
        print(f"\n⚙ Rate limit: {self.max_requests_per_minute} zahteva/minut ")
        print(f"  Procenjeno vreme: {total * self.min_delay_between_requests / 60:.1f} minuta\n")

        for idx, (article_num, article_text) in enumerate(articles, 1):
            print(f"[{idx}/{total}] Anotiram Član {article_num}...")
            annotation = self.annotate_article(article_text, article_num)
            if annotation:
                annotations[article_num] = annotation
                print(f"  ✓ Uspešno: {annotation.norm_type}, {len(annotation.legal_concepts)} koncepata")
            else:
                print(f"  ✗ Neuspešno")

        if self.strict_mode and len(annotations) != total:
            raise RuntimeError(
                f"Strict LLM mode: anotirano {len(annotations)}/{total}. Pipeline se prekida zbog neuspelih LLM anotacija."
            )

        return annotations
