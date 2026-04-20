import { Injectable } from '@angular/core';

interface ParsedReference {
  label: string;
  articleNumber: string | null;
  original: string;
}

/**
 * Centralized service for parsing legal references from law articles.
 * Extracts article numbers and formats reference labels.
 */
@Injectable({
  providedIn: 'root'
})
export class LegalReferenceService {

  constructor() { }

  /**
   * Parse an array of reference objects and extract article numbers.
   * Handles multiple reference formats (href, text, article, target fields).
   * 
   * @param references - Array of reference objects from backend
   * @returns Array of parsed references with extracted article numbers
   */
  parseReferences(references: Array<Record<string, any>>): ParsedReference[] {
    const parsed: ParsedReference[] = [];

    for (const ref of references) {
      const original = this.formatReference(ref);
      let label = original;
      let articleNumber: string | null = null;

      // Extract article number from href (e.g., #art_147 -> 147)
      if (ref['href']) {
        const hrefMatch = ref['href'].match(/#art_(\d+[a-z]?)/i);
        if (hrefMatch) {
          articleNumber = hrefMatch[1];
          label = ref['text'] || `Član ${articleNumber}`;
        } else if (ref['href'].includes('__para_')) {
          // It's a paragraph reference, not an article
          label = ref['text'] || original;
        }
      }
      
      // Try to extract from text field if we don't have articleNumber yet
      if (!articleNumber && ref['text']) {
        const textMatch = String(ref['text']).match(/[Čč]lan\s*(\d+[a-z]?)/i);
        if (textMatch) {
          articleNumber = textMatch[1];
          label = ref['text'];
        }
      }
      
      if (!articleNumber && ref['article']) {
        // Try to extract from article field
        const articleMatch = String(ref['article']).match(/(\d+[a-z]?)/i);
        if (articleMatch) {
          articleNumber = articleMatch[1];
          label = `Član ${articleNumber}`;
        }
      }
      
      if (!articleNumber && ref['target']) {
        // Try to extract from target field
        const targetMatch = String(ref['target']).match(/[čć]lan\s*(\d+[a-z]?)/i);
        if (targetMatch) {
          articleNumber = targetMatch[1];
          label = `Član ${articleNumber}`;
        }
      }

      // If we still don't have a label, try to parse from original
      if (!label || label === original) {
        const labelMatch = original.match(/[čć]lan\s*(\d+[a-z]?)/i);
        if (labelMatch) {
          articleNumber = labelMatch[1];
          label = `Član ${articleNumber}`;
        }
      }
      parsed.push({ label, articleNumber, original });
    }

    return parsed;
  }

  /**
   * Format a reference object into a human-readable string.
   * 
   * @param reference - Reference object
   * @returns Formatted reference string
   */
  private formatReference(reference: Record<string, any>): string {
    if (reference['text']) {
      return String(reference['text']);
    }
    if (reference['href']) {
      return String(reference['href']);
    }
    if (reference['article']) {
      return `Član ${reference['article']}`;
    }
    if (reference['target']) {
      return String(reference['target']);
    }
    return JSON.stringify(reference);
  }
}
