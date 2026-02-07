"""
Utility skript za analizu i validaciju anotacija.

Koristi se za:
- Pregled statistike anotacija
- Validaciju kvaliteta
- Ekstrakciju specifičnih podataka
"""

import json
import sys
from pathlib import Path
from collections import Counter
from typing import Dict, Any


class AnnotationAnalyzer:
    """Alat za analizu JSON anotacija."""
    
    def __init__(self, json_file: str):
        """
        Args:
            json_file: Putanja do JSON fajla sa anotacijama
        """
        with open(json_file, 'r', encoding='utf-8') as f:
            self.annotations = json.load(f)
        
        self.article_count = len(self.annotations)
    
    def print_summary(self):
        """Ispisuje sažetak anotacija."""
        print("=" * 70)
        print("PREGLED ANOTACIJA")
        print("=" * 70)
        print(f"Ukupno anotiranih članaka: {self.article_count}\n")
        
        # Tipovi normi
        norm_types = Counter()
        for ann in self.annotations.values():
            norm_types[ann.get('norm_type', 'unknown')] += 1
        
        print("TIPOVI NORMI:")
        for norm_type, count in norm_types.most_common():
            percentage = count / self.article_count * 100
            print(f"  {norm_type:20s} {count:3d} ({percentage:5.1f}%)")
        
        # Subjekti
        all_subjects = Counter()
        for ann in self.annotations.values():
            for subj in ann.get('subjects', []):
                all_subjects[subj] += 1
        
        print("\nNAJČEŠĆI SUBJEKTI:")
        for subject, count in all_subjects.most_common(10):
            print(f"  {subject:25s} {count:3d}x")
        
        # Uslovi
        all_conditions = Counter()
        for ann in self.annotations.values():
            for cond in ann.get('conditions', []):
                all_conditions[cond] += 1
        
        print("\nNAJČEŠĆI USLOVI:")
        for condition, count in all_conditions.most_common(10):
            print(f"  {condition:30s} {count:3d}x")
        
        # Pravni koncepti
        all_concepts = Counter()
        for ann in self.annotations.values():
            for concept in ann.get('legal_concepts', []):
                all_concepts[concept] += 1
        
        print("\nPRAVNI KONCEPTI:")
        for concept, count in all_concepts.most_common(15):
            print(f"  {concept:30s} {count:3d}x")
        
        # Sankcije
        self._print_sanction_stats()
        
        # Kvalifikatori
        self._print_qualifier_stats()
        
        # Confidence scores
        self._print_confidence_stats()
        
        print("=" * 70)
    
    def _print_sanction_stats(self):
        """Statistika sankcija."""
        prison_sentences = []
        fines = []
        
        for ann in self.annotations.values():
            sanction = ann.get('sanctions', {})
            if sanction.get('type') == 'prison':
                min_val = sanction.get('min_value')
                max_val = sanction.get('max_value')
                if min_val:
                    prison_sentences.append(min_val)
                if max_val:
                    prison_sentences.append(max_val)
            elif sanction.get('type') == 'fine':
                fines.append(sanction)
        
        print("\nSANKCIJE:")
        print(f"  Članaka sa kaznom zatvora: {len([a for a in self.annotations.values() if a.get('sanctions', {}).get('type') in ['prison', 'both']])}")
        
        if prison_sentences:
            print(f"  Min kazna zatvora: {min(prison_sentences)} godina")
            print(f"  Max kazna zatvora: {max(prison_sentences)} godina")
            print(f"  Prosečna kazna: {sum(prison_sentences)/len(prison_sentences):.1f} godina")
    
    def _print_qualifier_stats(self):
        """Statistika kvalifikatora."""
        aggravated_count = 0
        mitigated_count = 0
        
        for ann in self.annotations.values():
            qualifiers = ann.get('qualifiers', {})
            if qualifiers.get('aggravated'):
                aggravated_count += 1
            if qualifiers.get('mitigated'):
                mitigated_count += 1
        
        print("\nKVALIFIKATORI:")
        print(f"  Otežavajući oblici (aggravated): {aggravated_count}")
        print(f"  Olakšavajući oblici (mitigated): {mitigated_count}")
    
    def _print_confidence_stats(self):
        """Statistika confidence scores."""
        confidences = []
        for ann in self.annotations.values():
            conf = ann.get('confidence')
            if conf is not None:
                confidences.append(conf)
        
        if confidences:
            print("\nKONFIDENCE SCORES:")
            print(f"  Prosečan: {sum(confidences)/len(confidences):.2f}")
            print(f"  Min: {min(confidences):.2f}")
            print(f"  Max: {max(confidences):.2f}")
            
            low_confidence = [c for c in confidences if c < 0.7]
            if low_confidence:
                print(f"  ⚠ Članaka sa niskim confidence (<0.7): {len(low_confidence)}")
    
    def find_articles_by_concept(self, concept: str):
        """
        Pronalazi sve članke koji sadrže određeni pravni koncept.
        
        Args:
            concept: Pravni koncept (npr. "murder", "bodily_harm")
        """
        matching = []
        for art_num, ann in self.annotations.items():
            if concept in ann.get('legal_concepts', []):
                matching.append(art_num)
        
        return matching
    
    def find_articles_by_sanction_range(self, min_years: int, max_years: int):
        """
        Pronalazi članke sa kaznom u određenom rangu.
        
        Args:
            min_years: Minimalna kazna (godine)
            max_years: Maksimalna kazna (godine)
        """
        matching = []
        for art_num, ann in self.annotations.items():
            sanction = ann.get('sanctions', {})
            min_val = sanction.get('min_value')
            max_val = sanction.get('max_value')
            
            if min_val and min_val >= min_years and (max_val is None or max_val <= max_years):
                matching.append(art_num)
        
        return matching
    
    def export_to_csv(self, output_file: str):
        """
        Eksportuje anotacije u CSV format za analizu u Excel/pandas.
        
        Args:
            output_file: Putanja do CSV fajla
        """
        import csv
        
        with open(output_file, 'w', encoding='utf-8', newline='') as f:
            writer = csv.writer(f)
            
            # Header
            writer.writerow([
                'article_number',
                'norm_type',
                'subjects',
                'conditions',
                'legal_concepts',
                'sanction_type',
                'sanction_min',
                'sanction_max',
                'aggravated',
                'mitigated',
                'confidence'
            ])
            
            # Rows
            for art_num, ann in sorted(self.annotations.items(), key=lambda x: int(x[0])):
                sanction = ann.get('sanctions', {})
                qualifiers = ann.get('qualifiers', {})
                
                writer.writerow([
                    art_num,
                    ann.get('norm_type', ''),
                    ';'.join(ann.get('subjects', [])),
                    ';'.join(ann.get('conditions', [])),
                    ';'.join(ann.get('legal_concepts', [])),
                    sanction.get('type', ''),
                    sanction.get('min_value', ''),
                    sanction.get('max_value', ''),
                    qualifiers.get('aggravated', False),
                    qualifiers.get('mitigated', False),
                    ann.get('confidence', '')
                ])
        
        print(f"✓ CSV eksportovan u: {output_file}")


