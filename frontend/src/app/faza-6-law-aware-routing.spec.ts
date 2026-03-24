import { TestBed, ComponentFixture } from '@angular/core/testing';
import { RouterTestingModule } from '@angular/router/testing';
import { of } from 'rxjs';
import { Router } from '@angular/router';

import { LawDetailComponent } from './components/law-detail.component';
import { LawArticleComponent } from './components/law-article.component';
import { VerdictDetailComponent } from './components/verdict-detail.component';
import { LawService } from './services/law.service';
import { VerdictService } from './services/verdict.service';
import { LegalReferenceService } from './services/legal-reference.service';
import { LawChapter, LawArticle } from './models/models';

describe('Faza 6: Law-Aware Frontend Navigation', () => {
  
  describe('Legal Reference Service', () => {
    let service: LegalReferenceService;

    beforeEach(() => {
      TestBed.configureTestingModule({
        providers: [LegalReferenceService]
      });
      service = TestBed.inject(LegalReferenceService);
    });

    it('should parse references from article objects', () => {
      const references = [
        {
          'href': '#art_147',
          'text': 'Član 147'
        },
        {
          'article': '151',
          'text': 'Član 151'
        }
      ];

      const parsed = service.parseReferences(references) as Array<{
        articleNumber: string | null;
        label: string;
      }>;

      expect(parsed.length).toBe(2);
      expect(parsed[0].articleNumber).toBe('147');
      expect(parsed[0].label).toContain('147');
      expect(parsed[1].articleNumber).toBe('151');
    });

    it('should extract article numbers from various reference formats', () => {
      const references = [
        { 'href': '#art_143' },
        { 'text': 'član 145' },
        { 'article': '151' },
        { 'target': 'član 153' }
      ];

      const parsed = service.parseReferences(references);

      expect(parsed.map(p => p.articleNumber)).toContain('143');
      expect(parsed.map(p => p.articleNumber)).toContain('145');
      expect(parsed.map(p => p.articleNumber)).toContain('151');
      expect(parsed.map(p => p.articleNumber)).toContain('153');
    });

    it('should handle paragraph references gracefully', () => {
      const references = [
        {
          'href': '#art_143__para_1',
          'text': 'Član 143, stav 1'
        }
      ];

      const parsed = service.parseReferences(references);

      // Paragraph references should be included with label but no article number
      expect(parsed.length).toBe(1);
      expect(parsed[0].label).toContain('143');
    });
  });

  describe('Law-Aware Routes (Faza 6 Requirement)', () => {
    let router: Router;
    let lawService: jasmine.SpyObj<LawService>;
    let fixture: ComponentFixture<LawDetailComponent>;

    beforeEach(async () => {
      const lawServiceSpy = jasmine.createSpyObj('LawService', [
        'getChapters',
        'getChapter',
        'getArticle'
      ]);

      await TestBed.configureTestingModule({
        imports: [
          LawDetailComponent,
          RouterTestingModule.withRoutes([
            { path: 'laws/:lawId/chapter/:chapterId', component: LawDetailComponent },
            { path: 'laws/:lawId/article/:articleNumber', component: LawArticleComponent }
          ])
        ],
        providers: [
          { provide: LawService, useValue: lawServiceSpy },
          LegalReferenceService
        ]
      }).compileComponents();

      router = TestBed.inject(Router);
      lawService = TestBed.inject(LawService) as jasmine.SpyObj<LawService>;
      fixture = TestBed.createComponent(LawDetailComponent);
    });

    it('should support law-aware routing with lawId parameter', async () => {
      const mockChapter: LawChapter = {
        number: '20',
        title: 'Teška tjelesna povreda',
        articles: []
      };

      lawService.getChapter.and.returnValue(of(mockChapter));

      await router.navigate(['laws', 'crime-code', 'chapter', '20']);

      expect(router.url).toBe('/laws/crime-code/chapter/20');
    });

    it('should navigate between articles using law-aware routes', async () => {
      const mockArticle: LawArticle = {
        number: '147',
        chapter_number: '20',
        content: 'Test content'
      };

      lawService.getArticle.and.returnValue(of(mockArticle));

      await router.navigate(['laws', 'crime-code', 'article', '147']);

      expect(router.url).toBe('/laws/crime-code/article/147');
    });

    it('should navigate to article detail using law-aware route', async () => {
      const component = fixture.componentInstance;
      component.lawId = 'crime-code';

      spyOn(router, 'navigate');

      component.openArticle('147');

      expect(router.navigate).toHaveBeenCalledWith([
        '/laws',
        'crime-code',
        'article',
        '147'
      ]);
    });

    it('should navigate to referenced articles using law-aware routes', async () => {
      const component = fixture.componentInstance;
      component.lawId = 'crime-code';

      spyOn(router, 'navigate');

      component.navigateToArticle('151');

      expect(router.navigate).toHaveBeenCalledWith([
        '/laws',
        'crime-code',
        'article',
        '151'
      ]);
    });
  });

  describe('Centralized Reference Parser Service', () => {
    let component: LawDetailComponent;
    let fixture: ComponentFixture<LawDetailComponent>;
    let referenceService: LegalReferenceService;

    beforeEach(async () => {
      const lawServiceSpy = jasmine.createSpyObj('LawService', [
        'getChapters',
        'getChapter',
        'getArticle'
      ]);

      await TestBed.configureTestingModule({
        imports: [
          LawDetailComponent,
          RouterTestingModule
        ],
        providers: [
          { provide: LawService, useValue: lawServiceSpy },
          LegalReferenceService
        ]
      }).compileComponents();

      fixture = TestBed.createComponent(LawDetailComponent);
      component = fixture.componentInstance;
      referenceService = TestBed.inject(LegalReferenceService);
    });

    it('should use LegalReferenceService for parsing article references', () => {
      const mockArticle: LawArticle = {
        number: '147',
        content: 'Test',
        references: [
          { 'href': '#art_151', 'text': 'Član 151' }
        ]
      };

      spyOn(referenceService, 'parseReferences').and.returnValue([
        { label: 'Član 151', articleNumber: '151', original: '#art_151' }
      ]);

      const result = component.getArticleReferences(mockArticle);

      expect(referenceService.parseReferences).toHaveBeenCalledWith(mockArticle.references || []);
      expect(result[0].articleNumber).toBe('151');
    });
  });

  describe('Safe Event Binding (No Global DOM Listener)', () => {
    let component: VerdictDetailComponent;
    let fixture: ComponentFixture<VerdictDetailComponent>;
    let router: Router;

    beforeEach(async () => {
      const verdictServiceSpy = jasmine.createSpyObj('VerdictService', [
        'getVerdict',
        'getOverrides',
        'updateOverrides',
        'getVerdicts',
        'searchVerdicts'
      ]);
      const lawServiceSpy = jasmine.createSpyObj('LawService', [
        'getArticle',
        'getChapter',
        'getChapters'
      ]);

      verdictServiceSpy.getVerdict.and.returnValue(of({
        case_id: 'TEST-1',
        case_number: 'TEST-1',
        court_name: 'Test court',
        date: '2026-01-01',
        judges: [],
        legal_references: [],
        parties: {},
        factual_state: {},
        summary: '',
        legal_issues: [],
        applied_laws: [],
        applied_articles: [],
        legal_reasoning: '',
        decision: '',
        outcome: '',
        legal_concepts: [],
        full_text: '',
        xml_file: ''
      }));
      verdictServiceSpy.getOverrides.and.returnValue(of({ case_id: 'TEST-1', overrides: {} }));

      await TestBed.configureTestingModule({
        imports: [
          VerdictDetailComponent,
          RouterTestingModule.withRoutes([
            { path: 'laws/:lawId/article/:articleNumber', component: LawArticleComponent }
          ])
        ],
        providers: [
          { provide: VerdictService, useValue: verdictServiceSpy },
          { provide: LawService, useValue: lawServiceSpy }
        ]
      }).compileComponents();

      router = TestBed.inject(Router);
      fixture = TestBed.createComponent(VerdictDetailComponent);
      component = fixture.componentInstance;
      fixture.detectChanges();
    });

    it('should expose scoped click handler on component', () => {
      expect(typeof component.onReasoningTextClick).toBe('function');
    });

    it('should handle clicks on data-article links without global listener', () => {
      spyOn(router, 'navigate');
      const mockLink = document.createElement('a');
      mockLink.setAttribute('data-article', '151');
      const event = {
        target: mockLink,
        preventDefault: jasmine.createSpy('preventDefault')
      } as unknown as Event;

      component.onReasoningTextClick(event);

      expect((event as any).preventDefault).toHaveBeenCalled();
      expect(router.navigate).toHaveBeenCalledWith(['/laws', 'crime-code', 'article', '151']);
    });
  });

  describe('Backward Compatibility Routes', () => {
    let router: Router;

    beforeEach(async () => {
      await TestBed.configureTestingModule({
        imports: [
          RouterTestingModule.withRoutes([
            { path: 'laws/:lawId/chapter/:chapterId', component: LawDetailComponent },
            { path: 'laws/:lawId/article/:articleNumber', component: LawArticleComponent },
            // Legacy routes redirect to new law-aware routes
            { path: 'laws/chapter/:id', redirectTo: '/laws/crime-code/chapter/:id' },
            { path: 'laws/article/:id', redirectTo: '/laws/crime-code/article/:id' }
          ])
        ],
        providers: [LegalReferenceService]
      }).compileComponents();

      router = TestBed.inject(Router);
    });

    it('should redirect legacy routes to law-aware routes', async () => {
      // Navigate using old route format
      await router.navigate(['laws', 'chapter', '20']);

      // Should redirect to new law-aware route with default lawId
      expect(router.url).toBe('/laws/crime-code/chapter/20');
    });
  });
});
