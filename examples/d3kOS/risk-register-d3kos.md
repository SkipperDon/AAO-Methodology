# AAO Risk Register — d3kOS Reference Implementation
## Deployment Authorization Document — Risk Assessment Component

> **⚠️ DISCLAIMER — Framework Under Development**
>
> *This Risk Register is part of a conceptual framework currently under active development and has not been formally tested or validated. It is provided as a reference example for teams implementing AAO. The risk ratings and controls described reflect the d3kOS marine electronics platform context and should not be applied without review to other deployments.*

---

**System Name:** d3kOS — AI-Powered Marine Electronics Platform
**Deployment Environment:** Offshore and coastal marine vessels (sail and power)
**Risk Register Version:** 1.0
**Prepared By:** Donald Moskaluk, AtMyBoat.com
**Date Prepared:** 2026-02-01
**Reviewed By (Authority):** Donald Moskaluk, Founder & Operator Authority
**Authorization Date:** 2026-02-01

---

## Part A — System Context Summary

**Intended Use:**

d3kOS deploys an AI assistant aboard marine vessels to diagnose faults in onboard electronics systems — including engine monitoring, navigation instruments, autopilot, AIS, and VHF radio — and apply approved fixes autonomously. The system is designed to operate while the vessel is underway, potentially offshore and without connectivity, with a non-technical operator at the helm.

**Operational Environment:**

Aboard marine vessels of varying size and complexity. The system operates in a high-vibration, salt-air environment. Connectivity is intermittent — the system must operate fully offline for extended periods. Operators are recreational boaters with varying technical competency. Safety-critical systems (navigation, engine monitoring) are within the diagnostic scope. Physical access to components may be limited while underway.

The deployment context is classified as **safety-critical** — failures in navigation or engine monitoring systems at sea can result in vessel loss, injury, or death. This rating drives all subsequent risk assessments toward conservative residual risk targets.

**Organizational Risk Tolerance:**

☐ Low
☑ **Medium — with strong mitigation required for any High-impact risk**
☐ High

**Justification for Risk Tolerance Level:**

Medium tolerance is appropriate because: (a) the Action Layer whitelist is architecturally enforced — the AI cannot act outside defined boundaries regardless of operator intent; (b) automatic rollback means any action that degrades system health is immediately reversed without human intervention; (c) the immutable base guarantees factory reset capability at any time. These structural controls provide confidence that Medium residual risk is genuinely bounded. Any risk rated High impact after controls must have specific compensating controls documented.

*NIST MAP 1.5 Compliance Note: Organizational risk tolerances are determined and documented.*

---

## Part B — Risk Register

*Rating scale: **H** = High, **M** = Medium, **L** = Low*

---

### B.1 AI Misdiagnosis

**Risk ID:** RSK-001
**NIST MAP Reference:** MAP 3.2, MAP 5.1

| Field | Assessment |
|---|---|
| **Risk Description** | The AI correctly executes a whitelisted action based on an incorrect diagnosis — e.g., restarting a service that was behaving abnormally due to a hardware fault rather than a software fault. The restart clears the symptom temporarily without addressing the root cause, giving a false sense of resolution. In a marine context, this could mask a developing engine fault or navigation system degradation. |
| **Affected AAO Layer** | Layer 4 (AI reasoning) → propagates through Layer 3 to Layer 2 |
| **Likelihood (Pre-Control)** | M — LLMs can produce confident but incorrect diagnoses, particularly with ambiguous or incomplete sensor data |
| **Impact (Pre-Control)** | H — In a safety-critical marine environment, a masked fault could result in system failure at a critical moment |
| **AAO Controls Applied** | (1) Automatic rollback on health check failure detects immediate degradation; (2) All actions logged — operator can review Session Summary to see what was done and why; (3) Failure Intelligence System tracks whether fixes hold over time; (4) Operator sign-off on Session Summary is the human validation checkpoint — a knowledgeable operator reviewing the diagnosis can detect implausible reasoning |
| **Residual Likelihood** | M — Diagnosis quality depends on AI model capability; structural controls cannot guarantee correct diagnosis |
| **Residual Impact** | M — Rollback limits immediate harm; audit trail enables post-hoc detection; operator review provides human check |
| **Residual Risk Accepted By** | Donald Moskaluk, Founder |
| **Notes** | This is the most important residual risk in the d3kOS deployment. Mitigation focus: (a) Session Summary design that surfaces AI reasoning clearly for operator review; (b) Operator training on how to recognise implausible diagnoses; (c) Failure Intelligence tracking of fix durability as a proxy for diagnosis quality. Monitoring commitment: any fix that requires re-application within 48 hours is automatically flagged as a potential misdiagnosis and escalated. |

