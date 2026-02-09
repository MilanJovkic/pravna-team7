"""Text extraction for court verdicts stored as .txt files."""
from pathlib import Path
from typing import Optional


class TextExtractor:
    """Loads text from .txt verdict files."""

    def __init__(self, encoding: str = "utf-8"):
        self.encoding = encoding

    def extract_text(self, txt_path: Path) -> str:
        """
        Loads text from a .txt file.

        Args:
            txt_path: Path to the .txt file

        Returns:
            File contents as a string
        """
        for enc in (self.encoding, "utf-8-sig", "cp1250", "latin-1"):
            try:
                return txt_path.read_text(encoding=enc).strip()
            except UnicodeDecodeError:
                continue
        return txt_path.read_text(errors="replace").strip()

    def extract_from_folder(self, folder_path: Path) -> dict[str, str]:
        """
        Loads text from all .txt files in a folder.

        Args:
            folder_path: Path to the folder with .txt files

        Returns:
            Mapping of case_id -> text
        """
        texts: dict[str, str] = {}
        for txt_file in sorted(folder_path.glob("*.txt")):
            texts[txt_file.stem] = self.extract_text(txt_file)
        return texts
