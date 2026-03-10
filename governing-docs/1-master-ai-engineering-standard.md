# Master AI Engineering, Coding, and Testing Standard

*(Unified Specification for JSON, Python, C++, Playwright, and AI
Behavior)*

## 1. Purpose of This Standard

This standard defines how an AI assistant must produce code, tests,
documentation, and instructions so that a human can run, validate, and
maintain the system on Windows. It ensures consistency across languages,
tools, and testing workflows.

The AI must follow this standard for **every** engineering task.

## 2. Required Deliverables

The AI must produce:

1.  Problem definition
2.  System architecture
3.  Technology stack recommendation
4.  Data model and schema
5.  API or module design
6.  Core logic or algorithms
7.  Example code (JSON, Python, C++ as required)
8.  Playwright automated tests
9.  Windows execution instructions
10. Testing strategy
11. Documentation package

## 3. AI Behavior Requirements

The AI must:

-   Ask for missing information before generating code or tests.
-   Produce structured, multi‑section output.
-   Explain reasoning clearly.
-   Provide alternatives when multiple approaches exist.
-   Highlight tradeoffs.
-   Avoid vague statements.
-   Ensure all code is runnable.
-   Ensure all tests are executable on Windows.
-   Provide human‑readable instructions.
-   Include troubleshooting guidance.
-   Use modern engineering practices.

## 4. Engineering Standards

### 4.1 General Coding Standards

-   Code must be modular, maintainable, and readable.
-   Follow separation of concerns.
-   Use typed languages or typed subsets.
-   Avoid deprecated libraries.
-   Include comments for non‑obvious logic.
-   Use environment variables for configuration.
-   Include error handling and logging.
-   Ensure code is runnable without modification.

### 4.2 JSON Standards

-   Must always be valid JSON.
-   Use consistent naming (snake_case or camelCase).
-   No comments.
-   Provide example payloads.
-   Validate against schema when applicable.

### 4.3 Python Standards

-   Follow PEP 8.
-   Use type hints.
-   Use virtual environments.
-   Use modern libraries (requests, pydantic, pytest).
-   Avoid global variables.
-   Include docstrings.
-   Include unit tests using pytest.
-   Use async/await when appropriate.
-   Include exception handling.

### 4.4 C++ Standards

-   Follow C*17 or C20. *
-   Use RAII for resource management.
-   Prefer smart pointers over raw pointers.
-   Use std::vector instead of raw arrays.
-   Use const correctness.
-   Use modern CMake.
-   Include unit tests using GoogleTest.
-   Document memory ownership.
-   Avoid undefined behavior.
-   Include performance notes for critical sections.

## 5. Testing Standards

### 5.1 Test Case Structure

Every test must include:

-   Test name
-   Purpose
-   Preconditions
-   Human‑readable steps
-   Expected results
-   Playwright code
-   Assertions
-   Cleanup steps

### 5.2 Test Design Rules

-   Use auto‑waiting (no sleeps).
-   *Use accessibility‑friendly selectors (*getByRole*, *locator*). *
-   Include screenshot capture on failure.
-   *Include clear assertions using *expect()*. *
-   Include comments explaining each step.
-   Avoid brittle selectors.
-   Validate both UI behavior and system state.

### 5.3 Test Coverage Requirements

-   Happy path
-   Error handling
-   Edge cases
-   Authentication
-   Form validation
-   Navigation
-   Data persistence
-   Performance‑critical flows

## 6. Playwright Standards (Browser Automation)

### 6.1 Code Requirements

-   Use modern Playwright patterns.
-   *Use *page.locator()* or *page.getByRole()*. *
-   Use auto‑waiting.
-   *Use *expect()* assertions. *
-   Include screenshot on failure.
-   Include comments explaining each step.
-   Support Chromium, Firefox, or WebKit.

### 6.2 Human‑Readable Test Steps

Each step must include:

-   Action
-   Selector
-   Expected result

### 6.3 Validation Logic

The AI must describe:

-   What is being validated
-   Why it matters
-   How the script checks it

### 6.4 Troubleshooting Guidance

The AI must include fixes for:

-   Selector failures
-   Timeout issues
-   Browser not launching
-   Missing dependencies
-   Login failures
-   Environment variable issues

## 7. Windows Execution Standards (Human‑Friendly)

### 7.1 Setup Instructions

The AI must provide steps for:

-   Installing Node.js or Python
-   Installing Playwright
-   Installing browsers
-   Saving test files
-   Running tests
-   Viewing reports

### 7.2 Execution Commands

The AI must include:

-   Run all tests
-   Run a single test
-   Run in headed mode
-   Open HTML report

### 7.3 What the Human Should Look For

-   Browser opens
-   Steps execute automatically
-   Assertions pass
-   No terminal errors
-   Report shows green checks

## 8. Performance and Reliability Standards

### 8.1 Performance

-   Avoid unnecessary computation.
-   Use caching where appropriate.
-   Avoid blocking operations.
-   Use async patterns correctly.

### 8.2 Reliability

-   Tests must be deterministic.
-   No flaky selectors.
-   No timing‑dependent logic.
-   Validate system state after actions.

## 9. Documentation Standards

Documentation must include:

-   Overview
-   Architecture
-   Setup
-   Usage
-   Test instructions
-   Troubleshooting
-   Glossary

Documentation must be clear, structured, and complete.

## 10. Reusable Invocation Prompt

Paste this at the top of any request to an AI assistant:

> Use the Master AI Engineering, Coding, and Testing Standard to produce
> a complete, modern, high‑performance, well‑documented solution. Follow
> all engineering, testing, language‑specific, and Playwright standards.
> Ask for missing information if anything is unclear.
