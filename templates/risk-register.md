# AAO Risk Register
## Deployment Authorization Document — Risk Assessment Component

> **⚠️ DISCLAIMER — Framework Under Development**
>
> *This template is part of a conceptual framework currently under active development and has not been formally tested or validated.*

---

**System Name:** _______________________________________________
**Deployment Environment:** _______________________________________________
**Risk Register Version:** _______________________________________________
**Prepared By:** _______________________________________________
**Date Prepared:** _______________________________________________
**Reviewed By (Authority):** _______________________________________________
**Authorization Date:** _______________________________________________

---

## Part A — System Context Summary

*(Complete before assessing individual risks. This establishes the lens through which risks are evaluated.)*

**Intended Use:**

*(What specific problem is this AI system authorized to solve? Be precise.)*

_______________________________________________

**Operational Environment:**

*(Where does this system operate? Physical location, network context, connectivity, presence of non-technical operators, safety-critical context?)*

_______________________________________________

**Organizational Risk Tolerance:**

☐ Low — Residual risk must be minimal; prefer false negatives (AI does less) over false positives (AI does too much)
☐ Medium — Balanced; some residual risk is acceptable where AAO controls are in place
☐ High — Operational benefit justifies higher residual risk; strong rollback capability required

**Justification for Risk Tolerance Level:**

_______________________________________________

**NIST MAP 1.5 Compliance Note:** *This section satisfies MAP 1.5 (Organizational risk tolerances are determined and documented).*

---

## Part B — Risk Register

*Complete one row per identified risk. Every AAO deployment MUST assess the Standard Risk Categories listed below before adding deployment-specific risks.*

*Rating scale: **H** = High, **M** = Medium, **L** = Low*

---

### B.1 Standard Risk Category: AI Misdiagnosis

**Risk ID:** RSK-001
**NIST MAP Reference:** MAP 3.2, MAP 5.1

| Field | Assessment |
|---|---|
| **Risk Description** | The AI system correctly executes a whitelisted action, but the action was based on an incorrect diagnosis or faulty reasoning by the AI model |
| **Affected AAO Layer** | Layer 4 (AI Conversation) → propagates to Layer 3 |
| **Likelihood (Pre-Control)** | |
| **Impact (Pre-Control)** | |
| **AAO Controls Applied** | Automatic rollback on health check failure (Section 6); Human sign-off required on all Session Summary artifacts (Section 12); Medium/High risk actions require explicit operator confirmation (Section 4) |
| **Residual Likelihood** | |
| **Residual Impact** | |
| **Residual Risk Accepted By** | |
| **Notes** | |

---

### B.2 Standard Risk Category: Whitelist Boundary

**Risk ID:** RSK-002
**NIST MAP Reference:** MAP 2.1, MAP 3.3, MAP 4.1

| Field | Assessment |
|---|---|
| **Risk Description** | A whitelisted action is defined too broadly or imprecisely, enabling unintended consequences within its authorized scope |
| **Affected AAO Layer** | Layer 1 (Immutable Base — whitelist definition) |
| **Likelihood (Pre-Control)** | |
| **Impact (Pre-Control)** | |
| **AAO Controls Applied** | Whitelist boundary testing required in SDLC test stage (Section 9); Scope specificity requirements for whitelist entries (Section 4); Whitelist stored in immutable base — cannot be modified at runtime |
| **Residual Likelihood** | |
| **Residual Impact** | |
| **Residual Risk Accepted By** | |
| **Notes** | |

---

### B.3 Standard Risk Category: Prompt Injection

**Risk ID:** RSK-003
**NIST MAP Reference:** MAP 4.1, MAP 5.1

| Field | Assessment |
|---|---|
| **Risk Description** | Crafted input from an external source (log data, sensor output, user message, third-party content) manipulates the AI model into requesting actions not intended by the legitimate operator |
| **Affected AAO Layer** | Layer 4 (AI Conversation) — boundary with Layer 3 |
| **Likelihood (Pre-Control)** | |
| **Impact (Pre-Control)** | |
| **AAO Controls Applied** | Section 7 Prompt Injection Defences; Action validation at Layer 3 — AI requests action by name only, cannot pass arbitrary commands; Elevated risk actions require operator confirmation |
| **Residual Likelihood** | |
| **Residual Impact** | |
| **Residual Risk Accepted By** | |
| **Notes** | *Note: Residual likelihood should never be rated L unless Section 7 defences are fully implemented. The whitelist boundary is the last line of defence, not the first.* |

