# 📖 Dokumentacija - Index

## 🎯 Početak - Čitaj Ovde Prvo!

### Za Brzince
👉 [QUICK_START.md](QUICK_START.md) - 2 minuta, testovi bez API-ja

### Za Sve Ostale
👉 [README_NEW.md](README_NEW.md) - Glavni README sa kompletnim pregledom

### Kratak Pregled
👉 [REFACTORING_SUMMARY.md](REFACTORING_SUMMARY.md) - Šta je urađeno i zašto

---

## 📚 Sva Dokumentacija

| Dokument | Opis | Vreme Čitanja | Za Koga |
|----------|------|---------------|---------|
| **[QUICK_START.md](QUICK_START.md)** | Brzi start, testiranje | 2-10 min | 🚀 Svi |
| **[README_NEW.md](README_NEW.md)** | Glavni README | 15-20 min | 👥 Svi |
| **[REFACTORING_SUMMARY.md](REFACTORING_SUMMARY.md)** | Kratak pregled | 5 min | 📊 Pregled |
| **[README_REFACTORED.md](README_REFACTORED.md)** | Detaljna dokumentacija | 20-30 min | 📖 Detaljno |
| **[ARCHITECTURE.md](ARCHITECTURE.md)** | Arhitektura i design | 30-45 min | 👨‍💻 Dev |
| **[MIGRATION_GUIDE.md](MIGRATION_GUIDE.md)** | Prelazak sa starog sistema | 15 min | 🔄 Migracija |
| **[PROJECT_STATUS.md](PROJECT_STATUS.md)** | Status svih zadataka | 5 min | 📊 Status |
| **[examples.py](examples.py)** | 6 praktičnih primera | 10-15 min | 💡 Praksa |

---

## 🗺️ Mapa Dokumentacije

```
📁 pravna-team7/
│
├── 🚀 QUICK_START.md          ← POČNI OVDE!
├── 📖 README_NEW.md            ← Glavni README
├── 📊 REFACTORING_SUMMARY.md  ← Kratak pregled
│
├── 📚 Detaljna Dokumentacija:
│   ├── README_REFACTORED.md   ← Sve o sistemu
│   ├── ARCHITECTURE.md        ← Design i principi
│   ├── MIGRATION_GUIDE.md     ← Kako preći sa starog
│   └── PROJECT_STATUS.md      ← Status zadataka
│
├── 💡 Primeri:
│   └── examples.py            ← 6 praktičnih primera
│
└── 📋 Specifikacija:
    └── spec.txt               ← Zadatak profesora
```

---

## 📖 Kako Čitati (Preporučeno)

### Scenario 1: Nov Na Projektu
1. [QUICK_START.md](QUICK_START.md) - Brzi test (2 min)
2. [README_NEW.md](README_NEW.md) - Glavni README (15 min)
3. [examples.py](examples.py) - Pokreni primere (10 min)
4. [ARCHITECTURE.md](ARCHITECTURE.md) - Razumevanje sistema (30 min)

### Scenario 2: Migriram Sa Starog Sistema
1. [MIGRATION_GUIDE.md](MIGRATION_GUIDE.md) - Kako preći (15 min)
2. [REFACTORING_SUMMARY.md](REFACTORING_SUMMARY.md) - Šta je novo (5 min)
3. [examples.py](examples.py) - Novi način korišćenja (10 min)

### Scenario 3: Implementiram Novi Zadatak
1. [ARCHITECTURE.md](ARCHITECTURE.md) - Razumem dizajn (30 min)
2. [examples.py](examples.py) - Vidim kako se proširuje (10 min)
3. [README_REFACTORED.md](README_REFACTORED.md) - Detalji (20 min)
4. Čitaj docstrings u kodu

### Scenario 4: Samo Brzo Testiram
1. [QUICK_START.md](QUICK_START.md) - Sve što treba (5 min)

---

## 🎯 Po Temi

