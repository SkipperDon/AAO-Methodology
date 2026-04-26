# AAO Methodology Repository — Version 10 Changelog

## Extended Data Collection Fields for Research Datasets

**Release Date:** 2026-04-26
**Version:** 10.0 (v9 → v10)
**Spec version:** v1.7 → v1.8

---

## Summary

Version 1.8 adds Section 19.8: Extended Data Collection Fields for Research
Datasets. This section closes the gap between operational SQS measurement
(which the core five metrics provide) and research-quality panel data capable
of supporting causal hypothesis testing.

The five core SQS metrics (SCR, SGCR, REC, MLS, UAC) were designed for
zero-marginal-cost session governance. They are sufficient for operational
improvement. They are not sufficient to test whether higher SQS sessions
produce better independently observable productivity outcomes — the causal
claim the governance multiplier model requires.

Section 19.8 defines the additional fields, a controlled vocabulary for
failure categories, session disposition tracking requirements, minimum
dataset requirements by claim type, and the operator calculation requirement
that addresses AI self-scoring reliability concerns.

---

## What Was Added

### SPECIFICATION.md — Section 19.8: Extended Data Collection Fields

Seven subsections:

**19.8.1 Purpose** — Distinguishes operational measurement (core 5 metrics)
from research-grade datasets. Extended fields are SHOULD for research teams,
not required for compliance levels.

**19.8.2 Extended Fields** — Seven new SESSION_LOG.md fields:

| Field | Purpose |
|-------|---------|
| `session_duration_min` | Normalises per-session counts; enables SQS-per-hour analysis |
| `tasks_planned` | Denominator for task completion rate |
| `tasks_completed` | Enables H1: SQS → actual productivity outcomes |
| `governing_doc_version` | Enables H4: document updates → SQS improvement |
| `attributed_rec` | Enables H3 lagged test: prior session quality → next session REC |
| `failure_category` | Controlled vocabulary for Deming Pareto analysis |
| `human_verified` | Inter-rater reliability flag; 0 = operator-only, 1 = independently verified |

**19.8.3 Failure Category Controlled Vocabulary** — Eleven codes covering
the observable failure patterns in the reference dataset (n=36 sessions):
`none`, `pre_action_informal`, `scope_expansion`, `documentation_not_read`,
`unauthorized_action`, `implementation_error`, `deployment_error`,
`resource_exhaustion`, `specification_misread`, `wrong_deployment_target`,
`context_loss`.

The controlled vocabulary enables Pareto analysis of failure mode frequency
— directly supporting the Deming continuous-improvement argument that the
AAO methodology makes. Free-text notes remain in the existing `notes` field.

**19.8.4 Session Disposition Tracking** — Defines the `session_exclusion_log.csv`
companion file format for teams tracking excluded sessions. Addresses the
selection bias concern in incomplete-panel SQS studies: sessions that fail
to produce a complete SQS record may be systematically worse-governed than
sessions that do. The companion file lets readers assess this.

Exclusion reason codes: `context_overflow_no_close`, `sub_session`,
`missing_metrics`, `missing_session_close`, `requires_log_verification`.

**19.8.5 Minimum Dataset Requirements** — Five claim tiers with minimum
session counts, organization counts, and required fields:

| Claim type | Minimum |
|------------|---------|
| Instrument operability | n ≥ 20, single org |
| Instrument validation | n ≥ 36, SGCR correlation, circularity analysis |
| Causal productivity claim (H1) | n ≥ 50, tasks + attributed_rec data |
| Cross-org generalization | n ≥ 50, ≥ 3 orgs, governing_doc_version tracked |
| Governance multiplier calibration (H5) | n ≥ 100, ≥ 3 orgs, independent outcome measure |

These thresholds are grounded in the statistical power analysis from the
reference pilot study (d=0.80, 80% power at n=25/group for primary MLS comparison).

**19.8.6 Operator Calculation Requirement** — SQS scores in research datasets
MUST be calculated by the operator from contemporaneous session records, not
self-reported by the AI. This addresses the AI self-scoring reliability concern
raised in peer review of the governance multiplier working paper. The AI system
generates the activity record. The operator applies the formula.

---

