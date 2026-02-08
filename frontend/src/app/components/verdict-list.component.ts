import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule, Router } from '@angular/router';
import { VerdictService } from '../services/verdict.service';
import { VerdictMetadata } from '../models/models';

@Component({
  selector: 'app-verdict-list',
  standalone: true,
  imports: [CommonModule, RouterModule],
  template: `
    <div class="container">
      <h2>Sudske presude</h2>
      
      <div class="verdict-list" *ngIf="verdicts.length > 0">
        <div *ngFor="let verdict of verdicts" class="verdict-card" (click)="viewVerdict(verdict.case_id)">
          <div class="verdict-header">
            <h3>{{ verdict.case_number || verdict.case_id }}</h3>
            <span class="verdict-date">{{ verdict.date }}</span>
          </div>
          
          <p class="court-name">{{ verdict.court_name }}</p>
          
          <p class="verdict-summary" *ngIf="verdict.summary">{{ verdict.summary }}</p>
          
          <div class="verdict-footer">
            <div class="applied-laws" *ngIf="verdict.applied_laws && verdict.applied_laws.length > 0">
              <strong>Zakoni:</strong> {{ verdict.applied_laws.join(', ') }}
            </div>
            <span class="outcome-badge" *ngIf="verdict.outcome" [class]="'outcome-' + verdict.outcome?.toLowerCase()">
              {{ verdict.outcome }}
            </span>
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
    
    h2 {
      color: #2c3e50;
      margin-bottom: 30px;
    }
    
    .verdict-list {
      display: grid;
      gap: 20px;
    }
    
    .verdict-card {
      background: white;
      border: 1px solid #ddd;
      border-radius: 8px;
      padding: 20px;
      cursor: pointer;
      transition: all 0.3s;
    }
    
    .verdict-card:hover {
      box-shadow: 0 4px 12px rgba(0,0,0,0.1);
      transform: translateY(-2px);
    }
    
    .verdict-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 10px;
    }
    
    .verdict-header h3 {
      margin: 0;
      color: #2c3e50;
      font-size: 18px;
    }
    
    .verdict-date {
      color: #7f8c8d;
      font-size: 14px;
    }
    
    .court-name {
      color: #34495e;
      font-weight: 500;
      margin: 0 0 15px 0;
    }
    
    .verdict-summary {
      color: #555;
      line-height: 1.6;
      margin-bottom: 15px;
    }
    
    .verdict-footer {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-top: 15px;
      padding-top: 15px;
      border-top: 1px solid #eee;
    }
    
    .applied-laws {
      font-size: 14px;
      color: #7f8c8d;
    }
    
    .outcome-badge {
      padding: 5px 15px;
      border-radius: 20px;
      font-size: 12px;
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
    
    .loading, .error {
      text-align: center;
      padding: 40px;
    }
    
    .error {
      color: #e74c3c;
    }
  `]
})
export class VerdictListComponent implements OnInit {
  verdicts: VerdictMetadata[] = [];
  loading = true;
  error = '';

  constructor(
    private verdictService: VerdictService,
    private router: Router
  ) {}

  ngOnInit() {
    this.loadVerdicts();
  }

  loadVerdicts() {
    this.verdictService.getVerdicts().subscribe({
      next: (data) => {
        this.verdicts = data.verdicts;
        this.loading = false;
      },
      error: (err) => {
        this.error = 'Greška pri učitavanju presuda';
        this.loading = false;
        console.error(err);
      }
    });
  }

  viewVerdict(caseId: string) {
    this.router.navigate(['/verdicts', caseId]);
  }
}
