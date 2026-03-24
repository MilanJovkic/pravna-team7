#!/usr/bin/env python3
"""Test case saving and CBR reuse."""
import requests
import json
import os

# Test Task 8: Save new case and verify it appears in CBR queries

print("\n" + "="*60)
print("Test: Save New Case & Verify in CBR")
print("="*60)

new_case = {
    'facts': {
        'defendant': 'Ana K.',
        'injury_type': 'teska tjelesna povreda',
        'location': 'Banja Luka',
        'weapon': 'palisada',
        'weapon_used': True,
        'severe_consequence': True,
        'death_result': False,
        'negligence': False,
        'provocation': True,
        'fight_participation': True,
        'fight_consequence': 'none',
        'left_without_help': False
    },
    'outcome': 'osudjen',
    'selected_verdict': 'osudjen',
    'selected_sanction': 'kazna zatvora (predlog)',
    'user_confirmation': True,
}

BASE_URL = os.getenv('TEST_API_BASE_URL', 'http://localhost:8000/api')

# Step 1: Save the case
print("\n1. Saving new case...")
r1 = requests.post(
    f'{BASE_URL}/cases/',
    json=new_case,
    timeout=30
)
r1.raise_for_status()
saved = r1.json()
print(f"   ID: {saved.get('id')}")
print(f"   Case Number: {saved.get('case_number')}")

# Step 2: Query CBR with identical facts
print("\n2. Running CBR query with same facts...")
facts = {
    'defendant': 'Ana K.',
    'injury_type': 'teska tjelesna povreda',
    'location': 'Banja Luka',
    'weapon': 'palisada',
    'weapon_used': True,
    'severe_consequence': True,
    'death_result': False,
    'negligence': False,
    'provocation': True,
    'fight_participation': True,
    'fight_consequence': 'none',
    'left_without_help': False
}

r2 = requests.post(
    f'{BASE_URL}/reasoning/',
    json={'facts': facts, 'top_k': 5},
    timeout=30
)
r2.raise_for_status()
result = r2.json()
print(f"   Applied norms: {result['rule_reasoning']['applied_norms']}")
print(f"   CBR Matches found: {len(result['cbr']['matches'])}")

# Step 3: Verify new case appears in results
print("\n3. Checking if new case appears in CBR matches...")
found = False
for match in result['cbr']['matches']:
    if saved['case_number'] in match['case_number']:
        print(f"   ✓ FOUND: {match['case_number']}")
        print(f"     Similarity: {match['similarity']:.2%}")
        print(f"     Outcome: {match['outcome']}")
        found = True
        break

if not found:
    raise AssertionError("Saved case was not returned in CBR matches.")

print("\n" + "="*60)
print("Task 8 Status: WORKING ✓")
print("="*60)
