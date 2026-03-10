Instruction Block the AI Assistant Needs (Add This to Your Template)

**AI Test‑Generation Behavior Requirements**

When generating automated tests, the AI must follow these rules:

1.  **Request missing information**\
    If any required detail is missing (URL, steps, expected results,
    credentials, browser type, language), the AI must ask the human for
    clarification before generating the test.

2.  **Produce two outputs**

    -   A **human‑readable test plan**
    -   A **runnable Playwright test script**

3.  **Use Windows‑friendly instructions**\
    All setup and execution steps must assume the human is running
    Windows 11.

4.  **Explain how to run the test**\
    The AI must provide clear, step‑by‑step instructions for:

    -   installing dependencies
    -   saving the test file
    -   running the test
    -   viewing the report
    -   troubleshooting failures

5.  **Use modern Playwright practices**

    -   *page.getByRole()* or *page.locator()*
    -   auto‑waiting
    -   *expect()* assertions
    -   screenshot on failure
    -   comments explaining each step

6.  **Describe validation logic**\
    The AI must explain:

    -   what is being validated
    -   why it matters
    -   how the script checks it

7.  **Include human‑readable steps**\
    Each step must include:

    -   **Action**
    -   **Selector**
    -   **Expected result**

8.  **Avoid assumptions about the environment**\
    The AI must not assume:

    -   the human has Node/Python installed
    -   Playwright is already configured
    -   test data exists
    -   credentials are known

9.  **Provide troubleshooting guidance**\
    The AI must include fixes for:

    -   selector failures
    -   timeouts
    -   login issues
    -   missing dependencies

10. **Ensure the test is self‑contained**\
    The AI must generate a test that can run immediately after
    copy/paste.

# AI Assistant test template

1\. Purpose of the Template

This template instructs an AI assistant to generate:

-   a complete Playwright test case
-   written in a modern, maintainable style
-   runnable on Windows
-   with clear steps, assertions, and error handling
-   using human‑like browser interactions

The AI must follow this structure exactly.

2\. Information the AI Needs to Create a Test Case

The AI must request or use the following inputs:

-   **Test name**
-   **Purpose of the test**
-   **URL to test**
-   **Preconditions** (e.g., user account, test data)
-   **Step‑by‑step actions**
-   **Expected results**
-   **Browser type** (Chromium, Firefox, WebKit)
-   **Language** (Python, TypeScript, or .NET)

If any of these are missing, the AI must ask for them.

3\. Required Structure of an AI‑Generated Playwright Test Case

Every test case must include the following sections:

3.1 Test Summary

-   One‑sentence description of what the test verifies.

3.2 Preconditions

-   Test data
-   Authentication requirements
-   Environment setup

3.3 Test Steps (Human‑Readable)

Each step must be written as:

-   **Action** --- what the user does
-   **Selector** --- how the element is located
-   **Expected result** --- what should happen

Example:

-   Click the login button --- selector: *button#login* --- expected:
    login form appears.

3.4 Playwright Code (Runnable)

The AI must generate:

-   imports
-   browser launch
-   navigation
-   actions
-   assertions
-   error handling
-   screenshot on failure

3.5 Post‑Conditions

-   Cleanup
-   Reset state
-   Close browser

4\. Code Requirements for the AI

The AI must generate Playwright code that:

-   uses auto‑waiting
-   uses *page.locator()* instead of deprecated selectors
-   includes assertions (*expect()*)
-   includes comments explaining each step
-   includes screenshot capture on failure
-   uses async/await for TypeScript or sync API for Python

Example requirement:

-   "Use *page.getByRole()* when possible for accessibility‑friendly
    selectors."

5\. Template the AI Must Use to Generate a Test Case

You can paste this into any AI assistant:

**Playwright Test Case Template (AI‑Consumable)**

**Test Name:**\
\[AI fills in\]

**Purpose:**\
\[AI fills in\]

**URL Under Test:**\
\[AI fills in\]

**Preconditions:**

-   \[AI fills in\]

**Test Steps (Human‑Readable):**

1.  **Action:** \[AI fills in\]\
    **Selector:** \[AI fills in\]\
    **Expected Result:** \[AI fills in\]
2.  **Action:**\
    **Selector:**\
    **Expected Result:**

(Continue until complete)

**Generated Playwright Code (Python or TypeScript)**

\# AI generates complete runnable code here

or

// AI generates complete runnable code here

The code must include:

-   imports
-   browser launch
-   navigation
-   actions
-   assertions
-   screenshot on failure
-   comments explaining each step

**Validation Logic**

The AI must include:

-   what is being validated
-   how it is validated
-   what constitutes failure
-   what screenshots/logs to capture

**Post‑Conditions**

-   \[AI fills in cleanup steps\]

