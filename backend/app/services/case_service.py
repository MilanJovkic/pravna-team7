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
        case_number = case_number or self._generate_case_number()
        config = self._db_config()

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
                outcome,
                verdict_type,
                sanction,
            ),
        )

        new_id, new_case_number = cursor.fetchone()
        conn.commit()
        cursor.close()
        conn.close()

        return {"id": new_id, "case_number": new_case_number}

    def _generate_case_number(self) -> str:
        stamp = datetime.now().strftime("%Y%m%d-%H%M%S")
        return f"USER-{stamp}"

    def _db_config(self) -> dict:
        return {
            "host": os.getenv("DB_HOST") or os.getenv("POSTGRES_HOST", "127.0.0.1"),
            "port": int(os.getenv("DB_PORT") or os.getenv("POSTGRES_PORT", "5432")),
            "database": os.getenv("DB_NAME") or os.getenv("POSTGRES_DB", "pravna_cbr"),
            "user": os.getenv("DB_USER") or os.getenv("POSTGRES_USER", "pravna_user"),
            "password": os.getenv("DB_PASSWORD") or os.getenv("POSTGRES_PASSWORD", "pravna_pass"),
        }
