import { Component, HostListener } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { HttpErrorResponse } from '@angular/common/http';
import { ReasoningService } from '../services/reasoning.service';
import { CaseFacts, CbrMatch, ReasoningResponse, VerdictDetail, VerdictGenerationResponse } from '../models/models';
import { Router } from '@angular/router';
import { VerdictService } from '../services/verdict.service';

@Component({
  selector: 'app-reasoning',
  standalone: true,
  imports: [CommonModule, FormsModule],
  template: `
    <div class="reasoning-page">
      <header class="hero">
        <div>
          <p class="eyebrow">Rasudjivanje</p>
          <h2>Unos slucaja i predlog presude</h2>
          <p class="subtitle">Popuni opis činjenica kroz napredne pravne atribute, pokreni rasuđivanje i sačuvaj novi slučaj.</p>
        </div>
      </header>

      <div class="content-grid">
        <section class="card form-card">
          <h3>Opis cinjenica</h3>
          <form (ngSubmit)="runReasoning()" #form="ngForm">
            <div class="advanced-facts">
              <h4>Napredni pravni atributi</h4>
              <div class="group-tabs">
                <button type="button" [class.active]="activeFactGroup === 'victim'" (click)="activeFactGroup = 'victim'">Podaci o zrtvi</button>
                <button type="button" [class.active]="activeFactGroup === 'outcome'" (click)="activeFactGroup = 'outcome'">Ishod/posljedica</button>
                <button type="button" [class.active]="activeFactGroup === 'method'" (click)="activeFactGroup = 'method'">Nacin i motiv</button>
                <button type="button" [class.active]="activeFactGroup === 'guilt'" (click)="activeFactGroup = 'guilt'">Subjektivni odnos</button>
                <button type="button" [class.active]="activeFactGroup === 'help'" (click)="activeFactGroup = 'help'">Napuštanje/pomoć</button>
                <button type="button" [class.active]="activeFactGroup === 'service'" (click)="activeFactGroup = 'service'">Služba/posebne radnje</button>
              </div>

              <div class="field-grid" *ngIf="activeFactGroup === 'victim'">
                <label>
                  Zdravstveno stanje zrtve
                  <select name="victim_health_state" [(ngModel)]="facts.victim_health_state">
                    <option value="">Nepoznato</option>
                    <option value="tesko_zdravstveno_stanje">Teško zdravstveno stanje</option>
                    <option value="uredno_zdravlje">Uredno zdravlje</option>
                  </select>
                </label>
                <label>
                  Uracunljivost zrtve
                  <select name="victim_accountability" [(ngModel)]="facts.victim_accountability">
                    <option value="">Nepoznato</option>
                    <option value="uracunljiva">Uračunljiva</option>
                    <option value="bitno_smanjena">Bitno smanjena uračunljivost</option>
                    <option value="neuracunljiva">Neuračunljiva</option>
                  </select>
                </label>
                <label>
                  Zrtva prethodno zlostavljana
                  <select name="victim_previously_abused" [(ngModel)]="facts.victim_previously_abused">
                    <option [ngValue]="null">Nepoznato</option>
                    <option [ngValue]="true">Da</option>
                    <option [ngValue]="false">Ne</option>
                  </select>
                </label>
                <label>
                  Broj zrtava
                  <select name="victim_count" [(ngModel)]="facts.victim_count">
                    <option value="">Nepoznato</option>
                    <option value="jedna">Jedna žrtva</option>
                    <option value="vise">Više žrtava</option>
                  </select>
                </label>
                <label>
                  Ozbiljan i izričit zahtjev zrtve
                  <select name="victim_explicit_request" [(ngModel)]="facts.victim_explicit_request">
                    <option value="">Nije poznato</option>
                    <option value="da">Da</option>
                    <option value="ne">Ne</option>
                    <option value="nije_primjenljivo">Nije primjenljivo</option>
                  </select>
                </label>
                <label>
                  Zrtva u odnosu podređenosti
                  <select name="victim_subordination" [(ngModel)]="facts.victim_subordination">
                    <option [ngValue]="null">Nepoznato</option>
                    <option [ngValue]="true">Da</option>
                    <option [ngValue]="false">Ne</option>
                  </select>
                </label>
                <div class="checkbox-group full-width">
                  <span>Status zrtve</span>
                  <label class="checkbox-line"><input type="checkbox" [checked]="isChecked(facts.victim_status, 'dijete')" (change)="toggleMulti('victim_status', 'dijete', $event)" />Dijete</label>
                  <label class="checkbox-line"><input type="checkbox" [checked]="isChecked(facts.victim_status, 'bremenita_zena')" (change)="toggleMulti('victim_status', 'bremenita_zena', $event)" />Bremenita žena</label>
                  <label class="checkbox-line"><input type="checkbox" [checked]="isChecked(facts.victim_status, 'clan_porodice')" (change)="toggleMulti('victim_status', 'clan_porodice', $event)" />Član porodice/zajednice</label>
                  <label class="checkbox-line"><input type="checkbox" [checked]="isChecked(facts.victim_status, 'sluzbeno_lice')" (change)="toggleMulti('victim_status', 'sluzbeno_lice', $event)" />Službeno lice</label>
                  <label class="checkbox-line"><input type="checkbox" [checked]="isChecked(facts.victim_status, 'vojno_lice')" (change)="toggleMulti('victim_status', 'vojno_lice', $event)" />Vojno lice</label>
                  <label class="checkbox-line"><input type="checkbox" [checked]="isChecked(facts.victim_status, 'punoljetno_lice')" (change)="toggleMulti('victim_status', 'punoljetno_lice', $event)" />Punoljetno lice</label>
                  <label class="checkbox-line"><input type="checkbox" [checked]="isChecked(facts.victim_status, 'maloljetnik')" (change)="toggleMulti('victim_status', 'maloljetnik', $event)" />Maloljetnik</label>
                  <label class="checkbox-line"><input type="checkbox" [checked]="isChecked(facts.victim_status, 'nemocno_lice')" (change)="toggleMulti('victim_status', 'nemocno_lice', $event)" />Nemoćno lice</label>
                </div>
              </div>

              <div class="field-grid" *ngIf="activeFactGroup === 'outcome'">
                <label>
                  Vrsta posljedice po zivot
                  <select name="life_consequence_type" [(ngModel)]="facts.life_consequence_type">
                    <option value="">Nepoznato</option>
                    <option value="smrt_nastupila">Smrt nastupila</option>
                    <option value="pokusaj">Pokušaj (smrt nije nastupila)</option>
                    <option value="tjelesna_povreda">Tjelesna povreda</option>
                  </select>
                </label>
                <label>
                  Stepen tjelesne povrede
                  <select name="injury_severity_level" [(ngModel)]="facts.injury_severity_level">
                    <option value="">Nepoznato</option>
                    <option value="laka">Laka tjelesna povreda</option>
                    <option value="teska">Teška tjelesna povreda</option>
                    <option value="narusenje_zdravlja">Narušavanje zdravlja</option>
                  </select>
                </label>
                <label>
                  Opasnost i za treca lica
                  <select name="danger_to_third_parties" [(ngModel)]="facts.danger_to_third_parties">
                    <option [ngValue]="null">Nepoznato</option>
                    <option [ngValue]="true">Da</option>
                    <option [ngValue]="false">Ne</option>
                  </select>
                </label>
                <label>
                  Samoubistvo: izvršeno ili pokušano
                  <select name="suicide_outcome" [(ngModel)]="facts.suicide_outcome">
                    <option value="">Nije poznato</option>
                    <option value="izvrseno">Izvršeno</option>
                    <option value="pokusano">Pokušano</option>
                    <option value="nije_primjenljivo">Nije primjenljivo</option>
                  </select>
                </label>
                <div class="checkbox-group full-width">
                  <span>Specifične posljedice teške povrede</span>
                  <label class="checkbox-line"><input type="checkbox" [checked]="isChecked(facts.severe_injury_specific_consequences, 'opasnost_po_zivot')" (change)="toggleMulti('severe_injury_specific_consequences', 'opasnost_po_zivot', $event)" />Opasnost po život</label>
                  <label class="checkbox-line"><input type="checkbox" [checked]="isChecked(facts.severe_injury_specific_consequences, 'unistenje_dijela_tijela')" (change)="toggleMulti('severe_injury_specific_consequences', 'unistenje_dijela_tijela', $event)" />Uništenje dijela tijela/organa</label>
                  <label class="checkbox-line"><input type="checkbox" [checked]="isChecked(facts.severe_injury_specific_consequences, 'trajno_ostecenje_organa')" (change)="toggleMulti('severe_injury_specific_consequences', 'trajno_ostecenje_organa', $event)" />Trajno oštećenje organa</label>
                  <label class="checkbox-line"><input type="checkbox" [checked]="isChecked(facts.severe_injury_specific_consequences, 'trajna_nesposobnost_za_rad')" (change)="toggleMulti('severe_injury_specific_consequences', 'trajna_nesposobnost_za_rad', $event)" />Trajna nesposobnost za rad</label>
                  <label class="checkbox-line"><input type="checkbox" [checked]="isChecked(facts.severe_injury_specific_consequences, 'trajno_naruseno_zdravlje')" (change)="toggleMulti('severe_injury_specific_consequences', 'trajno_naruseno_zdravlje', $event)" />Trajno narušeno zdravlje</label>
                  <label class="checkbox-line"><input type="checkbox" [checked]="isChecked(facts.severe_injury_specific_consequences, 'unakazenost')" (change)="toggleMulti('severe_injury_specific_consequences', 'unakazenost', $event)" />Unakaženost</label>
                </div>
                <div class="checkbox-group full-width">
                  <span>Ishod pobačaja</span>
                  <label class="checkbox-line"><input type="checkbox" [checked]="isChecked(facts.abortion_outcomes, 'pobacaj_izvrsen')" (change)="toggleMulti('abortion_outcomes', 'pobacaj_izvrsen', $event)" />Pobačaj izvršen</label>
                  <label class="checkbox-line"><input type="checkbox" [checked]="isChecked(facts.abortion_outcomes, 'pobacaj_zapocet')" (change)="toggleMulti('abortion_outcomes', 'pobacaj_zapocet', $event)" />Pobačaj započet</label>
                  <label class="checkbox-line"><input type="checkbox" [checked]="isChecked(facts.abortion_outcomes, 'smrt_zene')" (change)="toggleMulti('abortion_outcomes', 'smrt_zene', $event)" />Smrt žene nastupila</label>
                  <label class="checkbox-line"><input type="checkbox" [checked]="isChecked(facts.abortion_outcomes, 'teska_povreda_zene')" (change)="toggleMulti('abortion_outcomes', 'teska_povreda_zene', $event)" />Teška povreda žene</label>
                </div>
              </div>

              <div class="field-grid" *ngIf="activeFactGroup === 'method'">
                <label>
                  Sredstvo izvršenja (kod povrede)
                  <select name="injury_means_type" [(ngModel)]="facts.injury_means_type">
                    <option value="">Nepoznato</option>
                    <option value="oruzje">Oružje</option>
                    <option value="opasno_orudje">Opasno oruđe</option>
                    <option value="sredstvo_podobno_za_tesku_povredu">Sredstvo podobno za tešku povredu</option>
                    <option value="ostalo">Ostalo</option>
                  </select>
                </label>
                <label>
                  Pristanak zrtve na djelo
                  <select name="victim_consent" [(ngModel)]="facts.victim_consent">
                    <option value="">Nepoznato</option>
                    <option value="sa_pristankom">Da, sa pristankom</option>
                    <option value="bez_pristanka">Ne, bez pristanka</option>
                  </select>
                </label>
                <label>
                  Cilj sterilizacije
                  <select name="sterilization_goal" [(ngModel)]="facts.sterilization_goal">
                    <option value="">Nije primjenljivo</option>
                    <option value="onemogucavanje_reprodukcije">Onemogućavanje reprodukcije</option>
                    <option value="nije_primjenljivo">Nije primjenljivo</option>
                  </select>
                </label>
                <div class="checkbox-group full-width">
                  <span>Način lišenja života / vršenja djela</span>
                  <label class="checkbox-line"><input type="checkbox" [checked]="isChecked(facts.execution_manner, 'svirep_nacin')" (change)="toggleMulti('execution_manner', 'svirep_nacin', $event)" />Svirep način</label>
                  <label class="checkbox-line"><input type="checkbox" [checked]="isChecked(facts.execution_manner, 'podmukao_nacin')" (change)="toggleMulti('execution_manner', 'podmukao_nacin', $event)" />Podmukao način</label>
                  <label class="checkbox-line"><input type="checkbox" [checked]="isChecked(facts.execution_manner, 'bezobzirno_nasilje')" (change)="toggleMulti('execution_manner', 'bezobzirno_nasilje', $event)" />Bezobzirno nasilje</label>
                  <label class="checkbox-line"><input type="checkbox" [checked]="isChecked(facts.execution_manner, 'na_mah')" (change)="toggleMulti('execution_manner', 'na_mah', $event)" />Na mah</label>
                  <label class="checkbox-line"><input type="checkbox" [checked]="isChecked(facts.execution_manner, 'iz_nehata')" (change)="toggleMulti('execution_manner', 'iz_nehata', $event)" />Iz nehata</label>
                  <label class="checkbox-line"><input type="checkbox" [checked]="isChecked(facts.execution_manner, 'upotrebom_sile')" (change)="toggleMulti('execution_manner', 'upotrebom_sile', $event)" />Upotrebom sile</label>
                  <label class="checkbox-line"><input type="checkbox" [checked]="isChecked(facts.execution_manner, 'prijetnjom')" (change)="toggleMulti('execution_manner', 'prijetnjom', $event)" />Prijetnjom</label>
                </div>
                <div class="checkbox-group full-width">
                  <span>Motiv izvršioca</span>
                  <label class="checkbox-line"><input type="checkbox" [checked]="isChecked(facts.offender_motive, 'koristoljublje')" (change)="toggleMulti('offender_motive', 'koristoljublje', $event)" />Koristoljublje</label>
                  <label class="checkbox-line"><input type="checkbox" [checked]="isChecked(facts.offender_motive, 'bezobzirna_osveta')" (change)="toggleMulti('offender_motive', 'bezobzirna_osveta', $event)" />Bezobzirna osveta</label>
                  <label class="checkbox-line"><input type="checkbox" [checked]="isChecked(facts.offender_motive, 'niske_pobude')" (change)="toggleMulti('offender_motive', 'niske_pobude', $event)" />Niske pobude</label>
                  <label class="checkbox-line"><input type="checkbox" [checked]="isChecked(facts.offender_motive, 'samilost')" (change)="toggleMulti('offender_motive', 'samilost', $event)" />Samilost</label>
                  <label class="checkbox-line"><input type="checkbox" [checked]="isChecked(facts.offender_motive, 'prikrivanje_drugog_kd')" (change)="toggleMulti('offender_motive', 'prikrivanje_drugog_kd', $event)" />Prikrivanje drugog KD</label>
                  <label class="checkbox-line"><input type="checkbox" [checked]="isChecked(facts.offender_motive, 'izvrsenje_drugog_kd')" (change)="toggleMulti('offender_motive', 'izvrsenje_drugog_kd', $event)" />Izvršenje drugog KD</label>
                </div>
                <div class="checkbox-group full-width">
                  <span>Izazvanost (provokacija)</span>
                  <label class="checkbox-line"><input type="checkbox" [checked]="isChecked(facts.provocation_types, 'napad_od_ubijenog')" (change)="toggleMulti('provocation_types', 'napad_od_ubijenog', $event)" />Napad od strane ubijenog</label>
                  <label class="checkbox-line"><input type="checkbox" [checked]="isChecked(facts.provocation_types, 'zlostavljanje_od_ubijenog')" (change)="toggleMulti('provocation_types', 'zlostavljanje_od_ubijenog', $event)" />Zlostavljanje od ubijenog</label>
                  <label class="checkbox-line"><input type="checkbox" [checked]="isChecked(facts.provocation_types, 'tesko_vrijedjanje_od_ubijenog')" (change)="toggleMulti('provocation_types', 'tesko_vrijedjanje_od_ubijenog', $event)" />Teško vrijeđanje od ubijenog</label>
                  <label class="checkbox-line"><input type="checkbox" [checked]="isChecked(facts.provocation_types, 'bez_krivice_ucinioca')" (change)="toggleMulti('provocation_types', 'bez_krivice_ucinioca', $event)" />Bez krivice učinioca</label>
                </div>
              </div>

              <div class="field-grid" *ngIf="activeFactGroup === 'guilt'">
                <label>
                  Oblik krivnje
                  <select name="guilt_form" [(ngModel)]="facts.guilt_form">
                    <option value="">Nepoznato</option>
                    <option value="umisljaj_direktni">Umišljaj (direktni)</option>
                    <option value="umisljaj_eventualni">Umišljaj (eventualni)</option>
                    <option value="nehat">Nehat</option>
                  </select>
                </label>
                <label>
                  Psihičko stanje učinioca
                  <select name="offender_psych_state" [(ngModel)]="facts.offender_psych_state">
                    <option value="">Nepoznato</option>
                    <option value="normalno_stanje">Normalno stanje</option>
                    <option value="jaka_razdrazenost_na_mah">Jaka razdraženost (na mah)</option>
                    <option value="porodjajni_poremecaj">Porođajni poremećaj</option>
                  </select>
                </label>
                <label>
                  Smrt pripisiva nehatu učinioca
                  <select name="death_attributed_to_negligence" [(ngModel)]="facts.death_attributed_to_negligence">
                    <option value="">Nije poznato</option>
                    <option value="da">Da</option>
                    <option value="ne">Ne</option>
                    <option value="nije_primjenljivo">Nije primjenljivo</option>
                  </select>
                </label>
              </div>

              <div class="field-grid" *ngIf="activeFactGroup === 'help'">
                <label>
                  Opasnost prouzrokovana od strane učinioca
                  <select name="danger_caused_by_offender" [(ngModel)]="facts.danger_caused_by_offender">
                    <option [ngValue]="null">Nepoznato</option>
                    <option [ngValue]="true">Da</option>
                    <option [ngValue]="false">Ne</option>
                  </select>
                </label>
                <label>
                  Odnos učinioca prema zrtvi
                  <select name="offender_victim_relationship" [(ngModel)]="facts.offender_victim_relationship">
                    <option value="">Nepoznato</option>
                    <option value="povjereno_nemocno_lice">Povjereno nemoćno lice</option>
                    <option value="duznost_staranja">Dužnost staranja</option>
                    <option value="prolaznik">Prolaznik / slučajni svjedok</option>
                  </select>
                </label>
                <label>
                  Mogućnost pružanja pomoći
                  <select name="help_provision_ability" [(ngModel)]="facts.help_provision_ability">
                    <option value="">Nepoznato</option>
                    <option value="mogao_bez_opasnosti">Mogao pomoći bez opasnosti za sebe</option>
                    <option value="nije_mogao">Nije mogao pomoći</option>
                  </select>
                </label>
                <label>
                  Posljedica nepružanja pomoći
                  <select name="failure_to_help_consequence" [(ngModel)]="facts.failure_to_help_consequence">
                    <option value="">Nepoznato</option>
                    <option value="bez_posljedica">Bez posljedica</option>
                    <option value="teska_povreda_ili_narusenje_zdravlja">Teška povreda / narušenje zdravlja</option>
                    <option value="smrt">Smrt</option>
                  </select>
                </label>
              </div>

              <div class="field-grid" *ngIf="activeFactGroup === 'service'">
                <label>
                  Učešće u tuči
                  <select name="fight_participation" [(ngModel)]="facts.fight_participation">
                    <option [ngValue]="null">Nepoznato</option>
                    <option [ngValue]="true">Da, aktivan učesnik</option>
                    <option [ngValue]="false">Ne</option>
                  </select>
                </label>
                <label>
                  Veza sa vršenjem službene dužnosti
                  <select name="duty_connection" [(ngModel)]="facts.duty_connection">
                    <option value="">Nepoznato</option>
                    <option value="pri_vrsenju_duznosti">Pri vršenju dužnosti</option>
                    <option value="u_vezi_sa_vrsenjem_duznosti">U vezi sa vršenjem dužnosti</option>
                    <option value="ne">Ne</option>
                  </select>
                </label>
                <label>
                  Surovo / nečovječno postupanje
                  <select name="inhuman_treatment" [(ngModel)]="facts.inhuman_treatment">
                    <option [ngValue]="null">Nepoznato</option>
                    <option [ngValue]="true">Da</option>
                    <option [ngValue]="false">Ne</option>
                  </select>
                </label>
                <div class="checkbox-group full-width">
                  <span>Vrsta posebne radnje</span>
                  <label class="checkbox-line"><input type="checkbox" [checked]="isChecked(facts.special_action_types, 'sakacenje_zenskih_genitalija')" (change)="toggleMulti('special_action_types', 'sakacenje_zenskih_genitalija', $event)" />Sakaćenje ženskih genitalija</label>
                  <label class="checkbox-line"><input type="checkbox" [checked]="isChecked(facts.special_action_types, 'prisilna_sterilizacija')" (change)="toggleMulti('special_action_types', 'prisilna_sterilizacija', $event)" />Prisilna sterilizacija</label>
                  <label class="checkbox-line"><input type="checkbox" [checked]="isChecked(facts.special_action_types, 'navodjenje_na_samoubistvo')" (change)="toggleMulti('special_action_types', 'navodjenje_na_samoubistvo', $event)" />Navođenje na samoubistvo</label>
                  <label class="checkbox-line"><input type="checkbox" [checked]="isChecked(facts.special_action_types, 'pomaganje_u_samoubistvu')" (change)="toggleMulti('special_action_types', 'pomaganje_u_samoubistvu', $event)" />Pomaganje u samoubistvu</label>
                  <label class="checkbox-line"><input type="checkbox" [checked]="isChecked(facts.special_action_types, 'nelegalni_pobacaj')" (change)="toggleMulti('special_action_types', 'nelegalni_pobacaj', $event)" />Nelegalni pobačaj</label>
                  <label class="checkbox-line"><input type="checkbox" [checked]="isChecked(facts.special_action_types, 'hvatanje_oruzja_pri_svadji')" (change)="toggleMulti('special_action_types', 'hvatanje_oruzja_pri_svadji', $event)" />Hvatanje oružja pri svađi</label>
                </div>
              </div>
            </div>

            <div class="actions">
              <label class="topk">
                Top K
                <input type="number" name="top_k" [(ngModel)]="topK" min="1" max="10" />
              </label>
              <button type="submit" [disabled]="loading || !form.valid">Pokreni rasudjivanje</button>
            </div>

            <div *ngIf="error" class="error">{{ error }}</div>
          </form>
        </section>

        <section class="card results-card">
          <h3>Rezultati</h3>

          <div *ngIf="loading" class="loading">Obrada u toku...</div>
          <div *ngIf="!loading && !response" class="empty">Nema rezultata. Unesi cinjenice i pokreni obradu.</div>

          <div *ngIf="response" class="results">
            <div class="result-block">
              <h4>Rasudjivanje po pravilima</h4>
              <div *ngIf="response.rule_reasoning.applied_norms.length > 0" class="norms">
                <span *ngFor="let norm of response.rule_reasoning.applied_norms" class="norm-chip">{{ norm }}</span>
              </div>
              <div *ngIf="response.rule_reasoning.applied_norms.length === 0" class="empty">Nema pronađenih normi.</div>
            </div>

            <div class="result-block" *ngIf="response.rule_reasoning.applied_norms.length > 0">
              <h4>Norma → Član/Stav</h4>
              <div class="trace-grid">
                <div class="trace-head">Norma</div>
                <div class="trace-head">Mapiranje</div>
                <ng-container *ngFor="let row of normTraceRows(response.rule_reasoning.applied_norms)">
                  <div class="trace-cell norm">{{ row.norm }}</div>
                  <div class="trace-cell map">{{ row.target }}</div>
                </ng-container>
              </div>
            </div>

            <div class="result-block">
              <h4>Predlog presude i sankcije</h4>
              <div class="suggestion-grid">
                <div>
                  <span class="label">Predlog presude</span>
                  <div class="value">{{ response.suggested_verdict || 'Nije dostupno' }}</div>
                </div>
                <div>
                  <span class="label">Predlog sankcije</span>
                  <div class="value">{{ response.suggested_sanction || 'Nije dostupno' }}</div>
                </div>
              </div>
              <div class="selection-grid">
                <label>
                  Izabrana presuda
                  <select name="selectedVerdict" [(ngModel)]="selectedVerdict">
                    <option [ngValue]="''">-- Izaberi --</option>
                    <option value="osudjen">Osudjen</option>
                    <option value="oslobodjen">Oslobodjen</option>
                    <option value="odbijeno">Odbijeno</option>
                  </select>
                </label>
                <label>
                  Izabrana sankcija
                  <input type="text" name="selectedSanction" [(ngModel)]="selectedSanction" placeholder="Kazna zatvora / novcana kazna" />
                </label>
              </div>
            </div>

            <div class="result-block" *ngIf="response.reasoning_confidence as rc">
              <h4>Pouzdanost odluke</h4>
              <div class="confidence-grid">
                <div>
                  <span class="label">Osnov odluke</span>
                  <div class="value">{{ confidenceLabel(rc.decision_basis) }}</div>
                </div>
                <div>
                  <span class="label">Ukupna pouzdanost</span>
                  <div class="value">{{ confidencePercent(rc.final_confidence) }}</div>
                </div>
                <div>
                  <span class="label">Signal pravila</span>
                  <div class="value">{{ confidenceLabel(rc.rule_signal) }}</div>
                </div>
                <div>
                  <span class="label">Signal sličnosti</span>
                  <div class="value">{{ confidenceLabel(rc.cbr_signal) }}</div>
                </div>
                <div>
                  <span class="label">CBR konsenzus</span>
                  <div class="value">{{ confidencePercent(rc.cbr_confidence) }}</div>
                </div>
                <div>
                  <span class="label">Najveća sličnost</span>
                  <div class="value">{{ confidencePercent(rc.cbr_top_similarity) }}</div>
                </div>
              </div>
              <div class="empty" *ngIf="rc.conflict">Konflikt signala: pravila i slični slučajevi ukazuju na različite ishode.</div>
            </div>

            <div class="result-block">
              <h4>Primenjene zakonske odredbe</h4>
              <div *ngIf="response.applied_law_texts.length > 0" class="law-texts">
                <div *ngFor="let law of response.applied_law_texts" class="law-card">
                  <div class="law-title">Clan {{ law.article_number }}{{ law.title ? ' - ' + law.title : '' }}</div>
                  <div class="law-content">{{ law.content }}</div>
                </div>
              </div>
              <div *ngIf="response.applied_law_texts.length === 0" class="empty">Nema dostupnog teksta za norme.</div>
            </div>

            <div class="result-block">
              <h4>Slični slučajevi (CBR)</h4>
              <div *ngIf="response.cbr.matches.length > 0" class="matches">
                <div *ngFor="let match of response.cbr.matches" class="match-row">
                  <div class="match-info">
                    <strong>{{ match.case_number || 'Nepoznato' }}</strong>
                    <span class="outcome" *ngIf="match.outcome">{{ match.outcome }}</span>
                  </div>
                  <div class="match-actions">
                    <div class="similarity">{{ similarityPercent(match.similarity) }}</div>
                    <button type="button" class="match-open" (click)="openFullVerdict(match)">Prikaži cijelu presudu</button>
                  </div>
                </div>
              </div>
              <div *ngIf="response.cbr.matches.length === 0" class="empty">Nema sličnih slučajeva.</div>
              <div *ngIf="matchMessage" class="save-message">{{ matchMessage }}</div>
            </div>

          <div class="result-block">
            <h4>Snimi novi slucaj</h4>
            <div class="save-grid">
              <label>
                Broj predmeta (opciono)
                <input type="text" [(ngModel)]="caseNumber" name="caseNumber" placeholder="USER-..." />
              </label>
              <label>
                Ishod
                <input type="text" [(ngModel)]="caseOutcome" name="caseOutcome" placeholder="usvojeno / odbijeno" />
              </label>
            </div>
              <div class="save-grid">
                <label>
                  Vrsta presude
                  <input type="text" [(ngModel)]="selectedVerdict" name="selectedVerdictInput" placeholder="osudjen / oslobodjen" />
                </label>
                <label>
                  Sankcija
                  <input type="text" [(ngModel)]="selectedSanction" name="selectedSanctionInput" placeholder="npr. kazna zatvora 6 mjeseci" />
                </label>
              </div>
            <button class="secondary" (click)="saveCase()" [disabled]="saving">Sacuvaj slucaj</button>
            <div *ngIf="saveMessage" class="save-message">{{ saveMessage }}</div>
          </div>

          <div class="result-block">
            <h4>Generisi sudsku presudu (Task 9)</h4>
            <div class="save-grid">
              <label>
                Sud (opciono)
                <input type="text" [(ngModel)]="courtName" name="courtName" placeholder="Osnovni sud u Podgorici" />
              </label>
              <label>
                Sudija (opciono)
                <input type="text" [(ngModel)]="judgeName" name="judgeName" placeholder="Sudija" />
              </label>
            </div>
            <button class="secondary" (click)="generateVerdict()" [disabled]="generating || !response">Generisi presudu</button>
            <div *ngIf="generationMessage" class="save-message">{{ generationMessage }}</div>
          </div>
          </div>
        </section>
      </div>

      <div class="verdict-modal-backdrop" *ngIf="verdictDialogOpen" (click)="closeVerdictDialog()">
        <section class="verdict-modal" role="dialog" aria-modal="true" aria-label="Cijela presuda" tabindex="-1" (click)="$event.stopPropagation()" (keydown)="onDialogKeydown($event)">
          <header class="verdict-modal-header">
            <h4>{{ verdictDialog?.case_number || verdictDialog?.case_id || 'Cijela presuda' }}</h4>
            <div class="modal-actions">
              <button type="button" class="copy-button" (click)="copyVerdictCaseNumber()" [disabled]="!verdictDialog?.case_number">Kopiraj broj</button>
              <button type="button" class="close-button" (click)="closeVerdictDialog()">Zatvori</button>
            </div>
          </header>

          <div *ngIf="verdictDialogLoading" class="loading">Učitavanje presude...</div>
          <div *ngIf="!verdictDialogLoading && verdictDialogError" class="error">{{ verdictDialogError }}</div>

          <div *ngIf="!verdictDialogLoading && verdictDialog" class="verdict-modal-content">
            <div class="meta-row"><strong>Sud:</strong> {{ verdictDialog.court_name || 'Nepoznato' }}</div>
            <div class="meta-row" *ngIf="verdictDialog.date"><strong>Datum:</strong> {{ verdictDialog.date }}</div>
            <div class="meta-row" *ngIf="verdictDialog.outcome"><strong>Ishod:</strong> {{ verdictDialog.outcome }}</div>
            <div class="meta-row" *ngIf="copyMessage">{{ copyMessage }}</div>
            <pre class="full-text">{{ verdictDialog.full_text || 'Puni tekst presude nije dostupan.' }}</pre>
          </div>
        </section>
      </div>
    </div>
  `,
  styles: [`
    :host {
      display: block;
      font-family: "Space Grotesk", "Segoe UI", sans-serif;
      color: #1b2a33;
    }

    .reasoning-page {
      display: flex;
      flex-direction: column;
      gap: 28px;
    }

    .hero {
      padding: 28px 30px;
      border-radius: 18px;
      background: linear-gradient(120deg, #f2efe9 0%, #e5f2ef 50%, #f9efe3 100%);
      border: 1px solid #e3e6ea;
    }

    .eyebrow {
      text-transform: uppercase;
      letter-spacing: 2px;
      font-size: 12px;
      font-weight: 600;
      color: #2f6d62;
      margin: 0 0 8px 0;
    }

    .hero h2 {
      margin: 0 0 8px 0;
      font-size: 26px;
    }

    .subtitle {
      margin: 0;
      color: #405862;
    }

    .content-grid {
      display: grid;
      grid-template-columns: minmax(320px, 1.1fr) minmax(320px, 0.9fr);
      gap: 24px;
    }

    .card {
      background: #ffffff;
      border-radius: 16px;
      border: 1px solid #e0e4e8;
      padding: 24px;
      box-shadow: 0 10px 30px rgba(27, 42, 51, 0.08);
    }

    .card h3 {
      margin-top: 0;
      font-size: 20px;
    }

    .field-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
      gap: 16px;
      margin-top: 16px;
    }

    label {
      display: flex;
      flex-direction: column;
      gap: 6px;
      font-weight: 600;
      font-size: 13px;
      color: #3a4c55;
    }

    input,
    select {
      border: 1px solid #d7dde3;
      border-radius: 10px;
      padding: 10px 12px;
      font-size: 14px;
      font-family: inherit;
      background: #f7f9fb;
    }

    .actions {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-top: 20px;
      gap: 12px;
      flex-wrap: wrap;
    }

    .advanced-facts {
      margin-top: 20px;
      padding: 14px;
      border: 1px solid #e0e7ec;
      border-radius: 12px;
      background: #f9fbfc;
    }

    .advanced-facts h4 {
      margin: 0 0 10px 0;
      color: #2a3a42;
      font-size: 15px;
    }

    .group-tabs {
      display: flex;
      flex-wrap: wrap;
      gap: 8px;
      margin-bottom: 12px;
    }

    .group-tabs button {
      background: #e8eef2;
      color: #2a3a42;
      border-radius: 999px;
      padding: 8px 12px;
      font-size: 12px;
      font-weight: 600;
    }

    .group-tabs button.active {
      background: #2f6d62;
      color: #ffffff;
    }

    .checkbox-group {
      display: flex;
      flex-direction: column;
      gap: 6px;
      border: 1px solid #dde6eb;
      border-radius: 10px;
      background: #ffffff;
      padding: 10px 12px;
    }

    .checkbox-group span {
      font-weight: 700;
      font-size: 12px;
      color: #324852;
      text-transform: uppercase;
      letter-spacing: 0.4px;
      margin-bottom: 2px;
    }

    .checkbox-line {
      display: flex;
      flex-direction: row;
      align-items: center;
      gap: 8px;
      font-weight: 500;
      font-size: 13px;
      color: #3a4c55;
    }

    .full-width {
      grid-column: 1 / -1;
    }

    .topk {
      max-width: 120px;
    }

    button {
      background: #197a6b;
      color: white;
      border: none;
      padding: 10px 18px;
      border-radius: 999px;
      font-weight: 600;
      cursor: pointer;
    }

    button:disabled {
      opacity: 0.6;
      cursor: not-allowed;
    }

    button.secondary {
      background: #f1a24a;
      color: #2b1d0e;
    }

    .results {
      display: flex;
      flex-direction: column;
      gap: 20px;
      margin-top: 12px;
    }

    .result-block h4 {
      margin: 0 0 10px 0;
      font-size: 16px;
      color: #2a3a42;
    }

    .norms {
      display: flex;
      flex-wrap: wrap;
      gap: 8px;
    }

    .norm-chip {
      padding: 6px 10px;
      border-radius: 999px;
      background: #e8f4f1;
      color: #1f6a5c;
      font-weight: 600;
      font-size: 12px;
    }

    .matches {
      display: flex;
      flex-direction: column;
      gap: 10px;
    }

    .suggestion-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
      gap: 12px;
      background: #f8f3ea;
      border-radius: 12px;
      padding: 12px 14px;
    }

    .selection-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
      gap: 12px;
      margin-top: 12px;
    }

    .confidence-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
      gap: 10px;
      background: #f7faf8;
      border-radius: 12px;
      border: 1px solid #dbe6e0;
      padding: 12px 14px;
    }

    .trace-grid {
      display: grid;
      grid-template-columns: 1.2fr 1fr;
      border: 1px solid #dce6eb;
      border-radius: 12px;
      overflow: hidden;
    }

    .trace-head {
      background: #edf4f7;
      padding: 8px 10px;
      font-size: 12px;
      font-weight: 700;
      color: #2f4953;
      text-transform: uppercase;
      letter-spacing: 0.5px;
    }

    .trace-cell {
      padding: 8px 10px;
      border-top: 1px solid #edf2f5;
      font-size: 13px;
    }

    .trace-cell.norm {
      color: #35505a;
      background: #ffffff;
    }

    .trace-cell.map {
      color: #1f6a5c;
      background: #fbfdfc;
      font-weight: 600;
    }

    .suggestion-grid .label {
      display: block;
      font-size: 12px;
      text-transform: uppercase;
      letter-spacing: 1px;
      color: #7a5a2f;
      font-weight: 600;
      margin-bottom: 4px;
    }

    .suggestion-grid .value {
      font-weight: 700;
      color: #2b1d0e;
    }

    .law-texts {
      display: grid;
      gap: 12px;
    }

    .law-card {
      border-radius: 12px;
      border: 1px solid #ece6dc;
      background: #fbfaf7;
      padding: 12px 14px;
    }

    .law-title {
      font-weight: 700;
      color: #2f6d62;
      margin-bottom: 6px;
    }

    .law-content {
      white-space: pre-wrap;
      color: #3d4b52;
      line-height: 1.6;
      font-size: 14px;
    }

    .match-row {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 10px 12px;
      border-radius: 12px;
      background: #f6f7f9;
    }

    .match-info {
      display: flex;
      align-items: center;
      gap: 8px;
      flex-wrap: wrap;
    }

    .match-actions {
      display: flex;
      align-items: center;
      gap: 10px;
      flex-wrap: wrap;
      justify-content: flex-end;
    }

    .match-open {
      background: #2f6d62;
      color: #ffffff;
      border: none;
      padding: 6px 12px;
      border-radius: 999px;
      font-size: 12px;
      cursor: pointer;
      white-space: nowrap;
    }

    .outcome {
      margin-left: 8px;
      font-size: 12px;
      color: #a36a2c;
      font-weight: 600;
    }

    .similarity {
      font-weight: 700;
      color: #2f6d62;
    }

    .save-grid {
      display: grid;
      gap: 12px;
      margin-bottom: 12px;
    }

    .loading,
    .empty {
      color: #66757f;
      font-size: 14px;
      padding: 8px 0;
    }

    .error {
      color: #c0392b;
      margin-top: 12px;
      font-weight: 600;
    }

    .save-message {
      margin-top: 10px;
      font-weight: 600;
      color: #2f6d62;
    }

    .verdict-modal-backdrop {
      position: fixed;
      inset: 0;
      background: rgba(20, 33, 39, 0.55);
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 16px;
      z-index: 1100;
    }

    .verdict-modal {
      width: min(920px, 100%);
      max-height: 90vh;
      background: #ffffff;
      border-radius: 16px;
      border: 1px solid #d8e1e6;
      box-shadow: 0 20px 40px rgba(18, 28, 34, 0.25);
      display: flex;
      flex-direction: column;
      overflow: hidden;
    }

    .verdict-modal-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 14px 16px;
      border-bottom: 1px solid #e2e7ea;
      background: #f7faf8;
      position: sticky;
      top: 0;
      z-index: 1;
    }

    .verdict-modal-header h4 {
      margin: 0;
      font-size: 16px;
      color: #21353d;
    }

    .close-button {
      background: #e8edf0;
      color: #21353d;
      border: none;
      border-radius: 999px;
      padding: 8px 12px;
      font-weight: 600;
      cursor: pointer;
    }

    .modal-actions {
      display: flex;
      gap: 8px;
    }

    .copy-button {
      background: #d9efe9;
      color: #174d42;
      border: none;
      border-radius: 999px;
      padding: 8px 12px;
      font-weight: 600;
      cursor: pointer;
    }

    .verdict-modal-content {
      padding: 14px 16px 16px;
      overflow: auto;
    }

    .meta-row {
      margin-bottom: 6px;
      color: #334a53;
      font-size: 14px;
    }

    .full-text {
      margin-top: 12px;
      background: #fbfcfd;
      border: 1px solid #e4eaee;
      border-radius: 10px;
      padding: 12px;
      white-space: pre-wrap;
      font-family: "IBM Plex Sans", "Segoe UI", sans-serif;
      font-size: 14px;
      line-height: 1.6;
      color: #2a4049;
    }

    @media (max-width: 900px) {
      .content-grid {
        grid-template-columns: 1fr;
      }
    }
  `]
})
export class ReasoningComponent {
  facts: CaseFacts = {
    fight_participation: null,
    victim_status: [],
    victim_health_state: '',
    victim_accountability: '',
    victim_previously_abused: null,
    victim_count: '',
    victim_explicit_request: '',
    victim_subordination: null,
    life_consequence_type: '',
    injury_severity_level: '',
    severe_injury_specific_consequences: [],
    danger_to_third_parties: null,
    suicide_outcome: '',
    abortion_outcomes: [],
    execution_manner: [],
    offender_motive: [],
    provocation_types: [],
    injury_means_type: '',
    victim_consent: '',
    sterilization_goal: '',
    guilt_form: '',
    offender_psych_state: '',
    death_attributed_to_negligence: '',
    danger_caused_by_offender: null,
    offender_victim_relationship: '',
    help_provision_ability: '',
    failure_to_help_consequence: '',
    duty_connection: '',
    special_action_types: [],
    inhuman_treatment: null
  };

