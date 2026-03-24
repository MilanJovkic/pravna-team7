# Legal Annotation System - Full Stack Application

Sistem za semantičku anotaciju pravnih dokumenata pomoću LLM-a sa **FastAPI backend-om** i **Angular frontend-om**.

Projekat pokriva:
1. **Zadatak 1**: Anotacija zakona u Akoma Ntoso XML format
2. **Zadatak 2**: Anotacija sudskih presuda iz PDF-a
3. **Zadatak 3**: Full-stack web aplikacija za pregled i pretragu

## Zadatak 1: Anotacija Zakona

### Arhitektura
- `data/zakon.txt`: izvorni tekst zakona (Krivični zakonik)
- `src/akoma_annotation/parser.py`: parser strukture zakona (glava → član → stav → tačka)
- `src/akoma_annotation/annotator.py`: LLM semantička anotacija
- `src/akoma_annotation/exporter.py`: AKOMA Ntoso act XML generator
- `src/akoma_annotation/pipeline.py`: orkestracija faza
- `main.py`: CLI za procesiranje zakona

### Pokretanje
1. Instaliraj zavisnosti:
   ```bash
   pip install -r requirements.txt
   ```

2. Postavi API token u `.env`:
   ```bash
   python main.py  # Kreira .env sa placeholderima
   # Dodaj GITHUB_TOKEN ili OPENROUTER_API_KEY u .env
   ```

3. Procesuiraj zakon:
   ```bash
   python main.py --output annotated_law.xml --limit 5  # Test
   python main.py --output annotated_law.xml             # Pun zakon
   ```

## Zadatak 2: Anotacija Sudskih Presuda

### Arhitektura
- `data/verdicts_pdf/`: folder sa PDF presudama (najmanje 15)
- `src/verdict_annotation/pdf_extractor.py`: ekstrakcija teksta iz PDF-a
- `src/verdict_annotation/verdict_parser.py`: parser presuda (broj predmeta, sud, sudije, stranke)
- `src/verdict_annotation/verdict_annotator.py`: LLM semantička analiza presuda
- `src/verdict_annotation/verdict_exporter.py`: Akoma Ntoso judgment XML generator
- `src/verdict_annotation/verdict_pipeline.py`: orkestracija
- `process_verdicts.py`: CLI za procesiranje presuda

### Pokretanje
1. Postavi PDF presude u `data/verdicts_pdf/`

2. Procesuiraj presude:
   ```bash
   python process_verdicts.py --limit 2                    # Test
   python process_verdicts.py                              # Sve presude
   python process_verdicts.py --output-dir custom_output  # Custom output
   ```

3. Rezultati:
   - XML fajlovi u `data/verdicts_xml/` (Akoma Ntoso judgment format)
   - JSON sa anotacijama: `data/verdicts_xml/verdicts_annotations.json`

### Šta se anotira u presudama
- Broj predmeta, sud, datum, sudije
- Stranke u postupku
- Pravna pitanja i primenjeni zakoni
- Referencirani članci zakona
- Pravno obrazloženje
- Odluka suda i ishod predmeta
- Pravni koncepti

### Pregled presuda

Koristi `view_verdicts.py` za učitavanje i pregled XML presuda:

```bash
python view_verdicts.py list                     # Lista svih presuda
python view_verdicts.py show Одлуке              # Detalji presude
python view_verdicts.py search "Krivični zakonik" # Pretraga po zakonu
python view_verdicts.py export summary.txt       # Tekstualni rezime
```

## Struktura projekta

```
pravna-team7/
├── data/
│   ├── zakon.txt              # Izvorni tekst zakona
│   ├── verdicts_pdf/          # PDF presude (input)
│   └── verdicts_xml/          # XML presude (output)
├── src/
│   ├── akoma_annotation/      # Moduli za zakon (Zadatak 1)
│   │   ├── parser.py
│   │   ├── annotator.py
│   │   ├── exporter.py
│   │   └── pipeline.py
│   └── verdict_annotation/    # Moduli za presude (Zadatak 2)
│       ├── pdf_extractor.py
│       ├── verdict_parser.py
│       ├── verdict_annotator.py
│       ├── verdict_exporter.py
│       └── verdict_pipeline.py
├── main.py                    # CLI za zakon
├── process_verdicts.py        # CLI za presude
└── view_verdicts.py           # Viewer za presude

```

## Zadatak 6: Rasudjivanje po slucajevima (CBR)

- jColibri projekat: `cbr-jcolibri/`
- CSV baza slucajeva: `cbr-jcolibri/src/main/resources/presude.csv`
- Model i slicnosti: `cbr-jcolibri/src/main/java/`
- Opis: `CBR.md`

## Finalni evaluacioni protokol (5 zakljucanih presuda)

- Zakljucani skup: `data/verdicts_xml/Одлуке.xml`, `data/verdicts_xml/Одлуке1.xml`, `data/verdicts_xml/Одлуке2.xml`, `data/verdicts_xml/Одлуке3.xml`, `data/verdicts_xml/Одлуке4.xml`
- Protokol i pragovi: `tests/data/final_eval_protocol.json`
- Evaluator: `scripts/evaluate_final_protocol.py`
- Izvestaj: `output/final_eval_report.json` i `output/final_eval_report.md`

Kriterijumi skoringa (0-5 po kriterijumu):
- pravna tacnost
- logicka konzistentnost
- korisnost za korisnika
- pokrivenost kljucnih cinjenica
- objasnjenje zakljucka

Automatski red flags (trenutni FAIL po slucaju):
- kontradikcija u obrazlozenju
- pozivanje na nepostojece cinjenice
- genericki/nekoristan odgovor bez konkretnog rezonovanja

Jedan komandni korak za CI validaciju:

```bash
python scripts/run_ci_validation.py
```

Ovaj korak:
- podize API server
- pokrece proverene unit/governance testove
- pokrece API smoke test
- pokrece finalnu evaluaciju 5 zakljucanih presuda
- generise PASS/FAIL izvestaj sa detaljima problema

## Napomene

- Oba sistema koriste isti `.env` (GitHub ili OpenRouter token)
- Rate limiting je automatski (10 zahteva/minut)
- Za testiranje koristi `--limit` opciju
- XML je kompatibilan sa Akoma Ntoso 3.0 standardom
- Presude se procesiraju iz PDF formata i ekstraktuju se tekstovi automatski
