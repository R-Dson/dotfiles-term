---
name: tdd
description: Implements features, bug fixes, and behavior changes using the Red-Green-Refactor workflow. Use when writing production code that should be test-driven, when fixing regressions, or when adding behavior that needs automated verification.
disable-model-invocation: false
---

# TDD

## Purpose

Implement behavior through a disciplined Red-Green-Refactor loop: write a failing test for the desired behavior, make it pass with the smallest useful implementation, then improve the design while keeping tests green.

## When to use

Use this skill when:

- Adding a feature.
- Fixing a bug.
- Preventing a regression.
- Changing business logic.
- Refactoring code that already has or needs test coverage.
- Implementing a plan that requires verification at each step.

Do not use this skill as the primary workflow for:

- Pure documentation edits.
- Mechanical formatting changes.
- Generated files.
- Emergency hotfixes where the user explicitly chooses speed over TDD.
- Exploratory spikes that are intentionally thrown away.

---

## Required references

Load these references as needed:

```text
references/RED_PHASE.md
references/GREEN_REFACTOR.md
references/VERIFICATION.md
references/ANTI_PATTERNS.md
```

Use this asset for handoff summaries:

```text
assets/HANDOFF_TEMPLATE.md
```

---

## Core rules

* Do not write production code until a test fails for the expected behavior gap.
* The failing test must fail for the right reason, not because of syntax, import, setup, or environment errors.
* Test observable behavior through public APIs or user-visible behavior where practical.
* Mock only true external boundaries such as network, database, filesystem, clock, queue, email, or third-party service.
* Keep each cycle small: one behavior, one failing test or small test group, one minimal implementation.
* Never weaken, delete, or rewrite the failing test during Green just to make it pass.
* Do not announce completion until targeted tests and relevant regression checks pass.

---

## Operating workflow

1. **Scope behavior**

   * Identify the behavior to add or fix.
   * List the happy path and important edge cases.
   * Choose the smallest next behavior to test.

2. **Red**

   * Add or update a test that captures the behavior.
   * Run the narrowest relevant test command.
   * Confirm the failure is expected and meaningful.
   * Record the Red handoff.

3. **Green**

   * Implement the smallest change that satisfies the test.
   * Stay inside the scoped files.
   * Run the narrow test until it passes.

4. **Refactor**

   * Clean up names, duplication, structure, and consistency.
   * Keep tests green after each meaningful refactor.
   * Do not add new behavior during refactor.

5. **Verify**

   * Run targeted tests.
   * Run broader tests, lint, typecheck, or build when available.
   * Review the diff for accidental changes, debug output, and weakened tests.

6. **Report**

   * Summarize tests added, implementation files changed, commands run, and final status.
   * Use the handoff template when the task needs a durable record.

---

## TDD cycle contract

Each implementation cycle should produce this evidence:

```text
Behavior:
- <behavior under test>

Red:
- Test file: <path>
- Command: <command>
- Expected failure: <failure reason>

Green:
- Implementation files: <paths>
- Command: <command>
- Passing result: <summary>

Refactor:
- Cleanup performed, or "none"

Verification:
- Broader checks run
```

---

## Test selection

Prefer the test level that gives the strongest useful signal with the least brittleness.

| Situation                                            | Preferred test                            |
| ---------------------------------------------------- | ----------------------------------------- |
| Pure function or domain rule                         | Unit test                                 |
| Component or UI behavior                             | User-facing component test                |
| API route, database integration, or service boundary | Integration test                          |
| Critical user journey                                | End-to-end test                           |
| Bug report with known reproduction                   | Regression test that fails before the fix |

Do not overuse end-to-end tests for small logic changes. Do not use tiny unit tests that only lock implementation details.

---

## Output contract

When starting a TDD cycle:

```text
TDD scope:
- <behavior>

Next test:
- <test file>
- <command>
```

When Red is complete:

```text
TDD red complete:
- Test file: <path>
- Command: <command>
- Failure reason: <expected failure>
- Green scope: <allowed files or modules>
```

When Green is complete:

```text
TDD green complete:
- Implementation: <files>
- Passing command: <command>
- Refactor needed: yes | no
```

When finished:

```text
TDD complete:
- Tests added or changed: <files>
- Implementation changed: <files>
- Verification: <commands and results>
- Notes: <assumptions, skipped checks, or follow-up risks>
```