6\. Example of How the AI Should Answer Using the Template

If you give the AI:

Create a Playwright test case for logging into example.com with username
and password.

The AI should respond with:

-   a filled‑in test summary
-   human‑readable steps
-   full Playwright code
-   assertions
-   screenshot logic
-   cleanup steps

All following the template above.

7\. Why This Template Works

This structure ensures:

-   consistency across all tests
-   clarity for humans
-   machine‑readable steps for AI
-   runnable code for developers
-   modern Playwright best practices
-   easy integration into CI/CD

It also aligns with your broader goal of building a **world‑class,
modern, well‑documented engineering system**.

You can give an AI assistant a **clear, repeatable instruction set**
that tells it two things at once:

1.  **How to generate Playwright test cases**, and
2.  **How to give a human tester step‑by‑step instructions to run those
    tests on Windows.**

The template below is designed so any AI assistant can consume it and
produce:

-   a complete Playwright test
-   human‑readable execution steps
-   Windows‑friendly setup instructions
-   validation and troubleshooting guidance

It becomes your standard for AI‑generated automated tests.

## 🧩 Template for AI‑Generated Playwright Test Cases With Human Execution Instructions

### 1. Test Case Summary

-   **Test Name:**
-   **Purpose:**
-   **What the test verifies:**

### 2. Preconditions

-   Required accounts or credentials
-   Required test data
-   Required environment variables
-   Required browser (Chromium, Firefox, WebKit)
-   Required tools installed on Windows

### 3. Windows Setup Instructions (Human‑Readable)

The AI must always generate these steps so a human can run the test:

1.  Install Node.js (if not installed).

2.  Install Playwright using:

    *npm init playwright@latest*

3.  Choose "TypeScript" or "JavaScript" when prompted.

4.  Confirm browsers installation when Playwright asks.

5.  Save the generated test file into the *tests/* folder.

6.  Run the test using:

    *npx playwright test*

7.  View results in the Playwright HTML report:

    *npx playwright show-report*

The AI must adapt these steps if Python or .NET is chosen instead of
Node.js.

## 🧪 4. Human‑Readable Test Steps

Each step must include:

-   **Action** (what the human expects the script to do)
-   **Selector** (how the element is found)
-   **Expected Result**

Example format:

1.  **Action:** Navigate to login page\
    **Selector:** *page.goto(\"https://example.com/login\")*\
    **Expected Result:** Login form is visible
2.  **Action:** Enter username\
    **Selector:** *page.getByLabel(\"Username\")*\
    **Expected Result:** Field contains entered text
3.  **Action:** Click Login\
    **Selector:** *page.getByRole(\"button\", { name: \"Login\" })*\
    **Expected Result:** User is redirected to dashboard

## 🧩 5. Playwright Test Code (Generated by AI)

The AI must output runnable code using modern Playwright patterns:

-   *test()* blocks
-   *page.getByRole()* or *page.locator()*
-   auto‑waiting
-   assertions using *expect()*
-   screenshot on failure
-   comments explaining each step

Example structure:

*import { test, expect } from \'@playwright/test\';*

*test(\'Login flow works\', async ({ page }) =\> {*

* await page.goto(\'https://example.com/login\');*

* await page.getByLabel(\'Username\').fill(\'testuser\');*

* await page.getByLabel(\'Password\').fill(\'password123\');*

* await page.getByRole(\'button\', { name: \'Login\' }).click();*

* await expect(page).toHaveURL(\'https://example.com/dashboard\');*

*});*

## 🧭 6. Execution Instructions for the Human Tester

The AI must always include:

### How to run the test

*npx playwright test*

### How to run only this test

*npx playwright test \--grep \"Login flow works\"*

### How to run in headed mode (visible browser)

*npx playwright test \--headed*

### How to open the report

*npx playwright show-report*

### What the tester should look for

-   Browser opens
-   Steps execute automatically
-   Assertions pass
-   No errors in terminal
-   Report shows green checkmarks

## 🧯 7. Troubleshooting Guidance

The AI must include common issues and fixes:

-   **Browser not launching:** reinstall Playwright browsers
-   **Selectors failing:** UI changed, update selectors
-   **Timeouts:** increase timeout or use more stable locators
-   **Login failures:** check credentials or environment variables

## 🧩 8. Post‑Conditions

-   Browser closes
-   Test data cleaned up (if needed)
-   Logs and screenshots stored in *playwright-report/*

## 🧭 How the AI Should Use This Template

When you give the AI a request like:

> "Create a Playwright test for the checkout flow and include
> instructions for a human tester on Windows."

The AI must produce:

-   a filled‑in version of every section above
-   runnable Playwright code
-   Windows‑friendly setup and execution steps
-   clear human instructions
