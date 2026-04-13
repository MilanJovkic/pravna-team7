"""Centralized LLM configuration for backend infrastructure."""

from __future__ import annotations

import os
from dataclasses import dataclass

from dotenv import load_dotenv


@dataclass(frozen=True)
class LLMConfig:
    """Immutable configuration for LLM providers."""

    model: str
    provider: str
    api_token: str | None
    api_url: str
    max_requests_per_minute: int = 10
    min_delay_between_requests: float = 6.0
    max_retries: int = 3
    retry_delay: float = 2.0
    http_timeout: float = 45.0
    openai_service_tier: str | None = None

    @property
    def is_offline(self) -> bool:
        return not self.api_token


DEFAULT_MODEL = "gpt-4o-mini"
DEFAULT_PROVIDER = "openai"


def get_llm_config(
    model: str | None = None,
    provider: str | None = None,
    api_token: str | None = None,
) -> LLMConfig:
    """Create LLM configuration with explicit param/env/default precedence."""
    load_dotenv()

    resolved_model = model or os.getenv("LLM_MODEL") or os.getenv("VERDICT_LLM_MODEL") or DEFAULT_MODEL
    resolved_provider = (
        provider or os.getenv("LLM_PROVIDER") or os.getenv("VERDICT_LLM_PROVIDER") or DEFAULT_PROVIDER
    ).lower()

    if resolved_provider == "openrouter":
        resolved_token = api_token or os.getenv("OPENROUTER_API_KEY")
        api_url = "https://openrouter.ai/api/v1/chat/completions"
    elif resolved_provider == "openai":
        resolved_token = api_token or os.getenv("OPENAI_API_KEY")
        api_url = "https://api.openai.com/v1/chat/completions"
    else:
        resolved_token = api_token or os.getenv("GITHUB_TOKEN")
        api_url = "https://models.inference.ai.azure.com/chat/completions"

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
    """Return True for GPT-5 model variants using max_completion_tokens."""
    return model.startswith("gpt-5")
