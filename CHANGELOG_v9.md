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
