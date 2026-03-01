# AAO — Section 14: Risk Register and NIST MAP Alignment

> **⚠️ DISCLAIMER — Framework Under Development**
>
> *The methodology presented in this document is a conceptual framework currently under active development and has not been formally tested, validated, or peer-reviewed. It should not be interpreted as a finalized standard, best practice, or certified process.*

---

## 14.1 The AAO Position on Risk

AAO is a **zero-trust framework**. It does not assume good intent, reliable behavior, or acceptable outcomes from any AI system or human actor. The governing philosophy is:

> **Trust is not evaluated at runtime. It is established before the system operates — through authorization, process, and accountability — and it is earned over time through a recorded history of compliant behavior.**

This is a fundamentally different starting point from risk-based frameworks, which typically ask "what is the probability and magnitude of harm?" and calibrate controls accordingly. AAO instead asks: "Who is authorized to act? What are they authorized to do? Is every action recorded and signed off by a named individual?"

The result is that **risk assessment in AAO is not a runtime function — it is a design-time function**. Risk is assessed when the system is designed, when the whitelist is built, when operators are authorized, and when deployment scope is defined. At runtime, the process enforces what was decided at design time. The operator's sign-off closes the accountability loop.

This is why AAO's control structure naturally satisfies many NIST AI RMF requirements — not because it was designed around them, but because zero-trust and accountability-first design produces similar outcomes to systematic risk management, while being simpler to operate and harder to circumvent.

---

## 14.2 Where Risk Assessment Lives in AAO

Risk assessment happens at **three defined points** in the AAO lifecycle:

**Point 1 — System Authorization (before deployment)**
This is the primary risk assessment. It produces the Deployment Authorization Document (see Section 14.4), which must be signed off by the organizational authority before the system operates. This document captures context, scope, operator roles, the action whitelist rationale, and identified risks with their mitigations.

**Point 2 — Whitelist Design (at design time)**
Each action on the whitelist carries a risk level (Info / Low / Medium / High as defined in Section 4). Assigning this level IS a risk assessment — a deliberate judgment about the consequence of that action failing or being misused. This judgment is made by authorized people at design time and recorded in the immutable base. It cannot be changed at runtime.

**Point 3 — Periodic Review (ongoing)**
The Failure Intelligence System (Section 8) and the Artifact Repository (Section 12) together produce the evidence base for periodic risk re-assessment. As the system accumulates operational history, the original risk assessments can be validated or revised. This feeds a new Deployment Authorization Document if the system scope or risk profile has materially changed.

---

## 14.3 NIST AI RMF MAP Function Alignment

The NIST AI RMF MAP function establishes context and frames risks. Its five categories and subcategories map directly onto AAO's design-time risk assessment process. The table below shows how each MAP subcategory is satisfied by AAO elements.

**AAO implementers should use this table as a checklist when completing the Deployment Authorization Document (Section 14.4).**

### MAP 1 — Context is Established and Understood

| NIST Subcategory | AAO Implementation | Where Documented |
|---|---|---|
| **MAP 1.1** — Intended purposes, context-specific laws, norms, expectations, and prospective deployment settings are understood and documented | The Deployment Authorization Document requires explicit statement of intended use, deployment environment, applicable regulations, and operator profile | Deployment Authorization Document §1 |
| **MAP 1.2** — Interdisciplinary AI actors and competencies are documented; participation is recorded | Operator Registry defines all authorized humans and their roles; Authorization Code issuance is recorded | Operator Registry (Section 12.5) |
| **MAP 1.3** — The organization's mission and relevant goals for AI technology are understood and documented | System Purpose Statement in the Deployment Authorization Document | Deployment Authorization Document §2 |
| **MAP 1.4** — Business value or context of use is clearly defined | Deployment scope and use case definition required before whitelist design | Deployment Authorization Document §3 |
| **MAP 1.5** — Organizational risk tolerances are determined and documented | Risk tolerance drives whitelist action risk level assignments and confirmation requirements | Whitelist Design Record (Section 14.5) |
| **MAP 1.6** — System requirements are elicited from relevant AI actors and design decisions account for socio-technical implications | Human-AI configuration is explicitly designed — who sees what, who approves what, what can the AI never do | Section 12 (Human Sign-Off); Section 3 (Four-Layer Architecture) |

### MAP 2 — Categorization of the AI System

| NIST Subcategory | AAO Implementation | Where Documented |
|---|---|---|
| **MAP 2.1** — Specific tasks and methods the AI system will support are defined | The action whitelist is the authoritative definition of what the AI can do. Nothing outside the whitelist exists from the system's perspective | Whitelist (Section 4); Deployment Authorization Document §4 |
| **MAP 2.2** — Information about the system's knowledge limits and human oversight is documented | Confirmation requirements per risk level define exactly where human oversight is required. Layer 4 / Layer 3 separation defines what the AI can know vs. what it can act on | Section 3 (Four Layers); Section 4 (Action Layer) |
| **MAP 2.3** — Scientific integrity and TEVV considerations are documented | Whitelist boundary testing, prompt injection testing, rollback testing, and partition integrity testing are required by Section 9 (SDLC Integration) | Section 9 (SDLC); Test records in Artifact Repository |

