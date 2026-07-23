# Tier Escalation & Verification Protocol (DRAFT — proposed AAO Section 25)

**Status:** DRAFT for review — not yet merged into SPECIFICATION.md
**Author of draft:** Claude (Opus 4.8) at operator request, session 2026-07-23
**Builds on:** §22 (Persistent Knowledge Layer), §23 (Adaptive Governance — Three-Tier Model, Atomic Spec, Watchdog), §24 (Multi-Tier Question Queue Protocol), Confidence Score Protocol and Clarification Gate (CLAUDE.md)
**Compliance level:** proposed Level 2 operational extension (same tier as §23/§24)

---

## 25.1 Purpose

§23 defines the tiers (Tier 1 Architect / Tier 2 Spec Writer / Tier 3 Implementer) and the Atomic Spec handover. §24 defines how unresolved questions flow up via a wiki question file. This section adds the two mechanisms those sections leave unspecified:

1. **A live, structured escalation contract** — how a lower-tier model (Sonnet/Haiku) asks a higher-tier model (Opus) for clarification, advice, or a solution, *at the moment it becomes uncertain*, instead of guessing.
2. **An adversarial verification pass** — how the higher-tier model confirms the lower-tier model's output is actually correct after it is built, not merely aligned in intent.

The goal is to let cheap models do the mechanical work at 1/3 the cost while a capable model guarantees quality — without the cheap model silently shipping plausible-but-wrong output.

## 25.2 Why this is needed (the failure mode it prevents)

A weaker model's core risk is **overconfidence**: it does not reliably feel its own uncertainty, so it fills gaps with plausible defaults and proceeds. §24's question file helps, but it is (a) not triggered at a defined threshold and (b) asynchronous. This section makes escalation **forced at a confidence threshold** and gives it a **fixed message format** so the exchange is reliable whether run live (Opus orchestrating subagents) or asynchronously (operator relays between two Claude Code windows).

## 25.3 Communication topology

| Mode | Channel | When it applies | Cost |
|---|---|---|---|
| **A — Asynchronous, file-mediated** | `wiki/questions/<date>-<slug>.md` (§24) + operator relay | Lower-tier model runs in a separate session/window | Cheapest — each session on its own meter |
| **B — Live, orchestrated** | Structured subagent return value | Higher-tier model spawns the lower-tier model as a subagent in one session | Higher (runs under Tier 1 meter) but Tier 3 still does the typing |

Mode A is the default for this project (operator runs Sonnet/Haiku in a second window). Mode B is available when live Q&A and automatic re-dispatch are worth the added Tier-1 cost.

## 25.4 The escalation contract (how a lower tier asks)

When a lower-tier model must escalate, it emits **exactly this block** and stops:

```
🔺 ESCALATION — BUG-XX / <sub-task id>
Tier asking     : <Sonnet Tier 3 | Haiku Tier 3>
Type            : [CLARIFICATION | ADVICE | SOLUTION-REQUEST]
Blocking?       : [BLOCKED — cannot proceed | PROCEEDING on assumption below]
Question        : <one specific, bounded question>
Why it blocks   : <what changes in the code depending on the answer>
Options I see   : (1) ...  (2) ...
My provisional  : <best guess> — Confidence: NN/100
If I'm wrong    : <consequence>
```

**Type definitions:**
- **CLARIFICATION** — a fact the model lacks (a file path, a Signal K key, a table name). Higher tier answers in one line.
- **ADVICE** — a judgment between viable approaches. Higher tier recommends + gives reasoning.
- **SOLUTION-REQUEST** — the sub-task is beyond the lower tier's reliable capability (a subtle algorithm, a race condition). Higher tier writes that snippet; the lower tier integrates it.

## 25.5 Forced-stop triggers (when a lower tier MUST escalate)

The lower-tier model computes the Confidence Score (CLAUDE.md Confidence Score Protocol) **before writing code for each sub-task**. It MUST emit an ESCALATION block instead of writing code when **either** holds:

1. **Confidence < 75** (AMBER or RED), OR
2. **Any Clarification Gate condition is true** — missing business rule, undefined scope boundary, contradictory requirements, **unconfirmed data contract**, undefined success condition, or irreversible-and-ambiguous target.

This inverts the default: silence-and-guess is prohibited; the model must surface the gap. This is the enforcement §24 lacks.

### 25.5.1 Escalate-vs-substitute tie-breaker (when an ESCALATE-IF fires but a workaround exists)

**Origin:** first live test of this protocol (BUG-27, 2026-07-23). The spec's ESCALATE-IF list included "the app won't serve so the test can't run → CLARIFICATION." That trigger fired (Tier 3 lacked Playwright browser dependencies), but Tier 3 chose to **substitute** an equivalent test (a source-CSS parser) and document the substitution, rather than emit a 🔺 ESCALATION. The result was correct and Tier-1 verification caught the gap — but strictly the protocol had asked it to escalate.

**Rule.** When an ESCALATE-IF trigger fires, escalation is the default. A lower tier MAY substitute a workaround **only** when all three hold:
1. The workaround verifies the **same assertion** the spec required (not a weaker proxy).
2. It is **transparently logged** in the Decision Log as a deviation, with what changed and why.
3. The deviation is **non-destructive and reversible** — it does not modify additional files or system state.

