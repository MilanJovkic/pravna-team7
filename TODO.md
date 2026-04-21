# TODO - Enterprise Arhitektonska Transformacija (2026)

Ovaj dokument je operacionalni plan za transformaciju projekta iz studentskog/MVP nivoa u produkcijski, održiv i testabilan sistem, bez promene funkcionalnog ponašanja.

## Guardrails (Ne pregovara se)

- Functional freeze: nijedna postojeća funkcionalnost se ne menja bez eksplicitnog test dokaza da je ponašanje identično.
- Strangler pristup: migracija sloj po sloj uz adaptere, bez velikog "big-bang" rewrite-a.
- API contract lock: postojeći endpoint-i i JSON shape ostaju kompatibilni do završetka migracije.
- Test-first refactor: svaki korak refaktora prati contract/approval test.
- Observability pre optimizacije: prvo merenje i tracing, pa tek onda tuning.

---

## 1) Current Architecture Audit (Kratko i oštro)

### 1.1 Trenutna slika sistema

- Python backend API: FastAPI entry u backend/app/main.py
- HTTP sloj: backend/app/api/*.py
- "Service" sloj sa direktnim IO, subprocess i parsiranjem: backend/app/services/*.py
- Domenski NLP/parsing moduli: src/akoma_annotation/* i src/verdict_annotation/*
- CBR Java integracija kroz subprocess i JAR: backend/app/services/cbr_service.py
- Rule engine integracija kroz bat + RDF: backend/app/services/rule_reasoning_service.py
- Persistencija: PostgreSQL + JSON fajlovi (overrides/audit) + XML artefakti u data/verdicts_xml/
- CLI pipeline-i: main.py, process_verdicts.py, scripts/run_ci_validation.py

### 1.2 Ključni tehnički dug i slabosti

1. HIGH - Layer violation i import path hack:
- backend/app/services/law_service.py radi sys.path.append i direktno uvlači src module.
- Posledica: krhka rezolucija importa, teško testiranje, nejasna ownership granica.

2. HIGH - Global singleton servisi u routerima:
- backend/app/api/laws.py, verdicts.py, reasoning.py, cases.py, verdict_generation.py kreiraju global instance servisa.
- Posledica: state leakage, slab test isolation, otežan dependency injection.

3. HIGH - Mešanje domena i infrastrukture:
- cbr_service.py kombinuje business odluke, DB bootstrap, XML parsing i Java subprocess.
- rule_reasoning_service.py kombinuje RDF serializaciju, external process orchestration i rezultatnu domensku logiku.

4. HIGH - Nepotpuna asinhronost i blokirajući IO u request path:
- CPU/IO heavy operacije (ET.parse, file IO, subprocess.run, requests) pozivaju se iz async endpointa bez izolacije.
- Posledica: event-loop blokiranje pod opterećenjem.

5. HIGH - Error handling i logging nisu standardizovani:
- Više modula koristi print umesto strukturiranog logger-a.
- HTTPException 500 često vraća raw str(e), bez sanitizacije i correlation ID.

6. HIGH - Dupli i konfliktni modeli za isti koncept:
- VerdictMetadata postoji i kao dataclass u src/verdict_annotation/verdict_parser.py i kao Pydantic model u backend/app/models/schemas.py.
- Posledica: implicitne konverzije, rizik regresije i schema drift.

7. MEDIUM - "God service" simptom:
- verdict_generation_service.py ima više odgovornosti: prompting, generation plan, fallback, validation, metadata mapping, export i JSON persistence.

8. MEDIUM - Slaba separacija konfiguracije:
- db_config.py i verdict_exporter.py imaju različite fallback putanje i env naming obrasce.

9. MEDIUM - Fajl-sistem kao runtime storage bez jasnog repository ugovora:
- verdict_service.py direktno čita/piše overrides i audit JSON fajlove i XML direktorijum.

10. MEDIUM - Nedostatak formalnih portova/interfejsa:
- Nema jasnih apstrakcija za Rule engine, CBR engine, LLM gateway, XML store, override store.

11. MEDIUM - Cache i invalidation su ad-hoc:
- verdict_service.py prati mtime ručno; law_service.py drži memo state bez thread-safe strategije.

12. MEDIUM - Testovi nisu dovoljno segmentirani po slojevima:
- Postoje kvalitetni testovi ugovora, ali nedostaju adapter-level testovi za subprocess/DB/file IO i golden tests za API shape.

13. LOW - Neujednačen naming i transliteracija:
- mešanje latin/cyrillic i normalization logike kroz više mesta.

14. LOW - Učitavanje velikih skupova podataka bez kontrolisanog streaminga:
- više servisa učitava kompletne skupove XML/JSON u memoriju.

15. LOW - Nedovoljna formalizacija arhitektonskih odluka:
- nema ADR seta za ključne odluke (hybrid reasoning, persistence strategy, migration contracts).

---

## 2) New Architecture Blueprint (Clean/Hexagonal)

### 2.1 Ciljana logička podela

- Domain layer:
- Čista pravila domene, Value Object-i, entiteti, domen servisi bez framework/IO zavisnosti.

- Application layer:
- Use-case orkestracija, DTO mapiranje, transakcioni granice, policy evaluacija.

- Infrastructure layer:
- Adapteri za FastAPI, PostgreSQL, File/XML storage, subprocess (dr-device, jColibri), LLM HTTP klijente.

- Interface/API layer:
- Thin controller/router sloj + dependency injection.

### 2.2 Predložena struktura foldera (target)

```text
backend/
  app/
    bootstrap/
      container.py
      settings.py
      logging.py
      telemetry.py
    interfaces/
      api/
        v1/
          laws_router.py
          verdicts_router.py
          reasoning_router.py
          cases_router.py
          verdict_generation_router.py
      cli/
        run_law_pipeline.py
        run_verdict_pipeline.py
    application/
      dto/
        law_dto.py
        verdict_dto.py
        reasoning_dto.py
      use_cases/
        get_law_chapters.py
        get_law_article.py
        search_law_articles.py
        list_verdicts.py
        get_verdict_detail.py
        update_verdict_overrides.py
        run_hybrid_reasoning.py
        create_case.py
        generate_verdict.py
      services/
        reasoning_fusion_service.py
        verdict_generation_policy.py
    domain/
      law/
        entities.py
        services.py
      verdict/
        entities.py
        services.py
      reasoning/
        entities.py
        policies.py
      casebase/
        entities.py
      shared/
        errors.py
        result.py
        value_objects.py
    ports/
      inbound/
        law_queries.py
        verdict_queries.py
        reasoning_commands.py
        case_commands.py
      outbound/
        law_repository.py
        verdict_repository.py
        override_repository.py
        case_repository.py
        cbr_engine.py
        rule_engine.py
        llm_gateway.py
        verdict_export_gateway.py
        clock.py
        id_generator.py
    infrastructure/
      persistence/
        postgres/
          case_repository_pg.py
        filesystem/
          law_repository_fs.py
          verdict_repository_fs.py
          verdict_override_repository_fs.py
      engines/
        cbr/
          jcolibri_adapter.py
        rules/
          dr_device_adapter.py
      llm/
        openai_gateway.py
        openrouter_gateway.py
      exporters/
        akoma_verdict_exporter_adapter.py
      mappers/
        dto_mappers.py
        xml_mappers.py
    contracts/
      api/
        openapi_freeze_tests/
``` 

Napomena: postojeći src/akoma_annotation i src/verdict_annotation ostaju tokom tranzicije kao Legacy Adapter Zone, pa se postupno izmeštaju iza portova.

### 2.3 Pattern-i koji se uvode

- Repository pattern:
- Za XML/JSON i DB pristup (law, verdict, overrides, casebase).

- Strategy pattern:
- Za reasoning fusion (rule-only, cbr-only, hybrid-conflict-resolution) i LLM provider izbor.

- Factory pattern:
- Za runtime izbor adaptera (OpenAI/OpenRouter/offline, dr-device availability, cbr engine mode).

- Adapter (Hexagonal ports/adapters):
- Svi external sistemi (DB, files, subprocess, HTTP API) iza outbound portova.

- Unit of Work (lagano):
- Za use-case granice koje menjaju DB + fajl artefakte (npr. generate verdict + annotation upis).

---

## 3) Step-by-Step Refactoring Roadmap

## Faza 0 - Baseline lock i bezbedna migracija

- [x] Zamrzni API ugovor kroz snapshot/golden contract testove za:
- GET /api/laws/chapters
- GET /api/laws/articles/{id}
- GET /api/verdicts
- GET /api/verdicts/{case_id}
- POST /api/reasoning/
- POST /api/cases/
- POST /api/verdict-generation/

- [x] Uvedi centralni settings modul (Pydantic Settings) i ukloni rasutu env logiku.
- [x] Uvedi structured logging sa correlation_id middleware-om i standardnim error envelope-om.
- [x] Donesi ADR-001..ADR-005 (target arhitektura, ports, migraciona strategija, observability, test policy).

Status 2026-03-31:
- Contract lock testovi dodati u tests/unit/test_api_contract_lock.py.
- Bootstrap moduli dodati u backend/app/bootstrap/ (settings, logging, error_handling).
- ADR dokumenti dodati u docs/adr/ADR-001..ADR-005.
- Verifikacija: 15/15 testova green (pytest na contract/resilience/governance suite).

Definition of Done:
- Svi postojeći testovi prolaze.
- Novi contract testovi prolaze i čuvaju trenutni API shape.

## Faza 1 - API sloj i Dependency Injection

- [x] Eliminisati global service instance iz routera i preći na provider/factory injection.
- [x] Routere svesti na thin controllers (validacija inputa + mapiranje response DTO).
- [x] Uvesti Application UseCase klase po endpointu.

Target fajlovi za prvu migraciju:
- backend/app/api/laws.py
- backend/app/api/verdicts.py
- backend/app/api/reasoning.py
- backend/app/api/cases.py
- backend/app/api/verdict_generation.py

Status 2026-03-31:
- Routeri migrirani na Depends provider pattern, bez global singleton instanci.
- UseCase sloj dodat u backend/app/application/use_cases/ (law_queries, verdict_queries, reasoning_commands, case_commands, verdict_generation_commands).
- Test suite ažuriran na dependency_overrides umesto patching global instance.
- Verifikacija: 15/15 testova green (contract + resilience + governance).

Definition of Done:
- Nema business logike u routerima.
- Endpoint behavior 1:1 identičan (contract tests green).

## Faza 2 - Domain model konsolidacija i type-safe granice

- [x] Ukinuti duplirane modele "VerdictMetadata" i definisati jedinstven domain model + explicit mapper-e.
- [x] Uvesti Value Object-e za Outcome, ArticleReference, CaseNumber, ConfidenceScore.
- [x] Uvesti standardizovan Result/Error tip (bez bacanja generičnih Exception kroz slojeve).

Target hotspot:
- backend/app/models/schemas.py
- src/verdict_annotation/verdict_parser.py
- backend/app/services/verdict_generation_service.py

Status 2026-03-31:
- Uveden canonical domain model: backend/app/domain/verdict/entities.py.
- Parser i generation servis prebačeni na domain VerdictMetadata.
- API modeli semantički razdvojeni u DTO naming (VerdictMetadataDTO / VerdictDetailDTO) uz compatibility alias.
- Uveden domain/shared error model i Result tip; cases/reasoning use-case sloj više ne koristi FastAPI HTTPException.
- Dodati eksplicitni mapper-i domain<->DTO u backend/app/application/mappers/verdict_metadata_mapper.py.
- Verifikacija: 17/17 ciljnih testova green (contract + resilience + governance + annotation mapping + mapper).

Definition of Done:
- Jedna source-of-truth definicija domenskih tipova.
- MyPy/pyright clean za application/domain slojeve.

## Faza 3 - Persistencija iza Repository portova

- [x] Izvući file/XML/JSON operacije iz law_service.py i verdict_service.py u repository adaptere.
- [x] Uvesti override repository sa atomskim write + optimistic lock (mtime/hash).
- [x] Uvesti case repository za PostgreSQL, bez SQL duplikacije po servisima.

Target hotspot:
- backend/app/services/law_service.py
- backend/app/services/verdict_service.py
- backend/app/services/case_service.py

Definition of Done:
- Servisi ne rade direktan file/db IO.
- Repository test suite pokriva happy + failure + race scenarije.

Status 2026-03-31:
- Dodat outbound port: backend/app/ports/outbound/law_repository.py.
- Dodat filesystem adapter: backend/app/infrastructure/persistence/filesystem/law_repository_fs.py.
- LawService refaktorisan da koristi repository port umesto direktnog file/XML IO.
- Dodat outbound port: backend/app/ports/outbound/verdict_repository.py.
- Dodat filesystem adapter: backend/app/infrastructure/persistence/filesystem/verdict_repository_fs.py.
- VerdictService refaktorisan da XML/annotations read put ide kroz repository port.
- Dodat outbound port: backend/app/ports/outbound/override_repository.py.
- Dodat filesystem adapter: backend/app/infrastructure/persistence/filesystem/override_repository_fs.py (atomic write + optimistic lock).
- VerdictService refaktorisan da overrides/audit persistence ide kroz repository port.
- Dodat outbound port: backend/app/ports/outbound/case_repository.py.
- Dodat postgres adapter: backend/app/infrastructure/persistence/postgres/case_repository_pg.py.
- CaseService refaktorisan da SQL ide kroz repository adapter.
- Dodat test repository-port integracije na nivou servisa: tests/unit/test_law_service_repository_port.py.
- Dodati testovi: tests/unit/test_verdict_service_repository_port.py, tests/unit/test_override_repository_optimistic_lock.py, tests/unit/test_case_service_repository_port.py.
- Verifikacija: 18/18 testova green (repository ports + contract + resilience + override audit).

## Faza 4 - Rule i CBR engine adapterizacija

- [x] Rule engine: dr-device subprocess i RDF IO prebaciti u RuleEngineAdapter.
- [x] CBR engine: Java call + output parse + DB init prebaciti u CbrEngineAdapter i CasebaseSyncUseCase.
- [x] Uvesti timeout/retry/circuit-breaker policy za external procese.

Target hotspot:
- backend/app/services/rule_reasoning_service.py
- backend/app/services/cbr_service.py

Definition of Done:
- Application sloj vidi samo port interface (run/query), ne zna za subprocess/JAR/bat fajlove.
- Deterministički fallback/status kodovi i telemetry događaji po subsistemu.

Status 2026-03-31:
- Dodati outbound portovi: backend/app/ports/outbound/rule_engine.py i backend/app/ports/outbound/cbr_engine.py.
- Dodati engine adapteri: backend/app/infrastructure/engines/rules/dr_device_adapter.py i backend/app/infrastructure/engines/cbr/jcolibri_adapter.py.
- Reasoning use-case refaktorisan da zavisi od portova (RuleEngine/CbrEngine), ne od concrete servisa.
- API provideri prevezani na adaptere uz zadržavanje postojeće dependency override tačke (kompatibilnost testova).
- Uvedena resilience policy komponenta: backend/app/infrastructure/engines/policies.py (retry + circuit breaker).
- Dodat explicitni CBR case-base sync contract (port + adapter + use-case): backend/app/application/use_cases/casebase_sync_command.py.
- Dodati testovi adaptera i policy-ja: tests/unit/test_engine_adapters.py.
- Verifikacija: 16/16 testova green (engine adapters + contract + resilience).

## Faza 5 - Reasoning orchestration kao use-case

- [x] Refaktorisati reasoning.py endpoint da delegira kompletan flow u RunHybridReasoningUseCase.
- [x] Strategije odluke (consensus/conflict/rule-only/cbr-only) izdvojiti u Strategy implementacije.
- [x] Confidence izračunavanje i sanction suggestion prebaciti u domain policy module.

Target hotspot:
- backend/app/api/reasoning.py
- backend/app/services/reasoning_explain_service.py

Definition of Done:
- Reasoning flow je testabilan bez FastAPI i bez realnih external engine-a.
- Pokriveni kontradiktorni scenariji i partial failure matrica.

Status 2026-03-31:
- RunHybridReasoningUseCase koristi outbound engine portove + izdvojene decision strategije i domain policy module.
- Dodate strategy implementacije: backend/app/application/services/reasoning_decision_strategies.py (rule-only, cbr-only, hybrid-consensus, hybrid-conflict).
- Dodate domain policy komponente: backend/app/domain/reasoning/policies.py (confidence report + sanction suggestion).
- Reasoning API sloj ostao thin i DI-driven, sa dodatim providerima za strategy selector i policy.
- Dodati testovi: tests/unit/test_reasoning_policies_and_strategies.py.
- Verifikacija: 21/21 testova green (reasoning policy/strategy + engine adapters + API contract + resilience).

## Faza 6 - Verdict generation servis dekompozicija

- [x] Razbiti verdict_generation_service.py na:
- PlanBuilder
- PromptBuilder
- TextGenerationGateway
- PostGenerationValidator
- AnnotationAssembler
- ExportOrchestrator

- [x] Uvesti idempotency ključ i deterministic file naming policy.
- [x] Uvesti audit event za fallback generacije i quality_status.

Status 2026-03-31 (delta):
- Ekstrahovani su PlanBuilder, PromptBuilder i PostGenerationValidator u backend/app/application/services/.
- VerdictGenerationService delegira stage-1, stage-2 prompt i stage-3 validaciju na izdvojene komponente.
- Dodati testovi: tests/unit/test_generation_plan_builder.py i tests/unit/test_generation_components.py.
- Ekstrahovani su AnnotationAssembler i ExportOrchestrator i servis više nema inline metadata/annotation/export implementaciju.
- Uvedeni su GenerationIdentityPolicy, TextGenerationGateway i GenerationAuditLogger sa deterministic naming + fallback/quality audit eventima.
- Dodati testovi: tests/unit/test_generation_assembly_and_export.py i tests/unit/test_generation_identity_and_gateway.py.

Definition of Done:
- Nijedna klasa nema više od jedne primarne odgovornosti.
- Unit test coverage >= 90% za generation use-case jezgro.

## Faza 7 - Asinhronost i performanse bez promene logike

- [x] Blokirajući IO pozive iz endpoint puta izolovati u threadpool/task executore ili background jobs.
- [x] Za velike XML skupove uvesti lazy iteratore/paginaciju u query sloju.
- [x] Dodati read-through cache za law članke i reference sa jasnim invalidation pravilima.

Status 2026-03-31 (delta):
- API sloj prebačen na threadpool izolaciju (run_in_threadpool) za laws, verdicts, reasoning, cases i verdict-generation rute.
- Verifikacija: 31/31 testova green na contract/resilience/reasoning/engine/generation paketima.
- LawService sada koristi read-through article cache sa invalidacijom na promenu repository cache_version (mtime/version signal).
- Dodati testovi: tests/unit/test_law_service_cache_invalidation.py.
- VerdictService list/search tokovi koriste lazy iterator nad XML dokumentima umesto eager map-load pristupa.
- Dodati testovi: tests/unit/test_verdict_service_lazy_iteration.py.

Definition of Done:
- p95 latencija stabilnija pod paralelnim zahtevima.
- Nema event-loop blokiranja za duge subprocess/file operacije.

## Faza 8 - Hardening: Error model, logging, telemetry

- [x] Uvesti standardnu domensku hijerarhiju grešaka (DomainError, InfraError, ExternalServiceError, ValidationError).
- [x] Centralizovani exception handler koji mapira greške na stabilan API error contract.
- [x] OpenTelemetry spans za ključne use-case tokove:
- run_reasoning
- generate_verdict
- update_overrides
- cbr_query
- rule_run

Status 2026-03-31 (delta):
- Standardizovana hijerarhija grešaka aktivna u backend/app/domain/shared/errors.py.
- Uveden centralni mapper grešaka backend/app/bootstrap/error_handling.map_exception_to_http i prevezani API routeri na isti mapping helper.
- Stabilan error envelope potvrđen testovima (detail, status_code, correlation_id + X-Correlation-ID header).
- Span instrumentacija aktivna u use-case i adapter sloju za run_reasoning, generate_verdict, update_overrides, cbr_query i rule_run.
- Dodati testovi: tests/unit/test_error_handling_mapping.py.

Definition of Done:
- Svaki incident ima trace + correlation_id + subsystem status.

## Faza 9 - Legacy cleanup i finalna konsolidacija

- [x] Ukloniti sys.path hack i direktne cross-layer importe.
- [x] Premestiti preostalu logiku iz src/* modula u odgovarajuće domain/infrastructure module.
- [x] Ostaviti samo kompatibilne façade adaptere gde je neophodno.

Status 2026-03-31 (delta):
- Uklonjen sys.path hack iz backend/app/services/law_service.py.
- Direktan import src.akoma_annotation.parser iz service sloja eliminisan; uveden infrastructure adapter backend/app/infrastructure/parsers/legal_text_parser_adapter.py.
- LawService sada koristi adapter boundary (legacy parser ostaje iza infrastructure sloja).
- Direktni src.verdict_annotation.outcome_normalizer importi uklonjeni iz više modula (services/application/domain) i centralizovani u backend/app/domain/shared/outcome_normalization.py kao tranzicioni façade.
- Direktni src importi uklonjeni iz generation toka u service/application sloju:
  - backend/app/services/verdict_generation_service.py sada koristi infrastructure adaptere za exporter i llm config.
  - backend/app/application/services/annotation_assembler.py i backend/app/application/services/export_orchestrator.py koriste domain VerdictAnnotation model.
- Dodati kompatibilni adapteri:
  - backend/app/infrastructure/exporters/akoma_verdict_exporter_adapter.py
  - backend/app/infrastructure/llm/llm_config_adapter.py
- Dodata domain anotacija: backend/app/domain/verdict/annotation.py.
- Verifikacija: 27/27 testova green (generation + outcome + contract + resilience + error mapping).
- Parsing logika za law reference premeštena iz src u backend domain: backend/app/domain/law/references.py.
- Law filesystem repository prevezan na backend domain parser (bez direktnog src importa): backend/app/infrastructure/persistence/filesystem/law_repository_fs.py.
- Unit test parsera prevezan na novi canonical backend modul: tests/unit/test_law_reference_parser.py.
- Preostali src importi svedeni isključivo na infrastructure adaptere:
  - backend/app/infrastructure/exporters/akoma_verdict_exporter_adapter.py
- Verifikacija: 28/28 testova green (law parser + repository + generation + contract + resilience).
- LLM config logika migrirana iz src u backend infrastructure: backend/app/infrastructure/llm/config.py.
- Legal parser migriran iz src u backend infrastructure: backend/app/infrastructure/parsers/legal_text_parser.py.
- Adapteri llm/parser sada koriste backend implementation, bez src zavisnosti.
- Exporter implementacija migrirana iz src u backend infrastructure: backend/app/infrastructure/exporters/verdict_exporter.py.
- Export adapter backend/app/infrastructure/exporters/akoma_verdict_exporter_adapter.py sada koristi backend exporter implementaciju (bez src zavisnosti).
- Backend/app sloj više nema direktne src import zavisnosti.
- Dodatna verifikacija nakon migracije parsera: 19/19 testova green (law + contract + resilience).
- Dodatna verifikacija nakon migracije exportera: 22/22 testova green (generation mapping + contract + resilience + governance + law parser).

Definition of Done:
- Arhitektura čista po slojevima, dependency smer: interfaces -> application -> domain <- infrastructure.

---

## 4) Maintenance & Testing Plan (Stabilnost posle refaktora)

### 4.1 Test strategija

- Contract tests (obavezni): API response shape i status kodovi ostaju stabilni.
- Domain unit tests: čista poslovna pravila bez IO.
- Adapter integration tests: DB, filesystem, subprocess, LLM gateway mock/stub.
- End-to-end smoke: postojeći tests/api_smoke.py + reasoning/case-save scenariji.
- Regression pack: scripts/run_ci_validation.py ostaje obavezni gate.

### 4.2 CI quality gates (predlog minimalnog enterprise seta)

- static typing: mypy/pyright za backend/app/domain i backend/app/application
- lint: ruff + black --check
- security: pip-audit + bandit (critical/high fail)
- architecture tests:
- router ne sme importovati infrastructure direktno
- domain ne sme importovati FastAPI/requests/psycopg2/subprocess

Status 2026-03-31 (delta):
- Implementiran architecture boundary gate kroz tests/unit/test_architecture_boundaries.py.
- CI validator scripts/run_ci_validation.py proširen da izvršava tests.unit.test_architecture_boundaries u governance step-u.
- Razvezan API->infrastructure coupling u reasoning routeru: backend/app/api/reasoning.py sada koristi bootstrap provider boundary backend/app/bootstrap/dependencies.py.
- Verifikacija: 18/18 testova green (architecture + governance + API contract/resilience + generation mapping).

### 4.3 Operativni standardi

- Structured logs u JSON formatu (timestamp, level, trace_id, correlation_id, module, event, error_code).
- Health endpoint proširiti na readiness/dependency checks (DB, CBR engine availability, rule artifacts).
- Runbook dokument za:
- CBR JAR missing
- dr-device timeout
- overrides file corruption
- DB connection exhaustion

### 4.4 Pravila evolucije koda

- Svaki novi feature mora prvo definisati port/interface i use-case ugovor.
- Zabranjeno uvoditi business logiku u router i adapter sloj.
- Za svaki novi adapter: obavezni integration test + failure mode test.

---

## 5) Prioriteti implementacije (redosled koji minimizuje rizik)

1. Faza 0 + Faza 1 (contract lock + DI + thin routers)
2. Faza 2 + Faza 3 (model konsolidacija + repository portovi)
3. Faza 4 + Faza 5 (engine adapteri + hybrid orchestration)
4. Faza 6 (generation dekompozicija)
5. Faza 7 + Faza 8 + Faza 9 (async/perf + observability + legacy cleanup)

---

## 6) Konkretne prve 2 nedelje (execution starter)

- Week 1:
- Uvesti settings/logging/error envelope.
- Dodati API contract snapshot testove.
- Migrirati 1 endpoint vertical slice (npr. /api/laws/articles/{id}) na UseCase + Repository port.

- Week 2:
- Migrirati reasoning endpoint u use-case orchestrator sa mockable RuleEngine/CbrEngine portovima.
- Uvesti adapter testove za dr-device i jColibri subprocess granice.

Kriterijum uspeha za starter:
- 0 regresija na postojećim testovima.
- Vidljivo smanjenje coupling-a u backend/app/api i backend/app/services.
- Novi kod pokriven testovima i tipovima pre merge-a.

---

## 7) Risk Register (tokom migracije)

- Rizik: tihi API drift tokom mapiranja modela.
- Mitigacija: snapshot contract tests + golden JSON fixtures.

- Rizik: performansni pad zbog preterane apstrakcije.
- Mitigacija: baseline benchmark pre i posle svake faze.

- Rizik: kompatibilnost sa postojećim XML artefaktima.
- Mitigacija: XML backward-compatibility test suite na zaključanom skupu presuda.

- Rizik: nestabilnost external procesa (Java/dr-device).
- Mitigacija: retry/circuit-breaker/timeouts + fallback status, bez silent fail.

---

Ovo je plan transformacije koji zadržava funkcionalni identitet sistema, ali menja internu strukturu na enterprise nivo: jasno razdvojeni slojevi, testabilnost, observability i dugoročna održivost.
