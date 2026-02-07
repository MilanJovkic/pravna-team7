"""
Akoma Ntoso XML exporter implementation.

Exports legal documents to Akoma Ntoso 3.0 format.
"""

from datetime import datetime
from typing import Dict
from xml.etree.ElementTree import Element, SubElement, ElementTree
from xml.dom import minidom

from ...domain.interfaces.exporters import IDocumentExporter
from ...domain.entities.legal_document import LegalDocument, LegalChapter, LegalArticle
from ...domain.entities.annotation import SemanticAnnotation


class AkomaNtosoExporter(IDocumentExporter):
    """
    Exports legal documents to Akoma Ntoso XML format.
    
    Follows Akoma Ntoso 3.0 specification.
    """
    
    AKOMA_NS = "http://docs.oasis-open.org/legaldocml/ns/akn/3.0/WD17"
    
    def __init__(
        self,
        law_name: str = "Krivični zakonik Crne Gore",
        country_code: str = "me",
        law_year: str = "2024"
    ):
        """
        Initialize exporter.
        
        Args:
            law_name: Name of the law
            country_code: ISO country code
            law_year: Year of the law
        """
        self.law_name = law_name
        self.country_code = country_code
        self.law_year = law_year
        self.current_date = datetime.now().strftime("%Y-%m-%d")
    
    def export(
        self,
        document: LegalDocument,
        annotations: Dict[str, SemanticAnnotation],
        output_path: str
    ) -> str:
        """
        Export document to Akoma Ntoso XML.
        
        Args:
            document: Legal document to export
            annotations: Semantic annotations
            output_path: Output file path
            
        Returns:
            Path to created file
        """
        # Create root element
        root = Element(
            f"{{{self.AKOMA_NS}}}akomaNtoso",
            attrib={
                "xmlns": self.AKOMA_NS,
                "xmlns:xsi": "http://www.w3.org/2001/XMLSchema-instance"
            }
        )
        
        # Create <act>
        act = SubElement(root, "act", name=document.name)
        
        # Add metadata
        self._build_meta(act)
        
        # Add body
        body = SubElement(act, "body")
        
        # Add chapters
        for chapter in document.chapters:
            self._build_chapter(body, chapter, annotations)
        
        # Write to file
        self._write_pretty_xml(root, output_path)
        
        return output_path
    
    def validate_output(self, output_path: str) -> bool:
        """
        Validate exported XML file.
        
        Args:
            output_path: Path to XML file
            
        Returns:
            True if valid
        """
        try:
            tree = ElementTree()
            tree.parse(output_path)
            return True
        except Exception:
            return False
    
    def _build_meta(self, act_element: Element) -> None:
        """Build metadata section."""
        meta = SubElement(act_element, "meta")
        
        # Identification
        identification = SubElement(meta, "identification", source="#auto")
        
        # FRBRWork
        frbrwork = SubElement(identification, "FRBRWork")
        SubElement(frbrwork, "FRBRthis", value=f"/akn/{self.country_code}/act/{self.law_year}/1/main")
        SubElement(frbrwork, "FRBRuri", value=f"/akn/{self.country_code}/act/{self.law_year}/1")
        SubElement(frbrwork, "FRBRdate", date=self.law_year, name="Generation")
        SubElement(frbrwork, "FRBRauthor", href=f"#{self.country_code}")
        SubElement(frbrwork, "FRBRcountry", value=self.country_code)
        
        # FRBRExpression
        frbrexpression = SubElement(identification, "FRBRExpression")
        SubElement(frbrexpression, "FRBRthis", value=f"/akn/{self.country_code}/act/{self.law_year}/1/srp@/main")
        SubElement(frbrexpression, "FRBRuri", value=f"/akn/{self.country_code}/act/{self.law_year}/1/srp@")
        SubElement(frbrexpression, "FRBRdate", date=self.current_date, name="Generation")
        SubElement(frbrexpression, "FRBRauthor", href="#llm-annotator")
        SubElement(frbrexpression, "FRBRlanguage", language="srp")
        
        # FRBRManifestation
        frbrmanifestation = SubElement(identification, "FRBRManifestation")
        SubElement(frbrmanifestation, "FRBRthis", value=f"/akn/{self.country_code}/act/{self.law_year}/1/srp@/main.xml")
        SubElement(frbrmanifestation, "FRBRuri", value=f"/akn/{self.country_code}/act/{self.law_year}/1/srp@.xml")
        SubElement(frbrmanifestation, "FRBRdate", date=self.current_date, name="XMLConversion")
        SubElement(frbrmanifestation, "FRBRauthor", href="#llm-annotator")
    
    def _build_chapter(
        self,
        body: Element,
        chapter: LegalChapter,
        annotations: Dict[str, SemanticAnnotation]
    ) -> None:
        """Build chapter element."""
        chapter_elem = SubElement(
            body,
            "chapter",
            eId=f"chp_{chapter.number}"
        )
        
        # Chapter number and heading
        num = SubElement(chapter_elem, "num")
        num.text = f"GLAVA {chapter.number}"
        
        heading = SubElement(chapter_elem, "heading")
        heading.text = chapter.title
        
        # Articles
        for article in chapter.articles:
            self._build_article(chapter_elem, article, annotations)
    
    def _build_article(
        self,
        parent: Element,
        article: LegalArticle,
        annotations: Dict[str, SemanticAnnotation]
    ) -> None:
        """Build article element."""
        article_elem = SubElement(
            parent,
            "article",
            eId=f"art_{article.number}"
        )
        
        # Article number
        num = SubElement(article_elem, "num")
        num.text = f"Član {article.number}"
        
        # Article title (if exists)
        if article.title:
            heading = SubElement(article_elem, "heading")
            heading.text = article.title
        
        # Paragraphs
        for para in article.paragraphs:
            para_elem = SubElement(
                article_elem,
                "paragraph",
                eId=f"art_{article.number}_para_{para.number or '1'}"
            )
            
            if para.number:
                num = SubElement(para_elem, "num")
                num.text = f"({para.number})"
            
            content = SubElement(para_elem, "content")
            p = SubElement(content, "p")
            p.text = para.text
            
            # Points
            if para.points:
                for point in para.points:
                    point_elem = SubElement(content, "point")
                    num = SubElement(point_elem, "num")
                    num.text = f"{point.number})"
                    p = SubElement(point_elem, "p")
                    p.text = point.text
        
        # Add semantic annotations as notes
        if article.number in annotations:
            self._add_annotation_notes(article_elem, annotations[article.number])
    
    def _add_annotation_notes(
        self,
        article_elem: Element,
        annotation: SemanticAnnotation
    ) -> None:
        """Add semantic annotations as notes."""
        notes = SubElement(article_elem, "notes", source="#llm-annotation")
        
        # Norm type
        note = SubElement(notes, "note", type="normType")
        p = SubElement(note, "p")
        p.text = annotation.norm_type.value
        
        # Legal concepts
        if annotation.legal_concepts:
            note = SubElement(notes, "note", type="legalConcepts")
            p = SubElement(note, "p")
            p.text = ", ".join(annotation.legal_concepts)
        
        # Sanctions
        if annotation.sanctions:
            for sanction in annotation.sanctions:
                note = SubElement(notes, "note", type="sanction")
                p = SubElement(note, "p")
                p.text = f"{sanction.sanction_type.value}: {sanction.min_value}-{sanction.max_value} {sanction.unit}"
    
    def _write_pretty_xml(self, root: Element, output_path: str) -> None:
        """Write XML with pretty formatting."""
        from xml.etree.ElementTree import tostring
        
        xml_str = tostring(root, encoding='unicode')
        pretty_xml = minidom.parseString(xml_str).toprettyxml(indent="  ")
        
        # Remove empty lines
        lines = [line for line in pretty_xml.split('\n') if line.strip()]
        pretty_xml = '\n'.join(lines)
        
        with open(output_path, 'w', encoding='utf-8') as f:
            f.write(pretty_xml)
