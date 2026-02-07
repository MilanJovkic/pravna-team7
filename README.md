# 🎓 Pravna Informatika - Tim 7

## Sistem za Podršku Sudijama u Donošenju Odluka

> **⚠️ VAŽNO: Projekat je refaktorisan po SOLID i Clean Architecture principima!**
> 
> 👉 **NOVI KORISNICI:** Pročitajte [QUICK_START.md](QUICK_START.md) ili [README_NEW.md](README_NEW.md)  
> 👉 **POSTOJEĆI KORISNICI:** Pročitajte [MIGRATION_GUIDE.md](MIGRATION_GUIDE.md)  
> 👉 **SVI:** Pogledajte [DOCUMENTATION_INDEX.md](DOCUMENTATION_INDEX.md) za kompletnu dokumentaciju

---

## ⚡ Quick Start

```bash
# 1. Instalacija
pip install -r requirements_refactored.txt

# 2. Test (bez API-ja)
python -c "from src.domain.entities import LegalDocument; print('✓ Works!')"

# 3. Konfiguracija
cp .env.template .env
# Dodaj API token

# 4. Pokreni (sa API-jem)
python main_refactored.py --input zakon.txt --output test.xml --limit 5
```

**Više detalja:** [QUICK_START.md](QUICK_START.md)

---

## 📚 Dokumentacija

| Dokument | Opis |
|----------|------|
| **[QUICK_START.md](QUICK_START.md)** | 🚀 Brzi početak (2-10 min) |
| **[README_NEW.md](README_NEW.md)** | 📖 Glavni README |
| **[ARCHITECTURE.md](ARCHITECTURE.md)** | 🏗️ Arhitektura i SOLID |
| **[MIGRATION_GUIDE.md](MIGRATION_GUIDE.md)** | 🔄 Prelazak sa starog |
| **[DOCUMENTATION_INDEX.md](DOCUMENTATION_INDEX.md)** | 📑 Index dokumentacije |
| **[examples.py](examples.py)** | 💡 6 praktičnih primera |

---

## 🎯 Status Projekta

✅ **Zadatak 1: Akoma Ntoso Anotacija** - ZAVRŠENO i REFAKTORISANO  
🔄 **Zadatak 2-9** - Priprema za implementaciju

**Detalji:** [PROJECT_STATUS.md](PROJECT_STATUS.md)

---

## 🏗️ Nova Arhitektura

```
src/
├── domain/          # ❤️ Čisto jezgro
├── application/     # 🎯 Use cases  
├── infrastructure/  # 🔧 Implementacije
└── presentation/    # 🖥️ UI
```

**Zašto?** SOLID principi + Clean Architecture = Testabilno, Održivo, Proširivo

**Detaljnije:** [ARCHITECTURE.md](ARCHITECTURE.md)

---

## 🚀 Korišćenje

### Novi Način (Preporučeno)

```bash
python main_refactored.py --input zakon.txt --output output.xml --limit 10
```

### Stari Način (I dalje radi!)

```bash
python main.py --input zakon.txt --output output.xml --limit 10
```

---

## 📖 Stara Dokumentacija (ispod)

> ⚠️ Dokumentacija ispod je za **stari sistem** (main.py, legal_parser.py, itd.)  
> Za **novi refaktorisani sistem** pogledaj fajlove gore!

---

# Stari Sistem - Dokumentacija

## Arhitektura

```
zakon.txt → legal_parser → llm_annotator → akoma_exporter → output.xml
```

### Moduli

1. **legal_parser.py** - Segmentacija zakona
2. **llm_annotator.py** - LLM semantička anotacija  
3. **akoma_exporter.py** - AKOMA Ntoso XML generisanje
4. **main.py** - Orchestrator pipeline

## Setup (Stari Način)

### 1. Instaliraj

```bash
pip install requests python-dotenv
```

### 2. Konfiguracija

```env
GITHUB_TOKEN=your_token
# ILI
OPENROUTER_API_KEY=your_key
``` (GitHub Models)

