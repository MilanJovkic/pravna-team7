"""Shared PostgreSQL connection configuration helpers."""
from __future__ import annotations

import os


def get_db_config() -> dict:
    """Return PostgreSQL connection settings from environment variables."""
    return {
        "host": os.getenv("DB_HOST") or os.getenv("POSTGRES_HOST", "127.0.0.1"),
        "port": int(os.getenv("DB_PORT") or os.getenv("POSTGRES_PORT", "5432")),
        "database": os.getenv("DB_NAME") or os.getenv("POSTGRES_DB", "pravna_cbr"),
        "user": os.getenv("DB_USER") or os.getenv("POSTGRES_USER", "pravna_user"),
        "password": os.getenv("DB_PASSWORD") or os.getenv("POSTGRES_PASSWORD", "pravna_pass"),
    }
