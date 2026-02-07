"""
Ekstrakcija knowledge graph triplets-a iz anotiranih članaka.

Generiše RDF/turtle ili JSON-LD format za dalju upotrebu u graph databases.
"""

import json
from typing import List, Tuple, Dict


class KnowledgeGraphExtractor:
    """
    Ekstraktuje triplete (subjekt-predikat-objekt) iz semantičkih anotacija.
    
    Primjer:
        Article143 hasNormType Prohibition
        Article143 prescribesSanction Prison_5_15_years
        Article143 involvesConcept Murder
    """
    
    def __init__(self, annotations_file: str):
        """
        Args:
            annotations_file: JSON fajl sa anotacijama
        """
        with open(annotations_file, 'r', encoding='utf-8') as f:
            self.annotations = json.load(f)
    
    def extract_triplets(self) -> List[Tuple[str, str, str]]:
        """
        Ekstraktuje SVE triplete iz anotacija.
        
        Returns:
            Lista (subject, predicate, object) tuple-ova
        """
        triplets = []
        
        for art_num, ann in self.annotations.items():
            article_uri = f"Article{art_num}"
            
            # Norm type
            norm_type = ann.get('norm_type')
            if norm_type:
                triplets.append((
                    article_uri,
                    "hasNormType",
                    norm_type.capitalize()
                ))
            
            # Subjects
            for subject in ann.get('subjects', []):
                triplets.append((
                    article_uri,
                    "involvesSubject",
                    subject
                ))
            
            # Conditions
            for condition in ann.get('conditions', []):
                triplets.append((
                    article_uri,
                    "requiresCondition",
                    condition
                ))
            
            # Legal concepts
            for concept in ann.get('legal_concepts', []):
                triplets.append((
                    article_uri,
                    "involvesConcept",
                    concept.capitalize()
                ))
            
            # Sanctions
            sanction = ann.get('sanctions', {})
            if sanction.get('type'):
                sanction_uri = self._create_sanction_uri(sanction, art_num)
                triplets.append((
                    article_uri,
                    "prescribesSanction",
                    sanction_uri
                ))
                
                # Detalji sankcije
                if sanction.get('type'):
                    triplets.append((
                        sanction_uri,
                        "hasSanctionType",
                        sanction['type'].capitalize()
                    ))
                
                if sanction.get('min_value'):
                    triplets.append((
                        sanction_uri,
                        "hasMinimumDuration",
                        f"{sanction['min_value']}{sanction.get('min_unit', 'years')}"
                    ))
                
                if sanction.get('max_value'):
                    triplets.append((
                        sanction_uri,
                        "hasMaximumDuration",
                        f"{sanction['max_value']}{sanction.get('max_unit', 'years')}"
                    ))
            
            # Qualifiers
            qualifiers = ann.get('qualifiers', {})
            if qualifiers.get('aggravated'):
                triplets.append((
                    article_uri,
                    "isAggravatedForm",
                    "true"
                ))
            
            if qualifiers.get('mitigated'):
                triplets.append((
                    article_uri,
                    "isMitigatedForm",
                    "true"
                ))
            
            # References
            for ref in ann.get('references', []):
                if ref.get('type') == 'internal':
                    target_article = ref.get('article_number')
                    if target_article:
                        triplets.append((
                            article_uri,
                            "referencesArticle",
                            f"Article{target_article}"
                        ))
        
        return triplets
    
    def _create_sanction_uri(self, sanction: Dict, article_num: str) -> str:
        """Kreira URI za sankciju."""
        sanction_type = sanction.get('type', 'unknown')
        min_val = sanction.get('min_value', '')
        max_val = sanction.get('max_value', '')
        
        return f"Sanction_{sanction_type}_{article_num}_{min_val}_{max_val}"
    
    def export_turtle(self, output_file: str):
        """
        Eksportuje triplete u RDF Turtle format.
        
        Args:
            output_file: Putanja do .ttl fajla
        """
        triplets = self.extract_triplets()
        
        with open(output_file, 'w', encoding='utf-8') as f:
            # Prefiksi
            f.write("@prefix law: <http://example.org/criminal-law#> .\n")
            f.write("@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .\n")
            f.write("@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .\n\n")
            
            # Triplete
            for subj, pred, obj in triplets:
                # Escape spaces u URI-jima
                subj_uri = subj.replace(' ', '_')
                obj_uri = obj.replace(' ', '_')
                
                f.write(f"law:{subj_uri} law:{pred} law:{obj_uri} .\n")
        
        print(f"✓ RDF Turtle eksportovan u: {output_file}")
        print(f"  Ukupno triplets: {len(triplets)}")
    
    def export_json_ld(self, output_file: str):
        """
        Eksportuje triplete u JSON-LD format.
        
        Args:
            output_file: Putanja do .jsonld fajla
        """
        triplets = self.extract_triplets()
        
        # Organizuj triplete po subjektima
        graph = {}
        for subj, pred, obj in triplets:
            if subj not in graph:
                graph[subj] = {"@id": f"law:{subj}", "@type": "LegalArticle"}
            
            # Dodaj predikat-objekt par
            if pred not in graph[subj]:
                graph[subj][pred] = []
            
            graph[subj][pred].append({"@id": f"law:{obj}"})
        
        json_ld = {
            "@context": {
                "law": "http://example.org/criminal-law#",
                "rdf": "http://www.w3.org/1999/02/22-rdf-syntax-ns#",
                "rdfs": "http://www.w3.org/2000/01/rdf-schema#"
            },
            "@graph": list(graph.values())
        }
        
        with open(output_file, 'w', encoding='utf-8') as f:
            json.dump(json_ld, f, indent=2, ensure_ascii=False)
        
        print(f"✓ JSON-LD eksportovan u: {output_file}")
        print(f"  Ukupno entiteta: {len(graph)}")
    
    def export_cypher(self, output_file: str):
        """
        Eksportuje triplete kao Neo4j Cypher upite.
        
        Args:
            output_file: Putanja do .cypher fajla
        """
        triplets = self.extract_triplets()
        
        with open(output_file, 'w', encoding='utf-8') as f:
            f.write("// Neo4j Cypher import script\n")
            f.write("// Koristiti u Neo4j Browser ili cypher-shell\n\n")
            
            # Kreiraj nodove
            articles = set()
            concepts = set()
            sanctions = set()
            
            for subj, pred, obj in triplets:
                if subj.startswith('Article'):
                    articles.add(subj)
                if pred == 'involvesConcept':
                    concepts.add(obj)
                if pred == 'prescribesSanction':
                    sanctions.add(obj)
            
            # CREATE nodove
            for article in articles:
                f.write(f"CREATE (:{article}:LegalArticle {{id: '{article}'}});\n")
            
            f.write("\n")
            
            for concept in concepts:
                f.write(f"CREATE (:{concept}:LegalConcept {{name: '{concept}'}});\n")
            
            f.write("\n")
            
            for sanction in sanctions:
                f.write(f"CREATE (:{sanction}:Sanction {{id: '{sanction}'}});\n")
            
            f.write("\n// CREATE relationships\n")
            
            # CREATE relacije
            for subj, pred, obj in triplets:
                f.write(f"MATCH (a:{subj}), (b:{obj}) CREATE (a)-[:{pred}]->(b);\n")
        
        print(f"✓ Cypher script eksportovan u: {output_file}")
        print(f"  Ukupno triplets: {len(triplets)}")
        print(f"\nImport u Neo4j:")
        print(f"  1. Pokreni Neo4j Desktop")
        print(f"  2. Otvori Browser")
        print(f"  3. Kopiraj sadržaj {output_file} i izvrši")
    
    def print_statistics(self):
        """Ispisuje statistiku knowledge graph-a."""
        triplets = self.extract_triplets()
        
        # Brojanje po predikatima
        predicate_counts = {}
        for _, pred, _ in triplets:
            predicate_counts[pred] = predicate_counts.get(pred, 0) + 1
        
        print("=" * 70)
        print("KNOWLEDGE GRAPH STATISTIKA")
        print("=" * 70)
        print(f"Ukupno triplets: {len(triplets)}\n")
        
        print("Triplets po predikatima:")
        for pred, count in sorted(predicate_counts.items(), key=lambda x: -x[1]):
            print(f"  {pred:30s} {count:4d}")
        
        print("=" * 70)