```bash
python main.py --input zakon.txt --output annotated_law.xml
```

### Sa OpenRouter (besplatni DeepSeek model)

```bash
python main.py --provider openrouter --model tngtech/deepseek-r1t2-chimera:free --output annotated_law.xml
```

### Test na prvim N članaka

```bash
python main.py --input zakon.txt --output test.xml --limit 5
```

### Sa drugim modelom (GitHub)

```bash
python main.py --provider github --model gpt-4o-mini --output output.xml
```

### Kompletno procesiranje sa OpenRouter

```bash
# Svih 17 članaka sa OpenRouter DeepSeek modelom (besplatno)
python main.py --provider openrouter --model tngtech/deepseek-r1t2-chimera:free --limit 17 --output full_output.xml
```

**Napomena:** Rate limiting je automatski - GitHub ima 10 zahteva/minut (6s između poziva). OpenRouter limite zavise od modela

```bash
python main.py --input zakon.txt --output output.xml --model gpt-4o-mini
```

**Napomena:** Rate limiting je automatski - maksimalno 10 zahteva/minut (6s između poziva).

## Semantička Šema

LLM anotira članke po sledećoj šemi:

### Norm Type
- `prohibition` - zabrana
- `obligation` - obaveza
- `permission` - dozvola
- `definition` - definicija
- `sanction` - sankcija

### Subjects
- `perpetrator` - počinilac
- `victim` - žrtva
- `official` - službeno lice
- `minor` - maloljetnik
- `family_member` - član porodice

### Conditions
- `intent` - umišljaj
- `negligence` - nehat
- `consent` - pristanak
- `aggravating_circumstances` - otežavajuće okolnosti

### Sanctions
```json
{
  "type": "prison",
  "min_value": 5,
  "max_value": 15,
  "min_unit": "years",
  "max_unit": "years"
}
```

### Legal Concepts
- `murder` - ubistvo
- `bodily_harm` - tjelesna povreda
- `negligence` - nehat
- `attempt` - pokušaj
- `self_defense` - nužna odbrana

## Output

### XML Output (AKOMA Ntoso)

```xml
<article eId="art_143" 
         data-norm-type="prohibition"
         data-subjects="perpetrator,victim"
         data-concepts="murder">
  <num>Član 143</num>
  <paragraph eId="art_143__para_1">
    <content>
      <p>Ko drugog liši života, kazniće se zatvorom od pet do petnaest godina.</p>
    </content>
  </paragraph>
</article>
```

### JSON Output (Validacija)

```json
{
  "143": {
    "norm_type": "prohibition",
    "subjects": ["perpetrator", "victim"],
    "legal_concepts": ["murder"],
    "sanctions": {
      "type": "prison",
      "min_value": 5,
      "max_value": 15
    }
  }
}
```

## Struktura Output-a

- `output_annotated.xml` - AKOMA Ntoso XML sa semantičkim anotacijama
- `output_annotated_annotations.json` - JSON sa svim anotacijama (za analizu)

## Error Handling

Sistem implementira:
- **Retry logika** (3 pokušaja za LLM pozive)
- **Fallback anotacije** (default vrednosti ako LLM zakaže)
- **Automatski rate limiting** (10 zahteva/minut sa sliding window tracking)
- **Graceful degradation** (nastavlja sa sledećim člankom ako jedan zakaže)

## Napomene

### ZAŠTO ova arhitektura?

1. **Modularnost**: Svaki modul može se testirati/menjati nezavisno
2. **Skalabilnost**: Batch processing sa automatskim rate limiting-om
3. **Validacija**: JSON intermediate format omogućava validaciju pre XML-a
4. **Ekstenzibilnost**: Lako dodati nove semantičke kategorije

### ZAŠTO ova semantička šema?

Šema je dizajnirana za krivični zakon:
- `norm_type` - razlikuje prohibicije, sankcije, definicije
- `subjects` - prati aktere (počinilac, žrtva, službeno lice)
- `conditions` - umišljaj/nehat ključni za krivično pravo
- `sanctions` - centralna kategorija za kazne
- `legal_concepts` - mapira pravne institute