  activeFactGroup: 'victim' | 'outcome' | 'method' | 'guilt' | 'help' | 'service' = 'victim';

  topK = 5;
  loading = false;
  saving = false;
  error = '';
  response: ReasoningResponse | null = null;
  caseNumber = '';
  caseOutcome = '';
  selectedVerdict = '';
  selectedSanction = '';
  saveMessage = '';
  courtName = '';
  judgeName = '';
  generating = false;
  generationMessage = '';
  matchMessage = '';
  verdictDialogOpen = false;
  verdictDialogLoading = false;
  verdictDialogError = '';
  verdictDialog: VerdictDetail | null = null;
  copyMessage = '';
  private verdictIdByCaseNumber: Record<string, string> = {};

  constructor(
    private reasoningService: ReasoningService,
    private verdictService: VerdictService,
    private router: Router
  ) {}

  runReasoning() {
    this.loading = true;
    this.error = '';
    this.saveMessage = '';
    this.generationMessage = '';
    this.matchMessage = '';

    const payloadFacts = this.buildFactsPayload();
    this.reasoningService.runReasoning({ facts: payloadFacts, top_k: this.topK }).subscribe({
      next: (data: ReasoningResponse) => {
        this.response = data;
        if (!this.selectedVerdict && data.suggested_verdict) {
          this.selectedVerdict = data.suggested_verdict;
        }
        if (!this.selectedSanction && data.suggested_sanction) {
          this.selectedSanction = data.suggested_sanction;
        }
        if (!this.caseOutcome && data.suggested_verdict) {
          this.caseOutcome = data.suggested_verdict;
        }
        this.loadVerdictIndex();
        this.loading = false;
      },
      error: (err: unknown) => {
        this.error = 'Greska pri pokretanju rasudjivanja.';
        this.loading = false;
        console.error(err);
      }
    });
  }

