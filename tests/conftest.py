"""Shared pytest configuration: auto-load .env before tests run."""
from pathlib import Path

try:
    from dotenv import load_dotenv

    load_dotenv(dotenv_path=Path(__file__).parent.parent / ".env")
except ImportError:
    pass
