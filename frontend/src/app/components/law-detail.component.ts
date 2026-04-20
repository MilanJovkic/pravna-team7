import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ActivatedRoute, Router, RouterModule } from '@angular/router';
import { LawService } from '../services/law.service';
import { LegalReferenceService } from '../services/legal-reference.service';
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
          <div *ngFor="let article of chapter.articles"
               class="article-card"
               [attr.id]="'article-' + article.number"
               [class.focused]="isFocused(article.number)">
            <div class="article-header">
              <h3>Član {{ article.number }}</h3>
              <button class="detail-btn" (click)="openArticle(article.number)">Detalji</button>
            </div>
            <h4 *ngIf="article.title">{{ article.title }}</h4>
            <p class="article-content">{{ article.content }}</p>
            
            <div class="metadata" *ngIf="hasMetadata(article)">
              <div *ngIf="article.norm_type" class="meta-item">
                <strong>Tip norme:</strong> {{ article.norm_type }}
              </div>
              <div *ngIf="article.conditions && article.conditions.length > 0" class="meta-item">
                <strong>Uslovi:</strong> {{ article.conditions.join(', ') }}
              </div>
              <div *ngIf="article.subjects && article.subjects.length > 0" class="meta-item">
                <strong>Subjekti:</strong> {{ article.subjects.join(', ') }}
              </div>
              <div *ngIf="article.legal_concepts && article.legal_concepts.length > 0" class="meta-item">
                <strong>Pravni koncepti:</strong> {{ article.legal_concepts.join(', ') }}
              </div>
              <div *ngIf="article.references && article.references.length > 0" class="meta-item">
                <strong>Reference:</strong>
                <div class="references-list">
                  <ng-container *ngFor="let refLink of getArticleReferences(article)">
                    <button
                      *ngIf="refLink.articleNumber"
                      class="reference-link"
                      (click)="navigateToArticle(refLink.articleNumber)"
                      [title]="refLink.original">
                      {{ refLink.label }}
                    </button>
                    <span *ngIf="!refLink.articleNumber" class="reference-text">
                      {{ refLink.label }}
                    </span>
                  </ng-container>
                </div>
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

    .article-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      gap: 10px;
      margin-bottom: 8px;
    }

    .detail-btn {
      background: #ecf0f1;
      color: #2c3e50;
      border: none;
      padding: 6px 12px;
      border-radius: 5px;
      cursor: pointer;
      font-size: 13px;
      font-weight: 600;
    }

    .detail-btn:hover {
      background: #dfe6e9;
    }

    .article-card.focused {
      border-color: #3498db;
      box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.2);
      background: #f8fbff;
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

    .reference {
      display: inline-block;
      margin-left: 8px;
      color: #2c3e50;
    }

    .references-list {
      display: flex;
      flex-wrap: wrap;
      gap: 8px;
      margin-top: 8px;
    }

    .reference-link {
      background: #e3f2fd;
      color: #1565c0;
      border: none;
      padding: 6px 12px;
      border-radius: 5px;
      cursor: pointer;
      font-size: 13px;
      font-weight: 500;
      transition: all 0.2s;
    }

    .reference-link:hover {
      background: #bbdefb;
      transform: translateY(-1px);
      box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    }

    .reference-text {
      display: inline-block;
      padding: 6px 12px;
      background: #f5f5f5;
      color: #555;
      border-radius: 5px;
      font-size: 13px;
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
  focusedArticle: string | null = null;
  lawId: string = 'crime-code'; // Default law ID

  constructor(
    private route: ActivatedRoute,
    private router: Router,
    private lawService: LawService,
    private referenceService: LegalReferenceService
  ) {}

  ngOnInit() {
    // Get lawId from route parameters (defaults to 'crime-code')
    this.lawId = this.route.snapshot.paramMap.get('lawId') || 'crime-code';
    const chapterId = this.route.snapshot.paramMap.get('chapterId');
    
    this.route.queryParamMap.subscribe((params) => {
      this.focusedArticle = params.get('focus');
      if (this.chapter) {
        this.scrollToFocused();
      }
    });
    if (chapterId) {
      this.loadChapter(chapterId);
    }
  }

  loadChapter(chapterNumber: string) {
    this.lawService.getChapter(chapterNumber).subscribe({
      next: (data) => {
        this.chapter = data;
        this.loading = false;
        this.scrollToFocused();
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
      (article.conditions && article.conditions.length > 0) ||
      (article.subjects && article.subjects.length > 0) ||
      (article.legal_concepts && article.legal_concepts.length > 0) ||
      (article.references && article.references.length > 0));
  }

  isFocused(articleNumber: string): boolean {
    return !!this.focusedArticle && this.focusedArticle === articleNumber;
  }

  scrollToFocused() {
    if (!this.focusedArticle) {
      return;
    }

    setTimeout(() => {
      const element = document.getElementById(`article-${this.focusedArticle}`);
      if (element) {
        element.scrollIntoView({ behavior: 'smooth', block: 'start' });
      }
    }, 0);
  }

  getArticleReferences(article: LawArticle): Array<{ label: string; articleNumber: string | null; original: string }> {
    return this.referenceService.parseReferences(article.references || []);
  }

  navigateToArticle(articleNumber: string) {
    if (!articleNumber) {
      return;
    }
    // Navigate using law-aware route
    this.router.navigate(['/laws', this.lawId, 'article', articleNumber]);
  }

  goBack() {
    this.router.navigate(['/laws']);
  }

  openArticle(articleNumber: string) {
    // Navigate using law-aware route
    this.router.navigate(['/laws', this.lawId, 'article', articleNumber]);
  }
}
