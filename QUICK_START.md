# 🚀 QUICK START - Za One Koji Brze!

## Za Brzince (2 minuta)

```bash
# 1. Instaliraj
pip install requests python-dotenv pytest

# 2. Test domain entiteta
python -c "from src.domain.entities import LegalDocument; print('✓ Radi!')"

# 3. Test parser
python -c "from src.infrastructure.parsers import RegexLegalTextParser; print('✓ Radi!')"

# 4. Test config
python -c "from config.app_config import ApplicationConfig; print('✓ Radi!')"
```

✅ Ako sve ovo prođe - sistem radi!

---

## Za Malo Sporije (5 minuta)

### 1. Setup

```bash
pip install -r requirements_refactored.txt
```

### 2. Konfiguracija

```bash
# Kreiraj .env fajl
echo "LLM_PROVIDER=github" > .env
echo "GITHUB_TOKEN=tvoj_token_ovde" >> .env
```

### 3. Test Run (BEZ API tokena!)

```python
# test_basic.py
from src.domain.entities.legal_document import LegalDocument, LegalChapter, LegalArticle, LegalParagraph

# Kreiraj test dokument
doc = LegalDocument(name="Test Zakon", country_code="me")
chapter = LegalChapter(number="I", title="Test Glava")
article = LegalArticle(number="1", title="Test Član")
para = LegalParagraph(number=None, text="Test tekst", raw_text="Test")

article.add_paragraph(para)
chapter.add_article(article)
doc.add_chapter(chapter)

print(f"✓ Dokument: {doc.name}")
print(f"✓ Članaka: {doc.total_articles()}")
print(f"✓ Tekst: {article.get_full_text()}")
```

```bash
python test_basic.py
```

### 4. Pokreni Testove

```bash
pytest tests/unit/ -v
```

---

## Za Ozbiljne (10 minuta)

### Kompletna Setup

```bash
# 1. Virtual environment
python -m venv venv
venv\Scripts\activate  # Windows
# source venv/bin/activate  # Linux/Mac

# 2. Dependencies
pip install -r requirements_refactored.txt

# 3. .env konfiguracija
cp .env.template .env
# Dodaj API token u .env

# 4. Test da sve radi
pytest -v

# 5. Pokreni primere
python examples.py

# 6. Test annotation (sa API tokenom)
python main_refactored.py --input zakon.txt --output test.xml --limit 5
```

---

## 🎯 Najčešće Komande

```bash
# Test jednostavnih stvari (BEZ API-ja)
pytest tests/unit/test_entities.py -v

# Test parsera (BEZ API-ja)
pytest tests/unit/test_parsers.py -v

# Pokreni primere (BEZ API-ja, osim primera 1 i 5)
python examples.py

# Test annotation pipeline (TREBA API token)
python main_refactored.py --limit 3
```

---

## ✅ Checklist

- [ ] Python 3.9+ instaliran
- [ ] Dependencies instalirane (`pip install -r requirements_refactored.txt`)
- [ ] Import testovi prolaze (domain, infrastructure, config)
- [ ] Unit testovi prolaze (`pytest tests/unit/`)
- [ ] .env fajl kreiran (za API testove)
- [ ] Primeri rade (`python examples.py`)

---

## 🆘 Problem Solving

### Import Error?

```bash
# Proveri da si u pravom direktorijumu
cd c:\Users\Korisnik\Desktop\pravna\pravna-team7

# Proveri Python path
python -c "import sys; print(sys.path)"
```

### Module Not Found?

```bash
# Reinstaliraj
pip install -r requirements_refactored.txt --force-reinstall
```

### API Token Error?

```bash
# Proveri .env
cat .env  # Linux/Mac
type .env  # Windows

# Za testiranje BEZ API-ja, koristi:
pytest tests/unit/  # Ne poziva API
python examples.py  # Primeri 2, 3, 4, 6 ne koriste API
```

---

## 🎓 Šta Dalje?

1. ✅ Pročitaj [README_NEW.md](README_NEW.md) - glavni README
2. ✅ Pogledaj [examples.py](examples.py) - praktični primeri
3. ✅ Čitaj [ARCHITECTURE.md](ARCHITECTURE.md) - kako funkcioniše
4. ✅ Testiraj stvari - `pytest`
5. ✅ Implementiraj novi zadatak!

---

## 💡 Brzi Testovi (Copy-Paste)

### Test 1: Domain Entities

```python
from src.domain.entities import LegalDocument, LegalArticle, SemanticAnnotation, NormType

doc = LegalDocument(name="Test", country_code="me")
print(f"✓ Document created: {doc.name}")

article = LegalArticle(number="1", title="Test")
print(f"✓ Article created: {article.number}")

ann = SemanticAnnotation(
    article_number="1",
    norm_type=NormType.PROHIBITION,
    subjects=["test"],
    conditions=[],
    legal_concepts=[]
)
print(f"✓ Annotation created: {ann.norm_type.value}")
```

### Test 2: Parser

```python
from src.infrastructure.parsers import RegexLegalTextParser

parser = RegexLegalTextParser()
print(f"✓ Parser created")

text = """GLAVA I
TEST

Član 1
Test text."""

doc = parser.parse(text)
print(f"✓ Parsed: {doc.total_chapters()} chapters, {doc.total_articles()} articles")
```

### Test 3: Configuration

```python
from config.app_config import ApplicationConfig

try:
    config = ApplicationConfig.from_env()
    print(f"✓ Config loaded: Provider={config.llm.provider}, Model={config.llm.model}")
except Exception as e:
    print(f"⚠ Config error (normal if no .env): {e}")
```

### Test 4: Dependency Container

```python
from config.app_config import ApplicationConfig, LLMConfig, ParserConfig, ExporterConfig
from src.application.container import DependencyContainer

# Kreiraj test config (BEZ API tokena)
config = ApplicationConfig(
    llm=LLMConfig(provider="github", model="test", api_token="test"),
    parser=ParserConfig(),
    exporter=ExporterConfig()
)

container = DependencyContainer(config)
parser = container.get_parser()
exporter = container.get_exporter()

print(f"✓ Container created")
print(f"✓ Parser: {type(parser).__name__}")
print(f"✓ Exporter: {type(exporter).__name__}")
```

---

**Sve radi? Super! Sada pogledaj [README_NEW.md](README_NEW.md) za više! 🎉**
