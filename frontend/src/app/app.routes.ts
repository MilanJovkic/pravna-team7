import { Routes } from '@angular/router';
import { LawListComponent } from './components/law-list.component';
import { LawDetailComponent } from './components/law-detail.component';
import { VerdictListComponent } from './components/verdict-list.component';
import { VerdictDetailComponent } from './components/verdict-detail.component';

export const routes: Routes = [
  { path: '', redirectTo: '/laws', pathMatch: 'full' },
  { path: 'laws', component: LawListComponent },
  { path: 'laws/chapter/:id', component: LawDetailComponent },
  { path: 'verdicts', component: VerdictListComponent },
  { path: 'verdicts/:id', component: VerdictDetailComponent },
];
