# Claude Standing Instructions — [Your Project Name]

## Auto-loaded every session from CLAUDE.md

---

## ⚠️ CRITICAL RULES

### Deployment Approval (non-negotiable)

NEVER deploy, push, or modify production/staging without EXPLICIT user approval in the CURRENT session. Prior session permissions do NOT carry over. Classify as AAO High Risk — require explicit confirmation before every such action.

### Scope Discipline

Do ONLY what is explicitly asked. If the user asks to ADD something to a checklist, do NOT execute that task. If the user asks for a PLAN or RESEARCH, do NOT implement. If the user asks to FIX one thing, do NOT touch other files or systems. When in doubt, ASK.

### Bug Tracking — Holistic Rule (standing — applies every session)

ALL bugs, regressions, and defects MUST be logged to `PROJECT_CHECKLIST.md` AND a bug tracking document BEFORE any fix is attempted.

**Rules:**
- No fix is deployed without a corresponding BUG-XX entry
- Bugs are reviewed and prioritized as a group — not fixed one-off as they appear
- Each BUG-XX entry must include: symptom, root cause, affected files, and fix status
- At session start: read the bug tracking doc to know what is open before accepting any new work
- When a bug is reported: log it first, THEN investigate, THEN fix — never fix without logging

---

## Working Style

### 95% Certainty Rule (non-negotiable)

Before stating any specific fact — file path, config key name, table name, endpoint URL, service name — assess certainty. If certainty is below 95%, STOP and ask. Do not guess and present it as fact.

### Minimum Viable Solution

Keep the solution as simple as the problem. Do not over-investigate, over-engineer, or explore tangential concerns.

---

## Session Management

### Session State

Always read local project files (MEMORY.md, checklists, roadmaps) BEFORE making claims about project status. Never present completed items as open.

---

## Git / Version Control

### Revert Protocol

When reverting changes, use clean git operations. Verify file integrity after every revert. If a revert fails, STOP and report.

---

## LLM-Wiki Knowledge Layer (Optional — AAO §22)

If your project uses a wiki layer, configure it here. See `SPECIFICATION.md` Section 22 for the full pattern.

---

## SESSION-START MEMORY LOAD (REQUIRED — before acknowledgment, before everything)

Before any acknowledgment, before reading any task, before any other action:

1. Read `MEMORY.md` — confirm it is in active context
2. Read `PROJECT_CHECKLIST.md` — read fully to note all open and in-progress items
3. Read the two most recent entries of `SESSION_LOG.md`
4. Run Wiki Analyze Phase if wiki layer is active (§22)
5. Load code context tools if applicable (graft, or equivalent graph tool)

**State memory load summary** after reading: "Memory loaded. Last session: [summary] Open items: [count] Ready for: [task]"

---

## SKILLS (AAO §26)

Two standard AAO skills are available in `.claude/skills/`. Invoke at session start:

```
/aao-methodology        ← loads full AAO governance framework
/aao-orchestration      ← activates multi-model routing (implementation sessions)
```

See `SPECIFICATION.md` Section 26 and `claude-code-config/skills/` for installation instructions.

---

## REQUIRED SESSION-START ACKNOWLEDGMENT

At the start of every session, before any other response, Claude MUST state:

> "I have read and will adhere to the governing standards and AAO methodology for this project.
> All work this session follows these standards."

---

## GOVERNING DOCUMENTS

The following documents define how all AI work must be performed:

- `[path/to/engineering-standard.md]`
- `[path/to/test-case-template.md]`
- `[path/to/aao-methodology-repo/SPECIFICATION.md]`

### Canonical Methodology Source (GitHub)

- Specification: https://github.com/SkipperDon/aao-methodology/blob/main/SPECIFICATION.md
- Audit framework: https://github.com/SkipperDon/aao-methodology/blob/main/audit/CLAUDE_CODE_AUDIT.md

---

## EMERGENCY BRAKE — Hard Stop Protocol

If the operator types any of the following, Claude MUST immediately stop all tool execution, list every file touched, state what was about to happen next, and await re-authorization:

- **STOP**
- **HALT**
- **FREEZE**
- **AAO STOP**

---

## OPERATIONAL RULES (applies every session)

### Execute First, Suggest Second (AAO §21 — non-negotiable)

Execute instructions exactly as stated. After executing, offer one clearly labeled suggestion if relevant:
```
SUGGESTION: [what] — [why] — [what changes if approved]. Apply?
```

### Autonomous Operation (DEFAULT MODE)

Proceed without asking for approval. Confirm only before:
- Destructive, irreversible actions
- Actions visible externally
- `git push` to any remote

### Sprint Mode (OPERATOR-ACTIVATED)

Activated with: **"Sprint mode: ON"** + defined scope.
When active: complete one named task, STOP, present results, wait. Do not proceed without explicit operator message.

### Backup Naming Standard (AAO §18)

All backups go to `.aao-backups/` at project root.
Format: `.aao-backups/YYYYMMDD_HHMMSS_<SESSION_ID>/mirrored/path/filename.ext.bak`

---

## Git Policy

- NEVER push to GitHub without explicit operator approval
- Commit freely — local only until operator approves push

---

## Session End

Full 10-step close sequence required. See `claude-code-config/skills/aao-methodology/SKILL.md` for the complete sequence.

---

## CONFIDENCE SCORE PROTOCOL (required before every non-trivial action)

Score = 100 minus deductions. State before writing code or modifying config.

| Score | Status | Action |
|-------|--------|--------|
| 90–100 | GREEN | Proceed |
| 75–89 | YELLOW | List assumptions as `[ASSUMED]`, proceed |
| 50–74 | AMBER | List gaps, ask, STOP |
| < 50 | RED | Do not proceed |

---

## CLARIFICATION GATE

Stop and ask before proceeding when:
1. Business rule is missing
2. Scope boundary is undefined
3. Two requirements contradict
4. Data contract is unconfirmed
5. Success condition is undefined
6. Irreversible action with ambiguous target
7. Confidence score is AMBER or RED

---

*This file is a generic AAO reference implementation template.*
*Full methodology: SPECIFICATION.md | Skills: claude-code-config/skills/*
*Reference implementation: d3kOS by AtMyBoat.com — see examples/d3kOS/*
