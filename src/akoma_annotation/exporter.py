"""AKOMA Ntoso exporter for annotated legal text."""
from datetime import datetime
from typing import Dict, List, Optional
from xml.dom import minidom
from xml.etree.ElementTree import Element, SubElement, tostring

from .annotator import SemanticAnnotation
from .parser import LegalArticle, LegalChapter, LegalParagraph, LegalPoint


class AkomaExporter:
    """Generates AKOMA Ntoso XML from parsed chapters and annotations."""

    AKOMA_NS = "http://docs.oasis-open.org/legaldocml/ns/akn/3.0/WD17"

    def __init__(self, law_name: str = "Krivični zakonik Crne Gore", country_code: str = "me", law_year: str = "2024"):
        self.law_name = law_name
        self.country_code = country_code
        self.law_year = law_year
        self.current_date = datetime.now().strftime("%Y-%m-%d")

    def export(
        self,
        chapters: List[LegalChapter],
        annotations: Dict[str, SemanticAnnotation],
        output_file: str
    ) -> str:
        root = Element(
            f"{{{self.AKOMA_NS}}}akomaNtoso",
            attrib={
                "xmlns": self.AKOMA_NS,
                "xmlns:xsi": "http://www.w3.org/2001/XMLSchema-instance"
            }
        )

        act = SubElement(root, "act", name=self.law_name)
        self._build_meta(act)
        body = SubElement(act, "body")

        for chapter in chapters:
            self._build_chapter(body, chapter, annotations)

        self._write_pretty_xml(root, output_file)
        return output_file

    def _build_meta(self, act_element: Element) -> None:
        meta = SubElement(act_element, "meta")
        identification = SubElement(meta, "identification", source="#auto")
        work = SubElement(identification, "FRBRWork")
        SubElement(work, "FRBRthis", value=f"/akn/{self.country_code}/act/{self.law_year}/!main")
        SubElement(work, "FRBRuri", value=f"/akn/{self.country_code}/act/{self.law_year}")
        SubElement(work, "FRBRdate", date=self.current_date)
        SubElement(work, "FRBRauthor", href="#parliament")
        SubElement(work, "FRBRcountry", value=self.country_code)
        SubElement(work, "FRBRsubtype", value="act")
        SubElement(work, "FRBRnumber", value=self.law_year)
        SubElement(work, "FRBRname", value=self.law_name)

        expression = SubElement(identification, "FRBRExpression")
        SubElement(expression, "FRBRthis", value=f"/akn/{self.country_code}/act/{self.law_year}/sr@{self.current_date}/!main")
        SubElement(expression, "FRBRuri", value=f"/akn/{self.country_code}/act/{self.law_year}/sr@{self.current_date}")
        SubElement(expression, "FRBRdate", date=self.current_date)
        SubElement(expression, "FRBRauthor", href="#auto")
        SubElement(expression, "FRBRlanguage", language="sr")

        manifestation = SubElement(identification, "FRBRManifestation")
        SubElement(manifestation, "FRBRthis", value=f"/akn/{self.country_code}/act/{self.law_year}/sr@{self.current_date}/!main.xml")
        SubElement(manifestation, "FRBRuri", value=f"/akn/{self.country_code}/act/{self.law_year}/sr@{self.current_date}/!main.akn")
        SubElement(manifestation, "FRBRdate", date=self.current_date)
        SubElement(manifestation, "FRBRauthor", href="#auto")
        SubElement(manifestation, "FRBRformat", value="xml")

        classification = SubElement(meta, "classification", source="#auto")
        SubElement(classification, "keyword", value="criminal_law", showAs="Krivično pravo")

        references = SubElement(meta, "references", source="#auto")
        SubElement(references, "TLCOrganization", eId="parliament",
                   href=f"/akn/{self.country_code}/ontology/organization/parliament",
                   showAs="Skupština Crne Gore")
        SubElement(references, "TLCPerson", eId="auto",
                   href=f"/akn/{self.country_code}/ontology/person/auto",
                   showAs="Automatski generator")

    def _build_chapter(self, body: Element, chapter: LegalChapter, annotations: Dict[str, SemanticAnnotation]) -> None:
        chapter_id = f"chp_{chapter.number.lower()}"
        chapter_elem = SubElement(body, "chapter", eId=chapter_id)
        SubElement(chapter_elem, "num").text = chapter.number
        SubElement(chapter_elem, "heading").text = chapter.title

        for article in chapter.articles:
            self._build_article(chapter_elem, article, annotations.get(article.number))

    def _build_article(self, parent: Element, article: LegalArticle, annotation: Optional[SemanticAnnotation]) -> None:
        article_id = f"art_{article.number}"
        attribs = {"eId": article_id}

        if annotation:
            attribs["data-norm-type"] = annotation.norm_type
            if annotation.subjects:
                attribs["data-subjects"] = ",".join(annotation.subjects)
            if annotation.legal_concepts:
                attribs["data-concepts"] = ",".join(annotation.legal_concepts)
            if annotation.qualifiers.get("aggravated"):
                attribs["data-aggravated"] = "true"

        article_elem = SubElement(parent, "article", attrib=attribs)
        SubElement(article_elem, "num").text = f"Čлан {article.number}"
        if article.title:
            SubElement(article_elem, "heading").text = article.title

        for idx, paragraph in enumerate(article.paragraphs, 1):
            self._build_paragraph(article_elem, paragraph, article.number, idx, annotation)

    def _build_paragraph(
        self,
        article_elem: Element,
        paragraph: LegalParagraph,
        article_number: str,
        para_index: int,
        annotation: Optional[SemanticAnnotation]
    ) -> None:
        para_num = paragraph.number if paragraph.number else para_index
        para_id = f"art_{article_number}__para_{para_num}"
        para_elem = SubElement(article_elem, "paragraph", eId=para_id)

        if paragraph.points:
            intro = SubElement(para_elem, "intro", eId=f"{para_id}__intro")
            SubElement(intro, "p").text = paragraph.text
            for point in paragraph.points:
                self._build_point(para_elem, point, para_id)
        else:
            content = SubElement(para_elem, "content", eId=f"{para_id}__content")
            p = SubElement(content, "p")
            p.text = paragraph.text
            if annotation:
                self._add_semantic_annotations(p, annotation)

    def _build_point(self, para_elem: Element, point: LegalPoint, para_id: str) -> None:
        point_id = f"{para_id}__point_{point.number}"
        point_elem = SubElement(para_elem, "point", eId=point_id)
        SubElement(point_elem, "num").text = f"{point.number})"
        content = SubElement(point_elem, "content")
        SubElement(content, "p").text = point.text

    def _add_semantic_annotations(self, p_element: Element, annotation: SemanticAnnotation) -> None:
        if annotation.references:
            for ref in annotation.references:
                if isinstance(ref, dict) and ref.get("type") == "internal" and "article_number" in ref:
                    art_num = ref["article_number"]
                    ref_elem = SubElement(p_element, "ref", href=f"#art_{art_num}")
                    ref_elem.text = ref.get("target", f"Član {art_num}")

        if annotation.sanctions:
            sanction = annotation.sanctions
            if sanction.get("type"):
                sanction_elem = SubElement(p_element, "mod")
                sanction_text = f"{sanction.get('type')}: "
                if sanction.get('min_value') is not None:
                    sanction_text += f"{sanction['min_value']}"
                    if sanction.get('min_unit'):
                        sanction_text += f" {sanction['min_unit']}"
                if sanction.get('max_value') is not None:
                    sanction_text += f" - {sanction['max_value']}"
                    if sanction.get('max_unit'):
                        sanction_text += f" {sanction['max_unit']}"
                sanction_elem.text = sanction_text

    def _write_pretty_xml(self, root: Element, output_file: str) -> None:
        rough_string = tostring(root, encoding='utf-8')
        reparsed = minidom.parseString(rough_string)
        pretty_xml = reparsed.toprettyxml(indent="    ", encoding="utf-8")

        with open(output_file, "wb") as f:
            f.write(pretty_xml)

        print(f"✓ XML eksportovan u: {output_file}")

    def export_annotations_json(self, annotations: Dict[str, SemanticAnnotation], output_file: str) -> str:
        import json
        from dataclasses import asdict

        json_data = {
            art_num: asdict(annotation)
            for art_num, annotation in annotations.items()
        }

        with open(output_file, "w", encoding="utf-8") as f:
            json.dump(json_data, f, indent=2, ensure_ascii=False)

        print(f"✓ Anotacije eksportovane u JSON: {output_file}")
        return output_file
