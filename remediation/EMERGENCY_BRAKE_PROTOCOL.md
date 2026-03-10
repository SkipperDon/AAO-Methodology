# Emergency Brake Protocol
**Added:** March 2026 — following DI-001
**Status:** Active — required in all CLAUDE.md files

## The Problem It Solves

Mid-session commands (/methodology-check, /compact, /clear) are advisory.
Claude can acknowledge them and continue violating. There was no hard stop.

## The Protocol

Add this section to CLAUDE.md BEFORE the OPERATIONAL RULES section:

---

### EMERGENCY BRAKE — Hard Stop Protocol

If the operator types any of the following, Claude MUST immediately:
1. Stop all tool call execution — do not write to any further files
2. List every file touched since the last operator message (name and path)
3. State what action was about to be executed next
4. Await explicit re-authorization before any further tool call

Emergency brake phrases — no prefix, plain text, unconditional:
- STOP
- HALT
- FREEZE
- AAO STOP

These phrases override any mid-task context.
/compact, /clear, and /methodology-check are advisory — they do not block tool execution.
The brake phrases above are the only unconditional stop mechanism.

---

## How to Verify It Is Working

Start a new session and ask Claude to confirm it read the Emergency Brake protocol.
It should name it explicitly in the session-start acknowledgment.
