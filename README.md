# AAO — Autonomous Action Operating Methodology

**Owner:** Donald Moskaluk — AtMyBoat.com / d3kOS
**Version:** 1.1
**Authoritative spec:** `SPECIFICATION.md` (820 lines, 16 sections)

---

## What is AAO?

AAO is a structured methodology for governing AI-assisted software development.
It defines how Claude Code must behave on every project — what it can do autonomously,
what requires approval, how risk is classified, and how every action is audited.

The core principle: **trust is established before the system operates — through
authorization, process, and accountability. It is not evaluated at runtime.**

---

## Repository Structure

```
aao-methodology/
├── README.md                          ← this file
├── SPECIFICATION.md                   ← the 820-line authoritative spec
├── CLAUDE.md                          ← session-start template for any project
│
├── audit/
│   ├── CLAUDE_CODE_AUDIT.md           ← 180-point compliance scoring framework
│   └── CLAUDE_CODE_STATE_ASSESSMENT.md ← dated compliance snapshots
│
├── remediation/
│   └── CLAUDE_CODE_GAP_REMEDIATION.md ← task list to hand Claude Code
│
└── commands/
    ├── bug-fix.md                     ← TDD-enforced bug fix workflow
    ├── session-close.md               ← session close checklist
    └── methodology-check.md           ← mid-session self-audit
```

---

## How to Use This Methodology on a New Project

1. Copy `CLAUDE.md` to your project root — edit project-specific sections
2. Copy `commands/` contents to `.claude/commands/` in your project
3. Run the audit: give `audit/CLAUDE_CODE_AUDIT.md` to Claude Code and score your project
4. Close gaps: give `remediation/CLAUDE_CODE_GAP_REMEDIATION.md` to Claude Code
5. Configure hooks via `/hooks` in Claude Code

---

## Reference Implementation

d3kOS is the reference implementation of AAO at all three compliance levels.
See: `github.com/SkipperDon/d3kOS`

---

## AAO Risk Classification (Summary)

| Risk Level | What It Covers | Required Behaviour |
|------------|---------------|-------------------|
| **None** | Read-only actions | Execute without stating |
| **Low** | State-changing, reversible | State what you are about to do |
| **Medium** | Meaningful config changes | State action, impact, rollback path |
| **High** | Irreversible or externally visible | STOP — require explicit confirmation |

Full table and rules: `SPECIFICATION.md` Section 4.
