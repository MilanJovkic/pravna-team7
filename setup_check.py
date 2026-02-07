"""
Quick setup i dependency check skript.

Provjerava sve potrebne komponente prije pokretanja sistema.
"""

import sys
import os
from pathlib import Path


def check_python_version():
    """Provjerava Python verziju."""
    version = sys.version_info
    if version.major < 3 or (version.major == 3 and version.minor < 8):
        print("✗ Python 3.8+ je potreban")
        print(f"  Trenutna verzija: {version.major}.{version.minor}")
        return False
    print(f"✓ Python verzija: {version.major}.{version.minor}.{version.micro}")
    return True


def check_dependencies():
    """Provjerava instalirane pakete."""
    required = ['requests', 'dotenv']
    missing = []
    
    for package in required:
        try:
            if package == 'dotenv':
                __import__('dotenv')
            else:
                __import__(package)
            print(f"✓ {package} instaliran")
        except ImportError:
            missing.append(package)
            print(f"✗ {package} NEDOSTAJE")
    
    if missing:
        print("\nInstaliraj dependencies:")
        print("  pip install -r requirements.txt")
        return False
    
    return True


def check_input_files():
    """Provjerava ulazne fajlove."""
    required_files = {
        'zakon.txt': 'Tekst zakona za anotaciju',
        '.env': 'GitHub API token'
    }
    
    all_present = True
    for file, desc in required_files.items():
        if Path(file).exists():
            print(f"✓ {file} ({desc})")
        else:
            print(f"✗ {file} NEDOSTAJE ({desc})")
            all_present = False
    
    return all_present


def check_env_token():
    """Provjerava GitHub token u .env."""
    if not Path('.env').exists():
        return False
    
    with open('.env', 'r') as f:
        content = f.read()
    
    if 'GITHUB_TOKEN=' in content:
        token_line = [l for l in content.split('\n') if l.startswith('GITHUB_TOKEN=')][0]
        token = token_line.split('=')[1].strip()
        
        if token and token != 'your_token_here':
            print(f"✓ GitHub token prisutan (dužina: {len(token)} karaktera)")
            return True
        else:
            print("✗ GitHub token nije postavljen u .env")
            print("  Dodaj svoj token u .env fajl:")
            print("  GITHUB_TOKEN=ghp_...")
            return False
    
    return False


def test_api_connection():
    """Testira konekciju sa GitHub Models API."""
    try:
        from dotenv import load_dotenv
        import requests
        
        load_dotenv()
        token = os.getenv('GITHUB_TOKEN')
        
        if not token:
            print("✗ Token nije učitan iz .env")
            return False
        
        # Test API call (samo provjera auth)
        headers = {
            'Authorization': f'Bearer {token}'
        }
        
        # Koristimo lightweight endpoint za test
        url = "https://models.inference.ai.azure.com/chat/completions"
        
        # Ne šaljemo pun request, samo provjeravamo auth
        response = requests.get(
            "https://api.github.com/user",  # GitHub API za provjeru tokena
            headers=headers,
            timeout=5
        )
        
        if response.status_code == 200:
            print("✓ GitHub token je validan")
            return True
        else:
            print(f"⚠ GitHub token možda nije validan (status: {response.status_code})")
            return False
    
    except Exception as e:
        print(f"⚠ Nisam mogao testirati API konekciju: {e}")
        return False


def print_next_steps():
    """Prikazuje sledeće korake."""
    print("\n" + "=" * 70)
    print("SLEDEĆI KORACI")
    print("=" * 70)
    print("\n1. Test na 5 članaka:")
    print("   python main.py --limit 5 --output test.xml")
    print("\n2. Analiza rezultata:")
    print("   python analyze_annotations.py test_annotations.json")
    print("\n3. Knowledge graph:")
    print("   python extract_knowledge_graph.py test_annotations.json --all")
    print("\n4. Puno procesiranje:")
    print("   python process_full_law.py")
    print("\nVidi EXAMPLES.md za više primjera!")
    print("=" * 70)


def main():
    """Glavni check."""
    print("=" * 70)
    print("PROVERA SISTEMA ZA AUTOMATSKU ANOTACIJU")
    print("=" * 70)
    print()
    
    checks = [
        ("Python verzija", check_python_version),
        ("Dependencies", check_dependencies),
        ("Input fajlovi", check_input_files),
        ("GitHub token", check_env_token),
        ("API konekcija", test_api_connection)
    ]
    
    results = []
    for name, check_func in checks:
        print(f"\n[{name}]")
        result = check_func()
        results.append((name, result))
    
    print("\n" + "=" * 70)
    print("REZIME")
    print("=" * 70)
    
    for name, result in results:
        status = "✓ OK" if result else "✗ PROBLEM"
        print(f"{status:15s} {name}")
    
    all_ok = all(r for _, r in results)
    
    if all_ok:
        print("\n✓ Sistem je spreman za rad!")
        print_next_steps()
        return 0
    else:
        print("\n✗ Ispravi probleme prije pokretanja sistema.")
        print("\nTroubleshooting:")
        print("  - Dependencies: pip install -r requirements.txt")
        print("  - GitHub token: Dodaj u .env fajl")
        print("  - zakon.txt: Provjeri da fajl postoji")
        return 1


if __name__ == "__main__":
    sys.exit(main())
