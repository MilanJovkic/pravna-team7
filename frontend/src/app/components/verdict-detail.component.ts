import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ActivatedRoute, Router, RouterModule } from '@angular/router';
import { VerdictService } from '../services/verdict.service';
import { VerdictDetail } from '../models/models';

@Component({
  selector: 'app-verdict-detail',
  standalone: true,
  imports: [CommonModule, RouterModule],
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
            <span *ngFor="let article of verdict.applied_articles" class="article-badge">{{ article }}</span>
          </div>
        </div>
        
        <div class="section" *ngIf="verdict.legal_reasoning">
          <h3>Pravno obrazloženje</h3>
          <p>{{ verdict.legal_reasoning }}</p>
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

  constructor(
    private route: ActivatedRoute,
    private router: Router,
    private verdictService: VerdictService
  ) {}

  ngOnInit() {
    const caseId = this.route.snapshot.paramMap.get('id');
    if (caseId) {
      this.loadVerdict(caseId);
    }
  }

  loadVerdict(caseId: string) {
    this.verdictService.getVerdict(caseId).subscribe({
      next: (data) => {
        this.verdict = data;
        this.loading = false;
      },
      error: (err) => {
        this.error = 'Greška pri učitavanju presude';
        this.loading = false;
        console.error(err);
      }
    });
  }

  goBack() {
    this.router.navigate(['/verdicts']);
  }
}
