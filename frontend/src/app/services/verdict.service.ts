import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { VerdictMetadata, VerdictDetail, VerdictListResponse, VerdictOverrideUpdate } from '../models/models';

@Injectable({
  providedIn: 'root'
})
export class VerdictService {
  private apiUrl = 'http://localhost:8000/api/verdicts';

  constructor(private http: HttpClient) {}

  getVerdicts(page: number = 1, pageSize: number = 20): Observable<VerdictListResponse> {
    return this.http.get<VerdictListResponse>(`${this.apiUrl}?page=${page}&page_size=${pageSize}`);
  }

  getVerdict(caseId: string): Observable<VerdictDetail> {
    return this.http.get<VerdictDetail>(`${this.apiUrl}/${caseId}`);
  }

  getOverrides(caseId: string): Observable<{ case_id: string; overrides: VerdictOverrideUpdate }> {
    return this.http.get<{ case_id: string; overrides: VerdictOverrideUpdate }>(`${this.apiUrl}/${caseId}/overrides`);
  }

  updateOverrides(caseId: string, payload: VerdictOverrideUpdate): Observable<{ case_id: string; overrides: VerdictOverrideUpdate }> {
    return this.http.put<{ case_id: string; overrides: VerdictOverrideUpdate }>(`${this.apiUrl}/${caseId}/overrides`, payload);
  }

  searchVerdicts(query: string, filterBy?: string): Observable<{ total_results: number, results: VerdictMetadata[] }> {
    let url = `${this.apiUrl}/search/?q=${query}`;
    if (filterBy) {
      url += `&filter_by=${filterBy}`;
    }
    return this.http.get<{ total_results: number, results: VerdictMetadata[] }>(url);
  }
}
