# Why the LLM-Wiki Pattern Is Critical to AAO Methodology

**Document type:** Research rationale
**Date:** 2026-04-17
**Author:** Donald Moskaluk, AtMyBoat.com
**Source:** Andrej Karpathy, "LLM Wiki" gist, April 2026
**Gist URL:** https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f
**Integration spec:** `SPECIFICATION.md` Section 22

---

## The Problem AAO Had Without It

The AAO loop (Analyze → Act → Observe) is sound in principle, but without a
persistent knowledge layer it suffers from one structural deficiency: **every
session starts from zero.**

Claude Code reads files, understands them, makes changes, and the session ends.
The next session re-reads the same files and re-derives the same understanding.
Nothing compounds. This is precisely the RAG failure mode Karpathy described:

> *"The LLM is rediscovering knowledge from scratch on every question.
> There's no accumulation."*

In a codebase or project that spans weeks or months, this means:

- Decisions made in session 3 are unknown in session 20.
- Contradictions between modules are re-discovered instead of already flagged.
- Syntheses (why we chose Postgres, why this API is versioned this way) live
  only in chat logs no one ever reads again.
- The Analyze phase of AAO reads raw files instead of distilled knowledge,
  which wastes context and slows every cycle.

The LLM-Wiki pattern closes this gap by giving the Analyze phase something
far more valuable than raw files: **a curated, interlinked, up-to-date wiki
that the agent itself maintains.**

---

## What the Integration Specifically Adds to Each Phase

### Analyze — From Cold-Start to Warm-Start

Without the wiki, Analyze means reading source files and hoping context fits
in the window. With the wiki:

- `wiki/index.md` gives a catalogue of every known entity, concept, and
  decision in the project — no file-scanning required.
- `wiki/log.md` gives the last five changes — the agent knows immediately
  what happened recently without re-reading everything.
- Entity pages like `wiki/entities/auth-module.md` contain synthesised
  understanding: what the module does, its known constraints, which RFC or
  decision document governs it, and any open contradictions.

The Analyze phase becomes a *lookup into accumulated knowledge* rather than
a cold read of raw material. Each cycle is faster and more accurate than
the last.

### Act — Decisions Informed by History

Without the wiki, Act is stateless. The agent may implement something that
contradicts a decision made two months ago because it has no memory of that
decision.

With the wiki:

- Before writing code, the agent checks for a `wiki/entities/` or
  `wiki/concepts/` page that covers the area being changed.
- If a prior decision exists (e.g. `wiki/entities/decision-db-choice.md`),
  the Act phase respects it or explicitly flags a contradiction.
- The act of updating wiki pages *as part of the task* means the next
  agent session will benefit from what this one learned.

### Observe — From Logging to Compounding

Without the wiki, Observe means appending to a log that no one will
systematically read. With the wiki:

- Valuable findings (a surprising constraint, a cross-module dependency, a
  resolved ambiguity) are filed into `wiki/syntheses/` immediately.
- The lint pass runs automatically, keeping the knowledge base healthy.
- Contradiction flags are surfaced for human review rather than silently
  accumulating as technical debt.
- The log entry in `wiki/log.md` is structured and parseable, so future
  Analyze phases can grep it efficiently.

The Observe phase becomes the **write path** for a self-maintaining knowledge
base rather than a passive record nobody consults.

---

## The Compounding Advantage

This is the most important capability the pattern adds, and it is worth
stating precisely.

In a traditional AAO setup, the *n*-th session is no smarter than the first,
because each session starts from the same raw files. Accumulated work appears
only in the diff history of the code itself, which the agent cannot efficiently
query for semantic understanding.

With the LLM-Wiki layer, each session deposits knowledge into the wiki. The
*n*-th session enters an Analyze phase that has the benefit of every prior
session's synthesis. The wiki is a **compounding artifact**: it gets
progressively more valuable the longer the project runs.

Concretely, after 30 sessions:
- The wiki contains entity pages for every major module, decision, and concept.
- Contradictions between components have been flagged and resolved.
- Syntheses answer the "why" questions (why this architecture, why this
  library, why this versioning scheme) that are otherwise buried in old chat
  histories.
- The index gives the agent a map of the entire knowledge surface in one read.

A project running AAO + LLM-Wiki for three months is qualitatively different
from the same project running plain AAO — not because the agent is smarter,
but because it is operating against three months of accumulated, maintained,
cross-referenced knowledge rather than cold files.

---

## Why Maintenance Is No Longer the Bottleneck

Traditional wikis fail because maintenance burden grows faster than value.
No human wants to spend 20 minutes updating cross-references after every
decision. So they stop doing it. The wiki drifts. The wiki dies.

The LLM-Wiki pattern solves this structurally. The agent does the maintenance
as an integral part of every task — not as a separate chore. In the AAO loop
above, updating wiki pages happens *during* Act, not after it. The lint pass
happens *during* Observe. The human never has to consciously decide to maintain
the wiki; it is maintained as a side effect of the work.

As Karpathy observed:

> *"The tedious part of maintaining a knowledge base is not the reading or the
> thinking — it's the bookkeeping. LLMs don't get bored, don't forget to
> update a cross-reference, and can touch 15 files in one pass."*

For AAO this means the methodology finally has a durable memory layer — one
that stays accurate because the cost of keeping it accurate is effectively zero.

---

## AAO Rule Conflicts and Resolutions

The integration introduces four rule conflicts. All four are resolved in
`SPECIFICATION.md` Section 22. Summary:

| # | Conflict | Resolution |
|---|----------|------------|
| C1 | Zero-Inference Rule prohibits touching files not in Phase 1 list; ingest touches 10–15 wiki pages | `wiki/` is permanently in scope when wiki layer is active — standing scope authorization (§22.5) |
| C2 | File Scope Permissions are per-task; `wiki/log.md` must be appended after every task | `wiki/log.md` append + mini-lint are standing authorized operations exempt from per-task scope (§22.5) |
| C3 | No-Planning Rule prohibits producing plans; Analyze phase reads wiki before every task | Wiki pre-reads are internal None-risk reads, not operator-facing planning output — no conflict in practice (§22.8) |
| C4 | MEMORY.md + SESSION_LOG.md overlap with wiki/ artifacts | These serve different scopes and are complementary — MEMORY.md is the executive index, wiki/ is the detailed layer (§22.7) |

---

## Summary of Capabilities Added

| Capability | Before (plain AAO) | After (AAO + LLM-Wiki) |
|---|---|---|
| Cross-session memory | None | `wiki/` persists across all sessions |
| Decision history | Buried in git messages | Dedicated entity pages with citations |
| Contradiction detection | Manual | Lint pass flags automatically |
| Synthesis retrieval | Re-derive each session | Pre-compiled `syntheses/` pages |
| Analyze phase speed | Slow (raw file reads) | Fast (index lookup + focused page reads) |
| Knowledge compounding | None | Each session adds to the next |
| Maintenance burden | On the human | On the agent, zero human overhead |
| "Why" answers | Lost in chat history | Filed in `wiki/syntheses/` permanently |

The LLM-Wiki pattern does not change what AAO does. It gives it **memory**.
And a methodology with memory is categorically more capable than one without.

---

*Reference: Andrej Karpathy, "LLM Wiki" gist, April 2026*
*https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f*

*Integration spec: SPECIFICATION.md Section 22 — PERSISTENT KNOWLEDGE LAYER*
