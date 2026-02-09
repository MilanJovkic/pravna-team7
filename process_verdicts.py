"""CLI entry point for verdict annotation pipeline."""
import argparse
import sys
from pathlib import Path

from src.verdict_annotation.verdict_pipeline import VerdictAnnotationPipeline

DEFAULT_PDF_FOLDER = Path("data/verdicts_pdf")
DEFAULT_XML_OUTPUT = Path("data/verdicts_xml")


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Anotacija sudskih presuda u Akoma Ntoso format (Zadatak 2)"
    )

    parser.add_argument(
        "--pdf-folder",
        type=str,
        default=str(DEFAULT_PDF_FOLDER),
        help="Folder sa PDF presudama (default: data/verdicts_pdf)"
    )

    parser.add_argument(
        "--output-dir",
        type=str,
        default=str(DEFAULT_XML_OUTPUT),
        help="Folder za XML output (default: data/verdicts_xml)"
    )

    parser.add_argument(
        "--output-json",
        type=str,
        default=None,
        help="JSON fajl sa anotacijama (default: auto)"
    )

    parser.add_argument(
        "--provider",
        type=str,
        default="openai",
        choices=["github", "openrouter", "openai"],
        help="LLM provider (github, openrouter ili openai)"
    )

    parser.add_argument(
        "--model",
        type=str,
        default="gpt-5-nano",
        help="Naziv LLM modela"
    )

    parser.add_argument(
        "--limit",
        type=int,
        default=None,
        help="Limit broja presuda za testiranje"
    )

    args = parser.parse_args()

    pdf_folder = Path(args.pdf_folder)
    if not pdf_folder.exists():
        print(f"✗ Folder '{pdf_folder}' ne postoji.")
        sys.exit(1)

    # Check for PDFs
    pdf_files = list(pdf_folder.glob("*.pdf"))
    if not pdf_files:
        print(f"✗ Nema PDF fajlova u {pdf_folder}")
        sys.exit(1)

    print(f"Pronađeno {len(pdf_files)} PDF fajlova.")

    # Check .env
    env_path = Path(".env")
    if not env_path.exists():
        print("⚠ .env fajl nije pronađen. Dodaj GITHUB_TOKEN, OPENROUTER_API_KEY ili OPENAI_API_KEY.")
        sys.exit(1)

    pipeline = VerdictAnnotationPipeline(
        pdf_folder=str(pdf_folder),
        output_xml_dir=args.output_dir,
        output_json=args.output_json,
        model=args.model,
        provider=args.provider,
        limit=args.limit
    )

    success = pipeline.run()
    sys.exit(0 if success else 1)


if __name__ == "__main__":
    main()
