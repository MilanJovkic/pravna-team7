# Projekat: Pravna Informatika - Tim 7

## 📋 Pregled Projekta

Sistem za podršku sudijama u donošenju odluka, implementiran po **SOLID** principima i **Clean Architecture** paternima.

## ✅ Status Zadataka

### Zadatak 1: Akoma Ntoso Anotacija ✅ ZAVRŠENO
- ✅ Parsiranje pravnog teksta
- ✅ LLM semantička anotacija
- ✅ Akoma Ntoso XML export
- ✅ **REFAKTORISANO** po SOLID i Clean Architecture

### Buduće Implementacije (Pripremljeno)

#### Zadatak 2: Sudske Odluke
- 📁 Folder structure pripremnjen: `src/domain/entities/court_decision.py`
- 🔌 Interface definisan: `ICourtDecisionParser`

#### Zadatak 3: LegalRuleML
- 🔌 Interface: `IDocumentExporter` - spreman za LegalRuleML implementaciju

#### Zadatak 4: NLP Ekstrakcija
- 📁 Struktura: `src/infrastructure/nlp/`
- 🔌 Interface: `IFactExtractor` (kreirati)

#### Zadatak 5: Rule-Based Reasoning
- 📁 Struktura: `src/application/services/rule_engine.py`
- 🔗 dr-device integracija

#### Zadatak 6: Case-Based Reasoning
- 🔌 Interface: `ICaseRepository`
- 📁 Struktura: `src/application/services/similarity_service.py`

#### Zadatak 7-9: UI & Generisanje
- 📁 Web UI: `src/presentation/web/`
- 📁 REST API: `src/presentation/api/`

## 🏗️ Refaktorisana Arhitektura

```
src/
├── domain/              # ❤️ Jezgro sistema
│   ├── entities/        # Domain entiteti
│   └── interfaces/      # Apstraktni interfejsi
├── application/         # 🎯 Business logika
│   ├── use_cases/       # Use case implementacije
│   └── container.py     # Dependency injection
├── infrastructure/      # 🔧 Eksterne implementacije
│   ├── parsers/
│   ├── llm/
│   └── exporters/
└── presentation/        # 🖥️ Korisnički interfejs
    └── cli/
```

## 🎯 SOLID Principi

✅ **Single Responsibility** - Svaka klasa ima jednu odgovornost  
✅ **Open/Closed** - Otvoren za proširenje, zatvoren za modifikaciju  
✅ **Liskov Substitution** - Implementacije su zamenjive  
✅ **Interface Segregation** - Fokusirani interfejsi  
✅ **Dependency Inversion** - Zavisnosti od apstrakcija  

## 🚀 Quick Start

```bash
# 1. Instalacija
pip install -r requirements_refactored.txt

# 2. Konfiguracija (.env)
cp .env.template .env
# Dodaj API token u .env

# 3. Pokretanje
python main_refactored.py --input zakon.txt --output output.xml --limit 10

# 4. Testiranje
pytest
```

## 📚 Dokumentacija

- [README_REFACTORED.md](README_REFACTORED.md) - Detaljna dokumentacija
- [ARCHITECTURE.md](ARCHITECTURE.md) - Arhitekturni dizajn
- [MIGRATION_GUIDE.md](MIGRATION_GUIDE.md) - Prelazak sa starog sistema
- [examples.py](examples.py) - Primeri korišćenja

## 🧪 Testiranje

```bash
# Svi testovi
pytest

# Sa coverage
pytest --cov=src --cov-report=html

# Samo unit testovi
pytest tests/unit/

# Code quality
flake8 src/
mypy src/
```

## 📈 Sledeći Koraci

1. ✅ **Zadatak 1**: Kompletiran i refaktorisan
2. 🔄 **Zadatak 2**: Implementirati parsiranje sudskih odluka
3. 🔄 **Zadatak 3**: LegalRuleML export
4. 🔄 **Zadatak 4**: NLP ekstrakcija činjenica
5. 🔄 **Zadatak 5**: dr-device integracija
6. 🔄 **Zadatak 6**: jColibri integracija
7. 🔄 **Zadatak 7-9**: Web UI i generisanje odluka

## 👥 Tim

Tim 7 - Pravna Informatika 2025/2026

## 📝 Licenca

Akademski projekat
