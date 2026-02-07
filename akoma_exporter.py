"""
Modul za generisanje AKOMA Ntoso XML-a iz anotiranih pravnih tekstova.

Generiše XML strukturu kompatibilnu sa AKOMA Ntoso 3.0 standardom.
"""

from datetime import datetime
from typing import List, Dict, Optional
from xml.etree.ElementTree import Element, SubElement, tostring, ElementTree
from xml.dom import minidom
from legal_parser import LegalChapter, LegalArticle, LegalParagraph, LegalPoint
from llm_annotator import SemanticAnnotation


class AkomaExporter:
    """
    Eksportuje parsovane i anotirane pravne tekstove u AKOMA Ntoso XML format.
    
    AKOMA Ntoso elementi:
    - akomaNtoso (root)
    - act
    - meta (metapodaci)
    - body (sadržaj)
    - chapter (glava)
    - article (član)
    - paragraph (stav)
    - point (tačka)
    """
    
    AKOMA_NS = "http://docs.oasis-open.org/legaldocml/ns/akn/3.0/WD17"
    
    def __init__(
        self,
        law_name: str = "Krivični zakonik Crne Gore",
        country_code: str = "me",
        law_year: str = "2024"
    ):
        """
        Inicijalizacija exportera.
        
        Args:
            law_name: Naziv zakona
            country_code: ISO kod zemlje (me za Crnu Goru)
            law_year: Godina zakona
        """
        self.law_name = law_name
        self.country_code = country_code
        self.law_year = law_year
        self.current_date = datetime.now().strftime("%Y-%m-%d")
    
    def export(
        self,
        chapters: List[LegalChapter],
        annotations: Dict[str, SemanticAnnotation],  # String keys (podržava "151a")
        output_file: str
    ) -> str:
        """
        Glavni metod za eksport u AKOMA Ntoso XML.
        
        Args:
            chapters: Lista LegalChapter objekata
            annotations: Dict {article_number: SemanticAnnotation} sa string keys
            output_file: Putanja do izlaznog XML fajla
            
        Returns:
            Putanja do generisanog fajla
        """
        # Kreiraj root element
        root = Element(
            f"{{{self.AKOMA_NS}}}akomaNtoso",
            attrib={
                "xmlns": self.AKOMA_NS,
                "xmlns:xsi": "http://www.w3.org/2001/XMLSchema-instance"
            }
        )
        
        # <act>
        act = SubElement(root, "act", name=self.law_name)
        
        # <meta>
        self._build_meta(act)
        
        # <body>
        body = SubElement(act, "body")
        
        # Dodaj glave i članke
        for chapter in chapters:
            self._build_chapter(body, chapter, annotations)
        
        # Snimi u fajl
        self._write_pretty_xml(root, output_file)
        
        return output_file
    
    def _build_meta(self, act_element: Element) -> None:
        """Kreira <meta> sekciju sa FRBRWork, FRBRExpression, FRBRManifestation."""
        meta = SubElement(act_element, "meta")
        
        # Identification
        identification = SubElement(meta, "identification", source="#auto")
        
        # FRBRWork (apstraktni nivo)
        work = SubElement(identification, "FRBRWork")
        SubElement(work, "FRBRthis", value=f"/akn/{self.country_code}/act/{self.law_year}/!main")
        SubElement(work, "FRBRuri", value=f"/akn/{self.country_code}/act/{self.law_year}")
        SubElement(work, "FRBRdate", date=self.current_date)
        SubElement(work, "FRBRauthor", href="#parliament")
        SubElement(work, "FRBRcountry", value=self.country_code)
        SubElement(work, "FRBRsubtype", value="act")
        SubElement(work, "FRBRnumber", value=self.law_year)
        SubElement(work, "FRBRname", value=self.law_name)
        
        # FRBRExpression (lingvistička verzija)
        expression = SubElement(identification, "FRBRExpression")
        SubElement(expression, "FRBRthis", value=f"/akn/{self.country_code}/act/{self.law_year}/sr@{self.current_date}/!main")
        SubElement(expression, "FRBRuri", value=f"/akn/{self.country_code}/act/{self.law_year}/sr@{self.current_date}")
        SubElement(expression, "FRBRdate", date=self.current_date)
        SubElement(expression, "FRBRauthor", href="#auto")
        SubElement(expression, "FRBRlanguage", language="sr")
        
        # FRBRManifestation (fizički fajl)
        manifestation = SubElement(identification, "FRBRManifestation")
        SubElement(manifestation, "FRBRthis", value=f"/akn/{self.country_code}/act/{self.law_year}/sr@{self.current_date}/!main.xml")
        SubElement(manifestation, "FRBRuri", value=f"/akn/{self.country_code}/act/{self.law_year}/sr@{self.current_date}/!main.akn")
        SubElement(manifestation, "FRBRdate", date=self.current_date)
        SubElement(manifestation, "FRBRauthor", href="#auto")
        SubElement(manifestation, "FRBRformat", value="xml")
        
        # Classification (semantičke kategorije iz anotacija)
        classification = SubElement(meta, "classification", source="#auto")
        SubElement(classification, "keyword", value="criminal_law", showAs="Krivično pravo")
        
        # References (entiteti)
        references = SubElement(meta, "references", source="#auto")
        SubElement(references, "TLCOrganization", eId="parliament", 
                   href=f"/akn/{self.country_code}/ontology/organization/parliament",
                   showAs="Skupština Crne Gore")
        SubElement(references, "TLCPerson", eId="auto",
                   href=f"/akn/{self.country_code}/ontology/person/auto",
                   showAs="Automatski generator")
    
    def _build_chapter(
        self,
        body: Element,
        chapter: LegalChapter,
        annotations: Dict[str, SemanticAnnotation]  # String keys
    ) -> None:
        """Kreira <chapter> element sa svim člancima."""
        chapter_id = f"chp_{chapter.number.lower()}"
        chapter_elem = SubElement(body, "chapter", eId=chapter_id)
        
        # Broj glave
        SubElement(chapter_elem, "num").text = chapter.number
        
        # Naslov glave
        SubElement(chapter_elem, "heading").text = chapter.title
        
        # Dodaj članke
        for article in chapter.articles:
            self._build_article(chapter_elem, article, annotations.get(article.number))
    
    def _build_article(
        self,
        parent: Element,
        article: LegalArticle,
        annotation: Optional[SemanticAnnotation]
    ) -> None:
        """
        Kreira <article> element sa paragrafima i semantičkim atributima.
        
        KLJUČNO: Ovde inkorporiramo semantičku anotaciju kao XML atribute.
        """
        # Generiši eId (zameni slova sa _ npr. 151a -> art_151a)
        article_id = f"art_{article.number}"
        
        # Pripremi atribute sa semantičkom anotacijom
        attribs = {"eId": article_id}
        
        if annotation:
            # Dodaj semantičke atribute (custom namespace ili data-*)
            attribs["data-norm-type"] = annotation.norm_type
            
            if annotation.subjects:
                attribs["data-subjects"] = ",".join(annotation.subjects)
            
            if annotation.legal_concepts:
                attribs["data-concepts"] = ",".join(annotation.legal_concepts)
            
            if annotation.qualifiers.get("aggravated"):
                attribs["data-aggravated"] = "true"
        
        article_elem = SubElement(parent, "article", attrib=attribs)
        
        # Broj člana
        SubElement(article_elem, "num").text = f"Člан {article.number}"
        
        # Naslov člana (ako postoji)
        if article.title:
            SubElement(article_elem, "heading").text = article.title
        
        # Paragrafi
        for idx, paragraph in enumerate(article.paragraphs, 1):
            self._build_paragraph(article_elem, paragraph, article.number, idx, annotation)
    
    def _build_paragraph(
        self,
        article_elem: Element,
        paragraph: LegalParagraph,
        article_number: str,  # String umesto int (podržava 151a)
        para_index: int,
        annotation: Optional[SemanticAnnotation]
    ) -> None:
        """Kreira <paragraph> element sa eventualnim tačkama."""
        para_num = paragraph.number if paragraph.number else para_index
        para_id = f"art_{article_number}__para_{para_num}"
        
        para_elem = SubElement(article_elem, "paragraph", eId=para_id)
        
        # Ako ima tačke, dodaj <intro>
        if paragraph.points:
            intro = SubElement(para_elem, "intro", eId=f"{para_id}__intro")
            SubElement(intro, "p").text = paragraph.text
            
            # Dodaj tačke
            for point in paragraph.points:
                self._build_point(para_elem, point, para_id)
        else:
            # Obični paragraf bez tačaka
            content = SubElement(para_elem, "content", eId=f"{para_id}__content")
            p = SubElement(content, "p")
            p.text = paragraph.text
            
            # Dodaj semantičke anotacije kao komentare ili custom elemente
            if annotation:
                self._add_semantic_annotations(p, annotation)
    
    def _build_point(
        self,
        para_elem: Element,
        point: LegalPoint,
        para_id: str
    ) -> None:
        """Kreira <point> element."""
        point_id = f"{para_id}__point_{point.number}"
        point_elem = SubElement(para_elem, "point", eId=point_id)
        
        SubElement(point_elem, "num").text = f"{point.number})"
        
        content = SubElement(point_elem, "content")
        SubElement(content, "p").text = point.text
    
    def _add_semantic_annotations(
        self,
        p_element: Element,
        annotation: SemanticAnnotation
    ) -> None:
        """
        Dodaje semantičke anotacije kao inline elemente ili atribute.
        
        Ovo je KLJUČNI deo gde se LLM anotacije inkorporiraju u XML.
        """
        # Reference na druge članke kao <ref>
        if annotation.references:
            for ref in annotation.references:
                if ref.get("type") == "internal" and "article_number" in ref:
                    art_num = ref["article_number"]
                    ref_elem = SubElement(
                        p_element, 
                        "ref",
                        href=f"#art_{art_num}"
                    )
                    ref_elem.text = ref.get("target", f"Član {art_num}")
        
        # Sankcije kao <mod> (modification) ili custom element
        if annotation.sanctions:
            sanction = annotation.sanctions
            if sanction.get("type"):
                sanction_elem = SubElement(p_element, "mod")
                sanction_text = f"{sanction.get('type')}: "
                if sanction.get('min_value'):
                    sanction_text += f"{sanction['min_value']}"
                    if sanction.get('min_unit'):
                        sanction_text += f" {sanction['min_unit']}"
                if sanction.get('max_value'):
                    sanction_text += f" - {sanction['max_value']}"
                    if sanction.get('max_unit'):
                        sanction_text += f" {sanction['max_unit']}"
                sanction_elem.text = sanction_text
    
    def _write_pretty_xml(self, root: Element, output_file: str) -> None:
        """Piše XML u fajl sa formatiranjem."""
        rough_string = tostring(root, encoding='utf-8')
        reparsed = minidom.parseString(rough_string)
        pretty_xml = reparsed.toprettyxml(indent="    ", encoding="utf-8")
        
        with open(output_file, "wb") as f:
            f.write(pretty_xml)
        
        print(f"✓ XML eksportovan u: {output_file}")
    
    def export_annotations_json(
        self,
        annotations: Dict[str, SemanticAnnotation],  # String keys
        output_file: str
    ) -> str:
        """
        Eksportuje anotacije u JSON format (za validaciju / analizu).
        
        Args:
            annotations: Dict {article_number: SemanticAnnotation} sa string keys
            output_file: Putanja do JSON fajla
            
        Returns:
            Putanja do fajla
        """
        import json
        from dataclasses import asdict
        
        json_data = {
            art_num: asdict(annotation)  # art_num je već string
            for art_num, annotation in annotations.items()
        }
        
        with open(output_file, "w", encoding="utf-8") as f:
            json.dump(json_data, f, indent=2, ensure_ascii=False)
        
        print(f"✓ Anotacije eksportovane u JSON: {output_file}")
        return output_file


if __name__ == "__main__":
    # Test
    from legal_parser import LegalTextParser
    
    with open("zakon.txt", "r", encoding="utf-8") as f:
        text = f.read()
    
    parser = LegalTextParser()
    chapters = parser.parse(text)
    
    # Mock anotacije za test
    mock_annotations = {}
    
    exporter = AkomaExporter()
    exporter.export(chapters, mock_annotations, "output_test.xml")
