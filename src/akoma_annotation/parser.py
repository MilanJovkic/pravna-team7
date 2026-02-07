"""Parser za strukturiranje zakona.

Hijerarhija: GLAVA → Član → stav → tačka.
"""
import re
from dataclasses import dataclass, field
from typing import List, Optional


@dataclass
class LegalPoint:
    """Tačka unutar stava."""
    number: str
    text: str
    raw_text: str


@dataclass
class LegalParagraph:
    """Stav člana koji može sadržati tačke."""
    number: Optional[int]
    text: str
    points: List[LegalPoint] = field(default_factory=list)
    raw_text: str = ""


@dataclass
class LegalArticle:
    """Član zakona sa naslovom i paragrafima."""
    number: str
    title: Optional[str]
    paragraphs: List[LegalParagraph] = field(default_factory=list)
    raw_text: str = ""


@dataclass
class LegalChapter:
    """Glava zakona sa listom članova."""
    number: str
    title: str
    articles: List[LegalArticle] = field(default_factory=list)
    raw_text: str = ""


class LegalTextParser:
    """Parser koji prepoznaje glave, članove, stavove i tačke."""

    def __init__(self):
        self.chapter_pattern = re.compile(
            r'^GLAVA\s+([A-ZČĆŽŠĐ]+)\s+(.+?)$',
            re.MULTILINE | re.IGNORECASE
        )
        self.article_pattern = re.compile(
            r'^Član\s+(\d+[a-z]?)$',
            re.MULTILINE
        )
        self.paragraph_pattern = re.compile(
            r'^\((\d+)\)\s+(.+?)$',
            re.MULTILINE
        )
        self.point_pattern = re.compile(
            r'^(\d+)\)\s+(.+?)$'
        )

    def parse(self, text: str) -> List[LegalChapter]:
        """Parsira tekst zakona u hijerarhiju objekata."""
        chapters = []
        lines = text.split('\n')

        i = 0
        current_chapter = None
        current_article = None
        current_article_title = None

        while i < len(lines):
            line = lines[i].strip()

            if not line:
                i += 1
                continue

            chapter_match = self.chapter_pattern.match(line)
            if chapter_match:
                if current_chapter and current_article:
                    current_chapter.articles.append(current_article)
                if current_chapter:
                    chapters.append(current_chapter)

                chapter_num = chapter_match.group(1)
                chapter_title = chapter_match.group(2).strip()
                current_chapter = LegalChapter(
                    number=chapter_num,
                    title=chapter_title,
                    raw_text=line
                )
                current_article = None
                current_article_title = None
                i += 1
                continue

            article_match = self.article_pattern.match(line)
            if article_match:
                if current_article and current_chapter:
                    current_chapter.articles.append(current_article)

                article_num = article_match.group(1)
                current_article = LegalArticle(
                    number=article_num,
                    title=current_article_title,
                    raw_text=line
                )
                current_article_title = None
                i += 1
                continue

            if i + 1 < len(lines):
                next_line = lines[i + 1].strip()
                if self.article_pattern.match(next_line):
                    if line and line[0].isupper() and len(line) < 100:
                        current_article_title = line
                        i += 1
                        continue

            para_match = self.paragraph_pattern.match(line)
            if para_match and current_article:
                para_num = int(para_match.group(1))
                para_text = para_match.group(2).strip()

                points = []
                j = i + 1
                while j < len(lines):
                    point_line = lines[j].strip()
                    if not point_line:
                        j += 1
                        continue

                    point_match = self.point_pattern.match(point_line)
                    if point_match:
                        point_num = point_match.group(1)
                        point_text = point_match.group(2).strip()
                        point_text = point_text.rstrip(';')
                        points.append(LegalPoint(
                            number=point_num,
                            text=point_text,
                            raw_text=point_line
                        ))
                        j += 1
                    else:
                        break

                paragraph = LegalParagraph(
                    number=para_num,
                    text=para_text,
                    points=points,
                    raw_text=line
                )
                current_article.paragraphs.append(paragraph)
                i = j
                continue

            if current_article and not current_article.paragraphs:
                paragraph_text = line
                j = i + 1
                while j < len(lines):
                    next_line = lines[j].strip()
                    if not next_line:
                        break
                    if (self.article_pattern.match(next_line) or
                        self.paragraph_pattern.match(next_line) or
                        (j + 1 < len(lines) and self.article_pattern.match(lines[j + 1].strip()))):
                        break
                    paragraph_text += " " + next_line
                    j += 1

                paragraph = LegalParagraph(
                    number=None,
                    text=paragraph_text.strip(),
                    raw_text=line
                )
                current_article.paragraphs.append(paragraph)
                i = j
                continue

            i += 1

        if current_article and current_chapter:
            current_chapter.articles.append(current_article)
        if current_chapter:
            chapters.append(current_chapter)

        return chapters

    def get_all_articles(self, chapters: List[LegalChapter]) -> List[LegalArticle]:
        """Vraća sve članke iz svih glava."""
        articles = []
        for chapter in chapters:
            articles.extend(chapter.articles)
        return articles

    def get_article_full_text(self, article: LegalArticle) -> str:
        """Rekonstruše tekst člana uključujući stavove i tačke."""
        parts = []
        if article.title:
            parts.append(article.title)
        parts.append(f"Član {article.number}")

        for para in article.paragraphs:
            if para.number:
                parts.append(f"({para.number}) {para.text}")
            else:
                parts.append(para.text)

            for point in para.points:
                parts.append(f"{point.number}) {point.text}")

        return "\n".join(parts)
