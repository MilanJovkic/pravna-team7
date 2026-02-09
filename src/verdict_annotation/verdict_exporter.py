"""Akoma Ntoso XML exporter for court verdicts (judgment format)."""
from datetime import datetime
from typing import Dict, Optional
from xml.dom import minidom
from xml.etree.ElementTree import Element, SubElement, tostring

from .verdict_parser import VerdictMetadata
from .verdict_annotator import VerdictAnnotation


class VerdictAkomaExporter:
    """Exports court verdicts to Akoma Ntoso judgment XML format."""

    AKOMA_NS = "http://docs.oasis-open.org/legaldocml/ns/akn/3.0/WD17"

    def __init__(self, country_code: str = "me"):
        self.country_code = country_code
        self.current_date = datetime.now().strftime("%Y-%m-%d")

    def export(
        self,
        verdict_metadata: VerdictMetadata,
        annotation: Optional[VerdictAnnotation],
        output_file: str,
        case_id: str
    ) -> str:
        """
        Exports a single verdict to Akoma Ntoso XML.
        
        Args:
            verdict_metadata: Parsed metadata
            annotation: LLM semantic annotation
            output_file: Path to XML file
            case_id: Unique case identifier
            
        Returns:
            Path to generated file
        """
        root = Element(
            f"{{{self.AKOMA_NS}}}akomaNtoso",
            attrib={
                "xmlns": self.AKOMA_NS,
                "xmlns:xsi": "http://www.w3.org/2001/XMLSchema-instance"
            }
        )

        judgment = SubElement(root, "judgment", name=case_id)
        self._build_meta(judgment, verdict_metadata, case_id)
        self._build_judgment_body(judgment, verdict_metadata, annotation)

        self._write_pretty_xml(root, output_file)
        return output_file

    def _build_meta(self, judgment_element: Element, metadata: VerdictMetadata, case_id: str) -> None:
        """Builds <meta> section for judgment."""
        meta = SubElement(judgment_element, "meta")
        identification = SubElement(meta, "identification", source="#court")

        # FRBRWork
        work = SubElement(identification, "FRBRWork")
        SubElement(work, "FRBRthis", value=f"/akn/{self.country_code}/judgment/{case_id}/!main")
        SubElement(work, "FRBRuri", value=f"/akn/{self.country_code}/judgment/{case_id}")
        SubElement(work, "FRBRdate", date=metadata.date or self.current_date, name="judgment")
        SubElement(work, "FRBRauthor", href="#court")
        SubElement(work, "FRBRcountry", value=self.country_code)

        # FRBRExpression
        expression = SubElement(identification, "FRBRExpression")
        SubElement(expression, "FRBRthis", value=f"/akn/{self.country_code}/judgment/{case_id}/sr@{metadata.date or self.current_date}/!main")
        SubElement(expression, "FRBRuri", value=f"/akn/{self.country_code}/judgment/{case_id}/sr@{metadata.date or self.current_date}")
        SubElement(expression, "FRBRdate", date=metadata.date or self.current_date)
        SubElement(expression, "FRBRauthor", href="#court")
        SubElement(expression, "FRBRlanguage", language="sr")

        # FRBRManifestation
        manifestation = SubElement(identification, "FRBRManifestation")
        SubElement(manifestation, "FRBRthis", value=f"/akn/{self.country_code}/judgment/{case_id}/sr@{metadata.date or self.current_date}/!main.xml")
        SubElement(manifestation, "FRBRuri", value=f"/akn/{self.country_code}/judgment/{case_id}/sr@{metadata.date or self.current_date}/!main.akn")
        SubElement(manifestation, "FRBRdate", date=self.current_date)
        SubElement(manifestation, "FRBRauthor", href="#court")
        SubElement(manifestation, "FRBRformat", value="xml")

        # References (court, judges, parties, laws)
        references = SubElement(meta, "references", source="#court")
        
        if metadata.court_name:
            SubElement(
                references, "TLCOrganization",
                eId="court",
                href=f"/akn/{self.country_code}/ontology/organization/court",
                showAs=metadata.court_name
            )
        
        for idx, judge in enumerate(metadata.judges, 1):
            SubElement(
                references, "TLCPerson",
                eId=f"judge_{idx}",
                href=f"/akn/{self.country_code}/ontology/person/judge",
                showAs=judge
            )
        
        # Case classification
        classification = SubElement(meta, "classification", source="#court")
        SubElement(classification, "keyword", value="criminal_case", showAs="Krivična stvar")

    def _build_judgment_body(
        self,
        judgment_elem: Element,
        metadata: VerdictMetadata,
        annotation: Optional[VerdictAnnotation]
    ) -> None:
        """Builds <judgmentBody> with verdict content."""
        body = SubElement(judgment_elem, "judgmentBody")

        # Header (case number, court, date, judges)
        header = SubElement(body, "header")
        
        if metadata.case_number:
            case_num_elem = SubElement(header, "block", name="caseNumber")
            SubElement(case_num_elem, "docNumber").text = metadata.case_number
        
        if metadata.court_name:
            court_elem = SubElement(header, "block", name="court")
            SubElement(court_elem, "docTitle").text = metadata.court_name
        
        if metadata.date:
            date_elem = SubElement(header, "block", name="date")
            SubElement(date_elem, "docDate", date=metadata.date).text = metadata.date
        
        if metadata.judges:
            judges_elem = SubElement(header, "block", name="judges")
            for judge in metadata.judges:
                SubElement(judges_elem, "judge").text = judge

        # Introduction (summary, legal issues)
        if annotation:
            intro = SubElement(body, "introduction")
            
            if annotation.verdict_summary:
                summary_block = SubElement(intro, "block", name="summary")
                SubElement(summary_block, "p").text = annotation.verdict_summary
            
            if annotation.legal_issues:
                issues_block = SubElement(intro, "block", name="legalIssues")
                for issue in annotation.legal_issues:
                    SubElement(issues_block, "p").text = issue

        # Background (applied laws and articles)
        applied_laws = annotation.applied_laws if annotation else metadata.legal_references
        applied_articles = annotation.applied_articles if annotation else metadata.article_references
        if applied_laws or applied_articles:
            background = SubElement(body, "background")
            
            if applied_laws:
                laws_block = SubElement(background, "block", name="appliedLaws")
                for law in applied_laws:
                    SubElement(laws_block, "ref", href="#").text = law
            
            if applied_articles:
                articles_block = SubElement(background, "block", name="appliedArticles")
                for article in applied_articles:
                    SubElement(articles_block, "ref", href="#").text = article

        # Motivation (legal reasoning)
        if annotation and annotation.legal_reasoning:
            motivation = SubElement(body, "motivation")
            reasoning_block = SubElement(motivation, "block", name="reasoning")
            SubElement(reasoning_block, "p").text = annotation.legal_reasoning

        # Decision (verdict outcome)
        if annotation and annotation.decision:
            decision = SubElement(body, "decision")
            decision_block = SubElement(decision, "block", name="verdict")
            SubElement(decision_block, "p").text = annotation.decision
            
            # Add outcome as attribute
            if annotation.case_outcome:
                decision_block.set("outcome", annotation.case_outcome)

        # Parties and organizations (metadata fallback)
        if not annotation and (metadata.parties or metadata.organizations):
            participants = SubElement(body, "participants")
            if metadata.parties.get("defendant"):
                def_block = SubElement(participants, "block", name="defendants")
                for defendant in metadata.parties["defendant"]:
                    SubElement(def_block, "person").text = defendant
            if metadata.parties.get("victim"):
                vic_block = SubElement(participants, "block", name="victims")
                for victim in metadata.parties["victim"]:
                    SubElement(vic_block, "person").text = victim
            if metadata.organizations:
                org_block = SubElement(participants, "block", name="organizations")
                for org in metadata.organizations:
                    SubElement(org_block, "organization").text = org

        # Conclusions (raw text fallback if no annotation)
        if not annotation:
            conclusions = SubElement(body, "conclusions")
            text_block = SubElement(conclusions, "block", name="fullText")
            # Truncate long text
            text_preview = metadata.raw_text[:2000] + "..." if len(metadata.raw_text) > 2000 else metadata.raw_text
            SubElement(text_block, "p").text = text_preview

    def _write_pretty_xml(self, root: Element, output_file: str) -> None:
        """Writes XML to file with formatting."""
        rough_string = tostring(root, encoding='utf-8')
        reparsed = minidom.parseString(rough_string)
        pretty_xml = reparsed.toprettyxml(indent="    ", encoding="utf-8")

        with open(output_file, "wb") as f:
            f.write(pretty_xml)

    def export_batch(
        self,
        verdicts: Dict[str, VerdictMetadata],
        annotations: Dict[str, VerdictAnnotation],
        output_dir: str
    ) -> list[str]:
        """
        Exports multiple verdicts to XML files.
        
        Args:
            verdicts: Dict {case_id: VerdictMetadata}
            annotations: Dict {case_id: VerdictAnnotation}
            output_dir: Directory for XML files
            
        Returns:
            List of generated file paths
        """
        from pathlib import Path
        output_path = Path(output_dir)
        output_path.mkdir(parents=True, exist_ok=True)

        generated_files = []
        total = len(verdicts)

        print(f"\nGeneriram {total} XML fajlova...")

        for idx, (case_id, metadata) in enumerate(verdicts.items(), 1):
            print(f"[{idx}/{total}] Eksportujem: {case_id}")
            
            # Safe filename
            safe_filename = case_id.replace("/", "_").replace("\\", "_").replace(":", "_")
            output_file = output_path / f"{safe_filename}.xml"
            
            annotation = annotations.get(case_id)
            
            try:
                self.export(metadata, annotation, str(output_file), case_id)
                generated_files.append(str(output_file))
                print(f"  ✓ {output_file.name}")
            except Exception as e:
                print(f"  ✗ Greška: {e}")

        return generated_files

    def export_annotations_json(self, annotations: Dict[str, VerdictAnnotation], output_file: str) -> str:
        """Exports annotations to JSON for validation."""
        import json
        from dataclasses import asdict

        json_data = {
            case_id: asdict(annotation)
            for case_id, annotation in annotations.items()
        }

        with open(output_file, "w", encoding="utf-8") as f:
            json.dump(json_data, f, indent=2, ensure_ascii=False)

        print(f"✓ Anotacije presuda eksportovane u JSON: {output_file}")
        return output_file
