# Session Testing Gate
## Required artifact before committing any Claude Code session output
## Produced by Claude Code — reviewed and signed by developer before commit

---

**Session ID:** _______________
**Date:** _______________
**Developer:** _______________
**Feature / Fix Description:** _______________
**Version:** _______________ → _______________
**Safety-Critical Change:** ☐ Yes  ☐ No

---

## SECTION A — Completed by Claude Code

*Claude Code completes this section and provides evidence for each item.*

### A1 — Unit Tests (Layer 1)

| Item | Status | Evidence |
|---|---|---|
| All new functions have unit tests | ☐ Pass  ☐ Fail  ☐ N/A | |
| All modified functions have updated unit tests | ☐ Pass  ☐ Fail  ☐ N/A | |
| Edge cases covered: null inputs | ☐ Pass  ☐ Fail  ☐ N/A | |
| Edge cases covered: boundary values | ☐ Pass  ☐ Fail  ☐ N/A | |
| Edge cases covered: error conditions | ☐ Pass  ☐ Fail  ☐ N/A | |
| All unit tests pass | ☐ Pass  ☐ Fail | |
| Coverage meets threshold (___%) | ☐ Pass  ☐ Fail | Actual: ___% |

**Unit test run output:** *(paste summary)*
```
[paste test runner output here]
```

**NMEA-specific (if applicable):**
| Item | Status |
|---|---|
| Malformed NMEA sentence handling tested | ☐ Pass  ☐ Fail  ☐ N/A |
| Missing field handling tested | ☐ Pass  ☐ Fail  ☐ N/A |
| Unexpected talker ID handling tested | ☐ Pass  ☐ Fail  ☐ N/A |
| NMEA 0183 / 2000 mixed input tested | ☐ Pass  ☐ Fail  ☐ N/A |

---

### A2 — Integration Tests (Layer 2)

| Integration Path | Test Exists | Status |
|---|---|---|
| NMEA → AI Context Builder | ☐ Yes  ☐ No | ☐ Pass  ☐ Fail  ☐ N/A |
| AI Output → Action Layer Validator | ☐ Yes  ☐ No | ☐ Pass  ☐ Fail  ☐ N/A |
| Action Layer → Health Check | ☐ Yes  ☐ No | ☐ Pass  ☐ Fail  ☐ N/A |
| Health Check → Rollback (failure path) | ☐ Yes  ☐ No | ☐ Pass  ☐ Fail  ☐ N/A |
| Action execution → Audit Ledger | ☐ Yes  ☐ No | ☐ Pass  ☐ Fail  ☐ N/A |
| SignalK → Session Summary | ☐ Yes  ☐ No | ☐ Pass  ☐ Fail  ☐ N/A |

**Failure scenarios explicitly tested:**

*(Claude Code must list each failure scenario tested, not just the happy path)*

- [ ] _______________________________________________
- [ ] _______________________________________________
- [ ] _______________________________________________

**Integration test run output:** *(paste summary)*
```
[paste test runner output here]
```

---

### A3 — AAO-Specific Tests (Layer 3)

*Complete all six categories. If a category is N/A for this change, explain why.*

**Whitelist Boundary Tests:**
| Item | Status | Notes |
|---|---|---|
| Non-whitelisted action requests are rejected | ☐ Pass  ☐ Fail  ☐ N/A | |
| Rejection is logged in audit ledger | ☐ Pass  ☐ Fail  ☐ N/A | |
| No system state change occurs on rejection | ☐ Pass  ☐ Fail  ☐ N/A | |

**Prompt Injection Tests:**
| Item | Status | Notes |
|---|---|---|
| Standard injection patterns tested | ☐ Pass  ☐ Fail  ☐ N/A | |
| NMEA-embedded injection patterns tested | ☐ Pass  ☐ Fail  ☐ N/A | |
| Injected prompts do not produce out-of-scope action requests | ☐ Pass  ☐ Fail  ☐ N/A | |
| Action Layer rejects out-of-scope requests regardless of AI output | ☐ Pass  ☐ Fail  ☐ N/A | |

**Rollback Tests:**
| Item | Status | Notes |
|---|---|---|
| Health check failure triggers automatic rollback | ☐ Pass  ☐ Fail  ☐ N/A | |
| Rollback completes within defined timeout | ☐ Pass  ☐ Fail  ☐ N/A | |
| System returns to working state after rollback | ☐ Pass  ☐ Fail  ☐ N/A | |
| Rollback event logged in audit ledger | ☐ Pass  ☐ Fail  ☐ N/A | |

**Partition Integrity Tests:**
| Item | Status | Notes |
|---|---|---|
| Base partition write attempt by AI action user: rejected | ☐ Pass  ☐ Fail  ☐ N/A | |
| Base partition write attempt by application user: rejected | ☐ Pass  ☐ Fail  ☐ N/A | |
| Base partition hash unchanged after all attempts | ☐ Pass  ☐ Fail  ☐ N/A | |

**Audit Completeness Tests:**
| Item | Status | Notes |
|---|---|---|
| Successful action produces complete audit record | ☐ Pass  ☐ Fail  ☐ N/A | |
| Failed action produces complete audit record | ☐ Pass  ☐ Fail  ☐ N/A | |
| Rejected action produces complete audit record | ☐ Pass  ☐ Fail  ☐ N/A | |
| Rolled-back action produces complete audit record | ☐ Pass  ☐ Fail  ☐ N/A | |

