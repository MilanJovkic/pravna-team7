"""Gateway wrapper for verdict text generation and fallback handling."""

from __future__ import annotations

from typing import Callable


class TextGenerationGateway:
    """Executes text generation with consistent fallback semantics."""

    def __init__(self, generator: object) -> None:
        self.generator = generator

    def generate(self, prompt: str, fallback_factory: Callable[[], str]) -> tuple[str, bool, str | None]:
        if getattr(self.generator, "offline", False):
            return fallback_factory(), True, "offline_mode"
        try:
            generated = self.generator.generate(prompt)
            return generated, False, None
        except Exception as exc:
            return fallback_factory(), True, str(exc)