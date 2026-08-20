# ThinkJava2 Project Board

Numbered tasks for tracking work. Each task has a permanent number; add new tasks at the end. Update status as work progresses.

### Current focus (2026-08-20)

- **Task 1–3:** Done on branch `java-runner` (see [issue #31](https://github.com/ChrisMayfield/ThinkJava2/issues/31)).
- Next: commit / PR when ready.

---

## Task 1: Dev environment for Quarto HTML

**Status:** Done (2026-08-20)

**Context:** Interactive book HTML is built with Quarto (`make html` → `quarto/_book/`). [Issue #31](https://github.com/ChrisMayfield/ThinkJava2/issues/31) replaces Trinket with client-side [java-runner](https://github.com/ChrisMayfield/java-runner). That work needs a reproducible local HTML build. This is **not** a JDK project: java-runner runs in the browser; conda only covers Python tooling.

**Goal:** Document and modernize the toolchain so `make html` / `quarto preview` work reliably.

### Done

- [x] Modernize `environment.yml` (Python 3.12, conda-forge; no Pillow — unused)
- [x] Makefile targets: `create_environment`, `update_environment`, `delete_environment`
- [x] README: Quarto install (external) + conda activate + `make html`; note no JDK needed
- [x] Smoke-check: `make html` → `quarto/_book/index.html`; `mamba env create` succeeded

### Out of scope

- JDK / OpenJDK in conda
- Building java-runner from npm (vendored `dist/` in Task 2)
- HeVeA / legacy Trinket path changes

---

## Task 2: Integrate java-runner (feature parity)

**Status:** Done (2026-08-20)

**Context:** 17 former `\begin{trinket}` programs in chapters 1–5, 7, 10. Quarto had flattened them to ordinary `{.java language="Java"}` fences.

**Goal:** Those 17 snippets become interactive editors in Quarto HTML via `<script type="text/x-java">`.

### Done

- [x] Vendor `javarunner.css` + `javarunner.js` into `quarto/assets/javarunner/`
- [x] Wire `_quarto.yml`: CSS, `include-in-header` JS, `resources:`, Lua filter
- [x] `quarto/filters/javarunner.lua` — `.javarunner` → `text/x-java` (HTML only)
- [x] Annotate all 17 former-trinket fences
- [x] Rebuild: 17 `<script type="text/x-java">` across ch01–05, 07, 10; assets in `_book/assets/javarunner/`; not wrapped in `code-fold` details

### Former trinket map

| Chapter | Programs |
|---------|----------|
| ch01 | Hello, Hello2, Goodbye×3, Hello3 |
| ch02 | Hello×2 |
| ch03 | Echo, Convert, GuessStarter |
| ch04 | NewLine, PrintTwice, PrintTime |
| ch05 | Logarithm |
| ch07 | Doubloon |
| ch10 | Surprise |

### Out of scope

- Removing legacy `make trinket`

---

## Task 3: Expand interactive coverage (extra mile)

**Status:** Done (initial pass, 2026-08-20)

**Context:** java-runner can run incomplete snippets and supports REPL via `text/x-java-repl`.

**Goal:** After Task 2 parity, selectively add more interactives and optional REPL blocks.

### Added `.javarunner` (incomplete / statement snippets)

- ch01: bare `println("Hello, World!")`; escaped-quote println
- ch02: print current time; minutes since midnight; floating-point `0.1` sum; string `+` associativity
- ch06: countdown `while`; for-loop “appreciate”; multiplication table

### Added `.javarunner-repl`

- ch02: `message` / `hour` / `minute` declarations (REPL init)
- ch06: `fruit` / `charAt(0)` (REPL init)

### Kept static (intentionally)

- Compiler-error demos, infinite-loop examples, fragments that depend on undeclared prior state, wrong/`==` string comparisons meant as cautionary text

### Deliverables

1. Candidate judgment recorded above
2. Annotated additional fences + 2 REPL examples
3. Re-test HTML build after Task 3 edits
