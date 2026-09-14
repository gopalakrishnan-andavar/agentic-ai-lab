#!/usr/bin/env bash
# setup-laptop-later.sh — Day-specific dependency installs from 10-day-plan.md.
# Run the matching block on its day (or all at once now if you'd rather have
# everything ready up front — nothing here depends on the day it runs).
#
# Usage:
#   bash scripts/setup-laptop-later.sh tue    # Pydantic, HTTP, secrets
#   bash scripts/setup-laptop-later.sh thu    # LLM API SDK
#   bash scripts/setup-laptop-later.sh fri    # Embeddings (numpy)
#   bash scripts/setup-laptop-later.sh sat    # Documents and chunking
#   bash scripts/setup-laptop-later.sh sun    # Podman + vector DB

set -euo pipefail
cd "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

case "${1:-}" in
  tue)
    # Tue 15 Sep — Pydantic, HTTP + secrets
    uv add pydantic httpx python-dotenv tenacity
    ;;
  thu)
    # Thu 17 Sep — LLM APIs and structured output
    # Swap for whichever provider SDK you're actually calling.
    uv add anthropic
    ;;
  fri)
    # Fri 18 Sep — Embeddings, implemented by hand with numpy
    uv add numpy
    ;;
  sat)
    # Sat 19 Sep — Documents and chunking (public regulatory PDFs)
    uv add pypdf
    ;;
  sun)
    # Sun 20 Sep — Podman + vector DB
    sudo apt update
    sudo apt install -y podman podman-docker
    uv add chromadb
    ;;
  *)
    echo "Usage: $0 {tue|thu|fri|sat|sun}"
    exit 1
    ;;
esac