### ZAŠTO custom XML atributi?

AKOMA Ntoso standard ne definiše semantiku specifičnu za krivično pravo.
Koristimo `data-*` atribute za ekstenziju standarda, što omogućava:
- Kompatibilnost sa AKOMA parsers
- Dodatne semantičke informacije za analitiku
- Laku ekstrakciju za knowledge graph

## Testiranje

```bash
# Test parser-a
python legal_parser.py

# Test annotator-a (procesira prvi član)
python llm_annotator.py

# Test exporter-a (generiše XML bez anotacija)
python akoma_exporter.py

# Test kompletnog pipeline-a (5 članaka)
python main.py --limit 5
```

## Procesiranje Kompletnog Zakona

**VAŽNO**: Procesiranje celog zakona može trajati 15-30 minuta i košta API tokens.

### Opcija 1: Sigurni način (interaktivno)

```bash
python process_full_law.py
```

Skript će tražiti potvrdu i prikazati procenu troškova.

### Opcija 2: Direktan poziv

```bash
python main.py --input zakon.txt --output full_output.xml
```

### Opcija 3: Batch procesiranje (sa pauzom)

```bash
# Prvi batch (50 članaka)
python main.py --limit 50 --output batch1.xml

# Pauza...

# Drugi batch (sledeći 50)
# NAPOMENA: Trenutno nije implementiran offset, treba ručno editovati zakon.txt
python main.py --limit 50 --output batch2.xml
```

## Analiza Rezultata

Nakon procesiranja, analiziraj rezultate:

```bash
# Statistički pregled
python analyze_annotations.py full_output_annotations.json

# Eksportuj u CSV za dalju analizu
python analyze_annotations.py full_output_annotations.json --csv results.csv

# Otvori CSV u Excel/LibreOffice za grafike i pivot tabele
```

## Dalja Upotreba

Generirani XML može se koristiti za:
- **Knowledge Graph** - ekstrakcija triplets-a (subjekt-predikat-objekt)
- **Semantička pretraga** - pronalaženje sličnih članaka
- **Pravna analitika** - statistika o sankcijama, tipovima dela
- **Cross-reference analiza** - mreža referenciranja između članaka
- **Komparativna analiza** - poređenje sa drugim zakonima

### Knowledge Graph Ekstrakcija

```bash
# Statistika triplets-a
python extract_knowledge_graph.py output_annotations.json

# Export u RDF Turtle format (za SPARQL query)
python extract_knowledge_graph.py output_annotations.json --turtle graph.ttl

# Export u JSON-LD format
python extract_knowledge_graph.py output_annotations.json --jsonld graph.jsonld

# Export u Neo4j Cypher format
python extract_knowledge_graph.py output_annotations.json --cypher graph.cypher

# Generiši sve formate odjednom
python extract_knowledge_graph.py output_annotations.json --all
```

### SPARQL Query primeri (nad .ttl fajlom)

```sparql
# Pronađi sve članke koji uključuju "murder"
SELECT ?article WHERE {
  ?article law:involvesConcept law:Murder .
}

# Pronađi članke sa kaznom >10 godina
SELECT ?article ?min WHERE {
  ?article law:prescribesSanction ?sanction .
  ?sanction law:hasMinimumDuration ?min .
  FILTER(xsd:integer(SUBSTR(?min, 1, 2)) > 10)
}
```

### Neo4j Query primeri (nakon import .cypher fajla)

```cypher
// Pronađi sve članke povezane sa ubistvom
MATCH (a:LegalArticle)-[:involvesConcept]->(c:Murder)
RETURN a, c

// Pronađi najstrože sankcije
MATCH (a:LegalArticle)-[:prescribesSanction]->(s:Sanction)
WHERE s.id CONTAINS 'prison'
RETURN a.id, s.id
ORDER BY s.id DESC
LIMIT 10

// Mreža povezanih članaka
MATCH path = (a:LegalArticle)-[:referencesArticle*1..3]->(b:LegalArticle)
RETURN path
```

