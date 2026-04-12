import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule, Router } from '@angular/router';
import { VerdictService } from '../services/verdict.service';
import { VerdictListResponse, VerdictMetadata } from '../models/models';

@Component({
  selector: 'app-verdict-list',
  standalone: true,
  imports: [CommonModule, RouterModule],
  template: `
    <div class="container">
      <h2>Sudske presude</h2>

      <div class="toolbar" *ngIf="!loading && !error">
        <div class="summary">
          Ukupno presuda: <strong>{{ total }}</strong>
        </div>
        <div class="page-size-control">
          <label for="page-size">Po strani:</label>
          <select id="page-size" [value]="pageSize" (change)="onPageSizeChange($event)">
            <option *ngFor="let size of pageSizeOptions" [value]="size">{{ size }}</option>
          </select>
        </div>
      </div>
      
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
            <span class="outcome-badge" *ngIf="verdict.outcome" [class]="'outcome-' + verdict.outcome.toLowerCase()">
              {{ verdict.outcome }}
            </span>
          </div>
        </div>
      </div>

      <div class="pagination" *ngIf="!loading && !error && totalPages > 1">
        <button type="button" (click)="goToPage(1)" [disabled]="page === 1"><<</button>
        <button type="button" (click)="goToPage(page - 1)" [disabled]="page === 1"><</button>
        <span>Strana {{ page }} / {{ totalPages }}</span>
        <button type="button" (click)="goToPage(page + 1)" [disabled]="page === totalPages">></button>
        <button type="button" (click)="goToPage(totalPages)" [disabled]="page === totalPages">>></button>
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

    .toolbar {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 16px;
      padding: 12px 16px;
      border: 1px solid #e6eaf0;
      border-radius: 10px;
      background: #f9fbfd;
    }

    .summary {
      color: #314155;
      font-size: 14px;
    }

    .page-size-control {
      display: flex;
      align-items: center;
      gap: 8px;
      font-size: 14px;
      color: #314155;
    }

    .page-size-control select {
      border: 1px solid #cfd8e3;
      border-radius: 8px;
      padding: 4px 8px;
      background: #fff;
      color: #2c3e50;
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

    .pagination {
      margin-top: 20px;
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 10px;
    }

    .pagination button {
      border: 1px solid #cfd8e3;
      background: #fff;
      color: #2c3e50;
      border-radius: 8px;
      padding: 6px 12px;
      cursor: pointer;
      font-weight: 600;
    }

    .pagination button:disabled {
      opacity: 0.5;
      cursor: not-allowed;
    }

    .pagination span {
      color: #314155;
      font-size: 14px;
      min-width: 110px;
      text-align: center;
    }

    @media (max-width: 768px) {
      .toolbar {
        flex-direction: column;
        align-items: stretch;
        gap: 10px;
      }

      .page-size-control {
        justify-content: space-between;
      }

      .verdict-header {
        flex-direction: column;
        align-items: flex-start;
        gap: 8px;
      }

      .verdict-footer {
        flex-direction: column;
        align-items: flex-start;
        gap: 10px;
      }
    }
    
    .error {
      color: #e74c3c;
    }
  `]
})
export class VerdictListComponent implements OnInit {
  verdicts: VerdictMetadata[] = [];
  total = 0;
  page = 1;
  pageSize = 20;
  totalPages = 1;
  readonly pageSizeOptions = [10, 20, 50, 100];
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
    this.loading = true;
    this.error = '';
    this.verdictService.getVerdicts(this.page, this.pageSize).subscribe({
      next: (data: VerdictListResponse) => {
        this.verdicts = data.verdicts;
        this.total = data.total;
        this.page = data.page;
        this.pageSize = data.page_size;
        this.totalPages = data.total_pages;
        this.loading = false;
      },
      error: (err) => {
        this.error = 'Greška pri učitavanju presuda';
        this.loading = false;
        console.error(err);
      }
    });
  }

  goToPage(nextPage: number) {
    if (nextPage < 1 || nextPage > this.totalPages || nextPage === this.page) {
      return;
    }
    this.page = nextPage;
    this.loadVerdicts();
  }

  onPageSizeChange(event: Event) {
    const target = event.target as HTMLSelectElement;
    const parsed = Number(target.value);
    if (!Number.isFinite(parsed) || parsed <= 0) {
      return;
    }
    this.pageSize = parsed;
    this.page = 1;
    this.loadVerdicts();
  }

  viewVerdict(caseId: string) {
    this.router.navigate(['/verdicts', caseId]);
  }
}
