#!/usr/bin/env python3
"""Test CBR reasoning with multiple scenarios."""
import requests
import json

BASE_URL = 'http://localhost:8000/api/reasoning/'

def test_scenario(name, facts, top_k=5):
    """Test a reasoning scenario."""
    print(f"\n{'='*60}")
    print(f"Test: {name}")
    print('='*60)
    
    try:
        r = requests.post(
            BASE_URL,
            json={'facts': facts, 'top_k': top_k},
            timeout=30
        )
        r.raise_for_status()
        res = r.json()
        
        # Display results
        print(f"\nRule-Based Reasoning:")
        print(f"  Applied norms: {res['rule_reasoning']['applied_norms']}")
        
        print(f"\nApplied Articles:")
        for art in res['applied_articles']:
            print(f"  - Article {art}")
        
        print(f"\nCBR Matches: {len(res['cbr']['matches'])} cases")
        for i, match in enumerate(res['cbr']['matches'][:3], 1):
            print(f"  {i}. {match['case_number']}: {match['similarity']:.2%} similar → {match['outcome']}")
        
        print(f"\nSuggested Verdict: {res['suggested_verdict']}")
        print(f"Suggested Sanction: {res['suggested_sanction']}")
        
        return True
    except Exception as e:
        print(f"ERROR: {e}")
        return False

# Test 1: Severe injury with weapon
test_scenario(
    "Severe Injury with Weapon",
    {
        'defendant': 'Milos P.',
        'injury_type': 'teska tjelesna povreda',
        'location': 'Sarajevo',
        'weapon': 'noz',
        'weapon_used': True,
        'severe_consequence': True,
        'death_result': False,
        'negligence': False,
        'provocation': False,
        'fight_participation': False,
        'fight_consequence': 'none',
        'left_without_help': False
    }
)

# Test 2: Light injury
test_scenario(
    "Light Injury",
    {
        'defendant': 'Marko M.',
        'injury_type': 'laka tjelesna povreda',
        'location': 'Podgorica',
        'weapon': None,
        'weapon_used': False,
        'severe_consequence': False,
        'death_result': False,
        'negligence': False,
        'provocation': False,
        'fight_participation': False,
        'fight_consequence': 'none',
        'left_without_help': False
    }
)

# Test 3: No injury info
test_scenario(
    "Minimal Case (No Injury)",
    {
        'defendant': 'John Doe',
        'injury_type': None,
        'location': None,
        'weapon': None,
        'weapon_used': False,
        'severe_consequence': False,
        'death_result': False,
        'negligence': False,
        'provocation': False,
        'fight_participation': False,
        'fight_consequence': 'none',
        'left_without_help': False
    }
)

print(f"\n{'='*60}")
print("Testing Complete!")
print('='*60)
