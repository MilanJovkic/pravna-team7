import json
import unittest
from pathlib import Path


class TestPhase0Governance(unittest.TestCase):
    def setUp(self):
        self.repo_root = Path(__file__).resolve().parents[1]
        self.traceability_file = self.repo_root / "docs" / "spec_traceability.json"
        self.dod_file = self.repo_root / "docs" / "phase0_definition_of_done.md"
        self.matrix_file = self.repo_root / "docs" / "spec_traceability_matrix.md"

    def test_governance_documents_exist(self):
        self.assertTrue(self.traceability_file.exists(), "Missing docs/spec_traceability.json")
        self.assertTrue(self.dod_file.exists(), "Missing docs/phase0_definition_of_done.md")
        self.assertTrue(self.matrix_file.exists(), "Missing docs/spec_traceability_matrix.md")

    def test_traceability_has_all_spec_tasks(self):
        with self.traceability_file.open("r", encoding="utf-8") as fh:
            data = json.load(fh)

        self.assertIn("tasks", data)
        self.assertEqual(len(data["tasks"]), 9, "Traceability must include exactly 9 tasks")

        task_ids = {item.get("task") for item in data["tasks"]}
        self.assertEqual(task_ids, set(range(1, 10)), "Traceability must cover tasks 1-9")

    def test_each_task_has_required_mappings(self):
        with self.traceability_file.open("r", encoding="utf-8") as fh:
            data = json.load(fh)

        required_keys = {
            "task",
            "title",
            "acceptance_criteria",
            "modules",
            "endpoint_bindings",
            "tests",
            "artifacts",
        }

        for item in data["tasks"]:
            missing = required_keys - set(item.keys())
            self.assertFalse(missing, f"Task {item.get('task')} missing keys: {sorted(missing)}")

            self.assertGreaterEqual(len(item["acceptance_criteria"]), 3)
            self.assertGreaterEqual(len(item["modules"]), 1)
            self.assertGreaterEqual(len(item["endpoint_bindings"]), 1)
            self.assertGreaterEqual(len(item["tests"]), 1)
            self.assertGreaterEqual(len(item["artifacts"]), 1)

    def test_traceability_paths_resolve(self):
        with self.traceability_file.open("r", encoding="utf-8") as fh:
            data = json.load(fh)

        for item in data["tasks"]:
            task = item["task"]

            for module_path in item["modules"]:
                resolved = self.repo_root / module_path
                self.assertTrue(
                    resolved.exists(),
                    f"Task {task} has missing module path: {module_path}",
                )

            for test_path in item["tests"]:
                resolved = self.repo_root / test_path
                self.assertTrue(
                    resolved.exists(),
                    f"Task {task} has missing test path: {test_path}",
                )

            for binding in item["endpoint_bindings"]:
                self.assertIn("endpoint", binding, f"Task {task} endpoint binding missing endpoint")
                self.assertIn("implementation", binding, f"Task {task} endpoint binding missing implementation")
                self.assertTrue(binding["endpoint"].strip(), f"Task {task} endpoint must not be empty")

                impl = self.repo_root / binding["implementation"]
                self.assertTrue(
                    impl.exists(),
                    f"Task {task} endpoint implementation path missing: {binding['implementation']}",
                )

            for artifact in item["artifacts"]:
                self.assertIn("path", artifact, f"Task {task} artifact missing path")
                self.assertIn("type", artifact, f"Task {task} artifact missing type")

                artifact_path = self.repo_root / artifact["path"]
                artifact_type = artifact["type"]

                if artifact_type == "file":
                    self.assertTrue(
                        artifact_path.is_file(),
                        f"Task {task} expected file artifact missing: {artifact['path']}",
                    )
                elif artifact_type == "dir":
                    self.assertTrue(
                        artifact_path.is_dir(),
                        f"Task {task} expected dir artifact missing: {artifact['path']}",
                    )
                else:
                    self.fail(f"Task {task} has unsupported artifact type: {artifact_type}")


if __name__ == "__main__":
    unittest.main()
