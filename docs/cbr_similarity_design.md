# CBR Similarity Design (Phase 5)

This document formalizes the upgraded CBR similarity model for Task 6.

## Objectives

- Weighted similarity by legal relevance.
- Soft similarity for text attributes (location and weapon).
- Tri-state handling for unknown boolean values.
- Per-feature contribution explanation in CBR response.

## Feature Weights

Total weight = 1.00

- injury_type: 0.22
- location: 0.10
- weapon: 0.08
- weapon_used: 0.10
- severe_consequence: 0.12
- death_result: 0.10
- negligence: 0.06
- provocation: 0.06
- fight_participation: 0.06
- fight_consequence: 0.05
- left_without_help: 0.05

## Similarity Functions

- injury_type: tabular similarity (heavy/light injuries, unknown-aware)
- fight_consequence: tabular similarity (none/death_or_serious_injury, unknown-aware)
- location: soft text similarity (token + character overlap + synonym groups)
- weapon: soft text similarity (token + character overlap + synonym groups)
- booleans: unknown-aware boolean similarity

## Unknown Handling

Unknown values are represented as `unknown` in Java CBR layer.

- unknown vs known -> similarity 0.5 (neutral penalty)
- unknown vs unknown -> similarity 0.5
- known boolean mismatch -> 0.0
- known boolean match -> 1.0

This prevents accidental coercion of NULL to false.

## Explainability Output

Each CBR match now includes `feature_contributions`.

- Contribution = local_similarity * feature_weight / total_weight
- Output is returned per attribute in API JSON for transparent case comparison.
