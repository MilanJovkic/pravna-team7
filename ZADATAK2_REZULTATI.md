# Zadatak 2: Sudske Odluke - Rezultati

## Ekstrahovano i anotirano presuda: 5

Sve presude pripadaju **krivičnoj oblasti prava** i direktno referiraju **Krivični zakonik Crne Gore**, 
što ih čini relevantnim za Zadatak 1 (zakon koji je anotiran).

## Lista presuda

1. **Одлуке** (K.br.781/18) - 27.03.2019
   - Krivično djelo: Teška tjelesna povreda (član 151)
   - Kazna: Uslovna osuda 6 mjeseci zatvora
   - Ishod: Усвојено

2. **Одлуке1** (K.br.780/18) - 10.09.2015
   - Krivično djelo: Teška tjelesna povreda (član 151)
   - Kazna: 5 mjeseci zatvora
   - Ishod: Усвојено

3. **Одлуке2** (K.br.265/2024) - 19.03.2024
   - Krivično djelo: Teška tjelesna povreda (član 151)
   - Kazna: 120 časova rada u javnom interesu
   - Ishod: Усвојено

4. **Одлуке3** (K.br.834/18) - 24.01.2019
   - Krivično djelo: Laka tjelesna povreda
   - Kazna: Uslovna osuda 3 mjeseca
   - Ishod: Усвојено

5. **Одлуке4** (Kž.br.190/19) - 25.03.2019
   - Krivično djelo: Učestvovanje u tuči sa teškom tjelesnom povredom
   - Kazna: 360 časova rada u javnom interesu
   - Ishod: Усвојено

## Reference na zakone

Sve presude referiraju:
- **Krivični zakonik Crne Gore** (5/5 presuda)
- **Zakonik o krivičnom postupku** (4/5 presuda)

Referencirani članci iz Krivičnog zakonika:
- Član 151 (Teška tjelesna povreda) - najčešće
- Član 143 (Ubistvo)
- Član 144 (Laka tjelesna povreda)
- Član 153 (Učestvovanje u tuči)
- Članovi 3, 4, 5, 13, 15, 32, 36, 42, 45, 46, 52, 53, 54 (Opšti deo)

## Formati izvoza

Za svaku presudu generisani su:

1. **XML fajl** (Akoma Ntoso judgment format)
   - Lokacija: `data/verdicts_xml/`
   - Primjer: `data/verdicts_xml/Одлуке.xml`
   - Struktura:
     - `<header>`: Broj predmeta, sud, datum, sudije
     - `<introduction>`: Rezime, pravna pitanja
     - `<background>`: Primenjeni zakoni i članci
     - `<motivation>`: Pravno obrazloženje
     - `<decision>`: Odluka suda i ishod

2. **JSON sa anotacijama**
   - Lokacija: `data/verdicts_xml/verdicts_annotations.json`
   - Sadrži semantičku analizu svih presuda

3. **Tekstualni rezime**
   - Lokacija: `verdict_summary.txt`
   - Čitljiv pregled svih presuda

## Učitavanje i prikaz

Projekat sadrži `view_verdicts.py` za:

### Listanje presuda
```bash
python view_verdicts.py list
```

### Prikaz detalja
```bash
python view_verdicts.py show Одлуке
```

### Pretraga po zakonu
```bash
python view_verdicts.py search "Krivični zakonik"
```

### Export rezimea
```bash
python view_verdicts.py export output.txt
```

## Pokrivenost zahteva Zadatka 2

✅ **Odabir sudskih odluka**: 5 presuda iz krivične oblasti  
✅ **Anotacija tekstova**: Broj predmeta, stranke, sudije, organizacije, reference  
✅ **XML formatiacija**: Akoma Ntoso judgment format  
✅ **Učitavanje i pregled**: `view_verdicts.py` modul  
✅ **Provera referenci**: Sve presude referiraju Krivični zakonik Crne Gore (anotiran u Zadatku 1)  

## Tehnička realizacija

- **PDF ekstrakcija**: PyPDF2 biblioteka
- **Parsiranje**: Regex-based parser za strukture presude
- **LLM anotacija**: GitHub Models / OpenRouter API
- **XML format**: Akoma Ntoso 3.0 judgment schema
- **Pregled**: Python CLI viewer sa pretragom i exportom
