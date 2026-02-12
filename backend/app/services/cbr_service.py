"""CBR service for querying jColibri."""
from __future__ import annotations

import json
from pathlib import Path
import subprocess

from backend.app.models.schemas import CaseFacts, CbrResult, CbrMatch


ROOT = Path(__file__).resolve().parents[3]
CBR_DIR = ROOT / "cbr-jcolibri"
JAR_PATH = CBR_DIR / "target" / "pravna-cbr-0.0.1-SNAPSHOT.jar"
CP_PATH = CBR_DIR / "cp.txt"


class CbrService:
    """Service that executes jColibri and parses JSON output."""

    def query(self, facts: CaseFacts, top_k: int) -> CbrResult:
        if not JAR_PATH.exists():
            raise FileNotFoundError(f"CBR jar not found: {JAR_PATH}")
        if not CP_PATH.exists():
            raise FileNotFoundError(f"CBR classpath file not found: {CP_PATH}")

        classpath = f"{JAR_PATH};{CP_PATH.read_text(encoding='utf-8').strip()}"
        args = [
            "java",
            "-cp",
            classpath,
            "cbr.CbrApplication",
            "--json",
            f"top_k={top_k}",
        ]

        self._append_arg(args, "injury_type", facts.injury_type)
        self._append_arg(args, "location", facts.location)
        self._append_arg(args, "weapon", facts.weapon)
        self._append_arg(args, "weapon_used", self._bool_str(facts.weapon_used))
        self._append_arg(args, "severe_consequence", self._bool_str(facts.severe_consequence))
        self._append_arg(args, "death_result", self._bool_str(facts.death_result))
        self._append_arg(args, "negligence", self._bool_str(facts.negligence))
        self._append_arg(args, "provocation", self._bool_str(facts.provocation))
        self._append_arg(args, "fight_participation", self._bool_str(facts.fight_participation))
        self._append_arg(args, "fight_consequence", facts.fight_consequence)
        self._append_arg(args, "left_without_help", self._bool_str(facts.left_without_help))

        result = subprocess.run(
            args,
            cwd=str(CBR_DIR),
            check=True,
            capture_output=True,
            text=True,
            encoding="utf-8",
            errors="replace",
            timeout=60,
        )

        json_text = self._extract_json(result.stdout)
        payload = json.loads(json_text)
        matches = [
            CbrMatch(
                case_number=item.get("case_number"),
                similarity=float(item.get("similarity", 0.0)),
                outcome=item.get("outcome"),
            )
            for item in payload.get("matches", [])
        ]

        return CbrResult(matches=matches)

    def _append_arg(self, args: list[str], key: str, value: str | None) -> None:
        if value is None:
            return
        if isinstance(value, str) and not value.strip():
            return
        args.append(f"{key}={value}")

    def _bool_str(self, value: bool | None) -> str | None:
        if value is None:
            return None
        return "true" if value else "false"

    def _extract_json(self, output: str) -> str:
        start = output.find("{")
        end = output.rfind("}")
        if start == -1 or end == -1 or end <= start:
            raise ValueError("CBR output does not contain JSON")
        return output[start : end + 1]