def main():
    """CLI entry point."""
    import sys
    
    if len(sys.argv) < 2:
        print("Usage: python extract_knowledge_graph.py <annotations.json>")
        print("\nOptions:")
        print("  --turtle <output.ttl>      Export as RDF Turtle")
        print("  --jsonld <output.jsonld>   Export as JSON-LD")
        print("  --cypher <output.cypher>   Export as Neo4j Cypher")
        print("  --all                      Export all formats")
        sys.exit(1)
    
    annotations_file = sys.argv[1]
    
    extractor = KnowledgeGraphExtractor(annotations_file)
    
    # Statistika
    extractor.print_statistics()
    
    # Export
    if '--turtle' in sys.argv:
        idx = sys.argv.index('--turtle')
        output = sys.argv[idx + 1]
        extractor.export_turtle(output)
    
    if '--jsonld' in sys.argv:
        idx = sys.argv.index('--jsonld')
        output = sys.argv[idx + 1]
        extractor.export_json_ld(output)
    
    if '--cypher' in sys.argv:
        idx = sys.argv.index('--cypher')
        output = sys.argv[idx + 1]
        extractor.export_cypher(output)
    
    if '--all' in sys.argv:
        base = annotations_file.replace('_annotations.json', '')
        extractor.export_turtle(f"{base}_graph.ttl")
        extractor.export_json_ld(f"{base}_graph.jsonld")
        extractor.export_cypher(f"{base}_graph.cypher")


if __name__ == "__main__":
    main()
