# Uputstvo za Prelazak sa Starog na Novi Sistem

## Brzi Start

### 1. Instaliraj dependencies

```bash
pip install -r requirements_refactored.txt
```

### 2. Koristi novi entry point

```bash
# Stari način
python main.py --input zakon.txt --output output.xml --limit 10

# Novi način (ista komanda!)
python main_refactored.py --input zakon.txt --output output.xml --limit 10
```

## Glavne Izmene

### Pre (Stari Kod)

```python
# main.py
from legal_parser import LegalTextParser
from llm_annotator import LLMAnnotator
from akoma_exporter import AkomaExporter

parser = LegalTextParser()
annotator = LLMAnnotator()
exporter = AkomaExporter()
```

### Posle (Novi Kod)

```python
# main_refactored.py
from src.config.app_config import ApplicationConfig
from src.application.container import DependencyContainer

config = ApplicationConfig.from_env()
container = DependencyContainer(config)
use_case = container.get_annotate_document_use_case()
```

## Mapiranje Starih na Nove Module

| Stari Fajl | Novi Fajl | Lokacija |
|------------|-----------|----------|
| `legal_parser.py` | `regex_parser.py` | `src/infrastructure/parsers/` |
| `llm_annotator.py` | `llm_annotator.py` | `src/infrastructure/llm/` |
| `akoma_exporter.py` | `akoma_exporter.py` | `src/infrastructure/exporters/` |
| `main.py` | `main.py` | `src/presentation/cli/` |

## Šta je Novo?

### 1. Domain Entities (Čiste Domain Klase)

```python
from src.domain.entities import LegalDocument, LegalArticle, SemanticAnnotation

# Entiteti su sada nezavisni od infrastrukture
doc = LegalDocument(name="Zakon", country_code="me")
```

### 2. Interfaces (Apstrakcije)

```python
from src.domain.interfaces import ILegalTextParser

# Možeš implementirati svoj parser
class MyParser(ILegalTextParser):
    def parse(self, text: str) -> LegalDocument:
        # Tvoja implementacija
```

### 3. Dependency Injection

```python
# Automatsko kreiranje i povezivanje zavisnosti
container = DependencyContainer(config)
use_case = container.get_annotate_document_use_case()
```

### 4. Configuration Management

```python
# Centralizovana konfiguracija iz .env
config = ApplicationConfig.from_env()
```

### 5. Testovi

```bash
# Pokreni testove
pytest

# Sa coverage
pytest --cov=src tests/
```

## Migracija Postojećeg Koda

### Scenario 1: Koristiš Parser

**Pre:**
```python
from legal_parser import LegalTextParser

parser = LegalTextParser()
chapters = parser.parse(text)
```

**Posle:**
```python
from src.infrastructure.parsers import RegexLegalTextParser

parser = RegexLegalTextParser()
document = parser.parse(text)
chapters = document.chapters
```

### Scenario 2: Koristiš Annotator

**Pre:**
```python
from llm_annotator import LLMAnnotator

annotator = LLMAnnotator(api_token="xxx", model="gpt-4o")
annotations = annotator.annotate_batch(articles)
```

**Posle:**
```python
from src.infrastructure.llm import LLMSemanticAnnotator
from src.domain.entities import LegalArticle

annotator = LLMSemanticAnnotator(
    provider="github",
    model="gpt-4o",
    api_token="xxx"
)
# articles mora biti lista LegalArticle objekata
annotations = annotator.annotate_batch(articles)
```

### Scenario 3: Koristiš Exporter

**Pre:**
```python
from akoma_exporter import AkomaExporter

exporter = AkomaExporter()
exporter.export(chapters, annotations, "output.xml")
```

**Posle:**
```python
from src.infrastructure.exporters import AkomaNtosoExporter
from src.domain.entities import LegalDocument

exporter = AkomaNtosoExporter()
exporter.export(document, annotations, "output.xml")
```

## Kompatibilnost

### Stari fajlovi I DALJE RADE!

- `main.py` - stara implementacija
- `legal_parser.py` - stara implementacija
- `llm_annotator.py` - stara implementacija
- `akoma_exporter.py` - stara implementacija

### Novi fajlovi su dodatak, ne zamena

- `main_refactored.py` - nova implementacija
- `src/` - nova arhitektura

### Postepeni prelazak

1. **Faza 1**: Koristi `main_refactored.py` umesto `main.py`
2. **Faza 2**: Počni koristiti nove module u svom kodu
3. **Faza 3**: Dodaj testove koristeći dependency injection
4. **Faza 4**: Eventualno obriši stare fajlove

## FAQ

### Q: Da li moram da menjam postojeći kod?
**A:** Ne! Stari kod i dalje radi. Novi sistem je paralelna implementacija.

### Q: Kako testiram novi sistem?
**A:** Pokreni `python main_refactored.py --limit 5` da testiraš sa 5 članaka.

### Q: Šta ako nešto ne radi?
**A:** Uvek možeš koristiti stari `main.py`. Novi sistem je eksperimentalan.

### Q: Kako koristim dependency injection?
**A:** Pogledaj `examples.py` - ima sve primere!

### Q: Mogu li dodati svoj parser/annotator/exporter?
**A:** Da! Implementiraj odgovarajući interface iz `src/domain/interfaces/`.

### Q: Gde je dokumentacija?
**A:** 
- `README_REFACTORED.md` - Opšte uputstvo
- `ARCHITECTURE.md` - Detaljna arhitektura
- `examples.py` - Primeri korišćenja

## Prednosti Novog Sistema

✅ **Testabilnost** - Lako pisanje unit testova  
✅ **Održivost** - Jasna organizacija koda  
✅ **Proširivost** - Lako dodavanje novih funkcionalnosti  
✅ **Dokumentacija** - Sve ima docstrings  
✅ **Type Safety** - Type hints za sve metode  
✅ **Dependency Injection** - Laka zamena komponenti  

## Sledeći Koraci

1. Instaliraj novi requirements: `pip install -r requirements_refactored.txt`
2. Pokreni testove: `pytest`
3. Probaj primere: `python examples.py`
4. Pokreni novi sistem: `python main_refactored.py --limit 5`
5. Pročitaj `ARCHITECTURE.md` za detalje

## Podrška

Za pitanja i pomoć:
- Pogledaj `examples.py` za primere
- Čitaj docstrings u kodu
- Konsultuj `ARCHITECTURE.md`
