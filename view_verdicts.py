"""Simple viewer for court verdicts in Akoma Ntoso format."""
import json
from pathlib import Path
from typing import Optional
from xml.etree import ElementTree as ET


class VerdictViewer:
    """Učitava i prikazuje Akoma Ntoso presude."""

    AKOMA_NS = {"akn": "http://docs.oasis-open.org/legaldocml/ns/akn/3.0/WD17"}

    def __init__(self, xml_dir: str = "data/verdicts_xml"):
        self.xml_dir = Path(xml_dir)
        self.verdicts = {}
        self._load_verdicts()

    def _load_verdicts(self):
        """Učitava sve XML presude iz foldera."""
        if not self.xml_dir.exists():
            raise FileNotFoundError(f"Folder {self.xml_dir} ne postoji")

        xml_files = list(self.xml_dir.glob("*.xml"))
        
        print(f"Učitavam {len(xml_files)} presuda iz {self.xml_dir}...")
        
        for xml_file in xml_files:
            try:
                tree = ET.parse(xml_file)
                root = tree.getroot()
                
                # Find judgment element (with or without namespace)
                judgment = root.find(".//{http://docs.oasis-open.org/legaldocml/ns/akn/3.0/WD17}judgment")
                if judgment is None:
                    judgment = root.find(".//judgment")
                
                if judgment is not None:
                    case_id = judgment.get("name", xml_file.stem)
                    self.verdicts[case_id] = {
                        "file": xml_file,
                        "tree": tree,
                        "root": root
                    }
                    print(f"  ✓ {case_id}")
            except Exception as e:
                print(f"  ✗ Greška pri učitavanju {xml_file.name}: {e}")

    def list_verdicts(self) -> list[str]:
        """Vraća listu svih učitanih presuda."""
        return list(self.verdicts.keys())

    def get_verdict_metadata(self, case_id: str) -> dict:
        """Ekstraktuje metadata iz presude."""
        if case_id not in self.verdicts:
            raise ValueError(f"Presuda {case_id} nije pronađena")

        root = self.verdicts[case_id]["root"]
        metadata = {}

        # Helper to find elements with or without namespace
        def find_elem(xpath):
            elem = root.find(xpath, self.AKOMA_NS)
            if elem is None:
                # Try without namespace
                xpath_no_ns = xpath.replace("akn:", "")
                elem = root.find(f".//{{{self.AKOMA_NS['akn']}}}{xpath_no_ns.split('/')[-1]}")
            if elem is None:
                # Try plain
                elem = root.find(f".//{xpath.split('/')[-1]}")
            return elem

        def find_all(xpath):
            elems = root.findall(xpath, self.AKOMA_NS)
            if not elems:
                tag = xpath.split('/')[-1]
                elems = root.findall(f".//{{{self.AKOMA_NS['akn']}}}{tag}")
            if not elems:
                elems = root.findall(f".//{tag}")
            return elems

        # Case number
        case_num = find_elem(".//docNumber")
        if case_num is not None:
            metadata["case_number"] = case_num.text

        # Date
        date_elem = find_elem(".//docDate")
        if date_elem is not None:
            metadata["date"] = date_elem.get("date") or date_elem.text

        # Court
        court = find_elem(".//docTitle")
        if court is not None:
            metadata["court"] = court.text

        # Judges
        judges = find_all(".//judge")
        if judges:
            metadata["judges"] = [j.text for j in judges if j.text]

        # Summary
        summary_blocks = [b for b in root.iter() if b.get("name") == "summary"]
        if summary_blocks:
            for p in summary_blocks[0].iter():
                if p.tag.endswith("p") and p.text:
                    metadata["summary"] = p.text
                    break

        # Legal issues
        issues_blocks = [b for b in root.iter() if b.get("name") == "legalIssues"]
        if issues_blocks:
            issues = []
            for p in issues_blocks[0].iter():
                if p.tag.endswith("p") and p.text:
                    issues.append(p.text)
            if issues:
                metadata["legal_issues"] = issues

        # Applied laws
        laws_blocks = [b for b in root.iter() if b.get("name") == "appliedLaws"]
        if laws_blocks:
            laws = []
            for ref in laws_blocks[0].iter():
                if ref.tag.endswith("ref") and ref.text:
                    laws.append(ref.text)
            if laws:
                metadata["applied_laws"] = laws

        # Decision
        verdict_blocks = [b for b in root.iter() if b.get("name") == "verdict"]
        if verdict_blocks:
            outcome = verdict_blocks[0].get("outcome")
            if outcome:
                metadata["outcome"] = outcome
            for p in verdict_blocks[0].iter():
                if p.tag.endswith("p") and p.text:
                    metadata["decision"] = p.text
                    break

        return metadata

    def display_verdict(self, case_id: str):
        """Prikazuje presudu u čitljivom formatu."""
        metadata = self.get_verdict_metadata(case_id)
        
        print("\n" + "=" * 70)
        print(f"PRESUDA: {metadata.get('case_number', case_id)}")
        print("=" * 70)
        
        if "court" in metadata:
            print(f"Sud: {metadata['court']}")
        
        if "date" in metadata:
            print(f"Datum: {metadata['date']}")
        
        if "judges" in metadata:
            print(f"Sudije: {', '.join(metadata['judges'])}")
        
        if "summary" in metadata:
            print(f"\nRezime:")
            print(f"  {metadata['summary']}")
        
        if "legal_issues" in metadata:
            print(f"\nPravna pitanja:")
            for issue in metadata['legal_issues']:
                print(f"  - {issue}")
        
        if "applied_laws" in metadata:
            print(f"\nPrimenjeni zakoni:")
            for law in metadata['applied_laws']:
                print(f"  - {law}")
        
        if "decision" in metadata:
            print(f"\nOdluka:")
            print(f"  {metadata['decision']}")
            if "outcome" in metadata:
                print(f"  Ishod: {metadata['outcome']}")
        
        print("=" * 70)

    def search_by_law(self, law_name: str) -> list[str]:
        """Pronalazi presude koje primenjuju određeni zakon."""
        matching = []
        
        for case_id in self.verdicts.keys():
            metadata = self.get_verdict_metadata(case_id)
            applied_laws = metadata.get("applied_laws", [])
            
            for law in applied_laws:
                if law_name.lower() in law.lower():
                    matching.append(case_id)
                    break
        
        return matching

    def export_summary(self, output_file: str):
        """Eksportuje rezime svih presuda u tekstualni format."""
        with open(output_file, "w", encoding="utf-8") as f:
            f.write("REZIME SUDSKIH PRESUDA\n")
            f.write("=" * 70 + "\n\n")
            
            for case_id in self.verdicts.keys():
                metadata = self.get_verdict_metadata(case_id)
                
                f.write(f"Presuda: {metadata.get('case_number', case_id)}\n")
                f.write(f"Datum: {metadata.get('date', 'N/A')}\n")
                
                if "summary" in metadata:
                    f.write(f"Rezime: {metadata['summary']}\n")
                
                if "outcome" in metadata:
                    f.write(f"Ishod: {metadata['outcome']}\n")
                
                f.write("\n" + "-" * 70 + "\n\n")
        
        print(f"✓ Rezime eksportovano u: {output_file}")


