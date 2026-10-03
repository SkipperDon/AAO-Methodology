# AAO Methodology Repository — Version 12 Changelog

## Sonnet Delegation Rule + Gemini Documentation Ownership

**Release Date:** 2026-10-02
**Version:** 12.0
**Spec version:** v2.2 → v2.3

---

## What Changed

### §26.5.2 Model Dispatch Table — Revised

The orchestration lead role has moved from Haiku to Sonnet. Haiku's failure as orchestration lead — ignoring graft/wiki context, asking questions the codebase would answer, not reading methodology — was generating rework that cost more than the token savings. Sonnet's context-reading capability is the correct fit for orchestration.

Documentation ownership has moved from Haiku (finalize) to Gemini (build + document together). Sonnet's documentation role is now review-only.

| Role | Previous | New |
|---|---|---|
| Orchestration Lead | Haiku | **Sonnet** |
| Documentation (draft) | Gemini | Gemini (unchanged) |
| Documentation (finalize) | Haiku | **Removed — Gemini writes from templates** |
| Documentation Review | — | **Sonnet (new — 3-line pass/fail only)** |
| Micro Tasks | Haiku (shared) | **Haiku (exclusive — ≤3 lines only)** |

### §26.9 Sonnet Delegation Rule — New Section

The core problem: Sonnet defaults to implementing instead of delegating because writing a spec feels like more overhead than just doing the work. Without a structural constraint, Sonnet implements at 5–20× the cost of Sonnet-spec + Gemini-build.

**The fix — mandatory pre-declaration:**

Every Sonnet response during a build task MUST begin with one of five OUTPUT TYPE declarations on line 1:

```
OUTPUT TYPE: graft/wiki query
OUTPUT TYPE: Gemini Spec
OUTPUT TYPE: verification
OUTPUT TYPE: doc review
OUTPUT TYPE: operator question
```

This is a structural commitment, not a preference. Writing code after declaring `Gemini Spec` is a visible contradiction the operator catches immediately — without reading the full response.

**Five output types defined:**

| Output Type | Purpose | Cap |
|---|---|---|
| `graft/wiki query` | Read codebase context before speccing. No code. | — |
| `Gemini Spec` | Input → output → constraints → acceptance test → doc templates | 300 tokens |
| `verification` | Pass/fail on Gemini code output. May quote; no new implementation. | — |
| `doc review` | 3-line pass/fail on Gemini's doc output. One correction directive max. | — |
| `operator question` | Single bounded question when blocked. Not a list of options. | — |

**Gemini Spec doc template format:**

Every `Gemini Spec` for a build task includes this documentation section pre-filled by Sonnet:

```
DOCS REQUIRED:
SESSION_LOG: [date] | [task title] | Files: [list] | Outcome: [pass/fail]
CHECKLIST: BUG-[XX] status → [FIXED/OPEN] | [one-line description]
DEPLOYMENT_INDEX: [file path] | [description] | commit: [Gemini fills after build]
```

Gemini completes the commit hash post-build. Sonnet's `doc review` checks accuracy — it does not rewrite.

**Why Gemini documents:** Gemini just wrote the code — it has all the facts. It only needs the template and the BUG number. Sonnet writing docs from scratch costs 10–20× more than Sonnet reviewing Gemini's template output.

**Enforcement:**

1. **Pre-declaration trap** — Sonnet commits to output type on line 1 before writing anything. Violations are visible immediately.
2. **Operator brake phrase** — `DELEGATION VIOLATION — discard everything after line 1. Write the Gemini Spec only.`
3. **Three-strike session pause** — Three violations in one session triggers operator routing decision. Log in SESSION_LOG.md.

**Hard restrictions on Sonnet during orchestration:**
- MAY NOT write implementation code
- MAY NOT write project documentation from scratch
- MAY NOT exceed 300 tokens in a Gemini Spec
- MAY NOT ask questions answerable by reading graft/wiki

---

## Files Changed

| File | Change |
|---|---|
| `SPECIFICATION.md` | §26.5.2 dispatch table revised; §26.5.3–4 updated; §26.9 added; version v2.2 → v2.3 |
| `CHANGELOG_v12.md` | This file |

---

## Compliance Impact

No change to Level 1 or Level 2 compliance requirements. §26.9 is an operational refinement within the existing Skill-Governed Session compliance tier. Projects using the `aao-orchestration` skill should update their CLAUDE.md to reflect the revised dispatch table and add the Sonnet Delegation Rule.

---

*Donald Moskaluk, AtMyBoat.com, 2026-10-02*
*Drafted by Claude Sonnet 4.6 at operator direction.*
