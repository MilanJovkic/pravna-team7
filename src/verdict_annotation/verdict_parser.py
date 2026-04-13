"""Parser for structuring court verdict text."""
import re
import unicodedata
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
            metadata.case_number = case_match.group(1).strip()
        else:
            inline_match = self.case_number_inline_pattern.search(text)
            if inline_match:
                metadata.case_number = f"K.br. {inline_match.group(1).replace(' ', '')}"
        
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
        elif re.search(r"\branije\s+osudjivan\b|\bprethodno\s+osudjivan\b|\bvise\s+puta\s+osudjivan\b", normalized):
            self._add_fact(facts, "previous_convictions", "da")

        if re.search(r"\bpovratnik\b|\bspecijalni\s+povrat\b", normalized):
            self._add_fact(facts, "repeat_offender", "da")

        if re.search(r"\bpriznao\s+krivicu\b|\bpriznao\s+izvrsenje\b|\bpriznanje\s+krivice\b", normalized):
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
        lowered = text.lower().replace("\u00a0", " ")
        normalized = unicodedata.normalize("NFD", lowered)
        normalized = "".join(ch for ch in normalized if unicodedata.category(ch) != "Mn")
        normalized = re.sub(r"[^a-z0-9\s]", " ", normalized)
        return re.sub(r"\s+", " ", normalized).strip()

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
