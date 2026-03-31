"""Unit tests for rule/CBR engine adapters."""
from __future__ import annotations

import unittest
from unittest.mock import Mock

from backend.app.infrastructure.engines.policies import CircuitOpenError, ExternalEnginePolicy
from backend.app.infrastructure.engines.cbr.jcolibri_adapter import JColibriCbrEngineAdapter
from backend.app.infrastructure.engines.rules.dr_device_adapter import DrDeviceRuleEngineAdapter
from backend.app.models.schemas import CaseFacts


class TestEngineAdapters(unittest.TestCase):
    """Verify adapters delegate to legacy services without behavior changes."""

    def test_rule_engine_adapter_delegates_run(self) -> None:
        mocked_service = Mock()
        mocked_result = Mock()
        mocked_service.run.return_value = mocked_result
        adapter = DrDeviceRuleEngineAdapter(service=mocked_service)

        facts = CaseFacts(defendant="A B")
        result = adapter.run(facts=facts, strict_mode=False)

        self.assertIs(mocked_result, result)
        mocked_service.run.assert_called_once_with(facts=facts, strict_mode=False)

    def test_cbr_engine_adapter_delegates_query(self) -> None:
        mocked_service = Mock()
        mocked_result = Mock()
        mocked_service.query.return_value = mocked_result
        adapter = JColibriCbrEngineAdapter(service=mocked_service)

        facts = CaseFacts(defendant="A B")
        result = adapter.query(facts=facts, top_k=7)

        self.assertIs(mocked_result, result)
        mocked_service.sync_case_base.assert_called_once()
        mocked_service.query.assert_called_once_with(facts=facts, top_k=7)

    def test_cbr_engine_adapter_delegates_sync_case_base(self) -> None:
        mocked_service = Mock()
        adapter = JColibriCbrEngineAdapter(service=mocked_service)

        adapter.sync_case_base()

        mocked_service.sync_case_base.assert_called_once()

    def test_rule_engine_adapter_retries_once_then_succeeds(self) -> None:
        mocked_service = Mock()
        mocked_result = Mock()
        mocked_service.run.side_effect = [RuntimeError("temp-fail"), mocked_result]
        adapter = DrDeviceRuleEngineAdapter(
            service=mocked_service,
            policy=ExternalEnginePolicy(max_retries=1, open_after_failures=5, reset_timeout_seconds=60.0),
        )

        facts = CaseFacts(defendant="A B")
        result = adapter.run(facts=facts, strict_mode=True)

        self.assertIs(mocked_result, result)
        self.assertEqual(2, mocked_service.run.call_count)

    def test_cbr_engine_adapter_opens_circuit_after_threshold(self) -> None:
        mocked_service = Mock()
        mocked_service.query.side_effect = RuntimeError("hard-fail")
        adapter = JColibriCbrEngineAdapter(
            service=mocked_service,
            policy=ExternalEnginePolicy(max_retries=0, open_after_failures=1, reset_timeout_seconds=60.0),
        )

        facts = CaseFacts(defendant="A B")
        with self.assertRaises(RuntimeError):
            adapter.query(facts=facts, top_k=3)

        with self.assertRaises(CircuitOpenError):
            adapter.query(facts=facts, top_k=3)

        self.assertEqual(1, mocked_service.query.call_count)


if __name__ == "__main__":
    unittest.main()
