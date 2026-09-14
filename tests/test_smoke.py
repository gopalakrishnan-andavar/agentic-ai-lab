"""Proves the src layout is importable and pytest is wired up.

If this fails with ModuleNotFoundError, the answer is in foundations-refresher.md
section F: `python foo.py` and `python -m package.foo` do not resolve the same way.
"""

import agentic_ai_lab


def test_package_imports() -> None:
    assert agentic_ai_lab.__all__ == []
