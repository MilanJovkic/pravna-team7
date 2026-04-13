"""
RULEBASE GENERATION PACKAGE
============================

Zero-Hardcode Policy Implementation:
- RulebaseGenerator: Dinamična generisanja rulebase.clp iz zakon.xml
- RulebaseAdaptationService: Adapter koji zamenjuje hardkodovane prioritete
- DynamicPriorityInferencer: Zamena za hardkodovani priorities dict

Sve bez hardkoda - sistem je 100% law-agnostic!
"""

from .rulebase_generator import (
    RulebaseGenerator,
    AkomaNtosoParser,
    LawStructureAnalyzer,
    RulebaseCodeGenerator,
    PriorityInferencer,
    CaseFactsSyncronizer,
    ArticleMetadata,
    DefeasibleRule,
)

from .rule_reasoning_adapter import (
    RulebaseAdaptationService,
    DynamicPriorityInferencer,
    create_adapter_singleton,
)

__all__ = [
    # Generator
    "RulebaseGenerator",
    "AkomaNtosoParser",
    "LawStructureAnalyzer",
    "RulebaseCodeGenerator",
    "PriorityInferencer",
    "CaseFactsSyncronizer",
    "ArticleMetadata",
    "DefeasibleRule",
    # Adapter
    "RulebaseAdaptationService",
    "DynamicPriorityInferencer",
    "create_adapter_singleton",
]
