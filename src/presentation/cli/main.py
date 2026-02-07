"""
CLI interface for legal document annotation.

Entry point for command-line interface.
"""

import argparse
import sys
from pathlib import Path

from ...config.app_config import ApplicationConfig
from ...application.container import DependencyContainer


class CLI:
    """
    Command-line interface for legal document annotation.
    
    Handles argument parsing and use case execution.
    """
    
    def __init__(self):
        """Initialize CLI."""
        self.parser = self._create_parser()
    
    def _create_parser(self) -> argparse.ArgumentParser:
        """Create argument parser."""
        parser = argparse.ArgumentParser(
            description="Automatska AKOMA Ntoso anotacija pravnih tekstova pomoću LLM-a",
            formatter_class=argparse.RawDescriptionHelpFormatter,
            epilog="""
Primeri:
  %(prog)s --input zakon.txt --output output.xml
  %(prog)s --input zakon.txt --output output.xml --limit 10
  %(prog)s --input zakon.txt --output output.xml --provider openrouter --model gpt-4o
            """
        )
        
        parser.add_argument(
            "--input",
            type=str,
            default="zakon.txt",
            help="Putanja do ulaznog fajla sa tekstom zakona (default: zakon.txt)"
        )
        
        parser.add_argument(
            "--output",
            type=str,
            default="output_annotated.xml",
            help="Putanja do izlaznog AKOMA XML fajla (default: output_annotated.xml)"
        )
        
        parser.add_argument(
            "--provider",
            type=str,
            default="github",
            choices=["github", "openrouter"],
            help="LLM provider (default: github)"
        )
        
        parser.add_argument(
            "--model",
            type=str,
            default="gpt-4o",
            help="LLM model (default: gpt-4o)"
        )
        
        parser.add_argument(
            "--limit",
            type=int,
            default=None,
            help="Procesuiraj samo prvih N članaka (za testiranje)"
        )
        
        return parser
    
    def run(self, args=None) -> int:
        """
        Run CLI application.
        
        Args:
            args: Command-line arguments (None = use sys.argv)
            
        Returns:
            Exit code (0 = success, 1 = error)
        """
        # Parse arguments
        parsed_args = self.parser.parse_args(args)
        
        # Validate input file
        if not Path(parsed_args.input).exists():
            print(f"✗ Greška: Fajl '{parsed_args.input}' ne postoji.")
            return 1
        
        # Create configuration
        config = self._create_config(parsed_args)
        
        # Validate configuration
        try:
            config.validate()
        except ValueError as e:
            print(f"✗ Greška u konfiguraciji: {e}")
            self._create_env_template()
            return 1
        
        # Create dependency container
        container = DependencyContainer(config)
        
        # Get use case
        use_case = container.get_annotate_document_use_case()
        
        # Execute
        try:
            result = use_case.execute(
                input_file=parsed_args.input,
                output_file=parsed_args.output,
                article_limit=parsed_args.limit
            )
            
            return 0 if result["success"] else 1
            
        except KeyboardInterrupt:
            print("\n\n⚠ Pipeline prekinut od strane korisnika (Ctrl+C)")
            return 1
            
        except Exception as e:
            print(f"\n✗ KRITIČNA GREŠKA: {e}")
            import traceback
            traceback.print_exc()
            return 1
    
    def _create_config(self, args) -> ApplicationConfig:
        """
        Create configuration from CLI arguments and environment.
        
        Args:
            args: Parsed CLI arguments
            
        Returns:
            ApplicationConfig instance
        """
        config = ApplicationConfig.from_env()
        
        # Override with CLI arguments
        if args.provider:
            config.llm.provider = args.provider
        if args.model:
            config.llm.model = args.model
        
        return config
    
    def _create_env_template(self) -> None:
        """Create .env template file if it doesn't exist."""
        env_path = Path(".env")
        
        if env_path.exists():
            print("\n  .env fajl već postoji. Proverite da li ste dodali API token.")
            return
        
        with open(env_path, "w", encoding="utf-8") as f:
            f.write("# LLM Provider Configuration\n")
            f.write("LLM_PROVIDER=github\n")
            f.write("LLM_MODEL=gpt-4o\n")
            f.write("\n")
            f.write("# API Tokens\n")
            f.write("GITHUB_TOKEN=your_github_token_here\n")
            f.write("OPENROUTER_API_KEY=your_openrouter_key_here\n")
            f.write("\n")
            f.write("# LLM Settings\n")
            f.write("LLM_MAX_REQUESTS_PER_MINUTE=10\n")
            f.write("LLM_MAX_RETRIES=3\n")
            f.write("\n")
            f.write("# Law Metadata\n")
            f.write("LAW_NAME=Krivični zakonik Crne Gore\n")
            f.write("COUNTRY_CODE=me\n")
            f.write("LAW_YEAR=2024\n")
        
        print(f"\n  ✓ .env fajl kreiran sa template-om.")
        print("\n  Za GitHub Models: dodaj GITHUB_TOKEN")
        print("  Za OpenRouter: dodaj OPENROUTER_API_KEY")
        print("\n  Pokreni ponovo nakon dodavanja odgovarajućeg tokena.")


def main():
    """Entry point for CLI application."""
    cli = CLI()
    sys.exit(cli.run())


if __name__ == "__main__":
    main()
