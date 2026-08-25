# Foundations Refresher — the mechanics layer

Companion to `agentic-ai-30day-prep.md`. Written 27 Aug 2026, after the Day 1 baseline.

## Why this file exists

The Real Python cheat sheet is a **syntax** reference. Its eighteen sections tell you what to
type: strings, loops, functions, classes, comprehensions, file I/O, venvs. That is genuinely
useful and worth reading end to end — but every one of those sections answers *what do I write*,
and none of them answers *what does the machine do*. The Day 1 baseline showed the gap is the
second kind, not the first.

So: read the cheat sheet for syntax recall. Use **this** file as the test of whether the model
underneath is actually there.

## How to use this

Do not read it as notes. Every line below is a **question you should be able to answer out loud
without looking**. Work through a section, answer each question, and where you can't — go to the
linked primary doc, and then *prove it in the REPL* rather than trusting the explanation.
`id()`, `dis.dis()`, `type()`, `__defaults__` and `time.perf_counter()` are your instruments.

Mark each question: **know it** / **fuzzy** / **no idea**. Bring the fuzzy and no-idea ones to
the session. That list is worth more than a page of notes.

---

## A. The object model — do this one first, it explains half the others

Ref: [Data model](https://docs.python.org/3/reference/datamodel.html) ·
[Execution model: naming and binding](https://docs.python.org/3/reference/executionmodel.html)

- Python has no variables in the Java sense. What does it have instead, and what does `x = y`
  actually do to memory? How many objects exist after it?
- Why does `def f(lst): lst.append(1)` change the caller's list, when Java would have needed you
  to think about it? What is the argument-passing rule, precisely — not "by value" or "by
  reference"?
- Which built-in types are immutable? What breaks if you use a mutable object as a dict key, and
  what is the actual mechanism that breaks?
- When is a function's default argument evaluated — at compile time, at definition time, or at
  call time? Where is the resulting object stored? (Inspect `f.__defaults__` and confirm.)
- `is` vs `==` — and why `a = 256; b = 256; a is b` differs from the same code with `257`.
- How does CPython reclaim memory, and how is that different from the JVM's generational
  collector? What is a reference cycle and what handles it?

## B. Scope and closures

Ref: [Scopes and namespaces](https://docs.python.org/3/tutorial/classes.html#python-scopes-and-namespaces)

- Spell out LEGB. When do you need `global`, when `nonlocal`, and why is needing either usually a
  design smell?
- A closure captures the *variable*, not the value. Write the classic loop-of-lambdas bug, predict
  the output, run it, and explain the gap.
- Why does a comprehension not leak its loop variable when a `for` loop does?

## C. Protocols, not interfaces — this is where your Java habits will show

Ref: [Data model: special method names](https://docs.python.org/3/reference/datamodel.html#special-method-names)

- What actually happens when you call `len(x)`, `x + y`, or `item in x`? Where does the dispatch go?
- Duck typing vs interfaces: why does Python have no `implements` keyword and not miss it?
- EAFP vs LBYL. Why is `try/except` idiomatic control flow here and defensive null-checking is not?
  (This will feel wrong to you for about a week.)
- The `__eq__`/`__hash__` contract — what breaks if you override one and not the other?
- When is a class the right answer in Python and when is it a function, a dict, or a dataclass?
  Your instinct will be to reach for a class hierarchy. Interrogate that instinct every time.
- [`dataclasses`](https://docs.python.org/3/library/dataclasses.html) — learn these *before*
  Pydantic on Day 3, so you can see exactly what Pydantic adds on top.

## D. Iteration and laziness

Ref: [Functional programming HOWTO](https://docs.python.org/3/howto/functional.html)

- The iterator protocol: `__iter__`, `__next__`, `StopIteration`. What does a `for` loop desugar to?
- What does `yield` do to a function? At what moment does the body first run?
- List comprehension vs generator expression — when does the memory difference actually matter?
  (It will, when you chunk regulatory PDFs in Week 3.)
- Dict and set comprehensions. `enumerate`, `zip`, `any`, `all`, `sorted(key=...)`.
- Why is `for i in range(len(items))` almost always the wrong shape?

## E. Concurrency mechanics — your weakest measured area, and it is not a syntax problem

Ref: [asyncio](https://docs.python.org/3/library/asyncio.html) ·
[Developing with asyncio](https://docs.python.org/3/library/asyncio-dev.html)

- What is the GIL, what does it actually protect, and what does it therefore stop you doing?
- Given the GIL, why are threads still useful for I/O? When does a thread pool beat asyncio?
- What is an event loop, concretely? Where exactly does it get the chance to switch tasks?
- A coroutine is an object, not a running thing. What does calling `foo()` on an `async def`
  return if you never await it?
- What does a blocking call inside `async def` do to every *other* task on that loop?
- `asyncio.gather` vs `asyncio.TaskGroup` — and what happens to siblings when one raises?
- Where is the boundary: `asyncio` / `threading` / `multiprocessing`. State the rule in terms of
  the workload, not in terms of the tool.

## F. Imports, environments, packaging

Ref: [The import system](https://docs.python.org/3/reference/import.html) ·
[PEP 668](https://peps.python.org/pep-0668/)

- A module's top-level code runs how many times, however many places import it? What caches it?
- What is `if __name__ == "__main__":` really testing?
- Absolute vs relative imports, and why `python foo.py` and `python -m package.foo` resolve
  differently. (This will bite you in Week 1 the moment you add `src/` and `tests/`.)
- What does a venv physically change? What is on `sys.path` inside one?
- Why does Ubuntu refuse a bare `pip install` with `externally-managed-environment`?
- `requirements.txt` vs `pyproject.toml` vs a lockfile — what does each one promise?
- [`uv`](https://docs.astral.sh/uv/) — worth learning instead of `pip` + `venv`. Faster, and it is
  what new projects are standardising on.

## G. Typing

Ref: [`typing`](https://docs.python.org/3/library/typing.html)

- `list[str]` vs `List[str]`, `Optional[X]` vs `X | None`.
- **Type hints are not enforced at runtime. Nothing checks them when your program runs.**
  Sit with that, because it is the entire reason Pydantic exists — and Day 3 lands much harder if
  you arrive already knowing it.
- `TypedDict`, `Protocol`, `Literal`. What is a `Protocol` for, given duck typing already works?

## H. Errors

- The exception hierarchy. Why is bare `except:` a firing offence, and what does it swallow?
- `raise NewError(...) from err` — what does `from` preserve, and why does it matter at 3am?
- `finally` vs context managers. What guarantees does `with` give you, and what are `__enter__`
  and `__exit__` doing? Write one context manager by hand.

---

## Not in the curriculum, but you need them

The 30-day plan assumes these; it never teaches them. Fold them in as you go.

| Topic | Why | Where it lands |
|---|---|---|
| [`pytest`](https://docs.pytest.org/) — fixtures, `parametrize` | Day 2 creates `tests/` and the plan never says what goes in it. Untested code in a public repo reads badly. | Day 2 onward, continuously |
| [`logging`](https://docs.python.org/3/howto/logging.html) | You cannot instrument an agent on Day 27 if `print` is your only tool. Levels, handlers, structured output. | Learn Day 4, need it Day 27 |
| [`ruff`](https://docs.astral.sh/ruff/) | Lints and formats. It will catch your camelCase and your `for`+`append` before I do. Put it in the repo Day 2. | Day 2 |
| [`mypy`](https://mypy.readthedocs.io/) | Makes type hints mean something. Closes the gap in section G. | Day 3 |
| [`pathlib`](https://docs.python.org/3/library/pathlib.html) | You'll be walking directories of PDFs in Week 3. Don't do it with string concatenation. | Day 15 |
| [PEP 8](https://peps.python.org/pep-0008/) naming | snake_case, not camelCase. Read it once, properly. | Now |
| `collections`: `defaultdict`, `Counter`, `deque` | Counting chunks, dedup, bounded history buffers. | Weeks 3–4 |
| HTTP: idempotency, retries, `Retry-After` | Your weakest HTTP gap and the most embarrassing one given your domain. | Day 4 |
| `tenacity` or hand-rolled backoff | Every LLM API call in Weeks 2–4 needs it. Hand-roll it first. | Day 4 |

If you want one book alongside all this: **Fluent Python**, Ramalho, 2nd edition. It is the
mechanics layer, written for exactly the engineer you are — someone competent in another language
who wants to know why Python is shaped this way. Chapters 1, 2, 6, 8 and 17 cover most of the
above.

---

## Revised schedule — recovering the two lost days

Days 1 and 2 were lost (25–26 Aug). The Sep 24 course start is fixed, so the deficit gets absorbed
in the first weekend rather than carried. The key move is a **swap**: Day 8's environment work
happens on Saturday, because that is the day the machine is being rebuilt anyway.

| Date | Plan | Hours |
|---|---|---|
| Thu 27 Aug | **Day 1 + Day 2** — baseline (done), repo hygiene, venv/uv, `src/`, `tests/`, `.gitignore`, ruff, first commit | 2 |
| Fri 28 Aug | **Day 3** — type hints and Pydantic. Dense; do not compress this one. | 2 |
| Sat 29 Aug | **Ubuntu install + Day 8** — reformat, Podman, `podman-docker`, VS Code, git config, SSH keys, Postgres in a container | 4 |
| Sun 30 Aug | **Day 4 + Day 5** — HTTP/secrets, then async. Give async the larger half; it is your weakest area. | 4 |
| Mon 31 Aug | **Day 6** — FastAPI | 2 |
| Tue 1 Sep | **Day 7** — Week 1 evaluation + LinkedIn post #1 | 2 |
| Wed 2 Sep → | Back on plan. Day 9 onward, unchanged. | 2 |

Fully recovered by 2 Sep. Two four-hour weekend days is the entire cost.

**Back up before Saturday.** Push this repo to GitHub — a local-only repo on a disk you are about
to reformat is not a repo. Also capture: SSH keys, browser bookmarks, anything in Documents,
and the list of software you'll want reinstalled.
