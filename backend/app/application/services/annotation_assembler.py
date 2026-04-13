"""Builds verdict metadata and structured annotations from facts and reasoning."""

from __future__ import annotations

from backend.app.domain.verdict.annotation import VerdictAnnotation
from backend.app.domain.verdict.entities import VerdictMetadata
from backend.app.models.schemas import CaseFacts, ReasoningResponse
from backend.app.domain.shared.outcome_normalization import normalize_outcome


class AnnotationAssembler:
    """Single-responsibility component for metadata and annotation assembly."""

    def build_metadata(
        self,
        case_number: str,
        court_name: str,
        date_value: str,
        judges: list[str],
        facts: CaseFacts,
        reasoning: ReasoningResponse,
        verdict_text: str,
    ) -> VerdictMetadata:
        resolved_articles = self._resolve_applied_articles(facts, reasoning)
        applied_articles = [f"Clan {art}" for art in resolved_articles]
        legal_refs = []
        if applied_articles:
            legal_refs.append("Krivicni zakonik Crne Gore")

        parties = {}
        if facts.defendant:
            parties["defendant"] = [facts.defendant]

        return VerdictMetadata(
            case_number=case_number,
            court_name=court_name,
            date=date_value,
            judges=judges,
            parties=parties,
            organizations=[],
            legal_references=legal_refs,
            article_references=applied_articles,
            factual_state=self._facts_to_factual_state(facts),
            raw_text=verdict_text,
        )

    def build_structured_annotation(
        self,
        metadata: VerdictMetadata,
        reasoning: ReasoningResponse,
    ) -> VerdictAnnotation:
        injury = None
        if metadata.factual_state.get("injury_type"):
            injury = metadata.factual_state["injury_type"][0]
        legal_issues = [injury] if injury else ["krivicno delo"]
        legal_concepts = [injury] if injury else ["krivicno delo"]

        normalized_verdict = normalize_outcome(reasoning.suggested_verdict)
        if normalized_verdict == "odbijeno":
            outcome = "odbijeno"
            decision = "Optužba se odbija usled nedostatka dovoljno pouzdanih elemenata za osudu."
        elif normalized_verdict == "oslobodjen":
            outcome = "oslobodjen"
            decision = "Okrivljeni se oslobađa od optužbe."
        elif normalized_verdict == "usvojeno":
            outcome = "usvojeno"
            decision = "Predlog se usvaja i izriče se odgovarajuća sankcija."
        elif "delim" in (reasoning.suggested_verdict or "").lower():
            outcome = "delimicno usvojeno"
            decision = "Predlog se delimično usvaja, uz blažu kvalifikaciju i sankciju."
        else:
            outcome = "osudjen"
            decision = "Okrivljeni se oglašava krivim i izriče se sankcija u skladu sa zakonom."

        return VerdictAnnotation(
            verdict_summary="Presuda doneta na osnovu utvrdjenih cinjenica i primenjenih normi.",
            legal_issues=legal_issues,
            applied_laws=metadata.legal_references or ["Krivicni zakonik Crne Gore"],
            applied_articles=metadata.article_references or [],
            legal_reasoning="Sud je primenio relevantne zakonske odredbe na utvrdjeno cinjenicno stanje.",
            decision=decision,
            case_outcome=outcome,
            legal_concepts=legal_concepts,
            precedent_value="low",
            confidence=0.8,
            metadata={
                "case_number": metadata.case_number,
                "court_name": metadata.court_name,
                "date": metadata.date,
                "judges": metadata.judges,
                "parties": metadata.parties,
                "organizations": metadata.organizations,
            },
            factual_state=metadata.factual_state,
            raw_response="structured_annotation",
        )

    def fill_annotation_defaults(
        self,
        annotation: VerdictAnnotation,
        metadata: VerdictMetadata,
        reasoning: ReasoningResponse,
    ) -> None:
        if not annotation.applied_articles:
            annotation.applied_articles = metadata.article_references or []
        if not annotation.applied_laws:
            annotation.applied_laws = metadata.legal_references or ["Krivicni zakonik Crne Gore"]
        if not annotation.factual_state:
            annotation.factual_state = metadata.factual_state or {}
        if not annotation.case_outcome and reasoning.suggested_verdict:
            annotation.case_outcome = reasoning.suggested_verdict

    def _facts_to_factual_state(self, facts: CaseFacts) -> dict[str, list[str]]:
        state: dict[str, list[str]] = {}

        def add(key: str, value: object) -> None:
            if value is None:
                return
            if isinstance(value, bool):
                text = "da" if value else "ne"
            else:
                text = str(value).strip()
            if not text:
                return
            state.setdefault(key, [])
            if text not in state[key]:
                state[key].append(text)

        add("injury_type", facts.injury_type)
        add("location", facts.location)
        add("weapon", facts.weapon)
        add("weapon_used", facts.weapon_used)
        add("severe_consequence", facts.severe_consequence)
        add("death_result", facts.death_result)
        add("negligence", facts.negligence)
        add("provocation", facts.provocation)
        add("fight_participation", facts.fight_participation)
        add("fight_consequence", facts.fight_consequence)
        add("left_without_help", facts.left_without_help)
        add("previous_convictions", facts.previous_convictions)
        add("repeat_offender", facts.repeat_offender)
        add("confession", facts.confession)
        add("remorse", facts.remorse)
        add("plea_agreement", facts.plea_agreement)
        add("aggravating_circumstances", facts.aggravating_circumstances)
        add("mitigating_circumstances", facts.mitigating_circumstances)
        add("family_circumstances", facts.family_circumstances)
        add("poor_financial_status", facts.poor_financial_status)
        add("alcohol_intoxication", facts.alcohol_intoxication)
        add("narcotics_influence", facts.narcotics_influence)
        add("conditional_sentence_requested", facts.conditional_sentence_requested)
        add("attempted_offense", facts.attempted_offense)
        return state

    def _resolve_applied_articles(self, facts: CaseFacts, reasoning: ReasoningResponse) -> list[str]:
        provided = [str(item).strip() for item in (reasoning.applied_articles or []) if str(item).strip()]
        if provided:
            return provided

        inferred: list[str] = []
        if facts.severe_consequence or facts.death_result or (facts.injury_type and "teska" in facts.injury_type.lower()):
            inferred.append("151")
        if facts.fight_participation or (facts.fight_consequence and "smrt" in facts.fight_consequence.lower()):
            inferred.append("153")
        if facts.left_without_help:
            inferred.append("155")
        return inferred