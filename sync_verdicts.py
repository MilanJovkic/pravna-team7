#!/usr/bin/env python3
"""
Verdict synchronization script.

Ensures all PDF verdicts have corresponding TXT and XML versions.
This script should be run before the main application starts.

Flow:
1. Scan PDF folder for all verdict PDFs
2. Check which ones are missing TXT versions -> extract them
3. Check which TXT files are missing XML versions -> annotate them
4. Report status
"""
import argparse
import sys
import io
from pathlib import Path

# Fix Windows console encoding for Cyrillic characters
if sys.platform == 'win32' and hasattr(sys.stdout, 'buffer'):
    sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8', errors='replace')
    sys.stderr = io.TextIOWrapper(sys.stderr.buffer, encoding='utf-8', errors='replace')

# Add project root to path
PROJECT_ROOT = Path(__file__).resolve().parent
sys.path.insert(0, str(PROJECT_ROOT))

from src.verdict_annotation.pdf_extractor import PDFExtractor
from src.verdict_annotation.verdict_pipeline import VerdictAnnotationPipeline


# Default paths
PDF_FOLDER = PROJECT_ROOT / "data" / "verdicts_pdf"
TXT_FOLDER = PROJECT_ROOT / "data" / "verdicts_txt"
XML_FOLDER = PROJECT_ROOT / "data" / "verdicts_xml"


def cleanup_gen_artifacts(txt_folder: Path, xml_folder: Path) -> int:
    """Remove generated GEN-* artifacts from TXT/XML corpus folders."""
    removed = 0
    for folder, extension in ((txt_folder, ".txt"), (xml_folder, ".xml")):
        if not folder.exists():
            continue
        for path in folder.glob(f"*{extension}"):
            if path.stem.upper().startswith("GEN"):
                path.unlink(missing_ok=True)
                removed += 1
    return removed


def get_verdict_stems(folder: Path, extension: str) -> set[str]:
    """Get set of file stems (names without extension) from a folder."""
    if not folder.exists():
        return set()
    return {f.stem for f in folder.glob(f"*{extension}")}


def sync_pdf_to_txt(pdf_folder: Path, txt_folder: Path, force: bool = False) -> list[str]:
    """
    Extract text from PDFs that don't have corresponding TXT files.
    
    Args:
        pdf_folder: Folder containing PDF verdicts
        txt_folder: Folder for TXT output
        force: If True, re-extract all PDFs even if TXT exists
        
    Returns:
        List of newly extracted file stems
    """
    pdf_stems = get_verdict_stems(pdf_folder, ".pdf")
    txt_stems = get_verdict_stems(txt_folder, ".txt")
    
    if force:
        missing = pdf_stems
    else:
        missing = pdf_stems - txt_stems
    
    if not missing:
        print(f"[OK] Svi PDF fajlovi imaju TXT verzije ({len(pdf_stems)} ukupno)")
        return []
    
    print(f"\n{'='*70}")
    print(f"PDF -> TXT EKSTRAKCIJA")
    print(f"{'='*70}")
    print(f"Pronadjeno {len(missing)} PDF fajlova bez TXT verzije:")
    for stem in sorted(missing):
        print(f"  - {stem}.pdf")
    print()
    
    # Ensure output folder exists
    txt_folder.mkdir(parents=True, exist_ok=True)
    
    extractor = PDFExtractor()
    extracted = []
    
    for stem in sorted(missing):
        pdf_path = pdf_folder / f"{stem}.pdf"
        txt_path = txt_folder / f"{stem}.txt"
        
        print(f"Ekstrahujem: {stem}.pdf...")
        try:
            text = extractor.extract_text(pdf_path)
            if text:
                txt_path.write_text(text, encoding="utf-8")
                print(f"  [OK] Sacuvano: {txt_path.name} ({len(text)} karaktera)")
                extracted.append(stem)
            else:
                print(f"  [!] Prazan tekst iz {stem}.pdf")
        except Exception as e:
            print(f"  [X] Greska: {e}")
    
    print(f"\nEkstrahovano {len(extracted)}/{len(missing)} PDF fajlova")
    return extracted


