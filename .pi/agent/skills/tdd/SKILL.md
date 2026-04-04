---
name: tdd
description: Implements features and bugfixes using the Red-Green-Refactor workflow. Enforces writing failing tests before production code, preventing regressions, and ensuring behavioral verification.
---

# Test-Driven Development (TDD)

Follow this workflow to ensure high-quality, verified code. Do not write production code until a test fails for the expected reason.

## Core Principles
1. **No Production Code Without a Failing Test**: If you wrote code first, delete it and start over.
2. **Fail for the Right Reason**: The test must fail because of the *missing behavior*, not because of a syntax error.
3. **Behavior over Implementation**: Test what the code *does*, not how it does it.
4. **Verification is Final**: Never signal completion without a green test suite.

## Workflow Execution

### 1. The Red Phase (Define & Fail)
- Detect the project's test runner and create a failing test.
- *Refer to [RED_PHASE.md](references/RED_PHASE.md) for sub-agent roles and handoff templates.*

### 2. The Green Phase (Make it Pass)
- Write the **minimal** code to satisfy the test. Avoid "gold-plating."
- *Refer to [GREEN_PHASE.md](references/GREEN_PHASE.md) for implementation tactics.*

### 3. The Refactor Phase (Clean Up)
- Improve code quality while maintaining a "Green" state.
- *Refer to [GREEN_PHASE.md](references/GREEN_PHASE.md#refactor-phase) for cleanup rules.*

### 4. Final Verification
- Run the full suite to catch regressions and perform the "Definition of Done" check.
- *Refer to [VERIFICATION.md](references/VERIFICATION.md).*

## Commands
- `/skill:tdd` : Initialize a TDD session.
- `/skill:tdd verify` : Run final quality gate checks.
