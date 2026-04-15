"""Import extracted facts from XML verdicts into PostgreSQL database."""
from pathlib import Path
import os
import psycopg2
from psycopg2.extras import execute_values
from dotenv import load_dotenv
from backend.app.services.cbr_fact_extractor import (
    canonical_fact_key as shared_canonical_fact_key,
    extract_case_facts,
    normalize_case_number as shared_normalize_case_number,
)
from backend.app.services.cbr_normalization import normalize_weapon
from backend.app.domain.shared.outcome_normalization import normalize_outcome


ASCII_MAP = {
    "č": "c",
    "ć": "c",
    "š": "s",
    "ž": "z",
    "đ": "dj",
    "Č": "C",
    "Ć": "C",
    "Š": "S",
    "Ž": "Z",
    "Đ": "Dj",
}

CBR_BOOLEAN_COLUMNS = (
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

def normalize_text(value: str | None) -> str | None:
    if value is None:
        return None
    text = value.strip()
    if not text:
        return None
    for src, dst in ASCII_MAP.items():
        text = text.replace(src, dst)
    text = " ".join(text.split())
    return text.lower()


def normalize_injury_type(value: str | None) -> str | None:
    text = normalize_text(value)
    if not text:
        return None
    if "povred" in text:
        if "tesk" in text:
            return "teska tjelesna povreda"
        if "lak" in text:
            return "laka tjelesna povreda"
    return text


def normalize_fight_consequence(value: str | None) -> str | None:
    text = normalize_text(value)
    if not text:
        return None
    if text in {"none", "nema", "bez", "bez posledica", "bez posljedica"}:
        return "none"
    return text


def parse_boolean(value: str | bool | None) -> bool | None:
    """Parse string to boolean."""
    if value is None:
        return None
    if isinstance(value, bool):
        return value
    text = normalize_text(value) or ""
    if text in ("true", "1", "yes", "da", "t", "y"):
        return True
    if text in ("false", "0", "no", "ne", "f", "n"):
        return False
    return None


def _canonical_fact_key(raw_key: str | None) -> str | None:
    return shared_canonical_fact_key(raw_key)


def _normalize_case_number(raw_value: str | None, fallback_stem: str) -> str:
    return shared_normalize_case_number(raw_value, fallback_stem)


def extract_facts_from_xml(xml_path: Path) -> dict:
    """Extract facts from a single XML verdict."""
    return extract_case_facts(xml_path)


def _ensure_case_table_columns(cursor) -> None:
    for column in CBR_BOOLEAN_COLUMNS:
        cursor.execute(f"ALTER TABLE cases ADD COLUMN IF NOT EXISTS {column} BOOLEAN")


def import_to_database(xml_dir: Path, db_config: dict):
    """Import all XML verdicts into PostgreSQL."""
    conn = psycopg2.connect(**db_config)
    cursor = conn.cursor()
    
    _ensure_case_table_columns(cursor)

    # Clear existing data
    cursor.execute("TRUNCATE TABLE cases RESTART IDENTITY CASCADE")
    
    xml_files = sorted(xml_dir.glob("*.xml"))
    records = []
    
    for xml_file in xml_files:
        if xml_file.stem.upper().startswith("GEN"):
            continue
        try:
            facts = extract_facts_from_xml(xml_file)
            
            record = (
                facts.get("case_number", ""),
                normalize_injury_type(facts.get("injury_type")),
                normalize_text(facts.get("location")),
                normalize_weapon(facts.get("weapon")),
                parse_boolean(facts.get("weapon_used")),
                parse_boolean(facts.get("severe_consequence")),
                parse_boolean(facts.get("death_result")),
                parse_boolean(facts.get("negligence")),
                parse_boolean(facts.get("provocation")),
                parse_boolean(facts.get("fight_participation")),
                normalize_fight_consequence(facts.get("fight_consequence")),
                parse_boolean(facts.get("left_without_help")),
                parse_boolean(facts.get("previous_convictions")),
                parse_boolean(facts.get("repeat_offender")),
                parse_boolean(facts.get("confession")),
                parse_boolean(facts.get("remorse")),
                parse_boolean(facts.get("plea_agreement")),
                parse_boolean(facts.get("aggravating_circumstances")),
                parse_boolean(facts.get("mitigating_circumstances")),
                parse_boolean(facts.get("family_circumstances")),
                parse_boolean(facts.get("poor_financial_status")),
                parse_boolean(facts.get("alcohol_intoxication")),
                parse_boolean(facts.get("narcotics_influence")),
                parse_boolean(facts.get("conditional_sentence_requested")),
                parse_boolean(facts.get("attempted_offense")),
                normalize_outcome(facts.get("outcome"))
            )
            records.append(record)
            safe_name = xml_file.name.encode('ascii', 'replace').decode('ascii')
            print(f"[OK] Processed: {safe_name}")
        except Exception as e:
            safe_name = xml_file.name.encode('ascii', 'replace').decode('ascii')
            print(f"[X] Error processing {safe_name}: {e}")
    
    if not records:
        cursor.close()
        conn.close()
        print("\n[!] No XML case records found for import")
        return

    # Bulk insert
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
    cursor.close()
    conn.close()
    
    print(f"\n[OK] Imported {len(records)} cases into PostgreSQL")


def main():
    load_dotenv()
    root = Path(__file__).resolve().parent
    xml_dir = root / "data" / "verdicts_xml"
    
    db_config = {
        "host": os.getenv("DB_HOST") or os.getenv("POSTGRES_HOST", "localhost"),
        "port": int(os.getenv("DB_PORT") or os.getenv("POSTGRES_PORT", "5432")),
        "database": os.getenv("DB_NAME") or os.getenv("POSTGRES_DB", "pravna_cbr"),
        "user": os.getenv("DB_USER") or os.getenv("POSTGRES_USER", "pravna_user"),
        "password": os.getenv("DB_PASSWORD") or os.getenv("POSTGRES_PASSWORD", "pravna_pass"),
    }
    
    import_to_database(xml_dir, db_config)


if __name__ == "__main__":
    main()