def main():
    """CLI entry point."""
    if len(sys.argv) < 2:
        print("Usage: python analyze_annotations.py <annotations.json>")
        print("\nOpciono:")
        print("  --csv <output.csv>   Eksportuj u CSV format")
        sys.exit(1)
    
    json_file = sys.argv[1]
    
    if not Path(json_file).exists():
        print(f"✗ Fajl '{json_file}' ne postoji.")
        sys.exit(1)
    
    analyzer = AnnotationAnalyzer(json_file)
    
    # Glavni prikaz
    analyzer.print_summary()
    
    # CSV export ako je traženo
    if '--csv' in sys.argv:
        csv_idx = sys.argv.index('--csv')
        if csv_idx + 1 < len(sys.argv):
            csv_file = sys.argv[csv_idx + 1]
            analyzer.export_to_csv(csv_file)
    
    # Interaktivni queries (primeri)
    print("\n" + "=" * 70)
    print("PRIMERI QUERY-A")
    print("=" * 70)
    
    # Pronađi članke o ubistvu
    murder_articles = analyzer.find_articles_by_concept('murder')
    if murder_articles:
        print(f"\nČlanci o ubistvu (murder): {', '.join(murder_articles)}")
    
    # Pronađi članke sa teškom kaznom (>10 godina)
    heavy_sentences = analyzer.find_articles_by_sanction_range(10, 100)
    if heavy_sentences:
        print(f"Članci sa kaznom ≥10 godina: {', '.join(heavy_sentences)}")


if __name__ == "__main__":
    main()
