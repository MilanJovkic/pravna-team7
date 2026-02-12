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

export interface NewCaseRequest {
  case_number?: string;
  outcome?: string;
  facts: CaseFacts;
}

export interface NewCaseResponse {
  id: number;
  case_number: string;
}