---

### B.4 Standard Risk Category: Operator Error

**Risk ID:** RSK-004
**NIST MAP Reference:** MAP 1.6, MAP 3.4, MAP 3.5

| Field | Assessment |
|---|---|
| **Risk Description** | An authorized operator signs off on artifacts without adequate review — either through time pressure, insufficient understanding, or routine rubber-stamping |
| **Affected AAO Layer** | Human Sign-Off Process (Section 12) |
| **Likelihood (Pre-Control)** | |
| **Impact (Pre-Control)** | |
| **AAO Controls Applied** | Session Summary design surfaces anomalies and makes review practical; Rejection workflow requires mandatory notes; Complete audit trail enables post-hoc detection; Operator proficiency requirements at authorization |
| **Residual Likelihood** | |
| **Residual Impact** | |
| **Residual Risk Accepted By** | |
| **Notes** | *This risk is primarily controlled through operator selection and training, not technical controls. Document operator competency verification in DAD §6.* |

---

### B.5 Standard Risk Category: Base Integrity

**Risk ID:** RSK-005
**NIST MAP Reference:** MAP 4.1, MAP 4.2

| Field | Assessment |
|---|---|
| **Risk Description** | The immutable base partition is compromised, corrupting the whitelist, action definitions, or cryptographic keys — undermining all downstream AAO controls |
| **Affected AAO Layer** | Layer 1 (Immutable Base) |
| **Likelihood (Pre-Control)** | |
| **Impact (Pre-Control)** | |
| **AAO Controls Applied** | Boot-time integrity verification (Section 3.1.5); Signed update packages required for any base modification (Section 3.1.4); Factory reset restores known good base state (Section 3.1.6) |
| **Residual Likelihood** | |
| **Residual Impact** | |
| **Residual Risk Accepted By** | |
| **Notes** | |

---

### B.6 Standard Risk Category: Third-Party AI Model

**Risk ID:** RSK-006
**NIST MAP Reference:** MAP 4.1, MAP 4.2, GOVERN 6.1, GOVERN 6.2

| Field | Assessment |
|---|---|
| **Risk Description** | The external AI model (LLM or other) changes behavior, becomes unavailable, produces systematically poor outputs, or is subject to provider-side prompt injection |
| **Affected AAO Layer** | Layer 4 (AI Conversation) |
| **Likelihood (Pre-Control)** | |
| **Impact (Pre-Control)** | |
| **AAO Controls Applied** | Layer 3 is independent of AI model specifics — model can be replaced without changing controls; Human sign-off validates AI output before organizational acceptance; Offline operation capability (document in DAD §7); Failure Intelligence System detects systematic degradation (Section 8) |
| **Residual Likelihood** | |
| **Residual Impact** | |
| **Residual Risk Accepted By** | |
| **Notes** | *Specify AI model provider, version, and update policy in DAD §7. If model is cloud-dependent, offline behavior must be explicitly defined.* |

---

### B.7 Standard Risk Category: Authorization Scope Creep

**Risk ID:** RSK-007
**NIST MAP Reference:** MAP 1.5, MAP 3.3, GOVERN 1.5

| Field | Assessment |
|---|---|
| **Risk Description** | Over time, the operator roster expands beyond those with genuine need, or the whitelist accumulates actions beyond the original deployment scope — gradually eroding the zero-trust posture |
| **Affected AAO Layer** | Human Authorization Process (Section 12.5); Layer 1 (Whitelist) |
| **Likelihood (Pre-Control)** | |
| **Impact (Pre-Control)** | |
| **AAO Controls Applied** | Deployment Authorization Document has a mandatory review schedule; Authorization Code rotation every 90 days creates natural review touchpoints; Audit trail makes operator activity visible; Whitelist changes require signed update package |
| **Residual Likelihood** | |
| **Residual Impact** | |
| **Residual Risk Accepted By** | |
| **Notes** | *Document review schedule in DAD §8. Recommended: full DAD review annually or after any significant whitelist expansion.* |

---

### B.8 Standard Risk Category: Homogeneous Decision-Making

**Risk ID:** RSK-008
**NIST MAP Reference:** GOVERN 3.1, MAP 1.2