  saveCase() {
    this.saving = true;
    this.saveMessage = '';

    const selectedVerdict = this.selectedVerdict || this.response?.suggested_verdict || this.caseOutcome || undefined;
    const selectedSanction = this.selectedSanction || this.response?.suggested_sanction || undefined;

    if (!selectedVerdict || !selectedSanction) {
      this.saveMessage = 'Prije snimanja morate eksplicitno izabrati presudu i sankciju.';
      this.saving = false;
      return;
    }

    const payloadFacts = this.buildFactsPayload();
    this.reasoningService.saveCase({
      case_number: this.caseNumber || undefined,
      outcome: this.caseOutcome || undefined,
      verdict_type: selectedVerdict,
      sanction: selectedSanction,
      selected_verdict: selectedVerdict,
      selected_sanction: selectedSanction,
      user_confirmation: true,
      facts: payloadFacts
    }).subscribe({
      next: (data: { case_number: string }) => {
        this.saveMessage = `Sačuvan slučaj ${data.case_number}`;
        this.saving = false;
      },
      error: (err: unknown) => {
        const detail = err instanceof HttpErrorResponse ? err.error?.detail : undefined;
        this.saveMessage = detail ? `Greška pri snimanju slučaja: ${detail}` : 'Greška pri snimanju slučaja.';
        this.saving = false;
        console.error(err);
      }
    });
  }

