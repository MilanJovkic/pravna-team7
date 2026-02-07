"""
Modul za semantičku anotaciju pravnih tekstova pomoću LLM-a.

Koristi GitHub Models API za strukturiranu analizu članaka zakona.
"""

import os
import json
import time
from typing import Dict, List, Optional, Any
from dataclasses import dataclass, asdict
from dotenv import load_dotenv
import requests
from collections import deque
from datetime import datetime, timedelta


@dataclass
class SemanticAnnotation:
    """Semantička anotacija pravnog teksta."""
    
    # Tip norme
    norm_type: str  # prohibition, obligation, permission, definition, sanction
    
    # Subjekti
    subjects: List[str]  # perpetrator, victim, age_restricted, official, etc.
    
    # Uslovi primene norme
    conditions: List[str]  # intent, negligence, consent, aggravating_circumstances
    
    # Sankcije
    sanctions: Dict[str, Any]  # {type: prison/fine, min: X, max: Y, unit: years/months}
    
    # Reference na druge članke ili zakone
    references: List[Dict[str, str]]  # [{type: internal/external, target: "Član 144"}]
    
    # Pravni koncepti
    legal_concepts: List[str]  # murder, bodily_harm, self_defense, negligence
    
    # Dodatni kvalifikatori
    qualifiers: Dict[str, Any]  # aggravated_form, mitigated_form, special_conditions
    
    # Confidence score (ako LLM pruži)
    confidence: Optional[float] = None
    
    # Raw response za debugging
    raw_response: Optional[str] = None


