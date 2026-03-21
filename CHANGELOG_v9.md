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
