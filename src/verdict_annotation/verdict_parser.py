"""Parser for structuring court verdict text."""
import re
from datetime import datetime
from typing import List, Optional

from backend.app.domain.verdict.entities import VerdictMetadata

class VerdictParser:
    """Parses court verdict text and extracts structured metadata."""

    def __init__(self):
        # Regex patterns za identifikaciju elemenata
        self.case_number_pattern = re.compile(
            r'(?:Број|Br\.|број)\s*(?:предмета|K|Ki|Kž|Kv)[\s:-]*(\S+)',
            re.IGNORECASE
        )
        self.case_number_inline_pattern = re.compile(
            r'\bK\.?\s*br\.?\s*([0-9]+\s*/\s*[0-9]+)',
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
            r'([A-ZČĆŽŠĐА-ЯŠĐČĆŽ][a-zčćžšđа-яšđčćž]+'
            r'(?:\s+[A-ZČĆŽŠĐА-ЯŠĐČĆŽ][a-zčćžšđа-яšđčćž]+)*'
            r'(?:\s+[čćžšđ])?)',
            re.IGNORECASE
        )
        self.judge_inline_pattern = re.compile(
            r'(?:po\s+sudiji|po\s+sutkinji|sudija|sutkinja)\s+'
            r'([A-ZČĆŽŠĐА-Я][a-zčćžšđа-я]+'
            r'(?:\s+[A-ZČĆŽŠĐА-Я][a-zčćžšđа-я]+)*'
            r'(?:\s+[čćžšđ])?)',
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
        self.witness_pattern = re.compile(
            r'(?:svjedok|svedok)\s*:?' 
            r'\s+([A-ZČĆŽŠĐА-Я]\.?:?\s*[A-ZČĆŽŠĐА-Я]\.|[A-ZČĆŽŠĐА-Я][a-zčćžšđа-я]+(?:\s+[A-ZČĆŽŠĐА-Я][a-zčćžšđа-я]+)*)',
            re.IGNORECASE
        )
        self.clerk_pattern = re.compile(
            r'(?:zapisni[čc]ar|zapisničar)\s*:?' 
            r'\s+([A-ZČĆŽŠĐА-Я]\.?:?\s*[A-ZČĆŽŠĐА-Я]\.|[A-ZČĆŽŠĐА-Я][a-zčćžšđа-я]+(?:\s+[A-ZČĆŽŠĐА-Я][a-zčćžšđа-я]+)*)',
            re.IGNORECASE
        )
        self.applied_law_patterns = [
            re.compile(r"Krivičn[iy] zakonik Crne Gore", re.IGNORECASE),
            re.compile(r"Zakonik o krivičnom postupku(?: Crne Gore)?", re.IGNORECASE),
            re.compile(r"Zakon o [A-Za-zČĆŽŠĐčćžšđ ]+", re.IGNORECASE)
        ]

        # Factual state patterns
        self.injury_patterns = [
            (re.compile(r"(teš[kc]a|teska)\s+tjelesn[aeo]\s+povred[ae]", re.IGNORECASE), "teška tjelesna povreda"),
            (re.compile(r"(lak[aoe])\s+tjelesn[aeo]\s+povred[ae]", re.IGNORECASE), "laka tjelesna povreda"),
            (re.compile(r"(tešk[ao]|tesk[ao])\s+telesn[aeo]\s+povred[ae]", re.IGNORECASE), "teška tjelesna povreda"),
            (re.compile(r"(lak[aoe])\s+telesn[aeo]\s+povred[ae]", re.IGNORECASE), "laka tjelesna povreda"),
            (re.compile(r"тешк[ао]\s+тјелесн[ао]\s+повред[ае]", re.IGNORECASE), "teška tjelesna povreda"),
            (re.compile(r"лак[ао]\s+тјелесн[ао]\s+повред[ае]", re.IGNORECASE), "laka tjelesna povreda"),
        ]
        self.weapon_patterns = [
            (re.compile(r"metaln[iy]\s+klju[čc]", re.IGNORECASE), "metalni ključ"),
            (re.compile(r"metaln[iy]\s+ključ", re.IGNORECASE), "metalni ključ"),
            (re.compile(r"no[žz]", re.IGNORECASE), "nož"),
            (re.compile(r"pi[šs]tolj", re.IGNORECASE), "pistolj"),
            (re.compile(r"palic[ae]", re.IGNORECASE), "palica"),
            (re.compile(r"kamen", re.IGNORECASE), "kamen"),
            (re.compile(r"staklen[a-zčćžšđ]*\s+fla[šs]a", re.IGNORECASE), "staklena flaša"),
        ]
        self.substance_pattern = re.compile(
            r"(\d+(?:[\.,]\d+)?)\s*(mg|g|kg)\b(?:\s+([A-Za-zČĆŽŠĐčćžšđ]+))?",
            re.IGNORECASE
        )
        self.speed_pattern = re.compile(r"brzin[ao]\s+od\s+(\d+)\s*km/h", re.IGNORECASE)
        self.alcohol_pattern = re.compile(r"(\d+(?:[\.,]\d+)?)\s*(?:‰|promila)", re.IGNORECASE)
        self.location_patterns = [
            re.compile(r"\bu\s+(?:mjestu|mestu)\s+([A-ZČĆŽŠĐА-Я][a-zčćžšđа-я]+(?:\s+[A-ZČĆŽŠĐА-Я][a-zčćžšđа-я]+)*)"),
            re.compile(r"\bu\s+ulici\s+([A-ZČĆŽŠĐА-Я][\wčćžšđ]+(?:\s+[A-ZČĆŽŠĐА-Я][\wčćžšđ]+)*)"),
            re.compile(r"\bu\s+([A-ZČĆŽŠĐА-Я][a-zčćžšđа-я]+(?:\s+[A-ZČĆŽŠĐА-Я][a-zčćžšđа-я]+)*)"),
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
            metadata.case_number = self._clean_case_number(case_match.group(1).strip())
        else:
            inline_match = self.case_number_inline_pattern.search(text)
            if inline_match:
                inline_value = f"K.br. {inline_match.group(1).replace(' ', '')}"
                metadata.case_number = self._clean_case_number(inline_value)

        if not metadata.case_number and filename:
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
        inline_judges = self.judge_inline_pattern.findall(text)
        all_judges = list(judge_matches) + list(inline_judges)
        if all_judges:
            normalized = [self._normalize_person_name(j) for j in all_judges if len(j.strip()) > 3]
            metadata.judges = list({j for j in normalized if j})
        
        # Ekstraktuj reference na članke
        article_refs = self.article_ref_pattern.findall(text)
        if article_refs:
            metadata.article_references = [f"Član {ref}" for ref in set(article_refs)]

        # Ekstraktuj stranke (okrivljeni i oštećeni)
        defendants = self._extract_defendants(text)
        victims = self.victim_pattern.findall(text)
        if defendants:
            normalized_def = [self._normalize_person_name(d) for d in defendants]
            metadata.parties["defendant"] = list({d.strip() for d in normalized_def if d.strip()})
        if victims:
            normalized_vic = [self._normalize_person_name(v) for v in victims]
            metadata.parties["victim"] = list({v.strip() for v in normalized_vic if v.strip()})

        witnesses = self.witness_pattern.findall(text)
        clerks = self.clerk_pattern.findall(text)
        if witnesses:
            normalized_wit = [self._normalize_person_name(w) for w in witnesses]
            metadata.parties["witness"] = list({w.strip() for w in normalized_wit if w.strip()})
        if clerks:
            normalized_clerk = [self._normalize_person_name(c) for c in clerks]
            metadata.parties["clerk"] = list({c.strip() for c in normalized_clerk if c.strip()})

        metadata.factual_state = self._extract_factual_state(text)

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

    def _add_fact(self, facts: dict[str, List[str]], key: str, value: str) -> None:
        if not value:
            return
        key = key.strip()
        value = value.strip()
        if not key or not value:
            return
        facts.setdefault(key, [])
        if value not in facts[key]:
            facts[key].append(value)

    def _extract_factual_state(self, text: str) -> dict[str, List[str]]:
        facts: dict[str, List[str]] = {}

        for pattern, label in self.injury_patterns:
            if pattern.search(text):
                self._add_fact(facts, "injury_type", label)

        for pattern, label in self.weapon_patterns:
            if pattern.search(text):
                self._add_fact(facts, "weapon", label)

        for match in self.substance_pattern.findall(text):
            amount, unit, substance = match
            amount_norm = amount.replace(",", ".")
            if substance:
                self._add_fact(facts, "substance_amount", f"{amount_norm} {unit} {substance}")
            else:
                self._add_fact(facts, "amount", f"{amount_norm} {unit}")

        for match in self.speed_pattern.findall(text):
            self._add_fact(facts, "speed", f"{match} km/h")

        for match in self.alcohol_pattern.findall(text):
            self._add_fact(facts, "alcohol_level", f"{match} promila")

        for loc in self._extract_locations(text):
            self._add_fact(facts, "location", loc)

        return facts

    def _normalize_person_name(self, name: str) -> str:
        cleaned = " ".join(name.replace("\u00a0", " ").split())
        tokens = cleaned.split()
        merged_tokens = []
        idx = 0
        while idx < len(tokens):
            token = tokens[idx]
            if (
                len(token) == 1
                and token.isupper()
                and idx + 1 < len(tokens)
                and tokens[idx + 1][0].isupper()
                and tokens[idx + 1][1:].islower()
            ):
                next_token = tokens[idx + 1]
                merged = token + next_token[0].lower() + next_token[1:]
                merged_tokens.append(merged)
                idx += 2
                continue
            merged_tokens.append(token)
            idx += 1
        fixed_tokens = []
        for token in merged_tokens:
            if len(token) == 1 and token.isalpha() and fixed_tokens:
                prev = fixed_tokens[-1]
                if prev and prev[-1].isalpha():
                    fixed_tokens[-1] = prev + token
                    continue
            fixed_tokens.append(token)
        cleaned = " ".join(fixed_tokens)
        cleaned = re.sub(r"([A-ZČĆŽŠĐ])\s+([a-zčćžšđ])", r"\1\2", cleaned)
        cleaned = re.sub(r"([a-zčćžšđ])\s+([čćžšđ])\b", r"\1\2", cleaned)
        cleaned = re.sub(r"\s+,", ",", cleaned)
        return cleaned.strip()

    def _extract_locations(self, text: str) -> List[str]:
        stopwords = {
            "ime", "okrivljeni", "okrivljenog", "okrivljenih", "vidu", "roku", "trajanju",
            "predjelu", "postupku", "spisima", "izreci", "svemu", "okviru", "vezi", "smislu",
            "periodu", "javnom", "toku", "ulici", "ul", "mjestu", "mestu", "stranaka", "odsustvu",
            "kafe", "tu", "tuči", "skladu"
        }
        results: List[str] = []

        for pattern in self.location_patterns:
            for match in pattern.findall(text):
                candidate = match.strip().strip(",.;:)")
                if not candidate:
                    continue
                if candidate.isupper():
                    candidate = candidate.title()
                candidate = self._normalize_location(candidate)
                head = candidate.split()[0].lower()
                if head in stopwords:
                    continue
                if len(candidate) < 3:
                    continue
                results.append(candidate)

        unique = []
        for loc in results:
            if loc not in unique:
                unique.append(loc)
        return unique

    def _normalize_location(self, location: str) -> str:
        mapping = {
            "Podgorici": "Podgorica",
            "Podgorica": "Podgorica",
            "Danilovgradu": "Danilovgrad",
            "Skadru": "Skadar"
        }
        if location in mapping:
            return mapping[location]
        return location

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

    def _clean_case_number(self, value: str | None) -> Optional[str]:
        if not value:
            return None

        candidate = " ".join(value.replace("\u00a0", " ").split())
        lowered = candidate.lower()
        if lowered in {"n/a", "na", "none"}:
            return None

        # Reject obvious OCR noise that does not resemble a case identifier.
        if len(candidate) < 4:
            return None
        if not re.search(r"\d", candidate):
            return None
        if re.fullmatch(r"[\.\-/]+", candidate):
            return None

        # Remove leading/trailing punctuation while preserving internal separators.
        candidate = candidate.strip(" .,-_\t")
        if not candidate or len(candidate) < 4:
            return None

        return candidate

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
            # Use safe ASCII representation for filenames with non-ASCII chars
            safe_filename = filename.encode('ascii', 'replace').decode('ascii')
            print(f"[{idx}/{total}] Parsiram: {safe_filename}")
            
            try:
                metadata = self.parse(text, filename)
                results[filename] = metadata
                
                print(f"  [OK] Broj predmeta: {metadata.case_number or 'N/A'}")
                print(f"  [OK] Sud: {(metadata.court_name or 'N/A').encode('ascii', 'replace').decode('ascii')}")
                print(f"  [OK] Datum: {metadata.date or 'N/A'}")
                print(f"  [OK] Reference na clanke: {len(metadata.article_references)}")
            
            except Exception as e:
                print(f"  [X] Greska: {str(e).encode('ascii', 'replace').decode('ascii')}")
                # Kreiraj prazan metadata sa sirovic tekstom
                results[filename] = VerdictMetadata(raw_text=text, case_number=filename)
        
        return results
