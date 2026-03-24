import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { ActivatedRoute, Router, RouterModule } from '@angular/router';
import { VerdictService } from '../services/verdict.service';
import { LawService } from '../services/law.service';
import { VerdictDetail, VerdictOverrideUpdate } from '../models/models';

@Component({
  selector: 'app-verdict-detail',
  standalone: true,
  imports: [CommonModule, RouterModule, FormsModule],
  template: `
    <div class="container">
      <button class="back-btn" (click)="goBack()">← Nazad</button>
      
      <div *ngIf="verdict" class="verdict-detail">
        <div class="verdict-header">
          <h2>{{ verdict.case_number || verdict.case_id }}</h2>
          <span class="outcome-badge" *ngIf="verdict.outcome" [class]="'outcome-' + verdict.outcome?.toLowerCase()">
            {{ verdict.outcome }}
          </span>
        </div>

        <div class="edit-toolbar">
          <button class="secondary-btn" (click)="toggleEdit()">
            {{ editMode ? 'Zatvori izmenu' : 'Uredi podatke' }}
          </button>
        </div>

        <div class="edit-panel" *ngIf="editMode">
          <h3>Rucne ispravke</h3>
          <div class="edit-grid">
            <label>
              Rezime
              <textarea [(ngModel)]="editSummary" rows="3"></textarea>
            </label>
            <label>
              Pravna pitanja (odvoji zarezom)
              <input type="text" [(ngModel)]="editLegalIssues" />
            </label>
            <label>
              Primenjeni zakoni (odvoji zarezom)
              <input type="text" [(ngModel)]="editAppliedLaws" />
            </label>
            <label>
              Primenjeni clanci (odvoji zarezom)
              <input type="text" [(ngModel)]="editAppliedArticles" />
            </label>
            <label>
              Pravno obrazlozenje
              <textarea [(ngModel)]="editLegalReasoning" rows="4"></textarea>
            </label>
            <label>
              Odluka
              <textarea [(ngModel)]="editDecision" rows="3"></textarea>
            </label>
            <label>
              Ishod
              <input type="text" [(ngModel)]="editOutcome" />
            </label>
            <label>
              Pravni koncepti (odvoji zarezom)
              <input type="text" [(ngModel)]="editLegalConcepts" />
            </label>
            <label>
              Sud
              <input type="text" [(ngModel)]="editCourtName" />
            </label>
            <label>
              Datum (YYYY-MM-DD)
              <input type="text" [(ngModel)]="editDate" />
            </label>
            <label>
              Sudije (odvoji zarezom)
              <input type="text" [(ngModel)]="editJudges" />
            </label>
            <label>
              Ucesnici (JSON)
              <textarea [(ngModel)]="editParties" rows="4"></textarea>
            </label>
            <label>
              Cinjenicno stanje (JSON)
              <textarea [(ngModel)]="editFactualState" rows="4"></textarea>
            </label>
          </div>
          <div class="edit-actions">
            <button class="secondary-btn" (click)="saveOverrides()" [disabled]="editLoading">Sacuvaj izmene</button>
            <button class="ghost-btn" (click)="resetOverrides()" [disabled]="editLoading">Ponisti promene</button>
          </div>
          <div class="navigation-error" *ngIf="editError">{{ editError }}</div>
        </div>
        
        <div class="info-section">
          <div class="info-item">
            <strong>Sud:</strong> {{ verdict.court_name }}
          </div>
          <div class="info-item" *ngIf="verdict.date">
            <strong>Datum:</strong> {{ verdict.date }}
          </div>
          <div class="info-item" *ngIf="verdict.judges && verdict.judges.length > 0">
            <strong>Sudije:</strong> {{ verdict.judges.join(', ') }}
          </div>
        </div>
        
        <div class="section" *ngIf="verdict.summary">
          <h3>Rezime</h3>
          <p>{{ verdict.summary }}</p>
        </div>
        
        <div class="section" *ngIf="verdict.legal_issues && verdict.legal_issues.length > 0">
          <h3>Pravna pitanja</h3>
          <ul>
            <li *ngFor="let issue of verdict.legal_issues">{{ issue }}</li>
          </ul>
        </div>
        
        <div class="section" *ngIf="verdict.applied_laws && verdict.applied_laws.length > 0">
          <h3>Primenjeni zakoni</h3>
          <div class="law-list">
            <span *ngFor="let law of verdict.applied_laws" class="law-badge">{{ law }}</span>
          </div>
        </div>
        
        <div class="section" *ngIf="verdict.applied_articles && verdict.applied_articles.length > 0">
          <h3>Primenjeni članci</h3>
          <div class="law-list">
            <button
              *ngFor="let link of appliedArticleLinks"
              class="article-badge link-badge"
              [title]="link.source"
              (click)="openArticle(link.number)">
              Član {{ link.number }}
            </button>
          </div>
          <div class="navigation-hint" *ngIf="appliedArticleLinks.length === 0">
            Nema referenci na Krivični zakonik u dostupnim podacima.
          </div>
          <div class="navigation-error" *ngIf="navigationError">{{ navigationError }}</div>
        </div>
        
        <div class="section" *ngIf="verdict.legal_reasoning">
          <h3>Pravno obrazloženje</h3>
          <div class="reasoning-text" 
               [innerHTML]="formatTextWithLinks(verdict.legal_reasoning)"
               (click)="onReasoningTextClick($event)"></div>
        </div>
        
        <div class="section" *ngIf="verdict.decision">
          <h3>Odluka suda</h3>
          <p class="decision">{{ verdict.decision }}</p>
        </div>
        
        <div class="section" *ngIf="verdict.legal_concepts && verdict.legal_concepts.length > 0">
          <h3>Pravni koncepti</h3>
          <div class="concepts">
            <span *ngFor="let concept of verdict.legal_concepts" class="concept-badge">{{ concept }}</span>
          </div>
        </div>

        <div class="section" *ngIf="verdict.factual_state && objectKeys(verdict.factual_state).length > 0">
          <h3>Činjenično stanje</h3>
          <div class="facts" *ngFor="let key of objectKeys(verdict.factual_state)">
            <strong>{{ key }}:</strong> {{ verdict.factual_state[key].join(', ') }}
          </div>
        </div>

        <div class="section" *ngIf="verdict.parties && objectKeys(verdict.parties).length > 0">
          <h3>Učesnici</h3>
          <div class="facts" *ngFor="let key of objectKeys(verdict.parties)">
            <strong>{{ key }}:</strong> {{ verdict.parties[key].join(', ') }}
          </div>
        </div>

        <div class="section" *ngIf="verdict.full_text">
          <h3>Kompletan tekst presude</h3>
          <div class="full-text" [innerHTML]="formatTextWithLinks(verdict.full_text)"></div>
        </div>
      </div>
      
      <div *ngIf="loading" class="loading">Učitavanje...</div>
      <div *ngIf="error" class="error">{{ error }}</div>
    </div>
  `,
  styles: [`
    .container {
      padding: 20px;
      max-width: 1200px;
      margin: 0 auto;
    }
    
    .back-btn {
      background: #3498db;
      color: white;
      border: none;
      padding: 10px 20px;
      border-radius: 5px;
      cursor: pointer;
      margin-bottom: 20px;
    }
    
    .back-btn:hover {
      background: #2980b9;
    }
    
    .verdict-detail {
      background: white;
      border-radius: 8px;
      padding: 30px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    }
    
    .verdict-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 20px;
      padding-bottom: 20px;
      border-bottom: 2px solid #eee;
    }
    
    .verdict-header h2 {
      margin: 0;
      color: #2c3e50;
    }
    
    .outcome-badge {
      padding: 8px 20px;
      border-radius: 20px;
      font-size: 14px;
      font-weight: 600;
      text-transform: uppercase;
    }
    
    .outcome-оправдан {
      background: #d4edda;
      color: #155724;
    }
    
    .outcome-осуђен {
      background: #f8d7da;
      color: #721c24;
    }
    
    .info-section {
      background: #f8f9fa;
      padding: 15px;
      border-radius: 5px;
      margin-bottom: 30px;
    }
    
    .info-item {
      margin-bottom: 10px;
    }
    
    .info-item:last-child {
      margin-bottom: 0;
    }
    
    .info-item strong {
      color: #34495e;
      margin-right: 10px;
    }
    
    .section {
      margin-bottom: 30px;
    }
    
    .section h3 {
      color: #2c3e50;
      margin-bottom: 15px;
      font-size: 20px;
    }
    
    .section p {
      line-height: 1.8;
      color: #555;
    }

    .reasoning-text {
      line-height: 1.8;
      color: #555;
      white-space: pre-wrap;
    }

    .reasoning-text :deep(a) {
      color: #3498db;
      text-decoration: underline;
      cursor: pointer;
      font-weight: 500;
    }

    .reasoning-text :deep(a):hover {
      color: #2980b9;
    }
    
    .section ul {
      list-style-type: disc;
      padding-left: 30px;
    }
    
    .section li {
      margin-bottom: 10px;
      line-height: 1.6;
    }
    
    .law-list, .concepts {
      display: flex;
      flex-wrap: wrap;
      gap: 10px;
    }
    
    .law-badge, .article-badge, .concept-badge {
      display: inline-block;
      padding: 8px 15px;
      border-radius: 5px;
      font-size: 14px;
      font-weight: 500;
    }
    
    .law-badge {
      background: #e3f2fd;
      color: #1565c0;
    }
    
    .article-badge {
      background: #f3e5f5;
      color: #6a1b9a;
    }

    .link-badge {
      border: none;
      cursor: pointer;
      transition: transform 0.2s ease, box-shadow 0.2s ease;
    }

    .link-badge:hover {
      transform: translateY(-1px);
      box-shadow: 0 2px 6px rgba(0,0,0,0.1);
    }
    
    .concept-badge {
      background: #fff3e0;
      color: #e65100;
    }
    
    .decision {
      background: #fffbf0;
      border-left: 4px solid #f39c12;
      padding: 15px;
      font-weight: 500;
    }

    .facts {
      margin-bottom: 8px;
      color: #555;
    }

    .full-text {
      white-space: pre-wrap;
      background: #f8f9fa;
      border: 1px solid #eee;
      border-radius: 6px;
      padding: 15px;
      color: #2c3e50;
      line-height: 1.6;
      max-height: 520px;
      overflow: auto;
    }

    .full-text :deep(a) {
      color: #3498db;
      text-decoration: underline;
      cursor: pointer;
      font-weight: 500;
    }

    .full-text :deep(a):hover {
      color: #2980b9;
      background: rgba(52, 152, 219, 0.1);
    }

    .navigation-error {
      margin-top: 10px;
      color: #c0392b;
      font-size: 14px;
    }

    .navigation-hint {
      margin-top: 10px;
      color: #7f8c8d;
      font-size: 14px;
    }

    .edit-toolbar {
      display: flex;
      justify-content: flex-end;
      margin-bottom: 16px;
    }

    .edit-panel {
      border: 1px solid #ececec;
      border-radius: 12px;
      padding: 18px;
      background: #fbfaf7;
      margin-bottom: 24px;
    }

    .edit-panel h3 {
      margin-top: 0;
      color: #2c3e50;
    }

    .edit-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
      gap: 12px;
    }

    .edit-grid label {
      display: flex;
      flex-direction: column;
      gap: 6px;
      font-size: 13px;
      font-weight: 600;
      color: #3a4c55;
    }

    .edit-grid input,
    .edit-grid textarea {
      border: 1px solid #d7dde3;
      border-radius: 8px;
      padding: 8px 10px;
      font-size: 13px;
      font-family: inherit;
      background: #ffffff;
    }

    .edit-actions {
      display: flex;
      gap: 12px;
      margin-top: 14px;
    }

    .secondary-btn {
      background: #ecf0f1;
      color: #2c3e50;
      border: none;
      padding: 8px 14px;
      border-radius: 6px;
      cursor: pointer;
      font-size: 13px;
      font-weight: 600;
    }

    .secondary-btn:hover {
      background: #dfe6e9;
    }

    .ghost-btn {
      background: transparent;
      border: 1px solid #d7dde3;
      color: #2c3e50;
      padding: 8px 14px;
      border-radius: 6px;
      cursor: pointer;
      font-size: 13px;
      font-weight: 600;
    }
    
    .loading, .error {
      text-align: center;
      padding: 40px;
    }
    
    .error {
      color: #e74c3c;
    }
  `]
})
export class VerdictDetailComponent implements OnInit {
  verdict?: VerdictDetail;
  loading = true;
  error = '';
  navigationError = '';
  objectKeys = Object.keys;
  appliedArticleLinks: Array<{ number: string; source: string }> = [];
  editMode = false;
  editLoading = false;
  editError = '';
  editSummary = '';
  editLegalIssues = '';
  editAppliedLaws = '';
  editAppliedArticles = '';
  editDecision = '';
  editOutcome = '';
  editLegalConcepts = '';
  editLegalReasoning = '';
  editCourtName = '';
  editDate = '';
  editJudges = '';
  editParties = '';
  editFactualState = '';

