# ThinkJava2 Project Board

Numbered tasks for tracking work. Each task has a permanent number; add new tasks at the end. Update status as work progresses.

### Current focus (2026-08-20)

- **Task 5:** Build Quarto PDF and decide which PDF is canonical — not started.
- **Task 6:** Redesign distribution like ThinkDSP (GitHub canonical; GTP optional mirror) — not started.
- **Task 4:** Done — LaTeX TOC restored ([issue #30](https://github.com/ChrisMayfield/ThinkJava2/issues/30)); [comment posted](https://github.com/ChrisMayfield/ThinkJava2/issues/30#issuecomment-5357911014).
- **Task 1–3:** Done on branch `java-runner` (see [issue #31](https://github.com/ChrisMayfield/ThinkJava2/issues/31) / [PR #32](https://github.com/ChrisMayfield/ThinkJava2/pull/32)).

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

---

## Task 4: Fix empty TOC in LaTeX PDF

**Status:** Done (2026-08-20)

**Context:** [Issue #30](https://github.com/ChrisMayfield/ThinkJava2/issues/30) reports a missing table of contents in the PDF. Confirmed on the **LaTeX** release path (`thinkjava2.pdf` / Green Tea Press `thinkjava7`): a **Contents** heading appears, but **no entries**. The Quarto PDF (`quarto/_book/Think-Java.pdf`) already has a full TOC. A commenter reproduced from source. Assignee: Allen Downey.

**Goal:** Restore a populated `\tableofcontents` in the LaTeX PDF build.

### Root cause

Empty Contents was a **failed / incomplete LaTeX build** problem, not a missing `\tableofcontents`. With TeX Live 2025:

1. `listings` `upquote=true` needs T1 (`\textquotedbl unavailable in encoding OT1`) — build aborted before `\end{document}`, so `.toc` never got written (0 bytes). One completed pass without a prior `.toc` typesets a blank Contents page.
2. In a ch05 exercise `tabular`, `\java{... && ...}` breaks on `&` (alignment tab). Fix: delimiter-form `\lstinline|...|` / `\lstinline+...+` (same style as `\java`, which is already `\lstinline`).

### Fix

- [x] `\usepackage[T1]{fontenc}` in [`latexonly.tex`](latexonly.tex)
- [x] Four ch05 table cells → `\lstinline|...|` (one with `||` uses `+...+`)
- [x] [`Makefile`](Makefile): `pdflatex -interaction=nonstopmode`; continue all 3 passes; require `thinkjava2.pdf`
- [x] Rebuild: **372 pages**, full Contents (Preface + chapters/sections), **0** `!` errors in log
- [x] Comment on issue #30

### Deliverables

1. Findings + fix on this board — done
2. Working LaTeX PDF TOC — done (`make pdf`)
3. Note on #30 — [comment](https://github.com/ChrisMayfield/ThinkJava2/issues/30#issuecomment-5357911014)

---

## Task 5: Quarto PDF vs LaTeX — choose canonical PDF

**Status:** Not started

**Context:** Two PDF pipelines exist. Quarto already produces a TOC; LaTeX is what Green Tea Press has shipped (`thinkjava7/thinkjava2.pdf`). After Task 4, we should consciously pick a canonical PDF for distribution.

**Goal:** Build the Quarto PDF, compare it to the (fixed) LaTeX PDF, and decide which is canonical for releases / thinkjava.org / GitHub.

### Scope

- [ ] `quarto render` PDF (or confirm `quarto/_book/Think-Java.pdf`) builds cleanly
- [ ] Side-by-side notes: TOC, typography, page count, code listings, figures, front matter
- [ ] Decision: canonical = Quarto | LaTeX | both for different channels
- [ ] Document decision in README / this board; update distrib targets if needed

### Deliverables

1. Short comparison notes
2. Explicit canonical choice recorded here
3. Follow-up issues/PRs if distrib paths need switching

---

## Task 6: Redesign distribution (ThinkDSP-style)

**Status:** Not started

**Context:** ThinkJava2 still uses bob-local `make distrib` → `DEST = /home/downey/public_html/greenteapress/thinkjava7` + `sh back`. That is the same fragile pattern ThinkDSP moved away from ([ThinkDSP Task 10](https://github.com/AllenDowney/ThinkDSP/blob/master/PROJECT_BOARD.md) / [Task 11](https://github.com/AllenDowney/ThinkDSP/blob/master/PROJECT_BOARD.md)): publish cannot run off one machine’s home directory tree.

**ThinkDSP pattern to mirror:**

| Layer | Role |
|-------|------|
| **GitHub** | Canonical PDF (commit/push after `make pdf`; stop treating the binary as local-only) |
| **GTP** `greenteapress.com/thinkjava7/` (or current tree) | Stable old URLs + WP landing; optional `rsync` mirror from any machine with `Host gtp` |
| **HTML** | Quarto / GitHub Pages (already the interactive path); do not require HeVeA rebuild for PDF release |

**Goal:** Replace bob-only `make distrib` with: build → commit PDF to GitHub → optional `rsync` to GTP. Align with Task 5’s canonical-PDF choice (LaTeX vs Quarto artifact).

### Scope

- [ ] Stop depending on `/home/downey/public_html/greenteapress/...` and `sh back` for the default release path
- [ ] Update `make distrib` (or replace) to stage the chosen PDF for GitHub commit (see ThinkDSP `book/Makefile` distrib)
- [ ] README: GitHub download link for PDF; document optional GTP mirror (`rsync` via `Host gtp`)
- [ ] Decide whether `thinkjava2.pdf` leaves `.gitignore` (ThinkDSP commits the ebook binaries)
- [ ] Optional: one-time GTP inventory for `thinkjava7` / thinkjava.org URLs (like ThinkDSP Task 11)
- [ ] Leave HeVeA HTML out of the PDF release ritual unless explicitly needed

### Out of scope

- Migrating every Green Tea Press book in one go
- GitHub Actions deploy (unless we want it later; ThinkDSP deferred CI)

### Deliverables

1. New distrib docs + Makefile targets
2. PDF available from GitHub; GTP mirror steps documented
3. Board note linking Task 5 decision to which file is published