**Confirmation Bypass Tests:**
| Item | Status | Notes |
|---|---|---|
| Medium risk action rejected without confirmation | ☐ Pass  ☐ Fail  ☐ N/A | |
| High risk action rejected without confirmation | ☐ Pass  ☐ Fail  ☐ N/A | |
| Confirmation cannot be set via AI conversation layer | ☐ Pass  ☐ Fail  ☐ N/A | |

---

### A4 — Known Limitations and Blind Spots

*Claude Code must honestly document what it could NOT test and why. This section cannot be left blank.*

**What this session's testing did NOT cover:**

1. _______________________________________________
2. _______________________________________________
3. _______________________________________________

**Scenarios that require human judgment to verify:**

1. _______________________________________________
2. _______________________________________________

**Scenarios that require production hardware (vessel) to verify:**

1. _______________________________________________
2. _______________________________________________

---

## SECTION B — Completed by Developer Before Commit

*You complete this section. Do not commit until all applicable items are checked.*

### B1 — Code Review (Independent Review)

| Item | Status | Notes |
|---|---|---|
| I have read the changed code, not just the test results | ☐ Done | |
| The code does what the requirements intended (not just what Claude Code intended) | ☐ Confirmed | |
| The unit tests are testing the right things (not just that they pass) | ☐ Confirmed | |
| The integration failure scenarios are realistic for d3kOS production conditions | ☐ Confirmed | |
| No new dependencies introduced without review | ☐ Confirmed  ☐ New deps — reviewed | |
| Partition classification is correct for all changed files | ☐ Confirmed | |

### B2 — Regression Gate

| Item | Status |
|---|---|
| CI pipeline triggered on this branch | ☐ Yes |
| All regression tests pass | ☐ Pass  ☐ Fail — DO NOT COMMIT |
| Any new test added to regression suite for this bug/feature | ☐ Yes  ☐ N/A |

**CI Pipeline run:** _______________________________________________

### B3 — Performance Impact Assessment

*You assess whether this change has performance implications. If yes, performance testing is required before deploy.*

| Question | Answer |
|---|---|
| Does this change affect NMEA processing throughput? | ☐ Yes → performance test required  ☐ No |
| Does this change affect memory usage over time? | ☐ Yes → performance test required  ☐ No |
| Does this change affect audit ledger growth rate? | ☐ Yes → performance test required  ☐ No |
| Does this change affect AI response time? | ☐ Yes → performance test required  ☐ No |
| Does this change affect health check execution time? | ☐ Yes → performance test required  ☐ No |

**If any "Yes" above — performance testing status:**
☐ Not yet done — DO NOT DEPLOY until complete
☐ Completed — results attached: _______________________________________________

### B4 — Safety-Critical Assessment

*If this change is safety-critical (affects navigation, engine monitoring, autopilot interaction, or rollback capability), additional gates apply.*

☐ This change is NOT safety-critical — proceed to Section B5

☐ This change IS safety-critical:
- [ ] Change has been reviewed against marine electronics safety considerations
- [ ] Rollback of this specific change has been tested in development environment
- [ ] Production validation plan documented below before fleet deployment

**Production validation plan for safety-critical change:**
_______________________________________________

---

## SECTION C — Production Deployment Gates

*Complete before staged rollout begins. This section documents the production validation approach.*

### C1 — Staged Rollout Plan

| Stage | Target | Success Criteria | Rollback Trigger |
|---|---|---|---|
| Stage 1 — Single vessel | Test vessel (yours) | All functions operate as expected; no unexpected rollbacks | Any unexpected behavior |
| Stage 2 — Small group | ___% of fleet | Rollback rate < 5% in 30 minutes | Rollback rate > 5% |
| Stage 3 — Full fleet | All vessels | Monitoring period: ___ hours | Any systematic failure pattern |

### C2 — On-Vessel Validation Checklist

*Complete on the test vessel before Stage 2. Check each item you have personally observed working.*

| Item | Observed | Conditions | Date |
|---|---|---|---|
| Change deployed successfully | ☐ | | |
| Basic function operates correctly | ☐ | | |
| Rollback tested and confirmed working | ☐ | | |
| Audit records appear correctly in repository | ☐ | | |
| No unexpected behavior after ___ hours of operation | ☐ | | |
| *(safety-critical only)* Tested underway, not just at dock | ☐ | | |

### C3 — Sign-Off Before Fleet Deploy

**Developer sign-off:** I have completed Sections A, B, and C1. The change is ready for staged rollout.

**Name:** _______________________________________________
**Authorization Code:** *(Enter in system — recorded as artifact in repository)*
**Date:** _______________________________________________

**Production validation sign-off** *(after C2 complete)*: I have personally observed this change operating correctly on the test vessel and authorize Stage 2 rollout.

**Name:** _______________________________________________
**Authorization Code:** *(Enter in system — recorded as artifact in repository)*
**Date:** _______________________________________________

---

## Quick Reference — What Each Term Means

| Term used in Claude Code session | Minimum testing completed |
|---|---|
| "verify" | Section A1 (unit tests) only |
| "test" | Sections A1 + A2 + A3 |
| "regression test" | Section B2 (CI pipeline) |
| "ready to commit" | Sections A1 + A2 + A3 + B1 + B2 + B3 |
| "ready to deploy" | All sections + C1 + C2 |
| "done" | Meaningless without the gate — always ask which section |

---

*AAO Session Testing Gate v1.0 | templates/session-testing-gate.md*
*© 2026 Donald Moskaluk | AtMyBoat.com | Apache License 2.0*
*Produce this artifact at the end of every Claude Code session that produces deployable code.*
*Store completed gates in the Artifact Repository as SESSION_TESTING_GATE artifact type.*
