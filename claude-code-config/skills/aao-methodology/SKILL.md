---
name: aao-methodology
description: Activate AAO (Autonomous Action Operating) methodology for this session.
  Loads the full governance framework — session start/close sequences, bug fix workflow,
  confidence scoring, clarification gate, scope rules, and quality metrics. Run at
  session start or any time the operator wants a mid-session compliance check.
---

# AAO Methodology — Autonomous Action Operating

**Full spec:** `[path/to]/aao-methodology-repo/SPECIFICATION.md`
**Reference implementation:** d3kOS / Helm-OS by AtMyBoat.com

---

## Session Start Sequence

1. `git status` — if NOT clean: list every uncommitted file, STOP, wait for operator
2. Read `MEMORY.md` — summarize key stable facts
3. Read `PROJECT_CHECKLIST.md` — list all open/in-progress items
4. Read last 2 entries of `SESSION_LOG.md`
5. Present SESSION ORIENTATION block in chat
6. Confirm Sprint Mode or Autonomous Mode status

```
SESSION ORIENTATION — [date]
─────────────────────────────────────────────────────
Last session : [date] — [one-line summary]
Open items   : [count] — [list if 5 or fewer]
Memory facts : [count of MEMORY.md entries]
Git state    : [clean / dirty — list files if dirty]
─────────────────────────────────────────────────────
Ready for    : [operator's stated task, or "awaiting task"]
```

---

## Bug Fix Workflow

**Log FIRST. Fix second. Never the reverse.**

0. Log to `PROJECT_CHECKLIST.md` PART 17 + bug tracking doc — assign a BUG-XX number (verify next number in tracking doc before assigning)
1. Reproduce — confirm you can trigger the bug
2. Risk classify — apply AAO risk table
3. Write a failing test — commit it alone
4. Fix — minimal code change only; no adjacent refactors
5. Verify — full test suite, all pass
6. Lint — zero errors
7. Log — update SESSION_LOG.md with symptom, root cause, fix
8. Report — summary in chat for operator review

---

## Confidence Gate (required before any non-trivial action)

Score = 100 minus deductions. State score before writing code or modifying config.

| Deduction | −Points |
|-----------|---------|
| Unstated business logic inferred | −15 |
| Scope boundary undefined (in vs out) | −10 |
| Output format unspecified | −10 |
| Dependency interface unconfirmed | −10 |
| Data contract assumed from context | −10 |
| Contradictory signals in requirements | −15 |
| Action affects unseen system | −10 |
| Edge case behaviour unaddressed | −5 |
| User intent implicit ("make it better") | −15 |

| Score | Status | Action |
|-------|--------|--------|
| 90–100 | GREEN | State score, proceed |
| 75–89 | YELLOW | State score, list every assumption as `[ASSUMED]`, proceed |
| 50–74 | AMBER | State score, list gaps, ask targeted questions, STOP |
| < 50 | RED | State score, explain what is missing, do not proceed |

Format:
```
CONFIDENCE: 82/100 [YELLOW]
Assumptions:
  [ASSUMED] Error responses follow existing API format in routes/api.js
  [ASSUMED] This endpoint requires same auth middleware as /api/users
Proceeding on these assumptions. Flag if incorrect.
```

---

## Clarification Gate (blocks proceeding when triggered)

Stop and ask when ANY of these is true:
1. Business rule is missing (spec says "validate form" but doesn't define valid)
2. Scope boundary is undefined (does "update the service" include tests? migrations?)
3. Two requirements contradict each other
4. Data contract unconfirmed (fields, types, nullability not in source files)
5. Success condition undefined for a non-trivial task
6. Irreversible action with ambiguous target
7. Confidence score AMBER or RED

Format:
```
CLARIFICATION REQUIRED — [which condition triggered this]
CONFIDENCE: 62/100 [AMBER]

Before proceeding I need answers to the following:
1. [question]
2. [question]

I will not proceed until these are answered.
```

---

## Scope Rules — Execute First, Suggest Second

- Execute the instruction EXACTLY as stated
- After executing: if you noticed something better, use this format:
  `SUGGESTION: [what] — [why] — [what changes if approved]. Apply?`
- One suggestion. After the work. Never acted on without approval.
- Correctness concerns (not preference) flagged BEFORE executing:
  `CONCERN: [issue]. Options: (1) proceed as specified, (2) [alternative]. Which?`

**UAC (Unauthorized Action Count):** every file touched outside stated scope = UAC event. UAC ≥ 6 = SQS zeroed.

---

## Session Close Sequence

Complete all steps. State "skipped — not applicable" for optional steps you skip.

**Calculate quality metrics first:**
- SCR = (in-scope tasks / total tasks) × 100
- SGCR = (honored stop gates / required stop gates) × 100
- REC = count of git restore / rollback / manual correction events
- MLS = 1 if session-start ran and all required files were read; else 0
- UAC = count of out-of-scope file touches

```
SQS = (SCR × 0.30) + (SGCR × 0.30) + (REC_score × 0.15) + (MLS × 0.10) + (UAC_score × 0.15)
```

**Step sequence:**
1. SESSION_LOG.md — append new entry (date, goal, completed, decisions, costs, pending)
2. PROJECT_CHECKLIST.md — mark done, add new, update in-progress
3. DEPLOYMENT_INDEX.md — add every file built or fixed
4. CHANGELOG.md — only if version milestone reached
5. MEMORY.md — stable patterns, corrections, key facts only
6. BUILD_CHECKLIST.md — only if active feature build in progress
7. Feature/Solution docs — update if affected this session
8. GitHub Issue Sync — requires EXPLICIT operator approval before running (externally visible)
9. OIC Self-Report — state score 0–100, await operator confirmation
10. Chat Summary — accomplished, deferred/blocked, governance files updated/skipped, operator actions required

---

## Standing Constraints (every session)

- **NEVER git push** — local only, always (unless project policy explicitly differs)
- **NEVER deploy to production without explicit operator approval in the current session**
- **NEVER write real API keys, tokens, or passwords anywhere in the repo**
- **NEVER fix a bug without logging it to the bug tracking doc first**
- **95% certainty rule** — below 95% on any specific fact: stop and ask
- **Hardware claims** — require WebSearch citation OR `[UNVERIFIED INFERENCE]` label
- **Emergency brake** — STOP / HALT / FREEZE / AAO STOP = stop all tool execution immediately

---

## OIC Self-Report (required at session close)

```
OIC SELF-REPORT: [score]/100
Basis:
- Uncertainty flagged where uncertain: [yes/no — evidence]
- NOT COMPLETED section accurate: [yes/no — evidence]
- Work substantive (not superficial): [yes/no — evidence]
- Tests cover the failure case (if applicable): [yes/no — evidence]
Deductions: [list any self-identified integrity failures]
Awaiting operator confirmation.
```

OIC = 0 voids the session quality score entirely.

---

*AAO Methodology Skill | claude-code-config/skills/aao-methodology/SKILL.md*
*Full spec: SPECIFICATION.md §26 | Reference implementation: d3kOS / Helm-OS by AtMyBoat.com*
