"""
Modul za parsiranje i segmentaciju pravnih tekstova.

Struktura krivičnog zakonika:
- GLAVA (chapter)
- Član (article)
- stav (paragraph) - brojčani (1), (2) ili nenumerisan prvi stav
- tačka (point) - brojčani 1), 2), 3)
"""

import re
from typing import List, Dict, Optional
from dataclasses import dataclass, field


@dataclass
class LegalPoint:
    """Tačka unutar stava (npr. '1) ko drugog liši života...')"""
    number: str
    text: str
    raw_text: str


@dataclass
class LegalParagraph:
    """Stav člana (može sadržati tačke)"""
    number: Optional[int]  # None ako je prvi, nenumerisan stav
    text: str
    points: List[LegalPoint] = field(default_factory=list)
    raw_text: str = ""


@dataclass
class LegalArticle:
    """Član zakona"""
    number: str  # Broj člana (može imati sufix: "143", "151a", "151b")
    title: Optional[str]  # Naslov člana (npr. "Ubistvo")
    paragraphs: List[LegalParagraph] = field(default_factory=list)
    raw_text: str = ""


@dataclass
class LegalChapter:
    """Glava zakona"""
    number: str
    title: str
    articles: List[LegalArticle] = field(default_factory=list)
    raw_text: str = ""


class LegalTextParser:
    """
    Parser za strukturiranje pravnog teksta.
    
    Prepoznaje hijerarhiju:
    GLAVA → Član → stav → tačka
    """
    
    def __init__(self):
        # Regex pattern-i za identifikaciju strukturnih elemenata
        self.chapter_pattern = re.compile(
            r'^GLAVA\s+([A-ZČĆŽŠĐ]+)\s+(.+?)$',
            re.MULTILINE | re.IGNORECASE
        )
        self.article_title_pattern = re.compile(
            r'^([A-ZČĆŽŠĐ].+?)$'
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
        """
        Glavni metod za parsiranje pravnog teksta.
        
        Args:
            text: Sirovi tekst zakona
            
        Returns:
            Lista LegalChapter objekata
        """
        chapters = []
        lines = text.split('\n')
        
        i = 0
        current_chapter = None
        current_article = None
        current_article_title = None
        
        while i < len(lines):
            line = lines[i].strip()
            
            # Prazan red
            if not line:
                i += 1
                continue
            
            # Detekcija GLAVE
            chapter_match = self.chapter_pattern.match(line)
            if chapter_match:
                # Snimi prethodnu glavу
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
            
            # Detekcija Člana
            article_match = self.article_pattern.match(line)
            if article_match:
                # Snimi prethodni član
                if current_article and current_chapter:
                    current_chapter.articles.append(current_article)
                
                # Zadržava pun broj sa sufixom (143, 151a, 151b)
                article_num = article_match.group(1)
                current_article = LegalArticle(
                    number=article_num,
                    title=current_article_title,
                    raw_text=line
                )
                current_article_title = None
                i += 1
                continue
            
            # Naslov člana (detektovan PRIJE "Član X")
            # Ako je trenutna linija title-like i sledeća je "Član"
            if i + 1 < len(lines):
                next_line = lines[i + 1].strip()
                if self.article_pattern.match(next_line):
                    if line[0].isupper() and len(line) < 100:
                        current_article_title = line
                        i += 1
                        continue
            
            # Detekcija stava (numerisani)
            para_match = self.paragraph_pattern.match(line)
            if para_match and current_article:
                para_num = int(para_match.group(1))
                para_text = para_match.group(2).strip()
                
                # Proveri da li stav ima tačke (u narednim linijama)
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
                        
                        # Ukloni trailing semicolon ili tačku-zarez
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
            
            # Nenumerisan stav (prvi stav člana, obično)
            if current_article and not current_article.paragraphs:
                # Ako nema paragrafa, ovo je prvi stav
                paragraph_text = line
                
                # Prikupi multi-line text ako postoji
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
        
        # Snimi poslednji član i glavu
        if current_article and current_chapter:
            current_chapter.articles.append(current_article)
        if current_chapter:
            chapters.append(current_chapter)
        
        return chapters
    
    def get_all_articles(self, chapters: List[LegalChapter]) -> List[LegalArticle]:
        """Vrati sve članove iz svih glava (flat lista)."""
        articles = []
        for chapter in chapters:
            articles.extend(chapter.articles)
        return articles
    
    def get_article_full_text(self, article: LegalArticle) -> str:
        """Rekonstruiše pun tekst člana."""
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


if __name__ == "__main__":
    # Test
    with open("zakon.txt", "r", encoding="utf-8") as f:
        text = f.read()
    
    parser = LegalTextParser()
    chapters = parser.parse(text)
    
    print(f"Parsovano: {len(chapters)} glava")
    for ch in chapters:
        print(f"  GLAVA {ch.number}: {ch.title} ({len(ch.articles)} članaka)")
    
    all_articles = parser.get_all_articles(chapters)
    print(f"\nUkupno članaka: {len(all_articles)}")
    
    if all_articles:
        print(f"\nPrimer - Član {all_articles[0].number}:")
        print(parser.get_article_full_text(all_articles[0]))
