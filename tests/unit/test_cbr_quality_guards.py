from __future__ import annotations

from pathlib import Path

import pytest

from backend.app.application.use_cases.reasoning_commands import RunHybridReasoningUseCase
from backend.app.domain.shared.errors import ExternalServiceError
from backend.app.models.schemas import CaseFacts, CbrMatch, CbrResult, ReasoningRequest, RuleReasoningResult
from backend.app.services.cbr_service import BOOLEAN_COLUMNS, CbrService
from import_facts_to_db import (
    _canonical_fact_key,
    _normalize_case_number,
    extract_facts_from_xml,
    parse_boolean,
)


class _DummyRuleEngine:
    def run(self, facts, strict_mode=True):
        raise NotImplementedError


class _DummyCbrEngine:
    def query(self, facts, top_k):
        raise NotImplementedError


class _RuleOkEngine:
    def run(self, facts, strict_mode=True):
        return RuleReasoningResult(
            applied_norms=["KZCG-151"],
            proofs=["ok"],
            strict_mode=strict_mode,
            status="ok",
        )


class _CbrOkEngine:
    def query(self, facts, top_k):
        return CbrResult(
            matches=[
                CbrMatch(
                    case_number="K.br. 1/24",
                    similarity=0.85,
                    outcome="osudjen",
                    feature_contributions={},
                )
            ]
        )


class _FailingRuleEngine:
    def run(self, facts, strict_mode=True):
        raise RuntimeError("rule broken")


class _FailingCbrEngine:
    def query(self, facts, top_k):
        raise RuntimeError("cbr broken")


class _DummyExplainService:
    def map_norms_to_articles(self, norms):
        return []

    def get_applied_law_texts(self, article_numbers, norms=None):
        return []


class _DummyDecisionSelector:
    def decide(self, norms, cbr, rule_available=True, cbr_available=True):
        return "odbijeno"


class _DummyPolicy:
    def suggest_sanction(self, article_numbers, facts, norms=None, verdict=None):
        return None

    def build_confidence_report(self, norms, cbr, suggested_verdict, subsystem_status=None):
        return None


class _DummyValidator:
    def validate(self, request):
        return None


class _FakeCursor:
    def __init__(self, row):
        self._row = row
        self.last_query = ""

    def execute(self, query):
        self.last_query = query

    def fetchone(self):
        return self._row


def _build_use_case(rule_engine=None, cbr_engine=None) -> RunHybridReasoningUseCase:
    return RunHybridReasoningUseCase(
        rule_engine=rule_engine or _DummyRuleEngine(),
        cbr_engine=cbr_engine or _DummyCbrEngine(),
        explain_service=_DummyExplainService(),
        decision_selector=_DummyDecisionSelector(),
        reasoning_policy=_DummyPolicy(),
        input_validator=_DummyValidator(),
    )


def _legacy_false_row(total: int = 58) -> list[int]:
    row = [total]
    for _ in BOOLEAN_COLUMNS:
        row.extend([0, 0])
    return row


def test_import_parse_boolean_preserves_unknown_as_none() -> None:
    assert parse_boolean("da") is True
    assert parse_boolean("ne") is False
    assert parse_boolean("nepoznato") is None
    assert parse_boolean(None) is None


def test_import_fact_alias_mapping_supports_camel_and_snake_case() -> None:
    assert _canonical_fact_key("weaponUsed") == "weapon_used"
    assert _canonical_fact_key("fight_participation") == "fight_participation"
    assert _canonical_fact_key("fightConsequence") == "fight_consequence"


def test_import_case_number_falls_back_to_file_stem_when_invalid() -> None:
    assert _normalize_case_number("K.br. 12/23", "CASE-STEM") == "K.br. 12/23"
    assert _normalize_case_number(".", "CASE-STEM") == "CASE-STEM"
    assert _normalize_case_number("", "CASE-STEM") == "CASE-STEM"


def test_import_extracts_injury_and_severe_consequence_from_narrative(tmp_path: Path) -> None:
        xml_file = tmp_path / "CASE-617.xml"
        xml_file.write_text(
                """
<akomaNtoso xmlns="http://docs.oasis-open.org/legaldocml/ns/akn/3.0/WD17">
    <judgment>
        <docNumber>K.br. 617/13</docNumber>
        <judgmentBody>
            <facts>
                <fact key="location">Podgorica</fact>
            </facts>
            <decision>
                <block name="verdict" outcome="osudjen">
                    <p>Okrivljeni je oglašen krivim za tešku tjelesnu povredu.</p>
                </block>
            </decision>
        </judgmentBody>
    </judgment>
</akomaNtoso>
""".strip(),
                encoding="utf-8",
        )

        facts = extract_facts_from_xml(xml_file)

        assert facts["case_number"] == "K.br. 617/13"
        assert parse_boolean(facts.get("severe_consequence")) is True
        injury = (facts.get("injury_type") or "").lower().replace("š", "s")
        assert "tesk" in injury
        assert (facts.get("location") or "").lower() == "podgorica"