### MAP 3 — AI Capabilities, Goals, Benefits, and Costs Are Understood

| NIST Subcategory | AAO Implementation | Where Documented |
|---|---|---|
| **MAP 3.1** — Potential benefits of intended AI functionality are examined and documented | Benefits statement required in Deployment Authorization Document | Deployment Authorization Document §5 |
| **MAP 3.2** — Potential costs, including from AI errors, are examined and documented | Risk Register (Section 14.5) captures failure modes and their organizational cost. This explicitly connects to organizational risk tolerance | Risk Register |
| **MAP 3.3** — Targeted application scope is specified and documented | The whitelist IS the scope boundary. Actions not on the whitelist cannot be requested, regardless of what the AI infers. Scope is therefore structurally enforced, not just documented | Whitelist; Deployment Authorization Document §3 |
| **MAP 3.4** — Processes for operator and practitioner proficiency are defined, assessed, and documented | Authorization Code issuance requires demonstrated operator proficiency. Role definitions specify required competencies | Operator Registry; Deployment Authorization Document §6 |
| **MAP 3.5** — Processes for human oversight are defined, assessed, and documented | End-of-session review, sign-off requirement, and confirmation requirements per action risk level constitute the complete human oversight framework | Section 12 (Sign-Off); Section 4 (Confirmation Requirements) |

### MAP 4 — Risks and Benefits Are Mapped for All Components

| NIST Subcategory | AAO Implementation | Where Documented |
|---|---|---|
| **MAP 4.1** — Approaches for mapping AI technology and legal risks of components are documented | Third-party AI model risks are documented in the Deployment Authorization Document. The separation of AI model (Layer 4) from action execution (Layer 3) is the primary control | Deployment Authorization Document §7 |
| **MAP 4.2** — Internal experts who identify, assess, and manage risks are involved with deployment decisions | Organizational authority sign-off on the Deployment Authorization Document is mandatory. This is not a technical team decision — it requires executive accountability (per NIST GOVERN 2.3) | Deployment Authorization Document — Authority Sign-Off |

### MAP 5 — Likelihood and Impact of Identified Risks Are Estimated

| NIST Subcategory | AAO Implementation | Where Documented |
|---|---|---|
| **MAP 5.1** — Likelihood and magnitude of each identified risk are documented, including expected and unexpected risks | Risk Register (Section 14.5) requires likelihood and impact rating for each identified risk, with residual risk after AAO controls are applied | Risk Register |
| **MAP 5.2** — Practices for regular engagement with AI actors and integration of feedback are in place | Failure Intelligence System (Section 8) and the Artifact Repository rejection workflow (Section 12.6.4) create structured feedback loops | Section 8; Section 12 |

---

## 14.4 The Deployment Authorization Document

The Deployment Authorization Document (DAD) is the primary risk assessment artifact for an AAO-compliant system. It must be completed before the system is authorized to operate and must be signed off by the organizational authority using the Authorization Code system (Section 12.5).

**It is not a risk management exercise. It is an authorization act.** The authority who signs it is declaring: "I understand what this system does, what it can and cannot touch, who operates it, and I authorize it to run." That declaration, backed by the immutable record in the Artifact Repository, is the foundation of trustworthiness.

### Required Sections

**§1 — Deployment Context**
- Operational environment (physical location, network context, connectivity constraints)
- Applicable laws and regulations
- Intended operator profile and technical competency baseline
- Users and affected parties who interact with or are impacted by the system

**§2 — System Purpose Statement**
- The specific problem this AI system is deployed to solve
- Why an AI system (rather than a non-AI approach) is appropriate for this purpose
- Organizational goals this system advances

**§3 — Deployment Scope**
- What the system is authorized to do (reference to the approved whitelist)
- What the system is explicitly NOT authorized to do (scope exclusions)
- Geographic, network, or physical boundaries on deployment

**§4 — Action Whitelist Summary**
- Count of actions by risk level (Info / Low / Medium / High)
- Rationale for any High-risk actions included
- Confirmation requirement summary

**§5 — Benefits Statement**
- Quantified or estimated operational benefits
- Non-monetary benefits (safety, reliability, consistency)

**§6 — Operator Authorization**
- Named operators and their roles
- Competency requirements and how they were verified
- Authorization Code issuance records

**§7 — Third-Party AI Component Risk**
- AI model provider and version
- Data handling and privacy considerations
- Dependency on external connectivity and fallback behavior if unavailable

