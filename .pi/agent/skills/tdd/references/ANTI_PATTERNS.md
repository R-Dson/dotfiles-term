# Testing anti-patterns

Avoid tests that are brittle, misleading, slow without value, or disconnected from real behavior.

## Anti-patterns

| Anti-pattern | Problem | Better approach |
|---|---|---|
| Inspector | Asserts private state or local variables | Assert public behavior or observable output |
| Mock everything | Mocks internal helpers and locks implementation | Mock external boundaries only |
| Local hero | Depends on local paths, machines, or environment | Use portable fixtures and test setup |
| Flake | Uses random values, real time, or uncontrolled async | Seed randomness, mock clocks, control async |
| Liar | Passes even when logic is broken | Assert the expected behavior directly |
| Giant | Tests many unrelated behaviors at once | Split into focused tests |
| Test-only export | Exposes private internals only for tests | Test through public API or refactor boundaries |
| Snapshot blanket | Uses broad snapshots for complex behavior | Assert specific meaningful outputs |
| Coverage theater | Adds tests just to hit line coverage | Test behavior and failure modes |
| Over-specified mock | Asserts every internal call detail | Assert outcome and important boundary interactions |
| Shared mutable setup | Tests depend on execution order | Isolate setup per test |
| Sleep-based async | Uses arbitrary waits | Await deterministic signals or events |

---

## Smell checks

A test is suspicious if:

- It passes when the implementation is intentionally broken.
- It fails after a harmless refactor.
- It requires many mocks to reach the behavior.
- It only verifies that mocks were called, not that behavior happened.
- It depends on current time, random order, network state, or local filesystem layout.
- Its name says one behavior but its assertions check another.
- It is skipped without a tracked reason.

---

## Repair tactics

When a test has an anti-pattern:

1. Identify the behavior the test should protect.
2. Move the assertion closer to observable behavior.
3. Replace internal mocks with real collaborators where cheap.
4. Mock only slow, nondeterministic, or external boundaries.
5. Make data setup explicit.
6. Split unrelated assertions.
7. Re-run the test and confirm it fails for the right reason when behavior is broken.

