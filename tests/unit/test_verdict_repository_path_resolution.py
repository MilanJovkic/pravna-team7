from pathlib import Path

from backend.app.infrastructure.persistence.filesystem.verdict_repository_fs import (
    FileSystemVerdictRepository,
)


def test_resolve_project_root_finds_workspace_root() -> None:
    repo_file = Path(__file__).resolve().parents[2] / "backend" / "app" / "infrastructure" / "persistence" / "filesystem" / "verdict_repository_fs.py"

    root = FileSystemVerdictRepository._resolve_project_root(repo_file)

    assert (root / "backend").exists()
    assert (root / "data" / "verdicts_xml").exists()
