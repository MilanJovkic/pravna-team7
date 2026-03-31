import re
import unittest
from pathlib import Path


def _load_clp_rules() -> list[tuple[str, list[tuple[str, str]], str]]:
    path = Path(__file__).resolve().parents[2] / "dr-device" / "dr-device" / "rulebase.clp"
    text = path.read_text(encoding="utf-8")

    rule_pattern = re.compile(
        r"\(defeasiblerule\s+(rule\d+)\s*(.*?)\n\)\s*(?=\n\(defeasiblerule|\Z)",
        re.S,
    )
    cond_pattern = re.compile(
        r"\(lc:case\s*\(\s*lc:defendant\s+\?Defendant\)\s*\(\s*lc:([a-zA-Z0-9_]+)\s+\"([^\"]+)\"\)\s*\)",
        re.S,
    )
    then_pattern = re.compile(r"=>\s*\((crime_art[0-9a-zA-Z_]+)")

    parsed: list[tuple[str, list[tuple[str, str]], str]] = []
    for rule_id, body in rule_pattern.findall(text):
        conditions = cond_pattern.findall(body)
        then_match = then_pattern.search(body)
        if not then_match:
            continue
        parsed.append((rule_id, conditions, then_match.group(1)))
    return parsed


def _evaluate_norms(facts: dict[str, list[str]]) -> set[str]:
    matched: set[str] = set()
    for _, conditions, norm in _load_clp_rules():
        ok = True
        for attr, expected in conditions:
            values = facts.get(attr, [])
            if expected not in values:
                ok = False
                break
        if ok:
            matched.add(norm)
    return matched


