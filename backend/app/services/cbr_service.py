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
from backend.app.services.cbr_normalization import (
    normalize_fight_consequence,
    normalize_injury_type,
    normalize_text,
    parse_bool,
)


ROOT = Path(__file__).resolve().parents[3]
CBR_DIR = ROOT / "cbr-jcolibri"
JAR_PATH = CBR_DIR / "target" / "pravna-cbr-0.0.1-SNAPSHOT.jar"
CP_PATH = CBR_DIR / "cp.txt"


class CbrService:
    """Service that executes jColibri and parses JSON output."""

    def __init__(self) -> None:
        self._cases_ready = False
        self._xml_snapshot: tuple[int, float] | None = None

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
        self._append_arg(args, "weapon", normalize_text(facts.weapon))
        self._append_arg(args, "weapon_used", self._bool_str(facts.weapon_used))
        self._append_arg(args, "severe_consequence", self._bool_str(facts.severe_consequence))
        self._append_arg(args, "death_result", self._bool_str(facts.death_result))
        self._append_arg(args, "negligence", self._bool_str(facts.negligence))
        self._append_arg(args, "provocation", self._bool_str(facts.provocation))
        self._append_arg(args, "fight_participation", self._bool_str(facts.fight_participation))
        self._append_arg(args, "fight_consequence", normalize_fight_consequence(facts.fight_consequence))
        self._append_arg(args, "left_without_help", self._bool_str(facts.left_without_help))

        env = os.environ.copy()
        env.setdefault("DB_HOST", os.getenv("POSTGRES_HOST", "127.0.0.1"))
        env.setdefault("DB_PORT", os.getenv("POSTGRES_PORT", "5432"))
        env.setdefault("DB_NAME", os.getenv("POSTGRES_DB", "pravna_cbr"))
        env.setdefault("DB_USER", os.getenv("POSTGRES_USER", "pravna_user"))
        env.setdefault("DB_PASSWORD", os.getenv("POSTGRES_PASSWORD", "pravna_pass"))

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
                case_number=item.get("case_number"),
                similarity=float(item.get("similarity", 0.0)),
                outcome=item.get("outcome"),
            )
            for item in payload.get("matches", [])
        ]

        return CbrResult(matches=matches)

    def sync_case_base(self) -> None:
        """Explicit adapter hook for pre-query case-base synchronization."""
        self._ensure_case_base()

    def _ensure_case_base(self) -> None:
        logger = logging.getLogger(__name__)
        config = self._db_config()
        xml_snapshot = self._build_xml_snapshot()

        if self._cases_ready and self._xml_snapshot == xml_snapshot:
            return

        try:
            conn = psycopg2.connect(**config)
        except Exception as exc:
            logger.exception("CBR database connection failed")
            raise RuntimeError("CBR database connection failed") from exc

        try:
            count = self._count_db_corpus_cases(conn)
            if count == 0 or self._xml_snapshot != xml_snapshot:
                self._import_cases(conn)
            conn.close()
            self._cases_ready = True
            self._xml_snapshot = xml_snapshot
        except Exception as exc:
            logger.exception("CBR database initialization failed")
            try:
                conn.close()
            except Exception:
                pass
            raise RuntimeError("CBR database initialization failed") from exc

    def _import_cases(self, conn) -> None:
        xml_dir = ROOT / "data" / "verdicts_xml"
        if not xml_dir.exists():
            return

        records = []
        for xml_file in sorted(xml_dir.glob("*.xml")):
            if self._is_generated_source(xml_file):
                continue

            facts = self._extract_facts(xml_file)
            if not facts:
                continue

            case_number = str(facts.get("case_number") or "").strip()
            if case_number.lower().startswith("gen"):
                continue

            record = (
                case_number,
                normalize_injury_type(facts.get("injury_type")),
                normalize_text(facts.get("location")),
                normalize_text(facts.get("weapon")),
                parse_bool(facts.get("weapon_used")),
                parse_bool(facts.get("severe_consequence")),
                parse_bool(facts.get("death_result")),
                parse_bool(facts.get("negligence")),
                parse_bool(facts.get("provocation")),
                parse_bool(facts.get("fight_participation")),
                normalize_fight_consequence(facts.get("fight_consequence")),
                parse_bool(facts.get("left_without_help")),
                facts.get("outcome", ""),
            )
            records.append(record)

        if not records:
            return

        cursor = conn.cursor()
        # Keep user-entered cases (USER-*) while refreshing corpus-derived entries.
        cursor.execute("DELETE FROM cases WHERE case_number IS NULL OR case_number NOT LIKE 'USER-%'")
        insert_query = """
            INSERT INTO cases (
                case_number, injury_type, location, weapon, weapon_used,
                severe_consequence, death_result, negligence, provocation,
                fight_participation, fight_consequence, left_without_help, outcome
            ) VALUES %s
        """
        execute_values(cursor, insert_query, records)
        conn.commit()
        cursor.close()

    def _build_xml_snapshot(self) -> tuple[int, float]:
        """Build a cheap snapshot of verdict XML corpus for change detection."""
        xml_dir = ROOT / "data" / "verdicts_xml"
        if not xml_dir.exists():
            return (0, 0.0)

        files = [path for path in sorted(xml_dir.glob("*.xml")) if not self._is_generated_source(path)]
        if not files:
            return (0, 0.0)

        latest_mtime = max(file.stat().st_mtime for file in files)
        return (len(files), latest_mtime)

    def _is_generated_source(self, xml_path: Path) -> bool:
        stem = xml_path.stem.strip().lower()
        return stem.startswith("gen")

    def _count_db_corpus_cases(self, conn) -> int:
        """Count only corpus-derived cases, excluding user-added USER-* entries."""
        cursor = conn.cursor()
        cursor.execute("SELECT COUNT(*) FROM cases WHERE case_number IS NULL OR case_number NOT LIKE 'USER-%'")
        count = int(cursor.fetchone()[0])
        cursor.close()
        return count

    def _extract_facts(self, xml_path: Path) -> dict:
        tree = ET.parse(xml_path)
        root = tree.getroot()

        case_number_elem = root.find(".//{*}docNumber")
        outcome_elem = root.find(".//{*}block[@name='verdict']")
        case_number = case_number_elem.text.strip() if case_number_elem is not None and case_number_elem.text else ""
        outcome = outcome_elem.get("outcome") if outcome_elem is not None else ""

        facts = {
            "case_number": case_number,
            "outcome": outcome,
        }

        for fact in root.findall(".//{*}facts/{*}fact"):
            key = fact.attrib.get("key")
            value = (fact.text or "").strip()
            if not key or not value:
                continue
            facts[key] = value

        return facts

    def _db_config(self) -> dict:
        return {
            "host": os.getenv("DB_HOST") or os.getenv("POSTGRES_HOST", "127.0.0.1"),
            "port": int(os.getenv("DB_PORT") or os.getenv("POSTGRES_PORT", "5432")),
            "database": os.getenv("DB_NAME") or os.getenv("POSTGRES_DB", "pravna_cbr"),
            "user": os.getenv("DB_USER") or os.getenv("POSTGRES_USER", "pravna_user"),
            "password": os.getenv("DB_PASSWORD") or os.getenv("POSTGRES_PASSWORD", "pravna_pass"),
        }

    def _append_arg(self, args: list[str], key: str, value: str | None) -> None:
        if value is None:
            return
        if isinstance(value, str) and not value.strip():
            return
        args.append(f"{key}={value}")

    def _bool_str(self, value: bool | None) -> str | None:
        if value is None:
            return None
        return "true" if value else "false"

    def _extract_json(self, output: str) -> str:
        start = output.find("{")
        end = output.rfind("}")
        if start == -1 or end == -1 or end <= start:
            raise ValueError("CBR output does not contain JSON")
        return output[start : end + 1]
