# 08 — Failure Intelligence System

## The Goal

Make the system more resilient over time by learning from every failure across every installation.

This is not data collection for its own sake. The Failure Intelligence System collects the minimum information needed to answer one question per failure event: how do we prevent this from happening again?

---

## The Four Questions

Every failure record answers exactly four questions:

**1. What broke?**
Service name, error type, error message (truncated to 500 chars), stack trace (truncated to 1000 chars).

**2. What was the state when it broke?**
Application version, uptime, service states, resource usage, last 60 seconds of the failing service's logs only.

**3. What fixed it?**
Action taken, who or what initiated it (AI, admin, user), time to fix, outcome.

**4. Did it stay fixed?**
Recurrence within 24 hours. Recurrence within 7 days.

Nothing else. No full log history. No continuous telemetry. No user data.

---

## Data Minimisation

A failure record SHOULD NOT exceed 5KB compressed. This constraint forces discipline:

- Log windows are truncated to 60 seconds — not the full history
- Error messages are truncated to 500 characters — enough to identify the error
- Stack traces are truncated to 1000 characters — enough to locate the issue
- No engine data, position history, or user content is captured

At 5KB per record, 1000 installations each reporting one failure per week generates 260MB per year. This fits in a free database tier.

---

## Anonymisation

Installation identifiers MUST be hashed before transmission. The centralised database stores the hash — not the actual ID.

```javascript
const crypto = require('crypto');

function anonymiseInstallationId(id) {
  return crypto.createHash('sha256').update(id).digest('hex');
}
```

This means the centralised database cannot identify which specific installation generated a failure record without the cooperation of the installation owner. Pattern analysis operates on anonymised data only.

---

## The Recurrence Rate as the Key Metric

The recurrence fields — `recurred_24h` and `recurred_7d` — are the most important fields in the entire failure record.

They reveal:
- **Low recurrence:** The fix addressed the root cause
- **High recurrence:** The fix is a temporary patch — root cause remains
- **Consistently high recurrence despite different fixes:** Hardware issue, not software

Development effort should be proportional to recurrence rate. High-recurrence patterns are the highest-priority items for the next development cycle.

---

## Failure Record Schema

```json
{
  "record_id": "uuid-v4",
  "installation_id_hash": "sha256-of-actual-id",
  "app_version": "2.0-T3",
  "runtime_info": {
    "platform": "raspberry-pi-4b",
    "uptime_seconds": 86400
  },
  "failure": {
    "timestamp": "2026-02-23T14:32:17Z",
    "service": "signalk",
    "error_type": "crash",
    "error_message": "Error: ECONNREFUSED - CAN bus timeout after 30000ms",
    "uptime_at_failure_seconds": 86400,
    "services_running": ["dashboard", "mqtt-publisher", "engine"],
    "services_stopped": ["signalk"],
    "resource_usage": {
      "cpu_temp_celsius": 67,
      "ram_used_percent": 43
    },
    "log_window_60s": "last 60 seconds of signalk log — truncated to 2KB"
  },
  "fix": {
    "action": "restart_service",
    "initiated_by": "ai_assistant",
    "time_to_fix_seconds": 45,
    "outcome": "success"
  },
  "recurrence": {
    "recurred_24h": false,
    "recurred_7d": false,
    "same_fix_resolved": null
  }
}
```

---

## Pattern Detection

With failure records accumulating across installations, pattern detection becomes possible:

- **Version correlation:** Does a specific version correlate with increased failure rate for a specific service?
- **Environment correlation:** Do specific hardware configurations correlate with specific failure types?
- **Fix effectiveness:** What is the success rate and recurrence rate for each fix type per failure type?
- **Proactive signals:** What warning signs appear in logs 24-48 hours before a known failure pattern?

Proactive scanning — checking running installations for pre-failure warning signs — is the highest-value application of the failure intelligence database. Detecting a problem before the user experiences it and offering a preventive fix is the goal.

---

*[Back: 07 — SDLC Integration](07-sdlc-integration.md) | [Back to README](../README.md)*