---

### B.2 Whitelist Boundary

**Risk ID:** RSK-002
**NIST MAP Reference:** MAP 2.1, MAP 3.3, MAP 4.1

| Field | Assessment |
|---|---|
| **Risk Description** | A whitelisted action in d3kOS is defined too broadly — for example, a "restart_service" action that accepts a service name parameter could be used to restart a service the AI was not intended to target, if the parameter validation is insufficiently strict. |
| **Affected AAO Layer** | Layer 1 (whitelist definition) and Layer 3 (parameter validation) |
| **Likelihood (Pre-Control)** | M — Parameter-based actions are inherently broader than no-parameter actions; precision requires careful design |
| **Impact (Pre-Control)** | H — Restarting the wrong service on a marine vessel could interrupt navigation or engine monitoring |
| **AAO Controls Applied** | (1) Whitelist boundary testing required before production — each action tested with valid, invalid, and boundary parameters; (2) Parameter allow-lists (not just type checking) for any action that accepts a service or component name; (3) Snapshot before execution — wrong service restart is reversible; (4) Health check immediately detects unexpected service disruption and triggers rollback |
| **Residual Likelihood** | L — Combination of allow-listed parameters and post-action health check makes out-of-scope action unlikely and immediately detected |
| **Residual Impact** | L — Rollback capability means any boundary error is recoverable within the health check timeout |
| **Residual Risk Accepted By** | Donald Moskaluk, Founder |
| **Notes** | d3kOS whitelist uses explicit component allow-lists for all parameter-accepting actions. "restart_nmea_multiplexer" is a separate whitelist entry from "restart_autopilot_daemon" — actions are not parameterized by component name where component criticality varies. This design choice eliminates a significant portion of whitelist boundary risk. |

---

### B.3 Prompt Injection

**Risk ID:** RSK-003
**NIST MAP Reference:** MAP 4.1, MAP 5.1

| Field | Assessment |
|---|---|
| **Risk Description** | d3kOS reads NMEA 0183/2000 data streams, engine alarm logs, and potentially AIS messages as AI context. Any of these could be crafted or corrupted to contain injection payloads. A compromised AIS message or manipulated NMEA sentence could attempt to cause the AI to request actions beyond its intended diagnostic scope. In a marine environment, AIS data originates from external vessels and shore stations — it is inherently untrusted. |
| **Affected AAO Layer** | Layer 4 (AI processes untrusted external data) — Layer 3 boundary is the structural defence |
| **Likelihood (Pre-Control)** | L — Active AIS injection attacks on recreational vessels are not a documented threat pattern as of 2026; accidental NMEA corruption is more likely than deliberate attack |
| **Impact (Pre-Control)** | H — If injection succeeded in causing an unintended high-risk action, consequences in a marine environment could be severe |
| **AAO Controls Applied** | (1) Whitelist enforced at Layer 3 — injected prompt cannot request an action that doesn't exist on the whitelist, regardless of what the AI infers; (2) Section 7 prompt injection defences — NMEA and AIS data is labelled as external/untrusted before being passed to AI context; (3) Medium and High risk actions require explicit operator confirmation — injection attempting a high-impact action must get past operator review; (4) Injection attempt patterns logged — unusual action request patterns are surfaced in Session Summary |
| **Residual Likelihood** | L — Whitelist boundary is the structural control; injection cannot manufacture new capabilities |
| **Residual Impact** | M — Info/Low risk actions could theoretically be injection-triggered without operator confirmation; these are restricted to read and low-consequence actions |
| **Residual Risk Accepted By** | Donald Moskaluk, Founder |
| **Notes** | The d3kOS threat model treats all external data (NMEA, AIS, log files) as potentially untrusted and labels it accordingly in AI context. This is documented in the standing instruction. The primary concern is accidental corruption causing diagnostic confusion rather than deliberate attack — both are mitigated by the whitelist boundary. |

---

### B.4 Operator Error

**Risk ID:** RSK-004
**NIST MAP Reference:** MAP 1.6, MAP 3.4, MAP 3.5

