import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule, Router } from '@angular/router';
import { LawService } from '../services/law.service';
import { LawChapter } from '../models/models';

@Component({
  selector: 'app-law-list',
  standalone: true,
  imports: [CommonModule, RouterModule],
  template: `
    <div class="container">
      <h2>Krivični zakonik Crne Gore</h2>
      
      <div class="chapter-list" *ngIf="chapters.length > 0">
        <div *ngFor="let chapter of chapters" class="chapter-card" (click)="viewChapter(chapter.number)">
          <h3>{{ chapter.title }}</h3>
          <p class="chapter-info">Glava {{ chapter.number }} • {{ chapter.article_count }} članova</p>
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
    
    .chapter-list {
      display: grid;
      gap: 15px;
    }
    
    .chapter-card {
      background: white;
      border: 1px solid #ddd;
      border-radius: 8px;
      padding: 20px;
      cursor: pointer;
      transition: all 0.3s;
    }
    
    .chapter-card:hover {
      box-shadow: 0 4px 12px rgba(0,0,0,0.1);
      transform: translateY(-2px);
    }
    
    .chapter-card h3 {
      margin: 0 0 10px 0;
      color: #34495e;
      font-size: 18px;
    }
    
    .chapter-info {
      margin: 0;
      color: #7f8c8d;
      font-size: 14px;
    }
    
    .loading, .error {
      text-align: center;
      padding: 40px;
      font-size: 16px;
    }
    
    .error {
      color: #e74c3c;
    }
  `]
})
export class LawListComponent implements OnInit {
  chapters: LawChapter[] = [];
  loading = true;
  error = '';

  constructor(
    private lawService: LawService,
    private router: Router
  ) {}

  ngOnInit() {
    this.loadChapters();
  }

  loadChapters() {
    this.lawService.getChapters().subscribe({
      next: (data) => {
        this.chapters = data.chapters;
        this.loading = false;
      },
      error: (err) => {
        this.error = 'Greška pri učitavanju zakona';
        this.loading = false;
        console.error(err);
      }
    });
  }

  viewChapter(chapterNumber: string) {
    this.router.navigate(['/laws/chapter', chapterNumber]);
  }
}
