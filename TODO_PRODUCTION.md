# TODO - Rigorozni Plan Popravki (Posle Stress-Test Revizije)

Ovaj plan pokriva sve zakljucke revizije i organizovan je po prioritetu i redosledu implementacije.
Napomena o obimu: broj sudskih odluka ostaje minimum 5 u ovoj fazi (namerno, zbog troska LLM tokena).

## Faza 0 - Pravila projekta i kriterijumi uspeha

- [x] Definisi "Definition of Done" po svakoj od 9 tacki specifikacije
  Razlog: Trenutno postoji vise implicitnih tumacenja sta znaci "zavrseno".
  Ocekivani ishod: Jedinstven dokument sa jasnim acceptance kriterijumima i dokazima.

- [x] Uvedi matricu trasiranja (Spec -> Modul -> Endpoint -> Test -> Artefakt)
  Razlog: Da bi odbrana projekta bila dokaziva i lako proverljiva.
  Ocekivani ishod: Tabela koja za svaku tacku specifikacije navodi gde je implementirana i cime je testirana.

## Faza 1 - Akoma Ntoso za zakon (Task 1)

- [x] Dodaj formalnu XML validaciju za zakon (XSD/semanticka pravila)
  Razlog: Trenutno postoji generisanje XML, ali bez obavezne validacije pre upotrebe.
  Ocekivani ishod: Build/test fail ako XML nije validan.

- [x] Proveri i standardizuj anotacije entiteta u zakonu (organizacije, datumi, reference)
  Razlog: Potrebna je konzistentnost anotacija za kasniju navigaciju i reasoning.
  Ocekivani ishod: Svi obavezni tipovi entiteta prisutni i uniformno zapisani.

- [x] Stabilizuj format internih referenci (clan/stav/tacka) u jedinstvenom obrascu
  Razlog: Razliciti formati otezzavaju frontend navigaciju i backend parsiranje.
  Ocekivani ishod: Jedan kanonski format href vrednosti i parser testovi.

## Faza 2 - Sudske odluke u Akoma Ntoso (Task 2, zadrzati minimum 5)

- [x] Zadrzi eksplicitno pravilo: minimum 5 odluka u ovoj fazi
  Razlog: Kontrola troska tokena tokom izrade.
  Ocekivani ishod: Jasno dokumentovan scope i test koji proverava >= 5 XML odluka.

- [x] Dodaj quality gate za svaku odluku (obavezna polja + struktura + fakta)
  Razlog: Nije dovoljno da XML postoji; mora biti upotrebljiv za reasoning i CBR.
  Ocekivani ishod: Validacioni testovi za case_number, date, participants, applied laws/articles, facts, fullText.

- [x] Uvedi kontrolu doslednosti outcomes vrednosti (latin/cyrillic, usvojeno/odbijeno/...)
  Razlog: Trenutno postoje mesoviti oblici koji lome UI stilove i filtre.
  Ocekivani ishod: Jedan normalizovan enum i migracija postojecih zapisa.

## Faza 3 - LegalRuleML i dr-device (Task 3 i 5)

- [x] Ukloni overfit pravila sa literalima koji nisu pravno smisleni (npr. specificni stringovi lokacije)
  Razlog: Pravila moraju modelovati normu, ne slucajne tekstualne artefakte.
  Ocekivani ishod: Pravila bazirana na pravnim cinjenicama i kvalifikatorima, ne na "magic" stringovima.

- [x] Napravi mapu "pravna norma -> rule id -> dokaz iz teksta zakona"
  Razlog: Potrebna akademska sledljivost i objasnjivost.
  Ocekivani ishod: Za svako od minimum 10 pravila postoji eksplicitna veza sa clanom/stavom.

- [x] Uvedi STRICT mode za rule reasoning (bez heuristickog fallback-a kao podrazumevano)
  Razlog: Fallback trenutno moze da vrati normu i bez stvarnog dokaza iz dr-device izlaza.
  Ocekivani ishod: Ako dr-device ne dokaze normu, odgovor to jasno prijavljuje bez "izmisljanja".

