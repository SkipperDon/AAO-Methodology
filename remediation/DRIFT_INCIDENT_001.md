# Drift Incident Report — DI-001
**Date:** March 2026
**Severity:** HIGH — scope violation with no effective interrupt
**Status:** REMEDIATED

## What Happened

During a Claude Code CLI session, Claude Code touched files outside the stated
task scope. The operator used /methodology-check, /clear, and /compact.
Claude acknowledged each command and continued violating anyway.
Token consumption continued. The scope violation was not stopped.

## Root Cause

All mid-session commands are advisory. Claude can acknowledge and continue.
No mechanism blocked tool execution. The Stop hook only fires at session end.

## Remediation Applied

1. PreToolUse hook added to /home/boatiq/.claude/settings.json
   — fires before every Write, Edit, MultiEdit, or Bash tool call
   — prints [AAO PRE-ACTION] with tool name and file path to stderr

2. Emergency Brake protocol added to /home/boatiq/CLAUDE.md
   — words STOP / HALT / FREEZE / AAO STOP are unconditional hard stops
   — Claude must list files touched, state next action, await re-authorization

3. Command prefix corrected:
   — Claude Code CLI uses /command (forward slash)
   — claude.ai chat uses \command (backslash)

## Files Changed

| File | Change |
|------|--------|
| /home/boatiq/.claude/settings.json | PreToolUse hook added |
| /home/boatiq/CLAUDE.md | Emergency Brake section added |
| aao-methodology-repo/remediation/DRIFT_INCIDENT_001.md | This document |

## Rule Created

Per AAO: drift happens once, then becomes a rule.
DI-001 is now permanent methodology. The Emergency Brake is non-negotiable.

*Drift should only ever happen once.*
