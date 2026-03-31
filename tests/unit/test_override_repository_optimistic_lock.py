import unittest
from pathlib import Path

from backend.app.infrastructure.persistence.filesystem.override_repository_fs import (
    FileSystemOverrideRepository,
)
from backend.app.ports.outbound.override_repository import OptimisticLockConflictError


class TestOverrideRepositoryOptimisticLock(unittest.TestCase):
    def test_save_with_stale_revision_raises_conflict(self):
        repo = FileSystemOverrideRepository()

        payload, revision = repo.load_overrides()
        payload["TEST-CONFLICT"] = {"summary": "v1"}
        _new_revision = repo.save_overrides(payload, expected_revision=revision)

        with self.assertRaises(OptimisticLockConflictError):
            repo.save_overrides({"TEST-CONFLICT": {"summary": "v2"}}, expected_revision=revision)

        # Cleanup test key
        current, current_revision = repo.load_overrides()
        current.pop("TEST-CONFLICT", None)
        repo.save_overrides(current, expected_revision=current_revision)

    def test_atomic_write_persists_json_payload(self):
        repo = FileSystemOverrideRepository()
        payload, revision = repo.load_overrides()

        payload["TEST-ATOMIC"] = {"decision": "test"}
        repo.save_overrides(payload, expected_revision=revision)

        reloaded, current_revision = repo.load_overrides()
        self.assertEqual("test", reloaded["TEST-ATOMIC"]["decision"])

        # Cleanup test key
        reloaded.pop("TEST-ATOMIC", None)
        repo.save_overrides(reloaded, expected_revision=current_revision)

        file_path = Path(repo.overrides_file_path)
        self.assertTrue(file_path.exists())


if __name__ == "__main__":
    unittest.main()