  generateVerdict() {
    if (!this.response) {
      return;
    }
    this.generating = true;
    this.generationMessage = '';

    const payloadFacts = this.buildFactsPayload();
    this.reasoningService.generateVerdict({
      facts: payloadFacts,
      reasoning: this.response,
      case_number: this.caseNumber || undefined,
      court_name: this.courtName || undefined,
      judges: this.judgeName ? [this.judgeName] : undefined,
      selected_verdict: this.selectedVerdict || undefined,
      selected_sanction: this.selectedSanction || undefined
    }).subscribe({
      next: (data: VerdictGenerationResponse) => {
        this.generationMessage = `Presuda generisana (${data.case_number}).`;
        this.generating = false;
        this.router.navigate(['/verdicts', data.case_id]);
      },
      error: (err: unknown) => {
        this.generationMessage = 'Greska pri generisanju presude.';
        this.generating = false;
        console.error(err);
      }
    });
  }

  openFullVerdict(match: CbrMatch): void {
    this.matchMessage = '';

    const directCaseId = (match.verdict_case_id || '').trim();
    if (directCaseId) {
      this.openVerdictDialog(directCaseId);
      return;
    }

    const caseNumber = (match.case_number || '').trim().toLowerCase();
    const resolvedCaseId = this.verdictIdByCaseNumber[caseNumber];
    if (resolvedCaseId) {
      this.openVerdictDialog(resolvedCaseId);
      return;
    }

    this.matchMessage = 'Cijela presuda za izabrani slučaj trenutno nije dostupna u korpusu XML presuda.';
  }