class LLMAnnotator:
    """
    Klasa za LLM-bazirano anotiranje pravnih tekstova.
    
    Koristi GitHub Models API (GPT-4o ili Claude) za strukturiranu analizu.
    """
    
    def __init__(self, api_token: Optional[str] = None, model: str = "gpt-4o", provider: str = "github"):
        """
        Inicijalizacija annotatora.
        
        Args:
            api_token: API token (GitHub ili OpenRouter)
            model: Model name (npr. "gpt-4o" ili "tngtech/deepseek-r1t2-chimera:free")
            provider: "github" ili "openrouter"
        """
        load_dotenv()
        self.provider = provider.lower()
        
        # Odaberi odgovarajući token i URL na osnovu provider-a
        if self.provider == "openrouter":
            self.api_token = api_token or os.getenv("OPENROUTER_API_KEY")
            self.api_url = "https://openrouter.ai/api/v1/chat/completions"
            if not self.api_token:
                raise ValueError(
                    "OpenRouter API key nije pronađen. Postavi OPENROUTER_API_KEY u .env fajlu."
                )
        else:  # github
            self.api_token = api_token or os.getenv("GITHUB_TOKEN")
            self.api_url = "https://models.inference.ai.azure.com/chat/completions"
            if not self.api_token:
                raise ValueError(
                    "GitHub token nije pronađen. Postavi GITHUB_TOKEN u .env fajlu."
                )
        
        self.model = model
        self.max_retries = 3
        self.retry_delay = 2  # sekundi
        
        # Rate limiting: max 10 zahteva u minuti
        self.max_requests_per_minute = 10
        self.request_timestamps = deque()  # Sliding window za tracking zahteva
        self.min_delay_between_requests = 6.0  # 60s / 10 requests = 6s
    
    def _wait_for_rate_limit(self):
        """
        Čeka ako je potrebno da ne prekorači rate limit od 10 zahteva/minut.
        Koristi sliding window pristup.
        """
        now = datetime.now()
        
        # Ukloni zahteve starije od 1 minuta
        while self.request_timestamps and \
              (now - self.request_timestamps[0]) > timedelta(minutes=1):
            self.request_timestamps.popleft()
        
        # Ako imamo 10+ zahteva u poslednjih 60 sekundi, čekaj
        if len(self.request_timestamps) >= self.max_requests_per_minute:
            oldest_request = self.request_timestamps[0]
            time_to_wait = 60 - (now - oldest_request).total_seconds()
            
            if time_to_wait > 0:
                print(f"  ⏳ Rate limit: čekam {time_to_wait:.1f}s...")
                time.sleep(time_to_wait + 0.5)  # +0.5s buffer
                # Očisti stare nakon čekanja
                now = datetime.now()
                while self.request_timestamps and \
                      (now - self.request_timestamps[0]) > timedelta(minutes=1):
                    self.request_timestamps.popleft()
        
        # Osiguramo minimum delay između poziva
        if self.request_timestamps:
            last_request = self.request_timestamps[-1]
            time_since_last = (now - last_request).total_seconds()
            
            if time_since_last < self.min_delay_between_requests:
                delay = self.min_delay_between_requests - time_since_last
                time.sleep(delay)
        
        # Registruj novi zahtev
        self.request_timestamps.append(datetime.now())
    
    def _create_annotation_prompt(self, article_text: str, article_number: str) -> str:
        """
        Kreira prompt za LLM sa jasnim instrukcijama za anotaciju.
        
        KLJUČNO: Prompt definiše šemu anotacije na osnovu prirode krivičnog zakona.
        """
        return f"""Ti si ekspert za pravnu informatiku. Zadatak ti je da semantički anotiraš član Krivičnog zakonika Crne Gore.

ČLAN ZA ANOTACIJU:
Član {article_number}
{article_text}

ZADATAK:
Analiziraj ovaj član i vrati **ISKLJUČIVO JSON** bez dodatnog teksta u sledećem formatu:

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
        "details": "<detalji ako postoje>"
    }},
    "references": [
        {{"type": "internal", "target": "Član X", "article_number": X}},
        {{"type": "external", "target": "Zakon o Y"}}
    ],
    "legal_concepts": ["<murder|bodily_harm|negligence|attempt|self_defense|...>"],
    "qualifiers": {{
        "aggravated": <true|false>,
        "mitigated": <true|false>,
        "special_conditions": ["<opis posebnih uslova>"]
    }},
    "confidence": <0.0-1.0>
}}

PRAVILA:
1. norm_type: prohibition ako zabranjuje radnju, obligation ako nalaže, sanction ako definiše kaznu
2. subjects: identifikuj SVE aktere (počinilac, žrtva, službeno lice...)
3. conditions: SVE uslove pod kojima norma važi (umišljaj, nehat, pristanak...)
4. sanctions: precizno ekstraktuj kazne (minimalne/maksimalne vrednosti)
5. references: nađi SVE reference na druge članke ili zakone (npr. "po članu 144")
6. legal_concepts: označi pravne institute (ubistvo, teška tjelesna povreda...)
7. qualifiers.aggravated: true ako je "teško", "kvalifikovano" delo
8. confidence: tvoja procena sigurnosti anotacije (0.0-1.0)

Vrati **SAMO JSON**, bez dodatnog teksta pre ili posle!"""
    
    def annotate_article(
        self, 
        article_text: str, 
        article_number: str,  # String umesto int (podržava 151a)
        retry_count: int = 0
    ) -> Optional[SemanticAnnotation]:
        """
        Anotira jedan član zakona koristeći LLM.
        
        Args:
            article_text: Pun tekst člana
            article_number: Broj člana (string, može biti "151a")
            retry_count: Interni counter za retry logiku
            
        Returns:
            SemanticAnnotation objekat ili None ako anotacija nije uspela
        """
        # Rate limiting pre svakog poziva
        self._wait_for_rate_limit()
        
        prompt = self._create_annotation_prompt(article_text, article_number)
        
        headers = {
            "Content-Type": "application/json",
            "Authorization": f"Bearer {self.api_token}"
        }
        
        # OpenRouter zahteva dodatne headere
        if self.provider == "openrouter":
            headers["HTTP-Referer"] = "https://github.com/pravna-team7"
            headers["X-Title"] = "Legal Annotation System"
        
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
            "temperature": 0.1,  # Niska temperatura za konzistentnost
            "max_tokens": 2000
        }
        
        try:
            response = requests.post(
                self.api_url,
                headers=headers,
                json=payload,
                timeout=30
            )
            
            if response.status_code != 200:
                print(f"⚠ LLM API error {response.status_code}: {response.text}")
                
                # Retry logika
                if retry_count < self.max_retries:
                    print(f"  Retry {retry_count + 1}/{self.max_retries}...")
                    time.sleep(self.retry_delay)
                    return self.annotate_article(article_text, article_number, retry_count + 1)
                
                return None
            
            result = response.json()
            raw_content = result['choices'][0]['message']['content'].strip()
            
            # Parsiranje JSON-a (LLM ponekad wrap-uje u ```json```)
            json_content = self._extract_json(raw_content)
            
            if not json_content:
                print(f"⚠ Nevalidan JSON odgovor za Član {article_number}")
                print(f"  Raw: {raw_content[:200]}...")
                
                if retry_count < self.max_retries:
                    print(f"  Retry {retry_count + 1}/{self.max_retries}...")
                    time.sleep(self.retry_delay)
                    return self.annotate_article(article_text, article_number, retry_count + 1)
                
                return None
            
            # Validacija strukture
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
        """
        Ekstraktuj JSON iz LLM odgovora.
        LLM ponekad wrap-uje JSON u ```json...``` blokove.
        """
        text = text.strip()
        
        # Ukloni markdown code blocks
        if text.startswith("```json"):
            text = text[7:]
        elif text.startswith("```"):
            text = text[3:]
        
        if text.endswith("```"):
            text = text[:-3]
        
        text = text.strip()
        
        # Proveri da li počinje sa {
        if not text.startswith("{"):
            # Probaj da nađeš prvi {
            start_idx = text.find("{")
            if start_idx == -1:
                return None
            text = text[start_idx:]
        
        # Proveri da li se završava sa }
        if not text.endswith("}"):
            end_idx = text.rfind("}")
            if end_idx == -1:
                return None
            text = text[:end_idx + 1]
        
        return text
    
    def _validate_and_build_annotation(
        self, 
        data: Dict[str, Any],
        raw_response: str
    ) -> SemanticAnnotation:
        """
        Validira LLM odgovor i kreira SemanticAnnotation objekat.
        Primenjuje default vrednosti ako nešto nedostaje.
        """
        # Obavezna polja sa fallback-om
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
    
    def annotate_batch(
        self, 
        articles: List[tuple]  # (article_number, article_text)
    ) -> Dict[str, SemanticAnnotation]:  # String keys (podržava "151a")
        """
        Anotira batch članaka sa automatskim rate limiting-om.
        
        Rate limiting je ugrađen - max 10 zahteva/minut.
        
        Args:
            articles: Lista tuple-ova (article_number, article_text) gde je article_number string
            
        Returns:
            Dict {article_number: SemanticAnnotation} sa string keys
        """
        annotations = {}
        total = len(articles)
        
        print(f"\n⚙ Rate limit: {self.max_requests_per_minute} zahteva/minut ")
        print(f"  Procenjeno vreme: {total * self.min_delay_between_requests / 60:.1f} minuta\n")
        
        for idx, (article_num, article_text) in enumerate(articles, 1):
            print(f"[{idx}/{total}] Anotiram Član {article_num}...")
            
            annotation = self.annotate_article(article_text, article_num)
            
            if annotation:
                annotations[article_num] = annotation
                print(f"  ✓ Uspešno: {annotation.norm_type}, "
                      f"{len(annotation.legal_concepts)} koncepata")
            else:
                print(f"  ✗ Neuspešno")
        
        return annotations


if __name__ == "__main__":
    # Test
    from legal_parser import LegalTextParser
    
    with open("zakon.txt", "r", encoding="utf-8") as f:
        text = f.read()
    
    parser = LegalTextParser()
    chapters = parser.parse(text)
    articles = parser.get_all_articles(chapters)
    
    # Test na prvom članu
    if articles:
        annotator = LLMAnnotator()
        article = articles[0]
        article_text = parser.get_article_full_text(article)
        
        print(f"Testiram anotaciju za Član {article.number}...")
        annotation = annotator.annotate_article(article_text, article.number)
        
        if annotation:
            print("\nREZULTAT:")
            print(json.dumps(asdict(annotation), indent=2, ensure_ascii=False))