def test_import_infers_outcome_from_verdict_text_when_attribute_unknown(tmp_path: Path) -> None:
        xml_file = tmp_path / "CASE-OUTCOME.xml"
        xml_file.write_text(
                """
<akomaNtoso xmlns="http://docs.oasis-open.org/legaldocml/ns/akn/3.0/WD17">
    <judgment>
        <judgmentBody>
            <decision>
                <block name="verdict" outcome="nepoznato">
                    <p>Okrivljeni je oglašen krivim.</p>
                </block>
            </decision>
        </judgmentBody>
    </judgment>
</akomaNtoso>
""".strip(),
                encoding="utf-8",
        )

        facts = extract_facts_from_xml(xml_file)
        assert facts.get("outcome") == "osudjen"


def test_import_infers_fight_and_negligence_from_narrative(tmp_path: Path) -> None:
        xml_file = tmp_path / "CASE-FIGHT.xml"
        xml_file.write_text(
                """
<akomaNtoso xmlns="http://docs.oasis-open.org/legaldocml/ns/akn/3.0/WD17">
    <judgment>
        <judgmentBody>
            <introduction>
                <block name="summary">
                    <p>Okrivljeni je kriv za učestvovanje u tuči i ubistvo iz nehata.</p>
                </block>
            </introduction>
            <decision>
                <block name="verdict" outcome="nepoznato">
                    <p>Kriv je.</p>
                </block>
            </decision>
        </judgmentBody>
    </judgment>
</akomaNtoso>
""".strip(),
                encoding="utf-8",
        )

        facts = extract_facts_from_xml(xml_file)
        assert parse_boolean(facts.get("fight_participation")) is True
        assert parse_boolean(facts.get("negligence")) is True
        assert facts.get("outcome") == "osudjen"


def test_cbr_service_extract_facts_sanitizes_case_number_and_aliases(tmp_path: Path) -> None:
    xml_file = tmp_path / "CASE-001.xml"
    xml_file.write_text(
        """
<akomaNtoso xmlns="http://docs.oasis-open.org/legaldocml/ns/akn/3.0/WD17">
  <judgment>
    <docNumber>.</docNumber>
    <judgmentBody>
      <facts>
        <fact key="weaponUsed">da</fact>
        <fact key="fightConsequence">none</fact>
      </facts>
      <decision>
        <block name="verdict" outcome="osudjen">
          <p>text</p>
        </block>
      </decision>
    </judgmentBody>
  </judgment>
</akomaNtoso>
""".strip(),
        encoding="utf-8",
    )

    service = CbrService()
    facts = service._extract_facts(xml_file)

    assert facts["case_number"] == "CASE-001"
    assert facts["weapon_used"] == "da"
    assert facts["fight_consequence"] == "none"


def test_cbr_service_detects_legacy_false_defaults() -> None:
    service = CbrService()
    cursor = _FakeCursor(_legacy_false_row())

    assert service._has_legacy_false_defaults(cursor) is True


def test_cbr_service_does_not_flag_nullable_booleans_as_legacy() -> None:
    service = CbrService()
    row = [58]
    for _ in BOOLEAN_COLUMNS:
        row.extend([58, 0])
    cursor = _FakeCursor(row)

    assert service._has_legacy_false_defaults(cursor) is False


def test_cbr_dampening_counts_only_cbr_features() -> None:
    use_case = _build_use_case()
    facts = CaseFacts(
        location="Podgorica",
        victim_status=["x"],
        execution_manner=["podmukao"],
        duty_connection="duznost",
        danger_to_life=True,
    )

    cbr = CbrResult(
        matches=[
            CbrMatch(
                case_number="K.br. 1/24",
                similarity=1.0,
                outcome="osudjen",
                feature_contributions={},
            )
        ]
    )

    dampened = use_case._apply_cbr_dampening(cbr, facts)
    assert dampened.matches[0].similarity == 0.2


def test_cbr_dampening_keeps_strength_when_enough_cbr_features_present() -> None:
    use_case = _build_use_case()
    facts = CaseFacts(
        injury_type="teska tjelesna povreda",
        location="Podgorica",
        weapon="noz",
        weapon_used=True,
        severe_consequence=True,
        death_result=False,
    )

    cbr = CbrResult(
        matches=[
            CbrMatch(
                case_number="K.br. 2/24",
                similarity=0.82,
                outcome="osudjen",
                feature_contributions={},
            )
        ]
    )

    dampened = use_case._apply_cbr_dampening(cbr, facts)
    assert dampened.matches[0].similarity == 0.82


def test_hybrid_reasoning_raises_when_cbr_fails() -> None:
    use_case = _build_use_case(rule_engine=_RuleOkEngine(), cbr_engine=_FailingCbrEngine())
    request = ReasoningRequest(facts=CaseFacts(location="Podgorica"), top_k=5, strict_mode=True)

    with pytest.raises(ExternalServiceError, match="cbr_error="):
        use_case.execute(request)


def test_hybrid_reasoning_raises_when_rule_fails() -> None:
    use_case = _build_use_case(rule_engine=_FailingRuleEngine(), cbr_engine=_CbrOkEngine())
    request = ReasoningRequest(facts=CaseFacts(location="Podgorica"), top_k=5, strict_mode=True)

    with pytest.raises(ExternalServiceError, match="rule_error="):
        use_case.execute(request)
