"""Service for inserting new cases into PostgreSQL."""
from __future__ import annotations

from datetime import datetime
import os

import psycopg2

from backend.app.models.schemas import CaseFacts


class CaseService:
    """Service for persisting new cases in the CBR database."""

    def insert_case(self, facts: CaseFacts, outcome: str | None, case_number: str | None) -> dict:
        case_number = case_number or self._generate_case_number()
        config = self._db_config()

        conn = psycopg2.connect(**config)
        cursor = conn.cursor()

        insert_query = """
            INSERT INTO cases (
                case_number, injury_type, location, weapon, weapon_used,
                severe_consequence, death_result, negligence, provocation,
                fight_participation, fight_consequence, left_without_help, outcome
            ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
            RETURNING id, case_number
        """

        cursor.execute(
            insert_query,
            (
                case_number,
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
            "host": os.getenv("DB_HOST", "localhost"),
            "port": int(os.getenv("DB_PORT", "5432")),
            "database": os.getenv("DB_NAME", "pravna_cbr"),
            "user": os.getenv("DB_USER", "pravna_user"),
            "password": os.getenv("DB_PASSWORD", "pravna_pass"),
        }
