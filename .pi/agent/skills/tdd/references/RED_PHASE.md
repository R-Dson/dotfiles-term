# Red phase

## Purpose

Create a failing test that defines the next behavior. The Red phase is complete only when the test fails for the expected reason.

## Steps

1. Identify the next smallest behavior.
2. Choose the right test level.
3. Write the test against public behavior or a stable public interface.
4. Run the narrowest relevant test command.
5. Confirm the failure proves the behavior is missing.
6. Record the Red handoff.

---

## Requirement analysis

Before writing the test, identify:

```text
Behavior:
Happy path:
Edge cases:
Existing related tests:
Expected failure:
Test command:
````

If requirements are ambiguous, record:

```text
ASSUMPTION: <reasonable assumption>
```

Do not block on clarification if a safe, reversible assumption can be made.

---

## Test-authoring rules

* Test behavior, not private implementation details.
* Use existing test patterns, helpers, factories, and naming conventions.
* Prefer one behavior per test.
* Include edge cases that clarify the contract.
* Make test data explicit and readable.
* Keep tests deterministic.
* Mock only true external boundaries.
* Do not add test-only exports for private functions.
* Do not change production code in Red except when required to expose an existing public entry point or fix broken test setup.

---

## Failing for the right reason

Good Red failures include:

```text
Expected 404, received 200
Expected validation error, received success
Expected item to be visible, but it was not found
Expected function to throw DomainError, but it returned normally
```

Bad Red failures include:

```text
SyntaxError
Cannot find module
ReferenceError caused by missing import
Test runner misconfiguration
Network timeout from unmocked external service
Snapshot failed because unrelated output changed
```

Fix bad Red failures before moving to Green.

---

## Subagent mode

If subagents are available, use a dedicated test-writing worker.

Role:

```text
tdd_test_writer
```

Task:

```text
Write tests only. Do not implement production behavior. Do not modify source files except for necessary public exports already consistent with project architecture.
```

Expected output:

```text
Test files changed:
Command run:
Failure observed:
Failure reason:
Assumptions:
```

---

## Red handoff template

Use this when Red is complete.

```markdown
## TDD red phase complete

- **Mode:** <subagent | manual>
- **Behavior:** <behavior under test>
- **Test files:** `<path>`
- **Verification command:** `<exact command>`
- **Failure reason:** <expected failure>

### Implementation contract

1. Do not weaken, delete, or rewrite the failing test during Green.
2. Implement only the scoped behavior.
3. Prefer changes in: `<paths or modules>`.
4. Green is complete only when `<command>` passes.
```

