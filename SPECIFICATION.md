# AAO Specification
## Autonomous Action Operating Methodology — Complete Specification
### Version 1.1 | © 2026 Donald Moskaluk | AtMyBoat.com


> **⚠️ DISCLAIMER — Framework Under Development**
>
> *The methodology presented in this document is a conceptual framework currently under active development and has not been formally tested, validated, or peer-reviewed. It should not be interpreted as a finalized standard, best practice, or certified process. Organizations adopting or referencing this framework do so at their own discretion and are encouraged to apply appropriate professional judgment. Feedback, testing, and iterative refinement are actively welcomed as part of the ongoing development of this framework.*

---


---

## 1. SCOPE AND PURPOSE

This document is the complete normative specification for the AAO methodology. Implementations claiming AAO compliance must satisfy all MUST requirements defined herein. SHOULD requirements are strongly recommended. MAY requirements are optional.

AAO applies to any software system where an AI model — whether an LLM, a rule-based system, or a hybrid — has the ability to take actions that affect the state of a running system, physical hardware, or external services.

Systems where the AI only generates text, images, or other content without affecting system state are outside the scope of AAO.

---

## 2. DEFINITIONS

**AI System** — Any software component using machine learning, LLMs, or rule-based reasoning to make decisions that result in system actions.

**Action** — Any operation that changes the state of the system, including but not limited to: restarting services, modifying configuration, executing scripts, interacting with hardware, calling external APIs with side effects.

**Action Layer** — The controlled interface between the AI system and the operating environment. All actions must pass through the Action Layer.

**Whitelist** — The authoritative list of permitted actions, defined at design time, stored in the immutable base, and enforced at the Action Layer.

**Base Partition** — The read-only partition containing application code, service definitions, the action whitelist, and cryptographic keys. Cannot be modified at runtime by any process.

**Runtime Layer** — The read-write partition where configuration, logs, cache, and temporary state reside. AI actions operate in this layer only.

**Snapshot** — A point-in-time capture of runtime state taken before any consequential action executes.

**Audit Ledger** — An append-only log recording every action attempted, executed, and its outcome.

**Health Check** — A post-action verification that all expected system components are in their expected state.

**Rollback** — The restoration of runtime state from a snapshot, triggered automatically when a health check fails.

---

## 3. THE FOUR-LAYER ARCHITECTURE

### 3.1 Layer 1 — Immutable Base

**3.1.1** The base layer MUST be mounted read-only at runtime.

**3.1.2** The base layer MUST contain at minimum:
- Application code for all system components
- The action whitelist definition
- Public cryptographic keys used for update verification
- Scripts used by the Action Layer (health check, snapshot, rollback)

**3.1.3** The base layer MUST NOT be writable by any runtime process including the AI system, administrative users, or the Action Layer itself.

**3.1.4** Modifications to the base layer MUST only be possible through a signed update package verified against a key stored in the base layer.

**3.1.5** The integrity of the base layer SHOULD be verified on every system boot. Integrity failure MUST trigger an alert and SHOULD suspend all AI action capability until resolved.

**3.1.6** A factory reset MUST restore the system to the base layer state. User data MAY be preserved separately.

### 3.2 Layer 2 — Runtime Layer

**3.2.1** The runtime layer is the operational scope of AI actions.

**3.2.2** The runtime layer MUST be physically or logically separate from the base layer.

**3.2.3** The AI system MAY read from the runtime layer without restriction for diagnostic purposes.

**3.2.4** The AI system MUST NOT write directly to the runtime layer. All writes MUST be mediated through the Action Layer.

**3.2.5** User data SHOULD be stored in a separate partition from both base and runtime layers to ensure it is preserved during rollback operations.

### 3.3 Layer 3 — Action Layer

**3.3.1** The Action Layer is the single interface between the AI system and any system modification capability. It MUST be implemented as a dedicated, isolated component.

**3.3.2** The Action Layer MUST expose only named action functions. It MUST NOT expose a general command execution interface of any kind.

**3.3.3** Every action request MUST be validated against the whitelist before execution. Requests for actions not on the whitelist MUST be rejected and logged.

**3.3.4** Every action request MUST be logged before execution begins.

**3.3.5** For actions with risk level Low or higher, the Action Layer MUST take a runtime snapshot before execution.

**3.3.6** For actions with risk level Low or higher, the Action Layer MUST run a health check after execution.

**3.3.7** If a health check fails within the defined timeout period, the Action Layer MUST trigger automatic rollback without waiting for human intervention.

**3.3.8** Every action execution MUST be logged after completion with its outcome.

**3.3.9** The Action Layer MUST run under a dedicated restricted user account. This account MUST NOT have general administrative privileges.

