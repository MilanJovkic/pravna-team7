# 🗺️ Brza Mapa Projekta - Gde Šta Naći

## 📁 Struktura - Šta Gde

```
pravna-team7/
│
├── 🚀 POČETAK OVDE
│   ├── QUICK_START.md          ← 2 minuta, test bez API
│   ├── README_NEW.md            ← Glavni README
│   └── DOCUMENTATION_INDEX.md  ← Index svih dokumenata
│
├── 📚 DOKUMENTACIJA
│   ├── ARCHITECTURE.md         ← Arhitektura, SOLID, Design patterns
│   ├── MIGRATION_GUIDE.md      ← Kako preći sa starog sistema
│   ├── REFACTORING_SUMMARY.md  ← Šta je urađeno i zašto
│   ├── PROJECT_STATUS.md       ← Status svih 9 zadataka
│   └── FINAL_REPORT.md         ← Finalni izveštaj
│
├── 💡 PRIMERI I TESTIRANJE
│   ├── examples.py             ← 6 detaljnih primera korišćenja
│   ├── tests/                  ← Unit i integration testovi
│   └── pytest.ini              ← Pytest konfiguracija
│
├── 🐍 KOD - Refaktorisan
│   ├── src/domain/             ← Domain entities i interfejsi
│   ├── src/application/        ← Use cases i servisi
│   ├── src/infrastructure/     ← Parseri, LLM, exporteri
│   └── src/presentation/       ← CLI interface
│
├── ⚙️ KONFIGURACIJA
│   ├── config/app_config.py    ← Centralizovana konfiguracija
│   ├── .env.template           ← Template za environment vars
│   └── requirements_refactored.txt ← Dependencies
│
├── 🎯 ENTRY POINTS
│   ├── main_refactored.py      ← NOVI (refaktorisan)
│   └── main.py                 ← STARI (legacy, još radi)
│
└── 📋 LEGACY (Stari kod)
    ├── legal_parser.py         ← Stari parser
    ├── llm_annotator.py        ← Stari annotator
    └── akoma_exporter.py       ← Stari exporter
```

---

## 🎯 Šta Kada Tražiš

### "Kako da počnem?"
→ [QUICK_START.md](QUICK_START.md) - 2 min, test bez API

### "Koji fajl da pokrenem?"
→ `python main_refactored.py --limit 5`

### "Kako funkcioniše sistem?"
→ [ARCHITECTURE.md](ARCHITECTURE.md) - kompletna arhitektura

### "Šta je novo?"
→ [REFACTORING_SUMMARY.md](REFACTORING_SUMMARY.md) - kratak pregled

### "Primeri koda?"
→ [examples.py](examples.py) - 6 detaljnih primera

### "Kako testirati?"
→ `pytest tests/unit/` - unit testovi bez API

### "Status projekta?"
→ [PROJECT_STATUS.md](PROJECT_STATUS.md) - svih 9 zadataka