- [x] Dodaj validaciju RuleML/LegalRuleML artefakata pre izvrsavanja
  Razlog: Rani fail je jeftiniji od tihih gresaka u reasoning rezultatu.
  Ocekivani ishod: CI provera konzistentnosti rulebase fajlova.

## Faza 4 - NLP ekstrakcija i manualna korekcija (Task 4)

- [x] Formalizuj NLP pipeline kao hibrid (regex + LLM) sa dokumentovanim granicama
  Razlog: Da ne deluje kao "fake NLP" i da bude jasno sta je model, a sta heuristika.
  Ocekivani ishod: Tehnicka dokumentacija sa opisom svakog koraka i fallback pravila.

- [x] Uvedi evaluaciju ekstrakcije (precision/recall/F1) na oznacenom mini-skupu
  Razlog: Bez metrika nema objektivne potvrde kvaliteta ekstrakcije.
  Ocekivani ishod: Izvestaj po poljima (stranke, sudije, datumi, cinjenice).

- [x] Sacuvaj audit trail za rucne izmene (koje polje, stara vrednost, nova vrednost, vreme)
  Razlog: Potrebno za transparentnost i kasniju analizu gresaka modela.
  Ocekivani ishod: Istorija izmena dostupna kroz API/UI.

- [x] Uvedi confidence prag i status "needs_review" za slabe ekstrakcije
  Razlog: Operativno smanjuje pogresne automatske anotacije u daljim koracima.
  Ocekivani ishod: Slabi rezultati automatski idu na rucnu proveru.

## Faza 5 - CBR/jColibri dubina (Task 6)

- [x] Uvedi ponderisane funkcije slicnosti po atributima
  Razlog: Prosti Average + Equal za vecinu atributa je metodoloski preslab.
  Ocekivani ishod: Tezine uskladjene sa pravnom relevantnoscu cinjenica.

- [x] Dodaj soft-similarity za tekstualna polja (lokacija/oruzje) i sinonime
  Razlog: Strogi Equal je osetljiv na sitne razlike u zapisu.
  Ocekivani ishod: Veca robustnost i realniji top-k rezultati.

- [x] Ispravno tretiraj "unknown" vrednosti (ne prevoditi NULL automatski u false)
  Razlog: Gubljenje nepoznatih vrednosti menja semantiku slucaja.
  Ocekivani ishod: Tri-state logika za relevantna binarna polja.

- [x] Uvedi objasnjenje CBR skora po atributima (feature contribution)
  Razlog: Potrebna objasnjivost pred komisijom i korisnikom.
  Ocekivani ishod: Za svaki match prikaz doprinosa atributa slicnosti.

## Faza 6 - Pregled i navigacija kroz dokumente (Task 7)

- [x] Refaktorisati navigaciju tako da podrzava vise zakona (law-aware routing)
  Razlog: Trenutno se reference cesto tretiraju kao da vode samo na jedan zakon.
  Ocekivani ishod: Ruta i resolver po obrascu lawId + articleId, sa tacnim preusmeravanjem.

- [x] Uvedi jedinstveni parser pravnih referenci (backend + frontend)
  Razlog: Duplirana i ad-hoc logika vodi do nedoslednosti.
  Ocekivani ishod: Jedna kanonska reprezentacija reference koju obe strane koriste.

- [x] Ukloni globalni document click listener i zameni Angular-safe mehanizmom
  Razlog: Rizik memory leak-a i nepredvidivog ponasanja komponenti.
  Ocekivani ishod: Bez globalnog listener-a, sa kontrolisanim lifecycle-om.

- [x] Dodaj testove za navigaciju "presuda -> clan zakona" i "clan -> referencirani clan"
  Razlog: Ovo je centralni funkcionalni zahtev i mora biti automatski proverljiv.
  Ocekivani ishod: Integracioni testovi koji pokrivaju i cross-law slucajeve.
  Napomena: Angular test target je konfigurisan i testovi prolaze (ChromeHeadless, 11/11).

## Faza 7 - Combined reasoning + cuvanje slucaja (Task 8)

