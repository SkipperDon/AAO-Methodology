---
name: aao-orchestration
description: AAO Orchestration Protocol v5.1 — Haiku leads, Gemini builds+tests+docs, Sonnet reviews, Opus consults (5min max)
---

# AAO Orchestration Protocol v5.1

Activate this skill at the start of any implementation session to enable multi-model routing for code generation, testing, and documentation.

## Model Dispatch Rules

| Task | Model | Responsibility |
|------|-------|----------------|
| **Orchestration Lead** | Haiku | Session direction, task dispatch, review Sonnet QA, update documentation, runtime decisions |
| **Code Generation** | Gemini 3.8 | All file edits, deployments, infrastructure code, configuration changes |
| **Testing** | Gemini 3.8 | Run all test suites (pytest, Playwright, integration tests, database tests) — report results |
| **Quality Gate** | Sonnet | Review Gemini work, flag correctness issues, verify constraints before merge |
| **Documentation (draft)** | Gemini | Write preliminary specs, runbooks, guides, solution docs (first draft) |
| **Documentation (finalize)** | Haiku | Refine/integrate Gemini's preliminary docs into MEMORY.md, SESSION_LOG.md, governance files |
| **Architecture Consult** | Opus | Cross-system design decisions, methodological questions (rare) — 5 min max per session |

## Routing Threshold

When this skill is active, Haiku (orchestration lead) routes based on task size:

- **Micro** (≤3 output lines, single value substitution, no logic): Haiku executes directly — agent spawn overhead exceeds the cost benefit at this scale
- **All other code changes**: Route to Gemini 3.8 (code generation, testing, documentation)
- **Quality gate**: Sonnet reviews before merge
- **Rare architecture questions**: Consult Opus (5 min max)

## When to Activate

Use this skill when:
- Starting an implementation session with multiple files to change
- A sprint includes code generation + testing + documentation
- Cost control is a priority (Gemini for building, Haiku for orchestration)

Skip this skill if:
- Session is read-only investigation
- Single-file micro edits (Haiku executes directly)
- Operator has not explicitly enabled orchestration

## Workflow

1. Haiku (you) receive the task
2. Haiku reads memory, project state, and task requirements
3. Haiku dispatches to Gemini for: code generation, test writing, test execution, preliminary docs
4. Sonnet reviews Gemini's output (correctness, constraints, security)
5. Haiku finalizes docs, merges results, updates governance files
6. Opus consulted only if architecture decision is unclear (5 min max)

## Cost Model

- **Haiku**: Orchestration overhead (session start, dispatch, review, doc updates)
- **Gemini 3.8**: Building + testing (target ~95% of implementation tokens)
- **Sonnet**: Quality reviews (~5–10% of tokens)
- **Opus**: Rare — consultation only, 5 min max per session

This model prioritizes Gemini (lowest cost) for all implementation work while maintaining quality gates via Sonnet and orchestration clarity via Haiku.

## Relationship to AAO §23 and §26

This skill implements the Three-Tier Agentic Model from AAO SPECIFICATION.md §23:
- Haiku = orchestration lead (session management and dispatch)
- Gemini = Tier 3 implementer (code generation, execution)
- Sonnet = Tier 2 quality reviewer (correctness, constraint verification)
- Opus = Tier 1 architect (rare consultation, 5 min max)

The skill-based invocation pattern is documented in §26 of the AAO Specification.

---

*AAO Orchestration Skill v5.1 | claude-code-config/skills/aao-orchestration.md*
*Full spec: SPECIFICATION.md §26 | Reference implementation: d3kOS / Helm-OS by AtMyBoat.com*
