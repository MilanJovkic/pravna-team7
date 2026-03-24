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
  { path: 'laws/article/:id', component: LawArticleComponent },
  { path: 'laws/chapter/:id', component: LawDetailComponent },
  { path: 'verdicts', component: VerdictListComponent },
  { path: 'verdicts/:id', component: VerdictDetailComponent },
  { path: 'reasoning', component: ReasoningComponent },
];
