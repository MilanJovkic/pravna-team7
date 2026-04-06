"""Dynamic rulebase generation aligned with ReasoningService facts schema."""
from __future__ import annotations

import re
import xml.etree.ElementTree as ET
from dataclasses import dataclass, field
from pathlib import Path
from typing import Optional


@dataclass
class ArticleMetadata:
    article_number: str
    paragraph_number: Optional[str] = None
    title: str = ""
    sanction: Optional[str] = None
    concepts: list[str] = field(default_factory=list)
    triggers: list[str] = field(default_factory=list)
    severity_level: int = 50
    hierarchy_level: int = 0


@dataclass
class DefeasibleRule:
    rule_id: str
    norm_id: str
    conditions: list[tuple[str, str]]
    consequence: str
    priority: int = 100


class AkomaNtosoParser:
    def __init__(self, xml_path: str | Path):
        self.xml_path = Path(xml_path)
        self.tree = None
        self.root = None
        self._parse()

    def _parse(self) -> None:
        self.tree = ET.parse(self.xml_path)
        self.root = self.tree.getroot()

    def extract_articles(self) -> list[ArticleMetadata]:
        articles: list[ArticleMetadata] = []
        ns: dict[str, str] = {}
        if self.root.tag.startswith("{"):
            ns_url = self.root.tag.split("}")[0][1:]
            ns = {"": ns_url, "akn": ns_url}

        article_elems = self.root.findall(".//article", ns)
        if not article_elems and ns:
            article_elems = self.root.findall(".//article")

        for article_elem in article_elems:
            article_id = (article_elem.get("eId") or "").replace("art_", "")
            if not article_id:
                continue
            article_num = article_id.split("__")[0]

            mod_elem = article_elem.find(".//mod", ns) if ns else article_elem.find(".//mod")
            if mod_elem is None and ns:
                mod_elem = article_elem.find(".//mod")
            sanction = (mod_elem.text or "").strip() if mod_elem is not None and mod_elem.text else None

            concepts = (
                article_elem.get("data-concepts", "").split(",")
                if article_elem.get("data-concepts")
                else []
            )
            concepts = [item.strip() for item in concepts if item.strip()]

            heading_elem = article_elem.find(".//heading", ns) if ns else article_elem.find(".//heading")
            if heading_elem is None and ns:
                heading_elem = article_elem.find(".//heading")
            title = heading_elem.text.strip() if heading_elem is not None and heading_elem.text else ""

            para_elems = article_elem.findall(".//paragraph", ns) if ns else article_elem.findall(".//paragraph")
            if not para_elems and ns:
                para_elems = article_elem.findall(".//paragraph")

            if not para_elems:
                metadata = ArticleMetadata(
                    article_number=article_num,
                    paragraph_number=None,
                    title=title,
                    sanction=sanction,
                    concepts=concepts,
                )
                metadata.severity_level = self._infer_severity(article_num, sanction)
                articles.append(metadata)
                continue

            for para_elem in para_elems:
                para_id = para_elem.get("eId", "")
                para_num = self._extract_paragraph_number(para_id)
                metadata = ArticleMetadata(
                    article_number=article_num,
                    paragraph_number=para_num,
                    title=title,
                    sanction=sanction,
                    concepts=concepts,
                )
                metadata.severity_level = self._infer_severity(article_num, sanction, para_num)
                articles.append(metadata)

        return articles

    def _extract_paragraph_number(self, para_id: str) -> Optional[str]:
        match = re.search(r"para_(\d+)", para_id or "")
        return match.group(1) if match else None

    def _infer_severity(
        self,
        article_num: str,
        sanction: Optional[str],
        paragraph_num: Optional[str] = None,
    ) -> int:
        severity = 50
        match = re.match(r"(\d+)", article_num)
        if match:
            article_int = int(match.group(1))
            if 143 <= article_int <= 148:
                severity = 88 - (article_int - 143) * 3
            elif article_int == 151:
                severity = 80
            elif article_int == 152:
                severity = 70
            elif article_int in (155, 156, 157):
                severity = 62
            else:
                severity = 55

        if paragraph_num and paragraph_num.isdigit():
            severity += int(paragraph_num)

        if sanction:
            years = [int(item) for item in re.findall(r"\d+", sanction)]
            if years:
                max_years = max(years)
                if max_years >= 12:
                    severity += 10
                elif max_years >= 8:
                    severity += 6

        return max(0, min(100, severity))


