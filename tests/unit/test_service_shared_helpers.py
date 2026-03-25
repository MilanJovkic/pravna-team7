import os
import unittest
from unittest.mock import patch

from backend.app.services.cbr_normalization import bool_to_text, normalize_ascii
from backend.app.services.db_config import get_db_config


class TestServiceSharedHelpers(unittest.TestCase):
    def test_normalize_ascii_transliterates_serbian_chars(self):
        self.assertEqual("Djurdjevic", normalize_ascii("Đurđević"))

    def test_bool_to_text_serialization(self):
        self.assertEqual("true", bool_to_text(True))
        self.assertEqual("false", bool_to_text(False))
        self.assertIsNone(bool_to_text(None))

    def test_get_db_config_prefers_db_vars_over_postgres_vars(self):
        env = {
            "DB_HOST": "db-host",
            "DB_PORT": "6543",
            "DB_NAME": "db-name",
            "DB_USER": "db-user",
            "DB_PASSWORD": "db-pass",
            "POSTGRES_HOST": "pg-host",
            "POSTGRES_PORT": "5432",
            "POSTGRES_DB": "pg-name",
            "POSTGRES_USER": "pg-user",
            "POSTGRES_PASSWORD": "pg-pass",
        }
        with patch.dict(os.environ, env, clear=True):
            config = get_db_config()

        self.assertEqual("db-host", config["host"])
        self.assertEqual(6543, config["port"])
        self.assertEqual("db-name", config["database"])
        self.assertEqual("db-user", config["user"])
        self.assertEqual("db-pass", config["password"])


if __name__ == "__main__":
    unittest.main()
