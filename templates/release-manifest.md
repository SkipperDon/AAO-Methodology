# Release Package Manifest Template
## Copy this template at the end of every development session that produces deployable changes

---

```
╔══════════════════════════════════════════════════════════════════╗
║                  RELEASE PACKAGE MANIFEST                       ║
║                  AAO-Compliant System Update                    ║
╠══════════════════════════════════════════════════════════════════╣

SYSTEM:         [Your system name]
VERSION
  Current:      [Read from version file]
  New:          [Incremented version]
  Prepared by:  [Developer name or AI assistant]
  Date:         [ISO date]

UPDATE TYPE
  [ ] hotfix      — Critical bug fix. <5MB. Silent apply.
  [ ] incremental — Normal release. 5-200MB. User notified.
  [ ] migration   — Major change. May require reboot.

CHANGED FILES
  [Repeat for each changed file]

  [MODIFIED/CREATED/DELETED]: [full file path]
    Partition:    BASE | RUNTIME | DATA
    What changed: [one sentence]
    Why:          [one sentence]

PRE-INSTALL STEPS
  Stop services:    [list — or "None"]
  DB migrations:    [list — or "None"]
  Other:            [list — or "None"]

POST-INSTALL STEPS
  Restart services: [list — or "None"]
  Clear caches:     [list — or "None"]
  Reboot required:  YES / NO

ROLLBACK NOTES
  Safe to roll back: YES / NO / CONDITIONAL
  Data risk:         NONE / LOW (description) / MEDIUM (description)
  Special notes:     [any rollback considerations — or "None"]

HEALTH CHECK
  Timeout:          [ ] 60s (hotfix)
                    [ ] 120s (incremental)
                    [ ] 300s (migration)
  Services to check: [list services that must be running after update]

RELEASE NOTES (plain language — shown to end users)
  [Maximum 3 sentences. What changed and why it benefits the user.
   Written for a non-technical audience.]

╚══════════════════════════════════════════════════════════════════╝
```

---

## Versioning Reference

| Change Type | Example | Rule |
|-------------|---------|------|
| Hotfix | 2.0-T3 → 2.0-T4 | Single fix. TIER increments. |
| Minor release | 2.0-T4 → 2.1-T1 | New feature or multiple fixes. MINOR increments. TIER resets. |
| Major release | 2.1-T3 → 3.0-T1 | Breaking change. MAJOR increments. Everything resets. |

---

## Partition Quick Reference

| Partition | Path | Modifiable by AI? | Survives rollback? |
|-----------|------|-------------------|--------------------|
| Base | /opt/app/base/ | No — immutable | Yes — never changes |
| Runtime | /opt/app/runtime/ | Yes — via Action Layer | Restored from snapshot |
| Data | /opt/app/data/ | No — user data only | Yes — excluded from rollback |

---

*Template version 1.0 | AAO Methodology | github.com/SkipperDon/aao-methodology*
