"""Service for loading and processing law documents."""
import sys
from pathlib import Path
from typing import List, Optional, Dict, Any
import json
from xml.etree import ElementTree as ET

# Add parent directory to path
sys.path.append(str(Path(__file__).parent.parent.parent.parent))

from src.akoma_annotation.parser import LegalTextParser
from src.akoma_annotation.references import parse_reference_href


class LawService:
    """Service for law document operations."""

    def __init__(self):
        self.parser = LegalTextParser()
        self.law_file = Path(__file__).parent.parent.parent.parent / "data" / "zakon.txt"
        self.xml_file = Path(__file__).parent.parent.parent.parent / "output" / "annotated_law.xml"
        self.annotations_file = None
        self._chapters = None
        self._annotations = None
        self._xml_references = None

    def _load_law(self):
        """Load and parse law document."""
        if self._chapters is None:
            with open(self.law_file, "r", encoding="utf-8") as f:
                text = f.read()
            self._chapters = self.parser.parse(text)
        return self._chapters

    def _load_annotations(self):
        """Load annotations if available."""
        if self._annotations is None:
            # Try to find annotations file (prefer output folder)
            output_dir = Path(__file__).parent.parent.parent.parent / "output"
            potential_files = list(output_dir.glob("*_annotations.json"))
            if not potential_files:
                potential_files = list(Path(self.law_file.parent).glob("*_annotations.json"))
            if potential_files:
                with open(potential_files[0], "r", encoding="utf-8") as f:
                    self._annotations = json.load(f)
            else:
                self._annotations = {}
        return self._annotations

    def _load_xml_references(self):
        """Load references from XML file."""
        if self._xml_references is None:
            self._xml_references = {}
            if not self.xml_file.exists():
                return self._xml_references

            try:
                tree = ET.parse(self.xml_file)
                root = tree.getroot()
                
                # Find all articles
                for article in root.findall(".//{http://docs.oasis-open.org/legaldocml/ns/akn/3.0/WD17}article"):
                    article_id = article.get("eId", "")
                    if not article_id.startswith("art_"):
                        continue
                    
                    article_number = article_id.replace("art_", "")
                    references = []
                    
                    # Find all ref elements within this article
                    for ref in article.findall(".//{http://docs.oasis-open.org/legaldocml/ns/akn/3.0/WD17}ref"):
                        href = ref.get("href", "")
                        text = ref.text or ""
                        parsed_ref = parse_reference_href(href)
                        
                        ref_data = {
                            "href": href,
                            "text": text,
                            "normalized_href": parsed_ref["normalized_href"],
                            "reference_kind": parsed_ref["kind"],
                            "target_article": parsed_ref["article_number"],
                            "target_paragraph": parsed_ref["paragraph_number"],
                            "target_point": parsed_ref["point_number"],
                        }
                        references.append(ref_data)
                    
                    if references:
                        self._xml_references[article_number] = references
            except Exception as e:
                print(f"Error loading XML references: {e}")
                
        return self._xml_references

    def get_all_chapters(self):
        """Get all law chapters."""
        chapters = self._load_law()
        return [
            {
                "number": ch.number,
                "title": ch.title,
                "article_count": len(ch.articles)
            }
            for ch in chapters
        ]

    def get_chapter(self, chapter_number: str):
        """Get specific chapter with articles."""
        chapters = self._load_law()
        annotations = self._load_annotations()

        for chapter in chapters:
            if chapter.number == chapter_number:
                return {
                    "number": chapter.number,
                    "title": chapter.title,
                    "articles": [
                        self._format_article(art, annotations, chapter.number)
                        for art in chapter.articles
                    ]
                }
        return None

    def get_article(self, article_number: str):
        """Get specific article."""
        chapters = self._load_law()
        annotations = self._load_annotations()

        for chapter in chapters:
            for article in chapter.articles:
                if article.number == article_number:
                    return self._format_article(article, annotations, chapter.number)
        return None

    def _format_article(self, article, annotations, chapter_number: Optional[str] = None):
        """Format article with annotations."""
        content = self.parser.get_article_full_text(article)
        annotation = annotations.get(article.number, {})
        xml_references = self._load_xml_references()
        article_references = xml_references.get(article.number, [])

        return {
            "number": article.number,
            "chapter_number": chapter_number,
            "title": article.title,
            "content": content,
            "norm_type": annotation.get("norm_type"),
            "subjects": annotation.get("subjects", []),
            "legal_concepts": annotation.get("legal_concepts", []),
            "sanctions": annotation.get("sanctions"),
            "conditions": annotation.get("conditions", []),
            "references": article_references if article_references else annotation.get("references", [])
        }

    def search_articles(self, query: str):
        """Search articles by text or concept."""
        chapters = self._load_law()
        annotations = self._load_annotations()
        results = []

        query_lower = query.lower()

        for chapter in chapters:
            for article in chapter.articles:
                # Search in content
                content = self.parser.get_article_full_text(article)
                if query_lower in content.lower():
                    results.append(self._format_article(article, annotations, chapter.number))
                    continue

                # Search in concepts
                annotation = annotations.get(article.number, {})
                concepts = annotation.get("legal_concepts", [])
                if any(query_lower in c.lower() for c in concepts):
                    results.append(self._format_article(article, annotations, chapter.number))
                    continue

        return results
