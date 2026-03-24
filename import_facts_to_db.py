"""Import extracted facts from XML verdicts into PostgreSQL database."""
import xml.etree.ElementTree as ET
from pathlib import Path
import os
import psycopg2
from psycopg2.extras import execute_values
from dotenv import load_dotenv


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


def parse_boolean(value: str) -> bool:
    """Parse string to boolean."""
    text = normalize_text(value) or ""
    if text in ("true", "1", "yes", "da", "t", "y"):
        return True
    if text in ("false", "0", "no", "ne", "f", "n"):
        return False
    return False


def extract_facts_from_xml(xml_path: Path) -> dict:
    """Extract facts from a single XML verdict."""
    tree = ET.parse(xml_path)
    root = tree.getroot()
    
    # Find judgment element
    judgment = root.find(".//{*}judgment")
    case_number_elem = root.find(".//{*}docNumber")
    outcome_elem = root.find(".//{*}block[@name='verdict']")
    
    case_number = case_number_elem.text if case_number_elem is not None else ""
    outcome = outcome_elem.get("outcome") if outcome_elem is not None else ""
    
    # Extract facts
    facts = {
        "case_number": case_number,
        "outcome": outcome
    }
    
    for fact in root.findall(".//{*}facts/{*}fact"):
        key = fact.attrib.get("key")
        value = fact.text or ""
        facts[key] = value
    
    return facts


def import_to_database(xml_dir: Path, db_config: dict):
    """Import all XML verdicts into PostgreSQL."""
    conn = psycopg2.connect(**db_config)
    cursor = conn.cursor()
    
    # Clear existing data
    cursor.execute("TRUNCATE TABLE cases RESTART IDENTITY CASCADE")
    
    xml_files = sorted(xml_dir.glob("*.xml"))
    records = []
    
    for xml_file in xml_files:
        try:
            facts = extract_facts_from_xml(xml_file)
            
            record = (
                facts.get("case_number", ""),
                normalize_injury_type(facts.get("injury_type")) or "",
                normalize_text(facts.get("location")) or "",
                normalize_text(facts.get("weapon")) or "",
                parse_boolean(facts.get("weapon_used", "false")),
                parse_boolean(facts.get("severe_consequence", "false")),
                parse_boolean(facts.get("death_result", "false")),
                parse_boolean(facts.get("negligence", "false")),
                parse_boolean(facts.get("provocation", "false")),
                parse_boolean(facts.get("fight_participation", "false")),
                normalize_fight_consequence(facts.get("fight_consequence")) or "none",
                parse_boolean(facts.get("left_without_help", "false")),
                facts.get("outcome", "")
            )
            records.append(record)
            print(f"✓ Processed: {xml_file.name}")
        except Exception as e:
            print(f"✗ Error processing {xml_file.name}: {e}")
    
    # Bulk insert
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
    conn.close()
    
    print(f"\n✓ Imported {len(records)} cases into PostgreSQL")


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