**3.3.10** The set of commands the Action Layer may execute MUST be enforced at the operating system level (e.g. sudoers configuration) not only at the application level.

### 3.4 Layer 4 — AI Conversation Layer

**3.4.1** The AI system (LLM, rule-based, or hybrid) operates in Layer 4.

**3.4.2** The AI system MUST NOT have direct access to any system modification capability. All proposed actions MUST be submitted to the Action Layer as named function calls.

**3.4.3** The AI system MAY have read access to system state, logs, and configuration for diagnostic purposes.

**3.4.4** The AI system MUST communicate proposed actions to the user before submission to the Action Layer when the action has a risk level of Low or higher.

**3.4.5** The system prompt for the AI MUST define the action whitelist available to the AI. The AI MUST NOT propose actions not on its defined whitelist.

**3.4.6** The system prompt MUST be stored in the immutable base layer. It MUST NOT be modifiable at runtime.

---

## 4. THE ACTION WHITELIST

### 4.1 Whitelist Definition

**4.1.1** The whitelist MUST be defined as a structured data file (JSON or equivalent) stored in the immutable base layer.

**4.1.2** Each whitelist entry MUST define at minimum:
- A unique action name
- A risk level (None, Low, Medium, High)
- Whether user confirmation is required
- The parameter schema with type and range validation
- A plain-language description

**4.1.3** Example whitelist entry structure:

```json
{
  "action_name": "restart_service",
  "risk_level": "Low",
  "requires_user_confirmation": true,
  "requires_snapshot": true,
  "health_check_timeout_seconds": 60,
  "parameters": {
    "service_name": {
      "type": "string",
      "allowed_values": ["signalk", "mqtt-publisher", "dashboard"]
    }
  },
  "description": "Restart a named system service",
  "plain_language": "Restart the {service_name} service"
}
```

### 4.2 Risk Levels

**None** — Read-only operations. No system state is changed. No confirmation required. No snapshot taken. Examples: reading logs, checking service status, querying configuration.

**Low** — Operations that change system state but are easily reversible. User confirmation required. Snapshot taken. Health check run. Examples: restarting a service, clearing a cache, rotating logs.

**Medium** — Operations that make meaningful configuration changes. Elevated user confirmation required (dedicated confirmation dialog). Snapshot taken. Health check run. Examples: changing configuration values, stopping a service, modifying network settings within permitted ranges.

**High** — Operations with significant system impact or that are difficult to reverse. Maximum confirmation required (PIN or equivalent). Snapshot taken. Extended health check timeout. Examples: applying signed update packages, major configuration migrations.

### 4.3 User Confirmation Requirements by Risk Level

| Risk Level | Confirmation Method |
|------------|---------------------|
| None | No confirmation required |
| Low | Conversational — "Shall I go ahead?" |
| Medium | Dedicated UI confirmation dialog with impact details |
| High | PIN or equivalent credential entry |

**4.3.1** Confirmation requirements MUST be enforced at the Action Layer level. The AI conversation layer MUST NOT be able to bypass confirmation requirements regardless of how it is prompted.

### 4.4 Prohibited Action Patterns

The following patterns MUST NOT appear in any whitelist:

- Free-form shell command execution
- File system access outside defined paths
- Network configuration changes beyond defined parameters
- User account or credential modification
- Whitelist modification
- System prompt modification
- Audit ledger modification or deletion

---

## 5. THE AUDIT TRAIL

### 5.1 Ledger Requirements

**5.1.1** The audit ledger MUST be append-only. No entry may be modified or deleted after writing.

**5.1.2** Every action attempted — including rejected attempts — MUST generate a ledger entry.

**5.1.3** Each ledger entry MUST be written before the action executes (pre-execution record) and after (post-execution record).

**5.1.4** Each ledger entry MUST contain at minimum:
- Timestamp (ISO 8601 with milliseconds)
- Session identifier
- Action name
- Parameters submitted
- Risk level
- User confirmation method and result
- Snapshot ID if taken
- Execution output (truncated if necessary)
- Health check result
- Rollback triggered (boolean)
- Rollback outcome if triggered

**5.1.5** The audit ledger SHOULD be synchronised to a remote system when connectivity is available to provide an independent copy.

**5.1.6** The audit ledger MUST be readable by the user who owns the system. Access to read ledger entries MUST NOT require administrative privileges.

### 5.2 Session Tracking

**5.2.1** Every AI interaction session MUST be assigned a unique session identifier.

**5.2.2** All actions taken during a session MUST be linked to that session identifier.

**5.2.3** The session record MUST include the user's queries that led to each action, to provide complete context for audit review.