  constructor(
    private route: ActivatedRoute,
    private router: Router,
    private verdictService: VerdictService,
    private lawService: LawService
  ) {}

  ngOnInit() {
    const caseId = this.route.snapshot.paramMap.get('id');
    if (caseId) {
      this.loadVerdict(caseId);
    }
    // Note: Global DOM event listeners have been removed.
    // Click handling for article links is now done via the (click) handler
    // on the reasoning-text element with the onReasoningTextClick method.
  }

  loadVerdict(caseId: string) {
    this.verdictService.getVerdict(caseId).subscribe({
      next: (data) => {
        this.verdict = data;
        this.appliedArticleLinks = this.buildAppliedArticleLinks(
          data.applied_articles || []
        );
        this.loading = false;
        if (this.editMode) {
          this.populateEditFields(data);
        }
      },
      error: (err) => {
        this.error = 'Greška pri učitavanju presude';
        this.loading = false;
        console.error(err);
      }
    });
  }

  toggleEdit() {
    this.editMode = !this.editMode;
    this.editError = '';
    if (this.editMode && this.verdict) {
      this.populateEditFields(this.verdict);
    }
  }

  populateEditFields(verdict: VerdictDetail) {
    this.editSummary = verdict.summary || '';
    this.editLegalIssues = (verdict.legal_issues || []).join(', ');
    this.editAppliedLaws = (verdict.applied_laws || []).join(', ');
    this.editAppliedArticles = (verdict.applied_articles || []).join(', ');
    this.editDecision = verdict.decision || '';
    this.editOutcome = verdict.outcome || '';
    this.editLegalConcepts = (verdict.legal_concepts || []).join(', ');
    this.editLegalReasoning = verdict.legal_reasoning || '';
    this.editCourtName = verdict.court_name || '';
    this.editDate = verdict.date || '';
    this.editJudges = (verdict.judges || []).join(', ');
    this.editParties = JSON.stringify(verdict.parties || {}, null, 2);
    this.editFactualState = JSON.stringify(verdict.factual_state || {}, null, 2);
  }