  closeVerdictDialog(): void {
    this.verdictDialogOpen = false;
    this.verdictDialogLoading = false;
    this.verdictDialogError = '';
    this.verdictDialog = null;
    this.copyMessage = '';
  }

  private openVerdictDialog(caseId: string): void {
    this.verdictDialogOpen = true;
    this.verdictDialogLoading = true;
    this.verdictDialogError = '';
    this.verdictDialog = null;
    this.copyMessage = '';

    this.verdictService.getVerdict(caseId).subscribe({
      next: (data) => {
        this.verdictDialog = data;
        this.verdictDialogLoading = false;
      },
      error: () => {
        this.verdictDialogError = 'Neuspjelo učitavanje pune presude.';
        this.verdictDialogLoading = false;
      }
    });
  }

  async copyVerdictCaseNumber(): Promise<void> {
    const value = this.verdictDialog?.case_number || '';
    if (!value) {
      return;
    }
    try {
      await navigator.clipboard.writeText(value);
      this.copyMessage = 'Broj predmeta je kopiran.';
    } catch {
      this.copyMessage = 'Kopiranje nije uspjelo.';
    }
  }

  @HostListener('document:keydown.escape')
  onEscape(): void {
    if (this.verdictDialogOpen) {
      this.closeVerdictDialog();
    }
  }