## Fajlovi u Projektu

### Core moduli
- `legal_parser.py` - Parser pravnih tekstova
- `llm_annotator.py` - LLM semantička anotacija
- `akoma_exporter.py` - AKOMA Ntoso XML generator
- `main.py` - Glavni orchestrator pipeline

### Utility skripte
- `analyze_annotations.py` - Statistička analiza anotacija
- `extract_knowledge_graph.py` - Ekstrakcija KG triplets-a
- `process_full_law.py` - Helper za procesiranje kompletnog zakona

### Input/Output
- `zakon.txt` - Ulazni tekst zakona
- `02_ZBSP_akn (1).xml` - Primer AKOMA XML šeme
- `.env` - GitHub API token
- `requirements.txt` - Python dependencies

## Arhitektura Odluke

### Zašto modularna arhitektura?
- **Testabilnost**: Svaki modul se može testirati izolovano
- **Maintainability**: Lako dodavanje novih feature-a
- **Reusability**: Parser i exporter mogu se koristiti samostalno

### Zašto LLM umesto rule-based?
- **Fleksibilnost**: LLM razume prirodni jezik i kontekst
- **Proširivost**: Lako dodavanje novih semantičkih kategorija
- **Preciznost**: GPT-4o ima solidno razumijevanje pravnih koncepata

### Zašto AKOMA Ntoso?
- **Standard**: Međunarodni standard za pravne dokumente
- **Interoperabilnost**: Kompatibilnost sa drugim sistemima
- **Semantička bogatost**: Podrška za meta-podatke i cross-reference

### Zašto JSON intermediate format?
- **Validacija**: Laka provera kvaliteta anotacija
- **Debug**: Jednostavan uvid u LLM outpute
- **Analitika**: Direktna upotreba u Python/pandas

## Limitacije i Buduća Unapređenja

### Trenutne limitacije:
1. **Parser ne prepoznaje sve edge case-ove** (npr. podtačke, fusnote)
2. **LLM može griješiti** pri interpretaciji složenih članaka
3. **Nema resume funkcionalnosti** (ako se procesiranje prekine)
4. **Nema batch offset-a** (za procesiranje u više faza)

### Buduća unapređenja:
1. **Resume capability** - sačuvaj checkpoint i nastavi odakle si stao
2. **Multi-model ensemble** - koristi više LLM-ova i merguj rezultate
3. **Human-in-the-loop validation** - GUI za pregled i korekciju anotacija
4. **Reference resolution** - automatsko parsiranje internih referenci
5. **Temporal versioning** - podrška za praćenje izmena zakona kroz vrijeme
6. **Cross-law linking** - povezivanje sa drugim zakonima

## Troubleshooting

### Problem: "GitHub token nije pronađen"
**Rešenje**: Proveri da li `.env` fajl postoji i sadrži `GITHUB_TOKEN=...`

### Problem: "JSON parsing error"
**Rešenje**: LLM je vratio nevalidan JSON. Sistem će automatski retry (3x). Ako i dalje ne radi, smanji `--rate-limit` ili probaj drugi model.

### Problem: "Timeout"
**Rešenje**: Povećaj timeout u `llm_annotator.py` ili koristi `--rate-limit 1.0` za sporiji procesing.

### Problem: "Parser propušta članke"
**Rešenje**: Proveri format `zakon.txt`. Parser očekuje standardnu strukturu (GLAVA → Član → stav → tačka).

## Kontribucije

Projekat je open-source. Kontribucije su dobrodošle:
1. Fork repo
2. Kreiraj feature branch
3. Commit izmene
4. Submit pull request

## Citiranje

Ako koristite ovaj sistem u naučnom radu:

```bibtex
@software{legal_annotation_system_2024,
  title = {Automatska AKOMA/NtTSO Anotacija Krivičnog Zakonika},
  author = {pravna-team7},
  year = {2024},
  url = {https://github.com/...}
}
```

## Licenca

MIT