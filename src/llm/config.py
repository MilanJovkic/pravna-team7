"""
LLM Configuration Module.

Centralizes all LLM-related configuration following the Single Responsibility Principle.
All model names, endpoints, and settings are defined here.
"""
from __future__ import annotations

import os
from dataclasses import dataclass, field
from enum import Enum
from typing import Optional

from dotenv import load_dotenv


class LLMProvider(Enum):
    """Supported LLM providers."""
    OPENAI = "openai"
    OPENROUTER = "openrouter"
    GITHUB = "github"


@dataclass(frozen=True)
class ProviderConfig:
    """Configuration for a specific LLM provider."""
    name: str
    api_url: str
    env_key: str
    default_model: str
    supports_json_mode: bool = True
    extra_headers: dict = field(default_factory=dict)


# Provider configurations
PROVIDER_CONFIGS = {
    LLMProvider.OPENAI: ProviderConfig(
        name="OpenAI",
        api_url="https://api.openai.com/v1/chat/completions",
        env_key="OPENAI_API_KEY",
        default_model="gpt-4o-mini",
        supports_json_mode=True,
    ),
    LLMProvider.OPENROUTER: ProviderConfig(
        name="OpenRouter",
        api_url="https://openrouter.ai/api/v1/chat/completions",
        env_key="OPENROUTER_API_KEY",
        default_model="openai/gpt-4o-mini",
        supports_json_mode=True,
        extra_headers={
            "HTTP-Referer": "https://github.com/pravna-team7",
            "X-Title": "Legal Annotation System",
        },
    ),
    LLMProvider.GITHUB: ProviderConfig(
        name="GitHub Models",
        api_url="https://models.inference.ai.azure.com/chat/completions",
        env_key="GITHUB_TOKEN",
        default_model="gpt-4o-mini",
        supports_json_mode=False,
    ),
}

# Model mapping for compatibility
MODEL_ALIASES = {
    "gpt-5-nano": "gpt-4o-mini",
    "gpt-5": "gpt-4o",
    "gpt-5-mini": "gpt-4o-mini",
}


@dataclass
class LLMConfig:
    """
    Main LLM configuration class.
    
    Attributes:
        provider: The LLM provider to use
        model: The model name (will be normalized)
        api_key: Optional API key override
        temperature: Generation temperature (0.0-1.0)
        max_tokens: Maximum tokens in response
        timeout: HTTP timeout in seconds
        max_retries: Number of retry attempts
        retry_delay: Delay between retries in seconds
        rate_limit_rpm: Requests per minute limit
    """
    provider: LLMProvider = LLMProvider.OPENAI
    model: str = "gpt-4o-mini"
    api_key: Optional[str] = None
    temperature: float = 0.1
    max_tokens: int = 2000
    timeout: float = 60.0
    max_retries: int = 3
    retry_delay: float = 2.0
    rate_limit_rpm: int = 10

    def __post_init__(self):
        # Normalize model name using aliases
        if self.model in MODEL_ALIASES:
            object.__setattr__(self, "model", MODEL_ALIASES[self.model])

    @property
    def provider_config(self) -> ProviderConfig:
        """Get the provider-specific configuration."""
        return PROVIDER_CONFIGS[self.provider]

    @property
    def api_url(self) -> str:
        """Get the API URL for the configured provider."""
        return self.provider_config.api_url

    @property
    def resolved_api_key(self) -> Optional[str]:
        """Get the API key, checking environment if not set."""
        if self.api_key:
            return self.api_key
        # Use override=True to ensure .env takes precedence over system env
        load_dotenv(override=True)
        return os.getenv(self.provider_config.env_key)

    def get_headers(self) -> dict:
        """Get HTTP headers for API requests."""
        headers = {
            "Content-Type": "application/json",
            "Authorization": f"Bearer {self.resolved_api_key}",
        }
        headers.update(self.provider_config.extra_headers)
        return headers


def get_default_config(
    provider: str = "openai",
    model: Optional[str] = None,
) -> LLMConfig:
    """
    Create a default LLM configuration.
    
    Args:
        provider: Provider name (openai, openrouter, github)
        model: Optional model override
        
    Returns:
        Configured LLMConfig instance
    """
    # Use override=True to ensure .env takes precedence over system env
    load_dotenv(override=True)
    
    # Get provider enum
    try:
        provider_enum = LLMProvider(provider.lower())
    except ValueError:
        provider_enum = LLMProvider.OPENAI
    
    # Get model from env or use default
    if model is None:
        model = os.getenv("LLM_MODEL", PROVIDER_CONFIGS[provider_enum].default_model)
    
    # Normalize model aliases
    if model in MODEL_ALIASES:
        model = MODEL_ALIASES[model]
    
    return LLMConfig(
        provider=provider_enum,
        model=model,
        timeout=float(os.getenv("LLM_TIMEOUT", "60")),
        max_retries=int(os.getenv("LLM_MAX_RETRIES", "3")),
    )
