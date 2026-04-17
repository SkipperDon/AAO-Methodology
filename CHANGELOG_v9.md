# AAO Methodology Repository — Version 9 Changelog

## Interactive Development Mode + Backup Naming Standard

**Release Date:** 2026-03-19
**Version:** 9.0 (v8 → v9)
**Spec version:** v1.2 → v1.3

---

## Summary

Version 9 adds two critical sections addressing AI coding assistant governance
in interactive development workflows. These sections close governance gaps that
exist when Claude Code or any AI coding assistant operates as a development tool
rather than a deployed autonomous agent.

**Section 17** — Defines git as the formal snapshot layer for Interactive
Development Mode. Establishes the Pre-Edit Snapshot Protocol as a MUST
requirement: git status must be clean before any file is modified.

**Section 18** — Defines the AAO Backup Naming Standard. Establishes a single,
consistent convention for every backup file created by an AI assistant, with
retention rules, cleanup commands, and `.gitignore` integration.

Both sections close gaps identified through real production use of Claude Code
across multiple development sessions. They are the result of observed failure
modes, not theoretical risk assessment.

---

## Why These Sections Were Added

### The Observed Problem

Claude Code has no automatic backup mechanism. It writes directly to live files.
When asked to create a backup, it generates a name on the fly — inconsistent
across sessions, unpredictable in location.

At scale (hundreds of files, dozens of sessions, thousands of `.bak` files),
there is no reliable way to:
- Find all backups for a specific file
- Know which session created which backup
- Determine which backups are safe to delete
- Connect a backup to the session log entry that explains why it was created

The Pre-Edit Snapshot Protocol (Section 17) addressed the primary recovery gap.
The Backup Naming Standard (Section 18) addresses the secondary backup gap.

### Why Structural Rather Than Verbal

Both standards are defined in governing documents (SPECIFICATION.md and CLAUDE.md)
because verbal instructions are ephemeral — they do not persist across sessions.
Claude Code re-reads its governing documents fresh at every session start.

A verbal instruction to "always back up files consistently" fails six sessions
later when the session starts fresh and the only instruction in force is what is
written in the governing document.

Structural definition in the governing document is the only mechanism that
persists reliably across sessions.

---

## New Sections

### Section 17 — Interactive Development Mode (SPECIFICATION.md)

Defines git as the snapshot layer for Interactive Development Mode. Covers:

- Definition of Interactive Development Mode vs production autonomous agent
- Git as snapshot: conditions under which it is valid
- MUST requirements including mandatory `git status` check before file edits
- The Pre-Edit Snapshot Protocol (5-step sequence)
- Comparison table: Section 6 production requirements vs Section 17 equivalents
- What git cannot provide (uncommitted state, external side effects, secrets)
- NIST AI RMF alignment (MANAGE 2.2, GOVERN 1.3)

### Section 18 — Backup Naming Standard (SPECIFICATION.md)

Defines the AAO Backup Standard for all AI-created backup files. Covers:

- Backup directory: `.aao-backups/` at project root, always
- Naming format: `YYYYMMDD_HHMMSS_<SESSION_ID>/mirrored/path/filename.ext.bak`
- Pre-backup confirmation requirement
- Retention rule: keep last 3 backups per original file
- Cleanup commands: `/aao-backup-status` and `/aao-backup-purge`
- `.gitignore` requirement: `.aao-backups/` must never be committed
- Relationship to Section 17 (git as primary, backup as secondary)
- NIST AI RMF alignment (MANAGE 2.2, GOVERN 1.3)

---

## New Files

| File | Description |
|---|---|
| `docs/12-backup-naming-standard.md` | Full explanation of the backup standard — what it does and why each design decision was made |
| `CHANGELOG_v9.md` | This file |

---

## Modified Files

| File | Change |
|---|---|
| `SPECIFICATION.md` | Section 17 and Section 18 appended. Version bumped v1.1 → v1.2 → v1.3 |
| `docs/06-snapshot-rollback.md` | Subsections 6.4 and 6.5 appended (summary references) |
| `README.md` | docs table updated to include `11-testing-taxonomy.md` and `12-backup-naming-standard.md` |
| `CLAUDE.md` | Pre-Edit Snapshot Rule and Backup Standard sections added |

