# 07 — SDLC Integration


> **⚠️ DISCLAIMER — Framework Under Development**
>
> *The methodology presented in this document is a conceptual framework currently under active development and has not been formally tested, validated, or peer-reviewed. It should not be interpreted as a finalized standard, best practice, or certified process. Organizations adopting or referencing this framework do so at their own discretion and are encouraged to apply appropriate professional judgment. Feedback, testing, and iterative refinement are actively welcomed as part of the ongoing development of this framework.*

---


## Why SDLC Needs Extending

Traditional SDLC frameworks — Agile, Scrum, DevOps, CI/CD — were designed for systems where software produces output but does not autonomously act on the world. The most autonomous traditional software gets is a scheduled job or an automated deployment pipeline — actions defined entirely by developers, not by AI reasoning at runtime.

AI systems with real-world action capability introduce a new category of runtime behaviour that existing SDLC frameworks do not address. AAO extends each stage with specific requirements for this category.

---

## Plan Stage Extension

Before planning any feature that involves AI actions, assess:

**Action boundary impact:** Does this feature require new whitelist entries? What risk level are the new actions? Does adding them require changes to the base partition (a more complex deploy) or only the runtime layer?

**Confirmation model:** What level of user confirmation is appropriate for the actions this feature requires? Define this before development begins — retrofitting confirmation requirements is difficult.

**Rollback impact:** If an action introduced by this feature is rolled back, what is the state of the system? Is rollback fully safe, or are there edge cases?

Document these assessments as part of the feature specification. A feature specification that does not answer these questions is incomplete for an AAO system.

---

## Design Stage Extension

Every component must be designed with explicit partition classification:

**Base partition:** What belongs here? Application logic, service definitions, the action whitelist, health check scripts. Changes here require a signed update package and base remount.

**Runtime partition:** What belongs here? Configuration values, logs, cache, session state. Changes here are the normal scope of AI action.

**Data partition:** What belongs here? User data that must survive rollback. Never affected by the snapshot/rollback cycle.

Partition classification must be documented in component design before implementation begins. Discovering partition classification issues during deployment is expensive.

---

## Develop Stage Extension

### The Release Package Manifest

Every development session that produces changes to be deployed to running systems MUST produce a Release Package Manifest. This is the formal handoff from development to deployment.

```
RELEASE PACKAGE MANIFEST
════════════════════════════════════════

VERSION
  Current:    2.0-T3
  New:        2.0-T4

UPDATE TYPE
  [x] hotfix      — critical bug fix, <5MB, silent apply

CHANGED FILES
  MODIFIED: /opt/app/base/services/signalk/reconnect.js
    Partition: BASE
    What changed: Added exponential backoff for CAN reconnection
    Why: Crash loop when bus loses power briefly

PRE-INSTALL
  Stop: app-signalk

POST-INSTALL
  Restart: app-signalk
  Reboot required: No

ROLLBACK NOTES
  Safe. No data affected. Previous reconnect logic restored.

HEALTH CHECK TIMEOUT
  [x] 60 seconds

RELEASE NOTES
  Fixes engine data going blank when NMEA2000 network
  loses power briefly. d3kOS now reconnects automatically.

════════════════════════════════════════
```

The manifest is produced by the developer (human or AI-assisted) at the end of every session. The deployment engineer uses it to build and sign the update package.

### Standing Instruction for AI-Assisted Development

When using an AI coding assistant (Claude Code or equivalent), provide a standing instruction at the start of every session that defines:

- The system's architecture and partition classification rules
- The requirement to produce a Release Package Manifest before closing the session
- The versioning scheme
- The naming conventions and architectural constraints

See [templates/standing-instruction.md](../templates/standing-instruction.md) for a generic template.

---

## Test Stage Extension

### Required Test Categories

**Whitelist boundary tests**
```
For each action NOT on the whitelist:
  Submit a request for that action to the Action Layer
  Assert: request is rejected
  Assert: rejection is logged in the audit ledger
  Assert: no system state changes occurred
```

**Prompt injection tests**
```
For each known injection pattern:
  Submit a user query containing the injection pattern
  Assert: injection pattern is detected and logged
  Assert: AI does not produce a response requesting out-of-scope actions
  Assert: Action Layer would reject any out-of-scope action regardless
```

**Rollback tests**
```
For each action with risk level Low or higher:
  Execute the action
  Simulate a health check failure immediately after
  Assert: rollback is triggered automatically without human intervention
  Assert: rollback completes within the defined timeout
  Assert: system returns to working state after rollback
  Assert: rollback event is logged in the audit ledger
```

**Partition integrity tests**
```
Attempt to write to the base partition as:
  - The AI action user
  - The application user
  - An authenticated admin user
Assert: all write attempts are rejected at the OS level
Assert: base partition hash is unchanged after all attempts
```

**Audit completeness tests**
```
For each of: successful action, failed action, rejected action, rolled-back action:
  Execute the scenario
  Assert: pre-execution audit entry exists
  Assert: post-execution audit entry exists
  Assert: entries contain all required fields
  Assert: entries cannot be modified after writing
```

**Confirmation bypass tests**
```
For each action requiring user confirmation:
  Submit the action to the Action Layer with userConfirmed = false
  Assert: action is rejected regardless of AI output
  Assert: rejection is logged
  Attempt to set userConfirmed = true via the AI conversation layer
  Assert: Action Layer still checks its own confirmation state
```

---

## Deploy Stage Extension

### Staged Rollout

Never deploy to all installations simultaneously. The staged rollout process:

1. **Single test installation** — push to one known installation, verify manually
2. **Small group (5-10%)** — automated rollout to a small percentage, monitor rollback rate
3. **Hold period** — wait minimum 30 minutes, review all outcomes
4. **Full rollout** — if rollback rate below threshold (5% recommended), deploy to all
5. **Monitoring period** — watch for deferred rollbacks and unexpected failure patterns

### Automatic Pause

The deployment system MUST automatically pause the rollout and alert the operator if the rollback rate exceeds the defined threshold during any stage. Pausing is automatic — resuming is always a human decision.

---

## Maintain Stage Extension

### Self-Healing Within the Sandbox

The watchdog service monitors all system components and takes corrective action within the defined whitelist when components fail. Every watchdog action is logged as a failure event and contributes to the failure intelligence database.

### Failure Intelligence Feedback Loop

The failure intelligence database closes the loop between maintenance and planning. Failure patterns from the field become the highest-priority items in the next planning cycle. This is not manual — pattern detection surfaces issues automatically.

The SDLC becomes genuinely circular:

```
Failure patterns → Plan priorities → Development → Deployment → Operations → Failure patterns
```

---

*[Back: 06 — Snapshot and Rollback](06-snapshot-rollback.md) | [Next: 08 — Failure Intelligence](08-failure-intelligence.md)*
