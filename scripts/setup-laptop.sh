#!/usr/bin/env bash
# setup-laptop.sh — Environment bootstrap for the agentic-ai-lab 10-day plan.
# Target: personal Ubuntu laptop (Dell Inspiron 5570). Safe to re-run.
#
#   bash scripts/setup-laptop.sh
#
# The project scaffold (pyproject.toml, src/, tests/, .env.example) is already
# in the repo. This script only does the parts that need a shell: installing
# uv and Python, fetching the .gitignore template, and syncing the venv.

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_DIR"

section() { echo; echo "==> $1"; }

# ---------------------------------------------------------------------------
# 0. Git identity — the plan flags this because the repo is public.
# ---------------------------------------------------------------------------
section "Git identity on this machine"
echo "user.name  = $(git config user.name || echo '(not set)')"
echo "user.email = $(git config user.email || echo '(not set)')"

# ---------------------------------------------------------------------------
# 1. Base packages
# ---------------------------------------------------------------------------
section "Installing base build tools (apt)"
sudo apt update
sudo apt install -y build-essential curl git ca-certificates

# ---------------------------------------------------------------------------
# 2. uv — the plan says uv, not pip + venv
# ---------------------------------------------------------------------------
section "Installing uv"
if command -v uv >/dev/null 2>&1; then
    echo "Already installed: $(uv --version)"
else
    curl -LsSf https://astral.sh/uv/install.sh | sh
    export PATH="$HOME/.local/bin:$PATH"
    if ! grep -q '.local/bin' "$HOME/.bashrc" 2>/dev/null; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
        echo "Added ~/.local/bin to PATH in ~/.bashrc"
    fi
fi

section "Installing Python 3.12 via uv"
uv python install 3.12

# ---------------------------------------------------------------------------
# 3. .gitignore — wholesale from GitHub's template, per the plan.
#    Your two existing entries are re-appended afterwards.
# ---------------------------------------------------------------------------
section "Fetching GitHub's Python .gitignore template"
if curl -sSLf https://raw.githubusercontent.com/github/gitignore/main/Python.gitignore \
     -o .gitignore.new; then
    mv .gitignore.new .gitignore
    for entry in '.env' '.venv' 'agentic-ai-30day-prep.md'; do
        grep -qxF "$entry" .gitignore || echo "$entry" >> .gitignore
    done
    echo "Wrote $(wc -l < .gitignore) lines. Confirm .env is in there before writing any key."
else
    rm -f .gitignore.new
    echo "WARNING: fetch failed. Existing .gitignore left untouched — check it by hand."
fi

# ---------------------------------------------------------------------------
# 4. Create the venv and install dev tooling from pyproject.toml
# ---------------------------------------------------------------------------
section "Syncing the environment (creates .venv, installs ruff/mypy/pytest)"
uv sync

section "Verifying the toolchain"
uv run ruff check . && echo "ruff: clean"
uv run pytest -q
uv run mypy || echo "mypy reported findings — expected until you write real code"

# ---------------------------------------------------------------------------
# 5. Editor check (informational)
# ---------------------------------------------------------------------------
section "Checking for VS Code"
if command -v code >/dev/null 2>&1; then
    echo "Found: $(code --version | head -1)"
else
    echo "Not found. Install with: sudo snap install code --classic"
fi

section "Done. Two commits are pending — review and push:"
echo "  git status"
echo "  git add -A && git commit -m 'Environment scaffold: uv, ruff, mypy, pytest'"
echo "  git push"
