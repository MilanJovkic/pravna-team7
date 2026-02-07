"""
Domain entities representing legal document structure.

Following Clean Architecture principles - pure domain logic with no external dependencies.
"""

from dataclasses import dataclass, field
from typing import List, Optional
from datetime import datetime


@dataclass
class LegalPoint:
    """
    Point within a paragraph (e.g., '1) ko drugog liši života...').
    
    Represents the finest granularity in legal text structure.
    """
    number: str
    text: str
    raw_text: str
    
    def __post_init__(self):
        """Validate point data."""
        if not self.number or not self.text:
            raise ValueError("Point must have number and text")


@dataclass
class LegalParagraph:
    """
    Paragraph of an article (may contain points).
    
    Business rule: First paragraph may be unnumbered (number = None).
    """
    number: Optional[int]  # None for unnumbered first paragraph
    text: str
    points: List[LegalPoint] = field(default_factory=list)
    raw_text: str = ""
    
    def add_point(self, point: LegalPoint) -> None:
        """Add a point to this paragraph."""
        self.points.append(point)
    
    def has_points(self) -> bool:
        """Check if paragraph has enumerated points."""
        return len(self.points) > 0
    
    def get_full_text(self) -> str:
        """Get complete paragraph text including all points."""
        if not self.points:
            return self.text
        
        parts = [self.text] if self.text else []
        parts.extend([f"{p.number} {p.text}" for p in self.points])
        return " ".join(parts)


@dataclass
class LegalArticle:
    """
    Article of a law.
    
    Business rules:
    - Number may have suffix (e.g., "143", "151a", "151b")
    - Title is optional
    - Must have at least one paragraph
    """
    number: str
    title: Optional[str] = None
    paragraphs: List[LegalParagraph] = field(default_factory=list)
    raw_text: str = ""
    
    def __post_init__(self):
        """Validate article data."""
        if not self.number:
            raise ValueError("Article must have a number")
    
    def add_paragraph(self, paragraph: LegalParagraph) -> None:
        """Add a paragraph to this article."""
        self.paragraphs.append(paragraph)
    
    def get_full_text(self) -> str:
        """Get complete article text including all paragraphs and points."""
        parts = []
        if self.title:
            parts.append(f"Član {self.number} - {self.title}")
        else:
            parts.append(f"Član {self.number}")
        
        for para in self.paragraphs:
            parts.append(para.get_full_text())
        
        return "\n".join(parts)
    
    def paragraph_count(self) -> int:
        """Get number of paragraphs in this article."""
        return len(self.paragraphs)


@dataclass
class LegalChapter:
    """
    Chapter of a law (e.g., GLAVA).
    
    Business rule: Chapter must have a title and may contain multiple articles.
    """
    number: str
    title: str
    articles: List[LegalArticle] = field(default_factory=list)
    raw_text: str = ""
    
    def __post_init__(self):
        """Validate chapter data."""
        if not self.number or not self.title:
            raise ValueError("Chapter must have number and title")
    
    def add_article(self, article: LegalArticle) -> None:
        """Add an article to this chapter."""
        self.articles.append(article)
    
    def find_article(self, article_number: str) -> Optional[LegalArticle]:
        """Find article by number within this chapter."""
        for article in self.articles:
            if article.number == article_number:
                return article
        return None
    
    def article_count(self) -> int:
        """Get number of articles in this chapter."""
        return len(self.articles)


@dataclass
class LegalDocument:
    """
    Complete legal document (e.g., entire law).
    
    Root aggregate for legal document domain.
    """
    name: str
    country_code: str = "me"
    year: str = ""
    chapters: List[LegalChapter] = field(default_factory=list)
    created_at: datetime = field(default_factory=datetime.now)
    
    def __post_init__(self):
        """Validate document data."""
        if not self.name:
            raise ValueError("Document must have a name")
    
    def add_chapter(self, chapter: LegalChapter) -> None:
        """Add a chapter to this document."""
        self.chapters.append(chapter)
    
    def find_article(self, article_number: str) -> Optional[LegalArticle]:
        """Find article by number across all chapters."""
        for chapter in self.chapters:
            article = chapter.find_article(article_number)
            if article:
                return article
        return None
    
    def get_all_articles(self) -> List[LegalArticle]:
        """Get all articles from all chapters."""
        articles = []
        for chapter in self.chapters:
            articles.extend(chapter.articles)
        return articles
    
    def total_articles(self) -> int:
        """Get total number of articles in document."""
        return sum(chapter.article_count() for chapter in self.chapters)
    
    def total_chapters(self) -> int:
        """Get total number of chapters in document."""
        return len(self.chapters)
