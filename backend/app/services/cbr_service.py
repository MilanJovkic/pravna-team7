"""CBR service for querying jColibri."""
from __future__ import annotations

import json
import logging
import os
from pathlib import Path
import subprocess
import xml.etree.ElementTree as ET

import psycopg2
from psycopg2.extras import execute_values

from backend.app.models.schemas import CaseFacts, CbrResult, CbrMatch
from backend.app.services.cbr_fact_extractor import extract_case_facts, normalize_case_number
from backend.app.services.cbr_normalization import (
    normalize_fight_consequence,
    normalize_injury_type,
    normalize_text,
    normalize_weapon,
    bool_to_text,
    parse_bool,
)
from backend.app.services.db_config import get_db_config
from backend.app.domain.shared.outcome_normalization import normalize_outcome


ROOT = Path(__file__).resolve().parents[3]
CBR_DIR = ROOT / "cbr-jcolibri"
JAR_PATH = CBR_DIR / "target" / "pravna-cbr-0.0.1-SNAPSHOT.jar"

BOOLEAN_COLUMNS = (
    "weapon_used",
    "severe_consequence",
    "death_result",
    "negligence",
    "provocation",
    "fight_participation",
    "left_without_help",
    "previous_convictions",
    "repeat_offender",
    "confession",
    "remorse",
    "plea_agreement",
    "aggravating_circumstances",
    "mitigating_circumstances",
    "family_circumstances",
    "poor_financial_status",
    "alcohol_intoxication",
    "narcotics_influence",
    "conditional_sentence_requested",
    "attempted_offense",
)


