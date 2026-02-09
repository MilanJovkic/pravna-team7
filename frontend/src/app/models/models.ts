export interface LawArticle {
  number: string;
  title?: string;
  content: string;
  norm_type?: string;
  subjects?: string[];
  legal_concepts?: string[];
  sanctions?: any;
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