class TestAttributeNormCoverageMatrix(unittest.TestCase):
    """Matrix test: each newly introduced attribute has positive and negative coverage."""

    def test_attribute_norm_matrix(self) -> None:
        matrix = [
            {
                "attribute": "life_consequence_type",
                "expected_norm": "crime_art143",
                "positive": {"life_consequence_type": ["smrt_nastupila"], "guilt_form": ["umisljaj_direktni"]},
                "negative": {"life_consequence_type": ["tjelesna_povreda"], "guilt_form": ["umisljaj_direktni"]},
            },
            {
                "attribute": "guilt_form",
                "expected_norm": "crime_art148",
                "positive": {"life_consequence_type": ["smrt_nastupila"], "guilt_form": ["nehat"]},
                "negative": {"life_consequence_type": ["smrt_nastupila"], "guilt_form": ["umisljaj_direktni"]},
            },
            {
                "attribute": "victim_status",
                "expected_norm": "crime_art144",
                "positive": {"life_consequence_type": ["smrt_nastupila"], "victim_status": ["dijete"]},
                "negative": {"life_consequence_type": ["smrt_nastupila"], "victim_status": ["punoljetno_lice"]},
            },
            {
                "attribute": "danger_to_third_parties",
                "expected_norm": "crime_art144",
                "positive": {"life_consequence_type": ["smrt_nastupila"], "danger_to_third_parties": ["true"]},
                "negative": {"life_consequence_type": ["smrt_nastupila"], "danger_to_third_parties": ["false"]},
            },
            {
                "attribute": "victim_count",
                "expected_norm": "crime_art144",
                "positive": {"life_consequence_type": ["smrt_nastupila"], "victim_count": ["vise"]},
                "negative": {"life_consequence_type": ["smrt_nastupila"], "victim_count": ["jedna"]},
            },
            {
                "attribute": "execution_manner",
                "expected_norm": "crime_art145",
                "positive": {"life_consequence_type": ["smrt_nastupila"], "execution_manner": ["na_mah"]},
                "negative": {"life_consequence_type": ["smrt_nastupila"], "execution_manner": ["podmukao_nacin"]},
            },
            {
                "attribute": "offender_psych_state",
                "expected_norm": "crime_art146",
                "positive": {"life_consequence_type": ["smrt_nastupila"], "offender_psych_state": ["porodjajni_poremecaj"]},
                "negative": {"life_consequence_type": ["smrt_nastupila"], "offender_psych_state": ["normalno_stanje"]},
            },
            {
                "attribute": "victim_explicit_request",
                "expected_norm": "crime_art147",
                "positive": {"life_consequence_type": ["smrt_nastupila"], "victim_explicit_request": ["da"]},
                "negative": {"life_consequence_type": ["smrt_nastupila"], "victim_explicit_request": ["ne"]},
            },
            {
                "attribute": "suicide_outcome",
                "expected_norm": "crime_art149_1",
                "positive": {
                    "suicide_outcome": ["izvrseno"],
                    "special_action_types": ["navodjenje_na_samoubistvo"],
                },
                "negative": {
                    "suicide_outcome": ["nije_primjenljivo"],
                    "special_action_types": ["navodjenje_na_samoubistvo"],
                },
            },
            {
                "attribute": "special_action_types",
                "expected_norm": "crime_art151a",
                "positive": {"special_action_types": ["sakacenje_zenskih_genitalija"]},
                "negative": {"special_action_types": ["prisilna_sterilizacija"]},
            },
            {
                "attribute": "inhuman_treatment",
                "expected_norm": "crime_art149_5",
                "positive": {"suicide_outcome": ["pokusano"], "inhuman_treatment": ["true"]},
                "negative": {"suicide_outcome": ["pokusano"], "inhuman_treatment": ["false"]},
            },
            {
                "attribute": "sterilization_goal",
                "expected_norm": "crime_art151b",
                "positive": {"sterilization_goal": ["onemogucavanje_reprodukcije"]},
                "negative": {"sterilization_goal": ["nije_primjenljivo"]},
            },
            {
                "attribute": "offender_victim_relationship",
                "expected_norm": "crime_art156",
                "positive": {"left_without_help": ["true"], "offender_victim_relationship": ["duznost_staranja"]},
                "negative": {"left_without_help": ["true"], "offender_victim_relationship": ["prolaznik"]},
            },
            {
                "attribute": "help_provision_ability",
                "expected_norm": "crime_art157",
                "positive": {
                    "left_without_help": ["true"],
                    "offender_victim_relationship": ["prolaznik"],
                    "help_provision_ability": ["mogao_bez_opasnosti"],
                },
                "negative": {
                    "left_without_help": ["true"],
                    "offender_victim_relationship": ["prolaznik"],
                    "help_provision_ability": ["nije_mogao"],
                },
            },
            {
                "attribute": "abortion_outcomes",
                "expected_norm": "crime_art150",
                "positive": {"abortion_outcomes": ["pobacaj_izvrsen"]},
                "negative": {"abortion_outcomes": ["teska_povreda_zene"]},
            },
            {
                "attribute": "injury_means_type",
                "expected_norm": "crime_art152_2",
                "positive": {"injury_means_type": ["opasno_orudje"], "injury_severity_level": ["laka"]},
                "negative": {"injury_means_type": ["ostalo"], "injury_severity_level": ["laka"]},
            },
            {
                "attribute": "injury_severity_level",
                "expected_norm": "crime_art152_2",
                "positive": {"injury_means_type": ["opasno_orudje"], "injury_severity_level": ["laka"]},
                "negative": {"injury_means_type": ["opasno_orudje"], "injury_severity_level": ["teska"]},
            },
            {
                "attribute": "danger_caused_by_offender",
                "expected_norm": "crime_art155_1",
                "positive": {"danger_caused_by_offender": ["true"], "left_without_help": ["true"]},
                "negative": {"danger_caused_by_offender": ["false"], "left_without_help": ["true"]},
            },
        ]

        for row in matrix:
            with self.subTest(attribute=row["attribute"], kind="positive"):
                norms = _evaluate_norms(row["positive"])
                self.assertIn(row["expected_norm"], norms)
            with self.subTest(attribute=row["attribute"], kind="negative"):
                norms = _evaluate_norms(row["negative"])
                self.assertNotIn(row["expected_norm"], norms)


if __name__ == "__main__":
    unittest.main()
