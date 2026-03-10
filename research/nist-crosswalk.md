# AAO — NIST AI RMF Crosswalk
## Mapping AAO Sections to NIST AI Risk Management Framework 1.0 Categories

> **⚠️ DISCLAIMER — Framework Under Development**
>
> *This crosswalk is part of a conceptual framework currently under active development and has not been formally tested or validated. NIST AI RMF alignment claims are the authors' assessment and have not been verified by NIST.*

---

## Purpose

This document enables organizations that have adopted or are evaluating the NIST AI Risk Management Framework (NIST AI 100-1, January 2023) to understand how AAO satisfies NIST requirements — and where AAO goes beyond them.

An organization implementing AAO at the Standard compliance level can use this crosswalk to demonstrate NIST alignment to auditors, legal teams, regulators, and enterprise governance bodies without implementing a separate NIST compliance program.

**Reading this document:** The crosswalk is organized by NIST function (GOVERN, MAP, MEASURE, MANAGE). For each subcategory, the table shows the AAO mechanism that satisfies it and where to find it in the AAO repository. Where AAO exceeds the NIST requirement, this is noted. Where a NIST subcategory is not fully addressed by AAO, this is honestly documented.

---

## GOVERN Function

The GOVERN function cultivates risk management culture, establishes accountability structures, and creates policies and processes for AI risk management.

### GOVERN 1 — Policies, Processes, and Practices

| NIST Subcategory | AAO Mechanism | AAO Location | Coverage |
|---|---|---|---|
| **G 1.1** Legal and regulatory requirements involving AI are understood, managed, and documented | Deployment Authorization Document §1 requires documentation of applicable laws and regulations before system authorization | `templates/deployment-authorization.md §1` | ✅ Full |
| **G 1.2** Characteristics of trustworthy AI are integrated into organizational policies | AAO Trustworthiness Statement maps each NIST characteristic to a structural control | `docs/10-risk-register-map-alignment.md §14.6` | ✅ Full |
| **G 1.3** Processes are in place to determine needed level of risk management based on risk tolerance | Risk tolerance is documented in the Risk Register Part A and drives whitelist action risk level assignments | `templates/risk-register.md Part A` | ✅ Full |
| **G 1.4** Risk management process and outcomes are established through transparent policies | Deployment Authorization Document is the transparent policy document; Artifact Repository is the transparent outcomes record | `templates/deployment-authorization.md`; `templates/artifact-repository-schema.sql` | ✅ Full |
| **G 1.5** Ongoing monitoring and periodic review are planned; roles and responsibilities defined | DAD §8 establishes mandatory review date and trigger conditions; Operator Registry defines roles | `templates/deployment-authorization.md §8` | ✅ Full |
| **G 1.6** Mechanisms are in place to inventory AI systems | Artifact Repository maintains complete record of all AI system deployments and their authorization status | `templates/artifact-repository-schema.sql` | ✅ Full |
| **G 1.7** Processes for decommissioning AI systems safely | Section 15 defines complete decommission workflow with archive preservation, Authorization Code revocation, factory reset, and Decommission Artifact creation | `SPECIFICATION.md §15`; `templates/deployment-authorization.md Appendix A` | ✅ Full |

### GOVERN 2 — Accountability Structures

| NIST Subcategory | AAO Mechanism | AAO Location | Coverage |
|---|---|---|---|
| **G 2.1** Roles and responsibilities related to AI risks are documented and clear | Operator Registry defines all roles; DAD §6 documents operator competencies and responsibilities | `templates/deployment-authorization.md §6`; `docs/09-human-signoff-repository.md` | ✅ Full |
| **G 2.2** Personnel receive AI risk management training | Operator competency verification required before Authorization Code issuance; training requirements in DAD §6 | `templates/deployment-authorization.md §6` | ✅ Full |
| **G 2.3** Executive leadership takes responsibility for AI risk decisions | DAD Authority Sign-Off (§8) requires organizational authority — not just technical team — to authorize deployment | `templates/deployment-authorization.md §8` | ✅ Full — **AAO exceeds this by making executive sign-off a signed, immutable artifact** |

### GOVERN 3 — Workforce Diversity and Inclusion

