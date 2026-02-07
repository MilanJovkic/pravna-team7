"""
Integration tests for annotation pipeline.
"""

import pytest
from pathlib import Path
from src.config.app_config import ApplicationConfig, LLMConfig, ParserConfig, ExporterConfig
from src.application.container import DependencyContainer


class TestAnnotationPipeline:
    """Test complete annotation pipeline."""
    
    @pytest.fixture
    def config(self):
        """Create test configuration."""
        return ApplicationConfig(
            llm=LLMConfig(
                provider="github",
                model="gpt-4o",
                api_token="test_token"
            ),
            parser=ParserConfig(),
            exporter=ExporterConfig()
        )
    
    @pytest.fixture
    def container(self, config):
        """Create dependency container."""
        return DependencyContainer(config)
    
    def test_create_parser(self, container):
        """Test parser creation."""
        parser = container.get_parser()
        assert parser is not None
    
    def test_create_exporter(self, container):
        """Test exporter creation."""
        exporter = container.get_exporter()
        assert exporter is not None
    
    def test_singleton_instances(self, container):
        """Test that container returns singleton instances."""
        parser1 = container.get_parser()
        parser2 = container.get_parser()
        assert parser1 is parser2
