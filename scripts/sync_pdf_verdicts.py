"""Synchronize verdict corpus from PDF files into TXT/XML artifacts.

Workflow:
1. Optionally remove generated GEN-* artifacts.
2. Extract text from every PDF in data/verdicts_pdf into data/verdicts_txt.
3. Optionally prune stale XML artifacts not backed by TXT files.
4. Run full verdict annotation pipeline over TXT corpus.
5. Prune annotations/overrides to active XML case IDs.
"""
from __future__ import annotations

import argparse
import json
from pathlib import Path
import sys


ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from src.verdict_annotation.pdf_extractor import PDFExtractor
from src.verdict_annotation.verdict_pipeline import VerdictAnnotationPipeline

PDF_DIR = ROOT / "data" / "verdicts_pdf"
TXT_DIR = ROOT / "data" / "verdicts_txt"
XML_DIR = ROOT / "data" / "verdicts_xml"
ANNOTATIONS_PATH = XML_DIR / "verdicts_annotations.json"
OVERRIDES_PATH = XML_DIR / "verdicts_overrides.json"


def remove_gen_artifacts() -> None:
    patterns = [
        ROOT / "data" / "verdicts_xml" / "GEN-*.xml",
        ROOT / "data" / "verdicts_xml" / "GEN*.xml",
        ROOT / "data" / "verdicts_txt" / "GEN-*.txt",
        ROOT / "data" / "verdicts_txt" / "GEN*.txt",
    ]

    removed = 0
    for pattern in patterns:
        for path in pattern.parent.glob(pattern.name):
            path.unlink(missing_ok=True)
            removed += 1

    print(f"Removed GEN artifacts: {removed}")


def extract_all_pdfs_to_txt(overwrite: bool) -> tuple[int, int]:
    if not PDF_DIR.exists():
        raise FileNotFoundError(f"PDF directory not found: {PDF_DIR}")

    TXT_DIR.mkdir(parents=True, exist_ok=True)

    extractor = PDFExtractor()
    created = 0
    skipped = 0

    for pdf_path in sorted(PDF_DIR.glob("*.pdf")):
        txt_path = TXT_DIR / f"{pdf_path.stem}.txt"
        if txt_path.exists() and not overwrite:
            skipped += 1
            continue

        text = extractor.extract_text(pdf_path)
        txt_path.write_text(text, encoding="utf-8")
        created += 1

    return created, skipped


def prune_stale_xml() -> int:
    XML_DIR.mkdir(parents=True, exist_ok=True)
    txt_stems = {path.stem for path in TXT_DIR.glob("*.txt")}
    removed = 0

    for xml_path in XML_DIR.glob("*.xml"):
        if xml_path.stem not in txt_stems:
            xml_path.unlink(missing_ok=True)
            removed += 1

    return removed


def _load_json(path: Path) -> dict:
    if not path.exists():
        return {}
    with open(path, "r", encoding="utf-8") as handle:
        return json.load(handle)


def _save_json(path: Path, payload: dict) -> None:
    with open(path, "w", encoding="utf-8") as handle:
        json.dump(payload, handle, ensure_ascii=False, indent=2)


def prune_metadata_json_to_xml_set() -> None:
    xml_stems = {path.stem for path in XML_DIR.glob("*.xml")}

    annotations = _load_json(ANNOTATIONS_PATH)
    pruned_annotations = {k: v for k, v in annotations.items() if k in xml_stems}
    if pruned_annotations != annotations:
        _save_json(ANNOTATIONS_PATH, pruned_annotations)
        print(f"Pruned annotations: {len(annotations) - len(pruned_annotations)} stale entries removed")

    overrides = _load_json(OVERRIDES_PATH)
    pruned_overrides = {k: v for k, v in overrides.items() if k in xml_stems}
    if pruned_overrides != overrides:
        _save_json(OVERRIDES_PATH, pruned_overrides)
        print(f"Pruned overrides: {len(overrides) - len(pruned_overrides)} stale entries removed")


def run_pipeline(provider: str, model: str, no_llm: bool) -> None:
    pipeline = VerdictAnnotationPipeline(
        txt_folder=str(TXT_DIR),
        output_xml_dir=str(XML_DIR),
        provider=provider,
        model=model,
        enable_llm=not no_llm,
        strict_mode=True,
    )
    ok = pipeline.run()
    if not ok:
        raise RuntimeError("Verdict pipeline failed")


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Sync PDF verdict corpus into TXT/XML artifacts")
    parser.add_argument("--cleanup-gen", action="store_true", help="Remove GEN-* artifacts before sync")
    parser.add_argument("--overwrite-txt", action="store_true", help="Rebuild TXT files even if they already exist")
    parser.add_argument("--prune-stale-xml", action="store_true", help="Remove XML files without matching TXT source")
    parser.add_argument("--provider", default="openai", choices=["github", "openrouter", "openai"])
    parser.add_argument("--model", default="gpt-4o-mini")
    parser.add_argument("--no-llm", action="store_true", help="Run regex-only annotations without LLM")
    return parser.parse_args()


def main() -> int:
    args = parse_args()

    if args.cleanup_gen:
        remove_gen_artifacts()

    created, skipped = extract_all_pdfs_to_txt(overwrite=args.overwrite_txt)
    print(f"TXT sync completed: created_or_updated={created}, skipped_existing={skipped}")

    if args.prune_stale_xml:
        removed = prune_stale_xml()
        print(f"Stale XML removed: {removed}")

    run_pipeline(
        provider=args.provider,
        model=args.model,
        no_llm=args.no_llm,
    )
    prune_metadata_json_to_xml_set()
    print("Corpus sync finished successfully")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
