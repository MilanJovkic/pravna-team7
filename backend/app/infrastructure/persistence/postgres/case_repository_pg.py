"""PostgreSQL adapter for case repository port."""
from __future__ import annotations

import psycopg2

from backend.app.models.schemas import CaseFacts
from backend.app.ports.outbound.case_repository import PersistCaseRecord
from backend.app.services.db_config import get_db_config


class PostgresCaseRepository:
    """Persist and query CBR cases in PostgreSQL."""

    def find_existing_case(
        self,
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
        with psycopg2.connect(**get_db_config()) as conn:
            with conn.cursor() as cursor:
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

    def next_version(self, facts: CaseFacts) -> int:
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
        with psycopg2.connect(**get_db_config()) as conn:
            with conn.cursor() as cursor:
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

    def insert_case(self, payload: PersistCaseRecord) -> tuple[int, str]:
        query = """
            INSERT INTO cases (
                case_number, injury_type, location, weapon, weapon_used,
                severe_consequence, death_result, negligence, provocation,
                fight_participation, fight_consequence, left_without_help,
                outcome, verdict_type, sanction
            ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
            RETURNING id, case_number
        """
        with psycopg2.connect(**get_db_config()) as conn:
            with conn.cursor() as cursor:
                cursor.execute(
                    query,
                    (
                        payload.case_number,
                        payload.facts.injury_type,
                        payload.facts.location,
                        payload.facts.weapon,
                        payload.facts.weapon_used,
                        payload.facts.severe_consequence,
                        payload.facts.death_result,
                        payload.facts.negligence,
                        payload.facts.provocation,
                        payload.facts.fight_participation,
                        payload.facts.fight_consequence,
                        payload.facts.left_without_help,
                        payload.outcome,
                        payload.verdict_type,
                        payload.sanction,
                    ),
                )
                row = cursor.fetchone()
            conn.commit()

        return int(row[0]), str(row[1])