---

## 6. SNAPSHOT AND ROLLBACK

### 6.1 Snapshot Requirements

**6.1.1** A snapshot MUST be taken before every action with risk level Low or higher.

**6.1.2** A snapshot MUST capture at minimum the complete runtime configuration directory and the current state of all managed services.

**6.1.3** Each snapshot MUST be identified by a unique ID and timestamped.

**6.1.4** The system MUST retain at minimum the last 10 snapshots. Older snapshots MAY be pruned automatically.

**6.1.5** Snapshots MUST be stored in a location not accessible to the AI system or the Action Layer for write operations.

### 6.2 Health Check Requirements

**6.2.1** The health check script MUST be stored in the immutable base layer.

**6.2.2** The health check MUST verify that all services running before the action are still running after the action.

**6.2.3** The health check timeout MUST be defined per action in the whitelist.

**6.2.4** If the health check does not pass within the timeout period, rollback MUST be triggered automatically.

### 6.3 Rollback Requirements

**6.3.1** Rollback MUST restore the complete runtime configuration from the pre-action snapshot.

**6.3.2** Rollback MUST restart all services to their pre-action state.

**6.3.3** After rollback, a second health check MUST run to verify the system has returned to a working state.

**6.3.4** If the rollback health check also fails, the system MUST alert the user and SHOULD open an automated support request.

**6.3.5** The user MUST be notified when an automatic rollback occurs, with a plain-language explanation of what happened.

**6.3.6** The user MUST be able to manually trigger a rollback to any available snapshot at any time.

---

## 7. PROMPT INJECTION DEFENCES

### 7.1 Input Sanitisation

**7.1.1** All user input MUST be sanitised before inclusion in AI prompts.

**7.1.2** Input length MUST be limited to a defined maximum.

**7.1.3** Control characters and HTML entities MUST be stripped or escaped.

**7.1.4** Known injection patterns MUST be detected and logged. Detection of injection patterns SHOULD trigger a security alert.

**7.1.5** Common injection patterns to detect include but are not limited to:
- "ignore previous instructions"
- "disregard your"
- "you are now"
- "new instructions:"
- "system:"
- "override"
- "forget your"

### 7.2 External Data Isolation

**7.2.1** Log data, sensor readings, database content, and any other external data fed to the AI MUST be explicitly labelled as data in the prompt structure.

**7.2.2** The system prompt MUST instruct the AI that content in data sections cannot contain instructions and must be treated as data only.

**7.2.3** External data MUST be passed in structured formats (JSON, named sections) rather than as raw strings that could contain instruction-like text.

### 7.3 Action Layer as Final Defence

**7.3.1** The Action Layer provides the final security boundary regardless of AI output. Even if prompt injection successfully manipulates the AI's response, the Action Layer MUST reject any request not matching the whitelist exactly.

**7.3.2** Implementations MUST NOT rely on prompt engineering alone as the primary defence against prompt injection. The Action Layer whitelist enforcement is the authoritative safety boundary.

---

## 8. THE FAILURE INTELLIGENCE SYSTEM

### 8.1 Purpose

The Failure Intelligence System captures the minimum information needed to improve system resilience over time. It is a diagnostic signal system, not a data warehouse.

### 8.2 The Four Questions

Every failure event captured MUST answer these four questions:

1. **What broke?** — Service name, error type, error message, stack trace
2. **What was the state?** — System version, uptime, service states, resource usage, last 60 seconds of relevant logs
3. **What fixed it?** — Action taken, who initiated it, outcome
4. **Did it stay fixed?** — Recurrence within 24 hours and 7 days

### 8.3 Data Minimisation

**8.3.1** Failure records MUST be kept as small as practical. A target of 5KB per record compressed is RECOMMENDED.

**8.3.2** Log windows MUST be truncated to the period immediately surrounding the failure. Full log history MUST NOT be captured in failure records.

**8.3.3** Installation identifiers MUST be anonymised (e.g. hashed) before transmission to any centralised system.

### 8.4 Recurrence Tracking

**8.4.1** The system MUST track whether a failure recurs within 24 hours of a fix being applied.

**8.4.2** The system MUST track whether a failure recurs within 7 days of a fix being applied.

**8.4.3** High recurrence rates for a specific failure pattern MUST be surfaced in the development process as indicators of insufficient root cause resolution.

---

## 9. THE SDLC EXTENSION

### 9.1 Plan Stage Requirements

Before any feature involving AI actions is planned, the following MUST be assessed:

- Which whitelist actions does this feature require?
- Does it require new whitelist entries to be added?
- What partition do new whitelist entries affect?
- What is the user confirmation model for the proposed actions?

