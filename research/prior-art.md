# Prior Art and Related Work

## How AAO Differs From Existing Approaches

### Principle of Least Privilege (Security)
The closest existing concept is the principle of least privilege in security engineering — a process should have only the minimum access rights needed to perform its function.

AAO applies this principle specifically to AI action capability. The distinction is that least privilege is traditionally applied to static, pre-defined processes. AAO addresses the novel case of an AI system that reasons at runtime about what actions to take — making the scope of "minimum necessary" dynamic rather than static.

### Human-in-the-Loop (AI Safety)
Human-in-the-loop (HITL) approaches require human approval before every AI action. AAO differs in that it defines a calibrated confirmation model — some actions require no confirmation (read-only), some require conversational confirmation (low risk), some require explicit confirmation dialogs (medium risk), some require credential entry (high risk).

HITL is maximally safe but operationally impractical for systems that must act quickly or operate without continuous human attention. AAO provides safety proportional to risk rather than uniform maximum safety.

### Sandboxed Execution (Software Engineering)
Container sandboxing (Docker, Kubernetes) and process isolation provide execution boundaries for software components. These approaches constrain what software can access at the OS level.

AAO uses similar principles for the base partition and the Action Layer's restricted user account. The distinction is that AAO is specifically designed for AI systems — it addresses the unique challenge of a system whose behaviour is determined by reasoning rather than deterministic code, and which therefore requires defence against prompt manipulation in addition to OS-level constraints.

### Capability-Based Security (Computer Science)
Capability-based security systems grant specific capabilities to processes rather than using identity-based access control. A process can only exercise capabilities it has been explicitly granted.

The AAO action whitelist is a capability list for the AI system. The distinction is the implementation context — capability-based security is a general OS concept; AAO is a specific pattern for AI systems taking real-world actions, with additional requirements for audit trails, confirmation models, and snapshot-based recovery.

### DevSecOps and Shift-Left Security
DevSecOps moves security considerations earlier in the development lifecycle. AAO's SDLC extension similarly requires action boundary assessment at the planning stage rather than the deployment stage.

The distinction is scope — DevSecOps addresses security across the entire system; AAO addresses specifically the safety of AI autonomous action capability.

---

## What AAO Addresses That Nothing Else Does

No existing framework addresses all of:
1. AI-specific action boundary enforcement (not just OS-level access control)
2. Prompt injection as a threat to real-world actions (not just information disclosure)
3. Calibrated confirmation models proportional to action risk
4. Snapshot-based recovery specifically for AI-initiated state changes
5. SDLC extension for teams building AI systems with autonomous action capability
6. Failure intelligence feedback loop from field deployments to development

AAO is the first framework to address this combination as a unified methodology.

---

*research/prior-art.md | AAO Methodology | © 2026 Donald Moskaluk*
