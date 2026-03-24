import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ActivatedRoute, Router, RouterModule } from '@angular/router';
import { LawService } from '../services/law.service';
import { LawArticle } from '../models/models';

@Component({
  selector: 'app-law-article',
  standalone: true,
  imports: [CommonModule, RouterModule],
  template: `
    <div class="container">
      <button class="back-btn" (click)="goBack()">← Nazad</button>

      <div *ngIf="article" class="article-detail">
        <div class="article-header">
          <div>
            <h2>Član {{ article.number }}</h2>
            <p class="article-title" *ngIf="article.title">{{ article.title }}</p>
          </div>
          <button
            class="secondary-btn"
            *ngIf="article.chapter_number"
            (click)="goToChapter(article.chapter_number)">
            Glava {{ article.chapter_number }}
          </button>
        </div>

        <pre class="article-content">{{ article.content }}</pre>

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
              <ng-container *ngFor="let refLink of parsedReferences">
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

    .article-detail {
      background: white;
      border-radius: 8px;
      padding: 30px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    }

    .article-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      gap: 12px;
      margin-bottom: 20px;
    }

    .article-header h2 {
      margin: 0;
      color: #2c3e50;
    }

    .article-title {
      margin: 5px 0 0 0;
      color: #34495e;
      font-weight: 500;
    }

    .secondary-btn {
      background: #ecf0f1;
      color: #2c3e50;
      border: none;
      padding: 8px 14px;
      border-radius: 5px;
      cursor: pointer;
      font-size: 13px;
      font-weight: 600;
      white-space: nowrap;
    }

    .secondary-btn:hover {
      background: #dfe6e9;
    }

    .article-content {
      white-space: pre-wrap;
      line-height: 1.6;
      color: #2c3e50;
      margin-bottom: 20px;
      font-family: inherit;
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
export class LawArticleComponent implements OnInit {
  article?: LawArticle;
  loading = true;
  error = '';
  parsedReferences: Array<{ label: string; articleNumber: string | null; original: string }> = [];

  constructor(
    private route: ActivatedRoute,
    private router: Router,
    private lawService: LawService
  ) {}

  ngOnInit() {
    // Subscribe to route parameter changes to handle navigation within same component
    this.route.paramMap.subscribe(params => {
      const articleNumber = params.get('id');
      if (articleNumber) {
        this.loadArticle(articleNumber);
      }
    });
  }

  loadArticle(articleNumber: string) {
    this.lawService.getArticle(articleNumber).subscribe({
      next: (data) => {
        this.article = data;
        this.parsedReferences = this.parseReferences(data.references || []);
        this.loading = false;
      },
      error: (err) => {
        this.error = 'Greška pri učitavanju člana';
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

  formatReference(reference: Record<string, any>): string {
    if (!reference) {
      return '';
    }

    const parts = [
      reference['type'],
      reference['article'],
      reference['law'],
      reference['label'],
      reference['target']
    ]
      .filter(Boolean);
    if (parts.length > 0) {
      return parts.join(' ');
    }

    return JSON.stringify(reference);
  }

  parseReferences(references: Array<Record<string, any>>): Array<{ label: string; articleNumber: string | null; original: string }> {
    const parsed: Array<{ label: string; articleNumber: string | null; original: string }> = [];
    
    console.log('Raw references from backend:', references);
    
    for (const ref of references) {
      const original = this.formatReference(ref);
      let label = original;
      let articleNumber: string | null = null;

      console.log('Processing reference:', ref);

      // Extract article number from href (e.g., #art_147 -> 147)
      if (ref['href']) {
        const hrefMatch = ref['href'].match(/#art_(\d+[a-z]?)/i);
        if (hrefMatch) {
          articleNumber = hrefMatch[1];
          label = ref['text'] || `Član ${articleNumber}`;
          console.log('Extracted from href:', articleNumber);
        } else if (ref['href'].includes('__para_')) {
          // It's a paragraph reference, not an article
          label = ref['text'] || original;
          console.log('Paragraph reference, skipping');
        }
      }
      
      // Try to extract from text field if we don't have articleNumber yet
      if (!articleNumber && ref['text']) {
        const textMatch = String(ref['text']).match(/[Čč]lan\s*(\d+[a-z]?)/i);
        if (textMatch) {
          articleNumber = textMatch[1];
          label = ref['text'];
          console.log('Extracted from text:', articleNumber);
        }
      }
      
      if (!articleNumber && ref['article']) {
        // Try to extract from article field
        const articleMatch = String(ref['article']).match(/(\d+[a-z]?)/i);
        if (articleMatch) {
          articleNumber = articleMatch[1];
          label = `Član ${articleNumber}`;
          console.log('Extracted from article field:', articleNumber);
        }
      }
      
      if (!articleNumber && ref['target']) {
        // Try to extract from target field
        const targetMatch = String(ref['target']).match(/[čć]lan\s*(\d+[a-z]?)/i);
        if (targetMatch) {
          articleNumber = targetMatch[1];
          label = `Član ${articleNumber}`;
          console.log('Extracted from target:', articleNumber);
        }
      }

      // If we still don't have a label, try to parse from original
      if (!label || label === original) {
        const labelMatch = original.match(/[čć]lan\s*(\d+[a-z]?)/i);
        if (labelMatch) {
          articleNumber = labelMatch[1];
          label = `Član ${articleNumber}`;
          console.log('Extracted from original:', articleNumber);
        }
      }

      console.log('Final parsed:', { label, articleNumber, original });
      parsed.push({ label, articleNumber, original });
    }

    console.log('All parsed references:', parsed);
    return parsed;
  }

  navigateToArticle(articleNumber: string) {
    if (!articleNumber) {
      return;
    }
    this.router.navigate(['/laws/article', articleNumber]);
  }

  goBack() {
    this.router.navigate(['/laws']);
  }

  goToChapter(chapterNumber: string) {
    this.router.navigate(['/laws/chapter', chapterNumber]);
  }
}
