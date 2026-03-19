# AAO Backup Naming Standard

## How Claude Code Manages File Backups — What It Does and Why

**Document:** `docs/12-backup-naming-standard.md`
**Spec reference:** SPECIFICATION.md Section 18
**Related:** `SPECIFICATION.md Section 17`, `docs/06-snapshot-rollback.md`
**Version:** 1.0 | 2026-03-19

---

## The Problem This Solves

Claude Code and every equivalent AI coding assistant — Cursor, Copilot, any
agentic tool — has no automatic backup mechanism. When you ask it to edit a file,
it writes directly to the live file using `str_replace` or `write_file`. No copy
is made. No `.bak` is created. The prior state is overwritten immediately.

When you explicitly ask Claude Code to make a backup before editing, it will
create a copy — but using whatever name it generates on the fly. Across different
sessions the same instruction produces different results:

- `filename.bak`
- `filename.backup`
- `filename_backup_2026-03-19.js`
- `filename.YYYYMMDD.js`
- `filename_orig.js`

There is no standard. The name is invented per session with no persistence.

At small scale this is an inconvenience. At production scale — a project with
hundreds of files, dozens of sessions, and thousands of backup files across weeks
of AI-assisted development — it becomes a genuine governance failure:

- No reliable way to find all backups for a specific file
- No reliable way to know which session created which backup
- No reliable way to determine which backups are safe to delete
- No audit trail connecting a backup to the change that triggered it
- Backup files scattered throughout the project tree mixed with source code

The AAO Backup Naming Standard closes this gap permanently.

---

## The Standard

### One Directory. Always.

All backup files created by Claude Code under this methodology live in one place:

```
.aao-backups/
```

This directory is always at the project root. Backup files are never created
alongside the original file. Never in a temp directory. Never anywhere else.

This single decision makes everything else manageable:

```bash
# Find every backup ever created in this project
find .aao-backups -name "*.bak"

# Find all backups for a specific file
find .aao-backups -path "*/src/config/database.js.bak"

# Find all backups from a specific session
ls .aao-backups/20260319_143205_a3f9/

# Purge a specific session's backups
rm -rf .aao-backups/20260319_143205_a3f9/
```

One directory. One command to find anything. One command to clean anything.

---

### The Naming Format

```
.aao-backups/YYYYMMDD_HHMMSS_<SESSION_ID>/<mirrored/original/path>/filename.ext.bak
```

**Broken down:**

| Component | Format | Example | Purpose |
|---|---|---|---|
| Root directory | `.aao-backups/` | `.aao-backups/` | Single location for all backups |
| Session folder | `YYYYMMDD_HHMMSS_<SESSION_ID>` | `20260319_143205_a3f9` | Groups all backups from one session |
| Mirrored path | Original relative path | `src/config/` | Prevents name collisions |
| Backup filename | `original.ext.bak` | `database.js.bak` | Unambiguous — always `.bak` appended |

**Complete example:**

Backing up `src/config/database.js` during session `a3f9` on March 19 2026
at 14:32:05 UTC produces:

```
.aao-backups/20260319_143205_a3f9/src/config/database.js.bak
```

---

### Why Each Component Was Designed This Way

**Date-time first in the session folder name (`YYYYMMDD_HHMMSS`)**

ISO 8601 date format at the start of the folder name means every file explorer,
every `ls` command, every terminal listing shows session folders in chronological
order automatically. No sorting required. Newest sessions appear last. You always
know the order without reading metadata.

**Session ID appended (`_a3f9`)**

The first 4 characters of the Claude Code session identifier make every folder
name unique even if two sessions start at the exact same second. More importantly,
they create a direct link between the backup and the session log — you can look
up session `a3f9` in your `SESSION_LOG.md` and understand exactly what was being
worked on when this backup was created.

**One folder per session**

All backups created during a single Claude Code session share one folder. The
timestamp is set when the first backup of the session is created and never changes.
This means:

- A session that went sideways has all its backups in one folder — one `rm -rf`
  to undo everything it touched
- The session folder is the unit of cleanup, not individual files
- You can see at a glance how many sessions touched a given part of the project

**Mirrored path inside the session folder**

Two files named `config.yaml` in `src/` and `tests/` would collide if only the
filename were preserved. Mirroring the full path from project root inside the
session folder means:

```
.aao-backups/20260319_143205_a3f9/src/config.yaml.bak
.aao-backups/20260319_143205_a3f9/tests/config.yaml.bak
```

No collision. And the backup path tells you exactly where to restore — you read
the path, you know the destination.

**`.bak` appended, original extension never replaced**

`database.js.bak` makes it unambiguous that this is a backup of a `.js` file.
If the extension were replaced (`database.bak`), you lose the original type
information and syntax highlighting in any editor that opens the file. Appending
preserves both: the file is still recognizable as JavaScript, and `.bak` signals
it is a backup copy.

---

## Git and Backups Are Not the Same Thing