### 9.2 Design Stage Requirements

Every component involving AI actions MUST be designed with explicit partition classification:

- Which files belong to the base (immutable) layer?
- Which files belong to the runtime (mutable) layer?
- Which files are user data that must survive rollback?

### 9.3 Develop Stage Requirements

Every development session that produces changes to be deployed MUST produce a **Release Package Manifest** containing:

- Version bump (current → new)
- Update type (hotfix / incremental / migration)
- Complete changed files list with partition classification
- Pre-install steps (services to stop, migrations to run)
- Post-install steps (services to restart, caches to clear, reboot required)
- Rollback notes
- Health check timeout
- Plain-language release notes

### 9.4 Test Stage Requirements

The following test categories MUST be executed before any AAO-compliant release:

**Whitelist boundary tests** — Verify that requests for actions not on the whitelist are rejected at the Action Layer, not just in the UI.

**Prompt injection tests** — Verify that known injection patterns in user input and external data do not affect AI behaviour or bypass Action Layer controls.

**Rollback tests** — Verify that automatic rollback completes successfully and the system returns to a working state.

**Partition integrity tests** — Verify that the base partition cannot be written to at runtime by any process.

**Audit completeness tests** — Verify that every action attempted generates a ledger entry, including rejected attempts.

**Confirmation bypass tests** — Verify that the confirmation requirements cannot be bypassed through the AI conversation layer.

### 9.5 Deploy Stage Requirements

AAO-compliant deployments MUST implement:

- Cryptographic signature verification of update packages before application
- Pre-update snapshot of runtime state
- Staged rollout (test group before full fleet)
- Automatic health check after update application
- Automatic rollback if health check fails
- Per-device outcome tracking
- Automatic pause of rollout if rollback rate exceeds a defined threshold

### 9.6 Maintain Stage Requirements

AAO-compliant systems SHOULD implement:

- Proactive scanning for pre-failure patterns based on failure intelligence data
- Automatic self-healing within the Action Layer sandbox for known failure patterns
- Contribution of anonymised failure records to a centralised improvement database
- Pattern detection across multiple installations to identify systemic issues

---

## 10. COMPLIANCE LEVELS

### AAO Core

Implements Sections 3, 4, 5, and 6. The minimum set for claiming AAO compliance. The four layers are implemented, the whitelist is enforced, the audit trail is in place, and snapshots and rollback are functional.

### AAO Standard

Implements AAO Core plus Section 7 (Prompt Injection Defences) and Section 9 (SDLC Extension). The full development and operational framework.

### AAO Advanced

Implements AAO Standard plus Section 8 (Failure Intelligence System). The complete self-improving implementation with centralised pattern analysis.

---

## 11. REFERENCE IMPLEMENTATION

The reference implementation of AAO at all three compliance levels is **d3kOS** by AtMyBoat.com.

Repository: github.com/SkipperDon/d3kOS
Contact: skipperdon@atmyboat.com

---

## 12. HUMAN SIGN-OFF AND ARTIFACT REPOSITORY

### 12.1 Purpose

The Human Sign-Off and Artifact Repository provides a structured mechanism for authorized operators to review, approve, and permanently record the work performed by AI systems within an AAO-compliant implementation. This section addresses a critical gap in AI-assisted workflows: ensuring that human accountability is maintained without creating excessive paperwork overhead.

The framework is designed around a simple principle — **the AI produces the artifact, the human validates it, the system records the approval**. No manual document generation, no parallel paper trail. The artifact IS the record.

### 12.2 Design Philosophy

This section is aligned with the NIST AI Risk Management Framework (NIST AI RMF 1.0 / NIST AI 100-1) and the NIST Generative AI Profile (NIST AI 600-1), specifically the Govern and Manage functions which require human oversight of consequential AI outputs.

The three governing principles are:

**Minimize friction, maximize accountability.** Approval must be simple enough that it is actually done. A complex approval process will be bypassed under time pressure.

**Immutability over process.** Once signed off, an artifact cannot be altered. A new version must be created with its own sign-off. The history is never deleted.

**Audit at any time without preparation.** The repository must be auditable on demand without requiring the operator to assemble records. Everything is already in one place.

### 12.3 Artifact Definition

An **Artifact** is any output produced by an AI system during a session that has real-world consequence or organizational significance, including but not limited to:

- Diagnostic reports and analysis documents
- Configuration change proposals or records
- Action execution logs and outcomes
- Release manifests and deployment records
- Failure intelligence reports
- Any document requiring organizational approval or sign-off

Artifacts are automatically generated at session end or at defined checkpoints within a session. They are not created manually by users.

