# 🎓 Pravna Informatika - Tim 7
## Sistem za Podršku Sudijama u Donošenju Odluka

[![Python](https://img.shields.io/badge/python-3.9+-blue.svg)](https://www.python.org/downloads/)
[![Code style: black](https://img.shields.io/badge/code%20style-black-000000.svg)](https://github.com/psf/black)
[![SOLID](https://img.shields.io/badge/architecture-SOLID-green.svg)](ARCHITECTURE.md)

---

## 📌 O Projektu

Kompletan sistem za pravnu informatiku koji omogućava:
- ✅ **Automatsku anotaciju** pravnih tekstova (Akoma Ntoso)
- 🔄 **Parsiranje sudskih odluka** (priprema za implementaciju)
- 🔄 **Rasudivanje po pravilima** (LegalRuleML + dr-device)
- 🔄 **Rasudivanje po slučajevima** (jColibri)
- 🔄 **Generisanje odluka** (LLM)

### ✨ Trenutni Status

✅ **Zadatak 1 KOMPLETIRAN** - Akoma Ntoso anotacija  
✅ **REFAKTORISAN** po SOLID i Clean Architecture principima  
✅ **Spreman za implementaciju** ostalih zadataka  

---

## 🚀 Quick Start (za Nestrpljive)

```bash
# 1. Clone/Download projekta
cd pravna-team7

# 2. Instalacija
pip install -r requirements_refactored.txt

# 3. Setup (.env file)
cp .env.template .env
# Dodaj GITHUB_TOKEN ili OPENROUTER_API_KEY

# 4. Testiraj sa 5 članaka
python main_refactored.py --input zakon.txt --output test.xml --limit 5

# 5. Pokreni testove
pytest
```

---

## 📚 Dokumentacija (Čitaj Ovo!)

| Dokument | Opis | Za Koga |
|----------|------|---------|
| [README_REFACTORED.md](README_REFACTORED.md) | **Detaljna dokumentacija** | 👥 Svi |
| [ARCHITECTURE.md](ARCHITECTURE.md) | **Arhitektura sistema** | 👨‍💻 Developeri |
| [MIGRATION_GUIDE.md](MIGRATION_GUIDE.md) | **Prelazak sa starog sistema** | 🔄 Migracija |
| [PROJECT_STATUS.md](PROJECT_STATUS.md) | **Status zadataka** | 📊 Pregled |
| [examples.py](examples.py) | **Primeri korišćenja** | 💡 Praktično |
| [spec.txt](spec.txt) | **Specifikacija zadatka** | 📋 Zahtevi |

---

## 🏗️ Arhitektura (Clean Architecture + SOLID)

```
┌─────────────────────────────────────────┐
│         PRESENTATION LAYER              │
│  ┌─────────┐  ┌──────┐  ┌──────────┐   │
│  │   CLI   │  │  Web │  │ REST API │   │ ← Budući zadaci
│  └─────────┘  └──────┘  └──────────┘   │
├─────────────────────────────────────────┤
│        APPLICATION LAYER                │
│  ┌──────────────┐  ┌──────────────┐    │
│  │  Use Cases   │  │   Services   │    │
│  └──────────────┘  └──────────────┘    │
├─────────────────────────────────────────┤
│      INFRASTRUCTURE LAYER               │
│  ┌────────┐ ┌──────┐ ┌──────────┐      │
│  │ Parser │ │ LLM  │ │ Exporter │      │
│  └────────┘ └──────┘ └──────────┘      │
├─────────────────────────────────────────┤
│          DOMAIN LAYER                   │
│  ┌──────────┐  ┌────────────┐          │
│  │ Entities │  │ Interfaces │          │
│  └──────────┘  └────────────┘          │
└─────────────────────────────────────────┘
```

**Zašto?**
- ✅ Testabilnost (Dependency Injection)
- ✅ Održivost (Jasna separacija)
- ✅ Proširivost (Interface-based)
- ✅ Razumljivost (Logična organizacija)

---

## 📁 Struktura Projekta

```
pravna-team7/
│
├── 📂 src/                          # Novi refaktorisan kod
│   ├── domain/                      # ❤️ Jezgro sistema
│   │   ├── entities/                # Domain entiteti
│   │   │   ├── legal_document.py    # LegalDocument, Article, Chapter
│   │   │   └── annotation.py        # SemanticAnnotation
│   │   └── interfaces/              # Interfejsi (DIP)
│   │       ├── parsers.py
│   │       ├── annotators.py
│   │       └── exporters.py
│   │
│   ├── application/                 # 🎯 Business logika
│   │   ├── use_cases/
│   │   │   └── annotate_document.py # Pipeline orchestration
│   │   └── container.py             # Dependency injection
│   │
│   ├── infrastructure/              # 🔧 Implementacije
│   │   ├── parsers/                 # Regex parser
│   │   ├── llm/                     # LLM annotator
│   │   ├── exporters/               # Akoma Ntoso exporter
│   │   └── repositories/            # (budući)
│   │
│   └── presentation/                # 🖥️ UI
│       └── cli/                     # Command-line interface
│
├── 📂 config/                       # Konfiguracija
│   └── app_config.py                # ApplicationConfig
│
├── 📂 tests/                        # Testovi
│   ├── unit/                        # Unit testovi
│   └── integration/                 # Integration testovi
│
├── 📂 docs/                         # Dokumentacija
│
├── 🐍 main_refactored.py            # ✅ Novi entry point
├── 🐍 main.py                       # ⚠️ Stari entry point (legacy)
├── 🐍 examples.py                   # 💡 Primeri korišćenja
│
├── 📄 README_REFACTORED.md          # Detaljna dokumentacija
├── 📄 ARCHITECTURE.md               # Arhitektura
├── 📄 MIGRATION_GUIDE.md            # Migracija
├── 📄 PROJECT_STATUS.md             # Status
│
└── 📋 requirements_refactored.txt   # Dependencies
```

---

## 🛠️ Instalacija i Setup

### 1. Python Environment

```bash
# Proveri Python verziju (potrebno 3.9+)
python --version

# Kreiraj virtual environment (preporučeno)
python -m venv venv

# Aktiviraj
# Windows:
venv\Scripts\activate
# Linux/Mac:
source venv/bin/activate
```

### 2. Dependencies

```bash
# Instaliraj novi refaktorisan sistem
pip install -r requirements_refactored.txt

# ILI stari sistem (za kompatibilnost)
pip install -r requirements.txt
```

### 3. Konfiguracija

```bash
# Kopiraj template
cp .env.template .env

# Uredi .env i dodaj token
# GITHUB_TOKEN=ghp_xxxxxxxxxxxxx
# ILI
# OPENROUTER_API_KEY=sk-or-xxxxxxxxxxxxx
```

---

## 💻 Korišćenje

### Osnovni Workflow

```bash
# 1. Test run (prvih 5 članaka)
python main_refactored.py --input zakon.txt --output test.xml --limit 5

# 2. Puna obrada
python main_refactored.py --input zakon.txt --output output.xml

# 3. Sa OpenRouter
python main_refactored.py --provider openrouter --model gpt-4o
```

### Programski (Python API)

```python
from src.config.app_config import ApplicationConfig
from src.application.container import DependencyContainer

# Setup
config = ApplicationConfig.from_env()
container = DependencyContainer(config)

# Execute
use_case = container.get_annotate_document_use_case()
result = use_case.execute(
    input_file="zakon.txt",
    output_file="output.xml",
    article_limit=10
)

print(f"Success: {result['success']}")
print(f"Annotated: {len(result['annotations'])} articles")
```

**Pogledaj [examples.py](examples.py) za više primera!**

---

## 🧪 Testiranje

```bash
# Svi testovi
pytest

# Sa detaljnim output-om
pytest -v

# Coverage report
pytest --cov=src --cov-report=html
# Open htmlcov/index.html

# Samo unit testovi
pytest tests/unit/ -v

# Code quality
flake8 src/
mypy src/
```

---

## 📊 Zadaci i Status

| # | Zadatak | Status | Lokacija |
|---|---------|--------|----------|
| 1 | Akoma Ntoso Anotacija | ✅ **Završeno** | `src/infrastructure/` |
| 2 | Sudske Odluke | 🔄 Priprema | Interface definisan |
| 3 | LegalRuleML | 🔄 Priprema | Interface definisan |
| 4 | NLP Ekstrakcija | 🔄 Priprema | `src/infrastructure/nlp/` |
| 5 | Rule Reasoning | 🔄 Priprema | `src/application/services/` |
| 6 | Case Reasoning | 🔄 Priprema | `src/application/services/` |
| 7 | Pregled Dokumenata | 🔄 Priprema | `src/presentation/web/` |
| 8 | Rasudivanje UI | 🔄 Priprema | `src/presentation/web/` |
| 9 | Generisanje Odluka | 🔄 Priprema | `src/application/services/` |

**Detaljno:** [PROJECT_STATUS.md](PROJECT_STATUS.md)

---

## 🎯 SOLID Principi u Praksi

### Single Responsibility
```python
# ✅ Svaka klasa ima jednu odgovornost
class RegexLegalTextParser:  # Samo parsiranje
class LLMSemanticAnnotator:  # Samo anotacija
class AkomaNtosoExporter:    # Samo export
```

### Open/Closed
```python
# ✅ Otvoren za proširenje, zatvoren za modifikaciju
class MyCustomParser(ILegalTextParser):
    def parse(self, text: str) -> LegalDocument:
        # Nova implementacija bez menjanja postojećeg koda
```

### Dependency Inversion
```python
# ✅ Zavisnosti od apstrakcija, ne konkretnih klasa
class AnnotateLegalDocumentUseCase:
    def __init__(
        self,
        parser: ILegalTextParser,      # ← Interface
        annotator: ISemanticAnnotator,  # ← Interface
        exporter: IDocumentExporter     # ← Interface
    ):
```

**Detaljno:** [ARCHITECTURE.md](ARCHITECTURE.md)

---

## 🔧 Proširivanje Sistema

### Dodavanje Novog Parsera

```python
from src.domain.interfaces.parsers import ILegalTextParser
from src.domain.entities.legal_document import LegalDocument

class NLPLegalTextParser(ILegalTextParser):
    """Parser baziran na NLP-u (spaCy, transformers)."""
    
    def parse(self, text: str) -> LegalDocument:
        # Tvoja implementacija
        pass
```

### Dodavanje Novog Exportera

```python
from src.domain.interfaces.exporters import IDocumentExporter

class LegalRuleMLExporter(IDocumentExporter):
    """Export u LegalRuleML format."""
    
    def export(self, document, annotations, output_path):
        # Tvoja implementacija
        pass
```

**Više primera:** [examples.py](examples.py)

---

## 🤝 Doprinos

### Code Style

```bash
# Format code
black src/

# Lint
flake8 src/

# Type check
mypy src/
```

### Commit Messages

```
feat: Add LegalRuleML exporter
fix: Correct parser regex pattern
docs: Update architecture documentation
test: Add unit tests for entities
refactor: Extract annotation logic to service
```

---

## 📖 Dodatni Resursi

- [Akoma Ntoso Standard](http://www.akomantoso.org/)
- [LegalRuleML](https://www.oasis-open.org/committees/legalruleml/)
- [Clean Architecture - Robert C. Martin](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [SOLID Principles](https://en.wikipedia.org/wiki/SOLID)

---

## 👥 Tim

**Tim 7** - Pravna Informatika 2025/2026

---

## 📝 Licenca

Akademski projekat - Univerzitet

---

## ❓ FAQ

**Q: Koji fajl da pokrenem?**  
A: `python main_refactored.py` - novi refaktorisan sistem

**Q: Moram li da menjam postojeći kod?**  
A: Ne! Stari `main.py` i dalje radi. Novi sistem je paralelna implementacija.

**Q: Kako testiram bez API tokena?**  
A: Koristi mock annotator - pogledaj `examples.py` primer 5.

**Q: Gde je dokumentacija za svaki modul?**  
A: Svaki Python fajl ima detaljne docstrings.

**Q: Kako dodajem nove funkcionalnosti?**  
A: Implementiraj odgovarajući interface i registruj u `DependencyContainer`.

**Q: Mogu li koristiti svoj LLM model?**  
A: Da! Postavi `LLM_PROVIDER` i `LLM_MODEL` u `.env` fajlu.

---

## 📞 Podrška

Za pitanja:
1. Proveri [MIGRATION_GUIDE.md](MIGRATION_GUIDE.md)
2. Pogledaj [examples.py](examples.py)
3. Čitaj docstrings u kodu
4. Konsultuj [ARCHITECTURE.md](ARCHITECTURE.md)

---

**Napravljeno sa ❤️ za Pravnu Informatiku**
