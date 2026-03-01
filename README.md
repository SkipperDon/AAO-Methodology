# AAO — Autonomous Action Operating Methodology


> **⚠️ DISCLAIMER — Framework Under Development**
>
> *The methodology presented in this document is a conceptual framework currently under active development and has not been formally tested, validated, or peer-reviewed. It should not be interpreted as a finalized standard, best practice, or certified process. Organizations adopting or referencing this framework do so at their own discretion and are encouraged to apply appropriate professional judgment. Feedback, testing, and iterative refinement are actively welcomed as part of the ongoing development of this framework.*

---


**A structured framework for building AI systems that take real-world actions safely.**

---

> *"The question is not whether to give AI systems real-world action capability.  
> The question is how to architect it so the power is real and the risks are managed."*
>
> — Donald Moskaluk, AtMyBoat.com

---

## What Is AAO?

AAO is an SDLC extension and architectural framework for software teams building AI systems that need to take autonomous actions in the real world — restarting services, modifying configuration, executing fixes, controlling hardware, or interacting with physical systems.

Traditional software development frameworks — Agile, DevOps, CI/CD — were designed before AI systems could act autonomously. They have no guidance for this scenario. AAO fills that gap.

It answers one question that no existing framework addresses:

**How do you give an AI system real-world action capability without losing control of what it does?**

---

## The Problem AAO Solves

An AI assistant that can read logs and diagnose problems is valuable. An AI assistant that can also apply fixes autonomously is transformative. But unrestricted AI action creates serious risk:

- A misdiagnosis leads to a wrong fix that disables a critical system
- The AI modifies something without a record — nobody knows what the system state is
- A crafted prompt manipulates the AI into making changes the user did not intend  
- The AI fixes one problem but creates another — with no snapshot, the previous state is gone

AAO solves this through **Controlled Autonomy** — a precisely defined action space, an immutable base that can never be corrupted, a complete audit trail of everything the AI does, and a snapshot system that always guarantees recovery.

---

## Core Principle

> **The AI can see everything but can only touch what it is explicitly permitted to touch.  
> Every action is logged. Every risky action requires user confirmation.  
> The base system is always recoverable regardless of what the AI does.**

---

## The Four-Layer Architecture

```
┌─────────────────────────────────────────────────────────┐
│  LAYER 4 — AI Conversation Layer                        │
│  Claude API / LLM  |  Diagnoses, proposes, explains     │
│  Cannot execute anything directly                        │
├─────────────────────────────────────────────────────────┤
│  LAYER 3 — AI Action Layer  ← The Critical Boundary     │
│  Named action functions only  |  Validates all requests │
│  Snapshot before execution  |  Logs everything          │
│  Health check after execution  |  Auto-rollback on fail │
├─────────────────────────────────────────────────────────┤
│  LAYER 2 — Runtime Layer  (Sandboxed AI Access)         │
│  Configuration  |  Services  |  Cache  |  Logs          │
│  AI can operate here within defined boundaries          │
├─────────────────────────────────────────────────────────┤
│  LAYER 1 — Immutable Base  (Read Only — Never Touched)  │
│  Application code  |  Service definitions               │
│  Action whitelist  |  Signing keys                      │
│  Cannot be modified by AI, users, or admins at runtime  │
└─────────────────────────────────────────────────────────┘
```

The AI operates freely in Layer 4 — diagnosing, explaining, proposing. It crosses into Layer 3 only through named, validated, logged action functions. It influences Layer 2 only through Layer 3. It never touches Layer 1.

---

## The Five AAO Guarantees

**1. The AI cannot exceed its defined action space**  
Actions are whitelisted by name on the immutable base. The AI calls action functions — it does not execute shell commands. Even a successfully injected prompt cannot request an action that does not exist on the whitelist.

**2. Every action is audited before and after execution**  
An append-only ledger records what the AI observed, what it decided, what it executed, and what happened. The user can always ask "what has the AI changed?" and receive a complete answer.

**3. A snapshot is taken before every consequential action**  
Before any action with risk level Low or higher, the system state is captured. If the action causes problems, the snapshot is restored automatically.

**4. Health checks trigger automatic rollback**  
After every consequential action, the system verifies that all previously-running components are still running. If the health check fails within the defined timeout, rollback happens without human intervention.

**5. The base is always recoverable**  
The immutable base partition means application code is always in a known state. No matter what the AI does in the runtime layer, a factory reset returns to a clean base. The AI cannot permanently damage the system.

---

## What AAO Is Not

- **Not a replacement for human oversight** — AAO defines where humans must remain in the loop, not how to remove them
- **Not an AI model or API** — AAO is an architectural framework, not a specific AI implementation
- **Not specific to any language or platform** — the principles apply to any AI system taking real-world actions
- **Not a security framework** — AAO addresses AI action safety, not network security or authentication

---

## Who Is AAO For?

**Software architects** designing systems where AI takes real-world actions — not just generates text.

**Engineering teams** building AI-powered automation, robotics control, infrastructure management, or any system where AI decisions have physical consequences.

**Product managers** who need to articulate to stakeholders exactly what an AI system can and cannot do autonomously — and why that boundary is trustworthy.

**SDLC practitioners** extending their existing development process to accommodate AI systems with autonomous capability.

---

## The SDLC Extension

AAO extends each stage of the software development lifecycle:

| Stage | Traditional | With AAO |
|-------|-------------|----------|
| **Plan** | Feature requirements | + Action boundary assessment — what whitelist entries does this feature need? |
| **Design** | Component architecture | + Partition classification — base or runtime? |
| **Develop** | Code + commit | + Release Package Manifest — partition, pre/post install, rollback notes |
| **Test** | Functional, regression | + Whitelist boundary, prompt injection, rollback, partition integrity tests |
| **Deploy** | Push to production | + Staged rollout, automatic health check, auto-rollback, outcome tracking |
| **Maintain** | Reactive support | + Self-healing within sandbox, failure intelligence, proactive scanning |

---

## Repository Structure

```
aao-methodology/
├── README.md                          ← You are here
├── EXECUTIVE-SUMMARY.md               ← One-page overview for leadership and compliance teams
├── LICENSE                            ← Apache License 2.0
├── LICENSE                            ← License (Apache 2.0)
├── CONTRIBUTING.md                    ← How to contribute
├── SPECIFICATION.md                   ← The complete AAO specification
│
├── docs/
│   ├── aao-flow-diagrams.html         ← Interactive flow diagrams (open in browser)
│
│   ├── 01-overview.md                 ← Controlled autonomy explained
│   ├── 02-immutable-base.md           ← Base partition architecture
│   ├── 03-action-layer.md             ← Whitelist, validation, execution
│   ├── 04-audit-trail.md              ← Append-only ledger design
│   ├── 05-prompt-injection.md         ← Defences and mitigations
│   ├── 06-snapshot-rollback.md        ← Golden image and recovery
│   ├── 07-sdlc-integration.md         ← How AAO extends your SDLC
│   ├── 08-failure-intelligence.md     ← Self-improving system design
│   ├── 09-human-signoff-repository.md ← Human sign-off and artifact repository
│   └── 10-risk-register-map-alignment.md ← Risk Register and NIST MAP alignment
│
├── templates/
│   ├── action-whitelist.json          ← Starter whitelist template
│   ├── audit-log-schema.sql           ← Audit ledger database schema
│   ├── artifact-repository-schema.sql ← Human sign-off & artifact repository schema
│   ├── risk-register.md               ← Risk Register template (NIST MAP aligned)
│   └── deployment-authorization.md    ← Deployment Authorization Document template
│   ├── release-manifest.md            ← Release Package Manifest template
│   ├── standing-instruction.md        ← Claude Code standing instruction
│   └── health-check.sh                ← Post-action health check script
│
├── examples/
│   └── d3kOS/                         ← Reference implementation
│       ├── README.md                  ← d3kOS as AAO implementation
│       └── links.md                   ← Links to d3kOS repository
│       └── risk-register-d3kos.md     ← Pre-filled Risk Register (reference implementation)
│
└── research/
    ├── prior-art.md                   ← Related work and distinctions
    ├── gap-analysis.md                ← What AAO has that everything else is missing
    ├── nist-crosswalk.md              ← Full NIST AI RMF 1.0 subcategory mapping
    └── eu-ai-act-alignment.md         ← EU AI Act high-risk obligations alignment
```

---

## Quick Start

**1. Understand the four layers**  
Read [docs/01-overview.md](docs/01-overview.md). The four-layer architecture is the foundation everything else builds on.

**2. Design your action whitelist**  
Use [templates/action-whitelist.json](templates/action-whitelist.json) as a starting point. Every action your AI can take must be named and defined here before you write any AI integration code.

**3. Build your Action Layer first**  
The Action Layer (Layer 3) is the most critical component. Build and test it completely before integrating any AI. See [docs/03-action-layer.md](docs/03-action-layer.md).

**4. Implement the audit trail**  
Use [templates/audit-log-schema.sql](templates/audit-log-schema.sql) to create your ledger. The audit trail must be in place before any AI action runs in production.

**5. Add the snapshot system**  
See [docs/06-snapshot-rollback.md](docs/06-snapshot-rollback.md). Every action with consequences needs a pre-action snapshot and post-action health check.

**6. Integrate your AI**  
Only now integrate your LLM or AI model. With Layers 1-3 in place, the AI can be powerful because its boundaries are enforced structurally — not through prompt engineering alone.

---

## Reference Implementation

The first production implementation of AAO is **d3kOS** — the AI-Powered Marine Electronics Platform built by AtMyBoat.com. d3kOS uses AAO to enable its onboard AI assistant to diagnose and fix marine electronics problems autonomously while the boat is underway.

See [examples/d3kOS/README.md](examples/d3kOS/README.md) for implementation details.

---

## The Origin

AAO emerged from a practical problem: building an AI assistant for marine vessels that could diagnose engine problems and apply fixes autonomously — while the boat was potentially offshore with no connectivity and a non-technical operator at the helm.

The constraints were severe:
- Mistakes could disable navigation or engine monitoring systems at sea
- The operator could not be expected to understand or approve every system action
- The system had to work completely offline for extended periods
- Recovery had to be possible without any technical knowledge

The resulting architecture — four layers, immutable base, action whitelist, audit trail, snapshot rollback — proved robust enough to generalise beyond marine applications. AAO is that generalisation.

---

## Status

**Current version:** 1.0 (Private — pre-publication)  
**Reference implementation:** d3kOS v2.x  
**License:** Apache 2.0  
**Publication:** Ready for public release  

---

## Author

**Donald Moskaluk**  
Creator of d3kOS and the AtMyBoat.com platform  
skipperdon@atmyboat.com  
github.com/SkipperDon

---

## Contributing

AAO is not yet public. When it is, contribution guidelines will be in [CONTRIBUTING.md](CONTRIBUTING.md).

If you have found this repository and want to discuss the methodology before public release, contact skipperdon@atmyboat.com.

---

*AAO — Because AI that acts in the real world needs more than a good prompt.*
