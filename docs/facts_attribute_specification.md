# Specifikacija Atributa Za Pravni Ekspertni Sistem

Ovaj dokument formalizuje skup atributa za unos cinjenica kroz 6 logickih grupa.
Skup pokriva cl. 143-157 i koristi se za rule-based grananje i CBR kontekst.

## 1) Podaci O Zrtvi

| Naziv polja | Tip inputa | Moguce vrijednosti | Clan zakona |
|---|---|---|---|
| Status zrtve | Checkbox | dijete, bremenita_zena, clan_porodice, sluzbeno_lice, vojno_lice, punoljetno_lice, maloljetnik, nemocno_lice | 144, 147, 149, 156 |
| Zdravstveno stanje zrtve | Radio | tesko_zdravstveno_stanje, uredno_zdravlje, nepoznato | 147 |
| Uracunljivost zrtve | Radio | uracunljiva, bitno_smanjena, neuracunljiva | 149 |
| Zrtva prethodno zlostavljana | Radio | da, ne | 144 st. 7 |
| Broj zrtava | Radio | jedna, vise | 144 st. 8 |
| Ozbiljan i izricit zahtjev zrtve | Radio | da, ne, nije_primjenljivo | 147, 149 st. 2 |
| Zrtva u odnosu podredjenosti | Radio | da, ne | 149 st. 5 |

## 2) Ishod / Posljedica Djela

| Naziv polja | Tip inputa | Moguce vrijednosti | Clan zakona |
|---|---|---|---|
| Vrsta posljedice po zivot | Radio | smrt_nastupila, pokusaj, tjelesna_povreda | 143-157 |
| Stepen tjelesne povrede | Dropdown | laka, teska, narusenje_zdravlja | 151, 152 |
| Specificne posljedice teske povrede | Checkbox | opasnost_po_zivot, unistenje_dijela_tijela, trajno_ostecenje_organa, trajna_nesposobnost_za_rad, trajno_naruseno_zdravlje, unakazenost | 151 st. 2 |
| Opasnost dovedena i za treca lica | Radio | da, ne | 144 st. 3 |
| Samoubistvo: izvrseno ili pokusano | Radio | izvrseno, pokusano, nije_primjenljivo | 149 |
| Ishod pobacaja | Checkbox | pobacaj_izvrsen, pobacaj_zapocet, smrt_zene, teska_povreda_zene | 150 |

## 3) Nacin Izvrsenja I Motiv

| Naziv polja | Tip inputa | Moguce vrijednosti | Clan zakona |
|---|---|---|---|
| Nacin lisenja zivota / vrsenja djela | Checkbox | svirep_nacin, podmukao_nacin, bezobzirno_nasilje, na_mah, iz_nehata, upotrebom_sile, prijetnjom | 143-148, 151b |
| Motiv izvrsioca | Checkbox | koristoljublje, bezobzirna_osveta, niske_pobude, samilost, prikrivanje_drugog_kd, izvrsenje_drugog_kd | 144 st. 4, 147 |
| Izazvanost (provokacija) | Checkbox | napad_od_ubijenog, zlostavljanje_od_ubijenog, tesko_vrijedjanje_od_ubijenog, bez_krivice_ucinioca | 145, 151 st. 5 |
| Sredstvo izvrsenja (kod povrede) | Radio | oruzje, opasno_orudje, sredstvo_podobno_za_tesku_povredu, ostalo | 152, 154 |
| Pristanak zrtve na djelo | Radio | sa_pristankom, bez_pristanka | 150 |
| Cilj sterilizacije | Radio | onemogucavanje_reprodukcije, nije_primjenljivo | 151b |

## 4) Subjektivni Odnos (Krivnja)

| Naziv polja | Tip inputa | Moguce vrijednosti | Clan zakona |
|---|---|---|---|
| Oblik krivnje | Radio | umisljaj_direktni, umisljaj_eventualni, nehat | 143-157 |
| Psihicko stanje ucinioca | Radio | normalno_stanje, jaka_razdrazenost_na_mah, porodjajni_poremecaj | 145, 146 |
| Smrt pripisiva nehatu ucinioca | Radio | da, ne, nije_primjenljivo | 149 st. 5 |

## 5) Okolnosti Napustanja / Nepruzanja Pomoci

| Naziv polja | Tip inputa | Moguce vrijednosti | Clan zakona |
|---|---|---|---|
| Opasnost prouzrokovana od strane ucinioca | Radio | da, ne | 155 |
| Odnos ucinioca prema zrtvi | Dropdown | povjereno_nemocno_lice, duznost_staranja, prolaznik | 155, 156, 157 |
| Mogucnost pruzanja pomoci | Radio | mogao_bez_opasnosti, nije_mogao | 157 |
| Posljedica nepruzanja pomoci | Radio | bez_posljedica, teska_povreda_ili_narusenje_zdravlja, smrt | 155, 156, 157 |

## 6) Kontekst Vrsenja Sluzbe I Posebne Radnje

| Naziv polja | Tip inputa | Moguce vrijednosti | Clan zakona |
|---|---|---|---|
| Veza sa vrsenjem sluzbene duznosti | Radio | pri_vrsenju_duznosti, u_vezi_sa_vrsenjem_duznosti, ne | 144 st. 5 |
| Ucesce u tuci | Radio | da, ne | 153, 154 |
| Vrsta posebne radnje | Checkbox | sakacenje_zenskih_genitalija, prisilna_sterilizacija, navodjenje_na_samoubistvo, pomaganje_u_samoubistvu, nelegalni_pobacaj, hvatanje_oruzja_pri_svadji | 149, 150, 151a, 151b, 154 |
| Surovo / necovjecno postupanje | Radio | da, ne | 149 st. 5 |

## Implementacione Napomene

- Kriticni atributi za razgranavanje: guilt_form, victim_status, offender_psych_state, victim_explicit_request.
- Preporuceni UI: wizard po granama (lisenje zivota, tjelesna povreda, napustanje/pomoc, posebne radnje).
- U API modelu ova polja su opciona radi backward kompatibilnosti.
- CBR trenutno koristi primarni skup atributa; prosirenje feature-a moze se uraditi fazno.
