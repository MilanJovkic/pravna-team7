"""Parser for structuring court verdict text."""
import re
from dataclasses import dataclass, field
from datetime import datetime
from typing import List, Optional


@dataclass
class VerdictMetadata:
    """Metadata extracted from court verdict."""
    
    case_number: Optional[str] = None
    court_name: Optional[str] = None
    date: Optional[str] = None
    judges: List[str] = field(default_factory=list)
    parties: dict[str, List[str]] = field(default_factory=dict)  # {"plaintiff": [...], "defendant": [...]}
    organizations: List[str] = field(default_factory=list)
    legal_references: List[str] = field(default_factory=list)  # Reference ka zakonima
    article_references: List[str] = field(default_factory=list)  # Reference ka članovima
    verdict_type: Optional[str] = None  # presuda, rješenje, zaključak
    raw_text: str = ""


class VerdictParser:
    """Parses court verdict text and extracts structured metadata."""

    def __init__(self):
        # Regex patterns za identifikaciju elemenata
        self.case_number_pattern = re.compile(
            r'(?:Број|Br\.|број)\s*(?:предмета|K|Ki|Kž|Kv)[\s:-]*(\S+)',
            re.IGNORECASE
        )
        self.court_pattern = re.compile(
            r'(Врховни суд|Виши суд|Основни суд|Апелациони суд|Привредни суд)'
            r'(?:\s+(?:Црне\s+Горе|Подгорице|Београда))?',
            re.IGNORECASE
        )
        self.date_pattern = re.compile(
            r'(\d{1,2})\.\s*(\d{1,2})\.\s*(\d{4})',
            re.IGNORECASE
        )
        self.judge_pattern = re.compile(
            r'[Сс]уди[јy]а:?\s+([A-ZČĆŽŠĐА-ЯШЂЧЋЖЏ][a-zčćžšđа-яшђчћжџ]+(?:\s+[A-ZČĆŽŠĐА-ЯШЂЧЋЖЏ][a-zčćžšđа-яшђчћжџ]+)*)',
            re.IGNORECASE
        )
        self.article_ref_pattern = re.compile(
            r'член(?:а|у|om)?\s+(\d+[a-z]?)',
            re.IGNORECASE
        )

    def parse(self, text: str, filename: Optional[str] = None) -> VerdictMetadata:
        """
        Parsira tekst presude i ekstraktuje metadata.
        
        Args:
            text: Tekst presude
            filename: Ime fajla (opciono)
            
        Returns:
            VerdictMetadata objekat
        """
        metadata = VerdictMetadata(raw_text=text)
        
        # Ekstraktuj broj predmeta
        case_match = self.case_number_pattern.search(text)
        if case_match:
            metadata.case_number = case_match.group(1).strip()
        elif filename:
            # Fallback na ime fajla
            metadata.case_number = filename
        
        # Ekstraktuj sud
        court_match = self.court_pattern.search(text)
        if court_match:
            metadata.court_name = court_match.group(0).strip()
        
        # Ekstraktuj datum
        date_matches = self.date_pattern.findall(text)
        if date_matches:
            # Uzmi prvi datum (obično datum presude)
            day, month, year = date_matches[0]
            metadata.date = f"{year}-{month.zfill(2)}-{day.zfill(2)}"
        
        # Ekstraktuj sudije
        judge_matches = self.judge_pattern.findall(text)
        if judge_matches:
            metadata.judges = [j.strip() for j in judge_matches if len(j.strip()) > 3]
        
        # Ekstraktuj reference na članke
        article_refs = self.article_ref_pattern.findall(text)
        if article_refs:
            metadata.article_references = [f"Član {ref}" for ref in set(article_refs)]
        
        # Identifikuj tip presude
        text_lower = text.lower()
        if "пресуд" in text_lower:
            metadata.verdict_type = "presuda"
        elif "рјешењ" in text_lower or "решењ" in text_lower:
            metadata.verdict_type = "rešenje"
        elif "закључ" in text_lower:
            metadata.verdict_type = "zaključak"
        else:
            metadata.verdict_type = "odluka"
        
        # Ekstraktuj organizacije (osnovna detekcija)
        # Pattern za institucije, firme, itd.
        org_pattern = re.compile(
            r'\b([A-ZČĆŽŠĐА-Я][a-zčćžšđа-я]+(?:\s+[a-zčćžšđа-я]+)*\s+(?:д\.о\.о\.|a\.d\.|јавно предузеће|министарство|агенција))',
            re.IGNORECASE
        )
        org_matches = org_pattern.findall(text)
        if org_matches:
            metadata.organizations = list(set([o.strip() for o in org_matches]))
        
        return metadata

    def parse_batch(self, texts: dict[str, str]) -> dict[str, VerdictMetadata]:
        """
        Parsira više presuda odjednom.
        
        Args:
            texts: Dict {filename: text}
            
        Returns:
            Dict {filename: VerdictMetadata}
        """
        results = {}
        total = len(texts)
        
        print(f"\nParsiram {total} presuda...")
        
        for idx, (filename, text) in enumerate(texts.items(), 1):
            print(f"[{idx}/{total}] Parsiram: {filename}")
            
            try:
                metadata = self.parse(text, filename)
                results[filename] = metadata
                
                print(f"  ✓ Broj predmeta: {metadata.case_number or 'N/A'}")
                print(f"  ✓ Sud: {metadata.court_name or 'N/A'}")
                print(f"  ✓ Datum: {metadata.date or 'N/A'}")
                print(f"  ✓ Reference na članke: {len(metadata.article_references)}")
            
            except Exception as e:
                print(f"  ✗ Greška: {e}")
                # Kreiraj prazan metadata sa sirović tekstom
                results[filename] = VerdictMetadata(raw_text=text, case_number=filename)
        
        return results
