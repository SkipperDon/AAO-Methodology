# d3kOS — AAO Reference Implementation

d3kOS is the first production implementation of the AAO methodology. It is an AI-powered marine electronics platform that enables an onboard AI assistant to diagnose and fix marine electronics problems autonomously while a vessel is underway.

---

## Why d3kOS Needed AAO

The d3kOS constraints were severe:
- Mistakes could disable navigation or engine monitoring at sea
- The operator is often non-technical and cannot evaluate AI actions
- The system must work completely offline for extended periods
- Recovery must be possible without any technical knowledge
- A vessel offshore has no access to remote technical support

Standard AI integration approaches — prompt engineering, human-in-the-loop review, sandboxed environments — were insufficient for this threat model. AAO emerged from the requirement to make AI action capability safe enough to deploy on a vessel at sea.

---

## AAO Compliance Level

**d3kOS implements AAO Advanced** — all three compliance levels:
- AAO Core: Four-layer architecture, whitelist, audit trail, snapshot/rollback
- AAO Standard: Prompt injection defences, full SDLC integration
- AAO Advanced: Failure intelligence system, proactive scanning

---

## Implementation Details

**Repository:** github.com/SkipperDon/d3kOS  
**Contact:** skipperdon@atmyboat.com  
**Platform:** Raspberry Pi 4B  
**Base partition:** `/opt/d3kos/base/` (read-only at runtime)  
**Runtime partition:** `/opt/d3kos/runtime/`  
**Data partition:** `/opt/d3kos/data/`  

---

## Key Implementation Decisions

**The action whitelist includes 14 named actions** ranging from read-only log access (risk: None) to applying signed update packages (risk: High). The whitelist is stored at `/opt/d3kos/base/ai-action-whitelist.json`.

**Two AI modes:** Online mode uses the Claude API (claude-sonnet model). Offline mode uses a local pattern matching system with cached knowledge base entries. The user experience is identical in both modes.

**The diagnostic console** at AtMyBoat.com provides remote AI-assisted diagnosis and fix delivery for fleet administrators, using the same AAO principles applied to remote access.

**The failure intelligence system** collects anonymised failure records from all d3kOS installations, enabling pattern detection and proactive software improvement.

---

## Lessons From Production Implementation

**Build the Action Layer first.** Every other component is constrained by it from the start. Retrofitting it is significantly more difficult.

**The user confirmation UX matters enormously.** A confirmation dialog that is too disruptive gets dismissed without reading. A confirmation that is too subtle gets approved without consideration. d3kOS uses conversational confirmation for Low risk actions and dedicated dialogs for Medium and High — this calibration was arrived at through user testing.

**Offline mode requires the same safety architecture as online mode.** The temptation is to relax safety constraints when the AI is just pattern matching. Do not. The audit trail, snapshot, and rollback system apply regardless of AI mode.

**The immutable base partition made the factory reset genuinely useful.** Before the immutable base, factory reset meant reflashing from scratch and losing everything. With the immutable base, factory reset means wiping the runtime partition and re-running the setup wizard — 5 minutes not 30.

---

*d3kOS | AtMyBoat.com | Donald Moskaluk | skipperdon@atmyboat.com*
