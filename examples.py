"""
Example: How to use the refactored system
"""

from pathlib import Path
from src.config.app_config import ApplicationConfig
from src.application.container import DependencyContainer
from src.domain.entities.legal_document import LegalArticle, LegalParagraph


def example_1_basic_usage():
    """Example 1: Basic annotation pipeline."""
    print("=" * 70)
    print("EXAMPLE 1: Basic Annotation Pipeline")
    print("=" * 70)
    
    # Create configuration from environment
    config = ApplicationConfig.from_env()
    
    # Create dependency container
    container = DependencyContainer(config)
    
    # Get use case
    use_case = container.get_annotate_document_use_case()
    
    # Execute pipeline
    result = use_case.execute(
        input_file="zakon.txt",
        output_file="output_example.xml",
        article_limit=5  # Process only first 5 articles
    )
    
    print(f"\nSuccess: {result['success']}")
    print(f"Total articles: {result['document'].total_articles()}")
    print(f"Annotated: {len(result['annotations'])}")


def example_2_custom_parser():
    """Example 2: Using custom parser."""
    print("\n" + "=" * 70)
    print("EXAMPLE 2: Custom Parser")
    print("=" * 70)
    
    from src.infrastructure.parsers import RegexLegalTextParser
    
    # Create parser
    parser = RegexLegalTextParser()
    
    # Parse text
    with open("zakon.txt", "r", encoding="utf-8") as f:
        text = f.read()
    
    document = parser.parse(text)
    
    # Print statistics
    print(f"Chapters: {document.total_chapters()}")
    print(f"Articles: {document.total_articles()}")
    
    # Find specific article
    article = document.find_article("143")
    if article:
        print(f"\nFound article: {article.number}")
        print(f"Title: {article.title}")
        print(f"Paragraphs: {article.paragraph_count()}")


def example_3_working_with_entities():
    """Example 3: Working with domain entities."""
    print("\n" + "=" * 70)
    print("EXAMPLE 3: Domain Entities")
    print("=" * 70)
    
    from src.domain.entities.legal_document import (
        LegalDocument, LegalChapter, LegalArticle, LegalParagraph
    )
    
    # Create document
    doc = LegalDocument(
        name="Krivični zakonik Crne Gore",
        country_code="me",
        year="2024"
    )
    
    # Create chapter
    chapter = LegalChapter(
        number="I",
        title="OSNOVNE ODREDBE"
    )
    
    # Create article
    article = LegalArticle(
        number="1",
        title="Primena krivičnog zakonika"
    )
    
    # Create paragraph
    paragraph = LegalParagraph(
        number=None,  # First paragraph is unnumbered
        text="Krivična dela i krivične sankcije propisane su zakonom.",
        raw_text="Krivična dela i krivične sankcije propisane su zakonom."
    )
    
    # Assemble structure
    article.add_paragraph(paragraph)
    chapter.add_article(article)
    doc.add_chapter(chapter)
    
    # Access data
    print(f"Document: {doc.name}")
    print(f"Total chapters: {doc.total_chapters()}")
    print(f"Article text:\n{article.get_full_text()}")


def example_4_annotations():
    """Example 4: Working with annotations."""
    print("\n" + "=" * 70)
    print("EXAMPLE 4: Semantic Annotations")
    print("=" * 70)
    
    from src.domain.entities.annotation import (
        SemanticAnnotation, NormType, Sanction, SanctionType, LegalReference
    )
    
    # Create annotation
    annotation = SemanticAnnotation(
        article_number="143",
        norm_type=NormType.PROHIBITION,
        subjects=["perpetrator", "victim"],
        conditions=["intent"],
        legal_concepts=["murder", "homicide"],
        qualifiers={"aggravated": False}
    )
    
    # Add sanction
    sanction = Sanction(
        sanction_type=SanctionType.PRISON,
        min_value=5,
        max_value=15,
        unit="years"
    )
    annotation.add_sanction(sanction)
    
    # Add reference
    reference = LegalReference(
        reference_type="internal",
        target="Član 144",
        article_number="144"
    )
    annotation.add_reference(reference)
    
    # Print annotation
    print(f"Article: {annotation.article_number}")
    print(f"Norm Type: {annotation.norm_type.value}")
    print(f"Subjects: {', '.join(annotation.subjects)}")
    print(f"Has sanctions: {annotation.has_sanctions()}")
    print(f"Aggravated: {annotation.is_aggravated()}")
    
    # Convert to dict
    data = annotation.to_dict()
    print(f"\nAs dictionary: {data}")


def example_5_dependency_injection():
    """Example 5: Dependency injection and testing."""
    print("\n" + "=" * 70)
    print("EXAMPLE 5: Dependency Injection")
    print("=" * 70)
    
    from src.domain.interfaces.annotators import ISemanticAnnotator
    from src.domain.entities.legal_document import LegalArticle
    from src.domain.entities.annotation import SemanticAnnotation, NormType
    
    # Create mock annotator for testing
    class MockAnnotator(ISemanticAnnotator):
        """Mock annotator for testing."""
        
        def annotate_article(self, article):
            return SemanticAnnotation(
                article_number=article.number,
                norm_type=NormType.PROHIBITION,
                subjects=["test"],
                conditions=["test"],
                legal_concepts=["test"]
            )
        
        def annotate_batch(self, articles, batch_size=1):
            return {
                art.number: self.annotate_article(art)
                for art in articles
            }
        
        def validate_annotation(self, annotation):
            return True
    
    # Use mock in container
    config = ApplicationConfig.from_env()
    container = DependencyContainer(config)
    
    # Replace real annotator with mock
    container._annotator = MockAnnotator()
    
    # Now use case will use mock annotator
    use_case = container.get_annotate_document_use_case()
    
    print("Mock annotator created and injected")
    print("Use case can now be tested without calling real LLM API")


def example_6_extensibility():
    """Example 6: Extending the system."""
    print("\n" + "=" * 70)
    print("EXAMPLE 6: System Extensibility")
    print("=" * 70)
    
    from src.domain.interfaces.exporters import IDocumentExporter
    from src.domain.entities.legal_document import LegalDocument
    
    # Create custom exporter for JSON format
    class JSONExporter(IDocumentExporter):
        """Export documents to JSON format."""
        
        def export(self, document, annotations, output_path):
            import json
            
            data = {
                "name": document.name,
                "chapters": document.total_chapters(),
                "articles": document.total_articles(),
                "annotations": len(annotations)
            }
            
            with open(output_path, "w", encoding="utf-8") as f:
                json.dump(data, f, indent=2, ensure_ascii=False)
            
            return output_path
        
        def validate_output(self, output_path):
            import json
            try:
                with open(output_path, "r") as f:
                    json.load(f)
                return True
            except:
                return False
    
    # Use custom exporter
    config = ApplicationConfig.from_env()
    container = DependencyContainer(config)
    
    # Replace exporter
    container._exporter = JSONExporter()
    
    print("Custom JSON exporter created")
    print("System can now export to JSON format")
    print("This demonstrates Open/Closed Principle - open for extension!")


if __name__ == "__main__":
    # Run examples
    print("REFACTORED SYSTEM - USAGE EXAMPLES")
    print("=" * 70)
    
    # Uncomment to run specific examples
    # example_1_basic_usage()
    example_2_custom_parser()
    example_3_working_with_entities()
    example_4_annotations()
    # example_5_dependency_injection()
    example_6_extensibility()
    
    print("\n" + "=" * 70)
    print("Examples completed!")
    print("=" * 70)
