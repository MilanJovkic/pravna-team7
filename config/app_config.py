"""
Application configuration management.

Centralizes all configuration settings.
"""

import os
from dataclasses import dataclass
from typing import Optional
from dotenv import load_dotenv


@dataclass
class LLMConfig:
    """LLM provider configuration."""
    provider: str = "github"
    model: str = "gpt-4o"
    api_token: Optional[str] = None
    max_requests_per_minute: int = 10
    max_retries: int = 3


@dataclass
class ParserConfig:
    """Parser configuration."""
    # Future: add parser-specific settings
    pass


@dataclass
class ExporterConfig:
    """Exporter configuration."""
    law_name: str = "Krivični zakonik Crne Gore"
    country_code: str = "me"
    law_year: str = "2024"


@dataclass
class ApplicationConfig:
    """Main application configuration."""
    llm: LLMConfig
    parser: ParserConfig
    exporter: ExporterConfig
    
    @staticmethod
    def from_env() -> 'ApplicationConfig':
        """
        Create configuration from environment variables.
        
        Returns:
            ApplicationConfig instance
        """
        load_dotenv()
        
        # LLM configuration
        provider = os.getenv("LLM_PROVIDER", "github")
        model = os.getenv("LLM_MODEL", "gpt-4o")
        
        if provider == "openrouter":
            api_token = os.getenv("OPENROUTER_API_KEY")
        else:
            api_token = os.getenv("GITHUB_TOKEN")
        
        llm_config = LLMConfig(
            provider=provider,
            model=model,
            api_token=api_token,
            max_requests_per_minute=int(os.getenv("LLM_MAX_REQUESTS_PER_MINUTE", "10")),
            max_retries=int(os.getenv("LLM_MAX_RETRIES", "3"))
        )
        
        # Parser configuration
        parser_config = ParserConfig()
        
        # Exporter configuration
        exporter_config = ExporterConfig(
            law_name=os.getenv("LAW_NAME", "Krivični zakonik Crne Gore"),
            country_code=os.getenv("COUNTRY_CODE", "me"),
            law_year=os.getenv("LAW_YEAR", "2024")
        )
        
        return ApplicationConfig(
            llm=llm_config,
            parser=parser_config,
            exporter=exporter_config
        )
    
    def validate(self) -> bool:
        """
        Validate configuration.
        
        Returns:
            True if configuration is valid
            
        Raises:
            ValueError: If configuration is invalid
        """
        if not self.llm.api_token:
            raise ValueError(
                f"API token not found for provider: {self.llm.provider}. "
                f"Please set {'OPENROUTER_API_KEY' if self.llm.provider == 'openrouter' else 'GITHUB_TOKEN'} in .env file."
            )
        
        return True
