"""
Centralized LLM Client.

This module provides a single, unified interface for all LLM interactions
in the project, following clean architecture principles.

Features:
- Single entry point for all LLM calls
- Automatic rate limiting
- Retry logic with exponential backoff
- JSON extraction utilities
- Provider abstraction
"""
from __future__ import annotations

import json
import time
from collections import deque
from dataclasses import dataclass
from datetime import datetime, timedelta
from typing import Any, Dict, List, Optional

import requests

from .config import LLMConfig, LLMProvider, get_default_config


@dataclass
class LLMResponse:
    """
    Standardized LLM response container.
    
    Attributes:
        content: The raw text content from the LLM
        json_data: Parsed JSON if response was JSON, else None
        success: Whether the request succeeded
        error: Error message if failed
        model: The model that was used
        usage: Token usage information if available
    """
    content: str
    json_data: Optional[Dict[str, Any]] = None
    success: bool = True
    error: Optional[str] = None
    model: Optional[str] = None
    usage: Optional[Dict[str, int]] = None

    @classmethod
    def from_error(cls, error: str) -> "LLMResponse":
        """Create an error response."""
        return cls(content="", success=False, error=error)


class LLMClient:
    """
    Unified LLM client for all providers.
    
    This class implements the Singleton pattern for configuration
    while allowing multiple instances for different use cases.
    
    Example:
        >>> client = LLMClient()  # Uses default config
        >>> response = client.complete("Translate to Serbian: Hello")
        >>> print(response.content)
        
        >>> response = client.complete_json("Return JSON with name and age")
        >>> print(response.json_data)
    """
    
    _default_instance: Optional["LLMClient"] = None

    def __init__(self, config: Optional[LLMConfig] = None):
        """
        Initialize the LLM client.
        
        Args:
            config: Optional LLMConfig. If not provided, uses default.
        """
        self.config = config or get_default_config()
        self._request_timestamps: deque = deque()
        self._min_delay = 60.0 / max(self.config.rate_limit_rpm, 1)

    @classmethod
    def get_default(cls) -> "LLMClient":
        """Get the default singleton instance."""
        if cls._default_instance is None:
            cls._default_instance = cls()
        return cls._default_instance

    def _wait_for_rate_limit(self) -> None:
        """Ensure we don't exceed rate limits."""
        now = datetime.now()
        
        # Remove timestamps older than 1 minute
        while self._request_timestamps and (now - self._request_timestamps[0]) > timedelta(minutes=1):
            self._request_timestamps.popleft()

        # Wait if at limit
        if len(self._request_timestamps) >= self.config.rate_limit_rpm:
            oldest = self._request_timestamps[0]
            wait_time = 60 - (now - oldest).total_seconds()
            if wait_time > 0:
                time.sleep(wait_time + 0.5)
                # Clean up again after waiting
                now = datetime.now()
                while self._request_timestamps and (now - self._request_timestamps[0]) > timedelta(minutes=1):
                    self._request_timestamps.popleft()

        # Enforce minimum delay between requests
        if self._request_timestamps:
            since_last = (now - self._request_timestamps[-1]).total_seconds()
            if since_last < self._min_delay:
                time.sleep(self._min_delay - since_last)

        self._request_timestamps.append(datetime.now())

    def _build_payload(
        self,
        messages: List[Dict[str, str]],
        json_mode: bool = False,
        max_tokens: Optional[int] = None,
    ) -> Dict[str, Any]:
        """Build the API request payload."""
        payload = {
            "model": self.config.model,
            "messages": messages,
            "temperature": self.config.temperature,
        }
        
        # Set max tokens
        tokens = max_tokens or self.config.max_tokens
        payload["max_tokens"] = tokens
        
        # Add JSON mode if supported and requested
        if json_mode and self.config.provider_config.supports_json_mode:
            payload["response_format"] = {"type": "json_object"}
        
        return payload

    def _parse_response(self, result: Dict[str, Any]) -> LLMResponse:
        """Parse the API response into our standard format."""
        try:
            choices = result.get("choices", [])
            if not choices:
                return LLMResponse.from_error("No choices in response")
            
            message = choices[0].get("message", {})
            content = message.get("content", "").strip()
            
            usage = result.get("usage")
            model = result.get("model")
            
            return LLMResponse(
                content=content,
                success=True,
                model=model,
                usage=usage,
            )
        except Exception as e:
            return LLMResponse.from_error(f"Failed to parse response: {e}")

    def _extract_json(self, text: str) -> Optional[Dict[str, Any]]:
        """Extract and parse JSON from text."""
        text = text.strip()
        
        # Remove markdown code blocks
        if text.startswith("```json"):
            text = text[7:]
        elif text.startswith("```"):
            text = text[3:]
        if text.endswith("```"):
            text = text[:-3]
        text = text.strip()
        
        # Find JSON boundaries
        start = text.find("{")
        end = text.rfind("}")
        
        if start == -1 or end == -1 or end < start:
            return None
        
        json_str = text[start:end + 1]
        
        try:
            return json.loads(json_str)
        except json.JSONDecodeError:
            return None

    def complete(
        self,
        prompt: str,
        system_prompt: Optional[str] = None,
        max_tokens: Optional[int] = None,
    ) -> LLMResponse:
        """
        Send a completion request to the LLM.
        
        Args:
            prompt: The user prompt
            system_prompt: Optional system prompt
            max_tokens: Optional max tokens override
            
        Returns:
            LLMResponse with the completion
        """
        if not self.config.resolved_api_key:
            return LLMResponse.from_error(
                f"API key not found. Set {self.config.provider_config.env_key} in .env"
            )

        messages = []
        if system_prompt:
            messages.append({"role": "system", "content": system_prompt})
        messages.append({"role": "user", "content": prompt})

        return self._make_request(messages, max_tokens=max_tokens)

    def complete_json(
        self,
        prompt: str,
        system_prompt: Optional[str] = None,
        max_tokens: Optional[int] = None,
    ) -> LLMResponse:
        """
        Send a completion request expecting JSON response.
        
        Args:
            prompt: The user prompt (should ask for JSON)
            system_prompt: Optional system prompt
            max_tokens: Optional max tokens override
            
        Returns:
            LLMResponse with json_data populated if valid JSON
        """
        if not self.config.resolved_api_key:
            return LLMResponse.from_error(
                f"API key not found. Set {self.config.provider_config.env_key} in .env"
            )

        # Enhance system prompt for JSON
        json_system = system_prompt or ""
        if json_system:
            json_system += " "
        json_system += "Respond ONLY with valid JSON, no additional text."

        messages = [
            {"role": "system", "content": json_system},
            {"role": "user", "content": prompt},
        ]

        response = self._make_request(messages, json_mode=True, max_tokens=max_tokens)
        
        if response.success and response.content:
            response.json_data = self._extract_json(response.content)
        
        return response

    def complete_with_messages(
        self,
        messages: List[Dict[str, str]],
        json_mode: bool = False,
        max_tokens: Optional[int] = None,
    ) -> LLMResponse:
        """
        Send a completion request with full message history.
        
        Args:
            messages: List of message dicts with role and content
            json_mode: Whether to request JSON response
            max_tokens: Optional max tokens override
            
        Returns:
            LLMResponse with the completion
        """
        if not self.config.resolved_api_key:
            return LLMResponse.from_error(
                f"API key not found. Set {self.config.provider_config.env_key} in .env"
            )

        response = self._make_request(messages, json_mode=json_mode, max_tokens=max_tokens)
        
        if json_mode and response.success and response.content:
            response.json_data = self._extract_json(response.content)
        
        return response

    def _make_request(
        self,
        messages: List[Dict[str, str]],
        json_mode: bool = False,
        max_tokens: Optional[int] = None,
        retry_count: int = 0,
    ) -> LLMResponse:
        """Make the actual API request with retry logic."""
        self._wait_for_rate_limit()

        payload = self._build_payload(messages, json_mode, max_tokens)
        headers = self.config.get_headers()

        try:
            response = requests.post(
                self.config.api_url,
                headers=headers,
                json=payload,
                timeout=self.config.timeout,
            )

            if response.status_code == 429:
                # Rate limited - check for Retry-After header
                retry_after = response.headers.get("Retry-After")
                if retry_after:
                    try:
                        wait_time = int(retry_after)
                    except ValueError:
                        wait_time = 60
                else:
                    wait_time = self.config.retry_delay * (2 ** retry_count) + 5
                
                if retry_count < self.config.max_retries:
                    time.sleep(wait_time)
                    return self._make_request(messages, json_mode, max_tokens, retry_count + 1)
                
                # Parse error message for more details
                try:
                    error_data = response.json()
                    error_msg = error_data.get("error", {}).get("message", response.text[:200])
                except Exception:
                    error_msg = response.text[:200]
                return LLMResponse.from_error(f"Rate limited: {error_msg}")

            if response.status_code != 200:
                error_text = response.text[:500]
                if retry_count < self.config.max_retries:
                    time.sleep(self.config.retry_delay)
                    return self._make_request(messages, json_mode, max_tokens, retry_count + 1)
                return LLMResponse.from_error(f"API error {response.status_code}: {error_text}")

            result = response.json()
            return self._parse_response(result)

        except requests.exceptions.Timeout:
            if retry_count < self.config.max_retries:
                time.sleep(self.config.retry_delay)
                return self._make_request(messages, json_mode, max_tokens, retry_count + 1)
            return LLMResponse.from_error("Request timed out")

        except Exception as e:
            if retry_count < self.config.max_retries:
                time.sleep(self.config.retry_delay)
                return self._make_request(messages, json_mode, max_tokens, retry_count + 1)
            return LLMResponse.from_error(f"Request failed: {e}")


# Convenience functions for simple usage
def complete(prompt: str, system_prompt: Optional[str] = None) -> str:
    """Simple completion - returns text or empty string on error."""
    response = LLMClient.get_default().complete(prompt, system_prompt)
    return response.content if response.success else ""


def complete_json(prompt: str, system_prompt: Optional[str] = None) -> Optional[Dict[str, Any]]:
    """Simple JSON completion - returns dict or None on error."""
    response = LLMClient.get_default().complete_json(prompt, system_prompt)
    return response.json_data