class LawStructureAnalyzer:
    def analyze(self, articles: list[ArticleMetadata]) -> list[ArticleMetadata]:
        return articles


class RulebaseCodeGenerator:
    """Generates CLP rules aligned with frontend/backend fact slots."""

    # Canonical template aligned with ReasoningService facts payload.
    COMPATIBILITY_TEMPLATES: list[tuple[str, list[tuple[str, str]]]] = [
        ("crime_art151_1", [("injury_type", "teska tjelesna povreda")]),
        ("crime_art151_2", [("injury_type", "teska tjelesna povreda"), ("weapon_used", "true")]),
        ("crime_art151_3", [("injury_type", "teska tjelesna povreda"), ("severe_consequence", "true")]),
        ("crime_art151_4", [("injury_type", "teska tjelesna povreda"), ("death_result", "true")]),
        ("crime_art151_5", [("injury_type", "teska tjelesna povreda"), ("negligence", "true")]),
        ("crime_art152_1", [("injury_type", "laka tjelesna povreda")]),
        ("crime_art152_2", [("injury_type", "laka tjelesna povreda"), ("weapon_used", "true")]),
        ("crime_art153", [("injury_type", "teska tjelesna povreda"), ("provocation", "true")]),
        ("crime_art154", [("fight_participation", "true")]),
        ("crime_art155_1", [("left_without_help", "true"), ("injury_type", "teska tjelesna povreda")]),
        ("crime_art143", [("life_consequence_type", "smrt_nastupila"), ("guilt_form", "umisljaj_direktni")]),
        ("crime_art143", [("life_consequence_type", "smrt_nastupila"), ("guilt_form", "umisljaj_eventualni")]),
        ("crime_art144_1", [("life_consequence_type", "smrt_nastupila"), ("victim_status", "dijete")]),
        ("crime_art144_1", [("life_consequence_type", "smrt_nastupila"), ("victim_status", "bremenita_zena")]),
        ("crime_art144_1", [("life_consequence_type", "smrt_nastupila"), ("danger_to_third_parties", "true")]),
        ("crime_art144_1", [("life_consequence_type", "smrt_nastupila"), ("victim_count", "vise")]),
        ("crime_art145", [("life_consequence_type", "smrt_nastupila"), ("execution_manner", "na_mah")]),
        ("crime_art145", [("life_consequence_type", "smrt_nastupila"), ("offender_psych_state", "jaka_razdrazenost_na_mah")]),
        ("crime_art146", [("life_consequence_type", "smrt_nastupila"), ("offender_psych_state", "porodjajni_poremecaj")]),
        ("crime_art147", [("life_consequence_type", "smrt_nastupila"), ("victim_explicit_request", "da")]),
        ("crime_art148", [("life_consequence_type", "smrt_nastupila"), ("guilt_form", "nehat")]),
        ("crime_art149_1", [("suicide_outcome", "izvrseno"), ("special_action_types", "navodjenje_na_samoubistvo")]),
        ("crime_art149_2", [("suicide_outcome", "izvrseno"), ("special_action_types", "pomaganje_u_samoubistvu")]),
        ("crime_art149_5", [("suicide_outcome", "pokusano"), ("inhuman_treatment", "true")]),
        ("crime_art150", [("special_action_types", "nelegalni_pobacaj")]),
        ("crime_art151a", [("special_action_types", "sakacenje_zenskih_genitalija")]),
        ("crime_art151b", [("special_action_types", "prisilna_sterilizacija")]),
        ("crime_art151b", [("sterilization_goal", "onemogucavanje_reprodukcije")]),
        ("crime_art156", [("left_without_help", "true"), ("offender_victim_relationship", "povjereno_nemocno_lice")]),
        ("crime_art156", [("left_without_help", "true"), ("offender_victim_relationship", "duznost_staranja")]),
        ("crime_art157", [("left_without_help", "true"), ("offender_victim_relationship", "prolaznik"), ("help_provision_ability", "mogao_bez_opasnosti")]),
        ("crime_art150", [("abortion_outcomes", "pobacaj_izvrsen")]),
        ("crime_art152_2", [("injury_means_type", "opasno_orudje"), ("injury_severity_level", "laka")]),
        ("crime_art155_1", [("danger_caused_by_offender", "true"), ("left_without_help", "true")]),
    ]

    def generate_rules(self, articles: list[ArticleMetadata]) -> list[DefeasibleRule]:
        article_to_paras: dict[str, set[str]] = {}
        for article in articles:
            article_to_paras.setdefault(article.article_number, set())
            if article.paragraph_number:
                article_to_paras[article.article_number].add(article.paragraph_number)

        rules: list[DefeasibleRule] = []
        for index, (norm_id, conditions) in enumerate(self.COMPATIBILITY_TEMPLATES, start=1):
            if not self._norm_exists_in_law(norm_id, article_to_paras):
                continue
            rules.append(
                DefeasibleRule(
                    rule_id=f"rule{len(rules) + 1}",
                    norm_id=norm_id,
                    conditions=conditions,
                    consequence=norm_id,
                    priority=100,
                )
            )

        # Fallback for non-criminal law swaps: generate broad article-level rules.
        if not rules:
            seen_norms: set[str] = set()
            for article in articles:
                norm_id = f"crime_art{article.article_number}"
                if norm_id in seen_norms:
                    continue
                seen_norms.add(norm_id)
                rules.append(
                    DefeasibleRule(
                        rule_id=f"rule{len(rules) + 1}",
                        norm_id=norm_id,
                        conditions=[("defendant", "?Defendant")],
                        consequence=norm_id,
                        priority=50,
                    )
                )

        return rules

    def _norm_exists_in_law(self, norm_id: str, article_to_paras: dict[str, set[str]]) -> bool:
        match = re.match(r"crime_art(\d+[a-z]?)(?:_(\d+))?$", norm_id)
        if not match:
            return False
        article = match.group(1)
        paragraph = match.group(2)
        if article not in article_to_paras:
            return False
        if paragraph:
            paras = article_to_paras.get(article, set())
            return not paras or paragraph in paras
        return True

    def generate_clp_code(self, rules: list[DefeasibleRule]) -> str:
        lines: list[str] = []
        lines.append('(import-rdf "facts.rdf")')
        export_norms: list[str] = []
        for rule in rules:
            if rule.norm_id not in export_norms:
                export_norms.append(rule.norm_id)
        lines.append("\t\t(export-rdf export.rdf  " + " ".join(export_norms) + ")")
        lines.append("\t\t(export-proof proof.ruleml)")
        lines.append("")

        for rule in rules:
            lines.append(self._rule_to_clp(rule))
            lines.append("")
        return "\n".join(lines).rstrip() + "\n"

    def _rule_to_clp(self, rule: DefeasibleRule) -> str:
        blocks: list[str] = []
        for field_name, field_value in rule.conditions:
            if field_name == "defendant" and field_value == "?Defendant":
                block = """\t(lc:case
		(
		 lc:defendant ?Defendant)
	)"""
            else:
                block = (
                    "\t(lc:case\n"
                    "\t\t(\n"
                    "\t\t lc:defendant ?Defendant)\n"
                    "\t\t(\n"
                    f"\t\t lc:{field_name} \"{field_value}\")\n"
                    "\t)"
                )
            blocks.append(block)

        conditions_text = "\n".join(blocks)
        return (
            f"(defeasiblerule {rule.rule_id}\n"
            f"{conditions_text}\n"
            "  =>\n"
            f"\t({rule.consequence}\n"
            "\t\t(\n"
            "\t\t defendant ?Defendant)\n"
            "\t)\n"
            ")"
        )