### "Kako dodati novu funkcionalnost?"
→ [ARCHITECTURE.md#extensibility-guide](ARCHITECTURE.md) - detaljan guide

### "Kako koristiti dependency injection?"
→ [examples.py](examples.py) - Primer 5

### "Šta je gde u kodu?"
→ [PROJECT_MAP.md](PROJECT_MAP.md) - OVAJ fajl!

---

## 📂 src/ Struktura - Detaljno

### Domain Layer (❤️ Jezgro)
```
src/domain/
├── entities/
│   ├── legal_document.py   → LegalDocument, Article, Chapter, Paragraph, Point
│   └── annotation.py       → SemanticAnnotation, Sanction, NormType
└── interfaces/
    ├── parsers.py          → ILegalTextParser (kako parsirati)
    ├── annotators.py       → ISemanticAnnotator (kako anotirati)
    ├── exporters.py        → IDocumentExporter (kako eksportovati)
    └── repositories.py     → IRepository (kako čuvati - budući)
```

**Kada koristiti:** Kreiraš novi entitet ili interfejs

### Application Layer (🎯 Logika)
```
src/application/
├── container.py            → DependencyContainer (DI)
└── use_cases/
    └── annotate_document.py → AnnotateLegalDocumentUseCase
```

**Kada koristiti:** Dodaješ novi use case ili servis

### Infrastructure Layer (🔧 Implementacije)
```
src/infrastructure/
├── parsers/
│   └── regex_parser.py     → RegexLegalTextParser
├── llm/
│   └── llm_annotator.py    → LLMSemanticAnnotator
└── exporters/
    └── akoma_exporter.py   → AkomaNtosoExporter
```

**Kada koristiti:** Implementiraš interfejs (parser, annotator, exporter)

### Presentation Layer (🖥️ UI)
```
src/presentation/
└── cli/
    └── main.py             → CLI interface
```

**Kada koristiti:** Dodaješ CLI komande ili novi UI

---

## 🧪 tests/ Struktura

```
tests/
├── unit/
│   ├── test_entities.py    → Domain entity testovi
│   └── test_parsers.py     → Parser testovi
└── integration/
    └── test_pipeline.py    → Pipeline integration testovi
```

**Kada dodati test:**
- Novi domain entitet → `tests/unit/test_entities.py`
- Novi parser → `tests/unit/test_parsers.py`
- Novi use case → `tests/integration/test_[use_case].py`

---

## 📖 Dokumentacija - Ko Šta Čita

| Ko Si | Čitaj |
|-------|-------|
| **Nov na projektu** | QUICK_START → README_NEW → examples.py |
| **Developer** | ARCHITECTURE → examples.py → src/ kod |
| **Migriram sa starog** | MIGRATION_GUIDE → examples.py |
| **Implementiram zadatak** | ARCHITECTURE#extensibility → examples.py |
| **Testiram** | QUICK_START → pytest tests/ |
| **Brzo pregledavam** | PROJECT_STATUS → REFACTORING_SUMMARY |

---

## 🔍 Brza Pretraga Koda

### "Gde je parser?"
```
Stari: legal_parser.py (legacy)
Novi:  src/infrastructure/parsers/regex_parser.py
```

### "Gde je annotator?"
```
Stari: llm_annotator.py (legacy)
Novi:  src/infrastructure/llm/llm_annotator.py
```

### "Gde je exporter?"
```
Stari: akoma_exporter.py (legacy)
Novi:  src/infrastructure/exporters/akoma_exporter.py
```

### "Gde je main?"
```
Stari: main.py (legacy)
Novi:  src/presentation/cli/main.py
Entry: main_refactored.py
```

### "Gde su entiteti?"
```
src/domain/entities/
├── legal_document.py  → Document, Article, Chapter
└── annotation.py      → SemanticAnnotation
```

### "Gde su interfejsi?"
```
src/domain/interfaces/
├── parsers.py     → ILegalTextParser
├── annotators.py  → ISemanticAnnotator
└── exporters.py   → IDocumentExporter
```

### "Gde je dependency injection?"
```
src/application/container.py → DependencyContainer
```

### "Gde je konfiguracija?"
```
config/app_config.py → ApplicationConfig
.env                 → Environment variables
```

---

## 🎯 Implementacija Novih Zadataka

### Zadatak 2: Sudske Odluke

**Gde:**
- Entity: `src/domain/entities/court_decision.py` (kreirati)
- Interface: `src/domain/interfaces/parsers.py` (dodati `ICourtDecisionParser`)
- Implementation: `src/infrastructure/parsers/court_decision_parser.py` (kreirati)
- Test: `tests/unit/test_court_decisions.py` (kreirati)

**Primer:** Pogledaj [ARCHITECTURE.md#task-2](ARCHITECTURE.md)

### Zadatak 3: LegalRuleML

**Gde:**
- Implementation: `src/infrastructure/exporters/legal_ruleml_exporter.py` (kreirati)
- Test: `tests/unit/test_exporters.py` (ažurirati)

**Implementira:** `IDocumentExporter` (već postoji)

### Zadatak 4: NLP Ekstrakcija

**Gde:**
- Interface: `src/domain/interfaces/extractors.py` (kreirati `IFactExtractor`)
- Entity: `src/domain/entities/fact.py` (kreirati `Fact`)
- Implementation: `src/infrastructure/nlp/fact_extractor.py` (kreirati)

### Zadatak 5: Rule-Based Reasoning

**Gde:**
- Service: `src/application/services/rule_engine.py` (kreirati)
- Integration: dr-device alat

### Zadatak 6: Case-Based Reasoning

**Gde:**
- Service: `src/application/services/similarity_service.py` (kreirati)
- Repository: `src/infrastructure/repositories/case_repository.py` (kreirati)
- Integration: jColibri alat

### Zadatak 7-9: UI

**Gde:**
- Web: `src/presentation/web/` (kreirati)
- API: `src/presentation/api/` (kreirati)
- Templates: `src/presentation/web/templates/` (kreirati)

---

## 🛠️ Development Tools

### Code Quality
```bash
flake8 src/         # Linting
mypy src/           # Type checking
black src/          # Code formatting
```

### Testing
```bash
pytest              # Svi testovi
pytest tests/unit/  # Samo unit
pytest --cov=src    # Sa coverage
```

### Documentation
```bash
# Sva dokumentacija u markdown fajlovima
# Docstrings u kodu - svaki modul, klasa, metod
```

---

## 🎓 Učenje Arhitekture

### Najbolji Redosled

1. **Počni sa Domain Layer**
   - `src/domain/entities/legal_document.py` - Čitaj entitete
   - `src/domain/entities/annotation.py` - Čitaj anotacije
   - `src/domain/interfaces/*.py` - Čitaj interfejse

2. **Pređi na Infrastructure**
   - `src/infrastructure/parsers/regex_parser.py` - Kako radi parser
   - `src/infrastructure/llm/llm_annotator.py` - Kako radi LLM
   - `src/infrastructure/exporters/akoma_exporter.py` - Kako radi export

3. **Razumej Application Layer**
   - `src/application/use_cases/annotate_document.py` - Use case
   - `src/application/container.py` - Dependency injection

4. **Pogledaj Presentation**
   - `src/presentation/cli/main.py` - CLI

5. **Testovi kao Primeri**
   - `tests/unit/test_entities.py` - Kako koristiti entitete
   - `tests/unit/test_parsers.py` - Kako koristiti parser

---

## 📞 Pomoć

**Dokumentacija nije jasna?**
→ Čitaj docstrings u kodu - više detalja

**Ne znam gde nešto?**
→ [DOCUMENTATION_INDEX.md](DOCUMENTATION_INDEX.md) - kompletna mapa

**Kako implementiram X?**
→ [ARCHITECTURE.md#extensibility](ARCHITECTURE.md) + [examples.py](examples.py)

**Problem sa kodom?**
→ [QUICK_START.md#problem-solving](QUICK_START.md)

---

**Sada znaš gde se šta nalazi! 🎉**

*Koristi Ctrl+F za brzu pretragu ovog fajla*
