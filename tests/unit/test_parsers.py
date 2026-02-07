"""
Unit tests for parsers.
"""

import pytest
from src.infrastructure.parsers.regex_parser import RegexLegalTextParser


class TestRegexLegalTextParser:
    """Test regex-based legal text parser."""
    
    def test_parse_simple_chapter(self):
        """Test parsing simple chapter."""
        text = """GLAVA I
OSNOVNE ODREDBE

Član 1
Ko drugog liši života kazniće se zatvorom."""
        
        parser = RegexLegalTextParser()
        document = parser.parse(text)
        
        assert document is not None
        assert document.total_chapters() >= 1
    
    def test_validate_structure(self):
        """Test structure validation."""
        text = """GLAVA I
TEST

Član 1
Text"""
        
        parser = RegexLegalTextParser()
        document = parser.parse(text)
        
        is_valid = parser.validate_structure(document)
        assert is_valid is True
