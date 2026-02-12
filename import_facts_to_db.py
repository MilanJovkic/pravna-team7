"""Import extracted facts from XML verdicts into PostgreSQL database."""
import xml.etree.ElementTree as ET
from pathlib import Path
import psycopg2
from psycopg2.extras import execute_values


def parse_boolean(value: str) -> bool:
    """Parse string to boolean."""
    return value.lower() in ('true', '1', 'yes')


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
                facts.get("injury_type", ""),
                facts.get("location", ""),
                facts.get("weapon", ""),
                parse_boolean(facts.get("weapon_used", "false")),
                parse_boolean(facts.get("severe_consequence", "false")),
                parse_boolean(facts.get("death_result", "false")),
                parse_boolean(facts.get("negligence", "false")),
                parse_boolean(facts.get("provocation", "false")),
                parse_boolean(facts.get("fight_participation", "false")),
                facts.get("fight_consequence", "none"),
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
    root = Path(__file__).resolve().parent
    xml_dir = root / "data" / "verdicts_xml"
    
    db_config = {
        "host": "localhost",
        "port": 5432,
        "database": "pravna_cbr",
        "user": "pravna_user",
        "password": "pravna_pass"
    }
    
    import_to_database(xml_dir, db_config)


if __name__ == "__main__":
    main()
