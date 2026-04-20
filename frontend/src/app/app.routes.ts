import { Routes } from '@angular/router';
import { LawListComponent } from './components/law-list.component';
import { LawDetailComponent } from './components/law-detail.component';
import { LawArticleComponent } from './components/law-article.component';
import { VerdictListComponent } from './components/verdict-list.component';
import { VerdictDetailComponent } from './components/verdict-detail.component';
import { ReasoningComponent } from './components/reasoning.component';

export const routes: Routes = [
  { path: '', redirectTo: '/laws', pathMatch: 'full' },
  { path: 'laws', component: LawListComponent },
  // Law-aware routes: /laws/:lawId/chapter/:chapterId and /laws/:lawId/article/:articleNumber
  { path: 'laws/:lawId/chapter/:chapterId', component: LawDetailComponent },
  { path: 'laws/:lawId/article/:articleNumber', component: LawArticleComponent },
  // Legacy routes for backward compatibility (redirect to law-aware routes)
  { path: 'laws/chapter/:id', redirectTo: '/laws/crime-code/chapter/:id', pathMatch: 'full' },
  { path: 'laws/article/:id', redirectTo: '/laws/crime-code/article/:id', pathMatch: 'full' },
  { path: 'verdicts', component: VerdictListComponent },
  { path: 'verdicts/:id', component: VerdictDetailComponent },
  { path: 'reasoning', component: ReasoningComponent },
];