If any of the three fails, the lower tier MUST emit the 🔺 ESCALATION block and wait. Even when a substitution is permitted, the higher tier's verification pass (§25.8) MUST independently confirm the substitute was sound (for BUG-27: a CSS override probe confirmed source value == computed value, validating the parser substitute). **A substitute test that cannot be independently validated by the higher tier is treated as a failed verification, not a pass.**

**Preferred future default:** escalate first; substitute only with higher-tier approval. Spec authors SHOULD state, per ESCALATE-IF entry, whether a documented substitute is acceptable or escalation is mandatory.

## 25.6 Per-spec ESCALATE-IF list (concrete triggers)

Because a weak model's "am I unsure?" detector is itself unreliable, every Atomic Spec (§23.5) produced for a lower tier MUST include a concrete, checkable ESCALATE-IF list. Example:

```
ESCALATE IF:
- the target file is not exactly <path>            → CLARIFICATION
- you cannot make the test FAIL before the fix     → SOLUTION-REQUEST
- the fix would require editing <other-file>       → ADVICE (scope question)
```

Concrete triggers beat "escalate if unsure" because they do not depend on the model's self-assessment.

## 25.7 Quality levers (how the higher tier drives quality up)

In priority order — most of the quality is bought *before* the lower tier runs:

1. **Spec richness.** The interface contract (exact paths, signatures, data shapes) and the failing test (an executable definition of done) are the two biggest ambiguity killers. A rich spec means few escalations.
2. **Forced stop.** §25.5 turns silent guessing into a visible question.
3. **Asking is free, guessing is costly.** A well-formed escalation carries zero penalty; a silent wrong assumption is a UAC event (CLAUDE.md). Reward asking.
4. **Pre-flight self-check.** Before coding, the lower tier answers three questions *from the spec alone*: which file? what proves done? what am I forbidden to touch? If it cannot answer any from the spec, it escalates.
5. **Pre-partition the hard parts.** The spec marks sections `[Tier-3 authored]` vs `[Tier-1 authored]`. Known-subtle logic is written into the spec so the weak model never attempts it.

## 25.8 The verification pass (after build)

After the lower tier returns its output, the higher tier runs an **adversarial verification pass** — distinct from the §23.6 Watchdog (which reviews *alignment*). Verification confirms *correctness*:

1. Confirm the failing test **genuinely failed before** the fix and **passes after** (guard against "fixed the test, not the bug" and trivially-passing tests).
2. Re-read the diff against the spec's **constraint boundaries** — did the lower tier touch a file it was told to leave alone?
3. Probe **adversarial edge cases** the spec's test may have missed.
4. Confirm no regression within the stated scope.

**Why this is the highest-leverage step:** authoring a fix is token-expensive; verifying one is cheap (read diff + run test + probe edges). The optimal cost/quality split is therefore *cheap model authors, capable model verifies* — you get Tier-1 judgment on the output without paying Tier-1 to write it. This is the economic core of the tier system.

**Hardware / on-Pi limit (Hardware Claim Protocol):** verification by a higher-tier model covers software only. Hardware-gated or on-device outcomes (NMEA 2000 wiring, service-running-on-Pi, audio playback) cannot be verified by reading a diff — the verification output for those is limited to "the code is correct; here is the exact on-Pi/on-boat check the operator must run." A higher tier MUST NOT claim a hardware fix works without a real test.

## 25.9 The end-to-end loop

```
Tier 1: write Atomic Spec (rich contract + failing test + ESCALATE-IF list)
  → Tier 3: pre-flight self-check → escalate OR build (test-first)
      → [if ESCALATION] Tier 1 answers (clarify / advise / write hard snippet) → Tier 3 resumes
  → Tier 3: return diff + which test now passes + Decision Log (§23.6)
  → Tier 1: verification pass (did the test flip? scope respected? edge cases?)
      → PASS → next sub-task   |   FAIL → back to Tier 3 with specifics
```

## 25.10 Tier / model routing note

Cost gate (CLAUDE.md): Tier 3 hard cap $30/month. Haiku 4.5 is ~1/3 the per-token cost of Sonnet ($1/$5 vs $3/$15 per 1M in/out). Route Tier 3 to **Haiku first**; the escalation contract is the safety net that makes the cheaper model viable. Step up to Sonnet only if Haiku escalates on nearly every sub-task (a signal that specs are under-rich or the work genuinely needs more capability).

## 25.11 Relationship to prior sections

- Extends **§23**: adds the escalation contract and verification pass on top of the Atomic Spec + Watchdog. Does not modify tier definitions or the Classification Gate.
- Extends **§24**: §24's question file is the Mode-A storage mechanism; §25 adds the forced-stop trigger, the message format, and the per-spec ESCALATE-IF list.
- Uses the **Confidence Score Protocol** and **Clarification Gate** from CLAUDE.md as the escalation trigger.
- Escalation is a Risk-None read/ask; no action is taken by the lower tier while blocked.
```
