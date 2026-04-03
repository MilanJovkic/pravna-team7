"""
Rule Reasoning Adapter - NOVI ADAPTER ZA DINAMIČKI RULEBASE
===========================================================

Zamenjuje hardkodovane prioritete i static rulebase sa dinamički generisanim.

PROMENA ARHITEKTURE:
┌─ STARI TOK ──────────────────────────────────┐
│ facts.rdf → rulebase.clp (hardkoded 34 rules)│
│          → export.rdf → hardkoded priorities │
└──────────────────────────────────────────────┘

┌─ NOVI TOK ───────────────────────────────────────────────────┐
│ facts.rdf → [RulebaseGenerator] → rulebase.clp (dinamički)   │
│                ↓ Generiše                                     │
│           prioriteti (nema hardkoda!)                        │
│           families (nema hardkoda!)                          │
│           CaseFacts requirements (nema hardkoda!)            │
│                ↓                                              │
│            export.rdf → SAMO LOGIKA, NEMA KABLA!            │
└──────────────────────────────────────────────────────────────┘
"""
from __future__ import annotations

from pathlib import Path
import json
from typing import Optional

from backend.app.domain.rulebase_generation.rulebase_generator import (
    RulebaseGenerator,
)
from backend.app.models.schemas import CaseFacts


class RulebaseAdaptationService:
    """
    Adapter koji integriše RulebaseGenerator sa rule_reasoning_service.py
    
    LOGIKA:
    - Pri startu sistema, generiše rulebase iz zakon.xml
    - Učitava dinamičke prioritete umesto hardkoda
    - Automatski sinhronizuje CaseFacts sa zahtevima zakona
    - Detektuje kad se zakon promeni i regeneriše
    """

    def __init__(
        self,
        law_xml_path: Path = None,
        cache_dir: Path = None,
        auto_regenerate: bool = True,
    ):
        """
        Args:
            law_xml_path: Putanja do annotated_law.xml. Ako None, koristi default
            cache_dir: Gde da spremi regenerisane fajlove (default: dr-device/dr-device)
            auto_regenerate: Da li da automatski regeneriše ako se zakon promeni
        """
        self.law_xml_path = law_xml_path or Path("output/annotated_law.xml")
        self.cache_dir = cache_dir or Path("dr-device/dr-device")
        self.auto_regenerate = auto_regenerate

        # Cache za generisane podatke
        self._cached_result = None
        self._law_file_mtime = None

        # Generiši na startu
        self.regenerate()

    def regenerate(self) -> dict:
        """
        Generiši rulebase, prioritete, families - SVE BEZ HARDKODA!
        
        Returns:
            Rulebase generation result sa svim potrebnim podacima
        """
        # Proveri da li je zakon fajl promenjen
        if self.auto_regenerate:
            current_mtime = self.law_xml_path.stat().st_mtime
            if (
                self._law_file_mtime is not None
                and current_mtime == self._law_file_mtime
                and self._cached_result is not None
            ):
                # Nema promena, vrati cache
                return self._cached_result

            self._law_file_mtime = current_mtime

        # Generiši sve
        generator = RulebaseGenerator(self.law_xml_path)
        result = generator.generate()

        # Spasmij generiše CLP fajl
        generator.save_rulebase(self.cache_dir / "rulebase.clp")

        # Spasmij prioritete kao JSON (za brže učitavanje)
        self._save_priorities(result["priorities"])

        # Spasmij family mapiranje
        self._save_families(result["families"])

        # Spasmij required facts za CaseFacts sinhronizaciju
        self._save_required_facts(result["required_facts"])

        # Cache rezultat
        self._cached_result = result

        return result

    def get_dynamic_priorities(self) -> dict[str, int]:
        """
        Učitaj prioritete iz generiše datoteke (umesto hardkoda!).
        
        ZA ZAMENU rule_reasoning_service.py linija 218-232
        """
        if self._cached_result is None:
            self.regenerate()

        return self._cached_result["priorities"]

    def get_dynamic_families(self) -> dict[str, set[str]]:
        """
Učitaj family mapiranje iz generiše datoteke (umesto hardkoda!)."""
        if self._cached_result is None:
            self.regenerate()

        return self._cached_result["families"]

    def get_required_facts(self) -> set[str]:
        """
        Učitaj fact-a koje sistem zahteva od korisnika.
        
        ZA SINHRONIZACIJU sa CaseFacts + Frontend forme
        """
        if self._cached_result is None:
            self.regenerate()

        return self._cached_result["required_facts"]

    def validate_case_facts(self, facts: CaseFacts) -> tuple[bool, list[str]]:
        """
        Validiraj CaseFacts prema zahtevima generiše zakona.
        
        Returns:
            (is_valid, list_of_missing_facts)
        """
        required = self.get_required_facts()
        facts_dict = facts.dict()

        missing = []
        for required_fact in required:
            if required_fact not in facts_dict or facts_dict[required_fact] is None:
                missing.append(required_fact)

        return len(missing) == 0, missing

    def _save_priorities(self, priorities: dict[str, int]) -> None:
        """Spasmij prioritete kao JSON za brže učitavanje."""
        priorities_file = self.cache_dir / "priorities.json"
        with open(priorities_file, "w") as f:
            json.dump(priorities, f, indent=2)

    def _save_families(self, families: dict[str, set[str]]) -> None:
        """Spasmij families kao JSON."""
        families_file = self.cache_dir / "families.json"
        # Konvertuj set u list za JSON
        families_serializable = {k: list(v) for k, v in families.items()}
        with open(families_file, "w") as f:
            json.dump(families_serializable, f, indent=2)

    def _save_required_facts(self, required_facts: set[str]) -> None:
        """Spasmij required facts kao JSON."""
        facts_file = self.cache_dir / "required_facts.json"
        with open(facts_file, "w") as f:
            json.dump(list(required_facts), f, indent=2)


