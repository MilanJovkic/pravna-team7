"""Adapter for legacy LLM config module access."""

from __future__ import annotations

from typing import Optional

from backend.app.infrastructure.llm.config import LLMConfig, get_llm_config, is_gpt5_model


def resolve_llm_config(
    model: Optional[str] = None,
    provider: Optional[str] = None,
    api_token: Optional[str] = None,
) -> LLMConfig:
    """Resolve LLM configuration via legacy config provider."""
    return get_llm_config(model=model, provider=provider, api_token=api_token)


def uses_gpt5_model(model: str) -> bool:
    """Check whether model requires GPT-5 compatible completion parameter."""
    return is_gpt5_model(model)