class CbrService:
    """Service that executes jColibri and parses JSON output."""

    def __init__(self) -> None:
        self._case_number_index: dict[str, str] | None = None

    def sync_case_base(self) -> None:
        """Initialize/synchronize case base records before retrieval flows."""
        self._ensure_case_base()

    def query(self, facts: CaseFacts, top_k: int) -> CbrResult:
        self._ensure_case_base()
        if not JAR_PATH.exists():
            raise FileNotFoundError(f"CBR jar not found: {JAR_PATH}")

        # Use fat JAR (-jar) which has all dependencies bundled, no need for -cp
        args = [
            "java",
            "-jar",
            str(JAR_PATH),
            "--json",
            f"top_k={top_k}",
        ]

        self._append_arg(args, "injury_type", normalize_injury_type(facts.injury_type))
        self._append_arg(args, "location", normalize_text(facts.location))
        self._append_arg(args, "weapon", normalize_weapon(facts.weapon))
        self._append_arg(args, "weapon_used", self._bool_str(facts.weapon_used))
        self._append_arg(args, "severe_consequence", self._bool_str(facts.severe_consequence))
        self._append_arg(args, "death_result", self._bool_str(facts.death_result))
        self._append_arg(args, "negligence", self._bool_str(facts.negligence))
        self._append_arg(args, "provocation", self._bool_str(facts.provocation))
        self._append_arg(args, "fight_participation", self._bool_str(facts.fight_participation))
        self._append_arg(args, "fight_consequence", normalize_fight_consequence(facts.fight_consequence))
        self._append_arg(args, "left_without_help", self._bool_str(facts.left_without_help))
        self._append_arg(args, "previous_convictions", self._bool_str(facts.previous_convictions))
        self._append_arg(args, "repeat_offender", self._bool_str(facts.repeat_offender))
        self._append_arg(args, "confession", self._bool_str(facts.confession))
        self._append_arg(args, "remorse", self._bool_str(facts.remorse))
        self._append_arg(args, "plea_agreement", self._bool_str(facts.plea_agreement))
        self._append_arg(args, "aggravating_circumstances", self._bool_str(facts.aggravating_circumstances))
        self._append_arg(args, "mitigating_circumstances", self._bool_str(facts.mitigating_circumstances))
        self._append_arg(args, "family_circumstances", self._bool_str(facts.family_circumstances))
        self._append_arg(args, "poor_financial_status", self._bool_str(facts.poor_financial_status))
        self._append_arg(args, "alcohol_intoxication", self._bool_str(facts.alcohol_intoxication))
        self._append_arg(args, "narcotics_influence", self._bool_str(facts.narcotics_influence))
        self._append_arg(args, "conditional_sentence_requested", self._bool_str(facts.conditional_sentence_requested))
        self._append_arg(args, "attempted_offense", self._bool_str(facts.attempted_offense))

        env = self._cbr_env()

        try:
            result = subprocess.run(
                args,
                cwd=str(CBR_DIR),
                check=True,
                capture_output=True,
                text=True,
                encoding="utf-8",
                errors="replace",
                timeout=60,
                env=env,
            )
        except subprocess.CalledProcessError as exc:
            stdout = (exc.stdout or "").strip()
            stderr = (exc.stderr or "").strip()
            detail = "CBR java process failed"
            if stderr:
                detail += f"; stderr: {stderr}"
            if stdout:
                detail += f"; stdout: {stdout}"
            raise RuntimeError(detail) from exc

        json_text = self._extract_json(result.stdout)
        payload = json.loads(json_text)
        matches = [
            CbrMatch(
                case_number=self._sanitize_case_number(item.get("case_number")),
                verdict_case_id=self._resolve_verdict_case_id(item.get("case_number")),
                similarity=float(item.get("similarity", 0.0)),
                outcome=normalize_outcome(item.get("outcome")),
                feature_contributions={
                    str(k): float(v)
                    for k, v in (item.get("feature_contributions") or {}).items()
                },
            )
            for item in payload.get("matches", [])
        ]

        return CbrResult(matches=matches)

    def _ensure_case_base(self) -> None:
        # ALWAYS reload from database to pick up newly saved cases
        # (no caching of case base state)
        logger = logging.getLogger(__name__)
        config = get_db_config()
        try:
            with psycopg2.connect(**config) as conn:
                with conn.cursor() as cursor:
                    self._ensure_case_schema(cursor)
                    cursor.execute("SELECT COUNT(*) FROM cases")
                    count = cursor.fetchone()[0]
                    non_generated_count = self._count_non_generated_cases(cursor)
                    if non_generated_count == 0:
                        self._import_cases(conn)
                    elif self._has_legacy_false_defaults(cursor):
                        logger.warning(
                            "Detected legacy CBR boolean defaults (all false); re-importing XML case base"
                        )
                        self._import_cases(conn)
                    else:
                        expected_xml_cases = self._count_xml_cases()
                        if expected_xml_cases > 0 and non_generated_count < expected_xml_cases:
                            logger.warning(
                                "Detected stale CBR case base (%s non-GEN rows, %s total rows in DB, %s XML cases); re-importing XML case base",
                                non_generated_count,
                                count,
                                expected_xml_cases,
                            )
                            self._import_cases(conn)
        except Exception as exc:
            logger.exception("CBR database initialization failed")
            raise RuntimeError("CBR database initialization failed") from exc

    def _count_xml_cases(self) -> int:
        xml_dir = ROOT / "data" / "verdicts_xml"
        if not xml_dir.exists():
            return 0
        count = 0
        for xml_file in xml_dir.glob("*.xml"):
            if xml_file.stem.upper().startswith("GEN"):
                continue
            count += 1
        return count

    def _count_non_generated_cases(self, cursor) -> int:
        cursor.execute(
            """
            SELECT COUNT(*)
            FROM cases
            WHERE case_number IS NULL OR case_number NOT ILIKE 'GEN-%'
            """
        )
        return int(cursor.fetchone()[0] or 0)

    def _import_cases(self, conn) -> None:
        xml_dir = ROOT / "data" / "verdicts_xml"
        if not xml_dir.exists():
            return

        records = []
        for xml_file in sorted(xml_dir.glob("*.xml")):
            if xml_file.stem.upper().startswith("GEN"):
                continue

            facts = self._extract_facts(xml_file)
            if not facts:
                continue

            record = (
                facts.get("case_number", ""),
                normalize_injury_type(facts.get("injury_type")),
                normalize_text(facts.get("location")),
                normalize_weapon(facts.get("weapon")),
                self._extract_bool_or_none(facts.get("weapon_used")),
                self._extract_bool_or_none(facts.get("severe_consequence")),
                self._extract_bool_or_none(facts.get("death_result")),
                self._extract_bool_or_none(facts.get("negligence")),
                self._extract_bool_or_none(facts.get("provocation")),
                self._extract_bool_or_none(facts.get("fight_participation")),
                normalize_fight_consequence(facts.get("fight_consequence")),
                self._extract_bool_or_none(facts.get("left_without_help")),
                self._extract_bool_or_none(facts.get("previous_convictions")),
                self._extract_bool_or_none(facts.get("repeat_offender")),
                self._extract_bool_or_none(facts.get("confession")),
                self._extract_bool_or_none(facts.get("remorse")),
                self._extract_bool_or_none(facts.get("plea_agreement")),
                self._extract_bool_or_none(facts.get("aggravating_circumstances")),
                self._extract_bool_or_none(facts.get("mitigating_circumstances")),
                self._extract_bool_or_none(facts.get("family_circumstances")),
                self._extract_bool_or_none(facts.get("poor_financial_status")),
                self._extract_bool_or_none(facts.get("alcohol_intoxication")),
                self._extract_bool_or_none(facts.get("narcotics_influence")),
                self._extract_bool_or_none(facts.get("conditional_sentence_requested")),
                self._extract_bool_or_none(facts.get("attempted_offense")),
                normalize_outcome(facts.get("outcome")),
            )
            records.append(record)

        if not records:
            return

        with conn.cursor() as cursor:
            self._ensure_case_schema(cursor)
            cursor.execute(
                """
                DELETE FROM cases
                WHERE case_number IS NULL OR case_number NOT ILIKE 'GEN-%'
                """
            )
            insert_query = """
                INSERT INTO cases (
                    case_number, injury_type, location, weapon, weapon_used,
                    severe_consequence, death_result, negligence, provocation,
                    fight_participation, fight_consequence, left_without_help,
                    previous_convictions, repeat_offender, confession, remorse,
                    plea_agreement, aggravating_circumstances, mitigating_circumstances,
                    family_circumstances, poor_financial_status, alcohol_intoxication,
                    narcotics_influence, conditional_sentence_requested, attempted_offense,
                    outcome
                ) VALUES %s
            """
            execute_values(cursor, insert_query, records)
        conn.commit()
        self._case_number_index = None

    def _extract_facts(self, xml_path: Path) -> dict:
        return extract_case_facts(xml_path)

    def _cbr_env(self) -> dict:
        config = get_db_config()
        env = {
            "DB_HOST": str(config["host"]),
            "DB_PORT": str(config["port"]),
            "DB_NAME": str(config["database"]),
            "DB_USER": str(config["user"]),
            "DB_PASSWORD": str(config["password"]),
            "JAVA_TOOL_OPTIONS": "-Xms64m -Xmx256m",
        }
        result = os.environ.copy()
        for key, value in env.items():
            result.setdefault(key, value)
        return result

    def _append_arg(self, args: list[str], key: str, value: str | None) -> None:
        if value is None:
            return
        if isinstance(value, str) and not value.strip():
            return
        args.append(f"{key}={value}")

    def _bool_str(self, value: bool | None) -> str | None:
        return bool_to_text(value)

    def _extract_json(self, output: str) -> str:
        start = output.find("{")
        end = output.rfind("}")
        if start == -1 or end == -1 or end <= start:
            raise ValueError("CBR output does not contain JSON")
        return output[start : end + 1]

    def _extract_bool_or_none(self, value: str | bool | None) -> bool | None:
        parsed = parse_bool(value)
        return parsed

    def _ensure_case_schema(self, cursor) -> None:
        for column in BOOLEAN_COLUMNS:
            cursor.execute(f"ALTER TABLE cases ADD COLUMN IF NOT EXISTS {column} BOOLEAN")

    def _sanitize_case_number(self, value: str | None, fallback: str | None = None) -> str | None:
        if fallback is None:
            normalized = normalize_case_number(value, "")
            return normalized or None
        return normalize_case_number(value, fallback)

    def _has_legacy_false_defaults(self, cursor) -> bool:
        select_parts = ["COUNT(*)"]
        for col in BOOLEAN_COLUMNS:
            select_parts.append(f"SUM(CASE WHEN {col} IS NULL THEN 1 ELSE 0 END)")
            select_parts.append(f"SUM(CASE WHEN {col} = TRUE THEN 1 ELSE 0 END)")

        cursor.execute(f"SELECT {', '.join(select_parts)} FROM cases")
        row = cursor.fetchone()
        if not row:
            return False

        total = int(row[0] or 0)
        if total < 10:
            return False

        offset = 1
        for _ in BOOLEAN_COLUMNS:
            null_count = int(row[offset] or 0)
            true_count = int(row[offset + 1] or 0)
            offset += 2

            if null_count != 0 or true_count != 0:
                return False

        return True

    def _resolve_verdict_case_id(self, case_number: str | None) -> str | None:
        normalized_case_number = self._sanitize_case_number(case_number)
        if not normalized_case_number:
            return None
        index = self._load_case_number_index()
        return index.get(normalized_case_number.lower())

    def _load_case_number_index(self) -> dict[str, str]:
        if self._case_number_index is not None:
            return self._case_number_index

        index: dict[str, str] = {}
        xml_dir = ROOT / "data" / "verdicts_xml"
        if not xml_dir.exists():
            self._case_number_index = index
            return index

        for xml_file in sorted(xml_dir.glob("*.xml")):
            if xml_file.stem.upper().startswith("GEN"):
                continue
            try:
                tree = ET.parse(xml_file)
                root = tree.getroot()
                case_number_elem = root.find(".//{*}docNumber")
                case_number = self._sanitize_case_number(
                    case_number_elem.text if case_number_elem is not None else None,
                    fallback=xml_file.stem,
                )
                if case_number:
                    index[case_number.lower()] = xml_file.stem
            except Exception:
                continue

        self._case_number_index = index
        return index