- [x] Ucvrsti tok korisnicke potvrde presude i sankcije pre cuvanja
  Razlog: Specifikacija trazi eksplicitan izbor korisnika pre upisa u bazu slucajeva.
  Ocekivani ishod: Jasna validacija inputa i obavezna potvrda pre persistiranja.

- [x] Dodaj pravila deduplikacije i verzionisanja slucajeva
  Razlog: Da se izbegne gomilanje slicnih zapisa i degradacija CBR baze.
  Ocekivani ishod: Deterministicko ponasanje pri ponovnom unosu slicnih slucajeva.

- [x] Uvedi robustan error model za partial failures (rule ok, cbr fail, itd.)
  Razlog: Trenutno degradacija postoji, ali treba formalizovati status i poruke.
  Ocekivani ishod: Klijent dobija jasan status svakog podsistema reasoning-a.

## Faza 8 - Generisanje novih presuda (Task 9)

- [x] Uvedi dvostepeni gen pipeline: strukturisani plan (JSON schema) -> finalni tekst
  Razlog: Smanjuje halucinacije i povecava kontrolu pravne strukture.
  Ocekivani ishod: Svaka generisana presuda ima proverljiv plan pre finalnog teksta.

- [x] Dodaj retrieval kontekst (relevantni clanci + top slicni slucajevi) kao obavezni input
  Razlog: Povecava pravnu uskladjenost i kvalitet argumentacije.
  Ocekivani ishod: Stabilniji izlaz i veca slicnost sa stilom domenskog korpusa.

- [x] Implementiraj post-generation validator (pravne reference, sankcija, struktura)
  Razlog: Trenutno fallback moze proizvesti template-like tekst bez dublje kontrole.
  Ocekivani ishod: Neispravna presuda se automatski vraca na regeneraciju ili review.

- [x] Obelezi fallback generacije posebnim statusom kvaliteta
  Razlog: Da bude transparentno kada je izlaz nastao bez punog LLM toka.
  Ocekivani ishod: UI/API jasno razlikuju "full-LLM" i "fallback" izlaz.

## Faza 9 - Inzenjersko ojacavanje (cross-cutting)

- [x] Dodaj CI korake: schema validation, unit/integration testovi, smoke testovi
  Razlog: Bez automatizovanih gate-ova regresije ce se vracati.
  Ocekivani ishod: Stabilan pipeline sa jasnim fail uslovima.
  Status: Implementirano kroz `scripts/run_ci_validation.py`, `scripts/evaluate_final_protocol.py` i workflow `.github/workflows/final-evaluation-ci.yml`.

- [ ] Uvedi performansne testove za vece XML skupove i endpoint latenciju
  Razlog: Servis trenutno ucitava vise podataka u memoriju i rizikuje usporenje.
  Ocekivani ishod: Merene granice performansi i plan optimizacije.

- [ ] Refaktorisati ucitavanje presuda (lazy/streaming gde ima smisla)
  Razlog: Skaliranje bez nepotrebnog memorijskog pritiska.
  Ocekivani ishod: Predvidiva potrosnja memorije pri rastu skupa dokumenata.

- [ ] Uvedi standardizovan logging i observability (reasoning trace, generation trace)
  Razlog: Potrebno za debugging i dokazivanje ponasanja sistema.
  Ocekivani ishod: Struktuirani logovi i osnovni dashboard metrika.

## Faza 10 - Dokumentacija za odbranu

- [ ] Pripremi "evidence pack" po tackama 1-9 (snimci ekrana + API primeri + test output)
  Razlog: Akademska evaluacija trazi dokaz, ne samo tvrdnju da "radi".
  Ocekivani ishod: Spreman materijal za demonstraciju bez improvizacije.

- [ ] Dodaj tehnicko obrazlozenje arhitekture i kompromisa (token budget, fallback, min 5 odluka)
  Razlog: Transparentno opravdanje dizajnerskih odluka pred komisijom.
  Ocekivani ishod: Jasna naracija sta je uradjeno, zasto i kako dalje skalirati.
