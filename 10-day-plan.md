# 10-Day Plan — Sep 14 to Sep 23, 2026

Replaces the 30-day curriculum. Course starts Thu 24 Sep.

**Budget:** ~23 hours (Mon 4h, Tue 3.5h, then 2h/day × 8). Original plan assumed 60.

**Goal:** not coverage. Three things you can defend in conversation on day one —
Python mechanics you actually understand, one RAG pipeline you built end to end,
and one agent loop you wrote by hand without a framework.

---

## What is cut, deliberately

Not "deferred" — cut. The course teaches all of these, and you'll learn them better
there with a working foundation than badly here in stolen hours.

| Cut | Why |
|---|---|
| FastAPI | An evening's work whenever you need it. Nothing downstream depends on it. |
| Hybrid search, reranking | Optimisation. You need retrieval working before you need it working *well*. |
| LangGraph / any framework | The original plan's own logic: hand-roll first. If only one survives, it's the hand-rolled loop. |
| Multi-agent, memory, observability | Weeks 4 territory. Pure course material. |
| Formal RAG evaluation | Painful cut — it's your differentiator. Becomes your first course project instead. |
| LinkedIn posts 1–3 | One retrospective post after the 23rd, if it earns its place. |

---

## Mon 14 Sep — 4h (battery-limited, so order matters)

Your correct charger is at home and this battery is eight years old. Assume you get
less than four hours. Do these **in order** and push after every step.

**First 30 minutes — eliminate the single point of failure**
- On the other laptop: push `agentic-ai-lab` to GitHub. It has one local commit and
  no remote copy. You have just spent three days learning what happens when a machine
  becomes unavailable.
- Check `git config user.email` on that machine before pushing. If it's a work
  machine with a work git identity, fix that first — the repo is public, and your own
  rules say everything in it is published.
- Then on the Ubuntu machine: generate an SSH key, add it to GitHub, clone the repo.

**Next 1h — environment**
- `uv` (not pip + venv). Project layout: `src/`, `tests/`, `pyproject.toml`, `.env.example`.
- `.gitignore` from `github/gitignore/Python.gitignore` — wholesale, not hand-rolled.
  **`.env` must be in it before you write a single API key.**
- `ruff` installed and running. It will catch your camelCase before I do.
- Commit, push.

**Remaining time — Python mechanics, in the REPL**
- Section A of `foundations-refresher.md` (object model), then section C (protocols).
- Concept first, then apply it — predict the output, run it, explain the gap.
  `id()`, `__defaults__`, `dis.dis()`. Prove each one; an explanation you did not
  run is not evidence.
- Bring me your *fuzzy* and *no idea* list at the end of the day.

## Tue 15 Sep — 3.5h

- **Pydantic.** `BaseModel`, nested models, validators, `model_validate`.
  Build a `SanctionsAlert` schema with nested fields and at least two real validators.
- Why it exists: type hints are not enforced at runtime. Sit with that.
- **HTTP + secrets.** `httpx`, timeouts, retries with backoff, `.env` via `python-dotenv`.
  Parse a real public API's response into your Pydantic models.
- **Idempotency** — the gap from your baseline. Read Stripe's docs on it. Fifteen minutes.

## Wed 16 Sep — 2h · Async

Your weakest measured area, and the one you must *prove* rather than read.

- Fetch 10 endpoints sequentially. Time it. Then with `asyncio.gather`. Time it.
- Then put a `time.sleep(1)` inside one coroutine and watch the concurrency collapse.
  Measure it. Explain the number to me.
- `TaskGroup` vs `gather`, and what happens to siblings when one raises.

## Thu 17 Sep — 2h · LLM APIs and structured output

- First API call. Token counts, cost per call, context window.
- Extract structured fields from a public regulatory notice into a validated Pydantic model.
- Handle malformed JSON with a validation-retry loop. Make it fail on purpose first.

## Fri 18 Sep — 2h · Embeddings

- What a vector actually is. Cosine similarity **implemented yourself with numpy** —
  no library, no vector DB. You need to feel the mechanics before you abstract them.
- Embed ~50 chunks, query them, look at what comes back and what doesn't.

## Sat 19 Sep — 2h · Documents and chunking

- Ingest 3–4 public regulatory PDFs (FATF, RBI Master Directions, EU AMLD, Wolfsberg).
- Chunk them. Then *read the chunks*. Find where naive chunking splits a clause and
  destroys the meaning. That failure is the whole lesson.
- `pathlib`, not string concatenation.

## Sun 20 Sep — 2h · Podman + vector DB

- Install Podman and `podman-docker`. Run one container, expose a port, mount a volume.
  Thirty minutes, and it also covers your course prerequisite.
- ChromaDB in that container. Index Friday's chunks. Query with metadata filters.
- Compare results against your own numpy version from Friday.

## Mon 21 Sep — 2h · End-to-end RAG

- Retrieve → augment → generate. Prompt construction with retrieved context. Citations.
- **Ask it 10 questions and log every failure.** The failure log is the deliverable,
  more than the pipeline is.

## Tue 22 Sep — 2h · The agent loop

The most valuable two hours in this plan.

- ReAct by hand: thought → action → observation → repeat. No framework.
- Termination conditions. Loop prevention. What happens when the model won't stop.
- One tool. Get it reasoning in a loop until it answers.

## Wed 23 Sep — 2h · Tools, polish, and questions

- Give the agent two more tools. Make one fail deliberately. Handle it without crashing.
- README: what this is, architecture, setup, and an honest **limitations** section.
  The limitations section is what a senior engineer reads first.
- **Write your list of hard questions for the faculty.** Arriving with sharp questions
  is the cheapest way to be noticed. Aim for five, drawn from things that actually
  broke this week.

---

## Standing rules for the ten days

- Commit and push every single day. No exceptions, and no local-only work ever again.
- Public documents only. No Oracle material, no client data. The repo is published.
- When something breaks: enumerate everything that changed, including the boring
  physical things. That is the lesson the charger taught, and it transfers to code.
- If a day slips, cut scope inside the day — do not push the day into the next one.
  There is no slack left to absorb it.
