from __future__ import annotations

import ast
from pathlib import Path


class ImportBoundaryViolation(AssertionError):
    pass


def _iter_python_files(root: Path):
    for path in root.rglob("*.py"):
        if path.name == "__init__.py":
            continue
        yield path


def _collect_import_roots(file_path: Path) -> set[str]:
    source = file_path.read_text(encoding="utf-8")
    tree = ast.parse(source, filename=str(file_path))
    roots: set[str] = set()

    for node in ast.walk(tree):
        if isinstance(node, ast.Import):
            for alias in node.names:
                roots.add(alias.name.split(".")[0])
        elif isinstance(node, ast.ImportFrom):
            if node.module:
                roots.add(node.module.split(".")[0])

    return roots


def _assert_no_forbidden_imports(scan_root: Path, forbidden_roots: set[str]) -> None:
    violations: list[str] = []
    for file_path in _iter_python_files(scan_root):
        roots = _collect_import_roots(file_path)
        illegal = sorted(roots & forbidden_roots)
        if illegal:
            violations.append(f"{file_path.as_posix()}: {', '.join(illegal)}")

    if violations:
        raise ImportBoundaryViolation("\n".join(violations))


def _assert_no_package_import(scan_root: Path, forbidden_pkg_prefix: str) -> None:
    violations: list[str] = []
    for file_path in _iter_python_files(scan_root):
        source = file_path.read_text(encoding="utf-8")
        tree = ast.parse(source, filename=str(file_path))

        for node in ast.walk(tree):
            if isinstance(node, ast.Import):
                for alias in node.names:
                    if alias.name.startswith(forbidden_pkg_prefix):
                        violations.append(f"{file_path.as_posix()}: import {alias.name}")
            elif isinstance(node, ast.ImportFrom):
                if node.module and node.module.startswith(forbidden_pkg_prefix):
                    violations.append(f"{file_path.as_posix()}: from {node.module} import ...")

    if violations:
        raise ImportBoundaryViolation("\n".join(violations))


def test_domain_layer_has_no_framework_io_imports() -> None:
    repo_root = Path(__file__).resolve().parents[2]
    domain_root = repo_root / "backend" / "app" / "domain"

    forbidden = {"fastapi", "requests", "psycopg2", "subprocess"}
    _assert_no_forbidden_imports(domain_root, forbidden)


def test_api_layer_does_not_import_infrastructure_directly() -> None:
    repo_root = Path(__file__).resolve().parents[2]
    api_root = repo_root / "backend" / "app" / "api"

    _assert_no_package_import(api_root, "backend.app.infrastructure")