### SOLID Principi
- [ARCHITECTURE.md](ARCHITECTURE.md#solid-principles-implementation) - Detaljna implementacija
- [README_NEW.md](README_NEW.md#solid-principi-u-praksi) - Brz pregled
- Kod sa `# ✅ SRP`, `# ✅ OCP` komentarima

### Clean Architecture
- [ARCHITECTURE.md](ARCHITECTURE.md#clean-architecture-layers) - Slojevi
- [README_REFACTORED.md](README_REFACTORED.md#clean-architecture) - Dijagrami
- [REFACTORING_SUMMARY.md](REFACTORING_SUMMARY.md#clean-architecture) - Kratak prikaz

### Dependency Injection
- [ARCHITECTURE.md](ARCHITECTURE.md#design-patterns) - Patterns
- [examples.py](examples.py) - Primer 5 (dependency injection)
- `src/application/container.py` - Implementacija

### Testiranje
- [README_NEW.md](README_NEW.md#testiranje) - Kako testirati
- [QUICK_START.md](QUICK_START.md) - Brzi testovi
- `tests/` direktorijum - Primeri testova

### Proširivanje
- [ARCHITECTURE.md](ARCHITECTURE.md#extensibility-guide) - Kako dodati nove funkcionalnosti
- [README_REFACTORED.md](README_REFACTORED.md#dodavanje-novih-funkcionalnosti) - Primeri
- [examples.py](examples.py) - Primer 6 (custom exporter)

---

## 🔍 Brza Pretraga

### Tražim...

**"Kako da počnem?"**  
→ [QUICK_START.md](QUICK_START.md)

**"Šta je novo u refaktorisanom sistemu?"**  
→ [REFACTORING_SUMMARY.md](REFACTORING_SUMMARY.md)

**"Kako koristiti novi sistem?"**  
→ [README_NEW.md](README_NEW.md) ili [examples.py](examples.py)

**"Kako preći sa starog sistema?"**  
→ [MIGRATION_GUIDE.md](MIGRATION_GUIDE.md)

**"Kako funkcioniše arhitektura?"**  
→ [ARCHITECTURE.md](ARCHITECTURE.md)

**"Kako implementirati zadatak 2/3/4...?"**  
→ [ARCHITECTURE.md#extensibility-guide](ARCHITECTURE.md) + [README_REFACTORED.md](README_REFACTORED.md)

**"Gde su primeri koda?"**  
→ [examples.py](examples.py) - 6 detaljnih primera

**"Kako testirati?"**  
→ [QUICK_START.md](QUICK_START.md) ili `pytest tests/unit/`

**"Šta je status projekta?"**  
→ [PROJECT_STATUS.md](PROJECT_STATUS.md)

---

## 📝 Dodatni Resursi

### U Kodu
- Svaki `.py` fajl ima detaljne **docstrings**
- **Type hints** na svim javnim metodama
- **Komentari** sa objašnjenjima SOLID principa

### Eksterne Reference
- [Akoma Ntoso Standard](http://www.akomantoso.org/) - XML format
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html) - Dizajn principi
- [SOLID Principles](https://en.wikipedia.org/wiki/SOLID) - Wikipedia

---

## ✅ Šta Pročitati Za Svaki Zadatak

### Zadatak 1 (Završen)
- ✅ [README_NEW.md](README_NEW.md)
- ✅ Pokreni: `python main_refactored.py --limit 5`

### Zadatak 2-9 (Implementacija)
- 📖 [ARCHITECTURE.md](ARCHITECTURE.md) - Kako proširiti
- 💡 [examples.py](examples.py) - Primeri 2 i 6
- 📂 `src/domain/interfaces/` - Interfejsi za implementaciju

---

## 🆘 Problem Solving

**Dokumentacija nije jasna?**  
→ Čitaj docstrings u kodu - ima više detalja

**Ne razumem arhitekturu?**  
→ [ARCHITECTURE.md](ARCHITECTURE.md) pa [examples.py](examples.py)

**Import errors?**  
→ [QUICK_START.md](QUICK_START.md#problem-solving)

**Kako dodati novu funkcionalnost?**  
→ [ARCHITECTURE.md#extensibility-guide](ARCHITECTURE.md)

---

## 📊 Statistika Dokumentacije

- **Markdown fajlova:** 8
- **Stranica dokumentacije:** ~100+
- **Primera koda:** 6 detaljnih + mnogostrukih mini primera
- **Dijagrama:** 5+
- **Tabela:** 10+

---

## 🎓 Zaključak

Projekat ima **ekstenzivnu dokumentaciju** koja pokriva:
- ✅ Quick start za početnike
- ✅ Detaljnu arhitekturu za developere
- ✅ Migraciju za postojeće korisnike
- ✅ Praktične primere
- ✅ Status i plan rada

**Sve što treba znaš je ovde! 🎉**

---

**Počni sa:** [QUICK_START.md](QUICK_START.md) → [README_NEW.md](README_NEW.md) → [examples.py](examples.py)

---

*Dokumentacija ažurirana: 2026-02-07*  
*Tim 7 - Pravna Informatika*
