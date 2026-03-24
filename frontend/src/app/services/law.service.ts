import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { LawChapter, LawArticle } from '../models/models';

@Injectable({
  providedIn: 'root'
})
export class LawService {
  private apiUrl = 'http://localhost:8000/api/laws';

  constructor(private http: HttpClient) {}

  getChapters(): Observable<{ chapters: LawChapter[], total: number }> {
    return this.http.get<{ chapters: LawChapter[], total: number }>(`${this.apiUrl}/chapters`);
  }

  getChapter(chapterNumber: string): Observable<LawChapter> {
    return this.http.get<LawChapter>(`${this.apiUrl}/chapters/${chapterNumber}`);
  }

  getArticle(articleNumber: string): Observable<LawArticle> {
    return this.http.get<LawArticle>(`${this.apiUrl}/articles/${articleNumber}`);
  }

  searchArticles(query: string): Observable<{ total: number, results: LawArticle[] }> {
    return this.http.get<{ total: number, results: LawArticle[] }>(`${this.apiUrl}/search?q=${query}`);
  }
}
