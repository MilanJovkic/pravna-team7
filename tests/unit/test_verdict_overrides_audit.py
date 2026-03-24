import json
import unittest
from pathlib import Path

from backend.app.services.verdict_service import VerdictService


class TestVerdictOverridesAudit(unittest.TestCase):
    def test_override_history_records_changes(self):
        service = VerdictService()
        case_id = "TEST-AUDIT-CASE"

        service.update_overrides(case_id, {"summary": "stara"})
        service.update_overrides(case_id, {"summary": "nova"})

        history = service.get_override_history(case_id)
        self.assertGreaterEqual(len(history), 2)
        self.assertEqual("summary", history[-1]["field"])
        self.assertEqual("stara", history[-1]["old_value"])
        self.assertEqual("nova", history[-1]["new_value"])

        # Cleanup only the test case from persistent files
        overrides_file = Path(service.overrides_file)
        if overrides_file.exists():
            payload = json.loads(overrides_file.read_text(encoding="utf-8"))
            payload.pop(case_id, None)
            overrides_file.write_text(json.dumps(payload, ensure_ascii=False, indent=2), encoding="utf-8")

        audit_file = Path(service.overrides_audit_file)
        if audit_file.exists():
            payload = json.loads(audit_file.read_text(encoding="utf-8"))
            payload.pop(case_id, None)
            audit_file.write_text(json.dumps(payload, ensure_ascii=False, indent=2), encoding="utf-8")


if __name__ == "__main__":
    unittest.main()