A common question: if git provides rollback (Section 17, Interactive Development
Mode), why do explicit backups exist at all?

They serve different purposes.

**Git (Section 17) is the primary recovery mechanism.** Before any session starts,
`git status` must be clean. That clean commit is the rollback point. If Claude Code
modifies files during the session and something goes wrong, `git restore` recovers
from that checkpoint.

**Explicit backups (Section 18) are a secondary mechanism** for situations where:

- The operator wants to see the before/after state of a specific file without
  switching git branches or reading diffs
- The operator wants to preserve a specific intermediate state during a complex
  multi-step operation
- The operator explicitly asks for a backup before a particularly risky edit
- The working tree is not clean (a prior session left uncommitted changes) and
  the operator has acknowledged the risk and authorized proceeding

The two mechanisms are independent. Both can be active in the same session.
Section 17 is always active. Section 18 activates when a backup is requested.

---

## Cleanup: How It Works

### The Retention Rule

The system retains the **3 most recent session backups per original file**.
Backups beyond that are eligible for purge.

Why 3? Enough to provide a short recovery window across multiple sessions. Not
so many that the backup directory becomes unmanageable.

### The Commands

Two commands manage the entire backup lifecycle:

**`/aao-backup-status`** — Shows every backup file, its session, its age, and
whether it is eligible for purge. Read-only. Never deletes anything.

```
AAO BACKUP STATUS — 2026-03-19
────────────────────────────────────────────────────────────────────
SESSION                    FILE                                AGE
────────────────────────────────────────────────────────────────────
20260319_143205_a3f9  src/config/database.js.bak          current session
20260318_091012_b7c2  src/config/database.js.bak          1 day ago
20260317_163344_f1e0  src/config/database.js.bak          2 days ago
20260315_110022_d4a1  src/config/database.js.bak          4 days ago  ← eligible
────────────────────────────────────────────────────────────────────
TOTAL: 4 backup files across 4 sessions
ELIGIBLE FOR PURGE: 1 file (exceeds 3-most-recent limit)
────────────────────────────────────────────────────────────────────
Run /aao-backup-purge to review and confirm deletion.
```

**`/aao-backup-purge`** — Lists every file eligible for deletion with its reason,
then waits for explicit confirmation before deleting anything.

Claude Code will never purge a backup without:
1. Listing every file that will be deleted
2. Showing the reason each file is eligible
3. Receiving an unambiguous confirmation from the operator
4. Reporting exactly what was deleted after the purge completes

Automatic cleanup never runs. Purge only happens when the operator triggers it.

### Never Purge the Current Session

The current session's backup folder is never eligible for automatic cleanup.
It becomes eligible only after the session has been committed and closed.

This ensures that if a session goes sideways, its backups remain intact for
recovery until the operator has explicitly confirmed the session's work is good.

---

## Git Integration

The `.aao-backups/` directory must always be in `.gitignore`:

```
# AAO backup files (AAO Methodology Section 18 — never commit backup files)
.aao-backups/
```

Backup files are operational artifacts, not source code. They must never be
committed to version control. They are not part of the project history.
They are a safety net for the development session, and they live entirely
outside the git tracking boundary.

Claude Code verifies this `.gitignore` entry exists before creating the first
backup of any session. If it is absent, Claude Code adds it before creating
the backup.

---

## Pre-Backup Confirmation

Before creating any backup, Claude Code states the full target path in chat:

```
Creating backup: .aao-backups/20260319_143205_a3f9/src/config/database.js.bak
```

This gives the operator the opportunity to stop before the backup is created.
Proceeding with the conversation counts as acknowledgment.

This confirmation is not optional. It is part of the audit trail — the operator
always knows exactly where a backup was created before it exists.

---

## Relationship to the AAO Specification

This document implements **SPECIFICATION.md Section 18 (Backup Naming Standard)**
in practical terms. The specification defines the normative MUST requirements.
This document explains the reasoning behind each design decision.

The standard fits within the broader AAO recovery architecture:

| Layer | Mechanism | When It Applies |
|---|---|---|
| Production autonomous agent | Action Layer snapshot (Section 6) | Deployed system with Layer 3 infrastructure |
| Interactive development — primary | Git clean working tree (Section 17) | Every session start, automatically |
| Interactive development — secondary | Explicit file backup (Section 18) | When operator requests a backup |

All three mechanisms serve the same guarantee: **the system is always recoverable
regardless of what the AI does.**

---

## Summary

The AAO Backup Naming Standard exists because consistency at scale requires
a standard — not a suggestion.

Without it: `.bak` files scattered across the project tree, named differently
every session, with no connection to the session that created them and no
systematic way to clean them up.

With it: one directory, one format, one set of commands, and a complete audit
trail connecting every backup to the session, the file, and the time it was made.

Simple. Predictable. Auditable.

---

*AAO Methodology | docs/12-backup-naming-standard.md*
*Spec reference: SPECIFICATION.md Section 18*
*© 2026 Donald Moskaluk | Apache 2.0*
