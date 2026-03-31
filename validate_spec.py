#!/usr/bin/env python3
"""Validation of all 9 specification requirements."""

import sys
import io
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8', errors='replace')

import os
import json
import xml.etree.ElementTree as ET
from pathlib import Path

ROOT = Path(__file__).resolve().parent
VERDICTS_XML = ROOT / "data" / "verdicts_xml"
LAW_XML = ROOT / "output" / "annotated_law.xml"
RULES_DIR = ROOT / "dr-device" / "dr-device"
CBR_DIR = ROOT / "cbr-jcolibri"

def check(name, passed, details=""):
    status = "✓" if passed else "✗"
    print(f"  {status} {name}")
    if details and not passed:
        print(f"    -> {details}")
    return passed

def count_xml_verdicts():
    """Count verdict XML files (excluding GEN-* generated ones)."""
    count = 0
    for f in VERDICTS_XML.glob("*.xml"):
        if not f.name.startswith("GEN-") and f.name.endswith(".xml"):
            if not f.name.startswith("eval_") and not f.name.startswith("verdicts_"):
                count += 1
    return count

def count_rules():
    """Count rules in dr-device rulebase."""
    rules_file = RULES_DIR / "rulebase.ruleml"
    if not rules_file.exists():
        return 0
    content = rules_file.read_text(encoding='utf-8')
    # Count <Implies> elements (each is a rule) - with or without attributes
    import re
    return len(re.findall(r'<Implies\s*[^>]*>', content))

def count_cbr_attributes():
    """Count CBR case attributes."""
    # Check multiple possible paths
    csv_paths = [
        ROOT / "cbr-jcolibri" / "case_base.csv",
        ROOT / "cbr-jcolibri" / "src" / "main" / "resources" / "presude.csv",
        ROOT / "data" / "case_base.csv",
    ]
    for csv_file in csv_paths:
        if csv_file.exists():
            header = csv_file.read_text(encoding='utf-8').split('\n')[0]
            # Handle both comma and semicolon separators
            sep = ';' if ';' in header else ','
            # Skip comment marker if present
            if header.startswith('#'):
                header = header[1:]
            return len(header.split(sep))
    return 0

def main():
    print("=" * 60)
    print("VALIDACIJA SPECIFIKACIJE - 9 TACAKA")
    print("=" * 60)
    
    results = {}
    
    # TASK 1: Zakon u Akoma Ntoso
    print("\n1. ZAKON U AKOMA NTOSO FORMATU")
    law_exists = LAW_XML.exists() or (ROOT / "data" / "annotated_law.xml").exists()
    results['task1'] = check("Zakon u XML formatu", law_exists)
    
    # TASK 2: Sudske odluke (min 15)
    print("\n2. SUDSKE ODLUKE U AKOMA NTOSO (min 15)")
    verdict_count = count_xml_verdicts()
    results['task2'] = check(f"Broj presuda: {verdict_count} >= 15", verdict_count >= 15)
    
    # TASK 3: LegalRuleML
    print("\n3. PRAVNE NORME U LEGALRULEML")
    rules_count = count_rules()
    results['task3'] = check(f"Broj pravila: {rules_count} >= 10", rules_count >= 10)
    
    # TASK 4: NLP ekstrakcija
    print("\n4. NLP EKSTRAKCIJA METAPODATAKA")
    annotations_file = VERDICTS_XML / "verdicts_annotations.json"
    has_annotations = annotations_file.exists()
    results['task4'] = check("Anotacije presuda", has_annotations)
    
    # TASK 5: dr-device reasoning
    print("\n5. RASUDIVANJE PO PRAVILIMA (dr-device)")
    facts_rdf = RULES_DIR / "facts.rdf"
    has_facts = facts_rdf.exists() if RULES_DIR.exists() else False
    results['task5'] = check("Facts RDF za dr-device", has_facts)
    
    # TASK 6: CBR/jColibri (min 7 atributa)
    print("\n6. CBR BAZA SLUCAJEVA (min 7 atributa)")
    cbr_attrs = count_cbr_attributes()
    results['task6'] = check(f"Broj atributa: {cbr_attrs} >= 7", cbr_attrs >= 7)
    
    # TASK 7: Pregled i navigacija
    print("\n7. PREGLED I NAVIGACIJA")
    frontend_exists = (ROOT / "frontend" / "src").exists()
    results['task7'] = check("Frontend aplikacija", frontend_exists)
    
    # TASK 8: Combined reasoning
    print("\n8. KOMBINOVANO RASUDIVANJE")
    # Check for both rule reasoning and CBR services
    rule_reasoning = (ROOT / "backend" / "app" / "services" / "rule_reasoning_service.py").exists()
    cbr_service = (ROOT / "backend" / "app" / "services" / "cbr_service.py").exists()
    results['task8'] = check("Rule + CBR reasoning services", rule_reasoning and cbr_service)
    
    # TASK 9: Generisanje presuda
    print("\n9. GENERISANJE PRESUDA")
    gen_service = (ROOT / "backend" / "app" / "services" / "verdict_generation_service.py").exists()
    results['task9'] = check("Verdict generation service", gen_service)
    
    # Summary
    print("\n" + "=" * 60)
    passed = sum(1 for v in results.values() if v)
    total = len(results)
    print(f"REZULTAT: {passed}/{total} tacaka ispunjeno")
    
    if passed == total:
        print("\n✓✓✓ SVE TACKE SPECIFIKACIJE SU ISPUNJENE ✓✓✓")
        return 0
    else:
        print("\n✗ Neke tacke nisu ispunjene!")
        return 1

if __name__ == "__main__":
    sys.exit(main())
