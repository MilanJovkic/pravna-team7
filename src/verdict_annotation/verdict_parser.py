"""Parser for structuring court verdict text."""
import re
import unicodedata
from typing import List, Optional

from backend.app.domain.verdict.entities import VerdictMetadata
from .outcome_normalizer import _latinize, normalize_outcome

class VerdictParser:
    """Parses court verdict text and extracts structured metadata."""

    def __init__(self):
        # Regex patterns za identifikaciju elemenata
        self.case_number_patterns = [
            re.compile(r"\bK\.?\s*br\.?\s*[:.]?\s*([0-9]{1,5}\s*/\s*[0-9]{1,4})\b", re.IGNORECASE),
            re.compile(r"\bPosl\.?\s*br\.?\s*K\.?\s*[:.]?\s*([0-9]{1,5}\s*/\s*[0-9]{1,4})\b", re.IGNORECASE),
            re.compile(r"\bK\s+([0-9]{1,5}\s*/\s*[0-9]{1,4})\b", re.IGNORECASE),
            re.compile(r"\bK[tvžz]?\.?\s*br\.?\s*[:.]?\s*([0-9]{1,5}\s*/\s*[0-9]{1,4})\b", re.IGNORECASE),
        ]
        self.court_pattern = re.compile(
            r'((?:Врховни|Виши|Основни|Апелациони|Привредни)\s+суд'
            r'|(?:Vrhovni|Viši|Visi|Osnovni|Apelacioni|Privredni)\s+sud)'
            r'(?:\s+u\s+[A-ZČĆŽŠĐА-Я][\wčćžšđа-я]+(?:\s+[A-ZČĆŽŠĐА-Я][\wčćžšđа-я]+){0,2})?'
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
            r'(?:po\s+sudiji\s*|po\s+sutkinji\s*|po\s+sudinic[ai]\s*|sudija(?!\s+za\b)\s+|sutkinja\s+)'
            r'(?:mr\.?\s*|dr\.?\s*)?'
            r'([A-ZČĆŽŠĐА-Я][A-Za-zČĆŽŠĐčćžšđА-Яа-я\.]*'
            r'(?:\s+[A-ZČĆŽŠĐА-Я][A-Za-zČĆŽŠĐčćžšđА-Яа-я\.]*){0,2})',
            re.IGNORECASE
        )
        self.article_ref_pattern = re.compile(
            r'(?:č\s*l\s*\.|čl\.|cl\.|član|члан)(?:а|у|ом)?\s*(\d+[a-z]?)',
            re.IGNORECASE
        )

        self.defendant_marker = re.compile(r"okrivljeni:?", re.IGNORECASE)
        self.victim_marker_pattern = re.compile(r'\b(?:oštećen(?:i|og|a)?|ostecen(?:i|og|a)?)\b', re.IGNORECASE)
        self.witness_marker_pattern = re.compile(r'\b(?:svjedok(?:a|inja)?|svedok(?:a|inja)?)\b', re.IGNORECASE)
        self.clerk_pattern = re.compile(
            r'(?:zapisni[čc]ar|zapisničar)\s*:?' 
            r'\s+([A-ZČĆŽŠĐА-Я]\.?:?\s*[A-ZČĆŽŠĐА-Я]\.|[A-ZČĆŽŠĐА-Я][a-zčćžšđа-я]+(?:\s+[A-ZČĆŽŠĐА-Я][a-zčćžšđа-я]+)*)',
            re.IGNORECASE
        )
        self.initials_pattern = re.compile(r'\b([A-ZČĆŽŠĐА-Я]\.?\s*[A-ZČĆŽŠĐА-Я]\.?)\b')
        self.person_name_pattern = re.compile(
            r'\b([A-ZČĆŽŠĐА-Я][a-zčćžšđа-я]+(?:\s+[A-ZČĆŽŠĐА-Я][a-zčćžšđа-я]+){1,2})\b'
        )
        self.applied_law_patterns = [
            re.compile(r"Krivičn[iy] zakonik Crne Gore", re.IGNORECASE),
            re.compile(r"Zakonik o krivičnom postupku(?: Crne Gore)?", re.IGNORECASE),
            re.compile(r"Zakon o [A-Za-zČĆŽŠĐčćžšđ ]+", re.IGNORECASE)
        ]

        self.city_aliases = {
            "podgorici": "Podgorica",
            "podgorica": "Podgorica",
            "herceg novom": "Herceg Novi",
            "herceg novi": "Herceg Novi",
            "niksicu": "Nikšić",
            "niksic": "Nikšić",
            "baru": "Bar",
            "bar": "Bar",
            "budvi": "Budva",
            "budva": "Budva",
            "kotoru": "Kotor",
            "kotor": "Kotor",
            "tivtu": "Tivat",
            "tivat": "Tivat",
            "ulcinju": "Ulcinj",
            "ulcinj": "Ulcinj",
            "danilovgradu": "Danilovgrad",
            "danilovgrad": "Danilovgrad",
            "bijelom polju": "Bijelo Polje",
            "bijelo polje": "Bijelo Polje",
            "beranama": "Berane",
            "berane": "Berane",
            "cetinju": "Cetinje",
            "cetinje": "Cetinje",
            "pljevljima": "Pljevlja",
            "pljevlja": "Pljevlja",
        }

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

        metadata.case_number = self._extract_case_number(text, filename)
        
        # Ekstraktuj sud
        court_name = self._extract_court_name(text)
        if court_name:
            metadata.court_name = court_name
        
        # Ekstraktuj datum
        metadata.date = self._extract_primary_date(text)
        
        # Ekstraktuj sudije
        judge_matches = self.judge_pattern.findall(text)
        inline_judges = self.judge_inline_pattern.findall(text)
        fallback_judges = self._extract_additional_judges(text)
        all_judges = list(judge_matches) + list(inline_judges) + list(fallback_judges)
        if all_judges:
            normalized = [
                self._normalize_judge_name(j)
                for j in all_judges
                if len(j.strip()) > 1
            ]
            filtered = [j for j in normalized if self._looks_like_judge_name(j)]
            ordered = self._ordered_unique(filtered)
            ordered = self._collapse_near_duplicate_names(ordered)
            full_names = [name for name in ordered if " " in name]
            metadata.judges = full_names or ordered
        
        # Ekstraktuj reference na članke
        article_refs = self.article_ref_pattern.findall(text)
        if article_refs:
            metadata.article_references = [f"Član {ref}" for ref in set(article_refs)]

        # Ekstraktuj stranke (okrivljeni i oštećeni)
        defendants = self._extract_defendants(text)
        victims = self._extract_victims(text)
        if defendants:
            cleaned_def = self._clean_party_values("defendant", defendants)
            if cleaned_def:
                metadata.parties["defendant"] = cleaned_def
        if victims:
            cleaned_vic = self._clean_party_values("victim", victims)
            if cleaned_vic:
                metadata.parties["victim"] = cleaned_vic

        witnesses = self._extract_witnesses(text)
        clerks = self.clerk_pattern.findall(text)
        if witnesses:
            cleaned_wit = self._clean_party_values("witness", witnesses)
            if cleaned_wit:
                metadata.parties["witness"] = cleaned_wit
        if clerks:
            cleaned_clerk = self._clean_party_values("clerk", clerks)
            if cleaned_clerk:
                metadata.parties["clerk"] = cleaned_clerk

        metadata.factual_state = self._extract_factual_state(text)
        metadata.factual_state = self._merge_fact_maps(
            metadata.factual_state,
            self._extract_sentencing_facts(text),
        )

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

        metadata.case_outcome = self._extract_case_outcome(text)
        
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

    def _extract_additional_judges(self, text: str) -> List[str]:
        """Fallback judge extraction for OCR-heavy or signature-style lines."""
        search_space = text[:12000]
        if len(text) > 4000:
            search_space += "\n" + text[-4000:]
        search_space = re.sub(r"(?i)s\s+u\s+d\s+i\s+j\s+a", "sudija", search_space)
        search_space = re.sub(r"(?i)sudinic[ai]", "sudiji", search_space)

        candidates: List[str] = []

        for pattern in (
            re.compile(
                r'(?i)\b(?:po\s+sudiji|po\s+sutkinji)\s*(?:mr\.?\s*|dr\.?\s*)?'
                r'([A-ZČĆŽŠĐ][A-Za-zČĆŽŠĐčćžšđ\.]+(?:\s+[A-ZČĆŽŠĐ][A-Za-zČĆŽŠĐčćžšđ\.]+){0,2})'
            ),
            re.compile(
                r'(?i)\b(?:predsjednik(?:a)?\s+vije[cć]a[-\s]*)?sudija\s+'
                r'(?:mr\.?\s*|dr\.?\s*)?'
                r'([A-ZČĆŽŠĐ][A-Za-zČĆŽŠĐčćžšđ\.]+(?:\s+[A-ZČĆŽŠĐ][A-Za-zČĆŽŠĐčćžšđ\.]+){0,2})'
            ),
            re.compile(
                r'(?i)\bSudija\s+Osnovnog\s+suda[^\n,]{0,80}\s+'
                r'([A-ZČĆŽŠĐ][a-zčćžšđ]+(?:\s+[A-ZČĆŽŠĐ][a-zčćžšđ]+){1,2})'
            ),
        ):
            candidates.extend(pattern.findall(search_space))

        council_full_pattern = re.compile(
            r'(?is)u\s+vije[cć]u\s+st[a-z]*avljenom\s+od\s+sudije\s+'
            r'(.{1,140}?)\s*,?\s*kao\s+predsjednika\s+vije[cć]a\s+i\s+sudija\s+'
            r'(.{1,180}?)(?:\s*,\s*kao|\s+kao\s+clanova|\s+uz\s+u[cč]e|\n)'
        )
        for match in council_full_pattern.finditer(search_space):
            president = match.group(1)
            members_block = match.group(2)
            candidates.append(president)

            if re.search(r'(?i)\bi\b', members_block):
                member_parts = re.split(r'(?i)\bi\b', members_block)
                candidates.extend(part for part in member_parts if part and part.strip())
            else:
                member_names = re.findall(
                    r'[A-ZČĆŽŠĐ][A-Za-zČĆŽŠĐčćžšđ\.]+\s+[A-ZČĆŽŠĐ][A-Za-zČĆŽŠĐčćžšđ\.]+',
                    members_block,
                )
                candidates.extend(member_names)

        council_pattern = re.compile(
            r'(?i)u\s+vije[cć]u\s+sastavljenom\s+od\s+sudije\s+'
            r'([A-ZČĆŽŠĐ]\.?(?:\s*[A-ZČĆŽŠĐ]\.?)?)'
            r'(?:[^\n]{0,120}?\bsudija\s+'
            r'([A-ZČĆŽŠĐ]\.?(?:\s*[A-ZČĆŽŠĐ]\.?)?)\s+i\s+'
            r'([A-ZČĆŽŠĐ]\.?(?:\s*[A-ZČĆŽŠĐ]\.?)?))?'
        )
        for match in council_pattern.finditer(search_space):
            for group in match.groups():
                if group:
                    candidates.append(group)

        for line_match in re.finditer(r'(?i)\b(?:sudija|sutkinja)\b[^\n]{0,120}', search_space):
            line = line_match.group(0)
            initials = re.findall(r'\b([A-ZČĆŽŠĐ]\.?(?:\s*[A-ZČĆŽŠĐ]\.?)?)\b', line)
            for value in initials:
                if len(re.findall(r'[A-ZČĆŽŠĐ]', value)) >= 2:
                    candidates.append(value)

        return self._ordered_unique([c.strip() for c in candidates if c and c.strip()])

    def _normalize_initials(self, value: str) -> str:
        letters = re.findall(r'[A-ZČĆŽŠĐА-Я]', (value or "").upper())
        if 2 <= len(letters) <= 3 and re.fullmatch(r'[A-ZČĆŽŠĐА-Я\.\s]+', (value or "").upper()):
            return "".join(f"{letter}." for letter in letters)
        return value.strip()

    def _looks_like_initials(self, value: str) -> bool:
        compact = re.sub(r'\s+', '', value or "")
        return bool(re.fullmatch(r'(?:[A-ZČĆŽŠĐА-Я]\.){2,3}', compact))

    def _looks_like_party_name(self, value: str, role: str) -> bool:
        if not value:
            return False
        if self._looks_like_initials(value):
            return True
        if not self._looks_like_person_name(value):
            return False

        normalized = self._normalize_for_matching(value)
        tokens = set(normalized.split())

        blocked_common = {
            "sud", "suda", "sudija", "sutkinja", "zapisnicar", "zapisnicar", "vjestak",
            "istragu", "ispostava", "opstina", "opstina", "ku", "kti", "predstavnik",
            "odbrane", "okrivljeni", "optuzeni", "osteceni", "svjedok", "svedok",
            "naveo", "navela", "objasnio", "dodao", "pokazao", "odgovorio", "izjavio",
            "predsjednik", "predsednik", "vijeca", "veca", "krivicnog", "krivicni",
            "zakonika", "zakonik", "budzeta", "drzavni", "tuzilastvo", "postupku",
            "obrazlozenje", "osnovno", "osnovni", "presuda",
        }
        if tokens & blocked_common:
            return False

        legal_phrase_tokens = {
            "krivicnog", "krivicni", "zakonika", "zakonik", "crne", "gore",
            "postupku", "predsjednik", "predsednik", "vijeca", "veca", "budzeta",
            "drzave", "zakona", "clana", "clan", "obrazlozenje", "osnovno", "presuda",
        }
        token_list = [tok for tok in normalized.split() if tok]
        if token_list:
            legal_hits = sum(1 for tok in token_list if tok in legal_phrase_tokens)
            if legal_hits >= max(2, len(token_list) - 1):
                return False

        blocked_geo_vehicle = {
            "podgorica", "herceg", "novi", "ulcinj", "kotor", "bar", "budva", "tivat",
            "cetinje", "rozaje", "berane", "pljevlja", "niksic", "danilovgrad", "bijelo",
            "polje", "fiat", "zastava", "opel", "golf", "punto", "corsa", "magnum",
            "mercedes", "audi", "bmw", "renault", "toyota", "peugeot", "skoda", "vozilo",
        }
        if role in {"victim", "witness", "clerk"} and (tokens & blocked_geo_vehicle):
            return False

        return True

    def _clean_party_values(self, role: str, values: List[str]) -> List[str]:
        cleaned: List[str] = []
        exact_seen = set()
        soft_index: dict[str, int] = {}

        for raw in values or []:
            value = self._normalize_person_name(str(raw or ""))
            value = self._normalize_initials(value)
            if not value or not self._looks_like_party_name(value, role):
                continue

            exact_key = value.lower()
            if exact_key in exact_seen:
                continue

            soft_key = self._party_name_soft_signature(value)
            if soft_key in soft_index:
                idx = soft_index[soft_key]
                better = self._choose_better_party_variant(cleaned[idx], value)
                if better.lower() != cleaned[idx].lower():
                    exact_seen.discard(cleaned[idx].lower())
                    cleaned[idx] = better
                    exact_seen.add(better.lower())
                continue

            soft_index[soft_key] = len(cleaned)
            cleaned.append(value)
            exact_seen.add(exact_key)

        return cleaned

    def _party_name_soft_signature(self, value: str) -> str:
        normalized = self._normalize_for_matching(value)
        tokens = [tok for tok in normalized.split() if tok]
        softened: List[str] = []

        for tok in tokens:
            if len(tok) >= 5 and tok.endswith("a") and not tok.endswith("ica"):
                softened.append(tok[:-1])
            else:
                softened.append(tok)

        return " ".join(sorted(softened))

    def _party_variant_score(self, value: str) -> int:
        normalized = self._normalize_for_matching(value)
        tokens = [tok for tok in normalized.split() if tok]
        score = 0

        if self._looks_like_person_name(value):
            score += 4
        if value.isupper():
            score -= 3

        if tokens and len(tokens) == 2:
            surname = tokens[-1]
            if len(surname) >= 5 and surname.endswith("a") and not surname.endswith("ica"):
                score -= 1

        if any(tok in {"predsjednik", "predsednik", "vijeca", "veca"} for tok in tokens):
            score -= 4

        return score

    def _choose_better_party_variant(self, current: str, candidate: str) -> str:
        current_score = self._party_variant_score(current)
        candidate_score = self._party_variant_score(candidate)

        if candidate_score > current_score:
            return candidate
        if candidate_score < current_score:
            return current

        if len(candidate) < len(current):
            return candidate
        return current

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

        self._extract_factual_state_from_compact_text(text, facts)

        return facts

    def _extract_factual_state_from_compact_text(self, text: str, facts: dict[str, List[str]]) -> None:
        """Fallback extraction resilient to OCR text with split characters inside words."""
        normalized = self._normalize_for_matching(text)
        compact = normalized.replace(" ", "")

        if any(token in compact for token in ["teskutjelesnupovredu", "teskatjelesnapovreda", "teskutelesnupovredu", "teskatelesnapovreda"]):
            self._add_fact(facts, "injury_type", "teška tjelesna povreda")
            self._add_fact(facts, "severe_consequence", "da")
        if any(token in compact for token in ["lakatjelesnupovredu", "lakatjelesnapovreda", "lakatelesnupovredu", "lakatelesnapovreda"]):
            self._add_fact(facts, "injury_type", "laka tjelesna povreda")

        if "pistolj" in compact:
            self._add_fact(facts, "weapon", "pistolj")
        if "noz" in compact:
            self._add_fact(facts, "weapon", "nož")
        if "pusk" in compact:
            self._add_fact(facts, "weapon", "puška")

        if facts.get("weapon"):
            self._add_fact(facts, "weapon_used", "da")

        has_attempt_marker = any(token in compact for token in ["upokusaju", "pokusao", "pokusala", "pokusaj"])
        has_explicit_death_outcome = any(
            token in compact
            for token in [
                "nastupilasmrt",
                "smrtostecenog",
                "smrtniishod",
                "smrtnishod",
                "preminuo",
                "preminula",
                "podlegao",
                "podlegla",
                "usledcegajesmrt",
                "usljedcegajesmrt",
            ]
        )
        if has_explicit_death_outcome or ("lisiozivota" in compact and not has_attempt_marker) or "usmrtio" in compact:
            self._add_fact(facts, "death_result", "da")

    def _extract_sentencing_facts(self, text: str) -> dict[str, List[str]]:
        """Extract sentencing-relevant facts used for punishment individualization."""
        facts: dict[str, List[str]] = {}
        normalized = self._normalize_for_matching(text)
        compact = normalized.replace(" ", "")

        if re.search(r"\branije\s+neosudjivan\b|\bneosudjivan\b|\bnije\s+osudjivan\b", normalized):
            self._add_fact(facts, "previous_convictions", "ne")
        elif re.search(
            r"\branije\s+osudjivan\b|\bprethodno\s+osudjivan\b|\bvise\s+puta\s+osudjivan\b|\bprethodne\s+osude\b|\bprethodn\w*\s+osud\w*\b",
            normalized,
        ):
            self._add_fact(facts, "previous_convictions", "da")

        if re.search(r"\bpovratnik\b|\bspecijalni\s+povrat\b", normalized):
            self._add_fact(facts, "repeat_offender", "da")

        if re.search(
            r"\bpriznao\s+krivicu\b|\bpriznao\s+izvrsenje\b|\bpriznanje\s+krivice\b|\bpriznavanje\s+krivice\b",
            normalized,
        ):
            self._add_fact(facts, "confession", "da")

        if re.search(r"\bkaje\s+se\b|\bpokajao\s+se\b|\biskreno\s+kajanje\b", normalized):
            self._add_fact(facts, "remorse", "da")

        if re.search(r"\bsporazum\s+o\s+priznanju\s+krivice\b", normalized):
            self._add_fact(facts, "plea_agreement", "da")

        if re.search(r"\bolaksavajuc\w*\s+okolnost", normalized):
            self._add_fact(facts, "mitigating_circumstances", "da")

        if re.search(r"\botezavajuc\w*\s+okolnost", normalized):
            self._add_fact(facts, "aggravating_circumstances", "da")

        if re.search(r"\bizdrzava\s+porodicu\b|\botac\s+\d+\s+djece\b|\bmajka\s+\d+\s+djece\b|\bporodicn\w*\s+prilik", normalized):
            self._add_fact(facts, "family_circumstances", "da")

        if re.search(r"\blos\w*\s+imovn\w*\s+stanj\w*\b|\blos\w*\s+imovn\w*\s+prilik\w*\b|\bnezaposlen\w*\b", normalized):
            self._add_fact(facts, "poor_financial_status", "da")

        if re.search(r"\balkoholisan\w*\b|\bpod\s+dejstvom\s+alkohola\b|\balkohola\s+u\s+krvi\b", normalized):
            self._add_fact(facts, "alcohol_intoxication", "da")

        if re.search(r"\bopojnih\s+droga\b|\bnarkotik\w*\b|\bpsihoaktivn\w*\b", normalized):
            self._add_fact(facts, "narcotics_influence", "da")

        if re.search(r"\buslovn\w*\s+osud\w*\b|\bnece\s+izvrsiti\s+ukoliko\b", normalized):
            self._add_fact(facts, "conditional_sentence_requested", "da")

        if (
            re.search(r"\bu\s+pokusaj\w*\b|\bpokusao\s+da\b|\bpokusala\s+da\b|\bpokusaj\s+ubistva\b", normalized)
            or any(token in compact for token in ["upokusaju", "pokusaodalisi", "pokusajubistva"])
        ):
            self._add_fact(facts, "attempted_offense", "da")

        imposed_months = self._extract_imposed_prison_months(text)
        if imposed_months is not None:
            self._add_fact(facts, "imposed_prison_sentence_months", str(imposed_months))

        return facts

    def _merge_fact_maps(
        self,
        left: dict[str, List[str]],
        right: dict[str, List[str]],
    ) -> dict[str, List[str]]:
        merged: dict[str, List[str]] = {key: list(values) for key, values in (left or {}).items()}
        for key, values in (right or {}).items():
            for value in values:
                self._add_fact(merged, key, value)
        return merged

    def _extract_imposed_prison_months(self, text: str) -> Optional[int]:
        normalized = self._normalize_for_matching(text)
        patterns = [
            re.compile(
                r"kazn(?:u|a)\s+zatvora\s+u\s+trajanju\s+od\s+(.{1,100})",
                re.IGNORECASE,
            ),
            re.compile(
                r"osudj(?:uje|en)\s+se\s+na\s+kazn(?:u|a)\s+zatvora\s+u\s+trajanju\s+od\s+(.{1,100})",
                re.IGNORECASE,
            ),
        ]

        for pattern in patterns:
            match = pattern.search(normalized)
            if not match:
                continue
            fragment = match.group(1)
            stop_markers = [
                " u koju",
                " presudom",
                " zbog",
                " pa se",
                " i istovremeno",
                " ali se",
                " te se",
            ]
            cut_positions = [fragment.find(marker) for marker in stop_markers if fragment.find(marker) >= 0]
            if cut_positions:
                fragment = fragment[: min(cut_positions)]
            years = 0
            months = 0

            year_match = re.search(r"(\d+|[a-z]+)\s*(?:godina|godine|godinu|god)\b", fragment)
            if year_match:
                years = self._parse_number_token(year_match.group(1)) or 0

            month_match = re.search(r"(\d+|[a-z]+)\s*(?:mjeseci|mjeseca|mjesec|meseci|meseca|mesec)\b", fragment)
            if month_match:
                months = self._parse_number_token(month_match.group(1)) or 0

            total_months = years * 12 + months
            if total_months > 0:
                return total_months

        return None

    def _parse_number_token(self, token: str) -> Optional[int]:
        value = str(token or "").strip().lower()
        value = re.sub(r"[^a-z0-9]", "", value)
        if not value:
            return None
        if value.isdigit():
            return int(value)

        number_words = {
            "jedan": 1,
            "jedna": 1,
            "jedne": 1,
            "jednog": 1,
            "dva": 2,
            "dvije": 2,
            "dve": 2,
            "tri": 3,
            "cetiri": 4,
            "pet": 5,
            "sest": 6,
            "sedam": 7,
            "osam": 8,
            "devet": 9,
            "deset": 10,
            "jedanaest": 11,
            "dvanaest": 12,
            "trinaest": 13,
            "cetrnaest": 14,
            "petnaest": 15,
            "sesnaest": 16,
            "sedamnaest": 17,
            "osamnaest": 18,
            "devetnaest": 19,
            "dvadeset": 20,
        }
        return number_words.get(value)

    def _normalize_for_matching(self, text: str) -> str:
        lowered = _latinize(text.lower()).replace("\u00a0", " ")
        normalized = unicodedata.normalize("NFD", lowered)
        normalized = "".join(ch for ch in normalized if unicodedata.category(ch) != "Mn")
        normalized = re.sub(r"[^a-z0-9\s]", " ", normalized)
        return re.sub(r"\s+", " ", normalized).strip()

    def _normalize_person_name(self, name: str) -> str:
        cleaned = " ".join(str(name or "").replace("\u00a0", " ").split())
        if not cleaned:
            return ""

        cleaned = re.sub(r"(?i)\bpravna\s+pouka\b.*$", "", cleaned)
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
        # Split OCR-glued surname+name tokens, e.g. "JelenićVesna".
        cleaned = re.sub(r"(?<=[a-zčćžšđ])(?=[A-ZČĆŽŠĐ])", " ", cleaned)
        # Join split lowercase fragments in first names, e.g. "Ogn jane" -> "Ognjane".
        prev = None
        while prev != cleaned:
            prev = cleaned
            cleaned = re.sub(
                r"\b([A-ZČĆŽŠĐ][a-zčćžšđ]{2,6})\s+([a-zčćžšđ]{2,6})\b",
                r"\1\2",
                cleaned,
            )
        cleaned = re.sub(r"([A-ZČĆŽŠĐ])\s+([a-zčćžšđ])", r"\1\2", cleaned)
        cleaned = re.sub(r"([a-zčćžšđ])\s+([čćžšđ])\b", r"\1\2", cleaned)
        cleaned = re.sub(r"\s+,", ",", cleaned)
        cleaned = " ".join(cleaned.split())
        return cleaned.strip()

    def _normalize_judge_name(self, name: str) -> str:
        cleaned = self._normalize_person_name(name)
        if not cleaned:
            return ""

        cleaned = self._normalize_initials(cleaned)
        if self._looks_like_initials(cleaned):
            return cleaned

        cleaned = re.sub(
            r"(?i)\b(?:sudija|sutkinja|predsjednik(?:a)?|predsednik(?:a)?|vije[cć]a?|ve[cć]a?|porotnik(?:a)?|zapisni[cč]ar(?:a)?|kao)\b",
            " ",
            cleaned,
        )
        cleaned = re.sub(
            r"(?i)\b(?:osnovnog|osnovni|vi[sš]eg|vrhovnog|apelacionog|privrednog)\s+suda?\b",
            " ",
            cleaned,
        )
        cleaned = re.sub(r"(?i)\bza\s+istragu\b", " ", cleaned)
        cleaned = re.sub(r"(?i)\bs\.?\s*r\.?\b", " ", cleaned)
        cleaned = re.sub(r"(?i)\b(?:dana|optu[žz]en\w*|okrivljen\w*)\b.*$", " ", cleaned)
        cleaned = re.sub(r"(?i)\b([A-ZČĆŽŠĐ][A-Za-zČĆŽŠĐčćžšđ]+(?:ić|ic))i\b", r"\1", cleaned)
        cleaned = re.sub(r"(?i)\b([A-ZČĆŽŠĐ][A-Za-zČĆŽŠĐčćžšđ]+a)i\b", r"\1", cleaned)
        cleaned = " ".join(cleaned.split())

        cleaned = self._normalize_initials(cleaned)
        if self._looks_like_initials(cleaned):
            return cleaned

        name_tokens = re.findall(r"[A-ZČĆŽŠĐ][a-zčćžšđ]+", cleaned)
        if len(name_tokens) >= 2:
            first, second = name_tokens[0], name_tokens[1]
            if self._looks_like_surname(first) and not self._looks_like_surname(second):
                second = self._normalize_given_name_case(second)
            else:
                first = self._normalize_given_name_case(first)
            return f"{first} {second}"

        initials = self.initials_pattern.search(cleaned)
        if initials:
            return initials.group(1).replace(" ", "")

        return cleaned

    def _ordered_unique(self, values: List[str]) -> List[str]:
        unique: List[str] = []
        seen = set()
        for value in values:
            key = value.strip()
            if not key:
                continue
            lowered = key.lower()
            if lowered in seen:
                continue
            seen.add(lowered)
            unique.append(key)
        return unique

    def _collapse_near_duplicate_names(self, values: List[str]) -> List[str]:
        collapsed: List[str] = []
        for candidate in values:
            candidate_key = candidate.lower()
            replaced = False
            for idx, existing in enumerate(collapsed):
                existing_key = existing.lower()
                if candidate_key == existing_key:
                    replaced = True
                    break
                if candidate_key.startswith(existing_key) or existing_key.startswith(candidate_key):
                    if len(candidate) > len(existing):
                        collapsed[idx] = candidate
                    replaced = True
                    break
            if not replaced:
                collapsed.append(candidate)
        return collapsed

    def _looks_like_surname(self, token: str) -> bool:
        lowered = (token or "").lower()
        return lowered.endswith(("ić", "ic", "ović", "ovic", "ević", "evic", "ski", "ska", "čki", "cki"))

    def _normalize_given_name_case(self, token: str) -> str:
        value = (token or "").strip()
        lowered = value.lower()
        if len(lowered) < 4:
            return value

        # Frequent Montenegrin dative forms seen in headers/signatures.
        if lowered.endswith("iji"):
            return value[:-1] + "a"
        if lowered.endswith("ji"):
            return value[:-1] + "a"
        if lowered.endswith("avu"):
            return value[:-1]
        if lowered.endswith("u") and len(lowered) >= 6:
            return value[:-1]

        return value

    def _looks_like_judge_name(self, value: str) -> bool:
        if not value:
            return False

        if self._looks_like_initials(value):
            return True

        words = value.split()
        if len(words) < 2 or len(words) > 3:
            return False

        blocked = {
            "sud", "suda", "sudija", "sutkinja", "pravna", "pouka", "predsjednika", "predsednika",
            "vijeca", "veca", "zapisnicar", "porotnik", "osnovnog", "viseg", "višeg", "vrhovnog", "apelacionog",
        }

        for word in words:
            if "." in word:
                return False
            core = word.strip(".,;:")
            if len(core) < 2:
                return False
            if not re.fullmatch(r"[A-Za-zČĆŽŠĐčćžšđ]+", core):
                return False
            low = core.lower()
            if not core[0].isupper():
                return False
            if low in blocked:
                return False
            if any(ch.isdigit() for ch in core):
                return False

        return True

    def _extract_locations(self, text: str) -> List[str]:
        results: List[str] = []
        normalized = self._normalize_for_matching(text)

        for alias, canonical in self.city_aliases.items():
            if re.search(rf"\b(?:u|na|iz|kod)\s+{re.escape(alias)}\b", normalized):
                if canonical not in results:
                    results.append(canonical)

        # As a precise fallback, accept city from court header if available.
        court_text = self._extract_court_name(text)
        if court_text:
            normalized_court = self._normalize_for_matching(court_text)
            for alias, canonical in self.city_aliases.items():
                if alias in normalized_court and canonical not in results:
                    results.append(canonical)

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

        primary_block = re.search(
            r"(?is)(?:optuzeni|optuženi|okrivljeni)\s*:?\s*(.{0,260})(?:\n\n|\n\s*na\s+osnovu|\n\s*kriv\s+je|\n\s*osudjuje|\n\s*oslobada|\n\s*oslobađa)",
            text,
        )
        if primary_block:
            snippet = primary_block.group(1)
            for initials in self.initials_pattern.findall(snippet):
                defendants.append(initials.replace(" ", ""))
            if not defendants:
                for name in self.person_name_pattern.findall(snippet):
                    defendants.append(name.strip())

        if not defendants:
            for match in self.defendant_marker.finditer(text):
                snippet = text[match.end():match.end() + 100]
                for initials in self.initials_pattern.findall(snippet):
                    defendants.append(initials.replace(" ", ""))
                if defendants:
                    break

        unique = []
        for candidate in defendants:
            cleaned = candidate.strip().strip(",.;")
            if len(cleaned) >= 3 and cleaned not in unique:
                unique.append(cleaned)
        return unique

    def _extract_case_number(self, text: str, filename: Optional[str]) -> str:
        header = "\n".join(text.splitlines()[:80])
        for pattern in self.case_number_patterns:
            match = pattern.search(header)
            if match:
                number = " ".join(match.group(1).split())
                return f"K.br. {number}".replace(" /", "/").replace("/ ", "/")

        inline_match = re.search(r"\b([0-9]{1,5}\s*/\s*[0-9]{1,4})\b", header)
        if inline_match:
            number = " ".join(inline_match.group(1).split())
            return f"K.br. {number}".replace(" /", "/").replace("/ ", "/")

        if filename:
            return filename
        return ""

    def _extract_court_name(self, text: str) -> Optional[str]:
        candidates: List[tuple[int, int, str]] = []

        for match in self.court_pattern.finditer(text):
            candidate = " ".join(match.group(0).split()).strip(" ,.;")
            candidate = re.sub(r"(?i)\s+(?:dana|kao|optu[žz]en\w*|okrivljen\w*)\b.*$", "", candidate).strip(" ,.;")
            if not candidate:
                continue

            normalized = self._normalize_for_matching(candidate)
            score = 0

            # Prefer entries that include a known city over generic "OSNOVNI SUD" variants.
            if any(alias in normalized for alias in self.city_aliases):
                score += 8

            if " sud u " in f" {normalized} ":
                score += 2

            # Penalize abbreviations like "u P." or "u N.K.".
            if re.search(r"\bu\s+[a-z]\.?(?:\s|$)", normalized):
                score -= 4
            if re.search(r"\bu\s+[a-z]\.[a-z]\.?(?:\s|$)", normalized):
                score -= 5

            score += min(len(candidate), 80) // 12
            candidates.append((score, len(candidate), candidate))

        if not candidates:
            return None

        candidates.sort(key=lambda item: (item[0], item[1]), reverse=True)
        return candidates[0][2]

    def _extract_primary_date(self, text: str) -> Optional[str]:
        header_window = text[:9000]
        explicit_patterns = [
            re.compile(
                r"dana\s+(\d{1,2})\.\s*(\d{1,2})\.\s*(\d{4})\.?\s*(?:g(?:odine)?\.?)?\s*,?\s*(?:je\s+)?(?:donio|donijela|doneo|objavio|javno\s+objavio)",
                re.IGNORECASE,
            ),
            re.compile(
                r"(?:donio|donijela|doneo|objavio)[^\n]{0,140}?(?:dana\s+)?(\d{1,2})\.\s*(\d{1,2})\.\s*(\d{4})\.?\s*(?:g(?:odine)?\.?)?",
                re.IGNORECASE,
            ),
            re.compile(
                r"(\d{1,2})\.\s*(\d{1,2})\.\s*(\d{4})\.?\s*(?:g(?:odine)?\.?)?\s*,?\s*(?:je\s+)?(?:donio|donijela|doneo|objavio|javno\s+objavio)",
                re.IGNORECASE,
            ),
        ]
        for pattern in explicit_patterns:
            match = pattern.search(header_window)
            if match:
                day, month, year = match.groups()
                return f"{year}-{month.zfill(2)}-{day.zfill(2)}"

        matches = list(self.date_pattern.finditer(text))
        if not matches:
            return None

        best_score = -10**9
        best_value: Optional[str] = None
        for match in matches:
            day, month, year = match.groups()
            index = match.start()
            context = text[max(0, index - 90):index + 110].lower()

            score = 0
            if "dana" in context:
                score += 2
            if any(token in context for token in ["donio", "objavio", "presudu", "javno objavio"]):
                score += 4
            if any(token in context for token in ["optužnic", "optuznic", "kt.br", "tužilaštv", "tuzilastv"]):
                score -= 4
            if any(token in context for token in ["rodjen", "rodjena", "rođen", "rođena", "jmbg", "od oca", "majke"]):
                score -= 6
            if any(
                token in context
                for token in [
                    "ranije osudjivan",
                    "osudjivan presudom",
                    "presudom osnovnog suda",
                    "presudom višeg suda",
                    "presudom viseg suda",
                    "uslovno",
                ]
            ):
                score -= 7
            if any(
                token in context
                for token in [
                    "izdat",
                    "oružni list",
                    "oruzni list",
                    "potvrd",
                    "obdukc",
                    "forenz",
                    "uvidj",
                    "dokumentacij",
                    "izvještaj",
                    "izvjestaj",
                    "nalaz",
                    "služben",
                    "sluzben",
                ]
            ):
                score -= 5

            year_num = int(year)
            if 1990 <= year_num <= 2035:
                score += 1

            if score > best_score:
                best_score = score
                best_value = f"{year}-{month.zfill(2)}-{day.zfill(2)}"

        return best_value

    def _extract_case_outcome(self, text: str) -> Optional[str]:
        normalized = self._normalize_for_matching(text)
        compact = normalized.replace(" ", "")

        if "oslobadaseodoptuzbe" in compact or "oslobađaseodoptužbe" in text.lower():
            return normalize_outcome("oslobodjen")
        if "oslobadase" in compact or "oslobađa se" in text.lower():
            return normalize_outcome("oslobodjen")
        if any(token in compact for token in ["zalbaseodbija", "odbijasezalba", "odbijasekaoneosnovanazalba"]):
            return normalize_outcome("odbijeno")
        if any(token in compact for token in ["presudasepotvrdjuje", "potvrdjujeseprvostepenapresuda", "potvrdjujepresuda"]):
            return normalize_outcome("odbijeno")
        if "odbijase" in compact:
            return normalize_outcome("odbijeno")
        if any(token in compact for token in ["zalbaseusvaja", "usvajasezalba", "preinacavasepresuda", "preinacujesepresuda"]):
            return normalize_outcome("usvojeno")
        if "ukidase" in compact or "ukinutapresuda" in compact:
            return normalize_outcome("ukinuto")
        if any(
            token in compact
            for token in [
                "krivje",
                "osudjuje",
                "oglasavasekrivim",
                "izricesekazna",
                "kaznuzatvora",
                "novcanukaznu",
                "neceizvrsitiukoliko",
                "uslovnaosuda",
            ]
        ) or "osuđuje" in text.lower():
            return normalize_outcome("osudjen")
        if "usvajase" in compact:
            return normalize_outcome("usvojeno")
        return None

    def _extract_victims(self, text: str) -> List[str]:
        victims: List[str] = []
        for marker in self.victim_marker_pattern.finditer(text):
            segment = text[marker.end():marker.end() + 120]
            for initials in self.initials_pattern.findall(segment):
                value = initials.replace(" ", "").strip().strip(",.;")
                if value and value not in victims:
                    victims.append(value)
            for name in self.person_name_pattern.findall(segment):
                candidate = name.strip().strip(",.;")
                if self._looks_like_person_name(candidate) and candidate not in victims:
                    victims.append(candidate)
        return victims

    def _extract_witnesses(self, text: str) -> List[str]:
        witnesses: List[str] = []
        for marker in self.witness_marker_pattern.finditer(text):
            segment = text[marker.end():marker.end() + 120]
            for initials in self.initials_pattern.findall(segment):
                value = initials.replace(" ", "").strip().strip(",.;")
                if value and value not in witnesses:
                    witnesses.append(value)
            for name in self.person_name_pattern.findall(segment):
                candidate = name.strip().strip(",.;")
                if self._looks_like_person_name(candidate) and candidate not in witnesses:
                    witnesses.append(candidate)
        return witnesses

    def _looks_like_person_name(self, value: str) -> bool:
        words = value.split()
        if len(words) < 2 or len(words) > 3:
            return False
        blocked = {
            "navedeno", "objasnio", "pokazao", "odgovorio", "dokaza", "postupka", "suda", "sudije",
            "oštećenog", "ostecenog", "okrivljenog", "odbrane", "nalaza", "misljenja", "doktor", "dr",
            "osnovni", "visi", "viši", "vrhovni", "apelacioni", "privredni",
        }
        first = words[0].lower().strip(".,")
        if first in blocked:
            return False
        return all(w[0].isupper() for w in words if w)

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
