## DOCUMENT 1 — Master AI Engineering, Coding, and Testing Standard

**Purpose:** Defines how AI must produce code, tests, documentation, and instructions so that a human can run, validate, and maintain the system on Windows.

### AI Behavior Rules

- Ask for missing information before generating code or tests

- Produce structured, multi-section output

- Explain reasoning clearly

- Provide alternatives when multiple approaches exist — highlight tradeoffs

- Avoid vague statements

- Ensure all code is runnable without modification

- Ensure all tests are executable on Windows

- Provide human-readable instructions with troubleshooting guidance

- Use modern engineering practices at all times

### Required Deliverables (every engineering task)

Problem definition — System architecture — Technology stack recommendation — Data model and schema — API or module design — Core logic or algorithms — Example code — Playwright automated tests — Windows execution instructions — Testing strategy — Documentation package

### Coding Standards

**General:** Modular, maintainable, readable. Separation of concerns. Typed languages or typed subsets. No deprecated libraries. Comments for non-obvious logic. Environment variables for configuration. Error handling and logging. Runnable without modification.

**JSON:** Always valid JSON. Consistent naming (snake_case or camelCase). No comments in JSON. Provide example payloads. Validate against schema when applicable.

**Python:** PEP 8. Type hints. Virtual environments. Modern libraries (requests, pydantic, pytest). No global variables. Docstrings. Unit tests via pytest. async/await when appropriate. Exception handling.

**C++:** C++17 or C++20. RAII. Smart pointers over raw pointers. std::vector over raw arrays. const correctness. Modern CMake. Unit tests via GoogleTest. Document memory ownership. No undefined behavior. Performance notes for critical sections.

### Testing Standards

Every test case must include: Test name — Purpose — Preconditions — Human-readable steps — Expected results — Playwright code — Assertions — Cleanup steps

**Test design rules:**

- Auto-waiting (no sleeps)

- Accessibility-friendly selectors (`getByRole`, `locator`)

- Screenshot capture on failure

- Clear `expect()` assertions

- Comments explaining each step

- No brittle selectors

- Validate both UI behavior and system state

**Coverage required:** Happy path — Error handling — Edge cases — Authentication — Form validation — Navigation — Data persistence — Performance-critical flows

### TDD Rule (non-negotiable)

For any bug fix: write a failing test that reproduces the bug FIRST. The fix is only written after the failing test exists. A test written after the fix is not a test — it is documentation.

### Playwright Standards

- Use `page.locator()` or `page.getByRole()` — never deprecated selectors

- Auto-waiting always

- `expect()` assertions

- Screenshot on failure

- Comments on every step

- Support Chromium, Firefox, or WebKit

- Each step documents: Action | Selector | Expected result

- Troubleshooting included for: selector failures, timeouts, browser launch, missing deps, login failures

### Windows Execution Standards

Every test delivery must include:

- Install Node.js or Python

- Install Playwright: `npm init playwright@latest`

- Save test file to `tests/` folder

- Run: `npx playwright test`

- View report: `npx playwright show-report`

- What the tester should see: browser opens, steps execute, assertions pass, report shows green

### Performance and Reliability

- Avoid unnecessary computation; use caching

- No blocking operations; use async correctly

- Tests must be deterministic — no flaky selectors, no timing-dependent logic

### Documentation Standards

Every deliverable must include: Overview — Architecture — Setup — Usage — Test instructions — Troubleshooting — Glossary


## DOCUMENT 2 — Standard Test Case Creation Template

**Purpose:** Defines the exact structure AI must use when generating automated Playwright tests.

### AI Test-Generation Rules

- If any required detail is missing (URL, steps, expected results, credentials, browser, language) — ASK before generating

- Always produce TWO outputs: (1) human-readable test plan, (2) runnable Playwright script

- All setup/execution steps assume Windows 11

- Never assume Node/Python is installed, Playwright is configured, test data exists, or credentials are known

- Generate self-contained tests that run immediately after copy/paste

### Required Inputs Before Generating a Test