**§8 — Authority Sign-Off**
- Name, title, and organizational role of authorizing individual
- Date of authorization
- Authorization Code signature (hash recorded in Artifact Repository)
- Review schedule (when this authorization will be reconsidered)

---

## 14.5 The Risk Register

The Risk Register is completed as part of the Deployment Authorization Document process. Unlike a traditional risk register that is revisited periodically, the AAO Risk Register serves a specific purpose: **it documents why the organizational authority was comfortable authorizing the system to operate.** It is a point-in-time justification, not an ongoing monitoring tool (monitoring is handled by the Failure Intelligence System and Artifact Repository).

See `templates/risk-register.md` for the complete Risk Register template.

### Risk Register Structure

For each identified risk, the register captures:

| Field | Description |
|---|---|
| Risk ID | Unique identifier (e.g., RSK-001) |
| Risk Description | Plain-language description of what could go wrong |
| NIST MAP Reference | Which MAP subcategory this risk relates to (e.g., MAP 3.2) |
| Affected Layer | Which AAO layer this risk originates in or affects |
| Likelihood (Pre-Control) | High / Medium / Low — before AAO controls are applied |
| Impact (Pre-Control) | High / Medium / Low — consequence if the risk materializes |
| AAO Control | Which AAO mechanism mitigates this risk |
| Residual Likelihood | High / Medium / Low — after AAO controls |
| Residual Impact | High / Medium / Low — after AAO controls |
| Residual Risk Accepted By | Name and role of person accepting residual risk |
| Notes | Any context, conditions, or monitoring commitments |

### Standard Risk Categories for AAO Systems

Every Risk Register for an AAO implementation should assess risks in these categories at minimum:

**AI Misdiagnosis Risk** — The AI correctly executes a whitelisted action, but the action was based on an incorrect diagnosis. Mitigated by: human sign-off, confirmation requirements for Medium/High actions, rollback capability.

**Whitelist Boundary Risk** — The whitelist contains an action that is too broad or poorly defined, enabling unintended consequences within its scope. Mitigated by: whitelist review process in Section 9 SDLC, prompt injection testing, scope specificity requirements.

**Prompt Injection Risk** — Crafted input causes the AI to request actions not intended by the legitimate operator. Mitigated by: Section 7 (Prompt Injection Defences), action validation at Layer 3, operator confirmation for elevated risk levels.

**Operator Error Risk** — An authorized operator signs off on an artifact without adequate review. Mitigated by: Session Summary design that makes review practical, rejection workflow, audit trail enabling post-hoc detection.

**Base Integrity Risk** — The immutable base is compromised, corrupting the whitelist or action definitions. Mitigated by: boot-time integrity verification (Section 3.1.5), signed update packages, factory reset capability.

**Third-Party AI Model Risk** — The AI model provider changes behavior, is unavailable, or produces unexpectedly poor outputs. Mitigated by: offline operation capability, action Layer independence from AI model specifics, human sign-off on all consequential outputs.

**Authorization Scope Creep Risk** — Over time, operators are authorized for more than their role requires, or the whitelist expands beyond original intent. Mitigated by: Deployment Authorization Document review schedule, Authorization Code rotation, periodic whitelist audit.

---

## 14.6 AAO Trustworthiness Statement

The NIST AI RMF identifies trustworthiness characteristics for AI systems. The following table documents how AAO addresses each characteristic — not through policy, but through structural controls.

| NIST Trustworthiness Characteristic | AAO Structural Control |
|---|---|
| **Valid and Reliable** | Whitelist boundary testing required before production deployment (Section 9). Health checks verify expected outcomes after every action. |
| **Safe** | Automatic rollback on health check failure (Section 6). High-risk actions require explicit human confirmation. No action outside the whitelist is possible. |
| **Secure and Resilient** | Immutable base partition prevents AI from corrupting its own control structures. Prompt injection defences in Section 7. Factory reset always available. |
| **Accountable and Transparent** | Every action is logged in the append-only audit ledger. Every consequential output is signed off by a named individual. Audit access is available at any time without preparation. |
| **Explainable and Interpretable** | The AI operates in Layer 4 (conversation) where its reasoning is visible. The separation between diagnosis (Layer 4) and action (Layer 3) means humans can always see what the AI concluded before action is taken. |
| **Privacy-Enhanced** | Data handling addressed in Deployment Authorization Document §7. Runtime layer isolation prevents AI from accessing data outside its defined scope. |
| **Fair with Harmful Bias Managed** | Operator proficiency requirements and diversity considerations in Operator Authorization (DAD §6). Failure Intelligence System identifies systematic error patterns. |

---

*Part of the AAO — Autonomous Action Operating Methodology*
*© 2026 Donald Moskaluk | AtMyBoat.com*
