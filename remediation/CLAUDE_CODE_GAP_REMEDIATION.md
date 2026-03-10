# Claude Code — Gap Remediation & Adherence Setup

> This document is handed directly to Claude Code as a task list to bring a project
> into full AAO methodology compliance.
> Produced: March 2026 — AtMyBoat.com / d3kOS

---

## TASK 1 — Update CLAUDE.md Document Paths

Update GOVERNING DOCUMENTS and TECHNICAL REFERENCE DOCUMENTS sections in
`/home/boatiq/CLAUDE.md` to use .md extensions:

```
- /home/boatiq/1 Master AI Engineering & Testing Standard.md
- /home/boatiq/1 standar test case creation template.md
- /home/boatiq/1 AI Egnieering & Automated Testing Specification Template.md
- /home/boatiq/1 AI Egineering SPecification & Soltuion Design Template.md
- /home/boatiq/aao-methodology-repo/SPECIFICATION.md
- /home/boatiq/1 openCPN using flatback.md → deployed to Helm-OS/deployment/docs/OPENCPN_FLATPAK_OCHARTS.md
```

Confirm paths exist on disk before saving.

---

## TASK 2 — Add Context Management Section to CLAUDE.md

Add under OPERATIONAL RULES:

```markdown
## Context Management (REQUIRED)

- At 50% context usage: run /compact and summarise current task state before continuing
- When switching between d3kOS and v0.9.3 work: run /clear — never carry state between projects
- If context was compacted: re-read the AAO checklist before the next action
- Never assume earlier instructions are still active after /compact
```

---

## TASK 3 — Add TDD Gate to CLAUDE.md

Add under Testing Standards:

```markdown
### TDD Rule (non-negotiable)
For any bug fix: write a failing test that reproduces the bug FIRST.
The fix is only written after the failing test exists.
A test written after the fix is not a test — it is documentation.
```

---

## TASK 4 — Add Definition of Done to CLAUDE.md

Add under OPERATIONAL RULES:

```markdown
## Definition of Done (every task)

A task is NOT complete until ALL of the following are true:
- [ ] Tests written (if applicable) and all passing
- [ ] Linter reports zero errors
- [ ] Type checker passes (if applicable)
- [ ] SESSION_LOG.md updated with this task's changes
- [ ] Release Package Manifest produced if any Pi deploy occurred
- [ ] AAO checklist verified (risk classified, pre-actions stated, no scope creep)
- [ ] Summary presented in chat for Don's review
```

---

## TASK 5 — Create Custom Slash Commands

Create `/home/boatiq/.claude/commands/` if it does not exist, then create:

**bug-fix.md**
```markdown
## Bug Fix — AAO Compliant Workflow

1. Reproduce — confirm you can trigger the bug
2. Risk classify — apply AAO risk table before any action
3. Write a failing test — write a test that fails because of the bug, commit it
4. Fix — make the minimal code change, do not refactor unrelated code
5. Verify — run the full test suite, all tests must pass
6. Lint — run linter, zero errors required
7. Log — update SESSION_LOG.md: bug description, root cause, fix applied
8. Report — present summary in chat for Don's review
```

**session-close.md**
```markdown
## Session Close — AAO Compliant

1. Verify AAO checklist is complete
2. List every file changed this session
3. Produce Release Package Manifest if any Pi deploy occurred
4. Write SESSION_LOG.md entry — complete, not summarised
5. Confirm no git push was executed
6. Present full session summary in chat for Don's review
```

**methodology-check.md**
```markdown
## Methodology Self-Audit

1. Did you read the relevant module before editing it? (Y/N)
2. Did you state a plan before writing code? (Y/N)
3. Did you classify risk before every action? (Y/N)
4. Did you give a pre-action statement for every Low+ risk action? (Y/N)
5. Did you write tests before or alongside code? (Y/N)
6. Did all tests pass at the end of your last change? (Y/N)
7. Did you stay within the scope of the stated task? (Y/N)
8. Did you modify any forbidden files or paths? (Y/N)
9. Is SESSION_LOG.md up to date? (Y/N)

If any answer is N — stop and remediate before proceeding.
Report results to Don.
```

---

## TASK 6 — Configure Hooks

Create or merge into `/home/boatiq/.claude/settings.json`:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write",
        "hooks": [
          {
            "type": "command",
            "command": "cd /home/boatiq && if ls *.py 2>/dev/null | grep -q .; then ruff check . && echo 'LINT PASSED' || echo 'LINT FAILED — fix before continuing'; fi"
          }
        ]
      }
    ],
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "echo 'BEFORE CLOSING: confirm — (1) tests passing, (2) lint clean, (3) SESSION_LOG.md updated, (4) AAO checklist complete, (5) no git push executed.'"
          }
        ]
      }
    ]
  }
}
```

---

## TASK 7 — Adherence Test

After Tasks 1–6, perform and report:

1. **Document Accessibility** — read first 10 lines of each governing .md file, report readable/unreadable
2. **CLAUDE.md Completeness** — confirm all required sections exist
3. **Commands Exist** — confirm all three command files are non-empty
4. **Hooks Active** — confirm settings.json contains PostToolUse and Stop hooks
5. **AAO Simulation** — state (do not execute) what you would do for:
   - Delete a log file
   - Modify a systemd unit
   - Run git push

---

## SESSION CLOSE

1. Run `/methodology-check`
2. Write SESSION_LOG.md entry
3. Present summary to Don for sign-off
