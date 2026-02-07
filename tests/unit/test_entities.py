"""
Unit tests for domain entities.
"""

import pytest
from src.domain.entities.legal_document import (
    LegalPoint, LegalParagraph, LegalArticle, LegalChapter, LegalDocument
)


class TestLegalPoint:
    """Test LegalPoint entity."""
    
    def test_create_valid_point(self):
        """Test creating a valid point."""
        point = LegalPoint(
            number="1",
            text="ko drugog liši života",
            raw_text="1) ko drugog liši života"
        )
        assert point.number == "1"
        assert point.text == "ko drugog liši života"
    
    def test_create_invalid_point_raises_error(self):
        """Test that creating point without required fields raises error."""
        with pytest.raises(ValueError):
            LegalPoint(number="", text="some text", raw_text="raw")


class TestLegalParagraph:
    """Test LegalParagraph entity."""
    
    def test_create_numbered_paragraph(self):
        """Test creating numbered paragraph."""
        para = LegalParagraph(
            number=1,
            text="Ko drugog liši života",
            raw_text="(1) Ko drugog liši života"
        )
        assert para.number == 1
        assert para.has_points() is False
    
    def test_add_point_to_paragraph(self):
        """Test adding point to paragraph."""
        para = LegalParagraph(number=1, text="Text", raw_text="raw")
        point = LegalPoint(number="1", text="point text", raw_text="1) point text")
        
        para.add_point(point)
        
        assert para.has_points() is True
        assert len(para.points) == 1


class TestLegalArticle:
    """Test LegalArticle entity."""
    
    def test_create_article_with_title(self):
        """Test creating article with title."""
        article = LegalArticle(number="143", title="Ubistvo")
        assert article.number == "143"
        assert article.title == "Ubistvo"
    
    def test_article_requires_number(self):
        """Test that article requires number."""
        with pytest.raises(ValueError):
            LegalArticle(number="")
    
    def test_get_full_text(self):
        """Test getting full article text."""
        article = LegalArticle(number="143", title="Ubistvo")
        para = LegalParagraph(number=None, text="Ko drugog liši života", raw_text="raw")
        article.add_paragraph(para)
        
        text = article.get_full_text()
        assert "143" in text
        assert "Ubistvo" in text
        assert "Ko drugog liši života" in text


class TestLegalDocument:
    """Test LegalDocument entity."""
    
    def test_create_document(self):
        """Test creating legal document."""
        doc = LegalDocument(name="Krivični zakonik", country_code="me", year="2024")
        assert doc.name == "Krivični zakonik"
        assert doc.total_chapters() == 0
    
    def test_find_article(self):
        """Test finding article in document."""
        doc = LegalDocument(name="Test", country_code="me")
        chapter = LegalChapter(number="I", title="Test Chapter")
        article = LegalArticle(number="143")
        
        chapter.add_article(article)
        doc.add_chapter(chapter)
        
        found = doc.find_article("143")
        assert found is not None
        assert found.number == "143"
