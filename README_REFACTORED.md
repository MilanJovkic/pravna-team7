# Refaktorisani Sistem za Pravnu Informatiku

Projekat refaktorisan po **SOLID** i **Clean Architecture** principima.

## 📁 Struktura Projekta

```
pravna-team7/
├── src/
│   ├── domain/              # Domain layer - jezgro biznisa
│   │   ├── entities/        # Domain entiteti (LegalDocument, Annotation)
│   │   └── interfaces/      # Interfejsi (parsers, annotators, exporters)
│   ├── application/         # Application layer - use cases
│   │   ├── use_cases/       # Use case implementacije
│   │   └── container.py     # Dependency injection container
│   ├── infrastructure/      # Infrastructure layer - eksterne implementacije
│   │   ├── parsers/         # Regex parser implementacija
│   │   ├── llm/             # LLM annotator implementacija
│   │   └── exporters/       # Akoma Ntoso exporter
│   └── presentation/        # Presentation layer - UI
│       └── cli/             # Command-line interface
├── config/                  # Konfiguracija
│   └── app_config.py        # Centralizovana konfiguracija
├── tests/                   # Testovi
│   ├── unit/                # Unit testovi
│   └── integration/         # Integration testovi
├── main_refactored.py       # Refaktorisani entry point
└── requirements_refactored.txt
```

## 🎯 SOLID Principi

### 1. **Single Responsibility Principle (SRP)**
- Svaka klasa ima jednu jasno definisanu odgovornost
- `RegexLegalTextParser` - samo parsiranje
- `LLMSemanticAnnotator` - samo anotacija
- `AkomaNtosoExporter` - samo export

### 2. **Open/Closed Principle (OCP)**
- Sistem otvoren za proširenje, zatvoren za modifikaciju
- Novi parseri mogu se dodati implementacijom `ILegalTextParser`
- Novi exporteri implementacijom `IDocumentExporter`

### 3. **Liskov Substitution Principle (LSP)**
- Sve implementacije mogu se zameniti bez narušavanja funkcionalnosti
- `RegexLegalTextParser` može se zameniti sa `NLPLegalTextParser`

### 4. **Interface Segregation Principle (ISP)**
- Interfejsi su fokusirani i specifični
- `ILegalTextParser`, `ISemanticAnnotator`, `IDocumentExporter`

### 5. **Dependency Inversion Principle (DIP)**
- Visoki nivoi zavise od apstrakcija, ne konkretnih implementacija
- `AnnotateLegalDocumentUseCase` zavisi od interfejsa
- Konkretne implementacije injektuju se kroz `DependencyContainer`

## 🏗️ Clean Architecture

### Slojevi (od unutra ka spolja):

1. **Domain Layer** (`src/domain/`)
   - Jezgro sistema, bez zavisnosti
   - Čiste business entitete i pravila
   - Interfejsi za外nje zavisnosti

2. **Application Layer** (`src/application/`)
   - Use cases - orkestracija business logike
   - Dependency injection container
   - Koordinacija između domain i infrastructure

3. **Infrastructure Layer** (`src/infrastructure/`)
   - Konkretne implementacije interfejsa
   - LLM integracija, parseri, exporteri
   - Eksterne zavisnosti (API, fajlovi)

4. **Presentation Layer** (`src/presentation/`)
   - CLI interface
   - Budući: Web UI, REST API

## 🚀 Pokretanje

### 1. Instalacija

```bash
pip install -r requirements_refactored.txt
```

### 2. Konfiguracija

Kreirati `.env` fajl:

```env
# LLM Provider
LLM_PROVIDER=github
LLM_MODEL=gpt-4o

# API Tokens
GITHUB_TOKEN=your_token_here
OPENROUTER_API_KEY=your_key_here

# Settings
LLM_MAX_REQUESTS_PER_MINUTE=10
LLM_MAX_RETRIES=3

# Law Metadata
LAW_NAME=Krivični zakonik Crne Gore
COUNTRY_CODE=me
LAW_YEAR=2024
```

