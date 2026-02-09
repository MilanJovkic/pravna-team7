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
            r'((?:Врховни|Виши|Основни|Апелациони|Привредни)\s+суд'
            r'|(?:Vrhovni|Viši|Visi|Osnovni|Apelacioni|Privredni)\s+sud)'
            r'(?:\s+u\s+[A-ZČĆŽŠĐА-Я][\wčćžšđа-я]+)?'
            r'(?:\s+(?:Црне\s+Горе|Crne\s+Gore))?',
            re.IGNORECASE
        )
        self.date_pattern = re.compile(
            r'(\d{1,2})\.\s*(\d{1,2})\.\s*(\d{4})',
            re.IGNORECASE
        )
        self.judge_pattern = re.compile(
            r'(?:[Сс]уди[јy]а|[Ss]udija|[Ss]utkinja):?\s+'
            r'([A-ZČĆŽŠĐА-ЯŠĐČĆŽ][a-zčćžšđа-яšđčćž]+(?:\s+[A-ZČĆŽŠĐА-ЯŠĐČĆŽ][a-zčćžšđа-яšđčćž]+)*)',
            re.IGNORECASE
        )
        self.article_ref_pattern = re.compile(
            r'(?:č\s*l\s*\.|čl\.|cl\.|član|члан)(?:а|у|ом)?\s*(\d+[a-z]?)',
            re.IGNORECASE
        )

        self.defendant_marker = re.compile(r"okrivljeni:?", re.IGNORECASE)
        self.victim_pattern = re.compile(
            r'oštećen(?:i|og|a)?\s+([A-ZČĆŽŠĐА-Я]\.?\s*[A-ZČĆŽŠĐА-Я]\.|[A-ZČĆŽŠĐА-Я][a-zčćžšđа-я]+(?:\s+[A-ZČĆŽŠĐА-Я][a-zčćžšđа-я]+)*)',
            re.IGNORECASE
        )
        self.applied_law_patterns = [
            re.compile(r"Krivičn[iy] zakonik Crne Gore", re.IGNORECASE),
            re.compile(r"Zakonik o krivičnom postupku(?: Crne Gore)?", re.IGNORECASE),
            re.compile(r"Zakon o [A-Za-zČĆŽŠĐčćžšđ ]+", re.IGNORECASE)
        ]

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
            metadata.judges = list({j.strip() for j in judge_matches if len(j.strip()) > 3})
        
        # Ekstraktuj reference na članke
        article_refs = self.article_ref_pattern.findall(text)
        if article_refs:
            metadata.article_references = [f"Član {ref}" for ref in set(article_refs)]

        # Ekstraktuj stranke (okrivljeni i oštećeni)
        defendants = self._extract_defendants(text)
        victims = self.victim_pattern.findall(text)
        if defendants:
            metadata.parties["defendant"] = list({d.strip() for d in defendants})
        if victims:
            metadata.parties["victim"] = list({v.strip() for v in victims})

        # Ekstraktuj reference na zakone
        laws = set()
        for pattern in self.applied_law_patterns:
            for match in pattern.findall(text):
                laws.add(match.strip())
        compact = re.sub(r"\s+", "", text).upper()
        if "KRIVIČNIZAKONIKCRNEGORE" in compact or "KRIVIČNOGZAKONIKACRNEGORE" in compact or "KRIVICNOGZAKONIKACRNEGORE" in compact:
            laws.add("Krivični zakonik Crne Gore")
        if (
            "ZAKONIKOKRIVIČNOMPOSTUPKUCRNEGORE" in compact
            or "ZAKONIKOKRIVIČNOMPOSTUPKU" in compact
            or "ZAKONIKOKRIVICNOMPOSTUPKUCRNEGORE" in compact
            or "ZAKONIKOKRIVICNOMPOSTUPKU" in compact
        ):
            laws.add("Zakonik o krivičnom postupku Crne Gore")
        if laws:
            metadata.legal_references = sorted(laws)
        
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

    def _extract_defendants(self, text: str) -> List[str]:
        defendants = []
        for match in self.defendant_marker.finditer(text):
            snippet = text[match.end():match.end() + 120]
            initials_match = re.search(r"([A-ZČĆŽŠĐА-Я]\.\s*[A-ZČĆŽŠĐА-Я]\.)", snippet)
            if initials_match:
                defendants.append(initials_match.group(1).strip())
                continue
            name_match = re.search(r"([A-ZČĆŽŠĐА-Я][a-zčćžšđа-я]+\s+[A-ZČĆŽŠĐА-Я][a-zčćžšđа-я]+)", snippet)
            if name_match:
                defendants.append(name_match.group(1).strip())
        return [d for d in defendants if len(d) >= 3]

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