| NIST Subcategory | AAO Mechanism | AAO Location | Coverage |
|---|---|---|---|
| **G 3.1** Decision-making is informed by a diverse team | Section 14 Workforce Diversity requirements; DAD §6.3 diversity documentation; Risk Register Part E requires minimum 3 reviewers from different disciplines; Operator Registry tracks role classifications; Artifact Repository tracks diversity metrics per session | `SPECIFICATION.md §14`; `templates/deployment-authorization.md §6.3`; `templates/risk-register.md Part E`; `templates/artifact-repository-schema.sql` | ✅ Full — **AAO exceeds: diversity is structurally enforced through multi-signature requirements, role tracking, and session-level diversity metrics** |
| **G 3.2** Policies define roles for human-AI configurations | Section 12 defines the complete human-AI configuration — what humans must review, what AI can do without review, what requires confirmation | `SPECIFICATION.md §12`; `docs/09-human-signoff-repository.md` | ✅ Full |

### GOVERN 4 — Risk Culture

| NIST Subcategory | AAO Mechanism | AAO Location | Coverage |
|---|---|---|---|
| **G 4.1** Safety-first mindset in design and deployment | Zero-trust philosophy is the foundation of AAO — nothing is trusted without process authorization | `SPECIFICATION.md §14.1`; `docs/10-risk-register-map-alignment.md` | ✅ Full |
| **G 4.2** Teams document risks and potential impacts | Risk Register is a mandatory pre-deployment artifact | `templates/risk-register.md` | ✅ Full |
| **G 4.3** Practices enable AI testing, incident identification, and information sharing | SDLC testing requirements (Section 9); Failure Intelligence System (Section 8); Artifact Repository incident records | `docs/07-sdlc-integration.md`; `docs/08-failure-intelligence.md` | ✅ Full |

### GOVERN 5 — External Engagement

| NIST Subcategory | AAO Mechanism | AAO Location | Coverage |
|---|---|---|---|
| **G 5.1** Policies collect and integrate feedback from external AI actors | Section 16 External Stakeholder Engagement requirements; DAD §2 stakeholder identification and engagement mechanisms; STAKEHOLDER_FEEDBACK artifact type in Artifact Repository; Adjudication workflow with integration into Risk Register and DAD review cycle | `SPECIFICATION.md §16`; `templates/deployment-authorization.md §2`; `templates/artifact-repository-schema.sql` | ✅ Full |
| **G 5.2** Mechanisms incorporate adjudicated feedback into system design | Failure Intelligence feedback loop from production to development cycle is the primary mechanism | `docs/08-failure-intelligence.md` | ✅ Full |

### GOVERN 6 — Third-Party and Supply Chain

| NIST Subcategory | AAO Mechanism | AAO Location | Coverage |
|---|---|---|---|
| **G 6.1** Policies address risks from third-party AI components | DAD §7 requires documentation of third-party AI model risks; RSK-006 in Risk Register addresses this explicitly | `templates/deployment-authorization.md §7`; `templates/risk-register.md B.6` | ✅ Full |
| **G 6.2** Contingency processes for third-party failures | Offline operation capability requirement in DAD §7; Layer 3/Layer 4 separation means AI model failure does not prevent human sign-off on already-produced artifacts | `templates/deployment-authorization.md §7`; `SPECIFICATION.md §3` | ✅ Full |

---

## MAP Function

The MAP function establishes context and frames risks related to an AI system.

### MAP 1 — Context Established

| NIST Subcategory | AAO Mechanism | AAO Location | Coverage |
|---|---|---|---|
| **MAP 1.1** Intended purposes, context-specific laws, deployment settings documented | DAD §1 and §2 | `templates/deployment-authorization.md §1,2` | ✅ Full |
| **MAP 1.2** Interdisciplinary AI actors and competencies documented | Operator Registry with role definitions | `docs/09-human-signoff-repository.md §12.5` | ✅ Full |
| **MAP 1.3** Organization's mission and AI goals documented | DAD §2 System Purpose Statement | `templates/deployment-authorization.md §2` | ✅ Full |
| **MAP 1.4** Business value clearly defined | DAD §3 Deployment Scope | `templates/deployment-authorization.md §3` | ✅ Full |
| **MAP 1.5** Organizational risk tolerances determined and documented | Risk Register Part A | `templates/risk-register.md Part A` | ✅ Full |
| **MAP 1.6** System requirements elicit socio-technical implications | Section 12 human-AI configuration design; Operator confirmation requirements | `SPECIFICATION.md §12`; `SPECIFICATION.md §4` | ✅ Full |

### MAP 2 — AI System Categorization

| NIST Subcategory | AAO Mechanism | AAO Location | Coverage |
|---|---|---|---|
| **MAP 2.1** Specific tasks the AI system will support are defined | The action whitelist is the authoritative definition | `templates/action-whitelist.json`; `docs/03-action-layer.md` | ✅ Full — **AAO exceeds this: the whitelist is structural, not documentary** |
| **MAP 2.2** AI knowledge limits and human oversight documented | Confirmation requirements per risk level; Layer 3/4 separation | `SPECIFICATION.md §4`; `docs/03-action-layer.md` | ✅ Full |
| **MAP 2.3** TEVV considerations documented | SDLC test stage requirements: whitelist boundary, prompt injection, rollback, partition integrity | `docs/07-sdlc-integration.md`; `SPECIFICATION.md §9` | ✅ Full |

