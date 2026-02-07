"""
Regex-based legal text parser implementation.

Implements ILegalTextParser interface using regex patterns.
"""

import re
from typing import List, Optional
from ...domain.interfaces.parsers import ILegalTextParser
from ...domain.entities.legal_document import (
    LegalDocument, LegalChapter, LegalArticle, LegalParagraph, LegalPoint
)


class RegexLegalTextParser(ILegalTextParser):
    """
    Parser for legal texts using regex patterns.
    
    Recognizes hierarchy: CHAPTER → ARTICLE → PARAGRAPH → POINT
    """
    
    def __init__(self):
        """Initialize regex patterns for structure recognition."""
        self.chapter_pattern = re.compile(
            r'^GLAVA\s+([A-ZČĆŽŠĐ]+)\s+(.+?)$',
            re.MULTILINE | re.IGNORECASE
        )
        self.article_pattern = re.compile(
            r'^Član\s+(\d+[a-z]?)$',
            re.MULTILINE
        )
        self.article_title_pattern = re.compile(
            r'^([A-ZČĆŽŠĐ].+?)$'
        )
        self.paragraph_pattern = re.compile(
            r'^\((\d+)\)\s+(.+?)$',
            re.MULTILINE
        )
        self.point_pattern = re.compile(
            r'^(\d+)\)\s+(.+?)$'
        )
    
    def parse(self, text: str) -> LegalDocument:
        """
        Parse complete legal text into document structure.
        
        Args:
            text: Raw legal text
            
        Returns:
            Structured LegalDocument
        """
        chapters = self.parse_chapters(text)
        
        document = LegalDocument(
            name="Krivični zakonik Crne Gore",
            country_code="me",
            year="2024"
        )
        
        for chapter in chapters:
            document.add_chapter(chapter)
        
        return document
    
    def parse_chapters(self, text: str) -> List[LegalChapter]:
        """
        Parse chapters from legal text.
        
        Args:
            text: Raw legal text
            
        Returns:
            List of LegalChapter objects
        """
        chapters = []
        lines = text.split('\n')
        
        i = 0
        current_chapter = None
        current_article = None
        current_article_title = None
        
        while i < len(lines):
            line = lines[i].strip()
            
            # Skip empty lines
            if not line:
                i += 1
                continue
            
            # Check for CHAPTER
            chapter_match = self.chapter_pattern.match(line)
            if chapter_match:
                # Save previous chapter
                if current_chapter and current_article:
                    current_chapter.add_article(current_article)
                if current_chapter:
                    chapters.append(current_chapter)
                
                # Start new chapter
                chapter_num = chapter_match.group(1)
                chapter_title = chapter_match.group(2).strip()
                current_chapter = LegalChapter(
                    number=chapter_num,
                    title=chapter_title
                )
                current_article = None
                current_article_title = None
                i += 1
                continue
            
            # Check for ARTICLE
            article_match = self.article_pattern.match(line)
            if article_match:
                # Save previous article
                if current_article and current_chapter:
                    current_chapter.add_article(current_article)
                
                # Start new article
                article_num = article_match.group(1)
                current_article = LegalArticle(number=article_num)
                current_article_title = None
                i += 1
                
                # Check if next line is article title (all caps)
                if i < len(lines):
                    next_line = lines[i].strip()
                    if next_line and next_line[0].isupper() and not self.article_pattern.match(next_line):
                        current_article.title = next_line
                        i += 1
                
                continue
            
            # Parse article content (paragraphs and points)
            if current_article:
                self._parse_article_content(current_article, lines, i)
                # Move to next significant line
                i += 1
            else:
                i += 1
        
        # Save last article and chapter
        if current_article and current_chapter:
            current_chapter.add_article(current_article)
        if current_chapter:
            chapters.append(current_chapter)
        
        return chapters
    
    def _parse_article_content(self, article: LegalArticle, lines: List[str], start_idx: int) -> None:
        """Parse paragraphs and points within an article."""
        line = lines[start_idx].strip()
        
        # Check for numbered paragraph
        para_match = self.paragraph_pattern.match(line)
        if para_match:
            para_num = int(para_match.group(1))
            para_text = para_match.group(2).strip()
            paragraph = LegalParagraph(
                number=para_num,
                text=para_text,
                raw_text=line
            )
            article.add_paragraph(paragraph)
            return
        
        # Check for point
        point_match = self.point_pattern.match(line)
        if point_match:
            if article.paragraphs:
                point_num = point_match.group(1)
                point_text = point_match.group(2).strip()
                point = LegalPoint(
                    number=point_num,
                    text=point_text,
                    raw_text=line
                )
                article.paragraphs[-1].add_point(point)
            return
        
        # Unnumbered first paragraph
        if line and not para_match and not point_match:
            if not article.paragraphs or article.paragraphs[-1].number is not None:
                paragraph = LegalParagraph(
                    number=None,
                    text=line,
                    raw_text=line
                )
                article.add_paragraph(paragraph)
    
    def validate_structure(self, document: LegalDocument) -> bool:
        """
        Validate document structure.
        
        Args:
            document: Document to validate
            
        Returns:
            True if structure is valid
        """
        if not document.chapters:
            return False
        
        for chapter in document.chapters:
            if not chapter.articles:
                return False
            
            for article in chapter.articles:
                if not article.paragraphs:
                    return False
        
        return True
