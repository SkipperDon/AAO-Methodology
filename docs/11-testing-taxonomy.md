# AAO — Testing Taxonomy for AI-Assisted Development
## Ensuring Complete Test Coverage When Claude Code Is Your Developer

> **⚠️ DISCLAIMER — Framework Under Development**
>
> *This document is part of a conceptual framework under active development and has not been formally tested or validated.*

---

## The Core Problem

When a human developer writes code, testing happens across multiple independent parties — the developer tests their own work, QA tests against requirements, regression suites catch regressions, performance teams test under load, and production validation happens on real systems. Each party has different knowledge, different blind spots, and different tools.

When Claude Code writes code, several of these roles collapse unless you are deliberate about separating them. Claude Code will write unit tests and run them. But it wrote both the code and the tests — so it has the same assumptions in both. It cannot provide truly independent QA. It cannot do real performance testing under production load. It cannot validate behavior on a physical vessel at sea.

**The question "has this been tested?" needs to become "which test types have been completed by whom?"**

This document defines the complete testing taxonomy for d3kOS AI-assisted development, establishes who is responsible for each type, and provides the Session Testing Gate that must be completed before any Claude Code session output is committed and deployed.

---

## The Six Testing Layers

### Layer 1 — Unit Testing
**What it is:** Individual functions, methods, and components tested in isolation with known inputs and expected outputs.

**Who does it:** Claude Code — this is what it does well. It writes the code and it writes the unit tests. Expect good coverage here.

**The blind spot:** Claude Code's unit tests verify the code does what Claude Code intended it to do. If the intention was wrong, the unit test will pass and the bug will still exist. Unit tests cannot catch requirement misunderstandings.

**What "verified" means here:** All functions have unit tests. Tests pass. Coverage meets the defined threshold. Edge cases (null inputs, boundary values, error conditions) are explicitly tested.

**d3kOS specifics:** Every NMEA parser function, every action validator, every whitelist lookup must have unit tests. Marine data is messy — malformed sentences, unexpected talker IDs, missing fields — these edge cases must be in the unit tests.

---

### Layer 2 — Integration Testing
**What it is:** Testing that components work correctly together — the NMEA parser feeding the AI context builder, the AI output feeding the Action Layer validator, the Action Layer calling the health check.

**Who does it:** Claude Code can write integration tests, but you need to review the test scenarios. Claude Code may connect components correctly but miss the scenario where the NMEA multiplexer goes offline mid-session, or where the health check times out during a CAN bus reset.

**The blind spot:** Integration tests written by the same agent that wrote the components will test the happy path well. Failure scenarios require explicit human-defined test cases based on what actually breaks in production.

**What "verified" means here:** Component interfaces are tested end-to-end. Key failure scenarios are explicitly represented as test cases. Tests run in CI, not just locally.

**d3kOS specifics:** Critical integration paths: NMEA → AI context → Action Layer → NMEA (verify action outcome). SignalK → audit ledger → Session Summary. Health check → rollback → health check (verify rollback restored state). Each of these must be an explicit integration test, not just unit tests on each component.

---

### Layer 3 — AAO-Specific Testing
**What it is:** The test categories defined in the AAO specification that are unique to systems with AI action capability. These do not exist in traditional SDLC frameworks.

**Who does it:** Claude Code can execute these tests, but the test scenarios must be human-defined. The prompt injection test patterns, the whitelist boundary cases, and the rollback failure simulations require human judgment to define — Claude Code may not think of the adversarial cases.

**The blind spot:** Claude Code testing its own Action Layer implementation for prompt injection resistance is like asking the lock manufacturer to pick their own lock. It will find the obvious cases. A human thinking adversarially will find more.

**What "verified" means here:** All six AAO test categories from the specification are explicitly completed and documented. See `docs/07-sdlc-integration.md` for the full test specifications.

**The six required AAO test categories:**
- Whitelist boundary tests (requests for non-whitelisted actions are rejected and logged)
- Prompt injection tests (known injection patterns do not result in out-of-scope action requests)
- Rollback tests (health check failure triggers automatic rollback within timeout)
- Partition integrity tests (base partition cannot be written by any runtime process)
- Audit completeness tests (all action outcomes produce complete audit records)
- Confirmation bypass tests (Medium/High actions cannot execute without confirmed operator approval)

**d3kOS specifics:** The prompt injection test suite must include NMEA-embedded injection patterns — crafted NMEA sentences that attempt to instruct the AI. This is a d3kOS-specific attack surface that generic prompt injection tests will miss.

---

### Layer 4 — Regression Testing
**What it is:** Ensuring that new changes do not break functionality that was previously working. Every existing capability is re-verified after every change.

**Who does it:** This must be automated. A regression suite that runs on every commit. Claude Code can help build the regression suite, but the suite must be run automatically — not manually, not by Claude Code deciding which existing tests to run.

**The blind spot:** If you don't have a regression suite, you don't have regression testing. "I checked it and it seemed fine" is not regression testing. The thing that breaks is usually the thing nobody thought to check.

**What "verified" means here:** CI pipeline runs the full regression suite. All tests pass. Any failure blocks commit. The regression suite grows with every bug fix — each bug fix adds a regression test for that specific bug.

**d3kOS specifics:** The regression suite must include a full NMEA playback test — a recording of real vessel data played back through the system to verify end-to-end behavior. Any change that affects NMEA processing must pass the full playback test.

---

### Layer 5 — Performance Testing
**What it is:** How does the system behave under load, over time, and in resource-constrained environments? Does the audit ledger grow without bound? Does the AI response time degrade after extended operation? Does the system recover after a memory spike?