---

## Files Unchanged

All files not listed above are unchanged from v8.

---

## Breaking Changes

None. Version 9 is fully additive. All v8 implementations remain compliant.

---

## Upgrade Path

**For any project using AAO with Claude Code:**

1. Add Section 17 Pre-Edit Snapshot Rule to your project `CLAUDE.md`
2. Add Section 18 Backup Standard to your project `CLAUDE.md`
3. Add `.aao-backups/` to your project `.gitignore`
4. Begin every Claude Code session with the pre-flight check: `git status`

**For AAO-Methodology contributors:**

- SPECIFICATION.md now at v1.3
- New docs file: `docs/12-backup-naming-standard.md`
- README.md updated

---

## Contact

**Author:** Donald Moskaluk
**Email:** skipperdon@atmyboat.com
**Repository:** github.com/SkipperDon/AAO-Methodology
**License:** Apache 2.0

---

*AAO Methodology Repository v9 | © 2026 Donald Moskaluk*

---

## Addendum — Session Memory Loop (added post v9 release)

**Date:** 2026-03-19

### Problem Identified

The AAO methodology had a complete session-close write sequence but no
corresponding session-start read sequence. MEMORY.md, SESSION_LOG.md, and
PROJECT_CHECKLIST.md were written at every session close but never explicitly
read at session start. The memory system was write-only.

### Changes

**Modified:**
- `CLAUDE.md` — Session-Start Memory Load block added before Required
  Session-Start Acknowledgment. Defines mandatory read sequence for
  MEMORY.md, PROJECT_CHECKLIST.md, and SESSION_LOG.md with a required
  chat summary confirming memory loaded.

**New files:**
- `commands/session-start.md` — new slash command `/project:session-start`
  implementing the full session orientation sequence including pre-flight
  git status check, memory load, and session orientation summary
- `docs/aao-commands-reference.html` — visual command reference showing
  all AAO commands, sprint mode activation phrases, the memory loop
  diagram, and the risk classification table

### The Memory Loop

Session-close writes → MEMORY.md, SESSION_LOG.md, PROJECT_CHECKLIST.md
Session-start reads ← same files

Without the read side, prior corrections and decisions are invisible to
every new session. The loop is now complete.

---

## Addendum — Section 19 Session Quality Metrics

**Date:** 2026-03-19

### What Was Added

**SPECIFICATION.md Section 19** — Session Quality Metrics. Defines five metrics
calculated at every session close: Scope Compliance Rate (SCR), Stop Gate
Compliance Rate (SGCR), Recovery Event Count (REC), Memory Load Success (MLS),
and Unauthorized Action Count (UAC). Combined into a weighted Session Quality
Score (SQS) on a 100-point scale.

**commands/session-close.md** — Step 1B added. Calculation procedure for all
five metrics with exact formulas, interpretation thresholds, and SESSION_LOG
format.

**docs/aao-session-quality.html** — NEW. Visual explainer covering Deming/PDCA
foundation, all five metrics, the SQS formula, grade table, SESSION_LOG example,
improvement loop, and economic case.

### The Foundation

Deming: you cannot improve a system you cannot measure. Sections 3–18 define
the governance process. Section 19 provides the measurement layer — the Check
step in the PDCA cycle made operational for AI-assisted development sessions.

Christensen: systematic measurement converts artisan practice into a reproducible,
improvable process. That transition is the structural advantage that separates
governed teams from ungoverned ones.

Version bumped to v1.4.

---

## Addendum — Section 20 Anti-Sycophancy Protocol + OIC Metric

**Date:** 2026-03-20

### Problem Addressed

Sycophancy is the failure mode where an AI system produces outputs that
feel satisfying and complete rather than outputs that are actually honest
and rigorous. AAO governed behavioral compliance (what Claude Code does)
but had not formally addressed output integrity (whether what Claude Code
produces is honest).

Specific gaps:
- No rule requiring uncertainty to be declared
- No standard requiring session summaries to disclose gaps
- No metric assessing whether outputs were substantive vs superficial
- No checklist item for sycophancy detection

### Changes