  resetOverrides() {
    if (this.verdict) {
      this.populateEditFields(this.verdict);
    }
    this.editError = '';
  }

  saveOverrides() {
    if (!this.verdict) {
      return;
    }
    this.editLoading = true;
    this.editError = '';

    const partiesResult = this.parseJsonField(this.editParties, 'Ucesnici');
    const factualStateResult = this.parseJsonField(this.editFactualState, 'Cinjenicno stanje');
    if (partiesResult.error || factualStateResult.error) {
      this.editError = partiesResult.error || factualStateResult.error || '';
      this.editLoading = false;
      return;
    }

    const payload: VerdictOverrideUpdate = {
      summary: this.emptyToNull(this.editSummary),
      legal_issues: this.parseCsv(this.editLegalIssues),
      applied_laws: this.parseCsv(this.editAppliedLaws),
      applied_articles: this.parseCsv(this.editAppliedArticles),
      decision: this.emptyToNull(this.editDecision),
      outcome: this.emptyToNull(this.editOutcome),
      legal_concepts: this.parseCsv(this.editLegalConcepts),
      legal_reasoning: this.emptyToNull(this.editLegalReasoning),
      court_name: this.emptyToNull(this.editCourtName),
      date: this.emptyToNull(this.editDate),
      judges: this.parseCsv(this.editJudges),
      parties: partiesResult.value,
      factual_state: factualStateResult.value,
    };

    this.verdictService.updateOverrides(this.verdict.case_id, payload).subscribe({
      next: () => {
        this.editLoading = false;
        this.loadVerdict(this.verdict?.case_id || '');
      },
      error: (err) => {
        this.editLoading = false;
        this.editError = 'Greska pri cuvanju izmena.';
        console.error(err);
      }
    });
  }