def main():
    """CLI za pregled presuda."""
    import sys
    
    if len(sys.argv) < 2:
        print("Usage: python view_verdicts.py <command> [args]")
        print("\nCommands:")
        print("  list                    - Prikaži sve presude")
        print("  show <case_id>          - Prikaži detalje presude")
        print("  search <law_name>       - Pretraži po zakonu")
        print("  export <output.txt>     - Eksportuj rezime")
        sys.exit(1)
    
    viewer = VerdictViewer()
    command = sys.argv[1]
    
    if command == "list":
        print("\nUčitane presude:")
        for case_id in viewer.list_verdicts():
            metadata = viewer.get_verdict_metadata(case_id)
            print(f"  - {case_id}: {metadata.get('date', 'N/A')}")
    
    elif command == "show":
        if len(sys.argv) < 3:
            print("✗ Navedi case_id")
            sys.exit(1)
        case_id = sys.argv[2]
        viewer.display_verdict(case_id)
    
    elif command == "search":
        if len(sys.argv) < 3:
            print("✗ Navedi naziv zakona")
            sys.exit(1)
        law_name = sys.argv[2]
        results = viewer.search_by_law(law_name)
        print(f"\nPronađeno {len(results)} presuda sa '{law_name}':")
        for case_id in results:
            print(f"  - {case_id}")
    
    elif command == "export":
        if len(sys.argv) < 3:
            print("✗ Navedi output fajl")
            sys.exit(1)
        output_file = sys.argv[2]
        viewer.export_summary(output_file)
    
    else:
        print(f"✗ Nepoznata komanda: {command}")
        sys.exit(1)


if __name__ == "__main__":
    main()
