"""Bootstrap-level dependency providers for infrastructure adapters."""

from __future__ import annotations

from backend.app.infrastructure.engines.cbr.jcolibri_adapter import JColibriCbrEngineAdapter
from backend.app.infrastructure.engines.rules.dr_device_adapter import DrDeviceRuleEngineAdapter
from backend.app.ports.outbound.cbr_engine import CbrEngine
from backend.app.ports.outbound.rule_engine import RuleEngine


def provide_rule_engine() -> RuleEngine:
    """Provide default RuleEngine adapter instance."""
    return DrDeviceRuleEngineAdapter()


def provide_cbr_engine() -> CbrEngine:
    """Provide default CbrEngine adapter instance."""
    return JColibriCbrEngineAdapter()