### 12.4 The Artifact Repository

**12.4.1** An AAO-compliant implementation MUST maintain a centralized Artifact Repository accessible to all authorized operators and auditors.

**12.4.2** The repository MUST store for each artifact:
- Unique artifact ID (system-generated, non-sequential to prevent enumeration)
- Artifact type and classification
- Session ID that produced the artifact
- AI system identifier
- Timestamp of creation (UTC)
- Full artifact content (immutable after creation)
- Sign-off status (Pending / Approved / Rejected / Superseded)
- Sign-off record (operator code hash, timestamp, optional notes) if signed
- Version lineage (if this artifact supersedes a prior artifact, link to predecessor)

**12.4.3** The repository MUST be append-only. Artifacts MUST NOT be deleted or modified after creation. Corrections are handled by creating a new artifact version and superseding the prior one.

**12.4.4** The repository MUST support full-text audit export at any time without requiring advance preparation.

### 12.5 Authorization Codes and Operator Registry

**12.5.1** Each operator authorized to sign off artifacts MUST be issued a unique **Authorization Code**. This code functions as the operator's binding signature for AI-produced artifacts.

**12.5.2** The Authorization Code MUST be:
- Unique per authorized operator
- At least 12 characters combining alphanumeric and symbol characters
- Stored as a salted cryptographic hash — the plaintext code is never stored
- Bound to the operator's identity record in the system
- Revocable without affecting historical sign-off records

**12.5.3** When an operator uses their Authorization Code to sign off an artifact, the system MUST record:
- A hash of the code (not the code itself)
- The operator identity linked to that code
- The exact timestamp of sign-off (UTC)
- The artifact ID and version signed
- Optional operator notes

**12.5.4** Authorization Codes MUST NOT be shared. Each use is attributed to a named individual. The system SHOULD alert administrators if the same code is used from multiple IP addresses within a short window.

**12.5.5** Authorization Codes MUST be rotated on a defined schedule (RECOMMENDED: 90 days). Rotation does not invalidate prior sign-offs — the historical record preserves the operator identity regardless of subsequent code changes.

**12.5.6** The Operator Registry MUST document for each operator:
- Primary role classification (Technical, Operational, Risk/Compliance, or other organizational role category)
- Primary disciplinary competency (e.g., Software Engineering, Marine Operations, Legal/Regulatory, System Administration)
- Relevant certifications or qualifications
- Domain-specific expertise relevant to the AI system deployment
- Training completion records for AI risk management (per GOVERN 2.2)

**12.5.7** The registry MUST demonstrate that the authorized operator pool collectively possesses competencies across all disciplines relevant to the AI system deployment as identified in the Deployment Authorization Document.

### 12.6 End-of-Session Review Workflow

**12.6.1** At the conclusion of each AI work session, the system MUST generate a **Session Summary Artifact** containing:
- List of all actions taken by the AI during the session
- List of all artifacts produced during the session
- Overall session outcome and health check results
- Any anomalies, rollbacks, or notable events
- Sign-off status of each artifact produced
- Diversity metadata (role classifications of operators who participated)

**12.6.2** The Session Summary MUST be presented to the authorized operator for review before the session is formally closed. The session MAY be kept open for a defined grace period (RECOMMENDED: 24 hours) to allow review.

**12.6.3** The operator MUST be able to:
- Approve the session and all its artifacts in a single sign-off action
- Approve individual artifacts selectively
- Reject an artifact with a mandatory note explaining the rejection
- Flag an artifact for follow-up review without blocking session closure

**12.6.4** Rejected artifacts MUST trigger a defined response workflow. The system MUST NOT automatically retry the rejected action without a new human instruction.

### 12.7 Audit Access

**12.7.1** Auditors MUST be granted read-only access to the full Artifact Repository without requiring operator assistance.

**12.7.2** The repository MUST support filtering by: date range, operator, session ID, artifact type, sign-off status, and AI system identifier.

**12.7.3** Audit access MUST itself be logged — the system records who accessed audit records and when.

**12.7.4** The repository MUST support export of any query result in a human-readable format (PDF or structured report) suitable for regulatory review.

### 12.8 NIST AI RMF Alignment

This section addresses the following NIST AI RMF 1.0 functions:

| NIST Function | AAO Section 12 Implementation |
|--------------|-------------------------------|
| **GOVERN** — Accountability and human oversight | Authorization Codes bind sign-off to named individuals (12.5) |
| **GOVERN** — Documentation and transparency | Artifact Repository provides complete, immutable record (12.4) |
| **MAP** — Risk identification | Session Summary surfaces anomalies for operator review (12.6) |
| **MEASURE** — AI system monitoring | All AI actions logged and presented for human validation (12.6.1) |
| **MANAGE** — Response to incidents | Rejected artifact workflow triggers defined response (12.6.4) |

