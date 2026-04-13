"""Centralized LLM configuration module.

This module provides a single source of truth for all LLM-related settings.
All other modules should import from here rather than defining their own defaults.
"""
import os
from dataclasses import dataclass
from typing import Optional

from dotenv import load_dotenv


@dataclass(frozen=True)
class LLMConfig:
    """Immutable configuration for LLM providers."""
    
    model: str
    provider: str
    api_token: Optional[str]
    api_url: str
    
    # Rate limiting
    max_requests_per_minute: int = 10
    min_delay_between_requests: float = 6.0
    max_retries: int = 3
    retry_delay: float = 2.0
    http_timeout: float = 45.0
    
    # OpenAI specific
    openai_service_tier: Optional[str] = None
    
    @property
    def is_offline(self) -> bool:
        """Check if API token is missing."""
        return not self.api_token


# Default model - SINGLE PLACE TO CHANGE
DEFAULT_MODEL = "gpt-4o-mini"
DEFAULT_PROVIDER = "openai"


def get_llm_config(
    model: Optional[str] = None,
    provider: Optional[str] = None,
    api_token: Optional[str] = None,
) -> LLMConfig:
    """
    Factory function to create LLM configuration.
    
    Precedence (highest to lowest):
    1. Explicit parameters
    2. Environment variables
    3. Module defaults
    
    Args:
        model: LLM model name (e.g., "gpt-4o-mini")
        provider: Provider name ("openai", "openrouter", "github")
        api_token: API token for authentication
        
    Returns:
        LLMConfig instance with resolved settings
    """
    load_dotenv()
    
    # Resolve model
    resolved_model = model or os.getenv("LLM_MODEL") or os.getenv("VERDICT_LLM_MODEL") or DEFAULT_MODEL
    
    # Resolve provider
    resolved_provider = (provider or os.getenv("LLM_PROVIDER") or os.getenv("VERDICT_LLM_PROVIDER") or DEFAULT_PROVIDER).lower()
    
    # Resolve API token and URL based on provider
    if resolved_provider == "openrouter":
        resolved_token = api_token or os.getenv("OPENROUTER_API_KEY")
        api_url = "https://openrouter.ai/api/v1/chat/completions"
    elif resolved_provider == "openai":
        resolved_token = api_token or os.getenv("OPENAI_API_KEY")
        api_url = "https://api.openai.com/v1/chat/completions"
    else:  # github
        resolved_token = api_token or os.getenv("GITHUB_TOKEN")
        api_url = "https://models.inference.ai.azure.com/chat/completions"
    
    # Get timeout and service tier from env
    http_timeout = float(os.getenv("LLM_HTTP_TIMEOUT_SECONDS") or os.getenv("VERDICT_LLM_HTTP_TIMEOUT_SECONDS") or "45")
    service_tier = os.getenv("OPENAI_SERVICE_TIER") or os.getenv("VERDICT_OPENAI_SERVICE_TIER") or None
    if service_tier:
        service_tier = service_tier.strip() or None
    
    return LLMConfig(
        model=resolved_model,
        provider=resolved_provider,
        api_token=resolved_token,
        api_url=api_url,
        http_timeout=http_timeout,
        openai_service_tier=service_tier,
    )


def is_gpt5_model(model: str) -> bool:
    """Check if the model is a GPT-5 series model (requires different API params)."""
    return model.startswith("gpt-5")
