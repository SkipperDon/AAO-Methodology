# AAO — EU AI Act Alignment Note
## How AAO Addresses EU AI Act Obligations for High-Risk AI Systems

> **⚠️ DISCLAIMER — Framework Under Development**
>
> *This alignment note is part of a conceptual framework currently under active development and has not been formally tested or validated. This document does not constitute legal advice. Organizations subject to the EU AI Act should seek qualified legal counsel for compliance determinations. The EU AI Act alignment claims are the authors' assessment only.*

---

## Implementation Timeline

The EU AI Act (Regulation (EU) 2024/1689) entered into force on 1 August 2024. Key dates for organizations building AI systems:

- **2 February 2025** — Prohibited AI practices and AI literacy obligations in effect
- **2 August 2025** — GPAI model rules in effect
- **2 August 2026** — Most high-risk AI system obligations in effect *(principal compliance deadline)*
- **2 August 2027** — High-risk AI systems embedded in regulated products

**For teams building AI systems that affect safety** — marine electronics, industrial control, infrastructure management, medical devices — the 2026 deadline is the operative date. AAO implementation can position a team for compliance before that deadline.

---

## Does AAO Apply to High-Risk AI Systems?

The EU AI Act defines high-risk AI systems primarily by use case (Annex III) and by role in safety-critical products (Annex I / Article 6). The primary high-risk triggers for AAO-type systems are:

**Annex I / Article 6(1)** — AI systems that are safety components of products covered by EU harmonisation legislation and are subject to third-party conformity assessment. This includes marine safety equipment, industrial machinery, and certain embedded control systems.

**Annex III use cases** — Including critical infrastructure management, certain employment uses, and systems that make or support decisions affecting individuals' access to essential services.

**The d3kOS reference implementation** — An AI system that diagnoses and applies fixes to marine electronics while a vessel is underway — directly operates as a safety component in a safety-critical environment. This almost certainly qualifies as high-risk under Annex I. Any team implementing AAO in a similar context should obtain a formal legal determination.

The good news: **AAO is designed for exactly this environment.** The controls AAO requires are not overhead added to satisfy regulators — they are what any competent engineering team would build for a system taking autonomous actions in a safety-critical context. The EU AI Act alignment is a consequence of getting the engineering right.

---

## High-Risk AI System Obligations and AAO Coverage

### Article 9 — Risk Management System

*The Act requires: A documented, ongoing risk management process covering the entire AI lifecycle, including identification and evaluation of known and foreseeable risks.*

**AAO Coverage: ✅ Full**

The AAO Risk Register (Section 14 of the Specification, `templates/risk-register.md`) satisfies Article 9's core requirement. It documents seven standard risk categories every AAO deployment must assess, with pre-control and post-control ratings, named individual acceptance of residual risk, and a mandatory review schedule.

The Deployment Authorization Document's review trigger conditions ensure the risk management system is active through deployment, not just at design time.

**AAO exceeds Article 9** in one respect: risk controls in AAO are structural, not procedural. The whitelist makes certain risk categories architecturally impossible — the risk management system doesn't just document the risk, it eliminates it at the architecture level.

---

### Article 10 — Data and Data Governance

*The Act requires: Training, validation, and testing data that is relevant, representative, sufficiently free of errors, and complete with respect to the system's intended purpose.*

**AAO Coverage: ⚡ Partial**

AAO addresses data governance at the runtime layer — the AI can only access data within its defined scope (Layer 2), and the whitelist prevents AI from accessing data it is not authorized to use. The immutable base prevents AI from modifying its own data access permissions.

AAO does not address training data governance, which is the primary concern of Article 10. This is intentional — AAO is an architectural framework for AI systems taking real-world actions, not a model training framework. Organizations using third-party AI models (the common case) should address Article 10 through model provider documentation and contractual requirements in the Deployment Authorization Document (§7).

---

### Article 11 — Technical Documentation

*The Act requires: Technical documentation established before the system is placed on the market, kept up to date, demonstrating compliance.*