### 3. Pokretanje

```bash
# Osnovn usage
python main_refactored.py --input zakon.txt --output output.xml

# Sa limitom (testiranje)
python main_refactored.py --input zakon.txt --output output.xml --limit 10

# Sa OpenRouter providerom
python main_refactored.py --provider openrouter --model gpt-4o
```

## 🧪 Testiranje

```bash
# Pokreni sve testove
pytest

# Sa coverage reportom
pytest --cov=src tests/

# Samo unit testovi
pytest tests/unit/

# Samo integration testovi
pytest tests/integration/
```

## 📝 Dodavanje Novih Funkcionalnosti

### Novi Parser

```python
from src.domain.interfaces.parsers import ILegalTextParser

class MyCustomParser(ILegalTextParser):
    def parse(self, text: str) -> LegalDocument:
        # Implementacija
        pass
```

### Novi Annotator

```python
from src.domain.interfaces.annotators import ISemanticAnnotator

class MyCustomAnnotator(ISemanticAnnotator):
    def annotate_article(self, article: LegalArticle) -> SemanticAnnotation:
        # Implementacija
        pass
```

### Novi Exporter

```python
from src.domain.interfaces.exporters import IDocumentExporter

class MyCustomExporter(IDocumentExporter):
    def export(self, document, annotations, output_path) -> str:
        # Implementacija
        pass
```

## 🎓 Priprema za Buduće Zadatke

Sistem je spreman za:

### ✅ Zadatak 2: Sudske Odluke
- Dodati `CourtDecision` entitet u `domain/entities/`
- Implementirati `CourtDecisionParser` u `infrastructure/parsers/`

### ✅ Zadatak 3: LegalRuleML
- Dodati `LegalRuleMLExporter` u `infrastructure/exporters/`
- Implementirati `IDocumentExporter` interface

### ✅ Zadatak 4: NLP Ekstrakcija
- Dodati `NLPExtractor` u `infrastructure/nlp/`
- Kreirati `IFactExtractor` interface u `domain/interfaces/`

### ✅ Zadatak 5: Rasudivanje po Pravilima
- Dodati `RuleEngine` u `application/services/`
- Integracija sa dr-device alatom

### ✅ Zadatak 6: Case-Based Reasoning
- Dodati `CaseRepository` implementaciju
- Kreirati `SimilarityService` u `application/services/`

### ✅ Zadatak 7-9: UI i Generisanje
- Web UI u `presentation/web/`
- REST API u `presentation/api/`
- Document generation service

## 🔧 Konfiguracija i Dependency Injection

Container automatski kreira i upravlja zavisnostima:

```python
from src.config.app_config import ApplicationConfig
from src.application.container import DependencyContainer

# Učitaj konfiguraciju
config = ApplicationConfig.from_env()

# Kreiraj container
container = DependencyContainer(config)

# Dobij use case (sa svim zavisnostima)
use_case = container.get_annotate_document_use_case()
```

## 📊 Benefits Refaktorisanja

1. **Testabilnost** - Lako unit testiranje zahvaljujući dependency injection
2. **Održivost** - Jasna separacija odgovornosti
3. **Proširivost** - Lako dodavanje novih funkcionalnosti
4. **Čitljivost** - Organizovana struktura
5. **Ponovana Upotreba** - Domain entiteti nezavisni od implementacije
6. **Sigurnost** - Type hints i validacija

## 📚 Dokumentacija

Svaki modul ima detaljnu dokumentaciju:
- Docstrings po Google/NumPy style
- Type hints za sve javne metode
- Primeri upotrebe u docstrings

## 🤝 Doprinosi

Sistem dizajniran za timski rad:
- Jasne granice između modula
- Dependency injection omogućava paralelni razvoj
- Testovi kao dokumentacija
