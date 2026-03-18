# /implementation-gate — AAO Pre-Implementation Gate Command

## Purpose

Invoke this command to explicitly re-arm the Pre-Implementation Gate at any point in a session.

Use cases:
* After a `/compact` when you want to ensure the gate is re-active before the next task
* When you suspect Claude has drifted into Autonomous Builder mode mid-session
* At the start of a new feature block within a long session
* Any time Claude has produced output that looked like it was invented rather than authorized

---

## How to Invoke

Type in chat:

```
/implementation-gate
```

---

## What Claude MUST Do When This Command Is Received

1. **Acknowledge the gate reset:**

   > "Pre-Implementation Gate re-armed. I am in TRANSACTIONAL MODE.
   > All file scope authorizations from previous tasks are cleared.
   > My next response to any task will be a Phase 1 interpretation only."

2. **Clear all carry-forward state:**
   * File scope permissions from previous tasks: cleared
   * Assumptions about project structure inferred during the session: cleared
   * Any planned next steps from a previous task: cleared

3. **Re-read the CLAUDE.md Pre-Implementation Gate section** before processing the next task.

4. **Produce a Phase 1 interpretation** for the next task received — regardless of whether the task seems simple, regardless of whether it appears to continue a prior task.

---

## Phase 1 Output Format (required)

Every Phase 1 response MUST use this exact structure:

```
PHASE 1 — INTERPRETATION

Task: [one to three sentence restatement of what you understand is being asked]

Files involved:
- [full/path/to/file.ext] — [exists | must be created] — [read | edit | create | delete]
- [full/path/to/file.ext] — [exists | must be created] — [read | edit | create | delete]

Operations required:
- [plain language description of operation 1] — Risk: [None | Low | Medium | High]
- [plain language description of operation 2] — Risk: [None | Low | Medium | High]

Uncertainties:
- [any ambiguity that needs clarification, or "None"]

Awaiting: APPROVED / REVISE / DENIED
```

Claude MUST stop after this output. No code. No file creation. No planning. No suggestions.

---

## Authorization Responses

| Operator response | Claude action |
| --- | --- |
| `APPROVED` | Proceed exactly as listed. No additions. No variations. |
| `REVISE [instructions]` | Adjust interpretation, produce a new Phase 1 output, stop, wait again. |
| `DENIED` | Do nothing. Acknowledge and await the next task. |
| Anything ambiguous | Ask for clarification. Do NOT interpret ambiguity as implicit APPROVED. |

---

## What Constitutes a Gate Violation

The following behaviours in the same response as or immediately following a task instruction — before an APPROVED — are gate violations:

* Any code written
* Any file created or modified
* Any architecture described with the intent to implement
* Any multi-step plan produced
* Any file invented that was not in the task instruction
* Any refactor proposed without being asked

If you observe a gate violation, invoke `/implementation-gate` to reset, then restate the task.

---

## Relationship to AAO Principles

The Pre-Implementation Gate is the development-time analog of the AAO Action Layer (Specification Section 3.3).

At runtime, the Action Layer prevents the AI system from executing actions not on the whitelist. At development time, the Pre-Implementation Gate prevents Claude Code from touching files and structures not explicitly authorized.

Both apply the same core principle from the AAO Specification (Section 3.3.2):

> "The Action Layer MUST expose only named action functions. It MUST NOT expose a general command execution interface of any kind."

At development time, this translates to:

> "Claude MUST implement only explicitly authorized operations on explicitly authorized files. It MUST NOT enter a general implementation mode."

---

*Part of the AAO Autonomous Action Operating Methodology.*
*commands/ — see SPECIFICATION.md for governing principles*