**Who does it:** This requires a test environment that simulates production conditions. Claude Code cannot do this — it has no visibility into the actual hardware performance, the Raspberry Pi's memory constraints, or what happens after 72 hours of continuous operation at sea.

**The blind spot:** A system that works perfectly in development can fail in production due to memory leaks, disk fill-up, CPU spikes, or network timeouts that only appear under real conditions over real time.

**What "verified" means here:** Performance tests have been run in the target hardware environment (not just a development machine). Specific metrics have been measured: response time under normal load, memory usage over 24 hours of operation, disk usage growth rate, CPU usage during peak diagnostic activity.

**d3kOS specifics:** Performance testing must happen on the actual target hardware (Raspberry Pi or equivalent marine computer). Key metrics: AI response time with full NMEA context (must be acceptable for a non-technical operator waiting for a diagnosis), audit ledger growth rate (must not fill the runtime partition in a typical cruising season), health check execution time (must complete within the defined timeout even under high CPU load).

---

### Layer 6 — Production Validation
**What it is:** Does the system work correctly in the real deployment environment — on a real vessel, with real marine electronics, in real conditions? This is the validation that no test environment can replicate.

**Who does it:** You. On the boat. This is not optional and cannot be delegated to Claude Code.

**The blind spot:** Marine environments introduce conditions that no development environment models — electrical noise, temperature extremes, vibration, intermittent power, mixed NMEA 0183 and 2000 devices with unexpected behavior, and the specific combination of equipment on your specific vessel.

**What "verified" means here:** The change has been deployed to a test vessel and observed in operation. For safety-critical changes, this includes observation under realistic conditions (underway, not just at the dock). Rollback has been tested in the production environment — not just in development.

**d3kOS specifics:** Any change that affects NMEA parsing, CAN bus interaction, or action execution must be validated on the actual vessel before fleet deployment. The staged rollout process (single vessel → small group → full fleet) is the production validation framework. Changes that pass all development testing but behave unexpectedly on the real vessel must trigger a rollback and a root cause investigation — not a "it's probably fine on other boats" assumption.

---

## Who Does What — Summary

| Test Layer | Claude Code | You (Developer Review) | Automated CI | On the Boat |
|---|---|---|---|---|
| **1 — Unit** | Writes and runs | Reviews coverage and edge cases | Runs on every commit | — |
| **2 — Integration** | Writes tests | Defines failure scenarios | Runs on every commit | — |
| **3 — AAO-Specific** | Executes tests | Defines adversarial scenarios | Runs on every commit | — |
| **4 — Regression** | Helps build suite | Reviews suite completeness | **Must be automated** | — |
| **5 — Performance** | Cannot do this | Defines metrics and thresholds | Scheduled runs | Hardware validation |
| **6 — Production** | Cannot do this | Cannot do this | Cannot do this | **You, on the vessel** |

---

## The Session Testing Gate

Every Claude Code development session that produces deployable code must complete this gate before you commit. It is produced by Claude Code, reviewed by you, and becomes an artifact in the Artifact Repository.

The gate has three sections: what Claude Code completed, what you need to complete before committing, and what must happen before fleet deployment.

See `templates/session-testing-gate.md` for the template.

---

## Mapping Your Terms to Test Layers

When you use these words in a Claude Code session, here is what they should mean and what evidence is required:

**"verify"** — Layers 1 and 2. Claude Code runs unit and integration tests and reports results. Evidence: test output showing pass/fail counts and coverage. This alone is NOT sufficient to commit.

**"test"** — Layers 1, 2, and 3 minimum. Claude Code runs unit, integration, and AAO-specific tests. Evidence: test output for all three layers. Still requires your review before commit.

**"regression test"** — Layer 4. CI pipeline runs the full regression suite against the changes. Evidence: CI pipeline output, all tests green. This should be automatic on every commit, not a manual instruction.

**"performance test"** — Layer 5. Requires separate execution in the target hardware environment. Cannot be done within a Claude Code session. Evidence: performance test report from the target hardware.

**"ready to commit"** — Layers 1, 2, 3, and 4 complete. You have reviewed the Session Testing Gate. CI is green. Performance impact has been assessed. Production validation plan is documented.

**"ready to deploy"** — All of the above, plus the staged rollout plan is defined, and for any safety-critical changes, the production validation approach on the vessel is documented.

---

## The Independence Problem

The most important thing to understand about AI-assisted testing is the **independence problem**.

Claude Code cannot provide independent verification of Claude Code's work. When Claude Code writes a function and then writes a test for that function, both the function and the test share the same misunderstandings, the same assumptions, and the same blind spots. The test will pass even if the function is wrong — because both are wrong in the same way.

True independence requires a different perspective. In a traditional team, this comes from QA having different knowledge than developers. In an AI-assisted workflow, it comes from:

**You reviewing what Claude Code did** — not running the tests again, but reading the code and the test cases and asking "is this testing the right thing?"

**The CI pipeline being independent** — automated tests that run outside of Claude Code's context, on a clean environment, without Claude Code's interpretation of the results.

**Production validation being real** — the vessel, the sea, the actual marine electronics. This cannot be simulated.

**Historical regression tests being human-defined** — every test added to the regression suite because something broke in production is a test that Claude Code would not have written proactively. These are your most valuable tests.

---

*docs/11-testing-taxonomy.md | AAO Methodology | © 2026 Donald Moskaluk | AtMyBoat.com | Apache License 2.0*