  onDialogKeydown(event: KeyboardEvent): void {
    if (event.key !== 'Tab') {
      return;
    }
    const root = event.currentTarget as HTMLElement | null;
    if (!root) {
      return;
    }
    const focusable = Array.from(
      root.querySelectorAll<HTMLElement>('button, [href], input, select, textarea, [tabindex]:not([tabindex="-1"])')
    ).filter((el) => !el.hasAttribute('disabled'));
    if (focusable.length === 0) {
      event.preventDefault();
      return;
    }
    const first = focusable[0];
    const last = focusable[focusable.length - 1];
    const active = document.activeElement as HTMLElement | null;

    if (event.shiftKey && active === first) {
      event.preventDefault();
      last.focus();
    } else if (!event.shiftKey && active === last) {
      event.preventDefault();
      first.focus();
    }
  }

  normTraceRows(norms: string[]): Array<{ norm: string; target: string }> {
    return norms.map((norm) => {
      const match = String(norm || '').match(/^crime_art(\d+[a-z]?)(?:_(\d+))?$/i);
      if (!match) {
        return { norm, target: 'N/A' };
      }
      const article = match[1];
      const paragraph = match[2];
      return {
        norm,
        target: paragraph ? `Član ${article}, stav (${paragraph})` : `Član ${article}`,
      };
    });
  }