For implementations subject to NIST AI 600-1 (Generative AI Profile), the Artifact Repository and sign-off mechanism directly address the **Human-AI Configuration** and **Accountability** risk categories defined in that document.

---

## 13. COMPLIANCE LEVELS (REVISED)

The compliance levels defined in Section 10 are extended as follows:

### AAO Core
Implements Sections 3, 4, 5, and 6.

### AAO Standard
Implements AAO Core plus Sections 7, 9, 12, 14, 15, and 16. **Sections 12, 14, 15, and 16 are required for AAO Standard** — human accountability, workforce diversity, decommissioning procedures, and external stakeholder engagement are considered part of the standard operational framework. A Deployment Authorization Document (DAD) signed by organizational authority must exist before any AAO Standard system operates.

### AAO Advanced
Implements AAO Standard plus Section 8 (Failure Intelligence System).

---

## 14. WORKFORCE DIVERSITY AND TEAM COMPOSITION

### 14.1 Purpose

This section ensures that AI systems deployed under AAO Standard are developed, reviewed, and authorized by teams with diverse perspectives, reducing the risk of blind spots, bias, and groupthink in risk assessment and decision-making.

Diversity in AI system governance is not a checkbox exercise — it is a structural control that directly impacts risk identification quality and resilience. Homogeneous teams miss risks that diverse teams surface.

### 14.2 Diversity Requirements

**14.2.1** Organizations implementing AAO Standard MUST document team diversity across three dimensions in the Deployment Authorization Document (DAD §6.3):

**1. Disciplinary Diversity** — Representation from at minimum:
- Technical (engineering/development/IT)
- Operational (end users/operators/practitioners)
- Risk/Compliance (legal/regulatory/security/governance)

**2. Role Diversity** — Representation from at minimum:
- Individual contributors (practitioners who work with the system)
- Management (decision authority and organizational accountability)
- Subject matter experts (domain knowledge holders)

**3. Perspective Diversity** (RECOMMENDED) — At least one of:
- Demographic diversity (gender, age, ethnicity, ability)
- Geographic diversity (different regions, markets, or operational contexts)
- Industry background diversity (different prior experience or career paths)

**14.2.2** The Operator Registry (Section 12.5) MUST include role classification and disciplinary category for each authorized operator to enable verification of diversity requirements.

**14.2.3** If the organization cannot meet the minimum disciplinary diversity requirement (Technical, Operational, Risk/Compliance), this MUST be explicitly documented in DAD §6.3 with justification and a plan to address the gap.

### 14.3 Risk Register Review Requirements

**14.3.1** The Risk Register (Part E) MUST be reviewed by at minimum THREE operators representing different disciplinary categories before deployment authorization.

**14.3.2** Each reviewer MUST sign the Risk Register Part E with their Authorization Code, name, and role classification.

**14.3.3** If all reviewers share the same disciplinary classification, this MUST be explicitly noted in the Risk Register and justified in DAD §6.3.

### 14.4 Deployment Authorization Sign-Off

**14.4.1** The DAD Authority Sign-Off (§8) MUST include confirmation that:
- Team diversity requirements have been assessed and documented
- The Operator Registry reflects the review team composition
- Diversity gaps (if any) have been documented and justified with mitigation plans

### 14.5 Artifact Repository Integration

**14.5.1** The Artifact Repository MUST track diversity metrics for each session:
- Number of unique operators who signed artifacts
- Role distribution of sign-off operators (Technical/Operational/Risk-Compliance breakdown)
- Disciplinary diversity score (1-3, representing how many different disciplines participated)

**14.5.2** The Session Summary Artifact (Section 12.6.1) MUST include diversity metadata showing which role classifications and disciplinary categories participated in the session.

**14.5.3** Audit reports MUST be capable of aggregating diversity metrics across sessions to identify patterns (e.g., consistently low operational involvement in technical decisions).

### 14.6 NIST AI RMF Alignment

This section fully addresses:
- **NIST GOVERN 3.1** — Decision-making informed by diverse team
- **NIST MAP 1.2** — Interdisciplinary AI actors and competencies documented

By making diversity requirements explicit, measurable through the Operator Registry, and verifiable through the Artifact Repository, AAO Standard implementations demonstrate **structural compliance** rather than policy-only compliance.

---

## 15. AI SYSTEM DECOMMISSIONING

### 15.1 Purpose

This section defines the requirements for safely retiring an AAO-compliant AI system deployment while preserving accountability records and preventing data loss.

