"""Canonical normalization of rule-engine fact values.

This module centralizes allowed vocabulary for rule facts so CLP rules
receive stable, predictable values regardless of UI/input variants.
"""
from __future__ import annotations

from typing import Iterable

from backend.app.services.cbr_normalization import normalize_text


def _tokenize(value: str | None) -> str | None:
    text = normalize_text(value)
    if not text:
        return None
    text = text.replace("-", " ").replace("/", " ")
    return " ".join(text.split())


def _compact(value: str | None) -> str | None:
    text = _tokenize(value)
    if not text:
        return None
    return text.replace(" ", "_")


# Canonical values are on the right side. All aliases are normalized by _compact.
FIELD_CANONICAL_ALIASES: dict[str, dict[str, set[str]]] = {
    "life_consequence_type": {
        "smrt_nastupila": {"smrt_nastupila", "smrt", "nastupila_smrt", "smrtni_ishod"},
    },
    "guilt_form": {
        "umisljaj_direktni": {"umisljaj_direktni", "direktni_umisljaj", "direktan_umisljaj"},
        "umisljaj_eventualni": {"umisljaj_eventualni", "eventualni_umisljaj"},
        "nehat": {"nehat", "iz_nehata"},
    },
    "execution_manner": {
        "svirep": {"svirep", "svirepo", "svirep_nacin"},
        "podmukao": {"podmukao", "podmuklo", "podmukao_nacin"},
        "bezobzirno_nasilnicko_ponasanje": {
            "bezobzirno_nasilnicko_ponasanje",
            "bezobzirno_nasilnicki",
            "nasilnicko_ponasanje",
            "bezobzirno_nasilje",
        },
        "na_mah": {"na_mah", "afekat", "u_afektu"},
    },
    "offender_psych_state": {
        "jaka_razdrazenost_na_mah": {
            "jaka_razdrazenost_na_mah",
            "jaka_razdrazenost",
            "afekt",
        },
        "porodjajni_poremecaj": {"porodjajni_poremecaj", "poremecaj_izazvan_porodjajem"},
    },
    "victim_explicit_request": {
        "da": {"da", "yes", "true"},
        "ne": {"ne", "no", "false"},
    },
    "victim_health_state": {
        "tesko_zdravstveno_stanje": {
            "tesko_zdravstveno_stanje",
            "tesko_stanje",
            "tesko_oboljenje",
            "uredno_zdravlje",
        },
    },
    "victim_status": {
        "dijete": {"dijete", "dete"},
        "bremenita_zena": {"bremenita_zena", "trudnica", "trudna_zena"},
        "sluzbeno_lice": {"sluzbeno_lice"},
        "vojno_lice": {"vojno_lice"},
        "clan_porodice": {"clan_porodice", "clan_porodicne_zajednice"},
        "punoljetno_lice": {"punoljetno_lice", "punoljetna_osoba", "odrasla_osoba"},
        "maloljetnik": {"maloljetnik", "maloletnik"},
        "maloljetna_trudnica": {"maloljetna_trudnica", "maloletna_trudnica"},
        "nemocno_lice": {"nemocno_lice", "nemoćno_lice", "nemocna_osoba"},
    },
    "victim_accountability": {
        "bitno_smanjena_uracunljivost": {
            "bitno_smanjena_uracunljivost",
            "smanjena_uracunljivost",
            "bitno_smanjena",
        },
        "uracunljiva": {"uracunljiva"},
        "neuracunljivo": {"neuracunljivo", "ne_uracunljivo", "neuracunljiva"},
    },
    "suicide_outcome": {
        "izvrseno": {"izvrseno", "izvrsio", "izvrsena"},
        "pokusano": {"pokusano", "pokusaj"},
    },
    "special_action_types": {
        "navodjenje_na_samoubistvo": {"navodjenje_na_samoubistvo"},
        "pomaganje_u_samoubistvu": {"pomaganje_u_samoubistvu"},
        "nelegalni_pobacaj": {"nelegalni_pobacaj", "nedozvoljen_prekid_trudnoce", "pobacaj"},
        "sakacenje_zenskih_genitalija": {"sakacenje_zenskih_genitalija"},
        "prisilna_sterilizacija": {"prisilna_sterilizacija", "prinudna_sterilizacija"},
    },
    "offender_motive": {
        "koristoljublje": {"koristoljublje"},
        "izvrsenje_ili_prikrivanje_drugog_krivicnog_djela": {
            "izvrsenje_ili_prikrivanje_drugog_krivicnog_djela",
            "prikrivanje_drugog_djela",
            "prikrivanje_drugog_kd",
            "izvrsenje_drugog_kd",
        },
        "bezobzirna_osveta": {"bezobzirna_osveta", "osveta"},
        "niske_pobude": {"niske_pobude", "niske_motive"},
        "samilost": {"samilost"},
    },
    "duty_connection": {
        "u_vrsenju_sluzbene_duznosti": {"u_vrsenju_sluzbene_duznosti", "u_vezi_sa_vrsenjem_sluzbene_duznosti"},
    },
    "abortion_outcomes": {
        "pobacaj_izvrsen": {"pobacaj_izvrsen", "izvrsen_pobacaj"},
        "smrt": {"smrt", "smrt_zene"},
        "tesko_narusavanje_zdravlja": {
            "tesko_narusavanje_zdravlja",
            "teska_povreda_ili_narusenje_zdravlja",
        },
        "teska_tjelesna_povreda": {"teska_tjelesna_povreda", "teska_povreda_zene"},
    },
    "injury_type": {
        "teska tjelesna povreda": {
            "teska_tjelesna_povreda",
            "teska_povreda",
            "teska_telesna_povreda",
        },
        "laka tjelesna povreda": {
            "laka_tjelesna_povreda",
            "laka_povreda",
            "laka_telesna_povreda",
        },
    },
    "injury_means_type": {
        "opasno_orudje": {"opasno_orudje", "oruzje", "opasno_sredstvo"},
        "sredstvo_podobno_za_tesku_povredu": {
            "sredstvo_podobno_za_tesku_povredu",
            "drugo_podobno_sredstvo",
        },
    },
    "injury_severity_level": {
        "laka": {"laka", "laksa"},
        "teska": {"teska"},
    },
    "sterilization_goal": {
        "onemogucavanje_reprodukcije": {"onemogucavanje_reprodukcije", "sprecavanje_reprodukcije"},
    },
    "victim_consent": {
        "pristanak": {"pristanak", "sa_pristankom", "uz_pristanak", "saglasnost"},
        "bez_pristanka": {"bez_pristanka", "nema_pristanka", "bez_saglasnosti"},
    },
    "guardian_consent": {
        "da": {"da", "yes", "true", "saglasnost"},
        "ne": {"ne", "no", "false", "bez_saglasnosti"},
    },
    "abortion_action_mode": {
        "izvrsi_pobacaj": {"izvrsi_pobacaj", "izvrsava_pobacaj", "izvrsenje_pobacaja"},
        "pomogne_izvrsenje_pobacaja": {
            "pomogne_izvrsenje_pobacaja",
            "pomaganje_izvrsenju_pobacaja",
            "pomogne_da_izvrsi_pobacaj",
        },
    },
    "offender_victim_relationship": {
        "povjereno_nemocno_lice": {"povjereno_nemocno_lice"},
        "duznost_staranja": {"duznost_staranja"},
        "prolaznik": {"prolaznik"},
    },
    "help_provision_ability": {
        "mogao_bez_opasnosti": {"mogao_bez_opasnosti", "mogao_je_bez_opasnosti"},
    },
    "failure_to_help_consequence": {
        "tesko_narusavanje_zdravlja": {
            "tesko_narusavanje_zdravlja",
            "teska_povreda_ili_narusenje_zdravlja",
        },
        "teska_tjelesna_povreda": {"teska_tjelesna_povreda", "teska_povreda"},
        "smrt": {"smrt"},
    },
    "severe_injury_specific_consequences": {
        "opasnost_po_zivot": {"opasnost_po_zivot", "doveden_u_opasnost_zivota"},
        "unistenje_dijela_tijela": {"unistenje_dijela_tijela"},
        "trajno_ostecenje_organa": {"trajno_ostecenje_organa"},
        "trajna_nesposobnost_za_rad": {"trajna_nesposobnost_za_rad"},
        "trajno_naruseno_zdravlje": {"trajno_naruseno_zdravlje"},
        "unakazenost": {"unakazenost"},
    },
}


def _alias_to_canonical(field_name: str, compact_value: str) -> str | None:
    field_map = FIELD_CANONICAL_ALIASES.get(field_name)
    if not field_map:
        return None
    for canonical, aliases in field_map.items():
        if compact_value == _compact(canonical) or compact_value in aliases:
            return canonical
    return None


def normalize_rule_fact_value(field_name: str, value: str | None) -> str | None:
    """Normalize a single fact value to canonical vocabulary for CLP rules."""
    tokenized = _tokenize(value)
    if not tokenized:
        return None

    compact = tokenized.replace(" ", "_")
    mapped = _alias_to_canonical(field_name, compact)
    if mapped is not None:
        return mapped

    # Fallback keeps a deterministic normalized representation.
    if field_name in {"injury_type"}:
        return tokenized
    return compact


def normalize_rule_fact_list(field_name: str, values: Iterable[str] | None) -> list[str]:
    if not values:
        return []
    normalized: list[str] = []
    seen: set[str] = set()
    for value in values:
        item = normalize_rule_fact_value(field_name, value)
        if not item or item in seen:
            continue
        seen.add(item)
        normalized.append(item)
    return normalized
