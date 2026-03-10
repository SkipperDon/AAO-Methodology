# AAO — Executive Summary
## Autonomous Action Operating Methodology

> **⚠️ DISCLAIMER — Framework Under Development**
>
> *This framework is under active development and has not been formally tested or validated. Not a finalized standard.*

---

## The Problem

Your engineering teams are deploying AI systems that take real-world actions — restarting services, modifying configuration, executing fixes, controlling hardware. Traditional development frameworks — Agile, DevOps, CI/CD — were designed before AI could act autonomously. They have no guidance for this scenario.

The result: 98% of organizations are deploying agentic AI while 79% lack formal security policies for these autonomous tools. When something goes wrong, nobody can answer: *What did the AI do? Who authorized it? Can we prove it?*

---

## What AAO Is

AAO is a framework that answers one question no existing framework addresses:

**How do you give an AI system real-world action capability without losing control of what it does?**

It is not a policy document. It is a structural architecture — four layers, an immutable base, an action whitelist, an audit trail, snapshot-based recovery, and a human sign-off system that produces signed, immutable records of every consequential AI output.

**The governing principle:** Trust is not evaluated at runtime. It is established before the system operates — through authorization, process, and accountability — and earned over time through a recorded history of compliant behavior.

---

## The Five Guarantees

Every AAO-compliant system provides five structural guarantees:

**1. The AI cannot exceed its defined action space.** Actions are whitelisted by name on an immutable base partition. The AI calls named action functions — it cannot execute shell commands. Even a successfully injected prompt cannot request an action that does not exist on the whitelist.

**2. Every action is audited before and after execution.** An append-only ledger records what the AI observed, decided, executed, and what happened. The question "what has the AI changed?" always has a complete, immediate answer.

**3. A snapshot is taken before every consequential action.** If an action causes problems, the snapshot is restored automatically — without human intervention.

**4. Health checks trigger automatic rollback.** If the system is worse after an AI action than before it, rollback happens within a defined timeout. The AI cannot permanently damage a system.

**5. A named human signs off every session.** Every AI work session produces artifacts reviewed and signed by an authorized individual using a unique Authorization Code. The record is immutable and audit-ready at any time without preparation.

---

## What This Means for Your Organization

**For legal and compliance:** AAO Standard implementations achieve 100% NIST AI RMF 1.0 coverage — all 53 subcategories across all four functions (GOVERN, MAP, MEASURE, MANAGE) are fully addressed. The framework also addresses Articles 9, 11, 12, 13, 14, 15, and 26 of the EU AI Act for high-risk AI systems. A single set of four documents — Deployment Authorization Document, Risk Register, Artifact Repository export, and Operator Registry — constitutes a credible audit response. See `research/nist-crosswalk.md` and `research/eu-ai-act-alignment.md`.

**For engineering teams:** AAO extends your existing SDLC. It adds specific required activities at each stage — action boundary assessment at planning, partition classification at design, whitelist boundary and prompt injection testing at test, signed package verification at deploy. It does not replace your current process; it extends it for the AI action scenario your current process doesn't address.

**For security:** The architecture makes certain attack categories impossible rather than monitored. Prompt injection cannot manufacture new capabilities because the whitelist is on an immutable base. A compromised AI model cannot damage the system permanently because factory reset always returns to a known good base. These are structural guarantees, not policy statements.

**For executive accountability:** The Deployment Authorization Document requires an organizational authority — not just the technical team — to sign off that they understand what the AI system does, what it is authorized to do, and that they accept organizational responsibility. This sign-off is recorded as an immutable artifact. When an auditor asks who authorized this system, you have a signed, timestamped answer.

---

## What AAO Is Not

AAO is not a replacement for human oversight — it defines where humans must remain in the loop, not how to remove them. It is not an AI model or API — it is an architectural framework applied to any AI system taking real-world actions. It is not a security framework — it addresses AI action safety specifically. It is not specific to any language or platform.

---

## Status and Licensing

**Current version:** 1.0
**License:** Apache 2.0
**Reference implementation:** d3kOS by AtMyBoat.com — an AI assistant for marine vessels that diagnoses and fixes onboard electronics autonomously, including while offshore with no connectivity.
**Status:** Framework under development — not yet formally tested or validated. Feedback and contributions welcome.

**Contact:** Donald Moskaluk — skipperdon@atmyboat.com — github.com/SkipperDon

---

## Starting Points by Role

**CISO / Legal / Compliance** → `research/nist-crosswalk.md` then `research/eu-ai-act-alignment.md`

**Engineering Lead / Architect** → `docs/01-overview.md` then `SPECIFICATION.md`

**Developer** → `templates/standing-instruction.md` then `docs/03-action-layer.md`

**Project Manager / SDLC** → `docs/07-sdlc-integration.md`

**Risk / Governance** → `templates/deployment-authorization.md` then `templates/risk-register.md`

**Visual learner** → `docs/aao-flow-diagrams.html` (open in any browser)

---

*AAO — Because AI that acts in the real world needs more than a good prompt.* ⚓

*© 2026 Donald Moskaluk | AtMyBoat.com | Apache License 2.0*
