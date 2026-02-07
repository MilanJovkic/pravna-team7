# Akoma Annotation Pipeline (Zadatak 1)

Ovaj projekat pokriva **Zadatak 1**: odabir zakona, kompletna semantička anotacija i izvoz u
mašinski čitljivi AKOMA Ntoso format. Fokus je na jednom zakonu (`data/zakon.txt`), na kojem
se:

1. analiziraju strukturne jedinice (glava → član → stav → tačka),
2. svaki član dobija LLM semantičku anotaciju (norme, subjekti, reference, entiteti),
3. rezultati se enkodiraju u validan AKOMA Ntoso XML zajedno sa JSON podacima za validaciju.

## Arhitektura

- `data/zakon.txt`: izvorni tekst zakona koji se anotira.
- `src/akoma_annotation/parser.py`: parser strukture zakona.
- `src/akoma_annotation/annotator.py`: LLM anotator sa GitHub/OpenRouter integracijom.
- `src/akoma_annotation/exporter.py`: AKOMA Ntoso XML generator + JSON export.
- `src/akoma_annotation/pipeline.py`: orkestracija faza (parsiranje, anotacija, eksport).
- `main.py`: CLI koji pokreće pipeline i postavlja `.env` kada ga nema.

## Pokretanje pipeline-a

1. Instaliraj zavisnosti:
   ```bash
   pip install -r requirements.txt
   ```
2. Pokreni `main.py` (prvi put kreira `.env` sa placeholderima):
   ```bash
   python main.py
   ```
   Dodaj `GITHUB_TOKEN` ili `OPENROUTER_API_KEY` u generisani `.env` i pokreni ponovo.
3. Za potpuni zakon ukloni limit i pokreni sa željenim modelom:
   ```bash
   python main.py --output annotated_law.xml --provider github --model gpt-4o
   ```
   Opcije:
   - `--input`: putanja do zakona (`data/zakon.txt`).
   - `--output`: AKOMA Ntoso XML izlaz.
   - `--output-json`: JSON fajl sa anotacijama (auto ako nije naveden).
   - `--provider`: `github` ili `openrouter`.
   - `--model`: naziv modela.
   - `--limit`: broj članaka za testiranje (npr. `--limit 5`).
4. Kod prvih pokretanja preporučeno je ograničiti broj članaka kako bi se proverilo da li LLM
daje očekivane semantičke oznake.

## Napomene

- Projekat je sveden na Task 1: parser, annotator, exporter i orchestration; pomoćni skripti za
  analizu ili knowledge graph više nisu prisutni u ovom repo.
- `src/` je python paket, tako da `main.py` može direktno uvesti `src.akoma_annotation.pipeline`.
- Za punu anotaciju ukloni `--limit` i proveri da li token ima dovoljnu kvotu.
