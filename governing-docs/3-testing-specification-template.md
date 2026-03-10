# **AI Engineering & Automated Testing Specification Template**

## **1. Project Overview**

**Project Name:**\
\[Enter project name\]

**Purpose:**\
\[Describe the problem this solution must solve\]

**Primary Users:**\
\[Describe who will use the system\]

**Desired Outcome:**\
\[Describe what success looks like\]

**Key Constraints:**\
\[Deadlines, budget, platform, integrations, etc.\]

## **2. Functional Requirements**

\[List all required features and behaviors\]

## **3. Non‑Functional Requirements**

-   Performance
-   Reliability
-   Security
-   Scalability
-   Maintainability
-   Usability

**Additional Notes:**\
\[Add any specific expectations\]

## **4. Quality Standards**

### **4.1 Usability**

-   Must be intuitive and require minimal training
-   Interfaces must follow modern UX principles
-   Error messages must be actionable
-   Configuration must be simple and documented

**Usability Notes:**\
\[Add domain‑specific expectations\]

### **4.2 Performance**

-   Must be optimized for speed and memory efficiency
-   Architecture must support scaling
-   Include expected performance benchmarks

**Performance Targets:**\
\[Define latency, throughput, resource goals\]

### **4.3 Documentation**

Documentation must include:

-   Overview
-   Architecture
-   Setup instructions
-   Usage examples
-   Troubleshooting
-   Glossary

**Documentation Audience:**\
\[Developers, operators, end users\]

### **4.4 Modern Programming Practices**

-   Modular, maintainable code
-   Clear separation of concerns
-   Automated tests
-   Typed languages or typed subsets
-   No deprecated libraries

**Preferred Languages/Frameworks:**\
\[List your preferences\]

## **5. Security Requirements**

-   Secure‑by‑default
-   Input validation
-   No unnecessary storage of sensitive data
-   Secure deployment guidance

**Additional Security Notes:**\
\[Add domain‑specific requirements\]

## **6. Interoperability Requirements**

-   Use open standards
-   Provide APIs or integration points
-   Avoid vendor lock‑in

**Systems to Integrate With:**\
\[List external systems\]

## **7. Maintainability Requirements**

-   Readable, self‑documenting code
-   Architecture must support future expansion
-   Logging, monitoring, diagnostics

**Maintenance Notes:**\
\[Define long‑term ownership or update cycles\]

## **8. Required Deliverables from the AI Assistant**

The AI must produce:

1.  Problem definition
2.  System architecture
3.  Technology stack recommendation
4.  Data model and schema
5.  API or module design
6.  Core logic or algorithms
7.  Example code
8.  Deployment plan
9.  Testing strategy
10. Documentation package

**Additional Deliverables:**\
\[Add any project‑specific items\]

## **9. AI Interaction Rules**

When generating solutions, the AI must:

-   Produce structured, multi‑section output
-   Explain reasoning clearly
-   Offer alternatives when multiple approaches exist
-   Highlight tradeoffs
-   Avoid vague statements
-   Use diagrams (ASCII or described) when helpful
-   Ask clarifying questions if requirements are incomplete

When writing code, the AI must:

-   Use modern idioms
-   Include comments for non‑obvious logic
-   Provide runnable examples
-   Avoid unnecessary complexity

When designing architecture, the AI must:

-   Provide diagrams
-   Explain component responsibilities
-   Describe data flow
-   Identify failure modes and recovery strategies

## **10. Automated Testing Requirements**

### **10.1 Browser‑Level Testing**

AI‑generated tests must use automation tools that simulate human
behavior, such as:

-   Playwright
-   Selenium
-   Puppeteer

Tests must include:

-   Navigation
-   Clicking
-   Typing
-   Form submission
-   Validation of expected results
-   Screenshot capture
-   Logging

**Browser Testing Notes:**\
\[Add any specific flows to test\]

### **10.2 Scraping and Data Validation**

AI‑generated scrapers must:

-   Respect legal and ethical boundaries
-   Use structured extraction
-   Validate extracted data
-   Handle dynamic content when required

**Scraping Notes:**\
\[Add any domain‑specific scraping needs\]

### **10.3 Test Execution Environment**

Tests must be runnable in:

-   Local development
-   CI/CD pipelines
-   Headless browser environments

The AI must provide:

-   Setup instructions
-   Dependencies
-   Execution commands
-   Expected outputs

### **10.4 AI‑Driven Test Refinement**

When test results are provided back to the AI, it must:

-   Diagnose failures
-   Propose fixes
-   Update scripts
-   Improve reliability

## **11. Reusable Invocation Prompt**

Paste this at the top of any request to an AI assistant:

> **Use the AI Engineering & Automated Testing Specification Template to
> produce a complete, modern, high‑performance, well‑documented
> solution.\
> Follow all quality standards, constraints, and deliverables.\
> Include automated browser testing using Playwright/Selenium.\
> Ask clarifying questions if any requirement is ambiguous.**

> **Project:**\
> \[Insert project description here\]

## **12. Project‑Specific Details (Fill‑In Section)**

### **12.1 Problem Description**

\[Describe the problem in detail\]

### **12.2 Functional Requirements**

\[List required features\]

### **12.3 Non‑Functional Requirements**

\[List performance, reliability, security, etc.\]

### **12.4 Example Inputs**

\[Provide sample data or scenarios\]

### **12.5 Example Outputs**

\[Describe expected results\]

## **13. Additional Notes**

\[Any other considerations\]