  parseCsv(value: string): string[] | null {
    const trimmed = (value || '').trim();
    if (!trimmed) {
      return null;
    }
    return trimmed.split(',').map((item) => item.trim()).filter(Boolean);
  }

  emptyToNull(value: string): string | null {
    const trimmed = (value || '').trim();
    return trimmed ? trimmed : null;
  }

  parseJsonField(value: string, label: string): { value: Record<string, string[]> | null; error: string | null } {
    const trimmed = (value || '').trim();
    if (!trimmed) {
      return { value: null, error: null };
    }
    try {
      return { value: JSON.parse(trimmed), error: null };
    } catch (err) {
      return { value: null, error: `${label} mora biti validan JSON.` };
    }
  }

  goBack() {
    this.router.navigate(['/verdicts']);
  }

  buildAppliedArticleLinks(appliedArticles: string[]) {
    const links: Array<{ number: string; source: string }> = [];
    const seen = new Set<string>();

    for (const reference of appliedArticles) {
      if (!this.isCriminalCodeReference(reference)) {
        continue;
      }
      const numbers = this.extractArticleNumbers(reference);
      for (const number of numbers) {
        const key = number.toLowerCase();
        if (!seen.has(key)) {
          seen.add(key);
          links.push({ number, source: reference });
        }
      }
    }

    return links;
  }