class PriorityInferencer:
    def infer_priorities(
        self,
        rules: list[DefeasibleRule],
        articles: list[ArticleMetadata],
    ) -> dict[str, int]:
        article_scores: dict[str, int] = {}
        para_scores: dict[str, int] = {}
        for article in articles:
            article_scores[article.article_number] = max(
                article_scores.get(article.article_number, 0),
                article.severity_level,
            )
            if article.paragraph_number:
                para_key = f"{article.article_number}_{article.paragraph_number}"
                para_scores[para_key] = max(para_scores.get(para_key, 0), article.severity_level)

        priorities: dict[str, int] = {}
        for rule in rules:
            match = re.match(r"crime_art(\d+[a-z]?)(?:_(\d+))?$", rule.norm_id)
            score = 50
            if match:
                article = match.group(1)
                paragraph = match.group(2)
                if paragraph and f"{article}_{paragraph}" in para_scores:
                    score = para_scores[f"{article}_{paragraph}"]
                else:
                    score = article_scores.get(article, score)
            priorities[rule.norm_id] = score

        if not priorities:
            return priorities

        max_priority = max(priorities.values())
        min_priority = min(priorities.values())
        if max_priority == min_priority:
            return {norm_id: 85 for norm_id in priorities}

        normalized: dict[str, int] = {}
        for norm_id, score in priorities.items():
            value = 50 + (score - min_priority) * 70 / (max_priority - min_priority)
            normalized[norm_id] = int(value)
        return normalized

    def infer_families(
        self,
        rules: list[DefeasibleRule],
        articles: list[ArticleMetadata],
    ) -> dict[str, set[str]]:
        article_concepts: dict[str, set[str]] = {}
        for article in articles:
            article_concepts.setdefault(article.article_number, set()).update(article.concepts)

        families: dict[str, set[str]] = {}
        for rule in rules:
            match = re.match(r"crime_art(\d+[a-z]?)(?:_(\d+))?$", rule.norm_id)
            if not match:
                families.setdefault("uncategorized", set()).add(rule.norm_id)
                continue
            article = match.group(1)
            concepts = article_concepts.get(article) or {"uncategorized"}
            for concept in concepts:
                families.setdefault(concept, set()).add(rule.norm_id)
        return families