  private loadVerdictIndex(): void {
    this.verdictService.getVerdicts().subscribe({
      next: (payload) => {
        const index: Record<string, string> = {};
        for (const verdict of payload.verdicts || []) {
          if (verdict.case_number && verdict.case_id) {
            index[verdict.case_number.trim().toLowerCase()] = verdict.case_id;
          }
        }
        this.verdictIdByCaseNumber = index;
      },
      error: () => {
        this.verdictIdByCaseNumber = {};
      }
    });
  }

  similarityPercent(value: number): string {
    return `${Math.round(value * 100)}%`;
  }

  confidencePercent(value: number): string {
    return `${Math.round((value || 0) * 100)}%`;
  }

  confidenceLabel(value: string): string {
    const labels: Record<string, string> = {
      hybrid_consensus: 'Hibridni konsenzus',
      hybrid_conflict_resolution: 'Hibridno razrešenje konflikta',
      rule_only: 'Samo pravila',
      cbr_only: 'Samo slični slučajevi',
      supports_conviction: 'Podržava osudu',
      supports_rejection: 'Podržava odbijanje',
      unavailable: 'Nedostupno',
      unknown: 'Nepoznato',
    };
    return labels[value] || value;
  }

  isChecked(values: string[] | undefined, value: string): boolean {
    return Array.isArray(values) ? values.includes(value) : false;
  }

