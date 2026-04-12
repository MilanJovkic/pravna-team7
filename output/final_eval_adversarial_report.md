# Finalni evaluacioni izvestaj (5 zakljucanih presuda)

- Status: **PASS**
- Base URL: http://127.0.0.1:58338/api
- Protokol: 1.1.0-adversarial
- Prosecna ocena: 28.8 / 30
- Prag proseka: 25.0

## Tehnicke provere

- api_health: **PASS** - GET http://127.0.0.1:58338/health => 200
- case_save_and_reuse: **PASS** - Saved case CI-EVAL-PROBE confirmed in CBR matches

## Slucajevi

### ADV-1-MILD-NEGLIGENCE (ADV-K-001) - PASS (30/30)
- Stabilnost: stable
- pravna_tacnost: 5/5 (rule=ok; norme prisutne; clanovi prisutni; poklapanje sa ocekivanim clancima)
- logicka_konzistentnost: 5/5 (nema detektovanih kontradikcija)
- korisnost_za_korisnika: 5/5 (ima predlog vrste presude; ima predlog sankcije; vraceni slicni slucajevi; doprinos atributa dostupan)
- pokrivenost_kljucnih_cinjenica: 5/5 (pokriveno 6/6 kljucnih cinjenica)
- objasnjenje_zakljucka: 5/5 (tekstovi primenjenih clanova; sadrzaj clanova nije prazan; dr-device proofs prisutni; eksplicitne primenjene norme)
- proporcionalnost_sankcije: 5/5 (pozitivan ishod ima sankciju; sankcija sadrzi raspon/kvantifikaciju; uskladjeno sa laksom povredom)

### ADV-2-SEVERE-WEAPON (ADV-K-002) - PASS (28/30)
- Stabilnost: stable
- pravna_tacnost: 5/5 (rule=ok; norme prisutne; clanovi prisutni; poklapanje sa ocekivanim clancima)
- logicka_konzistentnost: 5/5 (nema detektovanih kontradikcija)
- korisnost_za_korisnika: 5/5 (ima predlog vrste presude; ima predlog sankcije; vraceni slicni slucajevi; doprinos atributa dostupan)
- pokrivenost_kljucnih_cinjenica: 5/5 (pokriveno 7/7 kljucnih cinjenica)
- objasnjenje_zakljucka: 5/5 (tekstovi primenjenih clanova; sadrzaj clanova nije prazan; dr-device proofs prisutni; eksplicitne primenjene norme)
- proporcionalnost_sankcije: 3/5 (pozitivan ishod ima sankciju; sankcija sadrzi raspon/kvantifikaciju)

### ADV-3-DEATH-RESULT (ADV-K-003) - PASS (28/30)
- Stabilnost: stable
- pravna_tacnost: 5/5 (rule=ok; norme prisutne; clanovi prisutni; poklapanje sa ocekivanim clancima)
- logicka_konzistentnost: 5/5 (nema detektovanih kontradikcija)
- korisnost_za_korisnika: 5/5 (ima predlog vrste presude; ima predlog sankcije; vraceni slicni slucajevi; doprinos atributa dostupan)
- pokrivenost_kljucnih_cinjenica: 5/5 (pokriveno 7/7 kljucnih cinjenica)
- objasnjenje_zakljucka: 5/5 (tekstovi primenjenih clanova; sadrzaj clanova nije prazan; dr-device proofs prisutni; eksplicitne primenjene norme)
- proporcionalnost_sankcije: 3/5 (pozitivan ishod ima sankciju; sankcija sadrzi raspon/kvantifikaciju)

### ADV-4-FIGHT-SERIOUS (ADV-K-004) - PASS (28/30)
- Stabilnost: stable
- pravna_tacnost: 5/5 (rule=ok; norme prisutne; clanovi prisutni; poklapanje sa ocekivanim clancima)
- logicka_konzistentnost: 5/5 (nema detektovanih kontradikcija)
- korisnost_za_korisnika: 5/5 (ima predlog vrste presude; ima predlog sankcije; vraceni slicni slucajevi; doprinos atributa dostupan)
- pokrivenost_kljucnih_cinjenica: 5/5 (pokriveno 7/7 kljucnih cinjenica)
- objasnjenje_zakljucka: 5/5 (tekstovi primenjenih clanova; sadrzaj clanova nije prazan; dr-device proofs prisutni; eksplicitne primenjene norme)
- proporcionalnost_sankcije: 3/5 (pozitivan ishod ima sankciju; sankcija sadrzi raspon/kvantifikaciju)

### ADV-5-LOW-EVIDENCE (ADV-K-005) - PASS (30/30)
- Stabilnost: stable
- pravna_tacnost: 5/5 (rule=ok; norme prisutne; clanovi prisutni; poklapanje sa ocekivanim clancima)
- logicka_konzistentnost: 5/5 (nema detektovanih kontradikcija)
- korisnost_za_korisnika: 5/5 (ima predlog vrste presude; ima predlog sankcije; vraceni slicni slucajevi; doprinos atributa dostupan)
- pokrivenost_kljucnih_cinjenica: 5/5 (pokriveno 6/6 kljucnih cinjenica)
- objasnjenje_zakljucka: 5/5 (tekstovi primenjenih clanova; sadrzaj clanova nije prazan; dr-device proofs prisutni; eksplicitne primenjene norme)
- proporcionalnost_sankcije: 5/5 (pozitivan ishod ima sankciju; sankcija sadrzi raspon/kvantifikaciju; uskladjeno sa laksom povredom)
