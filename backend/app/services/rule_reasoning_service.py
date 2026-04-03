"""Rule-based reasoning service using dr-device."""
from __future__ import annotations

from pathlib import Path
import subprocess
import xml.etree.ElementTree as ET
import re

from backend.app.models.schemas import CaseFacts, RuleReasoningResult
from backend.app.services.cbr_normalization import bool_to_text, normalize_ascii
from backend.app.services.rule_artifact_validator import validate_rule_artifacts
from backend.app.domain.rulebase_generation.rule_reasoning_adapter import (
    create_adapter_singleton,
    DynamicPriorityInferencer,
)


ROOT = Path(__file__).resolve().parents[3]
DR_DEVICE_DIR = ROOT / "dr-device" / "dr-device"
FACTS_PATH = DR_DEVICE_DIR / "facts.rdf"
EXPORT_PATH = DR_DEVICE_DIR / "export.rdf"
RULEBASE_PATH = DR_DEVICE_DIR / "rulebase.clp"

class RuleReasoningService:
    """Service that runs dr-device reasoning on provided facts."""

    def __init__(self) -> None:
        self._adapter = None
        self._priority_inferencer = None
        try:
            self._adapter = create_adapter_singleton()
            self._priority_inferencer = DynamicPriorityInferencer(self._adapter)
        except Exception:
            self._adapter = None
            self._priority_inferencer = None

    def run(self, facts: CaseFacts, strict_mode: bool = True) -> RuleReasoningResult:
        if self._adapter is not None:
            # Keep CLP in sync with generator while relying on adapter cache.
            self._adapter.regenerate()

        artifact_errors = validate_rule_artifacts(DR_DEVICE_DIR)
        if artifact_errors:
            message = "; ".join(artifact_errors)
            raise ValueError(f"Rule artifact validation failed: {message}")

        self._sync_export_norms()
        self._write_facts(facts)
        self._run_dr_device()
        return self._parse_export(facts, strict_mode)

    def _normalize(self, value: str) -> str:
        normalized = normalize_ascii(value)
        return normalized or ""

    def _write_facts(self, facts: CaseFacts) -> None:
        defendant = (facts.defendant or "Unknown").strip()
        values: dict[str, str | list[str] | None] = {
            "defendant": self._normalize(defendant),
            "injury_type": self._normalize(facts.injury_type.strip()) if facts.injury_type else None,
            "location": self._normalize(facts.location.strip()) if facts.location else None,
            "weapon": self._normalize(facts.weapon.strip()) if facts.weapon else None,
            "weapon_used": self._bool_value(facts.weapon_used),
            "severe_consequence": self._bool_value(facts.severe_consequence),
            "death_result": self._bool_value(facts.death_result),
            "negligence": self._bool_value(facts.negligence),
            "provocation": self._bool_value(facts.provocation),
            "fight_participation": self._bool_value(facts.fight_participation),
            "fight_consequence": self._normalize(facts.fight_consequence.strip()) if facts.fight_consequence else None,
            "left_without_help": self._bool_value(facts.left_without_help),
            "victim_status": self._normalized_list(facts.victim_status),
            "victim_health_state": self._normalize_optional_text(facts.victim_health_state),
            "victim_accountability": self._normalize_optional_text(facts.victim_accountability),
            "victim_previously_abused": self._bool_value(facts.victim_previously_abused),
            "victim_count": self._normalize_optional_text(facts.victim_count),
            "victim_explicit_request": self._normalize_optional_text(facts.victim_explicit_request),
            "victim_subordination": self._bool_value(facts.victim_subordination),
            "life_consequence_type": self._normalize_optional_text(facts.life_consequence_type),
            "injury_severity_level": self._normalize_optional_text(facts.injury_severity_level),
            "severe_injury_specific_consequences": self._normalized_list(facts.severe_injury_specific_consequences),
            "danger_to_third_parties": self._bool_value(facts.danger_to_third_parties),
            "suicide_outcome": self._normalize_optional_text(facts.suicide_outcome),
            "abortion_outcomes": self._normalized_list(facts.abortion_outcomes),
            "execution_manner": self._normalized_list(facts.execution_manner),
            "offender_motive": self._normalized_list(facts.offender_motive),
            "provocation_types": self._normalized_list(facts.provocation_types),
            "injury_means_type": self._normalize_optional_text(facts.injury_means_type),
            "victim_consent": self._normalize_optional_text(facts.victim_consent),
            "sterilization_goal": self._normalize_optional_text(facts.sterilization_goal),
            "guilt_form": self._normalize_optional_text(facts.guilt_form),
            "offender_psych_state": self._normalize_optional_text(facts.offender_psych_state),
            "death_attributed_to_negligence": self._normalize_optional_text(facts.death_attributed_to_negligence),
            "danger_caused_by_offender": self._bool_value(facts.danger_caused_by_offender),
            "offender_victim_relationship": self._normalize_optional_text(facts.offender_victim_relationship),
            "help_provision_ability": self._normalize_optional_text(facts.help_provision_ability),
            "failure_to_help_consequence": self._normalize_optional_text(facts.failure_to_help_consequence),
            "duty_connection": self._normalize_optional_text(facts.duty_connection),
            "special_action_types": self._normalized_list(facts.special_action_types),
            "inhuman_treatment": self._bool_value(facts.inhuman_treatment),
        }

        lines = []
        lines.append("<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>")
        lines.append(
            "<rdf:RDF xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\"\n"
            "        xmlns:rdfs=\"http://www.w3.org/2000/01/rdf-schema#\"\n"
            "        xmlns:xsd=\"http://www.w3.org/2001/XMLSchema#\"\n"
            "        xmlns:lc=\"http://ftn.uns.ac.rs/legal-case#\">"
        )
        for key in values.keys():
            lines.append(f"    <rdf:Property rdf:about=\"http://ftn.uns.ac.rs/legal-case#{key}\">")
            lines.append("        <rdfs:domain rdf:resource=\"http://ftn.uns.ac.rs/legal-case#case\" />")
            lines.append("        <rdfs:range rdf:resource=\"http://www.w3.org/2001/XMLSchema#string\" />")
            lines.append("    </rdf:Property>")
        lines.append("")

        lines.append("    <lc:case rdf:about=\"http://ftn.uns.ac.rs/legal-case#case01\">")
        lines.append("        <rdf:type rdf:resource=\"http://ftn.uns.ac.rs/legal-case#case\" />")
        for key, value in values.items():
            if isinstance(value, list):
                for item in value:
                    if item in (None, ""):
                        continue
                    lines.append(f"        <lc:{key}>{self._escape(str(item))}</lc:{key}>")
                continue
            if value in (None, ""):
                continue
            lines.append(f"        <lc:{key}>{self._escape(str(value))}</lc:{key}>")
        lines.append("    </lc:case>")
        lines.append("</rdf:RDF>")

        FACTS_PATH.write_text("\n".join(lines) + "\n", encoding="utf-8")

    def _run_dr_device(self) -> None:
        bat_path = DR_DEVICE_DIR / "start-optimized.bat"
        subprocess.run(
            str(bat_path),
            cwd=str(DR_DEVICE_DIR),
            check=True,
            capture_output=True,
            text=True,
            shell=True,
            timeout=60,
        )

    def _parse_export(self, facts: CaseFacts, strict_mode: bool) -> RuleReasoningResult:
        if not EXPORT_PATH.exists():
            return RuleReasoningResult(strict_mode=strict_mode, status="no_export")

        export_ns = "http://startrek.csd.auth.gr/dr-device/export/export.rdf#"
        defeasible_ns = "http://lpis.csd.auth.gr/systems/dr-device/defeasible.rdfs#"
        ns = {"export": export_ns, "def": defeasible_ns}

        tree = ET.parse(EXPORT_PATH)
        root = tree.getroot()

        requested_defendant = self._normalize((facts.defendant or "").strip())
        norms = []
        proofs = []

        for elem in root:
            if not elem.tag.startswith(f"{{{export_ns}}}"):
                continue
            norm_name = elem.tag.replace(f"{{{export_ns}}}", "")
            truth_status = elem.find("def:truthStatus", ns)
            if truth_status is None or (truth_status.text or "").strip() != "defeasibly-proven-positive":
                continue
            if requested_defendant:
                def_elem = elem.find("export:defendant", ns)
                def_value = (def_elem.text or "").strip() if def_elem is not None else ""
                if def_value != requested_defendant:
                    continue
            if norm_name not in norms:
                norms.append(norm_name)
            proof_elem = elem.find("def:proof", ns)
            if proof_elem is not None and proof_elem.text:
                proofs.append(proof_elem.text.strip())

        return self._finalize_result(norms, proofs, facts, strict_mode)

    def _finalize_result(
        self,
        norms: list[str],
        proofs: list[str],
        facts: CaseFacts,
        strict_mode: bool,
    ) -> RuleReasoningResult:
        norms = self._resolve_norm_conflicts(norms)
        if norms:
            return RuleReasoningResult(
                applied_norms=norms,
                proofs=proofs,
                strict_mode=strict_mode,
                status="ok",
            )

        fallback_norms = self._infer_legal_fallback_norms(facts)
        if fallback_norms:
            return RuleReasoningResult(
                applied_norms=fallback_norms,
                proofs=proofs,
                strict_mode=strict_mode,
                status="ok",
            )

        _ = facts  # kept for signature compatibility with existing tests/callers
        return RuleReasoningResult(
            applied_norms=[],
            proofs=[],
            strict_mode=strict_mode,
            status="no_proof",
        )

    def _infer_legal_fallback_norms(self, facts: CaseFacts) -> list[str]:
        if facts.life_consequence_type == "smrt_nastupila" or facts.death_result is True:
            return ["crime_art143"]
        return []

    def _escape(self, value: str) -> str:
        return (
            value.replace("&", "&amp;")
            .replace("<", "&lt;")
            .replace(">", "&gt;")
            .replace('"', "&quot;")
            .replace("'", "&apos;")
        )

    def _bool_value(self, value: bool | None) -> str | None:
        return bool_to_text(value)

    def _normalize_optional_text(self, value: str | None) -> str | None:
        if not value:
            return None
        return self._normalize(value.strip())

    def _normalized_list(self, values: list[str] | None) -> list[str]:
        if not values:
            return []
        normalized: list[str] = []
        for value in values:
            text = self._normalize_optional_text(value)
            if text:
                normalized.append(text)
        return normalized

    def _resolve_norm_conflicts(self, norms: list[str]) -> list[str]:
        if not norms:
            return []

        priorities: dict[str, int] = {}
        families: dict[str, set[str]] = {}

        if self._priority_inferencer is not None:
            priorities = self._priority_inferencer.get_all_priorities()
        if self._adapter is not None:
            families = self._adapter.get_dynamic_families()

        family_by_norm = {
            norm: family_name
            for family_name, norm_set in families.items()
            for norm in norm_set
        }

        seen: set[str] = set()
        for norm in norms:
            if norm not in seen:
                seen.add(norm)

        winners: dict[str, tuple[str, int]] = {}
        passthrough: list[str] = []

        for norm in seen:
            family = family_by_norm.get(norm)
            score = priorities.get(norm, 50)
            if not family:
                passthrough.append(norm)
                continue
            current = winners.get(family)
            if current is None or score > current[1] or (score == current[1] and norm < current[0]):
                winners[family] = (norm, score)

        merged = passthrough + [value[0] for value in winners.values()]

        def sort_key(norm: str) -> tuple[int, str]:
            match = re.search(r"crime_art(\d+)", norm)
            article_num = int(match.group(1)) if match else 10_000
            return (article_num, norm)

        return sorted(merged, key=sort_key)

    def _sync_export_norms(self) -> None:
        if not RULEBASE_PATH.exists():
            return

        text = RULEBASE_PATH.read_text(encoding="utf-8")
        block_pattern = re.compile(
            r"\(defeasiblerule\s+rule\d+\s*(.*?)\n\)\s*(?=\n\(defeasiblerule|\Z)",
            re.S,
        )
        then_pattern = re.compile(r"=>\s*\((crime_art[0-9a-zA-Z_]+)")

        norms: set[str] = set()
        for block in block_pattern.findall(text):
            match = then_pattern.search(block)
            if match:
                norms.add(match.group(1))

        if not norms:
            return

        sorted_norms = sorted(norms, key=lambda item: (int(re.search(r"crime_art(\d+)", item).group(1)), item))
        export_line = "\t\t(export-rdf export.rdf  " + " ".join(sorted_norms) + ")"
        updated = re.sub(
            r"^\s*\(export-rdf\s+export\.rdf\s+.*?\)\s*$",
            export_line,
            text,
            count=1,
            flags=re.M,
        )
        if updated != text:
            RULEBASE_PATH.write_text(updated, encoding="utf-8")