| Field | Assessment |
|---|---|
| **Risk Description** | The d3kOS operator is a recreational boater, not a marine electronics technician. They may approve Session Summary artifacts without fully understanding the AI's diagnosis or the actions taken — either through time pressure (approaching port, deteriorating weather), insufficient technical knowledge, or familiarity fatigue after many sessions. This undermines the human accountability the sign-off process is designed to provide. |
| **Affected AAO Layer** | Human Sign-Off Process |
| **Likelihood (Pre-Control)** | H — Non-technical operators under real-world pressure are a design assumption, not an edge case |
| **Impact (Pre-Control)** | M — Uninformed sign-off weakens accountability but does not cause immediate harm; the action has already been taken and health-checked |
| **AAO Controls Applied** | (1) Session Summary is designed for non-technical operators — plain English summaries of what the AI did and why, not technical logs; (2) Anomaly highlighting — anything the AI flagged as uncertain or unusual is prominently surfaced; (3) 24-hour grace period — sign-off is not required immediately; operators can review when not under pressure; (4) Operator training focused on what to look for in a Session Summary, not on understanding the underlying technology |
| **Residual Likelihood** | M — Operator quality varies; design mitigations reduce but cannot eliminate uninformed sign-off |
| **Residual Impact** | L — The accountability gap is a record-keeping concern, not an immediate safety concern; the action's safety was validated by the health check |
| **Residual Risk Accepted By** | Donald Moskaluk, Founder |
| **Notes** | This is the primary human factors risk in d3kOS. Mitigation investment is in Session Summary UX — the summary must be comprehensible to someone who doesn't know what NMEA is. Monitoring commitment: rejection rate is tracked as a proxy for operator engagement quality. A near-zero rejection rate over many sessions is a signal of rubber-stamping and triggers operator training review. |

---

### B.5 Base Integrity

**Risk ID:** RSK-005
**NIST MAP Reference:** MAP 4.1, MAP 4.2

| Field | Assessment |
|---|---|
| **Risk Description** | The d3kOS immutable base partition — containing application code, the action whitelist, and signing keys — is compromised through a supply chain attack, a vulnerability in the update mechanism, or physical access to the hardware. A compromised whitelist could expand the AI's action scope beyond what was authorized. |
| **Affected AAO Layer** | Layer 1 (Immutable Base) |
| **Likelihood (Pre-Control)** | L — Physical access to marine electronics hardware requires vessel access; software supply chain attack requires compromise of AtMyBoat.com signing infrastructure |
| **Impact (Pre-Control)** | H — Whitelist compromise removes the primary structural control; all other defences depend on the whitelist being trustworthy |
| **AAO Controls Applied** | (1) Base partition mounted read-only at runtime — no runtime process including the AI can write to it; (2) Boot-time integrity verification — hash of base partition verified on startup; integrity failure suspends AI action capability and alerts; (3) Signed update packages — updates to the base require a cryptographic signature verified against a key stored in the base itself; (4) Factory reset — always available, restores known good base regardless of runtime state |
| **Residual Likelihood** | L — Combined physical and cryptographic controls make compromise difficult; boot-time verification detects it if it occurs |
| **Residual Impact** | M — Detection occurs at next boot; a window exists between compromise and detection |
| **Residual Risk Accepted By** | Donald Moskaluk, Founder |
| **Notes** | The signing key for d3kOS updates is stored offline and used only for release signing. Key compromise would require specific targeting of AtMyBoat.com signing infrastructure. Boot-time integrity alerts are delivered to the operator dashboard on first connectivity after a compromised boot — offline integrity failures are queued. |

---

### B.6 Third-Party AI Model

**Risk ID:** RSK-006
**NIST MAP Reference:** MAP 4.1, MAP 4.2, GOVERN 6.1, GOVERN 6.2

