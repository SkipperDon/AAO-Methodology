# AAO — Human Sign-Off and Artifact Repository

> **⚠️ DISCLAIMER — Framework Under Development**
>
> *The methodology presented in this document is a conceptual framework currently under active development and has not been formally tested, validated, or peer-reviewed. It should not be interpreted as a finalized standard, best practice, or certified process. Organizations adopting or referencing this framework do so at their own discretion and are encouraged to apply appropriate professional judgment.*

---

## The Problem This Solves

AI systems are increasingly capable of doing real work — diagnosing issues, writing documents, executing changes, producing reports. But in any organizational context, **someone needs to be accountable for that work**.

Traditional approaches to this problem are either too heavy (formal approval processes with paperwork that nobody actually follows) or too light (nothing — the AI output just gets used with no accountability at all).

The AAO Human Sign-Off and Artifact Repository takes a third path:

- **No paperwork** — the AI's output IS the document
- **No manual tracking** — the system assembles the record automatically
- **Clear accountability** — a named person with an Authorization Code binds their identity to each approval
- **Audit-ready at all times** — no preparation required, no records to assemble

---

## How It Works

### 1. The AI Produces Artifacts

Every meaningful output from an AI session is automatically captured as an **Artifact** in the repository. The operator doesn't create these — the system does. At session end, a Session Summary Artifact is produced that references everything the AI did.

### 2. The Operator Reviews

When the session ends, the authorized operator receives a review summary: what the AI did, what it produced, any anomalies. The operator can review in their own time within the grace period (default: 24 hours).

This is the **human validation step** — the operator confirms that the AI's work was appropriate, accurate, and authorized.

### 3. The Operator Signs Off

The operator enters their **Authorization Code** — a unique, personal code bound to their identity. This is their signature. The system records:
- Who approved (linked to the code)
- What was approved (artifact ID and version)
- When it was approved (UTC timestamp)
- Any notes the operator added

The code itself is never stored — only a cryptographic hash. If the code is ever compromised, it can be revoked without affecting historical records.

### 4. The Record Is Permanent

Once signed off, the artifact is immutable. If corrections are needed, a new version is created and the original is marked as superseded — never deleted. The complete history is always preserved.

### 5. Audit Any Time

Auditors can access the full repository at any time, filter by any dimension (date, operator, session, artifact type, status), and export a structured report. No preparation, no operator involvement required.

---

## Authorization Code Design

The Authorization Code is deliberately simple to use but cryptographically sound in its storage and verification.

**For the operator:** It's a code they memorize or keep securely. They enter it to approve work — like a PIN, but longer and unique to AI artifact approval. It should not be the same as any other system password.

**For the system:** The code is hashed with a per-operator salt using a strong hashing algorithm (bcrypt or Argon2 recommended). The plaintext is never stored. Each use logs the hash comparison result and operator identity without logging the code itself.

**Recommended code format:** 4 words + 4 digits (example pattern: `marine-anchor-delta-7734`). This gives high entropy while being memorable. Alternatively, a system-generated alphanumeric code of 16+ characters stored in a password manager.

**Code rotation:** Every 90 days, or immediately if compromise is suspected. Rotation generates a new code — old sign-offs remain valid because the operator identity (not the current code) is what the historical record preserves.

---

## Session Review Flow

```
Session Ends
     │
     ▼
System generates Session Summary Artifact
(lists all actions, artifacts, outcomes, anomalies)
     │
     ▼
Operator notified (email / in-app / dashboard)
     │
     ▼
Operator reviews Session Summary
     │
     ├─► Approve all → Enter Authorization Code → Session closed, all artifacts approved
     │
     ├─► Approve selectively → Enter code per artifact → Remaining artifacts flagged
     │
     ├─► Reject artifact → Enter code + mandatory note → Rejection workflow triggered
     │
     └─► Flag for follow-up → Session stays open → Reminder at interval
```

---

## Artifact Types

| Type | Generated When | Typical Content |
|------|---------------|-----------------|
| `DIAGNOSTIC_REPORT` | AI completes a diagnosis | Observed state, root cause analysis, recommended actions |
| `ACTION_RECORD` | AI executes a whitelist action | Action name, parameters, pre/post state, outcome |
| `CHANGE_PROPOSAL` | AI proposes changes requiring human approval | Proposed action, rationale, risk assessment |
| `SESSION_SUMMARY` | Session ends | All actions, all artifacts, session outcome |
| `FAILURE_REPORT` | Health check fails or rollback triggered | What failed, rollback outcome, recommended follow-up |
| `CUSTOM` | Any other significant AI output | Defined by implementation |

---

## NIST AI RMF Alignment

The Human Sign-Off and Artifact Repository is designed to satisfy the human oversight requirements of the **NIST AI Risk Management Framework (NIST AI 100-1)** and the **NIST Generative AI Profile (NIST AI 600-1)**.

Key alignment points:

**GOVERN function** — The Authorization Code system provides clear individual accountability. The immutable repository provides organizational transparency. Neither requires process overhead to maintain.

**MANAGE function** — The end-of-session review creates a natural checkpoint where humans evaluate AI outputs and can reject or flag anything that doesn't meet expectations.

**MEASURE function** — The complete artifact record enables measurement of AI system behavior over time — how often are artifacts rejected? What types of actions generate the most operator corrections? This data feeds improvement cycles.

For teams subject to NIST AI 600-1, the repository directly addresses the **Accountability** and **Human-AI Configuration** risk categories by ensuring that:
- Every consequential AI output has an identified human approver
- The human review process is documented without creating additional documentation burden
- The complete record is available for regulatory examination without preparation

---

## Implementation Notes

**Repository technology options:** A relational database (PostgreSQL recommended) with an application layer enforcing append-only semantics. Alternatively, a blockchain-adjacent structure where each artifact record is hash-chained to the previous. The critical requirement is that modification of historical records is detectable.

**Access control:** Three roles minimum:
- **Operator** — Can produce artifacts, submit sign-offs, view own sessions
- **Administrator** — Can manage operators and codes, view all sessions, cannot modify records
- **Auditor** — Read-only access to entire repository, can export reports

**Integration with AAO Action Layer:** The Action Layer (Section 4 of the specification) should automatically create Action Record artifacts for every executed action. This happens at Layer 3 — the AI system (Layer 4) does not control artifact creation.

---

*Part of the AAO — Autonomous Action Operating Methodology*  
*© 2026 Donald Moskaluk | AtMyBoat.com*
