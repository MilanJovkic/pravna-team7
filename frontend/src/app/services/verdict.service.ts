import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { VerdictMetadata, VerdictDetail } from '../models/models';

@Injectable({
  providedIn: 'root'
})
export class VerdictService {
  private apiUrl = 'http://localhost:8000/api/verdicts';

  constructor(private http: HttpClient) {}

  getVerdicts(): Observable<{ total: number, verdicts: VerdictMetadata[] }> {
    return this.http.get<{ total: number, verdicts: VerdictMetadata[] }>(this.apiUrl);
  }

  getVerdict(caseId: string): Observable<VerdictDetail> {
    return this.http.get<VerdictDetail>(`${this.apiUrl}/${caseId}`);
  }

  searchVerdicts(query: string, filterBy?: string): Observable<{ total_results: number, results: VerdictMetadata[] }> {
    let url = `${this.apiUrl}/search/?q=${query}`;
    if (filterBy) {
      url += `&filter_by=${filterBy}`;
    }
    return this.http.get<{ total_results: number, results: VerdictMetadata[] }>(url);
  }
}
