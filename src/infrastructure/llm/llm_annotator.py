"""
LLM-based semantic annotator implementation.

Supports multiple LLM providers (GitHub Models, OpenRouter).
"""

import os
import json
import time
import requests
from typing import Dict, List, Optional
from collections import deque
from datetime import datetime, timedelta
from dotenv import load_dotenv

from ...domain.interfaces.annotators import ISemanticAnnotator
from ...domain.entities.annotation import (
    SemanticAnnotation, NormType, SanctionType, Sanction, LegalReference
)
from ...domain.entities.legal_document import LegalArticle


class LLMSemanticAnnotator(ISemanticAnnotator):
    """
    LLM-based semantic annotator.
    
    Uses structured prompts to extract semantic information from legal texts.
    Implements rate limiting and retry logic.
    """
    
    def __init__(
        self,
        provider: str = "github",
        model: str = "gpt-4o",
        api_token: Optional[str] = None,
        max_requests_per_minute: int = 10,
        max_retries: int = 3
    ):
        """
        Initialize LLM annotator.
        
        Args:
            provider: "github" or "openrouter"
            model: Model name
            api_token: API token (optional, will use env var if not provided)
            max_requests_per_minute: Rate limit
            max_retries: Max retry attempts on failure
        """
        load_dotenv()
        
        self.provider = provider.lower()
        self.model = model
        self.max_retries = max_retries
        self.max_requests_per_minute = max_requests_per_minute
        self.min_delay_between_requests = 60.0 / max_requests_per_minute
        self.request_timestamps = deque()
        
        # Configure API endpoint and token
        if self.provider == "openrouter":
            self.api_token = api_token or os.getenv("OPENROUTER_API_KEY")
            self.api_url = "https://openrouter.ai/api/v1/chat/completions"
        else:  # github
            self.api_token = api_token or os.getenv("GITHUB_TOKEN")
            self.api_url = "https://models.inference.ai.azure.com/chat/completions"
        
        if not self.api_token:
            raise ValueError(f"API token not found for provider: {self.provider}")
    
    def annotate_article(self, article: LegalArticle) -> Optional[SemanticAnnotation]:
        """
        Annotate a single legal article using LLM.
        
        Args:
            article: Legal article to annotate
            
        Returns:
            SemanticAnnotation or None if annotation fails
        """
        article_text = article.get_full_text()
        
        prompt = self._build_annotation_prompt(article_text)
        
        # Call LLM with retry logic
        for attempt in range(self.max_retries):
            try:
                self._wait_for_rate_limit()
                response = self._call_llm(prompt)
                
                if response:
                    annotation = self._parse_llm_response(
                        response,
                        article.number
                    )
                    return annotation
                
            except Exception as e:
                print(f"  ⚠ Attempt {attempt + 1}/{self.max_retries} failed: {e}")
                if attempt < self.max_retries - 1:
                    time.sleep(2 ** attempt)  # Exponential backoff
        
        return None
    
    def annotate_batch(
        self,
        articles: List[LegalArticle],
        batch_size: int = 1
    ) -> Dict[str, SemanticAnnotation]:
        """
        Annotate multiple articles.
        
        Args:
            articles: List of articles to annotate
            batch_size: Batch size (currently only supports 1)
            
        Returns:
            Dictionary mapping article_number to SemanticAnnotation
        """
        annotations = {}
        total = len(articles)
        
        for idx, article in enumerate(articles, 1):
            print(f"  [{idx}/{total}] Anotiranje člana {article.number}...", end=" ")
            
            annotation = self.annotate_article(article)
            
            if annotation:
                annotations[article.number] = annotation
                print("✓")
            else:
                print("✗")
        
        return annotations
    
    def validate_annotation(self, annotation: SemanticAnnotation) -> bool:
        """
        Validate annotation structure.
        
        Args:
            annotation: Annotation to validate
            
        Returns:
            True if annotation is valid
        """
        if not annotation.article_number:
            return False
        
        if annotation.confidence is not None:
            if not 0.0 <= annotation.confidence <= 1.0:
                return False
        
        return True
    
    def _build_annotation_prompt(self, article_text: str) -> str:
        """Build structured prompt for LLM annotation."""
        return f"""Analiziraj sledeći član krivičnog zakonika i ekstrahuj strukturirane podatke.

TEKST ČLANA:
{article_text}

Vrati JSON sa sledećim poljima:
{{
  "norm_type": "prohibition|obligation|permission|definition|sanction|procedural",
  "subjects": ["perpetrator", "victim", "official", ...],
  "conditions": ["intent", "negligence", "consent", ...],
  "sanctions": [
    {{"type": "prison|fine", "min": broj, "max": broj, "unit": "years|months|EUR"}}
  ],
  "references": [
    {{"type": "internal|external", "target": "Član X", "article_number": "X"}}
  ],
  "legal_concepts": ["murder", "theft", "self_defense", ...],
  "qualifiers": {{"aggravated": true/false, "mitigated": true/false}}
}}

Odgovori SAMO sa JSON-om, bez dodatnog teksta."""
    
    def _call_llm(self, prompt: str) -> Optional[str]:
        """Call LLM API and return response."""
        headers = {
            "Content-Type": "application/json",
            "Authorization": f"Bearer {self.api_token}"
        }
        
        payload = {
            "model": self.model,
            "messages": [
                {"role": "user", "content": prompt}
            ],
            "temperature": 0.1,
            "max_tokens": 1000
        }
        
        response = requests.post(
            self.api_url,
            headers=headers,
            json=payload,
            timeout=30
        )
        
        if response.status_code == 200:
            data = response.json()
            return data["choices"][0]["message"]["content"]
        else:
            raise Exception(f"API error: {response.status_code} - {response.text}")
    
    def _parse_llm_response(
        self,
        response: str,
        article_number: str
    ) -> Optional[SemanticAnnotation]:
        """Parse LLM JSON response into SemanticAnnotation."""
        try:
            # Extract JSON from response
            response = response.strip()
            if response.startswith("```json"):
                response = response[7:]
            if response.startswith("```"):
                response = response[3:]
            if response.endswith("```"):
                response = response[:-3]
            response = response.strip()
            
            data = json.loads(response)
            
            # Parse norm type
            norm_type_str = data.get("norm_type", "unknown")
            norm_type = NormType(norm_type_str)
            
            # Parse sanctions
            sanctions = []
            for s in data.get("sanctions", []):
                sanction_type = SanctionType(s.get("type", "none"))
                sanction = Sanction(
                    sanction_type=sanction_type,
                    min_value=s.get("min"),
                    max_value=s.get("max"),
                    unit=s.get("unit")
                )
                sanctions.append(sanction)
            
            # Parse references
            references = []
            for r in data.get("references", []):
                ref = LegalReference(
                    reference_type=r.get("type", "internal"),
                    target=r.get("target", ""),
                    article_number=r.get("article_number")
                )
                references.append(ref)
            
            # Create annotation
            annotation = SemanticAnnotation(
                article_number=article_number,
                norm_type=norm_type,
                subjects=data.get("subjects", []),
                conditions=data.get("conditions", []),
                sanctions=sanctions,
                references=references,
                legal_concepts=data.get("legal_concepts", []),
                qualifiers=data.get("qualifiers", {}),
                raw_response=response
            )
            
            return annotation
            
        except Exception as e:
            print(f"Parse error: {e}")
            return None
    
    def _wait_for_rate_limit(self):
        """Implement rate limiting using sliding window."""
        now = datetime.now()
        
        # Remove timestamps older than 1 minute
        cutoff = now - timedelta(minutes=1)
        while self.request_timestamps and self.request_timestamps[0] < cutoff:
            self.request_timestamps.popleft()
        
        # If at limit, wait
        if len(self.request_timestamps) >= self.max_requests_per_minute:
            sleep_time = (self.request_timestamps[0] - cutoff).total_seconds() + 1
            if sleep_time > 0:
                time.sleep(sleep_time)
            self.request_timestamps.popleft()
        
        # Add current timestamp
        self.request_timestamps.append(now)
        
        # Ensure minimum delay between requests
        if len(self.request_timestamps) > 1:
            time_since_last = (now - self.request_timestamps[-2]).total_seconds()
            if time_since_last < self.min_delay_between_requests:
                time.sleep(self.min_delay_between_requests - time_since_last)