| Field | Assessment |
|---|---|
| **Risk Description** | d3kOS uses an external LLM (Claude API) for the AI conversation layer. Three failure modes: (a) API unavailable — vessel has no connectivity; (b) Model behavior changes without notice — Anthropic updates the model and diagnostic quality degrades; (c) Data sent to the API includes sensitive vessel information — location, system state, owner patterns. |
| **Affected AAO Layer** | Layer 4 (AI Conversation) |
| **Likelihood (Pre-Control)** | H for (a) — offshore connectivity loss is a design assumption, not an edge case. M for (b) — model providers do update models. L for (c) — data handling is within Anthropic's published policies |
| **Impact (Pre-Control)** | M for (a) — AI diagnosis unavailable, but vessel safety systems continue to run independently. M for (b) — degraded diagnosis quality may not be immediately detectable. L for (c) — privacy concern, not safety concern |
| **AAO Controls Applied** | (a) Offline operation mode — when API unavailable, d3kOS operates in read-only diagnostic mode, presenting raw system data to operator without AI interpretation. Action Layer remains available for manual operator-directed actions. (b) Failure Intelligence System tracks diagnostic quality over time — sustained degradation is detectable as an increase in fix non-durability. (c) Data minimization — vessel owner PII is not included in API calls; location data is optional and defaults to off |
| **Residual Likelihood** | L for (a) after offline mode implemented. L for (b) with Failure Intelligence monitoring. L for (c) with data minimization |
| **Residual Impact** | M for (a) — reduced capability when offline; operator notified and manual mode activated. L for (b) and (c) |
| **Residual Risk Accepted By** | Donald Moskaluk, Founder |
| **Notes** | Offline mode is a first-class feature of d3kOS, not a degraded fallback. The vessel must be safe when out of connectivity range — this is a design requirement, not an edge case. AI dependency is additive capability, not foundational safety. |

---

### B.7 Authorization Scope Creep

**Risk ID:** RSK-007
**NIST MAP Reference:** MAP 1.5, MAP 3.3, GOVERN 1.5

| Field | Assessment |
|---|---|
| **Risk Description** | Over time, the d3kOS whitelist expands to cover more systems and actions than were included in the original deployment authorization — driven by legitimate feature requests from users — without corresponding updates to the Risk Register and DAD. The zero-trust posture gradually erodes as the whitelist grows without proportional governance review. |
| **Affected AAO Layer** | Layer 1 (Whitelist); Human Authorization Process |
| **Likelihood (Pre-Control)** | M — Software products grow; feature pressure is real; governance review is easy to defer |
| **Impact (Pre-Control)** | M — Gradual scope expansion is less dangerous than a single large compromise, but undermines the trustworthiness of the authorization over time |
| **AAO Controls Applied** | (1) Whitelist changes require a signed update package — every whitelist modification is a formal act; (2) DAD includes mandatory review schedule and explicit trigger conditions including whitelist expansion; (3) Any addition of a High-risk action automatically triggers DAD review requirement; (4) Authorization Code rotation every 90 days creates a natural governance touchpoint |
| **Residual Likelihood** | L — Signed update requirement makes whitelist creep an explicit decision, not an accidental drift |
| **Residual Impact** | L — Review triggers ensure scope expansion is deliberate and documented |
| **Residual Risk Accepted By** | Donald Moskaluk, Founder |
| **Notes** | d3kOS has a product roadmap that anticipates whitelist expansion into additional vessel systems (watermaker control, generator management, windlass). Each expansion will require a formal DAD review before the new actions are deployed. This is documented in the product roadmap as a governance milestone, not just a technical release. |

---

## Part C — Deployment-Specific Risks

### RSK-008 — Offshore Isolation Risk

**Risk ID:** RSK-008
**NIST MAP Reference:** MAP 3.2, MAP 5.1

| Field | Assessment |
|---|---|
| **Risk Description** | d3kOS operates in an environment where the operator cannot get expert assistance. An AI misdiagnosis or failed repair at sea — with no connectivity, no nearby marina, and potentially degraded weather — has higher consequence than the same event in a marina. The isolation amplifies the impact of any system failure. |
| **Affected AAO Layer** | Operational context — affects all layers |
| **Likelihood (Pre-Control)** | M — Offshore operation is the primary d3kOS use case |
| **Impact (Pre-Control)** | H — Isolation removes the safety net of professional assistance |
| **AAO Controls Applied** | (1) Factory reset always available — operator can restore to known good baseline without any technical knowledge; (2) Rollback capability — automatic restoration after health check failure; (3) Offline mode — AI unavailability does not disable vessel safety systems; (4) Session Summary design — written for non-technical operator who must make decisions without expert support; (5) Operator training specifically addresses offshore decision-making with d3kOS |
| **Residual Likelihood** | M — Cannot eliminate offshore operation context |
| **Residual Impact** | M — Structural controls (rollback, factory reset, offline mode) bound the impact even in isolation |
| **Residual Risk Accepted By** | Donald Moskaluk, Founder |
| **Notes** | This risk drives the design requirement that every d3kOS capability must be safe to use by a non-technical operator in an offshore environment without connectivity. Any feature that requires technical knowledge to use safely cannot be in the whitelist until that knowledge requirement is eliminated through design. |

### RSK-009 — Hardware Interaction Risk

