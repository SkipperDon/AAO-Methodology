# AAO Project Installation — One-Time Setup
**Run this once in any new project to deploy the full AAO infrastructure.**
**Risk Level: Low | No push without explicit approval** 

---

## SESSION ACKNOWLEDGMENT

Before any other action, state:

> "I have read this instruction in full. This is a one-time AAO installation
> for this project. I will create all required files and directories, verify
> each one exists, and present a completion report. I will not modify any
> existing project files. I will stop if anything is unexpected."

---

## WHAT THIS INSTALLS

```
[project-root]/
├── .claude/
│   └── commands/
│       ├── session-start.md        ← /project:session-start
│       ├── session-close.md        ← /project:session-close
│       ├── methodology-check.md    ← /project:methodology-check
│       └── bug-fix.md              ← /project:bug-fix
├── CLAUDE.md                       ← governing document (if not present)
├── MEMORY.md                       ← persistent memory (if not present)
├── PROJECT_CHECKLIST.md            ← task tracking (if not present)
├── SESSION_LOG.md                  ← session history (if not present)
└── .gitignore                      ← .aao-backups/ entry added
```

---

## PRE-FLIGHT

**Risk: None**

```bash
# Confirm project root
git rev-parse --show-toplevel

# Confirm AAO-Methodology repo is available
find ~ -path "*/AAO-Methodology/commands/session-start.md" 2>/dev/null | head -1

# Check working tree
git status

# Check what already exists
ls -la .claude/commands/ 2>/dev/null || echo ".claude/commands/ does not exist yet"
ls CLAUDE.md MEMORY.md PROJECT_CHECKLIST.md SESSION_LOG.md 2>/dev/null
```

Report findings. Flag anything unexpected.

**If AAO-Methodology repo is not found locally:**
> STOP. State: "AAO-Methodology repository not found on this machine.
> Please confirm the path or clone it from github.com/SkipperDon/AAO-Methodology
> before running this installation."

**If working tree is NOT clean:**
> STOP. List uncommitted files. State: "Working tree is dirty. Please commit
> or stash changes before installing AAO. This ensures the installation is
> cleanly separable from prior work."

**STOP. Wait for operator confirmation before proceeding.**

---

## STEP 1 — Create .claude/commands/ directory

**Risk: None (directory creation)**

```bash
mkdir -p .claude/commands/
```

Confirm directory was created. State the full path.

---

## STEP 2 — Copy all command files

**Risk: Low**

```bash
AAO_COMMANDS="[PATH_TO_AAO_REPO]/commands"

cp "$AAO_COMMANDS/session-start.md"     .claude/commands/session-start.md
cp "$AAO_COMMANDS/session-close.md"     .claude/commands/session-close.md
cp "$AAO_COMMANDS/methodology-check.md" .claude/commands/methodology-check.md
cp "$AAO_COMMANDS/bug-fix.md"           .claude/commands/bug-fix.md
```

Verify each file exists after copying:

```bash
ls -la .claude/commands/
```

State each file name and confirm all four are present.
If any copy failed: state which one and why. Do not continue until all four exist.

---

## STEP 3 — Create CLAUDE.md (if not present)

**Risk: Low**

Check: does `CLAUDE.md` exist in the project root?

**If YES:** State "CLAUDE.md already exists — not overwriting. Operator should
verify it contains the AAO Sprint Mode, Backup Standard, Uncertainty Declaration,
Pre-Edit Snapshot Rule, and OIC sections. Run /project:methodology-check to audit."

**If NO:** Copy the AAO template:

```bash
cp "[PATH_TO_AAO_REPO]/CLAUDE.md" ./CLAUDE.md
```

Then state: "CLAUDE.md created from AAO template. You must fill in the
[PLACEHOLDER] sections for this project before the first session:
- Project name, primary repo, deploy target, primary languages
- Architecture rules (what Claude can and cannot touch)
- Deploy rules
- Never Do list
- Git push policy"

---

## STEP 4 — Create memory files (if not present)

**Risk: Low — create only, never overwrite**

For each file, check if it exists. Create only if absent.

**MEMORY.md:**
```bash
if [ ! -f MEMORY.md ]; then
cat > MEMORY.md << 'EOF'
# MEMORY.md — AAO Persistent Session Memory

## Architecture Decisions
[Add stable architectural decisions here as they are confirmed]

## Confirmed Patterns
[Add patterns that Claude Code should always follow in this project]

## Prior Corrections
[Add things Claude Code got wrong that must not be repeated]

## Project-Specific Rules
[Add rules specific to this project's stack and context]

---
*Updated by /project:session-close at end of each session*
*Read by /project:session-start at start of each session*
EOF
echo "MEMORY.md created"
else
  echo "MEMORY.md already exists — not overwritten"
fi
```

**PROJECT_CHECKLIST.md:**
```bash
if [ ! -f PROJECT_CHECKLIST.md ]; then
cat > PROJECT_CHECKLIST.md << 'EOF'
# PROJECT_CHECKLIST.md — Task Tracking

## Active Tasks
- [ ] [Add your current tasks here]

## Completed
[Tasks move here when done — never deleted]

## Discovered / Backlog
[Tasks identified during sessions but not yet scheduled]

---
*Updated by /project:session-close*
*Read by /project:session-start*
EOF
echo "PROJECT_CHECKLIST.md created"
else
  echo "PROJECT_CHECKLIST.md already exists — not overwritten"
fi
```

