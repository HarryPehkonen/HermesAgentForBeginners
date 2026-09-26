# Hermes Agent for Beginners — book plan

A book that documents learning Hermes Agent from the ground up, in public,
with the mistakes left in.

**Status:** plan, plus one sample chapter. Chapter 10 (the curator) exists as the
worked example that the output formats are being chosen against — built to HTML,
EPUB and PDF from the same Markdown source. See `chapters/10-the-curator.md` and
`build/`.

---

## The premise

Most agent documentation tells you what a feature is. This book tells you
**what it is for, what it costs, and how it bit me** — because the interesting
part of Hermes is not the feature list, it is the four or five systems that
quietly interact: memory caps, the skill index, profiles, the background
review, and the curator.

The intended reader has used a chat model, has a terminal open, and has never
configured an agent that remembers anything. The book starts there and ends
with a multi-profile setup that maintains itself.

## What makes it a book and not a docs mirror

- **Every command in the book was run, on a real install.** Real output, not
  invented output. Where output is trimmed, it says so.
- **Versions are recorded per chapter.** Hermes moves fast; a chapter states
  the version it was verified against, and the traps are written to survive
  version drift (symbols, file names and behaviour are the durable part;
  line numbers and defaults are not).
- **Each chapter carries at least one real incident.** The failures are the
  curriculum: a memory file that hit its cap and silently refused new facts, a
  `→ fact_store` pointer that had been a lie for months, a background result
  that reached the chat but never reached the agent.
- **Numbers where numbers exist.** Caps, index costs, delivery paths — measured
  rather than described.

## Who it is for

- **Primary:** a competent beginner — comfortable in a terminal, new to agents
  that persist, act, and remember.
- **Secondary:** an existing Hermes user who has memory and skills but has never
  looked at profiles, the curator, or the skill index budget.

## Voice

First person, learning in public. "I broke this twice before I understood it."
Honest about cost and about things that are still rough. No marketing register,
no exclamation marks, no feature laundry lists.

---

## Chapter arc

Four parts, ordered so each chapter only needs what came before it. The
subjects requested so far are marked **[requested]**; the rest are the
connective tissue the arc needs.

### Part 0 — Getting in

**1. What Hermes Agent actually is**
Explains the shape before any configuration: one agent core, many surfaces
(CLI, TUI, desktop, messaging gateway), and the two ideas every later chapter
depends on — persistent memory and skills. What "local-first" and
"provider-agnostic" mean in practice. First conversation, first tool call.

**2. The files that are you**
The layout under `$HERMES_HOME` (config, `.env` for secrets only, sessions,
state, skills, memories), and the rule that secrets live in exactly one place.
Why this chapter exists early: every later chapter is easier when you know
which file to open.

### Part I — Memory

**3. Memory: the smallest file that matters most** **[requested]**
`MEMORY.md` and `USER.md`, the character caps that make them special, and why a
full memory file **refuses** new facts instead of trimming. What belongs in
memory (rules, preferences, routing, pointers) and what does not (paths,
versions, inventories, procedures). The pointer discipline: a one-line trigger
whose detail lives somewhere else.

**4. Holographic memory: facts you can query** **[requested]**
The fact store as a *retrieval* system rather than a prompt block: probe,
search, related, reason across entities, contradict for hygiene, and feedback
that trains trust scores. Why facts stay out of the prompt and still get
recalled. What to do when a probe fails to find something it should.

**5. Keeping memory from rotting**
Consolidation as a scheduled habit rather than a rescue: the 70% trigger, "store
first, cut second", verifying every pointer resolves, and the audit that runs
silent when healthy. Grows out of the incident where a pointer had been dead for
months and nobody noticed.

### Part II — Capability

**6. Skills: procedures that load on demand** **[requested]**
The mental model first: skills are *instructions*, loaded when relevant, not
code. Discovery, loading, authoring, `references/` for the material that would
otherwise bloat a skill, size budgets. Then the measurement nobody tells you
about: the skill list itself is part of the system prompt and is paid every
single turn — with the real number. Ends with how to keep that budget from
growing forever.

**7. Profiles: several agents, one install** **[requested]**
Profiles as the structural answer to "my memory and skill list got too big":
separate config, memory, skills and sessions per profile. Partitioning by
domain (orchestrator versus specialists), what to move and what stays, the
shared directory for knowledge that must be visible everywhere, and the rule
that you never write into another profile's store by hand.

### Part III — Working across agents and time

**8. Kanban: handing work to another profile** **[requested]**
A durable board as a work queue rather than a to-do list: cards, assignees,
atomic claims, workspaces, handoff summaries, the review lifecycle, and
notifications back to chat. When a card is the right tool and when a plain
message is.

**9. Background and scheduled work**
Scheduled jobs (durable, survive restarts, conditions and monitors) versus
background processes versus dispatched subagents. Then the chapter's real
subject: **which results reach the agent and which only reach the human** — the
two delivery paths, the cases where a completion is dropped, and how to tell
the difference while debugging.

**10. The curator: maintenance for a library that grows itself** **[requested]**
Anything that creates skills from conversations needs a drain. The deterministic
lifecycle (active → stale → archived), the optional consolidation pass and what
it costs, pins and the fences they set, backups, the audit ledger and how to
undo a single change — plus the trap where the ledger's actor labels mislead you
about who changed what. Closes with an honest assessment of running it with
"no intervention".