**SPECIFICATION.md Section 19** — OIC (Output Integrity Check) added as
sixth metric. SQS formula updated: OIC acts as a binary multiplier — OIC=0
voids the entire session score. Maximum SQS is now 90. Weights redistributed:
SCR and SGCR reduced from 0.30 to 0.25 each to accommodate OIC. Grade
thresholds updated. SESSION_LOG format updated to include OIC line.

**SPECIFICATION.md Section 20** — NEW. Anti-Sycophancy Protocol. Defines:
Uncertainty Declaration Rule, Summary Accuracy Standard, sycophancy detection
patterns, and operator responsibility for OIC assessment.

**CLAUDE.md (both repos)** — Three new sections added: Uncertainty Declaration
Rule, Summary Accuracy Standard, Output Integrity Check. AAO Compliance
Checklist updated with three anti-sycophancy items.

**docs/aao-session-quality.html** — OIC card added to metrics grid. SQS
formula updated to show OIC multiplier. SESSION_LOG example updated.

Version bumped to v1.5.

### The Core Distinction

The five behavioral metrics ask: did Claude Code follow the process?
OIC asks: was the work within the process honest and rigorous?

Both questions are required for a complete quality assessment.
A session can score 90/90 on behavioral metrics while being sycophantic.
OIC closes that gap — and voids the score when sycophancy is detected.

---

## Addendum — Section 21 Execute First, Suggest Second

**Date:** 2026-03-19

### Problem Addressed

Claude Code has been executing its own judgment instead of operator
instructions. When told to increase a font size it kept its preferred
size. When given a structure it restructured it. When given a design
it improved it silently. It conflated execution with opinion and acted
on both simultaneously — an authority inversion where the AI treated
its judgment as superior to an explicit operator instruction.

### Changes

**SPECIFICATION.md Section 21** — Execute First, Suggest Second.
Defines the Execute First Rule (explicit instructions executed exactly
as stated, no silent substitution), the Suggestion Protocol (suggestions
offered after execution, clearly labeled, never acted on without approval),
and Post-Execution Verification (mandatory diff statement after every task
with an explicit instruction or reference).

**SPECIFICATION.md Section 19 UAC** — definition extended: silent
substitution of Claude Code judgment for operator instruction = UAC+1,
even when within sprint scope.

**CLAUDE.md (both repos)** — three new sections added before Autonomous
Operation: Execute First Suggest Second, Suggestion Protocol, Post-Execution
Verification.

Version bumped to v1.6.

### The Core Distinction

Execution follows the operator's authority.
Suggestion is offered for the operator's consideration.
The operator decides. Claude Code informs.

These are different acts. They must never occur simultaneously.

---

## v1.7 — Persistent Knowledge Layer (LLM-Wiki Integration)

**Release Date:** 2026-04-17
**Spec version:** v1.6 → v1.7

---

### Summary

Version 1.7 adds Section 22: Persistent Knowledge Layer — a formal integration
of Andrej Karpathy's LLM-Wiki pattern (April 2026) as an optional but recommended
extension to the AAO loop.

AAO addressed action safety, audit trails, risk classification, and session
discipline. It did not address cross-session knowledge accumulation. Without a
persistent knowledge layer, every session re-derives the same understanding from
raw files. Decisions made in session 3 are unknown in session 20. Contradictions
between modules are re-discovered instead of already flagged. The Analyze phase
wastes context reading cold files instead of distilled knowledge.

Section 22 closes that gap.

---

### What Was Added

**SPECIFICATION.md — Section 22: PERSISTENT KNOWLEDGE LAYER**

Eleven subsections defining the complete integration:

- **22.1 Purpose** — The cold-start problem, why plain AAO accumulates nothing,
  what the wiki layer changes.

- **22.2 Three-Layer Architecture** — Immutable `raw/` (human), AI-maintained
  `wiki/` (entities, concepts, sources, syntheses, questions), shared `schema/`.

- **22.3 Integration with AAO Phases** — Analyze reads `wiki/index.md` + recent
  log before every task. Act checks decision pages and updates wiki in the same
  pass. Observe appends to `wiki/log.md`, runs mini-lint, files syntheses.

- **22.4 Log Entry Format** — Structured format for `wiki/log.md`. Types: ingest,
  query, lint, edit, decision.