**SESSION_LOG.md:**
```bash
if [ ! -f SESSION_LOG.md ]; then
cat > SESSION_LOG.md << 'EOF'
# SESSION_LOG.md — Session History

## Format (append only — never edit prior entries)

---
**Date:** YYYY-MM-DD
**Goal:** [what was attempted]
**Completed:** [what was actually done]
**Deferred:** [what was not done and why]
**Decisions:** [architectural or design decisions made]
**Quality Metrics:** SCR: % | SGCR: % | REC: | MLS: | UAC: | OIC: | SQS: /90
---

EOF
echo "SESSION_LOG.md created"
else
  echo "SESSION_LOG.md already exists — not overwritten"
fi
```

---

## STEP 5 — Add .aao-backups/ to .gitignore

**Risk: Low**

Check if `.gitignore` already contains `.aao-backups/`:

```bash
grep -q "\.aao-backups" .gitignore 2>/dev/null && echo "already present" || echo "needs adding"
```

If not present, append:

```bash
cat >> .gitignore << 'EOF'

# AAO backup files (AAO Methodology Section 18 — never commit backup files)
.aao-backups/
EOF
echo ".aao-backups/ added to .gitignore"
```

If already present: state "`.aao-backups/` already in `.gitignore` — no change needed."

---

## STEP 6 — Verify complete installation

**Risk: None**

Run a final verification pass:

```bash
echo "=== AAO INSTALLATION VERIFICATION ==="
echo ""
echo "Commands directory:"
ls -la .claude/commands/
echo ""
echo "Project files:"
for f in CLAUDE.md MEMORY.md PROJECT_CHECKLIST.md SESSION_LOG.md; do
  [ -f "$f" ] && echo "  ✓ $f" || echo "  ✗ $f MISSING"
done
echo ""
echo ".gitignore check:"
grep "aao-backups" .gitignore && echo "  ✓ .aao-backups/ present" || echo "  ✗ .aao-backups/ MISSING"
echo ""
echo "=== END VERIFICATION ==="
```

Present the full output. If anything shows ✗: state what is missing and why,
and fix it before proceeding to the commit.

---

## STEP 7 — Commit the installation

**Risk: Low (local only)**

Stage only the AAO installation files:

```bash
git add .claude/commands/session-start.md
git add .claude/commands/session-close.md
git add .claude/commands/methodology-check.md
git add .claude/commands/bug-fix.md
git add CLAUDE.md
git add MEMORY.md
git add PROJECT_CHECKLIST.md
git add SESSION_LOG.md
git add .gitignore
```

Commit with:

```
chore(aao): install AAO Methodology governance infrastructure

One-time project setup for AAO Autonomous Action Operating Methodology.

Installs:
  .claude/commands/session-start.md      ← /project:session-start
  .claude/commands/session-close.md      ← /project:session-close
  .claude/commands/methodology-check.md  ← /project:methodology-check
  .claude/commands/bug-fix.md            ← /project:bug-fix
  CLAUDE.md                              ← governing document (from AAO template)
  MEMORY.md                              ← persistent session memory
  PROJECT_CHECKLIST.md                   ← task tracking
  SESSION_LOG.md                         ← session history
  .gitignore                             ← .aao-backups/ entry added

NOTE: CLAUDE.md [PLACEHOLDER] sections must be filled in for this project
before the first governed session.

Methodology: github.com/SkipperDon/AAO-Methodology
Spec: v1.5
```

State: "Installation committed locally. Not pushed."

---

## COMPLETION REPORT

After all steps, present:

```
AAO INSTALLATION COMPLETE
─────────────────────────────────────────────────────
Project      : [project name from git]
Installed    : [date]
Spec version : v1.5

Commands installed:
  ✓ /project:session-start
  ✓ /project:session-close
  ✓ /project:methodology-check
  ✓ /project:bug-fix

Files created or verified:
  ✓ CLAUDE.md
  ✓ MEMORY.md
  ✓ PROJECT_CHECKLIST.md
  ✓ SESSION_LOG.md
  ✓ .gitignore (.aao-backups/ entry)

─────────────────────────────────────────────────────
NEXT STEPS FOR OPERATOR:

1. Fill in the [PLACEHOLDER] sections in CLAUDE.md
   (project name, architecture rules, deploy rules, git policy)

2. Open a new Claude Code session and run:
   /project:session-start
   It should now work.

3. Activate Sprint Mode for your first governed session:
   Sprint mode: ON — [describe what you want to accomplish]
─────────────────────────────────────────────────────
```

---

## WHAT SUCCESS LOOKS LIKE

- [ ] `.claude/commands/` exists with all four .md files
- [ ] `CLAUDE.md` exists (created or pre-existing)
- [ ] `MEMORY.md` exists (created or pre-existing)
- [ ] `PROJECT_CHECKLIST.md` exists (created or pre-existing)
- [ ] `SESSION_LOG.md` exists (created or pre-existing)
- [ ] `.gitignore` contains `.aao-backups/`
- [ ] All files committed locally
- [ ] No existing project files were modified
- [ ] Completion report presented with next steps

---

*AAO Methodology v9 · Spec v1.5*
*Run once per project. Everything AAO needs, in one shot.*
*github.com/SkipperDon/AAO-Methodology*
