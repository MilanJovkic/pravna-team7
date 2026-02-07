"""
Quick start skript za procesiranje celog zakona.

KORISTI SA OPREZOM: Procesira SVE članke, može biti skupo (API troškovi).
"""

import os
import sys
from datetime import datetime

def confirm_processing():
    """Traži potvrdu od korisnika."""
    print("=" * 70)
    print("⚠ UPOZORENJE: Procesiranje CELOG zakona")
    print("=" * 70)
    print("\nOvo će:")
    print("  1. Procesirati SVE članke iz zakon.txt (može biti 100+)")
    print("  2. Slati LLM API pozive za svaki član")
    print("  3. Trajati 10-30 minuta")
    print("  4. Koštati API tokens (procena: $0.50 - $2.00)")
    print("\nAlternativa:")
    print("  Koristi --limit opciju za test (npr. --limit 20)")
    print("\n" + "=" * 70)
    
    response = input("\nNastavi sa procesiranjem CELOG zakona? (da/ne): ")
    return response.lower() in ['da', 'yes', 'y']

def main():
    """Pokreće procesiranje sa provjerom."""
    
    if not confirm_processing():
        print("\n✗ Procesiranje otkazano.")
        print("\nTest mode:")
        print("  python main.py --limit 10 --output test_output.xml")
        sys.exit(0)
    
    print("\n✓ Pokrećem procesiranje...")
    print(f"Start: {datetime.now().strftime('%H:%M:%S')}\n")
    
    # Pokreni glavni pipeline
    from main import AnnotationPipeline
    
    pipeline = AnnotationPipeline(
        input_file="zakon.txt",
        output_xml="kriviчni_zakonik_annotated.xml",
        output_json="kriviчni_zakonik_annotations.json",
        model="gpt-4o",        provider="github",        article_limit=None  # Svi članci
    )
    
    success = pipeline.run()
    
    print(f"\nEnd: {datetime.now().strftime('%H:%M:%S')}")
    
    if success:
        print("\n" + "=" * 70)
        print("✓ GOTOVO!")
        print("=" * 70)
        print("\nGenerirani fajlovi:")
        print("  - kriviчni_zakonik_annotated.xml")
        print("  - kriviчni_zakonik_annotations.json")
        print("\nSledeći koraci:")
        print("  1. Validacija: python analyze_annotations.py kriviчni_zakonik_annotations.json")
        print("  2. CSV export:  python analyze_annotations.py kriviчni_zakonik_annotations.json --csv stats.csv")
        print("  3. Otvori XML u editoru za pregled AKOMA strukture")
    else:
        print("\n✗ Procesiranje nije uspelo. Proveri logove iznad.")
    
    sys.exit(0 if success else 1)

if __name__ == "__main__":
    main()
