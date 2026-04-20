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
        "OPENAI_API_KEY=your_openai_key_here\n"
    )

    print("⚠ .env fajl nije pronađen. Kreirao sam .env sa placeholder vrednostima.")
    print("  Dodaj svoj OpenAI, GitHub ili OpenRouter token i pokreni ponovo.")
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
        default="output/annotated_law.xml",
        help="Putanja do izlaza u AKOMA Ntoso format (default: output/annotated_law.xml)"
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
        default="openai",
        choices=["github", "openrouter", "openai"],
        help="LLM provider (github, openrouter ili openai)"
    )

    parser.add_argument(
        "--no-llm",
        action="store_true",
        help="Isključi LLM anotaciju (samo strukturno parsiranje)"
    )

    parser.add_argument(
        "--model",
        type=str,
        default="gpt-4o-mini",
        help="Naziv LLM modela (npr. gpt-4o-mini ili tngtech/deepseek-... )"
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

    if not args.no_llm:
        ensure_env_file()

    output_path = Path(args.output)
    if output_path.parent == Path("."):
        output_path = Path("output") / output_path.name

    output_json = args.output_json
    if output_json:
        output_json_path = Path(output_json)
        if output_json_path.parent == Path("."):
            output_json = str(Path("output") / output_json_path.name)

    pipeline = AnnotationPipeline(
        input_file=str(input_path),
        output_xml=str(output_path),
        output_json=output_json,
        model=args.model,
        provider=args.provider,
        article_limit=args.limit,
        enable_llm=not args.no_llm
    )

    success = pipeline.run()
    sys.exit(0 if success else 1)


if __name__ == "__main__":
    main()
