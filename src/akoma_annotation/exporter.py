"""AKOMA Ntoso exporter for annotated legal text."""
from datetime import datetime
import re
from typing import Dict, List, Optional, Set
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
        else:
            inferred_norm = self._infer_norm_type(article)
            if inferred_norm:
                attribs["data-norm-type"] = inferred_norm

        article_elem = SubElement(parent, "article", attrib=attribs)
        SubElement(article_elem, "num").text = f"Čлан {article.number}"
        if article.title:
            SubElement(article_elem, "heading").text = article.title

        for idx, paragraph in enumerate(article.paragraphs, 1):
            self._build_paragraph(article_elem, paragraph, article.number, idx, annotation)

    def _infer_norm_type(self, article: LegalArticle) -> Optional[str]:
        for paragraph in article.paragraphs:
            text = paragraph.text.lower()
            if "kazniće se" in text or "kazniti" in text:
                return "sanction"
        return None

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

        extracted_refs, extracted_paragraph_refs = self._extract_internal_references(
            paragraph.text,
            article_number
        )
        extracted_external_laws = self._extract_external_law_refs(paragraph.text)
        extracted_sanctions = self._extract_sanctions(paragraph.text)

        if paragraph.points:
            intro = SubElement(para_elem, "intro", eId=f"{para_id}__intro")
            intro_p = SubElement(intro, "p")
            intro_p.text = paragraph.text
            self._add_references(intro_p, annotation, extracted_refs, extracted_paragraph_refs, extracted_external_laws)
            self._add_sanctions(intro_p, extracted_sanctions)
            for point in paragraph.points:
                self._build_point(para_elem, point, para_id)
        else:
            content = SubElement(para_elem, "content", eId=f"{para_id}__content")
            p = SubElement(content, "p")
            p.text = paragraph.text
            self._add_references(p, annotation, extracted_refs, extracted_paragraph_refs, extracted_external_laws)
            self._add_sanctions(p, extracted_sanctions)

    def _build_point(self, para_elem: Element, point: LegalPoint, para_id: str) -> None:
        point_id = f"{para_id}__point_{point.number}"
        point_elem = SubElement(para_elem, "point", eId=point_id)
        SubElement(point_elem, "num").text = f"{point.number})"
        content = SubElement(point_elem, "content")
        SubElement(content, "p").text = point.text

    def _add_references(
        self,
        p_element: Element,
        annotation: Optional[SemanticAnnotation],
        extracted_refs: Set[str],
        extracted_paragraph_refs: Set[str],
        extracted_external_laws: Set[str]
    ) -> None:
        refs: Set[str] = set(extracted_refs)

        for art_num in sorted(refs, key=lambda x: (len(x), x)):
            ref_elem = SubElement(p_element, "ref", href=f"#art_{art_num}")
            ref_elem.text = f"Član {art_num}"

        for para_ref in sorted(extracted_paragraph_refs, key=lambda x: (len(x), x)):
            ref_elem = SubElement(p_element, "ref", href=para_ref)
            ref_elem.text = f"stav {para_ref.split('__para_')[-1]}"

        for law_name in sorted(extracted_external_laws, key=lambda x: (len(x), x)):
            ref_elem = SubElement(p_element, "ref", href=self._law_href(law_name))
            ref_elem.text = law_name

    def _add_sanctions(self, p_element: Element, sanctions: List[Dict[str, Optional[object]]]) -> None:
        for sanction in sanctions:
            if not sanction or not sanction.get("type"):
                continue
            sanction_elem = SubElement(p_element, "mod")
            sanction_type = sanction.get("type")
            sanction_text = f"{sanction_type}: "
            min_value = sanction.get("min_value")
            max_value = sanction.get("max_value")
            min_unit = sanction.get("min_unit")
            max_unit = sanction.get("max_unit")
            details = sanction.get("details")

            if min_value is not None and max_value is not None:
                sanction_text += f"{min_value}"
                if min_unit:
                    sanction_text += f" {min_unit}"
                sanction_text += f" - {max_value}"
                if max_unit:
                    sanction_text += f" {max_unit}"
            elif min_value is not None:
                sanction_text += "at least "
                sanction_text += f"{min_value}"
                if min_unit:
                    sanction_text += f" {min_unit}"
            elif max_value is not None:
                sanction_text += "up to "
                sanction_text += f"{max_value}"
                if max_unit:
                    sanction_text += f" {max_unit}"

            if details:
                sanction_text += f" ({details})"

            sanction_elem.text = sanction_text

    def _extract_internal_references(self, text: str, article_number: str) -> tuple[Set[str], Set[str]]:
        if not text:
            return set(), set()

        article_pattern = re.compile(r"\bčlan(?:a|u|om)?\s+(\d+[a-z]?)", re.IGNORECASE)
        article_refs = {match.group(1) for match in article_pattern.finditer(text)}

        paragraph_refs: Set[str] = set()
        paragraph_pattern = re.compile(r"\b(stava|stavova|st\.)\s+([0-9]+(?:\s*(?:,|i)\s*[0-9]+)*)", re.IGNORECASE)
        for match in paragraph_pattern.finditer(text):
            numbers_part = match.group(2)
            for number in re.findall(r"\d+", numbers_part):
                paragraph_refs.add(f"#art_{article_number}__para_{number}")

        return article_refs, paragraph_refs

    def _extract_external_law_refs(self, text: str) -> Set[str]:
        if not text:
            return set()
        refs: Set[str] = set()
        patterns = [
            re.compile(r"Zakon o [A-Za-zČĆŽŠĐčćžšđ ]+", re.IGNORECASE),
            re.compile(r"Zakonik o [A-Za-zČĆŽŠĐčćžšđ ]+", re.IGNORECASE),
            re.compile(r"Krivičn[iy] zakonik(?: Crne Gore)?", re.IGNORECASE),
        ]
        for pattern in patterns:
            for match in pattern.findall(text):
                refs.add(match.strip())
        return refs

    def _law_href(self, law_name: str) -> str:
        name_lower = law_name.lower()
        if "krivični zakonik" in name_lower or "krivicni zakonik" in name_lower:
            return f"/akn/{self.country_code}/act/{self.law_year}/!main"

        slug = "".join(ch.lower() if ch.isalnum() else "-" for ch in law_name).strip("-")
        slug = "-".join([part for part in slug.split("-") if part])
        return f"/akn/{self.country_code}/act/{slug or 'law'}"

    def _extract_sanctions(self, text: str) -> List[Dict[str, Optional[object]]]:
        if not text:
            return []

        normalized = text.lower()
        has_long_term = "kaznom dugotrajnog zatvora" in normalized
        matches: List[tuple[int, Dict[str, Optional[object]]]] = []
        occupied_spans: List[tuple[int, int]] = []

        for match in re.finditer(
            r"novčanom kaznom ili zatvorom\s+do\s+([\wčćžšđ]+)\s+(godina|godine|godinu|mjeseci|mjeseca|mjesec)",
            normalized,
            re.IGNORECASE
        ):
            max_value = self._parse_number(match.group(1))
            max_unit = self._normalize_unit(match.group(2))
            sanction = {
                "type": "both",
                "min_value": None,
                "max_value": max_value,
                "min_unit": None,
                "max_unit": max_unit,
                "details": "fine or prison"
            }
            if has_long_term:
                sanction["details"] += ", long-term imprisonment"
            matches.append((match.start(), sanction))
            occupied_spans.append((match.start(), match.end()))

        for match in re.finditer(
            r"zatvorom\s+od\s+([\wčćžšđ]+)\s+(godina|godine|godinu|mjeseci|mjeseca|mjesec)\s+do\s+([\wčćžšđ]+)\s+(godina|godine|godinu|mjeseci|mjeseca|mjesec)",
            normalized,
            re.IGNORECASE
        ):
            if self._overlaps(match.start(), match.end(), occupied_spans):
                continue
            min_value = self._parse_number(match.group(1))
            min_unit = self._normalize_unit(match.group(2))
            max_value = self._parse_number(match.group(3))
            max_unit = self._normalize_unit(match.group(4))
            sanction = {
                "type": "prison",
                "min_value": min_value,
                "max_value": max_value,
                "min_unit": min_unit,
                "max_unit": max_unit,
                "details": None
            }
            if has_long_term:
                sanction["details"] = "long-term imprisonment"
            matches.append((match.start(), sanction))

        for match in re.finditer(
            r"zatvorom\s+od\s+([\wčćžšđ]+)\s+do\s+([\wčćžšđ]+)\s+(godina|godine|godinu|mjeseci|mjeseca|mjesec)",
            normalized,
            re.IGNORECASE
        ):
            if self._overlaps(match.start(), match.end(), occupied_spans):
                continue
            min_value = self._parse_number(match.group(1))
            max_value = self._parse_number(match.group(2))
            unit = self._normalize_unit(match.group(3))
            sanction = {
                "type": "prison",
                "min_value": min_value,
                "max_value": max_value,
                "min_unit": unit,
                "max_unit": unit,
                "details": None
            }
            if has_long_term:
                sanction["details"] = "long-term imprisonment"
            matches.append((match.start(), sanction))

        for match in re.finditer(
            r"zatvorom\s+najmanje\s+([\wčćžšđ]+)\s+(godina|godine|godinu|mjeseci|mjeseca|mjesec)",
            normalized,
            re.IGNORECASE
        ):
            if self._overlaps(match.start(), match.end(), occupied_spans):
                continue
            min_value = self._parse_number(match.group(1))
            min_unit = self._normalize_unit(match.group(2))
            sanction = {
                "type": "prison",
                "min_value": min_value,
                "max_value": None,
                "min_unit": min_unit,
                "max_unit": None,
                "details": None
            }
            if has_long_term:
                sanction["details"] = "long-term imprisonment"
            matches.append((match.start(), sanction))

        for match in re.finditer(
            r"zatvorom\s+do\s+([\wčćžšđ]+)\s+(godina|godine|godinu|mjeseci|mjeseca|mjesec)",
            normalized,
            re.IGNORECASE
        ):
            if self._overlaps(match.start(), match.end(), occupied_spans):
                continue
            max_value = self._parse_number(match.group(1))
            max_unit = self._normalize_unit(match.group(2))
            sanction = {
                "type": "prison",
                "min_value": None,
                "max_value": max_value,
                "min_unit": None,
                "max_unit": max_unit,
                "details": None
            }
            if has_long_term:
                sanction["details"] = "long-term imprisonment"
            matches.append((match.start(), sanction))

        if not matches and has_long_term:
            matches.append((0, {
                "type": "prison",
                "min_value": None,
                "max_value": None,
                "min_unit": None,
                "max_unit": None,
                "details": "long-term imprisonment"
            }))

        return [sanction for _, sanction in sorted(matches, key=lambda item: item[0])]

    def _parse_number(self, token: str) -> Optional[int]:
        if not token:
            return None
        token = token.strip().lower()
        token = re.sub(r"[^0-9a-zčćžšđ]", "", token)
        if token.isdigit():
            return int(token)

        word_map = {
            "jedan": 1,
            "jedna": 1,
            "jedne": 1,
            "jednog": 1,
            "dva": 2,
            "dvije": 2,
            "tri": 3,
            "četiri": 4,
            "cetiri": 4,
            "pet": 5,
            "šest": 6,
            "sest": 6,
            "sedam": 7,
            "osam": 8,
            "devet": 9,
            "deset": 10,
            "jedanaest": 11,
            "dvanaest": 12,
            "trinaest": 13,
            "četrnaest": 14,
            "cetrnaest": 14,
            "petnaest": 15,
            "šesnaest": 16,
            "sesnaest": 16,
            "sedamnaest": 17,
            "osamnaest": 18,
            "devetnaest": 19,
            "dvadeset": 20
        }
        return word_map.get(token)

    def _overlaps(self, start: int, end: int, spans: List[tuple[int, int]]) -> bool:
        for span_start, span_end in spans:
            if start < span_end and end > span_start:
                return True
        return False

    def _normalize_unit(self, unit: str) -> str:
        unit = unit.lower()
        if unit.startswith("mjes"):
            return "months"
        return "years"

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
