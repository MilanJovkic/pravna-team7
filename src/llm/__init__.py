"""
Centralized LLM Client Module.

This module implements a clean architecture approach for LLM interactions,
following SOLID principles:
- Single Responsibility: Each class has one job
- Open/Closed: Extendable for new providers without modification
- Liskov Substitution: All providers implement same interface
- Interface Segregation: Clean, minimal interface
- Dependency Inversion: Depend on abstractions, not concretions
"""
from .client import LLMClient, LLMResponse, complete, complete_json
from .config import LLMConfig, LLMProvider, get_default_config

__all__ = [
    "LLMClient",
    "LLMResponse",
    "LLMConfig",
    "LLMProvider",
    "get_default_config",
    "complete",
    "complete_json",
]
