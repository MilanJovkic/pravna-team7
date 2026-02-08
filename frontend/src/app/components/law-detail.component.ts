import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ActivatedRoute, Router, RouterModule } from '@angular/router';
import { LawService } from '../services/law.service';
import { LawChapter, LawArticle } from '../models/models';

@Component({
  selector: 'app-law-detail',
  standalone: true,
  imports: [CommonModule, RouterModule],
  template: `
    <div class="container">
      <button class="back-btn" (click)="goBack()">← Nazad</button>
      
      <div *ngIf="chapter" class="chapter-detail">
        <h2>{{ chapter.title }}</h2>
        <p class="chapter-number">Glava {{ chapter.number }}</p>
        
        <div class="articles">
          <div *ngFor="let article of chapter.articles" class="article-card">
            <h3>Član {{ article.number }}</h3>
            <h4 *ngIf="article.title">{{ article.title }}</h4>
            <p class="article-content">{{ article.content }}</p>
            
            <div class="metadata" *ngIf="hasMetadata(article)">
              <div *ngIf="article.norm_type" class="meta-item">
                <strong>Tip norme:</strong> {{ article.norm_type }}
              </div>
              <div *ngIf="article.subjects && article.subjects.length > 0" class="meta-item">
                <strong>Subjekti:</strong> {{ article.subjects.join(', ') }}
              </div>
              <div *ngIf="article.legal_concepts && article.legal_concepts.length > 0" class="meta-item">
                <strong>Pravni koncepti:</strong> {{ article.legal_concepts.join(', ') }}
              </div>
            </div>
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
    
    .chapter-detail h2 {
      color: #2c3e50;
      margin-bottom: 5px;
    }
    
    .chapter-number {
      color: #7f8c8d;
      margin-bottom: 30px;
    }
    
    .articles {
      display: flex;
      flex-direction: column;
      gap: 20px;
    }
    
    .article-card {
      background: white;
      border: 1px solid #ddd;
      border-radius: 8px;
      padding: 20px;
    }
    
    .article-card h3 {
      color: #2c3e50;
      margin: 0 0 5px 0;
    }
    
    .article-card h4 {
      color: #34495e;
      margin: 0 0 15px 0;
      font-weight: 500;
    }
    
    .article-content {
      line-height: 1.6;
      color: #2c3e50;
      margin-bottom: 15px;
    }
    
    .metadata {
      background: #f8f9fa;
      padding: 15px;
      border-radius: 5px;
      margin-top: 15px;
    }
    
    .meta-item {
      margin-bottom: 10px;
    }
    
    .meta-item:last-child {
      margin-bottom: 0;
    }
    
    .meta-item strong {
      color: #34495e;
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
export class LawDetailComponent implements OnInit {
  chapter?: LawChapter;
  loading = true;
  error = '';

  constructor(
    private route: ActivatedRoute,
    private router: Router,
    private lawService: LawService
  ) {}

  ngOnInit() {
    const chapterNumber = this.route.snapshot.paramMap.get('id');
    if (chapterNumber) {
      this.loadChapter(chapterNumber);
    }
  }

  loadChapter(chapterNumber: string) {
    this.lawService.getChapter(chapterNumber).subscribe({
      next: (data) => {
        this.chapter = data;
        this.loading = false;
      },
      error: (err) => {
        this.error = 'Greška pri učitavanju glave';
        this.loading = false;
        console.error(err);
      }
    });
  }

  hasMetadata(article: LawArticle): boolean {
    return !!(article.norm_type || 
      (article.subjects && article.subjects.length > 0) ||
      (article.legal_concepts && article.legal_concepts.length > 0));
  }

  goBack() {
    this.router.navigate(['/laws']);
  }
}