### commands/session-close.md — Step 1C

A new optional step added between the existing Step 1B (Calculate SQS) and
Step 2 (List files changed):

**Step 1C — Extended Research Data Fields (Section 19.8)**

Defines the SESSION_LOG.md extended block format, the failure_category
controlled vocabulary (all eleven codes), and the skip instruction for
teams not generating research datasets. The step is self-contained and does
not require reading Section 19.8 to use.

---

### README.md

- **Current version:** updated to 1.8
- **Version history table** added: ten versions from 1.0 to 1.8 with
  dates and key additions

---

## Why These Fields Were Added

### The Tautology Problem

The governance multiplier model defines Γ̂ = SQS/100. If higher SQS is
only validated against other SQS-related measures, the model is circular:
higher governance quality scores score higher on the governance quality
instrument. This is not an empirical finding — it is an arithmetic identity.

Breaking the circularity requires outcome measures independent of the SQS
instrument. `tasks_planned/completed` and `attributed_rec` provide two such
measures: task completion rate and lagged recovery attribution. Both can be
measured from existing SESSION_LOG.md infrastructure with minimal additions
at session close.

### The Selection Bias Problem

In the reference pilot study (n=36 sessions from 69 total log entries), 33
sessions were excluded for incomplete SQS scores. These excluded sessions
are plausibly worse-governed than the included ones — they are precisely the
sessions where the close protocol was not completed. The session disposition
file and exclusion reason codes make this selection mechanism transparent and
auditable rather than invisible.

### The Inter-Rater Reliability Problem

AI self-scoring is a known reliability concern: if the AI whose behavior is
being scored calculates the score, systematic self-favoring bias may inflate
results. The `human_verified` flag enables teams to report the percentage of
sessions independently verified, and to calculate an inter-rater reliability
coefficient (Cohen's κ or Krippendorff's α) as an instrument validity metric.

---

## Modified Files

| File | Change |
|------|--------|
| `SPECIFICATION.md` | Section 19.8 added. Version header 1.6 → 1.8. |
| `commands/session-close.md` | Step 1C added. |
| `README.md` | Version updated to 1.8. Version history table added. |
| `CHANGELOG_v10.md` | This file. |

---

## Files Unchanged

All files not listed above are unchanged from v1.7.

---

## Breaking Changes

None. Version 1.8 is fully additive. Extended fields are SHOULD (optional)
for research contexts, not MUST for compliance. All v1.7 implementations
remain compliant without any modification.

---

## Upgrade Path

**For teams using AAO operationally (no research dataset):**
- No action required. Add `"Step 1C: not applicable"` to session-close log
  if you want to confirm Section 19.8 was evaluated and skipped.

**For teams generating SQS research datasets:**
1. Add Step 1C to your session-close workflow.
2. Record the seven extended fields at every session close.
3. Begin tracking `session_exclusion_log.csv` for sessions without complete SQS.
4. Review Section 19.8.5 to confirm your dataset meets the minimum requirements
   for the claim type you intend to make.

---

## Connection to Working Paper

Section 19.8 was developed in direct response to peer review of:

Moskaluk, D. (2026). *Governing the AI Productivity Promise: Organizational
Capital, Governance Quality, and the Capture of AI-Assisted Development Gains.*
Working Paper v3.3. SSRN.

The reviewers correctly identified: (1) AI self-scoring reliability; (2) selective
sample bias from incomplete close protocols; (3) absence of outcome measures
independent of SQS; and (4) stipulative component weights without sensitivity
analysis. Section 19.8 addresses items 1, 2, and 3 structurally. Item 4
(sensitivity analysis) is addressed in the paper's limitations section.

The `failure_category` controlled vocabulary enables the Deming Pareto analysis
the paper's Section 6 describes: identifying which failure modes recur, whether
governing document updates reduce their frequency, and whether specific categories
correlate with SQS depression in ways that inform document improvement priorities.

---

## Contact

**Author:** Donald Moskaluk
**Email:** skipperdon@atmyboat.com
**Repository:** github.com/SkipperDon/AAO-Methodology
**License:** Apache 2.0

---

*AAO Methodology Repository v10 | Spec v1.8 | © 2026 Donald Moskaluk*
