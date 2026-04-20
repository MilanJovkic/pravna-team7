"""LLM-based semantic annotation for court verdicts."""
import json
import re
import time
from collections import deque
from dataclasses import dataclass
from datetime import datetime, timedelta
from typing import Any, Dict, List, Optional, Tuple

import requests

from src.config.llm_config import get_llm_config, DEFAULT_MODEL, is_gpt5_model
from .text_normalization import normalize_legal_text


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

    def _collect_ocr_candidates(self, text: str, max_items: int = 120) -> List[str]:
        """Collect suspicious OCR artifacts for optional LLM spacing repair."""
        patterns = (
            re.compile(r"\b[A-Za-zČĆŽŠĐčćžšđ]{2,}[a-zčćžšđ][A-ZČĆŽŠĐ]\s*[a-zčćžšđ]{1,}\b"),
            re.compile(r"\b[A-Za-zČĆŽŠĐčćžšđ]{3,}[čćžšđ]\s+[a-zčćžšđ]{1,4}\b"),
            re.compile(r"\b[A-Za-zČĆŽŠĐčćžšđ]{3,}\s+[čćžšđ]\b"),
            re.compile(r"\bkao[a-zčćžšđ]{4,}\b", re.IGNORECASE),
        )

        candidates: List[str] = []
        seen = set()

        for pattern in patterns:
            for match in pattern.finditer(text):
                token = match.group(0).strip()
                if not token:
                    continue
                # Keep initials untouched; we only repair lexical OCR spacing artifacts.
                if re.fullmatch(r"(?:[A-ZČĆŽŠĐ]\.\s*){2,3}", token):
                    continue
                lowered = token.lower()
                if lowered in seen:
                    continue
                seen.add(lowered)
                candidates.append(token)
                if len(candidates) >= max_items:
                    return candidates

        return candidates

    def _build_ocr_context(self, text: str, token: str, width: int = 40) -> str:
        idx = text.find(token)
        if idx < 0:
            return ""
        start = max(0, idx - width)
        end = min(len(text), idx + len(token) + width)
        snippet = text[start:end].replace("\n", " ")
        return " ".join(snippet.split())

    def _create_ocr_repair_prompt(self, case_number: str, candidates: List[str], contexts: List[str]) -> str:
        rows = []
        for i, candidate in enumerate(candidates):
            context = contexts[i] if i < len(contexts) else ""
            rows.append(f"- from: {candidate}\n  context: {context}")

        joined_rows = "\n".join(rows)
        return (
            "Vrati ISKLJUČIVO validan JSON formata "
            "{\"replacements\":[{\"from\":\"...\",\"to\":\"...\"}]}. "
            "Zadatak: ispravi samo OCR/spacing artefakte bez promjene značenja, padeža ili reda riječi. "
            "Dozvoljene promjene: dodavanje/uklanjanje razmaka između već postojećih slova. "
            "Ne mijenjaj interpunkciju osim razmaka. Ne mijenjaj inicijale tipa N.R. "
            "Ako nisi siguran, preskoči taj unos.\n\n"
            f"CASE: {case_number}\n"
            "KANDIDATI:\n"
            f"{joined_rows}"
        )

    def repair_ocr_artifacts(
        self,
        verdict_text: str,
        case_number: str,
        retry_count: int = 0,
    ) -> str:
        """Optional LLM fallback for residual OCR spacing artifacts in raw text."""
        text = verdict_text or ""
        candidates = self._collect_ocr_candidates(text)
        if not candidates:
            return text

        if self.offline:
            return text

        contexts = [self._build_ocr_context(text, token) for token in candidates]
        prompt = self._create_ocr_repair_prompt(case_number, candidates, contexts)

        response = self._request_json_completion(
            prompt=prompt,
            system_instruction=(
                "Ti si asistent za ispravljanje OCR artefakata u pravnim tekstovima. "
                "Vraćaš samo validan JSON i ništa drugo."
            ),
            max_tokens=1200,
            temperature=0.0,
            retry_count=retry_count,
            case_number=case_number,
        )
        if not response:
            return text

        payload, _ = response
        raw_replacements = payload.get("replacements")
        replacements: List[Tuple[str, str]] = []

        if isinstance(raw_replacements, dict):
            for src, dst in raw_replacements.items():
                replacements.append((str(src or "").strip(), str(dst or "").strip()))
        elif isinstance(raw_replacements, list):
            for item in raw_replacements:
                if not isinstance(item, dict):
                    continue
                src = str(item.get("from") or "").strip()
                dst = str(item.get("to") or "").strip()
                replacements.append((src, dst))

        if not replacements:
            return text

        fixed = text
        # Replace longer patterns first to avoid partial overwrite issues.
        replacements.sort(key=lambda pair: len(pair[0]), reverse=True)

        for source, target in replacements:
            if not source or not target or source == target:
                continue
            if source not in fixed:
                continue
            # Keep this stage conservative: spacing-only edits should not drift far in size.
            if abs(len(target) - len(source)) > 8:
                continue
            fixed = fixed.replace(source, target)

        return normalize_legal_text(fixed)

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

    def _build_prompt_context(self, verdict_text: str, max_chars: int = 7000) -> str:
        """Build compact but high-signal context for LLM prompts."""
        text = (verdict_text or "").strip()
        if len(text) <= max_chars:
            return text

        head = text[:3600]
        tail = text[-1400:]

        keywords = (
            "u vije", "u vijec", "sudija", "sutkinja", "predsjednika vije", "predsednika vec",
            "zapisni", "k.br", "broj", "presudu", "osudj", "oslobad", "odbij", "ukida",
        )

        focus_lines: list[str] = []
        for line in text.splitlines()[:260]:
            compact = " ".join(line.split())
            if not compact:
                continue
            line_lower = compact.lower()
            if any(token in line_lower for token in keywords):
                focus_lines.append(compact)

        # Keep unique order and cap size.
        seen = set()
        deduped: list[str] = []
        for line in focus_lines:
            key = line.lower()
            if key in seen:
                continue
            seen.add(key)
            deduped.append(line)

        focus_block = "\n".join(deduped)
        available = max(0, max_chars - len(head) - len(tail) - 40)
        if len(focus_block) > available:
            focus_block = focus_block[:available]

        return f"{head}\n\n[FOCUS]\n{focus_block}\n\n[TAIL]\n{tail}".strip()

    def _create_annotation_prompt(self, verdict_text: str, case_number: str) -> str:
        context = self._build_prompt_context(verdict_text, max_chars=7000)
        return (
            "Analiziraj presudu i vrati isključivo validan JSON bez markdowna i dodatnog teksta. "
            "Drži polja kratkim i listama do 4 stavke. "
            "Obavezna polja: verdict_summary, legal_issues, applied_laws, applied_articles, "
            "legal_reasoning, decision, case_outcome, legal_concepts, precedent_value, confidence, metadata, factual_state. "
            "metadata mora imati: case_number, court_name, date, judges, parties, organizations. "
            "Za judges vrati sva imena sudija koja se navode u uvodu presude, u nominativu (bez padeža), "
            "bez OCR artefakata i bez tokena poput 'kao', 'dana', 'optuženog'. "
            "Ako postoji konstrukcija 'u vijeću sastavljenom od sudije X ... i sudija Y i Z', judges mora sadržati X, Y, Z. "
            "case_outcome koristi samo: osudjen, oslobodjen, odbijeno, usvojeno, ukinuto, nepoznato.\n\n"
            f"PRESUDA {case_number}:\n{context}"
        )

    def _create_metadata_repair_prompt(self, verdict_text: str, case_number: str) -> str:
        context = self._build_prompt_context(verdict_text, max_chars=5200)
        return (
            "Vrati isključivo JSON sa ovim poljima: "
            "case_number, court_name, date, judges, case_outcome. "
            "Pravila: judges mora sadržati sva imena sudija u nominativu i punom obliku kad god je moguće. "
            "Ne vraćaj padežne oblike (npr. Mirjane -> Mirjana), ne vraćaj OCR artefakte (npr. Popovići -> Popović), "
            "ne vraćaj dodatne reči ('kao', 'dana', 'optuženog'). "
            "Ako se pojavljuje panel 'u vijeću sastavljenom od sudije X ... i sudija Y i Z', judges mora biti [X, Y, Z]. "
            "Ako nema pouzdanog podatka, vrati praznu vrednost ili praznu listu. "
            "case_outcome koristi samo: osudjen, oslobodjen, odbijeno, usvojeno, ukinuto, nepoznato.\n\n"
            f"PRESUDA {case_number}:\n{context}"
        )

    def _request_json_completion(
        self,
        *,
        prompt: str,
        system_instruction: str,
        max_tokens: int,
        temperature: float,
        retry_count: int,
        case_number: str,
    ) -> Optional[Tuple[Dict[str, Any], str]]:
        if self.offline:
            return None

        self._wait_for_rate_limit()

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
                    {"role": "system", "content": system_instruction},
                    {"role": "user", "content": prompt},
                ],
                "temperature": temperature,
                "response_format": {"type": "json_object"},
            }
            if is_gpt5_model(self.model):
                payload["max_completion_tokens"] = max_tokens
            else:
                payload["max_tokens"] = max_tokens
            if self.openai_service_tier:
                payload["service_tier"] = self.openai_service_tier
        else:
            payload = {
                "messages": [
                    {"role": "system", "content": system_instruction},
                    {"role": "user", "content": prompt},
                ],
                "model": self.model,
                "temperature": temperature,
                "max_tokens": max_tokens,
            }

        try:
            request_url = self.openai_chat_url if self.provider == "openai" else self.api_url
            response = requests.post(request_url, headers=headers, json=payload, timeout=self.http_timeout)

            if response.status_code != 200:
                print(f"[!] LLM API error {response.status_code}: {response.text[:200]}")
                if retry_count < self.max_retries:
                    time.sleep(self.retry_delay)
                    return self._request_json_completion(
                        prompt=prompt,
                        system_instruction=system_instruction,
                        max_tokens=max_tokens,
                        temperature=temperature,
                        retry_count=retry_count + 1,
                        case_number=case_number,
                    )
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
                    return self._request_json_completion(
                        prompt=prompt,
                        system_instruction=system_instruction,
                        max_tokens=max_tokens,
                        temperature=temperature,
                        retry_count=retry_count + 1,
                        case_number=case_number,
                    )
                return None

            data = json.loads(json_content)
            if not isinstance(data, dict):
                return None
            return data, raw_content

        except Exception as e:
            safe_case = case_number.encode('ascii', 'replace').decode('ascii') if case_number else 'unknown'
            print(f"[!] Greska pri anotaciji {safe_case}: {e}")
            if retry_count < self.max_retries:
                time.sleep(self.retry_delay)
                return self._request_json_completion(
                    prompt=prompt,
                    system_instruction=system_instruction,
                    max_tokens=max_tokens,
                    temperature=temperature,
                    retry_count=retry_count + 1,
                    case_number=case_number,
                )
            return None

    def extract_metadata_only(
        self,
        verdict_text: str,
        case_number: str,
        retry_count: int = 0,
    ) -> Optional[Dict[str, Any]]:
        """Run dedicated LLM pass for high-quality metadata extraction/repair."""
        prompt = self._create_metadata_repair_prompt(verdict_text, case_number)
        response = self._request_json_completion(
            prompt=prompt,
            system_instruction=(
                "Ti si ekspert za analizu sudskih presuda. "
                "Vrati samo validan JSON objekat bez dodatnog teksta."
            ),
            max_tokens=900,
            temperature=0.0,
            retry_count=retry_count,
            case_number=case_number,
        )
        if not response:
            return None

        payload, _ = response
        judges_raw = payload.get("judges") or []
        if isinstance(judges_raw, str):
            judges_raw = [judges_raw]
        judges = [str(j).strip() for j in judges_raw if str(j).strip()]

        case_outcome = str(payload.get("case_outcome") or "").strip().lower()
        if case_outcome and case_outcome not in {"osudjen", "oslobodjen", "odbijeno", "usvojeno", "ukinuto", "nepoznato"}:
            case_outcome = "nepoznato"

        court_name = str(payload.get("court_name") or "").strip()
        court_name = re.sub(r"(?i)\s+(?:dana|kao|optu[žz]en\w*|okrivljen\w*)\b.*$", "", court_name).strip(" ,.;")

        date_value = str(payload.get("date") or "").strip()
        if date_value and not re.fullmatch(r"\d{4}-\d{2}-\d{2}", date_value):
            date_value = ""

        return {
            "case_number": str(payload.get("case_number") or "").strip(),
            "court_name": court_name,
            "date": date_value,
            "judges": judges,
            "case_outcome": case_outcome,
        }

    def annotate_verdict(
        self,
        verdict_text: str,
        case_number: str,
        retry_count: int = 0
    ) -> Optional[VerdictAnnotation]:
        """Anotira jednu presudu."""
        prompt = self._create_annotation_prompt(verdict_text, case_number)
        response = self._request_json_completion(
            prompt=prompt,
            system_instruction=(
                "Ti si ekspert za analizu sudskih presuda. "
                "Vrati samo validan JSON objekat bez dodatnog teksta."
            ),
            max_tokens=1600,
            temperature=0.1,
            retry_count=retry_count,
            case_number=case_number,
        )
        if not response:
            return None

        annotation_data, raw_content = response
        annotation = self._validate_and_build_annotation(annotation_data, raw_content)
        return annotation

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
