"""Builds verdict generation prompts from domain/application input data."""

from __future__ import annotations

from typing import Optional

from backend.app.models.schemas import CaseFacts, ReasoningResponse


class PromptBuilder:
    """Single-responsibility prompt builder for verdict text generation."""

    def build(
        self,
        case_number: str,
        court_name: str,
        date_value: str,
        judges: list[str],
        facts: CaseFacts,
        reasoning: ReasoningResponse,
        selected_verdict: str | None,
        selected_sanction: str | None,
    ) -> str:
        applied_articles = ", ".join(reasoning.applied_articles or [])
        applied_laws = ", ".join(
            {
                "Krivicni zakonik Crne Gore",
                *["Krivicni zakonik Crne Gore" for _ in (reasoning.applied_law_texts or [])],
            }
        )
        law_snippets = []
        for law in reasoning.applied_law_texts or []:
            if isinstance(law, dict):
                article_number = law.get("article_number")
                content = law.get("content")
            else:
                article_number = getattr(law, "article_number", None)
                content = getattr(law, "content", None)
            content = (content or "").strip()
            if content:
                law_snippets.append(f"Clan {article_number}: {content[:220]}")

        law_text_block = "\n".join(law_snippets[:3]) if law_snippets else "Nema dodatnih izvoda."
        similar_cases = ", ".join(
            [f"{m.case_number} ({m.similarity:.0%})" for m in (reasoning.cbr.matches or [])[:3] if m.case_number]
        )

        verdict_line = selected_verdict or reasoning.suggested_verdict or "nepoznato"
        sanction_line = selected_sanction or reasoning.suggested_sanction or "nepoznato"

        return (
            "Generisi novu sudsku presudu na srpskom (latinica, bez markdowna).\n"
            "Presuda mora da sledi strukturu crnogorskih presuda i da sadrzi:\n"
            "1) naziv suda, broj predmeta i datum\n"
            "2) izraz 'U IME CRNE GORE'\n"
            "3) naslov 'P R E S U D U'\n"
            "4) opis okrivljenog\n"
            "5) izreku (kriv je / nije kriv) sa primenjenim clancima\n"
            "6) sankciju\n"
            "7) kratko obrazlozenje\n"
            "8) pravnu pouku (kratko)\n\n"
            f"Broj predmeta: {case_number}\n"
            f"Sud: {court_name}\n"
            f"Datum: {date_value}\n"
            f"Sudija/e: {', '.join(judges)}\n"
            f"Okrivljeni: {facts.defendant or 'nepoznato'}\n"
            f"Tip povrede: {facts.injury_type or 'nepoznato'}\n"
            f"Lokacija: {facts.location or 'nepoznato'}\n"
            f"Oruzje: {facts.weapon or 'nepoznato'}\n"
            f"Oruzje upotrebljeno: {self._bool_text(facts.weapon_used)}\n"
            f"Teza posledica: {self._bool_text(facts.severe_consequence)}\n"
            f"Smrtni ishod: {self._bool_text(facts.death_result)}\n"
            f"Nehat: {self._bool_text(facts.negligence)}\n"
            f"Provokacija: {self._bool_text(facts.provocation)}\n"
            f"Ucesce u tuci: {self._bool_text(facts.fight_participation)}\n"
            f"Posledica tuce: {facts.fight_consequence or 'nepoznato'}\n"
            f"Ostavljen bez pomoci: {self._bool_text(facts.left_without_help)}\n\n"
            f"Primenjeni clanci: {applied_articles or 'nepoznato'}\n"
            f"Primenjeni zakoni: {applied_laws}\n"
            f"Predlog presude: {verdict_line}\n"
            f"Predlog sankcije: {sanction_line}\n"
            f"Slicni slucajevi: {similar_cases or 'nema'}\n\n"
            "Kratki izvodi zakona:\n"
            f"{law_text_block}\n\n"
            "Vrati samo kompletan tekst presude, bez dodatnih objasnjenja."
        )

    def _bool_text(self, value: Optional[bool]) -> str:
        if value is None:
            return "nepoznato"
        return "da" if value else "ne"