  isCriminalCodeReference(reference: string): boolean {
    const lower = reference.toLowerCase();
    if (lower.includes('zakonika o krivičnom postupku')) {
      return false;
    }
    if (lower.includes('krivičnog zakonika') || lower.includes('krivični zakonik')) {
      return true;
    }
    return true;
  }

  extractArticleNumbers(reference: string): string[] {
    const matches: string[] = [];
    const pattern = /[ČC]lan(?:ovi)?\s+([0-9a-zA-Z ,.-]+)/gi;
    let result: RegExpExecArray | null;

    while ((result = pattern.exec(reference)) !== null) {
      let block = result[1];
      block = block.split(/stav|u\s+vezi|krivičnog|zakonika|zakon|zkp|zpp/i)[0];
      const numbers = block.match(/\d+[a-zA-Z]?/g);
      if (numbers) {
        matches.push(...numbers);
      }
    }

    return matches;
  }

  openArticle(articleNumber: string) {
    this.navigationError = '';
    // Navigate to law-aware route (default lawId is 'crime-code')
    this.router.navigate(['/laws', 'crime-code', 'article', articleNumber]);
  }

  /**
   * Handle clicks within the legal reasoning text element.
   * Checks if clicked element is a link with data-article attribute and navigates to it.
   * This replaces the former global document.addEventListener('click') pattern.
   */
  onReasoningTextClick(event: Event): void {
    const target = event.target as HTMLElement;
    if (target.tagName === 'A' && target.hasAttribute('data-article')) {
      event.preventDefault();
      const articleNumber = target.getAttribute('data-article');
      if (articleNumber) {
        this.openArticle(articleNumber);
      }
    }
  }

  formatTextWithLinks(text: string): string {
    if (!text) {
      return '';
    }

    // Match patterns like "član 143", "člana 144", "članu 145", etc.
    const pattern = /\b[čc]lan(?:a|u|om)?\s+(\d+[a-z]?)\b/gi;
    
    return text.replace(pattern, (match, articleNumber) => {
      return `<a data-article="${articleNumber}">${match}</a>`;
    });
  }
}
