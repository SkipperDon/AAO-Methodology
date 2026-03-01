# Contributing to AAO

Thank you for your interest in the AAO methodology. This document explains how to contribute when the repository goes public.

---

## Current Status

AAO is currently in pre-publication review. The methodology is stable and has been validated through the d3kOS reference implementation. We are finalising the license and conducting legal review before public release.

**If you have found this repository early:** contact skipperdon@atmyboat.com. We are happy to discuss the methodology and early collaboration opportunities.

---

## What We Are Looking For

### Documentation Improvements
The specification and documentation were written from the perspective of a marine electronics implementation. We welcome contributions that:
- Make the language more implementation-agnostic
- Add examples from other domains (home automation, industrial control, infrastructure management)
- Clarify ambiguous requirements in the specification
- Identify gaps — scenarios the current specification does not address

### New Domain Examples
The `examples/` directory currently contains only the d3kOS marine implementation. We welcome examples from:
- Home automation and smart building systems
- Industrial control and manufacturing
- Infrastructure management and DevOps automation
- Healthcare systems with autonomous AI components
- Any domain where AI takes real-world actions

### Implementation Templates
The `templates/` directory contains starter files. Improvements welcome:
- Language-specific action layer implementations (Python, Go, Rust, Java)
- Cloud-specific deployment patterns (AWS, GCP, Azure)
- Container-based implementations (Docker, Kubernetes)
- Platform-specific health check scripts

### Compliance Tooling
Tools that help teams assess and verify AAO compliance:
- Automated whitelist validation
- Audit log analysis tools
- Test suites for the required test categories
- CI/CD integration examples

---

## What We Are Not Looking For

- Changes to core compliance requirements without extensive discussion
- Implementations that weaken the security boundary between Layer 3 and Layer 4
- Contributions that introduce free-form command execution paths
- Changes that reduce the audit trail requirements

---

## How to Contribute

1. **Open an issue first** — describe what you want to contribute and why before writing code or documentation
2. **Fork the repository** and create a branch named `contribution/your-description`
3. **Follow the existing document style** — specifications use RFC 2119 language (MUST, SHOULD, MAY)
4. **Include context** — if you are implementing AAO in a real system, describe that system
5. **Open a pull request** with a clear description of what changed and why

---

## The Specification RFC Process

Changes to SPECIFICATION.md follow a more rigorous process:

1. Open an issue labelled `specification-change`
2. Describe the change, the scenario it addresses, and why the current spec is insufficient
3. Allow 14 days for community discussion
4. If consensus is reached, a maintainer will implement the change with version bump
5. MUST requirement changes require unanimous maintainer agreement

---

## Code of Conduct

This project is about making AI systems safer and more trustworthy. Contributions and discussions should reflect that purpose. Be direct, be specific, be constructive.

---

## Contact

**Donald Moskaluk** — skipperdon@atmyboat.com  
**AtMyBoat.com** — the organisation behind d3kOS and the AAO reference implementation

---

*CONTRIBUTING.md | AAO Methodology | © 2026 Donald Moskaluk*