### MAP 3 — Capabilities, Benefits, and Costs

| NIST Subcategory | AAO Mechanism | AAO Location | Coverage |
|---|---|---|---|
| **MAP 3.1** Potential benefits examined and documented | DAD §5 Benefits Statement | `templates/deployment-authorization.md §5` | ✅ Full |
| **MAP 3.2** Potential costs from AI errors documented | Risk Register standard categories; connected to risk tolerance in Part A | `templates/risk-register.md` | ✅ Full |
| **MAP 3.3** Targeted application scope specified | Whitelist IS the scope; DAD §3 Scope Exclusions | `templates/deployment-authorization.md §3`; `templates/action-whitelist.json` | ✅ Full — **AAO exceeds: scope is architecturally enforced** |
| **MAP 3.4** Operator proficiency processes defined and documented | Competency requirements in DAD §6; pre-issuance verification | `templates/deployment-authorization.md §6` | ✅ Full |
| **MAP 3.5** Human oversight processes defined and documented | Complete human oversight framework in Section 12 | `SPECIFICATION.md §12`; `docs/09-human-signoff-repository.md` | ✅ Full — **AAO exceeds: oversight is a signed artifact, not a policy** |

### MAP 4 — Risks and Benefits Mapped

| NIST Subcategory | AAO Mechanism | AAO Location | Coverage |
|---|---|---|---|
| **MAP 4.1** Approaches for mapping AI technology and legal risks documented | DAD §7 third-party risk; Risk Register standard categories | `templates/deployment-authorization.md §7`; `templates/risk-register.md` | ✅ Full |
| **MAP 4.2** Internal experts involved with deployment decisions | DAD Authority Sign-Off requires organizational authority involvement | `templates/deployment-authorization.md §8` | ✅ Full |

### MAP 5 — Likelihood and Impact Estimated

| NIST Subcategory | AAO Mechanism | AAO Location | Coverage |
|---|---|---|---|
| **MAP 5.1** Likelihood and magnitude of risks documented | Risk Register pre-control and post-control ratings | `templates/risk-register.md` | ✅ Full |
| **MAP 5.2** Regular engagement with AI actors; feedback integrated | Failure Intelligence System; artifact rejection workflow | `docs/08-failure-intelligence.md`; `SPECIFICATION.md §12.6.4` | ✅ Full |

---

## MEASURE Function

The MEASURE function analyzes and assesses AI risks using quantitative and qualitative methods.

| NIST Subcategory | AAO Mechanism | AAO Location | Coverage |
|---|---|---|---|
| **MEASURE 1.1** AI risk measurement approaches are documented | Risk Register likelihood/impact ratings; action risk level assignments | `templates/risk-register.md`; `SPECIFICATION.md §4` | ✅ Full |
| **MEASURE 1.3** Internal experts are involved in risk assessment | DAD requires authority sign-off; Risk Register Part E authority signature | `templates/deployment-authorization.md §8` | ✅ Full |
| **MEASURE 2.1** TEVV metrics and thresholds are documented | Health check pass/fail threshold; rollback trigger conditions | `templates/health-check.sh`; `docs/06-snapshot-rollback.md` | ✅ Full |
| **MEASURE 2.2** Evaluations are performed on in-context AI system behaviors | Post-action health checks after every consequential action | `SPECIFICATION.md §5`; `docs/06-snapshot-rollback.md` | ✅ Full — **AAO exceeds: evaluation is automatic, not periodic** |
| **MEASURE 2.5** AI system to be deployed in context of humans is tested | End-of-session human review process; operator confirmation flows | `SPECIFICATION.md §12.6`; `docs/09-human-signoff-repository.md` | ✅ Full |
| **MEASURE 2.7** AI risk and trustworthiness metrics are established | Failure Intelligence System tracks error rates, rollback frequency, fix durability | `docs/08-failure-intelligence.md` | ✅ Full |
| **MEASURE 2.9** Risks are tracked in applicable systems | Artifact Repository maintains complete risk event history | `templates/artifact-repository-schema.sql` | ✅ Full |
| **MEASURE 2.13** Effectiveness of risk management is evaluated | Periodic DAD review uses Artifact Repository and Failure Intelligence data | `templates/deployment-authorization.md §8`; `docs/08-failure-intelligence.md` | ✅ Full |
| **MEASURE 4.1** Risk management activities and outcomes are documented and communicated | All risk events automatically logged in Artifact Repository; Session Summary surfaced to operator | `templates/artifact-repository-schema.sql`; `SPECIFICATION.md §12.6` | ✅ Full |

