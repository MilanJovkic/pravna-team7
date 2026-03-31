"""Convert all PDFs to TXT files."""
import sys
import io

# Fix encoding for Windows console
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8', errors='replace')
sys.stderr = io.TextIOWrapper(sys.stderr.buffer, encoding='utf-8', errors='replace')

from pathlib import Path
from PyPDF2 import PdfReader


def main():
    pdf_folder = Path('data/verdicts_pdf')
    txt_folder = Path('data/verdicts_txt')
    txt_folder.mkdir(exist_ok=True)

    pdf_files = sorted(pdf_folder.glob("*.pdf"))
    print(f"Found {len(pdf_files)} PDF files")

    converted = 0
    for idx, pdf_file in enumerate(pdf_files, 1):
        print(f"[{idx}/{len(pdf_files)}] {pdf_file.name}", end=" ... ")
        try:
            reader = PdfReader(str(pdf_file))
            text_parts = []
            for page in reader.pages:
                text = page.extract_text()
                if text:
                    text_parts.append(text)
            full_text = "\n".join(text_parts).strip()
            
            if full_text:
                out_path = txt_folder / f'{pdf_file.stem}.txt'
                out_path.write_text(full_text, encoding='utf-8')
                print(f"OK ({len(full_text)} chars)")
                converted += 1
            else:
                print("SKIP (no text)")
        except Exception as e:
            print(f"ERROR: {e}")

    print(f"\nTotal: {converted}/{len(pdf_files)} converted")
    return 0 if converted == len(pdf_files) else 1


if __name__ == "__main__":
    sys.exit(main())
