# AAO Standing Instruction — Generic Template
## Paste this at the start of every AI-assisted development session
## Customise the bracketed sections for your specific system

---

You are working on **[YOUR SYSTEM NAME]** — [one sentence description].

## YOUR ENVIRONMENT

- **Repository:** [your repo URL]
- **Architecture:** AAO (Autonomous Action Operating) methodology
- **Reference:** github.com/SkipperDon/aao-methodology
- **Current Version:** Check [path to your version file]

---

## RULES YOU MUST FOLLOW

### 1. Review Before You Build
Read existing code before writing new code. Never assume a component does not exist.

### 2. Partition Awareness
Every file change must be classified:
- **BASE** `[your base path]` — read-only at runtime, requires signed update
- **RUNTIME** `[your runtime path]` — read-write, normal AI action scope
- **DATA** `[your data path]` — user data, never modified by updates or AI

### 3. Action Layer is Mandatory
Any new capability for the AI to affect the system must be added to the Action Layer whitelist first. No direct execution paths. No exceptions.

### 4. Check Service/Port Assignments
Before creating a new component, verify no conflicts with existing assignments:
[List your existing service ports/identifiers here]

### 5. Naming Conventions
[List your naming conventions here]

---

## SESSION TESTING GATE — REQUIRED

**At the end of every session that produces deployable code, you MUST produce a completed Session Testing Gate using the template at:**
`github.com/SkipperDon/aao-methodology/templates/session-testing-gate.md`

The gate has three sections:
- **Section A** — you (Claude Code) complete: unit tests, integration tests, AAO-specific tests, and honest documentation of what you could NOT test
- **Section B** — the developer completes before committing: code review, CI regression, performance impact
- **Section C** — the developer completes before fleet deploy: staged rollout, on-vessel validation

| Term used | What evidence you must provide |
|---|---|
| "verify" | Unit test output (Section A1 only) |
| "test" | Section A1 + A2 + A3 output |
| "ready to commit" | Full Section A delivered |
| "done" | Meaningless — always specify which section |

---

## RELEASE PACKAGE MANIFEST — REQUIRED

**At the end of every session that produces deployable changes, you MUST produce a Release Package Manifest using the template at:**
`github.com/SkipperDon/aao-methodology/templates/release-manifest.md`

A session is not complete until the manifest is produced.

**The manifest must contain:**
- Version bump (current → new) with versioning rationale
- Update type (hotfix / incremental / migration)
- Every changed file with full path and partition classification
- Pre-install steps (services to stop, migrations to run)
- Post-install steps (services to restart, reboot required)
- Rollback notes and data risk assessment
- Health check timeout
- Plain-language release notes for end users

---

## WHEN A MANIFEST IS REQUIRED

| Scenario | Manifest Required? |
|----------|-------------------|
| Bug fix deployed to running systems | YES |
| New feature deployed to running systems | YES |
| Internal refactor with no behaviour change | NO |
| Documentation update only | NO |
| Test files only | NO |
| Whitelist entry added or changed | YES — base partition change |

When in doubt — produce the manifest.

---

*AAO Standing Instruction Template v1.0 | github.com/SkipperDon/aao-methodology*
