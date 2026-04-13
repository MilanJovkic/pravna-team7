"""Centralized application settings."""
from __future__ import annotations

from functools import lru_cache
from typing import List

from pydantic import Field

try:
    from pydantic_settings import BaseSettings, SettingsConfigDict
except ImportError:  # pragma: no cover - compatibility fallback
    from pydantic import BaseModel

    class BaseSettings(BaseModel):
        """Fallback base when pydantic-settings is unavailable."""

    class SettingsConfigDict(dict):
        """Fallback settings config dict type."""


class AppSettings(BaseSettings):
    """Runtime settings for API bootstrap."""

    app_name: str = "Legal Annotation API"
    app_description: str = "API za pristup anotiranim zakonima i sudskim presudama"
    app_version: str = "1.0.0"

    cors_origins: List[str] = Field(default_factory=lambda: ["http://localhost:4200"])
    log_level: str = "INFO"
    environment: str = "development"

    if isinstance(SettingsConfigDict, type):
        model_config = SettingsConfigDict(
            env_file=".env",
            env_file_encoding="utf-8",
            extra="ignore",
        )


@lru_cache(maxsize=1)
def get_settings() -> AppSettings:
    """Build and cache settings once for process lifetime."""
    return AppSettings()
