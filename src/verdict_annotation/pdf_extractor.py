"""PDF text extraction for court verdicts."""
from pathlib import Path
from typing import Optional

try:
    from PyPDF2 import PdfReader
except ImportError:
    PdfReader = None

from .text_normalization import normalize_legal_text


class PDFExtractor:
    """Extracts text from PDF court verdicts."""

    def __init__(self):
        if PdfReader is None:
            raise ImportError("PyPDF2 nije instaliran. Pokreni: pip install PyPDF2>=3.0.0")

    def _extract_with_pypdf2(self, pdf_path: Path) -> str:
        reader = PdfReader(str(pdf_path))
        text_parts = []
        for page in reader.pages:
            text = page.extract_text() or ""
            if text.strip():
                text_parts.append(text)
        return "\n\n".join(text_parts).strip()

    def extract_text(self, pdf_path: Path) -> str:
        """
        Ekstraktuje tekst iz PDF fajla.
        
        Args:
            pdf_path: Putanja do PDF fajla
            
        Returns:
            Ekstraktovani tekst
        """
        try:
            text = self._extract_with_pypdf2(pdf_path)
            normalized = normalize_legal_text(text)

            if normalized:
                return normalized

            raise RuntimeError("Nijedan extractor nije uspeo da izdvoji tekst")

        except Exception as e:
            raise RuntimeError(f"Greška pri ekstrakciji teksta iz {pdf_path}: {e}")

    def extract_from_folder(self, folder_path: Path) -> dict[str, str]:
        """
        Ekstraktuje tekst iz svih PDF fajlova u folderu.
        
        Args:
            folder_path: Putanja do foldera sa PDF fajlovima
            
        Returns:
            Dict {filename: extracted_text}
        """
        if not folder_path.exists():
            raise FileNotFoundError(f"Folder {folder_path} ne postoji")
        
        results = {}
        pdf_files = list(folder_path.glob("*.pdf"))
        
        if not pdf_files:
            raise ValueError(f"Nema PDF fajlova u {folder_path}")
        
        print(f"Pronađeno {len(pdf_files)} PDF fajlova...")
        
        for idx, pdf_file in enumerate(pdf_files, 1):
            safe_name = pdf_file.name.encode('ascii', 'replace').decode('ascii')
            print(f"[{idx}/{len(pdf_files)}] Ekstrahujem: {safe_name}")
            try:
                text = self.extract_text(pdf_file)
                results[pdf_file.stem] = text
                print(f"  [OK] Ekstrahovano {len(text)} karaktera")
            except Exception as e:
                print(f"  [X] Greska: {e}")
                results[pdf_file.stem] = ""
        
        return results