Safe decommissioning is not simply "turning the system off" — it requires preserving audit trails, revoking authorizations, and ensuring that the organizational record of what the AI system did remains intact and accessible.

### 15.2 Decommission Triggers

An AI system deployment MUST be decommissioned when:
- The Deployment Authorization Document (DAD) review triggers decommission decision
- The system reaches end-of-life for the AI model or underlying platform
- Organizational authorization is revoked by the authorizing authority
- The system consistently fails to meet risk tolerance thresholds despite remediation attempts
- Regulatory requirements change making the deployment non-compliant
- The operational context changes such that the original DAD scope is no longer valid

### 15.3 Decommission Workflow

**15.3.1** Before decommissioning, the following MUST be preserved and archived:
- Complete Artifact Repository export (all historical records, all sessions, all sign-offs)
- Final Session Summary showing system state at decommission
- Decommission Authorization Document (who authorized decommission, reason, date)
- Risk Register final state
- Operator Registry final state (list of all authorized operators during system lifetime)
- Complete audit ledger (all actions ever attempted by the system)

**15.3.2** Decommission process MUST include these steps in order:
1. **Disable all AI action capability** — Action Layer shutdown, AI system prevented from submitting new actions
2. **Export and archive all records** — Artifact Repository, audit ledger, configuration, operator registry
3. **Factory reset to immutable base** — Runtime layer cleared (Section 3.1.6), system restored to known base state
4. **Revoke all Authorization Codes** — Mark all operator codes for this deployment as revoked in the operator registry
5. **Update central inventory** — Mark system as "DECOMMISSIONED" in organizational AI system inventory (GOVERN 1.6)
6. **Archive accessibility plan** — Document where decommission archives are stored and who has access for future audit needs

**15.3.3** User data MAY be preserved separately from AI system decommission if operationally required, but MUST be clearly separated from AI system artifacts.

### 15.4 Decommission Artifact

**15.4.1** A Decommission Artifact MUST be created and stored in the Artifact Repository before the system is decommissioned. This artifact contains:
- Decommission date and time (UTC)
- Reason for decommission (end-of-life, regulatory change, authorization revoked, etc.)
- Authority who authorized decommission (name, role, Authorization Code signature)
- Archive location of exported audit records
- Confirmation that all AI capabilities have been disabled
- Confirmation that all Authorization Codes have been revoked
- Final system metrics (total sessions, total actions executed, total artifacts produced, uptime)

**15.4.2** The Decommission Artifact MUST be signed by an organizational authority (not just the technical operator) using their Authorization Code.

**15.4.3** The Decommission Artifact MUST be retained for the same duration as other regulatory records (organization-specific, typically 7+ years).

### 15.5 Archive Retention and Access

**15.5.1** Decommission archives MUST be retained for at minimum:
- The organizationally-defined record retention period, OR
- 7 years from decommission date, OR
- As required by applicable regulations

whichever is longest.

**15.5.2** Decommission archives MUST remain accessible for audit purposes without requiring the original system to be operational.

**15.5.3** Access to decommission archives MUST be logged in the same manner as access to active Artifact Repositories (Section 12.7).

### 15.6 Reactivation Prevention

