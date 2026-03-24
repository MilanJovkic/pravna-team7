"""Service for inserting new cases into PostgreSQL."""
from __future__ import annotations

from datetime import datetime
import os

import psycopg2

from backend.app.models.schemas import CaseFacts
from backend.app.services.cbr_normalization import (
    normalize_fight_consequence,
    normalize_injury_type,
    normalize_text,
)
from src.verdict_annotation.outcome_normalizer import normalize_outcome


class CaseService:
    """Service for persisting new cases in the CBR database."""

    def insert_case(
        self,
        facts: CaseFacts,
        outcome: str | None,
        case_number: str | None,
        verdict_type: str | None,
        sanction: str | None,
    ) -> dict:
        config = self._db_config()
        canonical_outcome = normalize_outcome(outcome)

        normalized = CaseFacts(
            defendant=facts.defendant,
            injury_type=normalize_injury_type(facts.injury_type),
            location=normalize_text(facts.location),
            weapon=normalize_text(facts.weapon),
            weapon_used=facts.weapon_used,
            severe_consequence=facts.severe_consequence,
            death_result=facts.death_result,
            negligence=facts.negligence,
            provocation=facts.provocation,
            fight_participation=facts.fight_participation,
            fight_consequence=normalize_fight_consequence(facts.fight_consequence),
            left_without_help=facts.left_without_help,
        )

        conn = psycopg2.connect(**config)
        cursor = conn.cursor()

        existing = self._find_existing_case(
            cursor=cursor,
            facts=normalized,
            outcome=canonical_outcome,
            verdict_type=verdict_type,
            sanction=sanction,
        )
        if existing:
            existing_id, existing_case_number = existing
            cursor.close()
            conn.close()
            return {
                "id": existing_id,
                "case_number": existing_case_number,
                "reused_existing": True,
                "version": self._extract_version(existing_case_number),
            }

        version = self._next_version(cursor=cursor, facts=normalized)
        if case_number:
            case_number = case_number.strip()
        if not case_number:
            case_number = self._generate_case_number(version=version)
        elif version > 1 and "-v" not in case_number.lower():
            case_number = f"{case_number}-v{version}"

        insert_query = """
            INSERT INTO cases (
                case_number, injury_type, location, weapon, weapon_used,
                severe_consequence, death_result, negligence, provocation,
                fight_participation, fight_consequence, left_without_help,
                outcome, verdict_type, sanction
            ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
            RETURNING id, case_number
        """

        cursor.execute(
            insert_query,
            (
                case_number,
                normalized.injury_type,
                normalized.location,
                normalized.weapon,
                normalized.weapon_used,
                normalized.severe_consequence,
                normalized.death_result,
                normalized.negligence,
                normalized.provocation,
                normalized.fight_participation,
                normalized.fight_consequence,
                normalized.left_without_help,
                canonical_outcome,
                verdict_type,
                sanction,
            ),
        )

        new_id, new_case_number = cursor.fetchone()
        conn.commit()
        cursor.close()
        conn.close()

        return {
            "id": new_id,
            "case_number": new_case_number,
            "reused_existing": False,
            "version": version,
        }

    def _generate_case_number(self, version: int = 1) -> str:
        stamp = datetime.now().strftime("%Y%m%d-%H%M%S")
        base = f"USER-{stamp}"
        if version <= 1:
            return base
        return f"{base}-v{version}"

    def _find_existing_case(
        self,
        cursor,
        facts: CaseFacts,
        outcome: str | None,
        verdict_type: str | None,
        sanction: str | None,
    ) -> tuple[int, str] | None:
        query = """
            SELECT id, case_number
            FROM cases
            WHERE injury_type IS NOT DISTINCT FROM %s
              AND location IS NOT DISTINCT FROM %s
              AND weapon IS NOT DISTINCT FROM %s
              AND weapon_used IS NOT DISTINCT FROM %s
              AND severe_consequence IS NOT DISTINCT FROM %s
              AND death_result IS NOT DISTINCT FROM %s
              AND negligence IS NOT DISTINCT FROM %s
              AND provocation IS NOT DISTINCT FROM %s
              AND fight_participation IS NOT DISTINCT FROM %s
              AND fight_consequence IS NOT DISTINCT FROM %s
              AND left_without_help IS NOT DISTINCT FROM %s
              AND outcome IS NOT DISTINCT FROM %s
              AND verdict_type IS NOT DISTINCT FROM %s
              AND sanction IS NOT DISTINCT FROM %s
            ORDER BY id DESC
            LIMIT 1
        """
        cursor.execute(
            query,
            (
                facts.injury_type,
                facts.location,
                facts.weapon,
                facts.weapon_used,
                facts.severe_consequence,
                facts.death_result,
                facts.negligence,
                facts.provocation,
                facts.fight_participation,
                facts.fight_consequence,
                facts.left_without_help,
                outcome,
                verdict_type,
                sanction,
            ),
        )
        row = cursor.fetchone()
        if not row:
            return None
        return int(row[0]), str(row[1])

    def _next_version(self, cursor, facts: CaseFacts) -> int:
        query = """
            SELECT COUNT(*)
            FROM cases
            WHERE injury_type IS NOT DISTINCT FROM %s
              AND location IS NOT DISTINCT FROM %s
              AND weapon IS NOT DISTINCT FROM %s
              AND weapon_used IS NOT DISTINCT FROM %s
              AND severe_consequence IS NOT DISTINCT FROM %s
              AND death_result IS NOT DISTINCT FROM %s
              AND negligence IS NOT DISTINCT FROM %s
              AND provocation IS NOT DISTINCT FROM %s
              AND fight_participation IS NOT DISTINCT FROM %s
              AND fight_consequence IS NOT DISTINCT FROM %s
              AND left_without_help IS NOT DISTINCT FROM %s
        """
        cursor.execute(
            query,
            (
                facts.injury_type,
                facts.location,
                facts.weapon,
                facts.weapon_used,
                facts.severe_consequence,
                facts.death_result,
                facts.negligence,
                facts.provocation,
                facts.fight_participation,
                facts.fight_consequence,
                facts.left_without_help,
            ),
        )
        count = cursor.fetchone()[0]
        return int(count) + 1

    def _extract_version(self, case_number: str) -> int:
        value = (case_number or "").strip()
        marker = "-v"
        idx = value.lower().rfind(marker)
        if idx == -1:
            return 1
        suffix = value[idx + len(marker):]
        if suffix.isdigit():
            return int(suffix)
        return 1

    def _db_config(self) -> dict:
        return {
            "host": os.getenv("DB_HOST") or os.getenv("POSTGRES_HOST", "127.0.0.1"),
            "port": int(os.getenv("DB_PORT") or os.getenv("POSTGRES_PORT", "5432")),
            "database": os.getenv("DB_NAME") or os.getenv("POSTGRES_DB", "pravna_cbr"),
            "user": os.getenv("DB_USER") or os.getenv("POSTGRES_USER", "pravna_user"),
            "password": os.getenv("DB_PASSWORD") or os.getenv("POSTGRES_PASSWORD", "pravna_pass"),
        }