| Field | Assessment |
|---|---|
| **Risk Description** | Risk assessment and deployment authorization are performed by a team lacking disciplinary diversity, leading to blind spots in risk identification and inadequate consideration of operational, legal, or domain-specific concerns |
| **Affected AAO Layer** | Risk Assessment Process (Part A-E of this register) |
| **Likelihood (Pre-Control)** | |
| **Impact (Pre-Control)** | |
| **AAO Controls Applied** | Section 14 Workforce Diversity requirements; DAD §6.3 diversity documentation; Part E of Risk Register requires minimum 3 reviewers from different disciplines; Operator Registry tracks role classifications |
| **Residual Likelihood** | |
| **Residual Impact** | |
| **Residual Risk Accepted By** | |
| **Notes** | *If diversity requirements cannot be met, this MUST be documented in DAD §6.3 with justification and mitigation plan. Homogeneous teams statistically miss more risks than diverse teams.* |

---

## Part C — Deployment-Specific Risks

*Add rows below for any risks specific to this deployment that are not covered by the Standard Risk Categories above.*

**Risk ID:** RSK-009 *(increment as needed)*
**NIST MAP Reference:** *(select most relevant)*

| Field | Assessment |
|---|---|
| **Risk Description** | |
| **Affected AAO Layer** | |
| **Likelihood (Pre-Control)** | |
| **Impact (Pre-Control)** | |
| **AAO Controls Applied** | |
| **Residual Likelihood** | |
| **Residual Impact** | |
| **Residual Risk Accepted By** | |
| **Notes** | |

---

## Part D — Overall Risk Posture

**Pre-Control Risk Summary:**

| Risk Level | Count of Risks |
|---|---|
| High Likelihood / High Impact | |
| High Likelihood / Medium Impact | |
| Medium Likelihood / High Impact | |
| Medium Likelihood / Medium Impact | |
| Low Likelihood or Low Impact | |

**Post-Control (Residual) Risk Summary:**

| Risk Level | Count of Risks |
|---|---|
| High Likelihood / High Impact | |
| High Likelihood / Medium Impact | |
| Medium Likelihood / High Impact | |
| Medium Likelihood / Medium Impact | |
| Low Likelihood or Low Impact | |

**Residual Risks Requiring Specific Monitoring Commitments:**

*(List any residual High risks and the specific monitoring or compensating controls committed to)*

_______________________________________________

---

## Part E — Authority Sign-Off (Diversity-Verified Multi-Signature)

This Risk Register has been reviewed and approved by the following authorized operators representing diverse disciplinary perspectives:

| Operator Name | Role Classification | Disciplinary Category | Review Date | Authorization Code Hash |
|---|---|---|---|---|
| | ☐ Technical  ☐ Operational  ☐ Risk/Compliance | | | |
| | ☐ Technical  ☐ Operational  ☐ Risk/Compliance | | | |
| | ☐ Technical  ☐ Operational  ☐ Risk/Compliance | | | |
| *(add rows if >3 reviewers)* | | | | |

**Disciplinary Diversity Requirement:**

☐ **MET** — Minimum 3 reviewers from at least 2 different disciplinary categories (Technical/Operational/Risk-Compliance)
☐ **PARTIAL** — Only ___ disciplines represented among reviewers
☐ **NOT MET** — All reviewers from same disciplinary category

**If diversity requirement NOT MET, provide justification:**

_______________________________________________

**Mitigat plan for diversity gaps:**

_______________________________________________

**Final Authorizing Authority (Organizational Sign-Off):**

By signing, the final authorizing individual declares:

1. They have reviewed this Risk Register and the diversity of its review team.
2. They accept the residual risks documented in Part D on behalf of the organization.
3. They authorize the AAO-compliant system described in the Deployment Authorization Document to operate within the scope defined.
4. They understand that this authorization is recorded as an immutable artifact in the AAO Artifact Repository and is auditable at any time.

**Authorizing Individual Name:** _______________________________________________
**Title / Role:** _______________________________________________
**Organization:** _______________________________________________
**Authorization Date:** _______________________________________________
**Authorization Code Signature:** *(Enter Authorization Code in the system — hash recorded in Artifact Repository)*
**Next Review Date:** _______________________________________________

---

*AAO Risk Register Template v1.1*
*Part of the AAO Deployment Authorization Document package*
*© 2026 Donald Moskaluk | AtMyBoat.com*
*NIST AI RMF 1.0 (NIST AI 100-1) MAP function alignment*
*Includes GOVERN 3.1 Workforce Diversity requirements (Section 14)*