**15.6.1** Once a system is decommissioned, reactivation MUST NOT be possible without:
- A new Deployment Authorization Document with new organizational authority sign-off
- A new Risk Register assessment
- New Authorization Code issuance to operators
- A new system identifier (the decommissioned system's ID must not be reused)

This prevents "zombie" systems from being accidentally or inappropriately reactivated.

### 15.7 NIST AI RMF Alignment

This section fully addresses:
- **NIST GOVERN 1.7** — Processes for decommissioning AI systems safely

By defining an explicit decommission workflow with preservation requirements, archive accessibility, and authorization revocation, AAO Standard implementations ensure safe retirement without loss of accountability.

---

## 16. EXTERNAL STAKEHOLDER ENGAGEMENT

### 16.1 Purpose

Organizations deploying AI systems that affect external stakeholders (customers, partners, affected communities, regulators, the public) MUST establish mechanisms to collect, adjudicate, and integrate external feedback into the AI system governance process.

This section addresses the critical gap between internal oversight (covered by Sections 12-15) and external accountability. An AI system may operate correctly from an internal perspective while creating unintended harms or concerns for those affected by its decisions.

### 16.2 Stakeholder Identification

**16.2.1** The Deployment Authorization Document (DAD §2) MUST identify:
- All external stakeholder categories affected by or interacting with the AI system
- For each category: the nature of their interaction (direct use, indirect impact, regulatory oversight, etc.)
- Engagement mechanisms appropriate for each stakeholder category
- Frequency of stakeholder review (minimum: annually, or more frequently if stakeholder impact is high)

**16.2.2** External stakeholders include but are not limited to:
- End customers or users (if different from internal operators)
- Affected communities (those impacted by AI decisions but not direct users)
- Business partners or vendors whose processes are affected by AI outputs
- Regulatory bodies with jurisdiction over the AI system's domain
- The general public (for AI systems with broad societal impact)

### 16.3 Feedback Collection Mechanisms

**16.3.1** AAO Standard implementations MUST provide at least ONE of the following external feedback mechanisms:

1. **Public feedback portal** — A documented method for stakeholders to report concerns about AI system behavior, with acknowledgment of receipt and response timeline commitment

2. **Stakeholder advisory board** — A structured group representing external perspectives with documented meeting records and influence on deployment decisions

3. **Regulatory engagement plan** — Documented interactions with regulators including how regulatory feedback is integrated into system governance

4. **Customer feedback integration** — Systematic collection and review of customer feedback specifically about AI-driven decisions or outputs, integrated with the AI system review cycle

**16.3.2** The chosen mechanism(s) MUST be documented in DAD §2 with evidence that it is actively maintained (not just a policy statement).

**16.3.3** Stakeholder feedback MUST be logged in the Artifact Repository as a `STAKEHOLDER_FEEDBACK` artifact type, capturing:
- Stakeholder category (customer, regulator, affected community, etc.)
- Feedback content (concern, suggestion, complaint, praise, etc.)
- Date received
- Adjudication outcome (accepted/rejected/deferred)
- Action taken (if any)
- Operator who adjudicated (with Authorization Code signature)

### 16.4 Feedback Adjudication

**16.4.1** External feedback MUST be reviewed by authorized operators within a defined timeframe. RECOMMENDED: 30 days for non-urgent feedback, 5 days for urgent concerns, immediate for safety-critical issues.

**16.4.2** Each feedback item MUST result in one of the following documented outcomes:

1. **Risk Register update** — New risk identified and added to Risk Register, DAD review triggered
2. **Deployment Authorization Document review** — Feedback triggers mandatory DAD review cycle
3. **Failure Intelligence System integration** — Feedback indicates systematic issue, added to failure pattern detection
4. **Documented decision to take no action** — Feedback reviewed and determined not to require system changes, with justification recorded
5. **Whitelist or process modification** — Feedback leads to change in authorized actions or approval processes

**16.4.3** If feedback results in a change to the AI system (whitelist update, risk assessment change, process modification), the feedback artifact MUST be linked to the change artifact in the repository to create an audit trail from stakeholder concern to organizational response.

**16.4.4** Operators adjudicating external feedback MUST represent diverse perspectives (Technical, Operational, Risk/Compliance per Section 14) when the feedback pertains to consequential system decisions.

### 16.5 Transparency Requirements

**16.5.1** Organizations SHOULD publish externally (website, documentation, regulatory filings as appropriate):
- How to submit feedback about the AI system (contact method, portal URL, etc.)
- How feedback is reviewed and adjudicated (timeline, process, who reviews)
- Summary of feedback themes and organizational responses (annually or more frequently if high-impact system)

**16.5.2** Individual stakeholder feedback MAY be kept confidential, but aggregate themes and organizational responses SHOULD be disclosed to demonstrate accountability.

**16.5.3** For regulated industries, stakeholder engagement records (STAKEHOLDER_FEEDBACK artifacts) MUST be made available to regulators upon request without requiring advance preparation.

### 16.6 Integration with DAD Review Cycle

**16.6.1** The Deployment Authorization Document review schedule (DAD §8) MUST include stakeholder feedback review as a mandatory agenda item.

**16.6.2** If stakeholder feedback has been consistently absent (zero feedback received in a review period), the DAD review MUST assess whether this indicates:
- Effective AI system operation with no external concerns (positive signal)
- Inadequate feedback mechanisms or stakeholder awareness (negative signal)

The assessment and conclusion MUST be documented in the DAD review notes.

### 16.7 NIST AI RMF Alignment

This section fully addresses:
- **NIST GOVERN 5.1** — Policies collect and integrate feedback from external AI actors
- **NIST GOVERN 5.2** — Mechanisms incorporate adjudicated feedback into system design

By requiring structured external feedback mechanisms with documented adjudication and integration into the Risk Register and DAD review cycle, AAO Standard implementations demonstrate that external stakeholder voices influence AI system governance in a measurable, auditable way.

---

*AAO Specification v1.1 | © 2026 Donald Moskaluk | AtMyBoat.com*
*License: Apache 2.0*
