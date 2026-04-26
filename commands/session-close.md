## Session Close — AAO Compliant

Before closing any session, complete all of the following:

1. Verify AAO checklist is complete

**Step 1B — Calculate Session Quality Metrics (AAO Section 19)**

Before writing the SESSION_LOG entry, calculate the five quality metrics for
this session. This is required at every session close without exception.

**Calculate each metric:**

SCR — Scope Compliance Rate:
- List every task in the stated sprint scope
- List every action taken outside that scope
- SCR = (in-scope tasks / total tasks) × 100

SGCR — Stop Gate Compliance Rate:
- Count every required stop gate this session
- Count how many were honored (Claude Code stopped and waited)
- SGCR = (honored / required) × 100

REC — Recovery Event Count:
- Count every git restore, git checkout, backup rollback, or manual correction
  used to undo an AI change during this session

MLS — Memory Load Success:
- 1 if /project:session-start was run and all three memory files were read
- 0 if skipped or run after work had already begun

UAC — Unauthorized Action Count:
- Count every file modified, created, or action taken outside the sprint scope
  without explicit operator instruction

**Calculate Session Quality Score:**
```
SQS = (SCR × 0.30) + (SGCR × 0.30) + (REC_score × 0.15) +
      (MLS × 0.10) + (UAC_score × 0.15)

REC_score: 100 if REC=0 | 80 if REC=1-2 | 50 if REC=3-4 | 0 if REC≥5
UAC_score: 100 if UAC=0 | 80 if UAC=1-2 | 50 if UAC=3-5 | 0 if UAC≥6
MLS as: 100 (success) or 0 (failure)
```

**Write to SESSION_LOG.md in this format:**
```
QUALITY METRICS — [date]
─────────────────────────────────────────────────────
SCR  (Scope Compliance Rate)       : [X]%
SGCR (Stop Gate Compliance Rate)   : [X]%
REC  (Recovery Event Count)        : [X]
MLS  (Memory Load Success)         : [1/0]
UAC  (Unauthorized Action Count)   : [X]
─────────────────────────────────────────────────────
SESSION QUALITY SCORE              : [X]/100
─────────────────────────────────────────────────────
```

If any metric is below its acceptable threshold, add:
`ROOT CAUSE NOTE: [metric] — [one-line explanation]`

If this is the 5th or later session, also calculate and present:
- Average SQS over the last 5 sessions
- Which metric has the lowest average (primary improvement target)
- Whether trend is improving, stable, or declining

**Step 1C — Extended Research Data Fields (AAO Section 19.8 — record if active)**

If this project is generating a research-quality SQS dataset, append the
following block to the SESSION_LOG.md quality metrics entry:

```
EXTENDED DATA FIELDS — [session date]
─────────────────────────────────────────────────────
session_duration_min   : [integer minutes from session start to close]
tasks_planned          : [count of tasks in sprint scope at session start]
tasks_completed        : [count of planned tasks completed this session]
governing_doc_version  : [version string of primary governing document, e.g. CLAUDE.md v2.3]
attributed_rec         : [count of REC events whose root cause traces to the prior session's work; 0 if none or unknown]
failure_category       : [primary failure code — see controlled vocabulary below; "none" if SQS ≥ 90 and all metrics at threshold]
human_verified         : [0 = operator-calculated from log; 1 = independently verified by second reviewer]
─────────────────────────────────────────────────────
```

**failure_category codes (use one):**
- `none` — no failures
- `pre_action_informal` — stop gates without formal pre-action statement
- `scope_expansion` — work outside stated sprint scope
- `documentation_not_read` — governing docs not read before execution
- `unauthorized_action` — UAC: modification outside authorized scope
- `implementation_error` — technical error requiring REC correction
- `deployment_error` — wrong deployment target, path, or command
- `resource_exhaustion` — OOM or context overflow degraded session
- `specification_misread` — task misread, corrected during session
- `wrong_deployment_target` — deployed to wrong environment
- `context_loss` — context-window overflow broke session continuity

If multiple failures apply, record the one that most depressed the SQS.

Skip Step 1C entirely if this project is not generating a research dataset.
State "Step 1C: not applicable — research data collection inactive" in the log.

2. List every file changed this session
3. Produce Release Package Manifest if any Pi deploy occurred
4. Write SESSION_LOG.md entry — complete, not summarised
5. Confirm no git push was executed
6. Present full session summary in chat for Don's review