class DynamicPriorityInferencer:
    """
    ZAMENA za hardkodovani priorities dict!
    
    Može se koristi direktno u rule_reasoning_service.py
    """

    def __init__(self, adapter: RulebaseAdaptationService):
        """Inicijalizuj sa RulebaseAdaptationService-om."""
        self.adapter = adapter
        self._priorities = None

    def get_priority(self, norm_id: str) -> int:
        """
        Dobii prioritet za normu - BEZ HARDKODA!
        
        ZA ZAMENU lookup-ovanja hardkodovanog dict-a
        """
        if self._priorities is None:
            self._priorities = self.adapter.get_dynamic_priorities()

        return self._priorities.get(norm_id, 50)  # Default ako nema

    def get_all_priorities(self) -> dict[str, int]:
        """Dobii sve prioritete."""
        if self._priorities is None:
            self._priorities = self.adapter.get_dynamic_priorities()

        return self._priorities

    def get_family(self, norm_id: str) -> Optional[str]:
        """Pronađi koja familija sadrži dati norm."""
        families = self.adapter.get_dynamic_families()

        for family_name, norms in families.items():
            if norm_id in norms:
                return family_name

        return None


# KAKO DA INTEGRIŠE U POSTOJEĆI KOD:

# FILE: backend/app/services/rule_reasoning_service.py

# OLD CODE lines 214-265:
# def _resolve_norm_conflicts(self, norms: list[str]) -> list[str]:
#     priorities = {
#         "crime_art147": 120,  # ← HARDKOD!!!
#         # ... 30 više hardkodovanih vrednosti
#     }
#     families = {
#         "homicide": {"crime_art143", ...},  # ← HARDKOD!!!
#     }

# NEW CODE:
# def _resolve_norm_conflicts(self, norms: list[str]) -> list[str]:
#     priorities = self.priority_inferencer.get_all_priorities()  # ← DINAMIČKI!
#     families = self.adapter.get_dynamic_families()  # ← DINAMIČKI!


def create_adapter_singleton() -> RulebaseAdaptationService:
    """
    Kreiraj singleton adapter koji se koristi kroz sistem.
    
    KORIŠĆENJE:
    adapter = create_adapter_singleton()
    priorities = adapter.get_dynamic_priorities()
    """
    # Ovo bi trebalo biti done u main initialization
    global _RULEBASE_ADAPTER

    if "_RULEBASE_ADAPTER" not in globals():
        _RULEBASE_ADAPTER = RulebaseAdaptationService(
            law_xml_path=Path("output/annotated_law.xml"),
            cache_dir=Path("dr-device/dr-device"),
            auto_regenerate=True,
        )

    return _RULEBASE_ADAPTER


if __name__ == "__main__":
    # TEST
    adapter = RulebaseAdaptationService()

    print("=" * 70)
    print("RULE REASONING ADAPTER - TEST")
    print("=" * 70)

    # Generiše rulebase bez hardkoda
    result = adapter.regenerate()

    print(f"\n✓ Prioriteti (dinamički): {len(result['priorities'])} normi")
    print(f"✓ Families (dinamički): {list(result['families'].keys())}")
    print(f"✓ Required facts: {result['required_facts']}")

    # Test get_dynamic_priorities
    priorities = adapter.get_dynamic_priorities()
    print(f"\nPrimeri prioriteta (NO HARDCODE!):")
    for norm, priority in list(priorities.items())[:5]:
        print(f"  {norm}: {priority}")

    print("\n✓ ADAPTER RADI! Zameni priorities dict sa ovim!")
