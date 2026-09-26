# Working notes for AI agents in this repo

> Proposed file (`CLAUDE_PROPOSED.md`). Rename to `CLAUDE.md` to adopt it, or
> delete it — it is a suggestion, not a fixture.

This is a **book**, not a code project. `plan.md` is the contract: chapter order,
chapter template, voice, and non-goals. Read it before writing anything.

## Rules

- **Never invent output.** Commands are run on a real Hermes install; terminal
  output is pasted or explicitly marked as trimmed. If something cannot be run,
  say so in the text instead of simulating it.
- **Record the Hermes version** each chapter was verified against.
- **Numbers are measured.** Caps, costs, and counts come from running a command
  or reading a config value, not from memory.
- **Traps survive version drift.** Write the durable part (file names, symbols,
  behaviour); do not lean on line numbers or a default that changes.
- **Voice:** first person, learning in public, honest about cost and things that
  are still rough. No marketing register.
- **Privacy:** the repository is public. Sanitise personal details — hostnames,
  paths, tokens, third-party names — rather than publishing raw session output.

## When adding a chapter

1. Follow the template in `plan.md` ("How a chapter gets written").
2. Name the file `chapters/NN-slug.md`, numbered as in the plan.
3. Update `plan.md` only if the arc itself changes, not merely because a chapter
   got written.
