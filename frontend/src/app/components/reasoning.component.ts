import { Component, HostListener } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { HttpErrorResponse } from '@angular/common/http';
import { ReasoningService } from '../services/reasoning.service';
import { CaseFacts, CbrMatch, ReasoningResponse, VerdictDetail, VerdictGenerationResponse } from '../models/models';
import { Router } from '@angular/router';
import { VerdictService } from '../services/verdict.service';
import { normalizeRuleFactsInput } from '../services/rule-input-normalization';

@Component({
  selector: 'app-reasoning',
  standalone: true,
  imports: [CommonModule, FormsModule],
  template: `
    <div class="reasoning-page">
      <header class="hero">
        <div>
          <p class="eyebrow">Rasuđivanje</p>
          <h2>Unos slučaja i predlog presude</h2>
          <p class="subtitle">Popuni opis činjenica kroz napredne pravne atribute, pokreni rasuđivanje i sačuvaj novi slučaj.</p>
        </div>
      </header>

      <div class="content-grid">
        <section class="card form-card">
          <h3>Opis činjenica</h3>
          <form (ngSubmit)="runReasoning()" (change)="onFactsChanged()" #form="ngForm">
            <div class="advanced-facts">
              <h4>Napredni pravni atributi</h4>
              <div class="facts-layout">
                <section class="fact-group">
                  <h5>Grupa 1: Osnovni podaci o učiniocu</h5>
                  <div class="field-grid">
                    <label>
                      Okrivljeni (ime/ID)
                      <input type="text" name="defendant" [(ngModel)]="facts.defendant" placeholder="Ime ili identifikator okrivljenog" />
                    </label>
                  </div>
                </section>

                <section class="fact-group">
                  <h5>Grupa 2: Ishod po život žrtve</h5>
                  <div class="field-grid">
                    <label>
                      Ishod po život žrtve
                      <select name="life_consequence_type" [(ngModel)]="facts.life_consequence_type">
                        <option value="">Nije nastupila smrt / nije odabrano</option>
                        <option value="smrt_nastupila">smrt_nastupila</option>
                      </select>
                    </label>
                  </div>
                </section>

                <section class="fact-group">
                  <h5>Grupa 3: Oblik krivice</h5>
                  <div class="field-grid">
                    <label>
                      Oblik krivice
                      <select name="guilt_form" [(ngModel)]="facts.guilt_form">
                        <option value="">Nije odabrano</option>
                        <option value="umisljaj_direktni">umisljaj direktni</option>
                        <option value="umisljaj_eventualni">umisljaj eventualni</option>
                        <option value="nehat">nehat</option>
                      </select>
                    </label>
                  </div>
                </section>

                <section class="fact-group">
                  <h5>Grupa 4: Način izvršenja</h5>
                  <div class="field-grid">
                    <div class="checkbox-group full-width">
                      <span>Način izvršenja</span>
                      <label class="checkbox-line"><input type="checkbox" [checked]="isChecked(facts.execution_manner, 'svirep')" (change)="toggleMulti('execution_manner', 'svirep', $event)" />svirep</label>
                      <label class="checkbox-line"><input type="checkbox" [checked]="isChecked(facts.execution_manner, 'podmukao')" (change)="toggleMulti('execution_manner', 'podmukao', $event)" />podmukao</label>
                      <label class="checkbox-line"><input type="checkbox" [checked]="isChecked(facts.execution_manner, 'bezobzirno_nasilnicko_ponasanje')" (change)="toggleMulti('execution_manner', 'bezobzirno_nasilnicko_ponasanje', $event)" />bezobzirno nasilničko ponašanje</label>
                      <label class="checkbox-line"><input type="checkbox" [checked]="isChecked(facts.execution_manner, 'na_mah')" (change)="toggleMulti('execution_manner', 'na_mah', $event)" />na mah</label>
                    </div>

                    <div class="checkbox-group full-width" *ngIf="isNaMahContext()">
                      <span>Vrste provokacija</span>
                      <label class="checkbox-line"><input type="checkbox" [checked]="isChecked(facts.provocation_types, 'napad_od_ubijenog')" (change)="toggleMulti('provocation_types', 'napad_od_ubijenog', $event)" />napad od ubijenog</label>
                      <label class="checkbox-line"><input type="checkbox" [checked]="isChecked(facts.provocation_types, 'zlostavljanje_od_ubijenog')" (change)="toggleMulti('provocation_types', 'zlostavljanje_od_ubijenog', $event)" />zlostavljanje od ubijenog</label>
                      <label class="checkbox-line"><input type="checkbox" [checked]="isChecked(facts.provocation_types, 'tesko_vrijedjanje_od_ubijenog')" (change)="toggleMulti('provocation_types', 'tesko_vrijedjanje_od_ubijenog', $event)" />teško vrijeđanje od ubijenog</label>
                      <label class="checkbox-line"><input type="checkbox" [checked]="isChecked(facts.provocation_types, 'bez_krivice_ucinioca')" (change)="toggleMulti('provocation_types', 'bez_krivice_ucinioca', $event)" />bez krivice učinioca</label>
                    </div>

                    <label *ngIf="isNaMahContext()">
                      Visoki intenzitet stresa
                      <select name="high_intensity_distress" [(ngModel)]="facts.high_intensity_distress">
                        <option [ngValue]="null">Nije odabrano</option>
                        <option [ngValue]="true">da</option>
                        <option [ngValue]="false">ne</option>
                      </select>
                    </label>
                  </div>
                </section>

                <section class="fact-group">
                  <h5>Grupa 5: Motiv učinioca</h5>
                  <div class="field-grid">
                    <div class="checkbox-group full-width">
                      <span>Motiv učinioca</span>
                      <label class="checkbox-line"><input type="checkbox" [checked]="isChecked(facts.offender_motive, 'koristoljublje')" (change)="toggleMulti('offender_motive', 'koristoljublje', $event)" />koristoljublje</label>
                      <label class="checkbox-line"><input type="checkbox" [checked]="isChecked(facts.offender_motive, 'izvrsenje_ili_prikrivanje_drugog_krivicnog_djela')" (change)="toggleMulti('offender_motive', 'izvrsenje_ili_prikrivanje_drugog_krivicnog_djela', $event)" />izvršenje ili prikrivanje drugog krivičnog djela</label>
                      <label class="checkbox-line"><input type="checkbox" [checked]="isChecked(facts.offender_motive, 'niske_pobude')" (change)="toggleMulti('offender_motive', 'niske_pobude', $event)" />niske pobude</label>
                      <label class="checkbox-line"><input type="checkbox" [checked]="isChecked(facts.offender_motive, 'bezobzirna_osveta')" (change)="toggleMulti('offender_motive', 'bezobzirna_osveta', $event)" />bezobzirna osveta</label>
                      <label class="checkbox-line"><input type="checkbox" [checked]="isChecked(facts.offender_motive, 'samilost')" (change)="toggleMulti('offender_motive', 'samilost', $event)" />samilost</label>
                    </div>
                  </div>
                </section>

                <section class="fact-group">
                  <h5>Grupa 6: Status i karakteristike žrtve</h5>
                  <div class="field-grid">
                    <div class="checkbox-group full-width">
                      <span>Status i karakteristike žrtve</span>
                      <label class="checkbox-line"><input type="checkbox" [checked]="isChecked(facts.victim_status, 'sluzbeno_lice')" (change)="toggleMulti('victim_status', 'sluzbeno_lice', $event)" />službeno lice</label>
                      <label class="checkbox-line"><input type="checkbox" [checked]="isChecked(facts.victim_status, 'vojno_lice')" (change)="toggleMulti('victim_status', 'vojno_lice', $event)" />vojno lice</label>
                      <label class="checkbox-line"><input type="checkbox" [checked]="isChecked(facts.victim_status, 'dijete')" (change)="toggleMulti('victim_status', 'dijete', $event)" />dijete</label>
                      <label class="checkbox-line"><input type="checkbox" [checked]="isChecked(facts.victim_status, 'bremenita_zena')" (change)="toggleMulti('victim_status', 'bremenita_zena', $event)" />bremenita žena</label>
                      <label class="checkbox-line"><input type="checkbox" [checked]="isChecked(facts.victim_status, 'clan_porodice')" (change)="toggleMulti('victim_status', 'clan_porodice', $event)" />član porodice</label>
                      <label class="checkbox-line"><input type="checkbox" [checked]="isChecked(facts.victim_status, 'punoljetno_lice')" (change)="toggleMulti('victim_status', 'punoljetno_lice', $event)" />punoljetno lice</label>
                      <label class="checkbox-line"><input type="checkbox" [checked]="isChecked(facts.victim_status, 'maloljetnik')" (change)="toggleMulti('victim_status', 'maloljetnik', $event)" />maloljetnik</label>
                      <label class="checkbox-line"><input type="checkbox" [checked]="isChecked(facts.victim_status, 'maloljetna_trudnica')" (change)="toggleMulti('victim_status', 'maloljetna_trudnica', $event)" />maloljetna trudnica</label>
                    </div>

                    <label *ngIf="hasOfficialVictimStatus()">
                      Veza sa dužnošću
                      <select name="duty_connection" [(ngModel)]="facts.duty_connection">
                        <option value="">Nije odabrano</option>
                        <option value="u_vrsenju_sluzbene_duznosti">u vršenju službene dužnosti</option>
                      </select>
                    </label>

                    <label *ngIf="hasVictimStatus('clan_porodice')">
                      Žrtva prethodno zlostavljana
                      <select name="victim_previously_abused" [(ngModel)]="facts.victim_previously_abused">
                        <option [ngValue]="null">Nije odabrano</option>
                        <option [ngValue]="true">da</option>
                        <option [ngValue]="false">ne</option>
                      </select>
                    </label>

                    <label *ngIf="hasVictimStatus('punoljetno_lice')">
                      Zdravstveno stanje žrtve
                      <select name="victim_health_state" [(ngModel)]="facts.victim_health_state">
                        <option value="">Nije odabrano</option>
                        <option value="tesko_zdravstveno_stanje">teško zdravstveno stanje</option>
                      </select>
                    </label>

                    <label *ngIf="hasVictimStatus('punoljetno_lice')">
                      Eksplicitni zahtjev žrtve
                      <select name="victim_explicit_request" [(ngModel)]="facts.victim_explicit_request">
                        <option value="">Nije odabrano</option>
                        <option value="da">da</option>
                        <option value="ne">ne</option>
                      </select>
                    </label>

                    <label *ngIf="hasVictimStatus('maloljetna_trudnica')">
                      Saglasnost staratelja
                      <select name="guardian_consent" [(ngModel)]="facts.guardian_consent">
                        <option value="">Nije odabrano</option>
                        <option value="da">da</option>
                        <option value="ne">ne</option>
                      </select>
                    </label>

                    <label *ngIf="hasVictimStatus('maloljetna_trudnica') || isIllegalAbortionContext()">
                      Saglasnost žrtve
                      <select name="victim_consent" [(ngModel)]="facts.victim_consent">
                        <option value="">Nije odabrano</option>
                        <option value="pristanak">pristanak</option>
                        <option value="bez_pristanka">bez_pristanka</option>
                      </select>
                    </label>
                  </div>
                </section>

                <section class="fact-group">
                  <h5>Grupa 7: Broj žrtava</h5>
                  <div class="field-grid">
                    <label>
                      Broj žrtava
                      <select name="victim_count" [(ngModel)]="facts.victim_count">
                        <option value="">Nije odabrano</option>
                        <option value="jedna">jedna</option>
                        <option value="vise">vise</option>
                      </select>
                    </label>
                  </div>
                </section>

                <section class="fact-group">
                  <h5>Grupa 8: Opasnost po treća lica</h5>
                  <div class="field-grid">
                    <label>
                      Opasnost po treća lica
                      <select name="danger_to_third_parties" [(ngModel)]="facts.danger_to_third_parties">
                        <option [ngValue]="null">Nije odabrano</option>
                        <option [ngValue]="true">da</option>
                        <option [ngValue]="false">ne</option>
                      </select>
                    </label>
                  </div>
                </section>

                <section class="fact-group">
                  <h5>Grupa 9: Posebne radnje učinioca</h5>
                  <div class="field-grid">
                    <div class="checkbox-group full-width">
                      <span>Posebne radnje učinioca</span>
                      <label class="checkbox-line"><input type="checkbox" [checked]="isChecked(facts.special_action_types, 'navodjenje_na_samoubistvo')" (change)="toggleMulti('special_action_types', 'navodjenje_na_samoubistvo', $event)" />navođenje na samoubistvo</label>
                      <label class="checkbox-line"><input type="checkbox" [checked]="isChecked(facts.special_action_types, 'pomaganje_u_samoubistvu')" (change)="toggleMulti('special_action_types', 'pomaganje_u_samoubistvu', $event)" />pomoć u samoubistvu</label>
                      <label class="checkbox-line"><input type="checkbox" [checked]="isChecked(facts.special_action_types, 'nelegalni_pobacaj')" (change)="toggleMulti('special_action_types', 'nelegalni_pobacaj', $event)" />nelegalni pobačaj</label>
                      <label class="checkbox-line"><input type="checkbox" [checked]="isChecked(facts.special_action_types, 'sakacenje_zenskih_genitalija')" (change)="toggleMulti('special_action_types', 'sakacenje_zenskih_genitalija', $event)" />sakaćenje ženskih genitalija</label>
                      <label class="checkbox-line"><input type="checkbox" [checked]="isChecked(facts.special_action_types, 'prisilna_sterilizacija')" (change)="toggleMulti('special_action_types', 'prisilna_sterilizacija', $event)" />prisilna sterilizacija</label>
                    </div>

                    <label *ngIf="isSuicideActionContext()">
                      Ishod samoubistva
                      <select name="suicide_outcome" [(ngModel)]="facts.suicide_outcome">
                        <option value="">Nije odabrano</option>
                        <option value="izvrseno">izvršeno</option>
                        <option value="pokusano">pokušano</option>
                      </select>
                    </label>

                    <label *ngIf="isSuicideActionContext()">
                      Odgovornost žrtve
                      <select name="victim_accountability" [(ngModel)]="facts.victim_accountability">
                        <option value="">uracunljivo (implicitno)</option>
                        <option value="neuracunljivo">neuracunljivo</option>
                        <option value="bitno_smanjena_uracunljivost">bitno smanjena uračunljivost</option>
                      </select>
                    </label>

                    <label *ngIf="isIllegalAbortionContext()">
                      Način radnje pobačaja
                      <select name="abortion_action_mode" [(ngModel)]="facts.abortion_action_mode">
                        <option value="">Nije odabrano</option>
                        <option value="izvrsi_pobacaj">izvrši pobačaj</option>
                        <option value="pomogne_izvrsenje_pobacaja">pomogne izvršenje pobačaja</option>
                      </select>
                    </label>

                    <div class="checkbox-group full-width" *ngIf="isIllegalAbortionContext()">
                      <span>Ishodi pobačaja</span>
                      <label class="checkbox-line"><input type="checkbox" [checked]="isChecked(facts.abortion_outcomes, 'smrt')" (change)="toggleMulti('abortion_outcomes', 'smrt', $event)" />smrt</label>
                      <label class="checkbox-line"><input type="checkbox" [checked]="isChecked(facts.abortion_outcomes, 'tesko_narusavanje_zdravlja')" (change)="toggleMulti('abortion_outcomes', 'tesko_narusavanje_zdravlja', $event)" />teško narušavanje zdravlja</label>
                      <label class="checkbox-line"><input type="checkbox" [checked]="isChecked(facts.abortion_outcomes, 'teska_tjelesna_povreda')" (change)="toggleMulti('abortion_outcomes', 'teska_tjelesna_povreda', $event)" />teška tjelesna povreda</label>
                      <label class="checkbox-line"><input type="checkbox" [checked]="isChecked(facts.abortion_outcomes, 'pobacaj_izvrsen')" (change)="toggleMulti('abortion_outcomes', 'pobacaj_izvrsen', $event)" />pobačaj izvršen</label>
                    </div>

                    <label *ngIf="isForcedSterilizationContext()">
                      Cilj sterilizacije
                      <select name="sterilization_goal" [(ngModel)]="facts.sterilization_goal">
                        <option value="">Nije odabrano</option>
                        <option value="onemogucavanje_reprodukcije">onemogućavanje reprodukcije</option>
                      </select>
                    </label>
                  </div>
                </section>

                <section class="fact-group">
                  <h5>Grupa 10: Psihičko stanje učinioca</h5>
                  <div class="field-grid">
                    <label>
                      Psihičko stanje učinioca
                      <select name="offender_psych_state" [(ngModel)]="facts.offender_psych_state">
                        <option value="">Nije odabrano</option>
                        <option value="porodjajni_poremecaj">porođajni poremećaj</option>
                      </select>
                    </label>

                    <label *ngIf="facts.offender_psych_state === 'porodjajni_poremecaj'">
                      Učinilac je majka
                      <select name="offender_is_mother" [(ngModel)]="facts.offender_is_mother">
                        <option [ngValue]="null">Nije odabrano</option>
                        <option [ngValue]="true">da</option>
                        <option [ngValue]="false">ne</option>
                      </select>
                    </label>
                  </div>
                </section>

                <section class="fact-group">
                  <h5>Grupa 11: Tjelesne povrede</h5>
                  <div class="field-grid">
                    <label>
                      Vrsta povrede
                      <select name="injury_type" [(ngModel)]="facts.injury_type">
                        <option value="">Nije odabrano</option>
                        <option value="teska tjelesna povreda">teška tjelesna povreda</option>
                        <option value="laka tjelesna povreda">laka tjelesna povreda</option>
                      </select>
                    </label>

                    <div class="checkbox-group full-width" *ngIf="isHeavyInjuryContext()">
                      <span>Specifične posljedice teške povrede</span>
                      <label class="checkbox-line"><input type="checkbox" [checked]="isChecked(facts.severe_injury_specific_consequences, 'opasnost_po_zivot')" (change)="toggleMulti('severe_injury_specific_consequences', 'opasnost_po_zivot', $event)" />opasnost po život</label>
                      <label class="checkbox-line"><input type="checkbox" [checked]="isChecked(facts.severe_injury_specific_consequences, 'unistenje_dijela_tijela')" (change)="toggleMulti('severe_injury_specific_consequences', 'unistenje_dijela_tijela', $event)" />uništenje dijela tijela</label>
                      <label class="checkbox-line"><input type="checkbox" [checked]="isChecked(facts.severe_injury_specific_consequences, 'trajno_ostecenje_organa')" (change)="toggleMulti('severe_injury_specific_consequences', 'trajno_ostecenje_organa', $event)" />trajno oštećenje organa</label>
                      <label class="checkbox-line"><input type="checkbox" [checked]="isChecked(facts.severe_injury_specific_consequences, 'trajna_nesposobnost_za_rad')" (change)="toggleMulti('severe_injury_specific_consequences', 'trajna_nesposobnost_za_rad', $event)" />trajna nesposobnost za rad</label>
                      <label class="checkbox-line"><input type="checkbox" [checked]="isChecked(facts.severe_injury_specific_consequences, 'trajno_naruseno_zdravlje')" (change)="toggleMulti('severe_injury_specific_consequences', 'trajno_naruseno_zdravlje', $event)" />trajno narušeno zdravlje</label>
                      <label class="checkbox-line"><input type="checkbox" [checked]="isChecked(facts.severe_injury_specific_consequences, 'unakazenost')" (change)="toggleMulti('severe_injury_specific_consequences', 'unakazenost', $event)" />unakaženost</label>
                    </div>

                    <label *ngIf="isHeavyInjuryContext()">
                      Rezultat smrti
                      <select name="death_result" [(ngModel)]="facts.death_result">
                        <option [ngValue]="null">Nije odabrano</option>
                        <option [ngValue]="true">da</option>
                        <option [ngValue]="false">ne</option>
                      </select>
                    </label>

                    <label *ngIf="isHeavyInjuryContext()">
                      Nemarnost
                      <select name="negligence" [(ngModel)]="facts.negligence">
                        <option [ngValue]="null">Nije odabrano</option>
                        <option [ngValue]="true">da</option>
                        <option [ngValue]="false">ne</option>
                      </select>
                    </label>

                    <label *ngIf="isLightInjuryContext()">
                      Korišteno oružje
                      <select name="weapon_used" [(ngModel)]="facts.weapon_used">
                        <option [ngValue]="null">Nije odabrano</option>
                        <option [ngValue]="true">da</option>
                        <option [ngValue]="false">ne</option>
                      </select>
                    </label>

                    <label *ngIf="isLightInjuryContext() || facts.fight_participation === true">
                      Vrsta sredstva povrede
                      <select name="injury_means_type" [(ngModel)]="facts.injury_means_type">
                        <option value="">Nije odabrano</option>
                        <option value="opasno_orudje">opasno oruđe</option>
                        <option value="sredstvo_podobno_za_tesku_povredu">sredstvo podobno za tešku povredu</option>
                      </select>
                    </label>

                    <label *ngIf="isLightInjuryContext()">
                      Provokacija
                      <select name="provocation" [(ngModel)]="facts.provocation">
                        <option [ngValue]="null">Nije odabrano</option>
                        <option [ngValue]="true">da</option>
                        <option [ngValue]="false">ne</option>
                      </select>
                    </label>
                  </div>
                </section>

                <section class="fact-group">
                  <h5>Grupa 12: Tuča i svađa</h5>
                  <div class="field-grid">
                    <label>
                      Učešće u tuči
                      <select name="fight_participation" [(ngModel)]="facts.fight_participation">
                        <option [ngValue]="null">Nije odabrano</option>
                        <option [ngValue]="true">da</option>
                        <option [ngValue]="false">ne</option>
                      </select>
                    </label>

                    <label *ngIf="facts.fight_participation === true && !isLightInjuryContext()">
                      Korišteno oružje
                      <select name="weapon_used_fight" [(ngModel)]="facts.weapon_used">
                        <option [ngValue]="null">Nije odabrano</option>
                        <option [ngValue]="true">da</option>
                        <option [ngValue]="false">ne</option>
                      </select>
                    </label>

                    <label *ngIf="facts.fight_participation === true && !isLightInjuryContext()">
                      Vrsta sredstva povrede
                      <select name="injury_means_type_fight" [(ngModel)]="facts.injury_means_type">
                        <option value="">Nije odabrano</option>
                        <option value="opasno_orudje">opasno oruđe</option>
                        <option value="sredstvo_podobno_za_tesku_povredu">sredstvo podobno za tešku povredu</option>
                      </select>
                    </label>
                  </div>
                </section>

                <section class="fact-group">
                  <h5>Grupa 13: Ostavljanje bez pomoći</h5>
                  <div class="field-grid">
                    <label>
                      Ostavljanje bez pomoći
                      <select name="left_without_help" [(ngModel)]="facts.left_without_help">
                        <option [ngValue]="null">Nije odabrano</option>
                        <option [ngValue]="true">da</option>
                        <option [ngValue]="false">ne</option>
                      </select>
                    </label>

                    <label *ngIf="facts.left_without_help === true">
                      Odnos učinioca i žrtve
                      <select name="offender_victim_relationship" [(ngModel)]="facts.offender_victim_relationship">
                        <option value="">Nije odabrano</option>
                        <option value="povjereno_nemocno_lice">povjereno nemoćno lice</option>
                        <option value="duznost_staranja">dužnost staranja</option>
                        <option value="prolaznik">prolaznik</option>
                      </select>
                    </label>

                    <label *ngIf="facts.left_without_help === true">
                      Opasnost prouzrokovana od učinioca
                      <select name="danger_caused_by_offender" [(ngModel)]="facts.danger_caused_by_offender">
                        <option [ngValue]="null">Nije odabrano</option>
                        <option [ngValue]="true">da</option>
                        <option [ngValue]="false">ne</option>
                      </select>
                    </label>

                    <label *ngIf="facts.left_without_help === true && facts.danger_caused_by_offender === true">
                      Opasnost po život
                      <select name="danger_to_life" [(ngModel)]="facts.danger_to_life">
                        <option [ngValue]="null">Nije odabrano</option>
                        <option [ngValue]="true">da</option>
                        <option [ngValue]="false">ne</option>
                      </select>
                    </label>

                    <label *ngIf="facts.left_without_help === true && facts.danger_caused_by_offender === true">
                      Opasnost po zdravlje
                      <select name="danger_to_health" [(ngModel)]="facts.danger_to_health">
                        <option [ngValue]="null">Nije odabrano</option>
                        <option [ngValue]="true">da</option>
                        <option [ngValue]="false">ne</option>
                      </select>
                    </label>

                    <label *ngIf="facts.left_without_help === true && facts.offender_victim_relationship === 'prolaznik'">
                      Mogućnost pružanja pomoći
                      <select name="help_provision_ability" [(ngModel)]="facts.help_provision_ability">
                        <option value="">Nije odabrano</option>
                        <option value="mogao_bez_opasnosti">mogao bez opasnosti</option>
                      </select>
                    </label>

                    <label *ngIf="facts.left_without_help === true && facts.offender_victim_relationship === 'prolaznik'">
                      Posljedica neukazivanja pomoći
                      <select name="failure_to_help_consequence" [(ngModel)]="facts.failure_to_help_consequence">
                        <option value="">Nije odabrano</option>
                        <option value="tesko_narusavanje_zdravlja">teško narušavanje zdravlja</option>
                        <option value="teska_tjelesna_povreda">teška tjelesna povreda</option>
                        <option value="smrt">smrt</option>
                      </select>
                    </label>
                  </div>
                </section>

                <section class="fact-group">
                  <h5>Grupa 14: Nečovječno postupanje</h5>
                  <div class="field-grid">
                    <label>
                      Nečovječno postupanje
                      <select name="inhuman_treatment" [(ngModel)]="facts.inhuman_treatment">
                        <option [ngValue]="null">Nije odabrano</option>
                        <option [ngValue]="true">da</option>
                        <option [ngValue]="false">ne</option>
                      </select>
                    </label>

                    <label *ngIf="facts.inhuman_treatment === true">
                      Podređenost žrtve
                      <select name="victim_subordination" [(ngModel)]="facts.victim_subordination">
                        <option [ngValue]="null">Nije odabrano</option>
                        <option [ngValue]="true">da</option>
                        <option [ngValue]="false">ne</option>
                      </select>
                    </label>

                    <label *ngIf="facts.inhuman_treatment === true">
                      Smrt pripisana nemarnosti
                      <select name="death_attributed_to_negligence" [(ngModel)]="facts.death_attributed_to_negligence">
                        <option value="">Nije odabrano</option>
                        <option value="da">da</option>
                        <option value="ne">ne</option>
                      </select>
                    </label>
                  </div>
                </section>

                <section class="fact-group">
                  <h5>Grupa 15: Individualizacija kazne</h5>
                  <div class="field-grid">
                    <label>
                      Ranije osuđivan
                      <select name="previous_convictions" [(ngModel)]="facts.previous_convictions">
                        <option [ngValue]="null">Nije odabrano</option>
                        <option [ngValue]="true">da</option>
                        <option [ngValue]="false">ne</option>
                      </select>
                    </label>

                    <label>
                      Povratnik
                      <select name="repeat_offender" [(ngModel)]="facts.repeat_offender">
                        <option [ngValue]="null">Nije odabrano</option>
                        <option [ngValue]="true">da</option>
                        <option [ngValue]="false">ne</option>
                      </select>
                    </label>

                    <label>
                      Priznanje krivice
                      <select name="confession" [(ngModel)]="facts.confession">
                        <option [ngValue]="null">Nije odabrano</option>
                        <option [ngValue]="true">da</option>
                        <option [ngValue]="false">ne</option>
                      </select>
                    </label>

                    <label>
                      Iskreno kajanje
                      <select name="remorse" [(ngModel)]="facts.remorse">
                        <option [ngValue]="null">Nije odabrano</option>
                        <option [ngValue]="true">da</option>
                        <option [ngValue]="false">ne</option>
                      </select>
                    </label>

                    <label>
                      Sporazum o priznanju krivice
                      <select name="plea_agreement" [(ngModel)]="facts.plea_agreement">
                        <option [ngValue]="null">Nije odabrano</option>
                        <option [ngValue]="true">da</option>
                        <option [ngValue]="false">ne</option>
                      </select>
                    </label>

                    <label>
                      Otežavajuće okolnosti
                      <select name="aggravating_circumstances" [(ngModel)]="facts.aggravating_circumstances">
                        <option [ngValue]="null">Nije odabrano</option>
                        <option [ngValue]="true">da</option>
                        <option [ngValue]="false">ne</option>
                      </select>
                    </label>

                    <label>
                      Olakšavajuće okolnosti
                      <select name="mitigating_circumstances" [(ngModel)]="facts.mitigating_circumstances">
                        <option [ngValue]="null">Nije odabrano</option>
                        <option [ngValue]="true">da</option>
                        <option [ngValue]="false">ne</option>
                      </select>
                    </label>

                    <label>
                      Porodične prilike
                      <select name="family_circumstances" [(ngModel)]="facts.family_circumstances">
                        <option [ngValue]="null">Nije odabrano</option>
                        <option [ngValue]="true">da</option>
                        <option [ngValue]="false">ne</option>
                      </select>
                    </label>

                    <label>
                      Loše imovno stanje
                      <select name="poor_financial_status" [(ngModel)]="facts.poor_financial_status">
                        <option [ngValue]="null">Nije odabrano</option>
                        <option [ngValue]="true">da</option>
                        <option [ngValue]="false">ne</option>
                      </select>
                    </label>

                    <label>
                      Alkoholisanost učinioca
                      <select name="alcohol_intoxication" [(ngModel)]="facts.alcohol_intoxication">
                        <option [ngValue]="null">Nije odabrano</option>
                        <option [ngValue]="true">da</option>
                        <option [ngValue]="false">ne</option>
                      </select>
                    </label>

                    <label>
                      Uticaj narkotika
                      <select name="narcotics_influence" [(ngModel)]="facts.narcotics_influence">
                        <option [ngValue]="null">Nije odabrano</option>
                        <option [ngValue]="true">da</option>
                        <option [ngValue]="false">ne</option>
                      </select>
                    </label>

                    <label>
                      Predlog uslovne osude
                      <select name="conditional_sentence_requested" [(ngModel)]="facts.conditional_sentence_requested">
                        <option [ngValue]="null">Nije odabrano</option>
                        <option [ngValue]="true">da</option>
                        <option [ngValue]="false">ne</option>
                      </select>
                    </label>

                    <label>
                      Delo u pokušaju
                      <select name="attempted_offense" [(ngModel)]="facts.attempted_offense">
                        <option [ngValue]="null">Nije odabrano</option>
                        <option [ngValue]="true">da</option>
                        <option [ngValue]="false">ne</option>
                      </select>
                    </label>
                  </div>
                </section>
              </div>
            </div>

            <div class="actions">
              <label class="topk">
                Broj rezultata
                <input type="number" name="top_k" [(ngModel)]="topK" min="1" max="10" />
              </label>
              <button type="submit" [disabled]="loading || !form.valid">Pokreni rasuđivanje</button>
            </div>

            <div *ngIf="error" class="error">{{ error }}</div>
          </form>
        </section>

        <section class="card results-card">
          <h3>Rezultati</h3>

          <div *ngIf="loading" class="loading">Obrada u toku...</div>
          <div *ngIf="!loading && !response" class="empty">Nema rezultata. Unesi činjenice i pokreni obradu.</div>

          <div *ngIf="response" class="results">
            <div class="result-block">
              <h4>Rasuđivanje po pravilima</h4>
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
                    <option value="osudjen">Osuđen</option>
                    <option value="oslobodjen">Oslobođen</option>
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
                  <div class="law-title">Član {{ law.article_number }}{{ law.title ? ' - ' + law.title : '' }}</div>
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
            <h4>Snimi novi slučaj</h4>
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
                  <input type="text" [(ngModel)]="selectedVerdict" name="selectedVerdictInput" placeholder="osuđen / oslobođen" />
                </label>
                <label>
                  Sankcija
                  <input type="text" [(ngModel)]="selectedSanction" name="selectedSanctionInput" placeholder="npr. kazna zatvora 6 mjeseci" />
                </label>
              </div>
            <button class="secondary" (click)="saveCase()" [disabled]="saving">Sačuvaj slučaj</button>
            <div *ngIf="saveMessage" class="save-message">{{ saveMessage }}</div>
          </div>

          <div class="result-block">
            <h4>Generiši sudsku presudu (Zadatak 9)</h4>
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
            <button class="secondary" (click)="generateVerdict()" [disabled]="generating || !response">Generiši presudu</button>
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

    .facts-layout {
      display: flex;
      flex-direction: column;
      gap: 12px;
    }

    .fact-group {
      border: 1px solid #dde6eb;
      border-radius: 12px;
      background: #ffffff;
      padding: 12px;
    }

    .fact-group h5 {
      margin: 0 0 10px 0;
      color: #27414b;
      font-size: 14px;
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

    .field-helper {
      margin-top: 2px;
      font-size: 11px;
      line-height: 1.35;
      color: #6a7f8a;
      font-weight: 500;
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
    left_without_help: null,
    weapon_used: null,
    death_result: null,
    negligence: null,
    previous_convictions: null,
    repeat_offender: null,
    confession: null,
    remorse: null,
    plea_agreement: null,
    aggravating_circumstances: null,
    mitigating_circumstances: null,
    family_circumstances: null,
    poor_financial_status: null,
    alcohol_intoxication: null,
    narcotics_influence: null,
    conditional_sentence_requested: null,
    attempted_offense: null,
    injury_type: '',
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
    guardian_consent: '',
    abortion_action_mode: '',
    sterilization_goal: '',
    guilt_form: '',
    offender_psych_state: '',
    high_intensity_distress: null,
    offender_is_mother: null,
    death_attributed_to_negligence: '',
    danger_to_life: null,
    danger_to_health: null,
    danger_caused_by_offender: null,
    offender_victim_relationship: '',
    help_provision_ability: '',
    failure_to_help_consequence: '',
    duty_connection: '',
    special_action_types: [],
    inhuman_treatment: null
  };

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
    // Scroll to top of page
    window.scrollTo(0, 0);
    
    this.loading = true;
    this.error = '';
    this.saveMessage = '';
    this.generationMessage = '';
    this.matchMessage = '';

    const payloadFacts = this.buildFactsPayload();
    console.group('[Reasoning][Frontend] Request payload');
    console.log('top_k:', this.topK);
    console.log('facts:', payloadFacts);
    console.log('focus_153_154:', {
      defendant: payloadFacts.defendant,
      fight_participation: payloadFacts.fight_participation,
      injury_type: payloadFacts.injury_type,
      weapon_used: payloadFacts.weapon_used,
      injury_means_type: payloadFacts.injury_means_type,
      death_result: payloadFacts.death_result,
    });
    console.groupEnd();

    this.reasoningService.runReasoning({ facts: payloadFacts, top_k: this.topK }).subscribe({
      next: (data: ReasoningResponse) => {
        this.response = data;
        console.group('[Reasoning][Frontend] Response payload');
        console.log('applied_norms:', data.rule_reasoning?.applied_norms || []);
        console.log('proofs:', data.rule_reasoning?.proofs || []);
        console.log('applied_articles:', data.applied_articles || []);
        console.groupEnd();
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
        this.error = 'Greška pri pokretanju rasuđivanja.';
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
        this.generationMessage = 'Greška pri generisanju presude.';
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

      if (article === '144') {
        return {
          norm,
          target: paragraph ? `Član 144, tačka ${paragraph}` : 'Član 144',
        };
      }

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
      rule_plus_cbr_retrieval: 'Pravila + CBR sličnost',
      rule_only: 'Samo pravila',
      cbr_only: 'Samo slični slučajevi',
      supports_conviction: 'Podržava osudu',
      supports_rejection: 'Podržava odbijanje',
      retrieval_only: 'CBR sličnost bez konsenzusa ishoda',
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
    this.enforceFactsConsistency();
  }

  onFactsChanged(): void {
    this.enforceFactsConsistency();
  }

  hasSpecialAction(action: string): boolean {
    return this.isChecked(this.facts.special_action_types, action);
  }

  hasVictimStatus(status: string): boolean {
    return this.isChecked(this.facts.victim_status, status);
  }

  isNaMahContext(): boolean {
    return this.isChecked(this.facts.execution_manner, 'na_mah');
  }

  isSuicideActionContext(): boolean {
    return this.hasSpecialAction('navodjenje_na_samoubistvo') || this.hasSpecialAction('pomaganje_u_samoubistvu');
  }

  isIllegalAbortionContext(): boolean {
    return this.hasSpecialAction('nelegalni_pobacaj');
  }

  isForcedSterilizationContext(): boolean {
    return this.hasSpecialAction('prisilna_sterilizacija');
  }

  isHeavyInjuryContext(): boolean {
    return this.facts.injury_type === 'teska tjelesna povreda';
  }

  isLightInjuryContext(): boolean {
    return this.facts.injury_type === 'laka tjelesna povreda';
  }

  hasOfficialVictimStatus(): boolean {
    return this.hasVictimStatus('sluzbeno_lice') || this.hasVictimStatus('vojno_lice');
  }

  private enforceFactsConsistency(): void {
    if (!this.isNaMahContext()) {
      this.facts.provocation_types = [];
      this.facts.high_intensity_distress = null;
    }

    if (!this.hasOfficialVictimStatus()) {
      this.facts.duty_connection = '';
    }

    if (!this.hasVictimStatus('clan_porodice')) {
      this.facts.victim_previously_abused = null;
    }

    if (!this.hasVictimStatus('punoljetno_lice')) {
      this.facts.victim_health_state = '';
      this.facts.victim_explicit_request = '';
    }

    if (!this.hasVictimStatus('maloljetna_trudnica')) {
      this.facts.guardian_consent = '';
    }

    if (!this.hasVictimStatus('maloljetna_trudnica') && !this.isIllegalAbortionContext()) {
      this.facts.victim_consent = '';
    }

    if (!this.isSuicideActionContext()) {
      this.facts.suicide_outcome = '';
      this.facts.victim_accountability = '';
    }

    if (!this.isIllegalAbortionContext()) {
      this.facts.abortion_action_mode = '';
      this.facts.abortion_outcomes = [];
    }

    if (!this.isForcedSterilizationContext()) {
      this.facts.sterilization_goal = '';
    }

    if (this.facts.offender_psych_state !== 'porodjajni_poremecaj') {
      this.facts.offender_is_mother = null;
    }

    if (this.isLightInjuryContext()) {
      this.facts.injury_severity_level = 'laka';
    }

    if (!this.isHeavyInjuryContext()) {
      this.facts.severe_injury_specific_consequences = [];
      this.facts.death_result = null;
      this.facts.negligence = null;
    }

    if (!this.isLightInjuryContext() && this.facts.fight_participation !== true) {
      this.facts.weapon_used = null;
      this.facts.injury_means_type = '';
      this.facts.provocation = null;
    }

    if (!this.isLightInjuryContext()) {
      this.facts.injury_severity_level = '';
      this.facts.provocation = null;
    }

    if (this.facts.left_without_help !== true) {
      this.facts.offender_victim_relationship = '';
      this.facts.danger_caused_by_offender = null;
      this.facts.danger_to_life = null;
      this.facts.danger_to_health = null;
      this.facts.help_provision_ability = '';
      this.facts.failure_to_help_consequence = '';
    }

    if (this.facts.left_without_help === true && this.facts.danger_caused_by_offender !== true) {
      this.facts.danger_to_life = null;
      this.facts.danger_to_health = null;
    }

    if (this.facts.left_without_help === true && this.facts.offender_victim_relationship !== 'prolaznik') {
      this.facts.help_provision_ability = '';
      this.facts.failure_to_help_consequence = '';
    }

    if (this.facts.inhuman_treatment !== true) {
      this.facts.victim_subordination = null;
      this.facts.death_attributed_to_negligence = '';
    }
  }

  private buildFactsPayload(): CaseFacts {
    this.enforceFactsConsistency();
    const severeConsequence =
      this.facts.injury_type === 'teska tjelesna povreda' ||
      (this.facts.severe_injury_specific_consequences?.length || 0) > 0;

    const deathResult =
      typeof this.facts.death_result === 'boolean'
        ? this.facts.death_result
        : this.facts.life_consequence_type === 'smrt_nastupila';

    const weaponUsed =
      typeof this.facts.weapon_used === 'boolean'
        ? this.facts.weapon_used
        : this.facts.injury_means_type === 'opasno_orudje' ||
          this.facts.injury_means_type === 'sredstvo_podobno_za_tesku_povredu';

    const negligence =
      typeof this.facts.negligence === 'boolean'
        ? this.facts.negligence
        : this.facts.guilt_form === 'nehat' || this.facts.death_attributed_to_negligence === 'da';

    const provocation =
      typeof this.facts.provocation === 'boolean' ? this.facts.provocation : (this.facts.provocation_types?.length || 0) > 0;
    const fightParticipation = this.facts.fight_participation;
    const highIntensityDistress = this.facts.high_intensity_distress === true;

    const injuryType = this.facts.injury_type || '';

    let fightConsequence = 'none';
    if (deathResult || severeConsequence) {
      fightConsequence = 'death_or_serious_injury';
    }

    const leftWithoutHelp = this.facts.left_without_help;

    const payload: CaseFacts = {
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
      high_intensity_distress: highIntensityDistress,
      danger_to_life: this.facts.danger_to_life,
      danger_to_health: this.facts.danger_to_health,
      danger_caused_by_offender: this.facts.danger_caused_by_offender,
    };

    return normalizeRuleFactsInput(payload);
  }

}
