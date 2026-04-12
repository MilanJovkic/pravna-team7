export interface LawArticle {
  number: string;
  chapter_number?: string;
  title?: string;
  content: string;
  norm_type?: string;
  subjects?: string[];
  legal_concepts?: string[];
  sanctions?: any;
  conditions?: string[];
  references?: Array<Record<string, any>>;
}

export interface LawChapter {
  number: string;
  title: string;
  articles?: LawArticle[];
  article_count?: number;
}

export interface VerdictMetadata {
  case_id: string;
  case_number?: string;
  court_name?: string;
  date?: string;
  judges?: string[];
  summary?: string;
  legal_issues?: string[];
  applied_laws?: string[];
  applied_articles?: string[];
  decision?: string;
  outcome?: string;
  legal_concepts?: string[];
  parties?: Record<string, string[]>;
  factual_state?: Record<string, string[]>;
}

export interface VerdictDetail extends VerdictMetadata {
  legal_reasoning?: string;
  precedent_value?: string;
  confidence?: number;
  full_text?: string;
}

export interface VerdictListResponse {
  total: number;
  page: number;
  page_size: number;
  total_pages: number;
  verdicts: VerdictMetadata[];
}

export interface VerdictOverrideUpdate {
  summary?: string | null;
  legal_issues?: string[] | null;
  applied_laws?: string[] | null;
  applied_articles?: string[] | null;
  decision?: string | null;
  outcome?: string | null;
  legal_concepts?: string[] | null;
  legal_reasoning?: string | null;
  court_name?: string | null;
  date?: string | null;
  judges?: string[] | null;
  parties?: Record<string, string[]> | null;
  factual_state?: Record<string, string[]> | null;
}

export interface CaseFacts {
  defendant?: string;
  injury_type?: string;
  location?: string;
  weapon?: string;
  weapon_used?: boolean | null;
  severe_consequence?: boolean | null;
  death_result?: boolean | null;
  negligence?: boolean | null;
  provocation?: boolean | null;
  fight_participation?: boolean | null;
  fight_consequence?: string;
  left_without_help?: boolean | null;
}

export interface RuleReasoningResult {
  applied_norms: string[];
  proofs: string[];
}

export interface CbrMatch {
  case_number?: string;
  similarity: number;
  outcome?: string;
}

export interface CbrResult {
  matches: CbrMatch[];
}

export interface AppliedLawText {
  article_number: string;
  title?: string;
  content?: string;
}

export interface ReasoningRequest {
  facts: CaseFacts;
  top_k: number;
}

export interface ReasoningResponse {
  rule_reasoning: RuleReasoningResult;
  cbr: CbrResult;
  applied_articles: string[];
  applied_law_texts: AppliedLawText[];
  suggested_verdict?: string;
  suggested_sanction?: string;
}

export interface VerdictGenerationRequest {
  facts: CaseFacts;
  reasoning: ReasoningResponse;
  case_number?: string;
  court_name?: string;
  date?: string;
  judges?: string[];
  selected_verdict?: string;
  selected_sanction?: string;
}

export interface VerdictGenerationResponse {
  case_id: string;
  case_number: string;
  xml_file: string;
  verdict_text: string;
}

export interface NewCaseRequest {
  case_number?: string;
  outcome?: string;
  verdict_type?: string;
  sanction?: string;
  facts: CaseFacts;
}

export interface NewCaseResponse {
  id: number;
  case_number: string;
}
