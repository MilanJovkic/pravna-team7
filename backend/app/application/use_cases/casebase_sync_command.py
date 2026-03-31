"""Application use case for explicit CBR case-base synchronization."""
from __future__ import annotations

from backend.app.ports.outbound.cbr_engine import CbrEngine


class SyncCasebaseUseCase:
    """Trigger CBR case-base synchronization via outbound engine port."""

    def __init__(self, cbr_engine: CbrEngine) -> None:
        self._cbr_engine = cbr_engine

    def execute(self) -> None:
        self._cbr_engine.sync_case_base()