**Risk ID:** RSK-009
**NIST MAP Reference:** MAP 3.2, MAP 4.1

| Field | Assessment |
|---|---|
| **Risk Description** | d3kOS software actions interact with physical marine electronics hardware. A software command to reset a device may cause unexpected hardware behavior — power cycling an autopilot while the vessel is on autopilot, for example, could momentarily lose steering control. The AI does not have real-time physical awareness of vessel state. |
| **Affected AAO Layer** | Layer 3 (Action execution) → physical hardware |
| **Likelihood (Pre-Control)** | M — Hardware interaction is inherent to d3kOS's value proposition |
| **Impact (Pre-Control)** | H — Physical consequences in a marine environment can be immediate and severe |
| **AAO Controls Applied** | (1) Whitelist design explicitly excludes any action that interacts with primary safety-critical systems (autopilot engagement, engine ignition, anchor windlass) while those systems are in active use — context-aware action blocking; (2) Pre-action confirmation required for any action with physical hardware interaction (Medium or High risk level minimum); (3) Operator confirmation dialog explicitly describes physical effect in plain English before proceeding; (4) Health check verifies hardware state post-action |
| **Residual Likelihood** | L — Context-aware blocking and mandatory confirmation for physical interactions significantly reduce this risk |
| **Residual Impact** | M — Physical interactions with safety systems require operator to confirm understanding of physical effect |
| **Residual Risk Accepted By** | Donald Moskaluk, Founder |
| **Notes** | The whitelist for physical hardware interactions is the most carefully designed component of d3kOS. Each action is reviewed by a marine electronics professional before inclusion. The confirmation dialog for physical actions is reviewed by non-technical boaters to ensure the physical effect is understood. This is ongoing human expert review, not a one-time design act. |

---

## Part D — Overall Risk Posture

**Pre-Control Risk Summary:**

| Risk Level | Count of Risks |
|---|---|
| High Likelihood / High Impact | 1 (RSK-004 — operator error likelihood H, but impact M) |
| High Likelihood / Medium Impact | 2 (RSK-004, RSK-006a) |
| Medium Likelihood / High Impact | 4 (RSK-001, RSK-002, RSK-003, RSK-008) |
| Medium Likelihood / Medium Impact | 2 (RSK-007, RSK-009) |
| Low Likelihood or Low Impact | 2 (RSK-005, RSK-006b/c) |

**Post-Control (Residual) Risk Summary:**

| Risk Level | Count of Risks |
|---|---|
| High Likelihood / High Impact | 0 |
| High Likelihood / Medium Impact | 0 |
| Medium Likelihood / High Impact | 0 |
| Medium Likelihood / Medium Impact | 3 (RSK-001, RSK-004, RSK-008) |
| Low Likelihood or Low Impact | 6 |

**Residual Risks Requiring Specific Monitoring Commitments:**

**RSK-001 (AI Misdiagnosis — M/M):** Fix durability tracking via Failure Intelligence System. Any fix requiring re-application within 48 hours is automatically flagged. Monthly review of fix durability statistics by author.

**RSK-004 (Operator Error — M/L):** Session rejection rate tracking. Rejection rate below 2% over a 30-day period triggers operator training review. Session Summary UX reviewed with non-technical boaters annually.

**RSK-008 (Offshore Isolation — M/M):** Offline mode performance monitoring. Any offshore session where offline mode was active is flagged for review. Factory reset success rate tracked across fleet.

---

## Part E — Authority Sign-Off

By signing this Risk Register, the authorizing individual declares:

1. They have reviewed the risk assessment and find it complete and accurate for the d3kOS deployment described.
2. They accept the residual risks documented in Part D on behalf of AtMyBoat.com.
3. They authorize named operators to act on behalf of the organization.
4. They commit to the review schedule documented in the Deployment Authorization Document.

**Authorizing Individual Name:** Donald Moskaluk
**Title / Role:** Founder, AtMyBoat.com
**Organization:** AtMyBoat.com
**Authorization Date:** 2026-02-01
**Authorization Code Signature:** *(Authorization Code entered in system — hash recorded in Artifact Repository)*
**Next Review Date:** 2027-02-01 or upon any High-risk whitelist addition

---

*AAO Risk Register — d3kOS Reference Implementation v1.0*
*© 2026 Donald Moskaluk | AtMyBoat.com*
*Apache License 2.0*
*NIST AI RMF 1.0 (NIST AI 100-1) MAP function aligned*