**AAO Coverage: ✅ Full**

The AAO repository is the technical documentation. Specifically:

- `SPECIFICATION.md` — complete system architecture documentation
- `templates/deployment-authorization.md` — deployment-specific technical record
- `templates/action-whitelist.json` — complete capability documentation
- `templates/risk-register.md` — risk assessment record
- `docs/` folder — component-level documentation for each architectural layer

The Artifact Repository maintains the ongoing record required for "kept up to date" — every system change produces artifacts that update the technical record automatically.

---

### Article 12 — Record-Keeping (Logging)

*The Act requires: Automatic logging of events throughout the AI system's lifetime to the extent possible. Deployers must keep logs for at least six months.*

**AAO Coverage: ✅ Full — and exceeded**

The AAO audit ledger (append-only, `templates/audit-log-schema.sql`) satisfies Article 12. Every action attempted, executed, and its outcome is logged automatically. The Artifact Repository adds the human sign-off layer on top of this — not just logging that an action occurred, but recording that a named individual reviewed and accepted it.

**AAO exceeds Article 12** in three ways: the record is immutable (not just retained), it includes human sign-off not just system events, and it is audit-ready at any time without the six-month retention period being a practical limit.

---

### Article 13 — Transparency and Provision of Information to Deployers

*The Act requires: High-risk AI systems shall be designed and developed in such a way as to ensure that their operation is sufficiently transparent to enable deployers to interpret the system's output and use it appropriately.*

**AAO Coverage: ✅ Full**

AAO's four-layer architecture is designed around interpretability. The AI operates in Layer 4 where its reasoning is visible. The separation between diagnosis (Layer 4) and action (Layer 3) means the human operator can always see what the AI concluded and proposed before action is taken. The Session Summary artifact presents the AI's work in human-readable form for review.

The confirmation requirement for Medium and High risk actions is a direct implementation of Article 13's intent — the operator sees what the AI wants to do and explicitly approves it.

---

### Article 14 — Human Oversight

*The Act requires: High-risk AI systems shall be designed to allow effective oversight by natural persons. Persons assigned to oversight must be able to understand the system's capabilities and limitations, detect anomalies, interpret output, and decide not to use the system or override its output.*

**AAO Coverage: ✅ Full — and exceeded**

This is the Article where AAO is strongest. The EU AI Act describes human oversight as a design requirement. AAO makes it an architectural requirement.

Specifically:

| EU AI Act Article 14 Requirement | AAO Implementation |
|---|---|
| Humans can effectively oversee the system | End-of-session review is a mandatory workflow, not optional |
| Oversight persons understand capabilities and limitations | Operator competency verification required before Authorization Code issuance (DAD §6) |
| Persons can detect and address anomalies | Session Summary surfaces anomalies automatically; Failure Intelligence System flags patterns |
| Persons can remain aware of over-reliance risk | The zero-trust philosophy is documented and communicated; AAO explicitly defines what the AI cannot do |
| Persons can correctly interpret system output | Layer 4/3 separation means AI reasoning is always visible before action |
| Persons can decide not to use output or override it | Rejection workflow in Section 12 provides this explicitly; any artifact can be rejected with mandatory notes |
| System can be stopped or shut down safely | High actions require explicit confirmation; any session can be terminated without orphaned system state due to snapshot/rollback |

**AAO exceeds Article 14** because human oversight in AAO is not just enabled — it is required. The system cannot be operated without human sign-off on session outputs. A deployer cannot bypass the oversight process because the authorization code is a hard requirement, not a procedural recommendation.

---

### Article 15 — Accuracy, Robustness, and Cybersecurity

*The Act requires: High-risk AI systems shall be designed to achieve appropriate levels of accuracy, robustness, and cybersecurity, and to be resilient to errors, faults, or adversarial attacks.*

**AAO Coverage: ✅ Full**