def sync_txt_to_xml(
    txt_folder: Path,
    xml_folder: Path,
    provider: str = "openai",
    model: str = None,
    force: bool = False,
    no_llm: bool = False
) -> list[str]:
    """
    Annotate TXT files that don't have corresponding XML files.
    
    Args:
        txt_folder: Folder containing TXT verdicts
        xml_folder: Folder for XML output
        provider: LLM provider
        model: LLM model (None = use default from config)
        force: If True, re-annotate all TXT files
        no_llm: If True, skip LLM annotation (regex only)
        
    Returns:
        List of newly annotated file stems
    """
    txt_stems = get_verdict_stems(txt_folder, ".txt")
    xml_stems = get_verdict_stems(xml_folder, ".xml")
    
    if force:
        missing = txt_stems
    else:
        missing = txt_stems - xml_stems
    
    if not missing:
        print(f"[OK] Svi TXT fajlovi imaju XML verzije ({len(txt_stems)} ukupno)")
        return []
    
    print(f"\n{'='*70}")
    print(f"TXT -> XML ANOTACIJA")
    print(f"{'='*70}")
    print(f"Pronadjeno {len(missing)} TXT fajlova bez XML verzije:")
    for stem in sorted(missing):
        print(f"  - {stem}.txt")
    print()
    
    # Run annotation pipeline
    pipeline = VerdictAnnotationPipeline(
        txt_folder=str(txt_folder),
        output_xml_dir=str(xml_folder),
        model=model,
        provider=provider,
        enable_llm=not no_llm
    )
    
    success = pipeline.run()
    
    if success:
        new_xml_stems = get_verdict_stems(xml_folder, ".xml")
        annotated = list(new_xml_stems - xml_stems)
        return annotated
    else:
        print("[!] Anotacija nije uspela u potpunosti")
        return []


def check_sync_status(pdf_folder: Path, txt_folder: Path, xml_folder: Path) -> dict:
    """
    Check synchronization status between PDF, TXT, and XML folders.
    
    Returns:
        Dict with status information
    """
    pdf_stems = get_verdict_stems(pdf_folder, ".pdf")
    txt_stems = get_verdict_stems(txt_folder, ".txt")
    xml_stems = get_verdict_stems(xml_folder, ".xml")
    
    # Calculate coverage (PDF -> TXT -> XML chain)
    missing_txt = pdf_stems - txt_stems  # PDFs without TXT
    missing_xml = txt_stems - xml_stems  # TXTs without XML
    
    # Sync is complete when all PDFs have TXTs and all TXTs have XMLs
    fully_synced = len(missing_txt) == 0 and len(missing_xml) == 0 and len(pdf_stems) > 0
    
    return {
        "pdf_count": len(pdf_stems),
        "txt_count": len(txt_stems),
        "xml_count": len(xml_stems),
        "xml_from_txt_count": len(txt_stems & xml_stems),  # XMLs matching TXT stems
        "missing_txt": sorted(missing_txt),
        "missing_xml": sorted(missing_xml),
        "orphan_txt": sorted(txt_stems - pdf_stems),
        "orphan_xml": sorted(xml_stems - txt_stems),  # Extra XMLs (like GEN-*)
        "fully_synced": fully_synced
    }


def print_status(status: dict) -> None:
    """Print sync status in a readable format."""
    print(f"\n{'='*70}")
    print("STATUS SINHRONIZACIJE PRESUDA")
    print(f"{'='*70}")
    print(f"PDF fajlova:           {status['pdf_count']}")
    print(f"TXT fajlova:           {status['txt_count']}")
    print(f"XML fajlova (ukupno):  {status['xml_count']}")
    print(f"XML od TXT presuda:    {status['xml_from_txt_count']}")
    
    if status["missing_txt"]:
        print(f"\n[!] PDF bez TXT ({len(status['missing_txt'])}):")
        for stem in status["missing_txt"]:
            safe_stem = stem.encode('ascii', 'replace').decode('ascii')
            print(f"  - {safe_stem}")
    
    if status["missing_xml"]:
        print(f"\n[!] TXT bez XML ({len(status['missing_xml'])}):")
        for stem in status["missing_xml"]:
            safe_stem = stem.encode('ascii', 'replace').decode('ascii')
            print(f"  - {safe_stem}")
    
    if status["fully_synced"]:
        print(f"\n[OK] Sve presude su sinhronizovane ({status['pdf_count']} PDF -> TXT -> XML)")
    
    print(f"{'='*70}\n")