### Part IV — Growing it

**11. Extending Hermes without forking it** 
The extension surfaces in order of cost: config conventions, skills, plugins,
MCP servers, and core patches as the last resort. The rule that makes the choice
easy: every MCP tool schema rides on every API call, so prefer a CLI wrapped in
a skill; use MCP where there is no CLI.

**12. Keeping the whole thing healthy**
The maintenance chapter: what to measure (memory fill, skill index cost, skill
sizes, curator state), what to schedule, what to back up, and what to ignore.
Written as a short checklist a reader can run monthly.

**13. Where it goes wrong: a gotchas appendix**
Every trap from the book, collected, one line each, with the chapter that
explains it. The most-read page in the book.

**Appendix A — Glossary.** Terms used without ceremony: profile, frame, card,
delivery path, pointer, skill index.
**Appendix B — What I would tell my past self.** Three paragraphs, no code.

---

## How a chapter gets written

Template, so chapters stay comparable:

1. **What you will be able to do** — one sentence, concrete.
2. **The idea** — the mental model, before any commands.
3. **Do this** — a walkthrough with real commands and real output.
4. **Verify it** — how the reader proves it worked, not just that it ran.
5. **What broke for me** — the incident this chapter grew out of.
6. **Pitfalls** — the short list, including what silently fails.
7. **Where to go next** — the pointer to the next chapter, not a link dump.

Rules:

- Run the commands. Paste real output. Mark trimmed output explicitly.
- Record the Hermes version each chapter was verified against.
- Prefer measured numbers over adjectives.
- Nothing ships in a chapter that the author has not personally done.

## Repo structure

```
README.md        what the book is, who it is for, how to follow along
plan.md          this file
chapters/        one file per chapter, numbered
appendix/        glossary and the gotchas page
build/           the build pipeline: filter, theme, metadata, script
samples/         committed outputs of the sample chapter (generated; see below)
dist/            build output (git-ignored)
LICENSE          Unlicense
```

## Production

Source is **Markdown**, and the outputs are generated from it:

```bash
./build/build.sh              # dist/book.html, dist/book.epub, dist/book.pdf
```

Storage: `pandoc` (the converter) and `tectonic` (a self-contained LaTeX engine)
— static binaries, no TeX Live, no root. Both are expected on `PATH`, defaulting
to `~/.local/bin`.

### Markers — the only syntax the book adds to Markdown

Because a generated list cannot drift from its source, everything that appears
in two places is generated from one marker:

| Marker | Meaning |
| :--- | :--- |
| `[term]{.idx}` | An index entry. Gets a page number in the PDF's printed index and a link to its section in the HTML/EPUB index. |
| `::: {.definitive title="…"}` | A definitive block: styled as a labelled callout, and collected into the generated "Key ideas" list. |
| `::: {#book-index}` | Where the index is rendered. |
| `::: {#key-ideas}` | Where the key-ideas list is rendered. |

`build/book.lua` is the filter that implements this. Two things about it are
worth knowing before editing: pandoc's `walk` visits an element's children
*before* the element itself, so section tracking has to walk blocks top-down by
hand; and a fenced div's title is an **attribute** (`::: {.definitive
title="…"}`), not a `title:` line in the body.

### Outputs and why each exists

- **HTML** — one self-contained file (CSS embedded). The website form.
- **EPUB** — for eInk; open with Calibre or copy to the device. Reflowable, so
  its index links to *sections* rather than page numbers.
- **PDF** — via LaTeX: real typography, and a printed index with page numbers
  (`imakeidx`) alongside the generated linked one.

Still open: whether the PDF keeps the printed page-number index (it needs a
`makeindex` pass the engine may or may not run) or matches the other two formats
with a link-based index. The sample exists to decide that.

## Milestones

Keep it shipping rather than complete. Each milestone is a usable increment.

- **M0** — plan committed, repo public. *(this file)*
- **M1** — Part 0 written (chapters 1-2): a reader can install and understand
  the shape.
- **M2** — Part I (memory chapters): a reader can keep memory small and useful.
- **M3** — Part II (skills, profiles): the growth problem is answered.
- **M4** — Part III (kanban, background work, curator).
- **M5** — Part IV plus appendices; then a read-through for voice and drift.

## Open questions

- **Privacy of examples.** The strongest material is real, and the repository is
  public. Decide the line: which personal details get sanitised, which incidents
  are told with the identifying parts removed.
- **Where the book stops.** A book that explains every feature becomes a stale
  docs mirror. The current answer: stop at "a setup that maintains itself, and
  how to tell when it is not".
- **Screenshots or terminal text.** Terminal text is searchable, reproducible
  and version-diffable; screenshots are friendlier. Current lean: terminal text,
  with screenshots only for surfaces that have no text form.
- **Follow-along install vs own config.** Whether readers are told to run a
  throwaway profile for the book's examples, or to change their real one.

## Non-goals

- Not a replacement for the official documentation, and not a feature list.
- Not an API reference, and not a guide to writing an agent framework.
