# AAO Methodology Repository — Version 11 Changelog

## Claude Code Skill-Based Invocation Pattern

**Release Date:** 2026-10-02
**Version:** 11.0
**Spec version:** v2.1 → v2.2

---

## Summary

Version 2.2 adds Section 26: Claude Code Skill-Based Invocation Pattern. This section formalises the standard pattern for packaging AAO methodology elements as Claude Code skills — self-contained instruction files that load on demand via the `/` slash command system.

Two standard skills ship with this release under `claude-code-config/skills/`:

- **aao-methodology** — loads the full AAO governance framework for a session (session start/close, confidence gate, clarification gate, scope rules, quality metrics)
- **aao-orchestration** — activates AAO Orchestration Protocol v5.1 (multi-model routing: Haiku leads, Gemini builds, Sonnet reviews, Opus consults)

The `claude-code-config/CLAUDE.md` reference file has been rewritten as a clean generic template, removing all project-specific content.

---

## What Was Added

### SPECIFICATION.md — Section 26: Claude Code Skill-Based Invocation Pattern

Eight subsections:

**26.1 Purpose** — Why skills separate methodology instructions from CLAUDE.md project configuration, reducing inline duplication and version drift.

**26.2 Skill Architecture** — How Claude Code skills work: YAML frontmatter + instruction body, `.claude/skills/` location, slash command invocation, session persistence rules.

**26.3 Standard AAO Skills** — The two standard skills (`aao-methodology`, `aao-orchestration`) and where they are distributed.

**26.4 aao-methodology Skill** — What the skill loads: session start/close sequences, bug fix workflow, confidence gate, clarification gate, scope rules, standing constraints, OIC format.

**26.5 aao-orchestration Skill** — Model dispatch table, routing threshold (micro vs. full code changes), relationship to §23 Three-Tier Agentic Model, when to activate.

**26.6 Skill File Format** — YAML frontmatter requirements, instruction body conventions, multi-file skill directory pattern (`SKILL.md` entry point).

**26.7 Installation** — Step-by-step: copy skill files, update paths, reference from CLAUDE.md, auto-load pattern.

**26.8 Compliance Classification** — Level 2 operational extension (not required for Level 1). Skill-Governed Session compliance requirements.

---

### claude-code-config/skills/ — New Directory

**aao-orchestration.md** — Standard skill file for AAO Orchestration Protocol v5.1. Generic, ready to copy into any project's `.claude/skills/`.

**aao-methodology/SKILL.md** — Standard skill file for AAO methodology framework. Generic template with `[path/to]` placeholders for project-specific paths.

---

### claude-code-config/CLAUDE.md — Rewritten as Generic Template

Previous version contained project-specific content from the d3kOS reference implementation (private IPs, project-specific bug tracking rules, platform-specific paths). Rewritten as a fully generic CLAUDE.md template that any project can adopt, with `[FILL IN]` placeholders for project-specific sections.

The d3kOS reference implementation remains available under `examples/d3kOS/`.

---

## Compliance Impact

Section 26 is a **Level 2 operational extension**. No changes to Level 1 core compliance requirements. Projects claiming **Skill-Governed Session** compliance must:
- Both standard skills installed and invocable
- CLAUDE.md references skills rather than reproducing methodology inline
- Session logs record which skills were activated each session

---

*Section 26 authored: Donald Moskaluk, AtMyBoat.com, 2026-10-02*
*Drafted by Claude Sonnet 4.6 at operator direction, based on d3kOS reference implementation.*
