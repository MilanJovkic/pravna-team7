# Legal Information System - Architecture Documentation

## System Overview

This system is designed to support judges in decision-making for legal cases by:
1. Maintaining a knowledge base of legal norms and court decisions
2. Reasoning over facts to suggest violated norms and potential sanctions
3. Providing explanations through relevant legal norms and case law

## Architecture Principles

### SOLID Principles Implementation

#### 1. Single Responsibility Principle (SRP)
Each class has one clear reason to change:
- `LegalDocument` - Represents legal document structure
- `RegexLegalTextParser` - Parses text into structure
- `LLMSemanticAnnotator` - Extracts semantic annotations
- `AkomaNtosoExporter` - Exports to XML format

#### 2. Open/Closed Principle (OCP)
System is open for extension, closed for modification:
- New parsers: implement `ILegalTextParser`
- New annotators: implement `ISemanticAnnotator`
- New exporters: implement `IDocumentExporter`

#### 3. Liskov Substitution Principle (LSP)
All implementations are substitutable:
- Any `ILegalTextParser` can replace another
- Any `ISemanticAnnotator` can replace another

#### 4. Interface Segregation Principle (ISP)
Focused, specific interfaces:
- `ILegalTextParser` - only parsing methods
- `ISemanticAnnotator` - only annotation methods
- `IDocumentExporter` - only export methods

#### 5. Dependency Inversion Principle (DIP)
High-level modules depend on abstractions:
- `AnnotateLegalDocumentUseCase` depends on interfaces
- Concrete implementations injected via `DependencyContainer`

### Clean Architecture Layers

```
┌─────────────────────────────────────┐
│     Presentation Layer (CLI/Web)    │
├─────────────────────────────────────┤
│    Application Layer (Use Cases)    │
├─────────────────────────────────────┤
│   Infrastructure Layer (Impl.)      │
├─────────────────────────────────────┤
│    Domain Layer (Entities/Rules)    │
└─────────────────────────────────────┘
```

## Directory Structure

```
src/
├── domain/                    # Core business logic
│   ├── entities/             # Domain entities
│   │   ├── legal_document.py # Document structure
│   │   └── annotation.py     # Semantic annotations
│   └── interfaces/           # Abstract interfaces
│       ├── parsers.py        # Parser interface
│       ├── annotators.py     # Annotator interface
│       └── exporters.py      # Exporter interface
│
├── application/              # Use cases & services
│   ├── use_cases/            # Business workflows
│   │   └── annotate_document.py
│   └── container.py          # Dependency injection
│
├── infrastructure/           # External implementations
│   ├── parsers/              # Text parsing
│   │   └── regex_parser.py
│   ├── llm/                  # LLM integration
│   │   └── llm_annotator.py
│   ├── exporters/            # Format exporters
│   │   └── akoma_exporter.py
│   └── repositories/         # Data persistence
│
└── presentation/             # User interfaces
    ├── cli/                  # Command-line
    ├── web/                  # Web UI (future)
    └── api/                  # REST API (future)
```

## Design Patterns

### 1. Repository Pattern
```python
class IDocumentRepository(ABC):
    @abstractmethod
    def save(self, document: LegalDocument) -> bool:
        pass
```

### 2. Dependency Injection
```python
class DependencyContainer:
    def get_annotate_document_use_case(self):
        return AnnotateLegalDocumentUseCase(
            parser=self.get_parser(),
            annotator=self.get_annotator(),
            exporter=self.get_exporter()
        )
```

### 3. Strategy Pattern
Different implementations of interfaces:
- `RegexLegalTextParser` vs `NLPLegalTextParser`
- `LLMSemanticAnnotator` vs `RuleBasedAnnotator`

### 4. Factory Pattern
Configuration creates appropriate implementations:
```python
config = ApplicationConfig.from_env()
container = DependencyContainer(config)
```

## Extensibility Guide

### Adding New Task Implementations

#### Task 2: Court Decisions
```python
# 1. Add entity
@dataclass
class CourtDecision:
    case_number: str
    parties: List[str]
    decision_text: str

# 2. Add interface
class ICourtDecisionParser(ABC):
    @abstractmethod
    def parse(self, text: str) -> CourtDecision:
        pass

# 3. Add implementation
class CourtDecisionParser(ICourtDecisionParser):
    def parse(self, text: str) -> CourtDecision:
        # Implementation
```

#### Task 3: LegalRuleML Export
```python
class LegalRuleMLExporter(IDocumentExporter):
    def export(self, document, annotations, output_path):
        # Generate LegalRuleML XML
```

#### Task 4: NLP Fact Extraction
```python
class IFactExtractor(ABC):
    @abstractmethod
    def extract_facts(self, text: str) -> List[Fact]:
        pass

class NLPFactExtractor(IFactExtractor):
    def extract_facts(self, text: str):
        # Use spaCy/transformers
```

#### Task 5: Rule-Based Reasoning
```python
class RuleEngine:
    def __init__(self, rules: List[LegalRule]):
        self.rules = rules
    
    def reason(self, facts: List[Fact]) -> List[Conclusion]:
        # Integrate with dr-device
```

#### Task 6: Case-Based Reasoning
```python
class CaseBasedReasoner:
    def __init__(self, case_repository: ICaseRepository):
        self.cases = case_repository
    
    def find_similar(self, query_case: Case) -> List[Case]:
        # Implement similarity functions
```

## Testing Strategy

### Unit Tests
Test individual components in isolation:
```python
def test_legal_article_creation():
    article = LegalArticle(number="143", title="Ubistvo")
    assert article.number == "143"
```

### Integration Tests
Test component interactions:
```python
def test_annotation_pipeline():
    container = DependencyContainer(config)
    use_case = container.get_annotate_document_use_case()
    result = use_case.execute(input_file, output_file)
    assert result["success"]
```

### Mocking
Mock external dependencies:
```python
class MockLLMAnnotator(ISemanticAnnotator):
    def annotate_article(self, article):
        return SemanticAnnotation(...)
```

## Configuration Management

Environment-based configuration:
```env
LLM_PROVIDER=github
LLM_MODEL=gpt-4o
GITHUB_TOKEN=xxx
```

Load via:
```python
config = ApplicationConfig.from_env()
```

## Error Handling

Structured error handling:
```python
try:
    result = use_case.execute(...)
except ParseError as e:
    logger.error(f"Parse failed: {e}")
except AnnotationError as e:
    logger.error(f"Annotation failed: {e}")
```

## Performance Considerations

1. **Rate Limiting** - Built into LLM annotator
2. **Batch Processing** - Process multiple articles efficiently
3. **Caching** - Cache parsed documents (future)
4. **Lazy Loading** - Load data on demand (future)

## Security

1. **API Token Management** - Via environment variables
2. **Input Validation** - Validate all user inputs
3. **Output Sanitization** - Clean XML output

## Future Enhancements

1. **Web Interface** - Add REST API and web UI
2. **Database Integration** - Replace file-based storage
3. **Caching Layer** - Redis for performance
4. **Async Processing** - Celery for background tasks
5. **Monitoring** - Logging and metrics
6. **CI/CD** - Automated testing and deployment
