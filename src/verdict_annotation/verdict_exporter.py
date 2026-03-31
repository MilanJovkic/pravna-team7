"""Akoma Ntoso XML exporter for court verdicts (judgment format)."""
import os
from datetime import datetime
from typing import Dict, Optional
from xml.dom import minidom
from xml.etree.ElementTree import Element, SubElement, tostring

try:
    import psycopg2
    from psycopg2.extras import execute_values
    POSTGRES_AVAILABLE = True
except ImportError:
    POSTGRES_AVAILABLE = False
    print("[!] psycopg2 nije instaliran - upis u bazu podataka je onemogucen")

from .verdict_parser import VerdictMetadata
from .verdict_annotator import VerdictAnnotation
from .outcome_normalizer import normalize_outcome


class VerdictAkomaExporter:
    """Exports court verdicts to Akoma Ntoso judgment XML format."""

    AKOMA_NS = "http://docs.oasis-open.org/legaldocml/ns/akn/3.0/WD17"

    def __init__(self, country_code: str = "me", enable_db_insert: bool = True):
        self.country_code = country_code
        self.current_date = datetime.now().strftime("%Y-%m-%d")
        self.enable_db_insert = enable_db_insert and POSTGRES_AVAILABLE
        
        # Database connection parameters
        self.db_params = {
            "host": os.getenv("POSTGRES_HOST", "localhost"),
            "port": os.getenv("POSTGRES_PORT", "5432"),
            "database": os.getenv("POSTGRES_DB", "pravna_cbr"),
            "user": os.getenv("POSTGRES_USER", "pravna_user"),
            "password": os.getenv("POSTGRES_PASSWORD", "pravna_pass")
        }

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

        applied_laws = annotation.applied_laws if annotation and annotation.applied_laws else verdict_metadata.legal_references
        applied_laws = [self._normalize_law_name(law) for law in (applied_laws or [])]
        law_ref_map = self._build_meta(judgment, verdict_metadata, case_id, applied_laws)
        self._build_judgment_body(judgment, verdict_metadata, annotation, law_ref_map)

        self._write_pretty_xml(root, output_file, case_id, verdict_metadata, annotation)
        return output_file

    def _build_meta(
        self,
        judgment_element: Element,
        metadata: VerdictMetadata,
        case_id: str,
        applied_laws: list[str]
    ) -> dict[str, str]:
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

        for idx, defendant in enumerate(metadata.parties.get("defendant", []), 1):
            SubElement(
                references, "TLCPerson",
                eId=f"defendant_{idx}",
                href=f"/akn/{self.country_code}/ontology/person/defendant",
                showAs=defendant
            )

        for idx, victim in enumerate(metadata.parties.get("victim", []), 1):
            SubElement(
                references, "TLCPerson",
                eId=f"victim_{idx}",
                href=f"/akn/{self.country_code}/ontology/person/victim",
                showAs=victim
            )

        for idx, org in enumerate(metadata.organizations, 1):
            SubElement(
                references, "TLCOrganization",
                eId=f"org_{idx}",
                href=f"/akn/{self.country_code}/ontology/organization",
                showAs=org
            )

        law_ref_map: dict[str, str] = {}
        for idx, law in enumerate(applied_laws or [], 1):
            law_id = f"law_{idx}"
            law_ref_map[law] = law_id
            SubElement(
                references, "TLCLaw",
                eId=law_id,
                href=self._law_href(law),
                showAs=law
            )
        
        # Case classification
        classification = SubElement(meta, "classification", source="#court")
        SubElement(classification, "keyword", value="criminal_case", showAs="Krivična stvar")

        return law_ref_map

    def _build_judgment_body(
        self,
        judgment_elem: Element,
        metadata: VerdictMetadata,
        annotation: Optional[VerdictAnnotation],
        law_ref_map: dict[str, str]
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
        applied_laws = annotation.applied_laws if annotation and annotation.applied_laws else metadata.legal_references
        applied_articles = annotation.applied_articles if annotation and annotation.applied_articles else metadata.article_references
        if applied_laws or applied_articles:
            background = SubElement(body, "background")
            
            if applied_laws:
                laws_block = SubElement(background, "block", name="appliedLaws")
                for law in applied_laws:
                    law_id = law_ref_map.get(law)
                    href = f"#{law_id}" if law_id else self._law_href(law)
                    SubElement(laws_block, "ref", href=href).text = law
            
            if applied_articles:
                articles_block = SubElement(background, "block", name="appliedArticles")
                for article in applied_articles:
                    SubElement(
                        articles_block,
                        "ref",
                        href=self._article_href(article, applied_laws[0] if applied_laws else None)
                    ).text = article

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
                decision_block.set("outcome", normalize_outcome(annotation.case_outcome))

        # Parties and organizations (metadata)
        if metadata.parties or metadata.organizations:
            participants = SubElement(body, "participants")
            if metadata.parties.get("defendant"):
                def_block = SubElement(participants, "block", name="defendants")
                for defendant in metadata.parties["defendant"]:
                    SubElement(def_block, "person").text = defendant
            if metadata.parties.get("victim"):
                vic_block = SubElement(participants, "block", name="victims")
                for victim in metadata.parties["victim"]:
                    SubElement(vic_block, "person").text = victim
            if metadata.parties.get("witness"):
                wit_block = SubElement(participants, "block", name="witnesses")
                for witness in metadata.parties["witness"]:
                    SubElement(wit_block, "person").text = witness
            if metadata.parties.get("clerk"):
                clerk_block = SubElement(participants, "block", name="clerks")
                for clerk in metadata.parties["clerk"]:
                    SubElement(clerk_block, "person").text = clerk
            if metadata.organizations:
                org_block = SubElement(participants, "block", name="organizations")
                for org in metadata.organizations:
                    SubElement(org_block, "organization").text = org

        # Factual state (regex + LLM)
        factual_state = metadata.factual_state or (annotation.factual_state if annotation else {})
        if factual_state:
            facts_elem = SubElement(body, "facts")
            for key, values in factual_state.items():
                for value in values:
                    SubElement(facts_elem, "fact", key=key).text = value

        # Conclusions (full text for UI rendering)
        if metadata.raw_text:
            conclusions = SubElement(body, "conclusions")
            text_block = SubElement(conclusions, "block", name="fullText")
            SubElement(text_block, "p").text = metadata.raw_text

    def _law_href(self, law_name: str) -> str:
        name_lower = law_name.lower()
        if "krivični zakonik" in name_lower or "krivicni zakonik" in name_lower:
            return f"/akn/{self.country_code}/act/2024/!main"

        slug = "".join(ch.lower() if ch.isalnum() else "-" for ch in law_name).strip("-")
        slug = "-".join([part for part in slug.split("-") if part])
        return f"/akn/{self.country_code}/act/{slug or 'law'}"

    def _article_href(self, article_label: str, law_name: Optional[str]) -> str:
        digits = "".join(ch for ch in article_label if ch.isdigit())
        article_num = digits or ""

        if law_name:
            return f"{self._law_href(law_name)}#art_{article_num}"
        return f"/akn/{self.country_code}/act/law#art_{article_num}"

    def _normalize_law_name(self, law_name: str) -> str:
        name_lower = law_name.lower()
        if "krivični zakonik" in name_lower or "krivicni zakonik" in name_lower:
            if "crne gore" not in name_lower:
                return "Krivični zakonik Crne Gore"
        if "zakonik o krivičnom postupku" in name_lower or "zakonik o krivicnom postupku" in name_lower:
            if "crne gore" not in name_lower:
                return "Zakonik o krivičnom postupku"
        return law_name

    def _write_pretty_xml(
        self, 
        root: Element, 
        output_file: str, 
        case_id: str,
        verdict_metadata: VerdictMetadata,
        annotation: Optional[VerdictAnnotation]
    ) -> None:
        """Writes XML to file with formatting."""
        rough_string = tostring(root, encoding='utf-8')
        reparsed = minidom.parseString(rough_string)
        pretty_xml = reparsed.toprettyxml(indent="    ", encoding="utf-8")

        with open(output_file, "wb") as f:
            f.write(pretty_xml)
        
        # After saving XML, also save to database
        if self.enable_db_insert:
            try:
                factual_state = verdict_metadata.factual_state or (annotation.factual_state if annotation else {})
                outcome = annotation.case_outcome if annotation else "nepoznato"
                self._insert_case_to_db(case_id, factual_state, outcome)
            except Exception as e:
                safe_case_id = case_id.encode('ascii', 'replace').decode('ascii')
                print(f"  [!] Nije uspeo upis u bazu za {safe_case_id}: {str(e)[:50]}")

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
            # Use ASCII-safe representation for console output
            safe_case_id = case_id.encode('ascii', 'replace').decode('ascii')
            print(f"[{idx}/{total}] Eksportujem: {safe_case_id}")
            
            # Safe filename
            safe_filename = case_id.replace("/", "_").replace("\\", "_").replace(":", "_")
            output_file = output_path / f"{safe_filename}.xml"
            
            annotation = annotations.get(case_id)
            
            try:
                self.export(metadata, annotation, str(output_file), case_id)
                generated_files.append(str(output_file))
                print(f"  [OK] {output_file.name.encode('ascii', 'replace').decode('ascii')}")
            except Exception as e:
                print(f"  [X] Greska: {str(e)[:50]}")

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

        print(f"[OK] Anotacije presuda eksportovane u JSON: {output_file}")
        return output_file

    def _extract_fact_value(self, factual_state: Dict[str, list], key: str, default: str = "ne") -> str:
        """Extracts a single fact value from factual_state dict."""
        values = factual_state.get(key, [])
        if not values:
            return default
        # Take first value if multiple exist
        return str(values[0]) if values else default
    
    def _to_boolean(self, value: str) -> bool:
        """Converts да/ne/da/не/true/false string to boolean."""
        value_lower = str(value).lower().strip()
        return value_lower in ["да", "da", "true", "yes", "1"]

    def _insert_case_to_db(self, case_number: str, factual_state: Dict[str, list], outcome: str):
        """Inserts case facts into PostgreSQL database."""
        if not POSTGRES_AVAILABLE:
            return
        
        # Extract individual facts from factual_state
        facts_dict = {
            "injury_type": self._extract_fact_value(factual_state, "injury_type", "непознато"),
            "location": self._extract_fact_value(factual_state, "location", "непознато"),
            "weapon": self._extract_fact_value(factual_state, "weapon", "непознато"),
            "weapon_used": self._to_boolean(self._extract_fact_value(factual_state, "weapon_used", "не")),
            "severe_consequence": self._to_boolean(self._extract_fact_value(factual_state, "severe_consequence", "не")),
            "death_result": self._to_boolean(self._extract_fact_value(factual_state, "death_result", "не")),
            "negligence": self._to_boolean(self._extract_fact_value(factual_state, "negligence", "не")),
            "provocation": self._to_boolean(self._extract_fact_value(factual_state, "provocation", "не")),
            "fight_participation": self._to_boolean(self._extract_fact_value(factual_state, "fight_participation", "не")),
            "fight_consequence": self._extract_fact_value(factual_state, "fight_consequence", "непознато"),
            "left_without_help": self._to_boolean(self._extract_fact_value(factual_state, "left_without_help", "не")),
            "outcome": outcome
        }
        
        try:
            conn = psycopg2.connect(**self.db_params)
            cursor = conn.cursor()
            
            # Check if case already exists
            cursor.execute("SELECT id FROM cases WHERE case_number = %s", (case_number,))
            existing = cursor.fetchone()
            
            if existing:
                # Update existing case
                cursor.execute("""
                    UPDATE cases SET
                        injury_type = %s,
                        location = %s,
                        weapon = %s,
                        weapon_used = %s,
                        severe_consequence = %s,
                        death_result = %s,
                        negligence = %s,
                        provocation = %s,
                        fight_participation = %s,
                        fight_consequence = %s,
                        left_without_help = %s,
                        outcome = %s
                    WHERE case_number = %s
                """, (
                    facts_dict["injury_type"],
                    facts_dict["location"],
                    facts_dict["weapon"],
                    facts_dict["weapon_used"],
                    facts_dict["severe_consequence"],
                    facts_dict["death_result"],
                    facts_dict["negligence"],
                    facts_dict["provocation"],
                    facts_dict["fight_participation"],
                    facts_dict["fight_consequence"],
                    facts_dict["left_without_help"],
                    facts_dict["outcome"],
                    case_number
                ))
            else:
                # Insert new case
                cursor.execute("""
                    INSERT INTO cases (
                        case_number, injury_type, location, weapon, weapon_used,
                        severe_consequence, death_result, negligence, provocation,
                        fight_participation, fight_consequence, left_without_help, outcome
                    ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
                """, (
                    case_number,
                    facts_dict["injury_type"],
                    facts_dict["location"],
                    facts_dict["weapon"],
                    facts_dict["weapon_used"],
                    facts_dict["severe_consequence"],
                    facts_dict["death_result"],
                    facts_dict["negligence"],
                    facts_dict["provocation"],
                    facts_dict["fight_participation"],
                    facts_dict["fight_consequence"],
                    facts_dict["left_without_help"],
                    facts_dict["outcome"]
                ))
            
            conn.commit()
            cursor.close()
            conn.close()
            
        except Exception as e:
            raise Exception(f"Database insert failed: {e}")
