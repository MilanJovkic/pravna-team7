"""
Refactored entry point for legal document annotation system.

This file provides backward compatibility while using the new architecture.
"""

import sys
from pathlib import Path

# Add src to path
sys.path.insert(0, str(Path(__file__).parent / "src"))

from presentation.cli.main import main

if __name__ == "__main__":
    main()