class CaseFactsSyncronizer:
    def extract_required_facts(self, rules: list[DefeasibleRule]) -> set[str]:
        required_facts: set[str] = set()
        for rule in rules:
            for field_name, _ in rule.conditions:
                if field_name in {"defendant"}:
                    continue
                required_facts.add(field_name)
        return required_facts


class RulebaseGenerator:
    def __init__(self, law_xml_path: str | Path):
        self.law_xml_path = Path(law_xml_path)
        self.parser = None
        self.analyzer = None
        self.rule_generator = None
        self.priority_inferencer = None
        self.facts_sync = None

    def generate(self) -> dict:
        self.parser = AkomaNtosoParser(self.law_xml_path)
        articles = self.parser.extract_articles()

        self.analyzer = LawStructureAnalyzer()
        articles = self.analyzer.analyze(articles)

        self.rule_generator = RulebaseCodeGenerator()
        rules = self.rule_generator.generate_rules(articles)
        clp_code = self.rule_generator.generate_clp_code(rules)

        self.priority_inferencer = PriorityInferencer()
        priorities = self.priority_inferencer.infer_priorities(rules, articles)
        families = self.priority_inferencer.infer_families(rules, articles)

        self.facts_sync = CaseFactsSyncronizer()
        required_facts = self.facts_sync.extract_required_facts(rules)

        return {
            "rulebase_clp": clp_code,
            "rules": rules,
            "priorities": priorities,
            "families": families,
            "required_facts": required_facts,
            "articles": articles,
        }

    def save_rulebase(self, output_path: str | Path) -> None:
        result = self.generate()
        Path(output_path).write_text(result["rulebase_clp"], encoding="utf-8")

