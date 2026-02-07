"""
Use case for annotating legal documents.

Orchestrates the process of parsing, annotating, and exporting legal documents.
"""

from typing import Optional, Dict
from pathlib import Path

from ...domain.interfaces.parsers import ILegalTextParser
from ...domain.interfaces.annotators import ISemanticAnnotator
from ...domain.interfaces.exporters import IDocumentExporter
from ...domain.entities.legal_document import LegalDocument
from ...domain.entities.annotation import SemanticAnnotation


class AnnotateLegalDocumentUseCase:
    """
    Use case for complete document annotation pipeline.
    
    Follows Single Responsibility Principle - coordinates the annotation workflow.
    """
    
    def __init__(
        self,
        parser: ILegalTextParser,
        annotator: ISemanticAnnotator,
        exporter: IDocumentExporter
    ):
        """
        Initialize use case with dependencies.
        
        Args:
            parser: Legal text parser implementation
            annotator: Semantic annotator implementation
            exporter: Document exporter implementation
        """
        self.parser = parser
        self.annotator = annotator
        self.exporter = exporter
    
    def execute(
        self,
        input_file: str,
        output_file: str,
        article_limit: Optional[int] = None
    ) -> Dict[str, any]:
        """
        Execute the annotation pipeline.
        
        Args:
            input_file: Path to input text file
            output_file: Path to output XML file
            article_limit: Limit number of articles (for testing)
            
        Returns:
            Dictionary with execution results and statistics
        """
        print("=" * 70)
        print("LEGAL DOCUMENT ANNOTATION PIPELINE")
        print("=" * 70)
        print(f"Input:  {input_file}")
        print(f"Output: {output_file}")
        if article_limit:
            print(f"Limit:  {article_limit} articles (test mode)")
        print("=" * 70)
        
        # Phase 1: Parse document
        print("\n[PHASE 1/3] Parsing legal text...")
        document = self._parse_document(input_file)
        
        if not document or not self.parser.validate_structure(document):
            raise ValueError("Failed to parse document or invalid structure")
        
        print(f"  ✓ Parsed: {document.total_chapters()} chapters, {document.total_articles()} articles")
        
        # Phase 2: Semantic annotation
        print("\n[PHASE 2/3] Semantic annotation via LLM...")
        articles = document.get_all_articles()
        
        if article_limit:
            articles = articles[:article_limit]
            print(f"  → Processing {len(articles)} articles (limit applied)")
        
        annotations = self.annotator.annotate_batch(articles)
        
        success_rate = len(annotations) / len(articles) * 100 if articles else 0
        print(f"\n  ✓ Annotated: {len(annotations)}/{len(articles)} ({success_rate:.1f}% success)")
        
        # Phase 3: Export
        print("\n[PHASE 3/3] Exporting to Akoma Ntoso XML...")
        output_path = self.exporter.export(document, annotations, output_file)
        
        if not self.exporter.validate_output(output_path):
            raise ValueError("Failed to validate exported XML")
        
        print(f"  ✓ Exported: {output_path}")
        
        # Statistics
        stats = self._calculate_statistics(document, annotations)
        self._print_statistics(stats)
        
        print("\n" + "=" * 70)
        print("✓ PIPELINE COMPLETED SUCCESSFULLY")
        print("=" * 70)
        
        return {
            "success": True,
            "document": document,
            "annotations": annotations,
            "output_file": output_path,
            "statistics": stats
        }
    
    def _parse_document(self, input_file: str) -> LegalDocument:
        """Parse document from file."""
        with open(input_file, 'r', encoding='utf-8') as f:
            text = f.read()
        
        return self.parser.parse(text)
    
    def _calculate_statistics(
        self,
        document: LegalDocument,
        annotations: Dict[str, SemanticAnnotation]
    ) -> Dict[str, any]:
        """Calculate pipeline statistics."""
        norm_types = {}
        all_concepts = set()
        aggravated_count = 0
        total_sanctions = 0
        
        for annotation in annotations.values():
            # Count norm types
            norm_type = annotation.norm_type.value
            norm_types[norm_type] = norm_types.get(norm_type, 0) + 1
            
            # Collect concepts
            all_concepts.update(annotation.legal_concepts)
            
            # Count qualifiers
            if annotation.is_aggravated():
                aggravated_count += 1
            
            # Count sanctions
            total_sanctions += len(annotation.sanctions)
        
        # Concept frequency
        concept_freq = {}
        for annotation in annotations.values():
            for concept in annotation.legal_concepts:
                concept_freq[concept] = concept_freq.get(concept, 0) + 1
        
        return {
            "total_chapters": document.total_chapters(),
            "total_articles": document.total_articles(),
            "annotated_articles": len(annotations),
            "norm_types": norm_types,
            "total_concepts": len(all_concepts),
            "concept_frequency": concept_freq,
            "aggravated_count": aggravated_count,
            "total_sanctions": total_sanctions
        }
    
    def _print_statistics(self, stats: Dict[str, any]) -> None:
        """Print detailed statistics."""
        print("\n" + "=" * 70)
        print("ANNOTATION STATISTICS")
        print("=" * 70)
        
        print(f"\nStructure:")
        print(f"  - Chapters:  {stats['total_chapters']}")
        print(f"  - Articles:  {stats['total_articles']}")
        print(f"  - Annotated: {stats['annotated_articles']}")
        
        print(f"\nNorm Types:")
        for norm_type, count in sorted(stats['norm_types'].items(), key=lambda x: -x[1]):
            print(f"  - {norm_type}: {count}")
        
        print(f"\nSemantic Analysis:")
        print(f"  - Unique concepts: {stats['total_concepts']}")
        print(f"  - Aggravated forms: {stats['aggravated_count']}")
        print(f"  - Total sanctions: {stats['total_sanctions']}")
        
        # Top concepts
        if stats['concept_frequency']:
            print(f"\nTop Legal Concepts:")
            for concept, count in sorted(
                stats['concept_frequency'].items(),
                key=lambda x: -x[1]
            )[:10]:
                print(f"  - {concept}: {count}x")
        
        print("=" * 70)