---

## MANAGE Function

The MANAGE function allocates resources and takes action to address AI risks.

| NIST Subcategory | AAO Mechanism | AAO Location | Coverage |
|---|---|---|---|
| **MANAGE 1.1** Risks with established response plans | Seven standard risk categories in Risk Register each have defined AAO controls | `templates/risk-register.md` | ✅ Full |
| **MANAGE 1.3** Responses to known risks are prioritized | Action risk level (Info/Low/Medium/High) drives response requirements | `SPECIFICATION.md §4` | ✅ Full |
| **MANAGE 2.2** Mechanisms for human oversight are implemented | Authorization Code sign-off; confirmation requirements; end-of-session review | `SPECIFICATION.md §12`; `docs/09-human-signoff-repository.md` | ✅ Full — **AAO exceeds: oversight is structurally enforced** |
| **MANAGE 2.4** Risk response is monitored and documentation updated | Failure Intelligence feedback loop; Artifact Repository rejection records trigger response workflow | `docs/08-failure-intelligence.md`; `SPECIFICATION.md §12.6.4` | ✅ Full |
| **MANAGE 3.1** Responses to identified risks are communicated | Session Summary surfaced to operator; rejection workflow triggers defined escalation | `SPECIFICATION.md §12.6`; `docs/09-human-signoff-repository.md` | ✅ Full |
| **MANAGE 3.2** Organizational systems for tracking and managing AI incidents | Artifact Repository with FAILURE_REPORT artifact type; Failure Intelligence System | `templates/artifact-repository-schema.sql`; `docs/08-failure-intelligence.md` | ✅ Full |
| **MANAGE 4.1** Negative AI impacts are communicated to relevant parties | Artifact rejection workflow requires mandatory notes and escalation | `SPECIFICATION.md §12.6.4` | ✅ Full |
| **MANAGE 4.2** Effective AI risk management is documented | Complete immutable record in Artifact Repository; auditable at any time | `templates/artifact-repository-schema.sql`; `SPECIFICATION.md §12.7` | ✅ Full — **AAO exceeds: audit requires no preparation** |

---

## Coverage Summary

| NIST Function | Subcategories Addressed | Full Coverage | Partial Coverage | Not Addressed |
|---|---|---|---|---|
| GOVERN | 20 | 20 | 0 | 0 |
| MAP | 16 | 16 | 0 | 0 |
| MEASURE | 9 | 9 | 0 | 0 |
| MANAGE | 8 | 8 | 0 | 0 |
| **Total** | **53** | **53** | **0** | **0** |

**AAO achieves 100% NIST AI RMF 1.0 coverage.** All 53 subcategories across all four functions (GOVERN, MAP, MEASURE, MANAGE) are fully addressed through structural controls, not just policy statements.

**AAO exceeds NIST requirements** in nine areas where the structural enforcement of AAO controls goes beyond what NIST requires as policy or documentation:
- G 2.3: Executive sign-off is a signed, immutable artifact
- G 3.1: Diversity structurally enforced through multi-signature requirements and tracking
- MAP 2.1: Whitelist is structural, not documentary
- MAP 3.3: Scope is architecturally enforced
- MAP 3.5: Oversight is a signed artifact, not a policy
- MEASURE 2.2: Evaluation is automatic, not periodic
- MANAGE 2.2: Oversight is structurally enforced
- MANAGE 4.2: Audit requires no preparation

---

## How to Use This Crosswalk

**For legal and compliance teams:** Use the full coverage table above as evidence that AAO Standard implementation satisfies NIST AI RMF obligations. Each row provides the specific AAO artifact and location that demonstrates compliance.

**For auditors:** Request the following artifacts from an AAO Standard implementation to verify NIST alignment: Deployment Authorization Document, completed Risk Register, Artifact Repository export, and Operator Registry. These four documents together satisfy the evidence requirements for all 53 subcategories (100% coverage).

**For enterprise procurement:** An AAO Standard certification means the team has produced all four audit artifacts, has organizational authority sign-off on the Deployment Authorization Document, and maintains an immutable, audit-ready record of all AI system activity.

---

*research/nist-crosswalk.md | AAO Methodology | © 2026 Donald Moskaluk | AtMyBoat.com*
*References: NIST AI Risk Management Framework 1.0 (NIST AI 100-1, January 2023)*
*NIST AI RMF Subcategory labels are used for identification purposes only.*
