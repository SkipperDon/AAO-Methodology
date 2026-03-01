# 04 — The Audit Trail

## Why Auditability Is Not Optional

In any system where AI takes real-world actions, someone will eventually ask: "What did the AI do?" This question can come from the user who noticed something changed, an administrator investigating an incident, a regulator reviewing AI decision-making, or a developer debugging unexpected behaviour.

The answer must be complete, accurate, and always available — not reconstructed from scattered logs after the fact.

The AAO audit trail is built into the Action Layer from the beginning. It is not a logging feature. It is a core requirement.

---

## The Append-Only Ledger

The audit ledger is append-only. Entries are written. They are never modified or deleted.

This property is what makes the audit trail trustworthy. If entries could be modified, an AI system that had taken a harmful action could potentially cover its tracks. The append-only constraint means the record of what happened is permanent.

Implementation: write entries as newline-delimited JSON (JSONL) to a file. To make the append-only property robust, the file can be written with append-only file system flags on supported systems.

```bash
# Set append-only flag on Linux (root required)
chattr +a /opt/app/runtime/logs/ai-action-ledger.jsonl
```

---

## Ledger Entry Schema

Every entry in the audit ledger follows this structure:

```json
{
  "entry_id": "uuid-v4",
  "timestamp": "2026-02-23T14:32:17.443Z",
  "entry_type": "pre_execution | post_execution | rejected | security_flag",
  "session_id": "sess_a7f3c9",
  "action_name": "restart_service",
  "parameters": { "service_name": "signalk" },
  "risk_level": "Low",
  "user_confirmed": true,
  "confirmation_method": "conversational",
  "snapshot_id": "snap_20260223_143215",
  "execution_output": "Restarted successfully. Exit code 0.",
  "health_check_result": { "passed": true, "services_checked": 12, "duration_ms": 8432 },
  "rollback_triggered": false,
  "rollback_outcome": null,
  "duration_ms": 2341,
  "user_query_context": "User asked: what errors are you seeing?"
}
```

Note `user_query_context` — this captures what the user said that led to the action. Without this, audit entries show what happened but not why. The why is essential for meaningful audit review.

---

## Pre and Post Entries

Every consequential action generates two ledger entries:

**Pre-execution entry** — written before the action runs. If the system crashes during execution, the pre-execution entry still exists. An auditor can see that an action was initiated even if no post-execution entry exists.

**Post-execution entry** — written after the action completes, health check runs, and any rollback completes. Contains the full outcome.

For rejected actions (not on whitelist, failed parameter validation, missing confirmation), a single rejection entry is written.

---

## Synchronisation

The local ledger is the primary record. When connectivity to a remote system is available, the ledger SHOULD be synchronised to provide an independent copy.

Synchronisation is one-way: local → remote. The remote copy is read-only from the device's perspective. This prevents a compromised remote system from affecting the local audit record.

---

## User Access

The user who owns the system MUST be able to read their audit trail. This is not just a recommendation — it is a trust requirement. A user who cannot verify what the AI has done cannot genuinely trust the AI.

Provide a human-readable view of the audit trail that shows:
- What the AI did, in plain language
- When it happened
- Whether it worked
- Whether anything was rolled back

A technical JSON ledger is not sufficient for user access. A plain-language summary view is required.

---

## Session Tracking

All actions within a single user interaction session share a session ID. This allows reconstruction of a complete interaction: what the user said, what the AI diagnosed, what actions were taken in sequence, and the overall outcome.

Session IDs must be generated at the start of each interaction and persisted through all associated actions.

---

*[Back: 03 — Action Layer](03-action-layer.md) | [Next: 05 — Prompt Injection](05-prompt-injection.md)*