  toggleMulti(
    field:
      | 'victim_status'
      | 'severe_injury_specific_consequences'
      | 'abortion_outcomes'
      | 'execution_manner'
      | 'offender_motive'
      | 'provocation_types'
      | 'special_action_types',
    value: string,
    event: Event,
  ): void {
    const checked = (event.target as HTMLInputElement).checked;
    const current = [...(this.facts[field] || [])];
    if (checked && !current.includes(value)) {
      current.push(value);
    }
    if (!checked) {
      this.facts[field] = current.filter((entry) => entry !== value);
      return;
    }
    this.facts[field] = current;
  }

  private buildFactsPayload(): CaseFacts {
    const severeConsequence =
      this.facts.injury_severity_level === 'teska' ||
      (this.facts.severe_injury_specific_consequences?.length || 0) > 0;

    // death_result must reflect only explicit life-consequence declaration.
    // Other specialized outcomes (e.g. suicide/abortion) are kept in their own fields.
    const deathResult = this.facts.life_consequence_type === 'smrt_nastupila';

    const weaponUsed =
      this.facts.injury_means_type === 'oruzje' ||
      this.facts.injury_means_type === 'opasno_orudje' ||
      this.facts.injury_means_type === 'sredstvo_podobno_za_tesku_povredu';

    const negligence =
      this.facts.guilt_form === 'nehat' ||
      this.isChecked(this.facts.execution_manner, 'iz_nehata') ||
      this.facts.death_attributed_to_negligence === 'da';

    const provocation = (this.facts.provocation_types?.length || 0) > 0;
    const fightParticipation =
      this.facts.fight_participation ?? this.isChecked(this.facts.special_action_types, 'hvatanje_oruzja_pri_svadji');

    let injuryType = '';
    if (this.facts.injury_severity_level === 'laka') {
      injuryType = 'laka tjelesna povreda';
    } else if (this.facts.injury_severity_level === 'teska') {
      injuryType = 'teska tjelesna povreda';
    } else if (this.facts.injury_severity_level === 'narusenje_zdravlja') {
      injuryType = 'narušavanje zdravlja';
    } else if (this.facts.life_consequence_type === 'tjelesna_povreda') {
      injuryType = 'tjelesna povreda';
    }

    let fightConsequence = 'none';
    if (deathResult) {
      fightConsequence = 'smrt';
    } else if (severeConsequence) {
      fightConsequence = 'teska_povreda';
    } else if (injuryType) {
      fightConsequence = 'laka_povreda';
    }

    let leftWithoutHelp: boolean | null = null;
    if (this.facts.failure_to_help_consequence === 'bez_posljedica') {
      leftWithoutHelp = false;
    } else if (
      this.facts.help_provision_ability === 'mogao_bez_opasnosti' &&
      !!this.facts.failure_to_help_consequence &&
      this.facts.failure_to_help_consequence !== 'bez_posljedica'
    ) {
      leftWithoutHelp = true;
    }

    return {
      ...this.facts,
      defendant: this.facts.defendant || undefined,
      injury_type: injuryType || undefined,
      location: this.facts.location || undefined,
      weapon: this.facts.injury_means_type || undefined,
      weapon_used: weaponUsed,
      severe_consequence: severeConsequence,
      death_result: deathResult,
      negligence,
      provocation,
      fight_participation: fightParticipation,
      fight_consequence: fightConsequence,
      left_without_help: leftWithoutHelp,
    };
  }

}
