"""CLI entry point for the Akoma annotation pipeline."""
import argparse
import sys
from pathlib import Path

from src.akoma_annotation.pipeline import AnnotationPipeline

DEFAULT_LAW_PATH = Path("data/zakon.txt")


def ensure_env_file() -> None:
    env_path = Path(".env")
    if env_path.exists():
        return

    env_path.write_text(
        "# API tokens for annotation providers\n"
        "GITHUB_TOKEN=your_github_token_here\n"
        "OPENROUTER_API_KEY=your_openrouter_key_here\n"
    )

    print("⚠ .env fajl nije pronađen. Kreirao sam .env sa placeholder vrednostima.")
    print("  Dodaj svoj GitHub ili OpenRouter token i pokreni ponovo.")
    sys.exit(1)


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Automatska AKOMA/Ntoso anotacija zakona pomoću LLM-a"
    )

    parser.add_argument(
        "--input",
        type=str,
        default=str(DEFAULT_LAW_PATH),
        help="Putanja do tekstualnog fajla zakona (default: data/zakon.txt)"
    )

    parser.add_argument(
        "--output",
        type=str,
        default="output_annotated.xml",
        help="Putanja do izlaza u AKOMA Ntoso format (default: output_annotated.xml)"
    )

    parser.add_argument(
        "--output-json",
        type=str,
        default=None,
        help="Putanja do JSON fajla sa anotacijama (default: auto)"
    )

    parser.add_argument(
        "--provider",
        type=str,
        default="github",
        choices=["github", "openrouter"],
        help="LLM provider (github ili openrouter)"
    )

    parser.add_argument(
        "--model",
        type=str,
        default="gpt-4o",
        help="Naziv LLM modela (npr. gpt-4o ili tngtech/deepseek-... )"
    )

    parser.add_argument(
        "--limit",
        type=int,
        default=None,
        help="Limit broja članaka za brzo testiranje"
    )

    args = parser.parse_args()

    input_path = Path(args.input)
    if not input_path.exists():
        print(f"✗ Fajl '{input_path}' ne postoji.")
        if input_path == DEFAULT_LAW_PATH:
            print("  Sadržaj se nalazi u data/zakon.txt.")
        sys.exit(1)

    ensure_env_file()

    pipeline = AnnotationPipeline(
        input_file=str(input_path),
        output_xml=args.output,
        output_json=args.output_json,
        model=args.model,
        provider=args.provider,
        article_limit=args.limit
    )

    success = pipeline.run()
    sys.exit(0 if success else 1)


if __name__ == "__main__":
    main()
