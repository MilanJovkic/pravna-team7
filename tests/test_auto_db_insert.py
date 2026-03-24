"""Test script to verify automatic database insertion during XML export."""
import sys
from pathlib import Path

# Add workspace root to path for module resolution
workspace_root = Path.cwd()
if workspace_root.name != 'pravna-team7':
    workspace_root = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(workspace_root))

from src.verdict_annotation.verdict_parser import VerdictMetadata
from src.verdict_annotation.verdict_annotator import VerdictAnnotation
from src.verdict_annotation.verdict_exporter import VerdictAkomaExporter
import psycopg2
import os

try:
    from dotenv import load_dotenv
except Exception:
    load_dotenv = None

if load_dotenv:
    load_dotenv()

# Create test case
test_metadata = VerdictMetadata(
    case_number="TEST-001",
    court_name="Основни суд Подгорица",
    date="2026-02-12",
    judges=["Тест Судија"],
    legal_references=["Кривични законик члан 152"],
    parties={
        "defendant": ["Тест Оптужени"],
        "prosecutor": ["Тужилаштво"],
        "judge": ["Тест Судија"],
        "clerk": ["Тест Записничар"]
    },
    factual_state={
        "injury_type": ["teska tjelesna povreda"],
        "location": ["Podgorica"],
        "weapon": ["noz"],
        "weapon_used": ["da"],
        "severe_consequence": ["da"],
        "death_result": ["ne"],
        "negligence": ["ne"],
        "provocation": ["ne"],
        "fight_participation": ["ne"],
        "fight_consequence": ["none"],
        "left_without_help": ["ne"]
    },
    raw_text="Тест текст пресуде...",
    organizations=[]
)

test_annotation = VerdictAnnotation(
    verdict_summary="Тест резиме",
    legal_issues=["Тешка телесна повреда"],
    applied_laws=["Кривични законик"],
    applied_articles=["Члан 152"],
    legal_reasoning="Тест образложење",
    decision="Тест одлука",
    case_outcome="усвојено",
    legal_concepts=["повреда", "кривица"],
    factual_state=test_metadata.factual_state
)

# Export with automatic DB insertion
print("🔄 Exportujem test presidu sa automatskim upisom u bazu...")
exporter = VerdictAkomaExporter(enable_db_insert=True)
output_file = "output/test_verdict.xml"
exporter.export(test_metadata, test_annotation, output_file, "TEST-001")
print(f"✓ XML sacuvan: {output_file}")

# Verify database insertion
print("\n🔍 Proveravam unos u bazu...")
conn = psycopg2.connect(
    host=os.getenv("DB_HOST") or os.getenv("POSTGRES_HOST", "127.0.0.1"),
    port=int(os.getenv("DB_PORT") or os.getenv("POSTGRES_PORT", "5433")),
    database=os.getenv("DB_NAME") or os.getenv("POSTGRES_DB", "pravna_cbr"),
    user=os.getenv("DB_USER") or os.getenv("POSTGRES_USER", "pravna_user"),
    password=os.getenv("DB_PASSWORD") or os.getenv("POSTGRES_PASSWORD", "pravna_pass")
)
cursor = conn.cursor()
cursor.execute("SELECT * FROM cases WHERE case_number = %s", ("TEST-001",))
result = cursor.fetchone()
cursor.close()
conn.close()

if result:
    print(f"✅ Slučaj pronađen u bazi!")
    print(f"   ID: {result[0]}")
    print(f"   Case Number: {result[1]}")
    print(f"   Injury Type: {result[2]}")
    print(f"   Location: {result[3]}")
    print(f"   Weapon: {result[4]}")
    print(f"   Weapon Used: {result[5]}")
    print(f"   Outcome: {result[13]}")
    print(f"\n✅ AUTOMATSKI UPIS RADI!")
else:
    print("❌ Slučaj NIJE pronađen u bazi!")