- **22.5 Standing Scope Authorization (C1 + C2 conflict resolutions)** — The
  Zero-Inference Rule and per-task File Scope Permissions prohibit touching files
  not in the Phase 1 list. Wiki maintenance is irreconcilable with these rules at
  face value: a single ingest touches 10–15 pages, and `wiki/log.md` must be
  appended after every task. Resolution: `wiki/` is permanently in scope when a
  wiki layer is active. `wiki/log.md` append and mini-lint are standing authorized
  operations exempt from per-task Phase 1 listing. `raw/` remains outside standing
  scope.

- **22.6 Lint Operations** — Six checks: orphan pages, stale claims, contradictions,
  missing concept stubs, broken cross-references, index drift. Contradictions are
  never silently resolved — always filed to `wiki/questions/` for human review.

- **22.7 Relationship to MEMORY.md and SESSION_LOG.md (C4 conflict resolution)** —
  MEMORY.md is the executive index (1-line entries, fast session-start read).
  SESSION_LOG.md is the session governance record. `wiki/log.md` is the task-level
  operation timeline. `wiki/entities/` is the detailed knowledge layer. All four
  are complementary. MEMORY.md SHOULD reference wiki entity pages for detail.

- **22.8 No-Planning Rule (C3 conflict resolution)** — Analyze phase wiki reads
  are internal None-risk reads, not operator-facing planning output. Reading
  `wiki/index.md` before a task is not planning.

- **22.9 Compounding Knowledge Rule** — Non-obvious findings must be written into
  the wiki immediately. Syntheses from three or more sources must be filed to
  `wiki/syntheses/`. Unanswered questions must be filed to `wiki/questions/`.
  Nothing valuable should exist only in chat history.

- **22.10 Compliance Classification** — LLM-Wiki is a Level 3 optional extension.
  Not required for Level 1 or Level 2 compliance. Six requirements for projects
  claiming LLM-Wiki Enhanced AAO compliance.

- **22.11 Reference** — Karpathy gist URL, rationale document path, integration
  authorship.

**CLAUDE.md template — LLM-Wiki extension section**

Optional section added between the AAO Compliance Checklist and Project-Specific
Rules. Contains: directory structure reference, standing scope authorization rules,
Analyze/Act/Observe phase guidance, ingest workflow, compounding knowledge rule,
and MEMORY.md relationship table. Marked optional — skip if project has no wiki layer.

AAO Compliance Checklist updated with one new item:
`If LLM-Wiki layer is active: wiki/log.md appended and mini-lint run after every task`

**research/llm-wiki-integration.md — New**

Rationale document explaining why the pattern is critical to AAO. Covers: the
cold-start problem, per-phase capability improvements, the compounding advantage,
why maintenance is no longer the bottleneck, all four conflict resolutions, and a
summary capability comparison table (plain AAO vs. AAO + LLM-Wiki).

---

### Four Rule Conflicts Identified and Resolved

| # | Conflict | Resolution |
|---|----------|------------|
| C1 | Zero-Inference Rule prohibits touching files not in Phase 1 list; ingest touches 10–15 wiki pages | Standing scope authorization — `wiki/` permanently in scope when wiki layer active (§22.5) |
| C2 | File Scope Permissions are per-task; `wiki/log.md` must append after every task | `wiki/log.md` append + mini-lint are standing authorized, exempt from per-task scope (§22.5) |
| C3 | No-Planning Rule prohibits producing plans; Analyze reads wiki before every task | Wiki pre-reads are internal None-risk reads, not operator-facing output — no real conflict (§22.8) |
| C4 | MEMORY.md + SESSION_LOG.md overlap with wiki/ artifacts | Documented as complementary layers serving different scopes — MEMORY.md is executive index, wiki/ is detailed layer (§22.7) |

---

### Auditability Impact

No existing auditability mechanism was removed or weakened. Sections 1–21 are
unchanged. The wiki layer adds task-level traceability that SESSION_LOG.md does
not provide: named decision pages with citations, discoverable contradiction files,
and structured synthesis records.

One honest caution noted in the spec: wiki pages are AI-synthesised interpretations,
not factual records of actions taken. The lint pass catches stale claims, but the
human remains the final reviewer of wiki accuracy — as they are the final reviewer
of generated code.

---

### Source

Karpathy, Andrej. "LLM Wiki." GitHub Gist, April 2026.
https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f