def sync_all(
    pdf_folder: Path = PDF_FOLDER,
    txt_folder: Path = TXT_FOLDER,
    xml_folder: Path = XML_FOLDER,
    provider: str = "openai",
    model: str = None,
    force: bool = False,
    no_llm: bool = False,
    cleanup_gen: bool = False,
    check_only: bool = False
) -> bool:
    """
    Full synchronization: PDF → TXT → XML.
    
    Args:
        pdf_folder: Folder containing PDF verdicts
        txt_folder: Folder for TXT output
        xml_folder: Folder for XML output
        provider: LLM provider
        model: LLM model
        force: Re-process all files
        no_llm: Skip LLM annotation
        check_only: Only check status, don't sync
        
    Returns:
        True if all files are synced, False otherwise
    """
    if cleanup_gen:
        removed = cleanup_gen_artifacts(txt_folder, xml_folder)
        print(f"[OK] Uklonjeno GEN artefakata: {removed}")

    # Check initial status
    status = check_sync_status(pdf_folder, txt_folder, xml_folder)
    print_status(status)
    
    if check_only:
        return status["fully_synced"]
    
    if status["fully_synced"] and not force:
        return True
    
    # Step 1: PDF → TXT
    if status["missing_txt"] or force:
        sync_pdf_to_txt(pdf_folder, txt_folder, force=force)
    
    # Step 2: TXT → XML
    # Re-check status after PDF extraction
    status = check_sync_status(pdf_folder, txt_folder, xml_folder)
    
    if status["missing_xml"] or force:
        sync_txt_to_xml(
            txt_folder, xml_folder,
            provider=provider,
            model=model,
            force=force,
            no_llm=no_llm
        )
    
    # Final status
    final_status = check_sync_status(pdf_folder, txt_folder, xml_folder)
    print_status(final_status)
    
    return final_status["fully_synced"]


def main():
    parser = argparse.ArgumentParser(
        description="Sinhronizacija presuda: PDF → TXT → XML"
    )
    
    parser.add_argument(
        "--check",
        action="store_true",
        help="Samo proveri status, ne pokreći sinhronizaciju"
    )
    
    parser.add_argument(
        "--force",
        action="store_true",
        help="Ponovo obradi sve fajlove"
    )
    
    parser.add_argument(
        "--no-llm",
        action="store_true",
        help="Preskoči LLM anotaciju (samo regex)"
    )

    parser.add_argument(
        "--cleanup-gen",
        action="store_true",
        help="Obriši GEN* TXT/XML artefakte prije sinhronizacije"
    )
    
    parser.add_argument(
        "--provider",
        type=str,
        default="openai",
        choices=["openai", "openrouter", "github"],
        help="LLM provider"
    )
    
    parser.add_argument(
        "--model",
        type=str,
        default=None,
        help="LLM model (default: gpt-4o-mini)"
    )
    
    parser.add_argument(
        "--pdf-folder",
        type=str,
        default=str(PDF_FOLDER),
        help="Folder sa PDF presudama"
    )
    
    parser.add_argument(
        "--txt-folder",
        type=str,
        default=str(TXT_FOLDER),
        help="Folder za TXT presude"
    )
    
    parser.add_argument(
        "--xml-folder",
        type=str,
        default=str(XML_FOLDER),
        help="Folder za XML presude"
    )
    
    args = parser.parse_args()
    
    success = sync_all(
        pdf_folder=Path(args.pdf_folder),
        txt_folder=Path(args.txt_folder),
        xml_folder=Path(args.xml_folder),
        provider=args.provider,
        model=args.model,
        force=args.force,
        no_llm=args.no_llm,
        cleanup_gen=args.cleanup_gen,
        check_only=args.check
    )
    
    sys.exit(0 if success else 1)


if __name__ == "__main__":
    main()
