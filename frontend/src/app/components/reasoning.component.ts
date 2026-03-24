import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { ReasoningService } from '../services/reasoning.service';
import { CaseFacts, ReasoningResponse, VerdictGenerationResponse } from '../models/models';
import { Router } from '@angular/router';

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
          <p class="subtitle">Popuni cinjenice, pokreni rasudjivanje po pravilima i po slucajevima, pa sacuvaj novi slucaj.</p>
        </div>
      </header>

      <div class="content-grid">
        <section class="card form-card">
          <h3>Opis cinjenica</h3>
          <form (ngSubmit)="runReasoning()" #form="ngForm">
            <div class="field-grid">
              <label>
                Okrivljeni
                <input type="text" name="defendant" [(ngModel)]="facts.defendant" placeholder="Npr. P. M." />
              </label>
              <label>
                Tip povrede
                <input type="text" name="injury_type" [(ngModel)]="facts.injury_type" placeholder="teska tjelesna povreda" required />
              </label>
              <label>
                Lokacija
                <input type="text" name="location" [(ngModel)]="facts.location" placeholder="Podgorica" />
              </label>
              <label>
                Oruzje
                <input type="text" name="weapon" [(ngModel)]="facts.weapon" placeholder="metalni kljuc" />
              </label>
              <label>
                Posledice teskih povreda
                <select name="severe_consequence" [(ngModel)]="facts.severe_consequence">
                  <option [ngValue]="null">Nepoznato</option>
                  <option [ngValue]="true">Da</option>
                  <option [ngValue]="false">Ne</option>
                </select>
              </label>
              <label>
                Smrtni ishod
                <select name="death_result" [(ngModel)]="facts.death_result">
                  <option [ngValue]="null">Nepoznato</option>
                  <option [ngValue]="true">Da</option>
                  <option [ngValue]="false">Ne</option>
                </select>
              </label>
              <label>
                Oruzje upotrebljeno
                <select name="weapon_used" [(ngModel)]="facts.weapon_used">
                  <option [ngValue]="null">Nepoznato</option>
                  <option [ngValue]="true">Da</option>
                  <option [ngValue]="false">Ne</option>
                </select>
              </label>
              <label>
                Nehat
                <select name="negligence" [(ngModel)]="facts.negligence">
                  <option [ngValue]="null">Nepoznato</option>
                  <option [ngValue]="true">Da</option>
                  <option [ngValue]="false">Ne</option>
                </select>
              </label>
              <label>
                Provokacija
                <select name="provocation" [(ngModel)]="facts.provocation">
                  <option [ngValue]="null">Nepoznato</option>
                  <option [ngValue]="true">Da</option>
                  <option [ngValue]="false">Ne</option>
                </select>
              </label>
              <label>
                Ucesce u tuci
                <select name="fight_participation" [(ngModel)]="facts.fight_participation">
                  <option [ngValue]="null">Nepoznato</option>
                  <option [ngValue]="true">Da</option>
                  <option [ngValue]="false">Ne</option>
                </select>
              </label>
              <label>
                Posledica tuce
                <input type="text" name="fight_consequence" [(ngModel)]="facts.fight_consequence" placeholder="none" />
              </label>
              <label>
                Ostavljen bez pomoci
                <select name="left_without_help" [(ngModel)]="facts.left_without_help">
                  <option [ngValue]="null">Nepoznato</option>
                  <option [ngValue]="true">Da</option>
                  <option [ngValue]="false">Ne</option>
                </select>
              </label>
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
              <div *ngIf="response.rule_reasoning.applied_norms.length === 0" class="empty">Nema pronadjenih normi.</div>
            </div>

            <div class="result-block">
              <h4>Predlog presude i sankcije</h4>
              <div class="suggestion-grid">
                <div>
                  <span class="label">Predlog presude</span>
                  <div class="value">{{ response.suggested_verdict || 'N/A' }}</div>
                </div>
                <div>
                  <span class="label">Predlog sankcije</span>
                  <div class="value">{{ response.suggested_sanction || 'N/A' }}</div>
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
                    <option value="delimicno usvojeno">Delimicno usvojeno</option>
                  </select>
                </label>
                <label>
                  Izabrana sankcija
                  <input type="text" name="selectedSanction" [(ngModel)]="selectedSanction" placeholder="Kazna zatvora / novcana kazna" />
                </label>
              </div>
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
              <h4>Slicni slucajevi (CBR)</h4>
              <div *ngIf="response.cbr.matches.length > 0" class="matches">
                <div *ngFor="let match of response.cbr.matches" class="match-row">
                  <div>
                    <strong>{{ match.case_number || 'Nepoznato' }}</strong>
                    <span class="outcome" *ngIf="match.outcome">{{ match.outcome }}</span>
                  </div>
                  <div class="similarity">{{ similarityPercent(match.similarity) }}</div>
                </div>
              </div>
              <div *ngIf="response.cbr.matches.length === 0" class="empty">Nema slicnih slucajeva.</div>
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

    @media (max-width: 900px) {
      .content-grid {
        grid-template-columns: 1fr;
      }
    }
  `]
})
export class ReasoningComponent {
  facts: CaseFacts = {
    defendant: '',
    injury_type: '',
    location: '',
    weapon: '',
    weapon_used: null,
    severe_consequence: null,
    death_result: null,
    negligence: null,
    provocation: null,
    fight_participation: null,
    fight_consequence: 'none',
    left_without_help: null
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

  constructor(private reasoningService: ReasoningService, private router: Router) {}

  runReasoning() {
    this.loading = true;
    this.error = '';
    this.saveMessage = '';
    this.generationMessage = '';

    this.reasoningService.runReasoning({ facts: this.facts, top_k: this.topK }).subscribe({
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

    this.reasoningService.saveCase({
      case_number: this.caseNumber || undefined,
      outcome: this.caseOutcome || undefined,
      verdict_type: this.selectedVerdict || undefined,
      sanction: this.selectedSanction || undefined,
      facts: this.facts
    }).subscribe({
      next: (data: { case_number: string }) => {
        this.saveMessage = `Sacuvan slucaj ${data.case_number}`;
        this.saving = false;
      },
      error: (err: unknown) => {
        this.saveMessage = 'Greska pri snimanju slucaja.';
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

    this.reasoningService.generateVerdict({
      facts: this.facts,
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

  similarityPercent(value: number): string {
    return `${Math.round(value * 100)}%`;
  }
}