Test name — Purpose — URL — Preconditions — Step-by-step actions — Expected results — Browser type (Chromium/Firefox/WebKit) — Language (Python/TypeScript/.NET)

### Required Test Case Structure

**3.1 Test Summary** — one sentence describing what the test verifies

**3.2 Preconditions** — test data, authentication, environment setup

**3.3 Human-Readable Steps** — each step formatted as: `Action: [what happens] | Selector: [how found] | Expected Result: [what should happen]`

**3.4 Playwright Code (runnable)** — imports, browser launch, navigation, actions, assertions, error handling, screenshot on failure

**3.5 Post-Conditions** — cleanup, state reset, browser close

### Playwright Code Requirements

- `test()` blocks with async/await

- `page.getByRole()` or `page.locator()` — no deprecated selectors

- `expect()` assertions

- Screenshot on failure

- Comments explaining each step

### Execution Instructions (always included)

```
# Run all tests
npx playwright test

# Run this specific test
npx playwright test --grep "Test Name"

# Run with visible browser
npx playwright test --headed

# View report
npx playwright show-report
```

### Troubleshooting (always included)

- Browser not launching: reinstall Playwright browsers

- Selectors failing: UI changed, update selectors

- Timeouts: increase timeout or use stable locators

- Login failures: check credentials or environment variables


## DOCUMENT 3 — AI Engineering & Automated Testing Specification Template

**Purpose:** The fill-in specification template used to scope any new project. AI uses this structure when creating a project spec.

### Required Sections in Every Project Spec

1. Project Overview (name, purpose, users, outcome, constraints)

2. Functional Requirements

3. Non-Functional Requirements (performance, reliability, security, scalability, maintainability, usability)

4. Quality Standards (usability, performance, documentation, modern practices)

5. Security Requirements (secure-by-default, input validation, no unnecessary sensitive data storage)

6. Interoperability Requirements (open standards, APIs, no vendor lock-in)

7. Maintainability Requirements (readable code, future expansion, logging/monitoring)

8. Required Deliverables (problem definition, architecture, stack, data model, API design, algorithms, code, deployment plan, test strategy, documentation)

9. AI Interaction Rules (structured output, reasoning, alternatives, tradeoffs, no vague statements)

10. Automated Testing Requirements

### Automated Testing Requirements

- Browser-level: Playwright/Selenium/Puppeteer — navigation, clicking, typing, form submission, validation, screenshots, logging

- Tests must run in: local dev, CI/CD, headless browser

- AI-driven test refinement: when results are returned, diagnose failures, propose fixes, update scripts

- When test results are provided, AI MUST: diagnose failures, propose fixes, update scripts, improve reliability


## DOCUMENT 4 — AI Engineering Specification & Solution Design Template

**Purpose:** Governs how AI approaches solution design for any new problem.

### Solution Design Rules

**Usability:** System must be intuitive, minimal training required. Modern UX principles. Actionable error messages. Simple, documented configuration.

**Performance:** Optimized for speed and memory. Architecture must support scaling. Benchmarks must be defined.

**Modern Practices:** Modular code. Dependency injection, separation of concerns. Automated tests. Typed languages. No deprecated libraries.

**Security:** Secure-by-default. Validate all inputs. No unnecessary sensitive data storage. Secure deployment guidance.

**Interoperability:** Open standards. APIs and integration points. No vendor lock-in.

**Maintainability:** Self-documenting code. Architecture supports future expansion. Logging, monitoring, diagnostics.

### Architecture Deliverables (required)

- Diagrams (ASCII or described)

- Component responsibilities explained

- Data flow described

- Failure modes and recovery strategies identified

### AI Interaction Rules

When generating solutions:

- Structured multi-section output

- Clear reasoning

- Alternatives with tradeoffs

- No vague or generic statements

- ASCII diagrams when helpful

- Ask clarifying questions if requirements are incomplete

When writing code:

- Modern idioms

- Comments on non-obvious logic

- Runnable examples

- No unnecessary complexity