| EU AI Act Article 15 Requirement | AAO Implementation |
|---|---|
| Accuracy | Post-action health checks verify that expected outcomes were achieved; rollback corrects failures automatically |
| Robustness to errors | Automatic rollback on health check failure; immutable base means AI errors cannot permanently damage the system |
| Robustness to faults | Factory reset always returns to known good state regardless of runtime fault |
| Cybersecurity — adversarial attacks | Section 7 Prompt Injection Defences; action whitelist means injected prompts cannot request non-existent actions |

---

### Article 26 — Obligations of Deployers

*The Act requires: Deployers shall use high-risk AI systems according to instructions, assign human oversight to competent individuals, monitor operation, keep logs for six months, and report serious incidents.*

**AAO Coverage: ✅ Full**

| Article 26 Requirement | AAO Mechanism |
|---|---|
| Use system according to instructions | Whitelist enforces authorized use structurally; deviations are architecturally impossible, not just prohibited |
| Assign human oversight to competent individuals | Operator Registry with competency verification; Authorization Code issuance records |
| Monitor operation | Real-time audit ledger; Failure Intelligence System; Session Summary |
| Keep logs for six months | Artifact Repository is append-only and permanent; no deletion possible |
| Report serious incidents | FAILURE_REPORT artifact type triggers defined escalation workflow |

---

## EU AI Act Compliance Summary for AAO Standard Implementations

| Article | Obligation | AAO Coverage |
|---|---|---|
| Art. 9 | Risk management system | ✅ Full |
| Art. 10 | Data governance | ⚡ Partial (runtime scope only) |
| Art. 11 | Technical documentation | ✅ Full |
| Art. 12 | Record-keeping / logging | ✅ Full (exceeded) |
| Art. 13 | Transparency to deployers | ✅ Full |
| Art. 14 | Human oversight | ✅ Full (exceeded) |
| Art. 15 | Accuracy and robustness | ✅ Full |
| Art. 26 | Deployer obligations | ✅ Full |

**Partial coverage note on Article 10:** Organizations using third-party foundation models (LLMs, specialist AI) should address training data governance through model provider agreements documented in the Deployment Authorization Document §7. This is not an AAO gap — it is a boundary condition. AAO governs what happens after the AI model outputs — the model provider governs what went into training.

---

## What an EU AI Act Auditor Would Ask For

If a competent authority or auditor requests documentation for a high-risk AI system implemented with AAO, the following artifacts satisfy the request:

1. **Deployment Authorization Document** — establishes the authorization chain, scope, and executive accountability
2. **Risk Register** — demonstrates the required risk management process with named acceptance of residual risks
3. **Artifact Repository export** — provides the automatic log records required under Article 12, with human sign-off records
4. **SPECIFICATION.md and docs/ folder** — constitutes the technical documentation required under Article 11
5. **Operator Registry** — demonstrates human oversight assignment to named, competent individuals (Article 26)

These five items together represent a credible response to an EU AI Act audit for a high-risk AI system. No additional documentation preparation is required — the Artifact Repository means the record is always current and always available.

---

## A Note on AAO as a Voluntary Code of Conduct

Article 69 of the EU AI Act encourages voluntary codes of conduct for requirements under Title III Chapter 2 for AI systems that do not meet the high-risk threshold. AAO's architecture — risk management, data governance at the runtime level, human oversight — maps directly onto the voluntary code of conduct framework.

Organizations deploying AI systems that fall below the high-risk threshold can use AAO as their voluntary code of conduct, demonstrating to customers, partners, and regulators that they operate their AI systems to a rigorous standard even where not legally required. This is a meaningful differentiator in markets where AI trust is becoming a commercial consideration.

---

*research/eu-ai-act-alignment.md | AAO Methodology | © 2026 Donald Moskaluk | AtMyBoat.com*
*References: EU AI Act (Regulation (EU) 2024/1689, Official Journal version of 13 June 2024)*
*This document does not constitute legal advice. Consult qualified EU legal counsel for formal compliance determinations.*
