import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { ReasoningRequest, ReasoningResponse, NewCaseRequest, NewCaseResponse, VerdictGenerationRequest, VerdictGenerationResponse } from '../models/models';

@Injectable({
  providedIn: 'root'
})
export class ReasoningService {
  private reasoningUrl = 'http://localhost:8000/api/reasoning';
  private casesUrl = 'http://localhost:8000/api/cases';
  private verdictGenerationUrl = 'http://localhost:8000/api/verdict-generation';

  constructor(private http: HttpClient) {}

  runReasoning(payload: ReasoningRequest): Observable<ReasoningResponse> {
    return this.http.post<ReasoningResponse>(this.reasoningUrl, payload);
  }

  saveCase(payload: NewCaseRequest): Observable<NewCaseResponse> {
    return this.http.post<NewCaseResponse>(this.casesUrl, payload);
  }

  generateVerdict(payload: VerdictGenerationRequest): Observable<VerdictGenerationResponse> {
    return this.http.post<VerdictGenerationResponse>(this.verdictGenerationUrl, payload);
  }
}
