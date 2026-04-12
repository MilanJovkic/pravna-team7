"""CLI entry point for verdict annotation pipeline."""
import argparse
import sys
from pathlib import Path

from src.verdict_annotation.verdict_pipeline import VerdictAnnotationPipeline

DEFAULT_TXT_FOLDER = Path("data/verdicts_txt")
DEFAULT_XML_OUTPUT = Path("data/verdicts_xml")


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Anotacija sudskih presuda u Akoma Ntoso format (Zadatak 2)"
    )

    parser.add_argument(
        "--txt-folder",
        type=str,
        default=str(DEFAULT_TXT_FOLDER),
        help="Folder sa TXT presudama (default: data/verdicts_txt)"
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
        "--no-llm",
        action="store_true",
        help="Isključi LLM anotaciju (samo regex ekstrakcija)"
    )

    parser.add_argument(
        "--model",
        type=str,
        default="gpt-4o-mini",
        help="Naziv LLM modela"
    )

    parser.add_argument(
        "--limit",
        type=int,
        default=None,
        help="Limit broja presuda za testiranje"
    )

    parser.add_argument(
        "--overrides",
        type=str,
        default=None,
        help="JSON fajl za rucne korekcije metadata/faktickog stanja"
    )

    args = parser.parse_args()

    txt_folder = Path(args.txt_folder)
    if not txt_folder.exists():
        print(f"✗ Folder '{txt_folder}' ne postoji.")
        sys.exit(1)

    # Check for TXT files
    txt_files = list(txt_folder.glob("*.txt"))
    if not txt_files:
        print(f"✗ Nema TXT fajlova u {txt_folder}")
        sys.exit(1)

    print(f"Pronađeno {len(txt_files)} TXT fajlova.")

    if not args.no_llm:
        # Check .env
        env_path = Path(".env")
        if not env_path.exists():
            print("⚠ .env fajl nije pronađen. Dodaj GITHUB_TOKEN, OPENROUTER_API_KEY ili OPENAI_API_KEY.")
            sys.exit(1)

    pipeline = VerdictAnnotationPipeline(
        txt_folder=str(txt_folder),
        output_xml_dir=args.output_dir,
        output_json=args.output_json,
        model=args.model,
        provider=args.provider,
        limit=args.limit,
        overrides_file=args.overrides,
        enable_llm=not args.no_llm,
        strict_mode=True,
    )

    success = pipeline.run()
    sys.exit(0 if success else 1)


if __name__ == "__main__":
    main()
