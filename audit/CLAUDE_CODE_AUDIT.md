# Claude Code — Methodology Audit & State Assessment

> Run this audit at the start of any project or session to establish where you are
> and what you need to do.

---

## ⚡ CURRENT STATE DIAGNOSIS

Answer each question honestly. Your score determines your compliance tier.

---

### SECTION 1: Project Foundation

| # | Check | Status | Points |
|---|-------|--------|--------|
| 1.1 | Does a `CLAUDE.md` file exist in the project root? | ☐ YES / ☐ NO | 10 |
| 1.2 | Does `CLAUDE.md` include coding standards and style rules? | ☐ YES / ☐ NO | 5 |
| 1.3 | Does `CLAUDE.md` include banned commands or forbidden actions? | ☐ YES / ☐ NO | 5 |
| 1.4 | Does `CLAUDE.md` include required verification steps (test cmds)? | ☐ YES / ☐ NO | 5 |
| 1.5 | Is `CLAUDE.md` under version control (committed to git)? | ☐ YES / ☐ NO | 5 |

**Section Score: ___ / 30**

---

### SECTION 2: Hooks & Guardrails

| # | Check | Status | Points |
|---|-------|--------|--------|
| 2.1 | Is at least one `PostToolUse` hook configured? | ☐ YES / ☐ NO | 10 |
| 2.2 | Does a hook run the linter/formatter after every file write? | ☐ YES / ☐ NO | 10 |
| 2.3 | Does a hook block writes to protected paths (migrations, infra)? | ☐ YES / ☐ NO | 10 |
| 2.4 | Does a hook run the test suite after significant code changes? | ☐ YES / ☐ NO | 10 |
| 2.5 | Is there a `Stop` hook that validates completeness before ending? | ☐ YES / ☐ NO | 10 |

**Section Score: ___ / 50**

---

### SECTION 3: Workflow Discipline

| # | Check | Status | Points |
|---|-------|--------|--------|
| 3.1 | Do you use Plan Mode before tasks touching 3+ files? | ☐ YES / ☐ NO | 10 |
| 3.2 | Do you review and approve plans before execution? | ☐ YES / ☐ NO | 10 |
| 3.3 | Do you run `/compact` before context exceeds ~50%? | ☐ YES / ☐ NO | 5 |
| 3.4 | Do you use `/clear` when switching between unrelated tasks? | ☐ YES / ☐ NO | 5 |
| 3.5 | Do you scope tasks to one concern at a time? | ☐ YES / ☐ NO | 10 |

**Section Score: ___ / 40**

---

### SECTION 4: Test-Driven & Quality Practice

| # | Check | Status | Points |
|---|-------|--------|--------|
| 4.1 | Is a failing test written before fixing a bug? (TDD) | ☐ YES / ☐ NO | 10 |
| 4.2 | Does every new feature have a corresponding test? | ☐ YES / ☐ NO | 10 |
| 4.3 | Are tests passing before Claude is told the task is complete? | ☐ YES / ☐ NO | 10 |
| 4.4 | Is type checking run after every significant change? | ☐ YES / ☐ NO | 5 |
| 4.5 | Is there a definition of "done" that Claude must satisfy? | ☐ YES / ☐ NO | 5 |

**Section Score: ___ / 40**

---

### SECTION 5: Custom Commands & Automation

| # | Check | Status | Points |
|---|-------|--------|--------|
| 5.1 | Does `.claude/commands/` directory exist? | ☐ YES / ☐ NO | 5 |
| 5.2 | Is there a `bug-fix.md` command enforcing TDD workflow? | ☐ YES / ☐ NO | 5 |
| 5.3 | Is there a `pr-ready.md` command with a pre-PR checklist? | ☐ YES / ☐ NO | 5 |
| 5.4 | Is there a `methodology-check.md` self-audit command? | ☐ YES / ☐ NO | 5 |

**Section Score: ___ / 20**

---

## 📊 SCORING & STATE

| Total Score | State | What This Means |
|-------------|-------|-----------------|
| **0 – 39** | 🔴 UNCONFIGURED | Zero guardrails. Claude will drift regularly. Immediate action required. |
| **40 – 99** | 🟡 PARTIAL | Some methodology in place but enforcement has gaps. |
| **100 – 149** | 🟢 CONFIGURED | Core guardrails active. Minor refinements needed. |
| **150 – 180** | 🏆 OPTIMISED | Full methodology enforcement. |

**YOUR SCORE: ___ / 180 → State: ___________________**

---

## 🗺️ COMPLIANCE ROADMAP

See `remediation/CLAUDE_CODE_GAP_REMEDIATION.md` for the action list matching your score.

---

## 🔁 ONGOING METHODOLOGY TEST

Run this after every Claude Code session:

```
POST-SESSION CHECKLIST
======================
[ ] Claude stayed within the stated task scope
[ ] Tests were written before or with code (not after)
[ ] All tests passed at session end
[ ] Linter returned zero errors
[ ] No forbidden files were modified
[ ] Claude produced a clear summary of what changed

Drift detected? YES / NO
If YES — update CLAUDE.md or hooks to prevent it next time
```

> The Rule: Every time Claude drifts, that drift becomes a new hook or CLAUDE.md rule.
> Drift should only ever happen once.

---

## 📁 TARGET FILE STRUCTURE

```
your-project/
├── CLAUDE.md                          ← methodology constitution
├── .claude/
│   ├── settings.json                  ← hooks configuration
│   └── commands/
│       ├── bug-fix.md
│       ├── session-close.md
│       └── methodology-check.md
└── [your source code]
```

*Re-run this audit at the start of each new project and after any major workflow change.*
