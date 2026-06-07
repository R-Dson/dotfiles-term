# Verification gate

## Purpose

Prove that the behavior works, the regression is protected, and the codebase remains healthy before announcing completion.

---

## Required checks

Complete the relevant checks before reporting done.

### Red confirmation

- [ ] A test was added or updated before production code.
- [ ] The test failed.
- [ ] The failure matched the missing behavior.
- [ ] The failure was not caused by syntax, import, setup, or environment issues.

### Green confirmation

- [ ] The targeted test passes.
- [ ] The implementation is minimal and scoped.
- [ ] The test was not weakened.
- [ ] The change solves the user’s actual problem, not only the assertion.

### Regression confirmation

Run broader checks when available and relevant:

```bash
npm test
npm run test
npm run lint
npm run typecheck
npm run build
pytest
cargo test
go test ./...
````

Use the commands that match the project.

### Diff review

Review changed files before completion.

Check for:

* [ ] Debug `console.log`, `print`, `dbg!`, or equivalent output.
* [ ] Placeholder tests such as `expect(true).toBe(true)`.
* [ ] `TODO` or skipped tests introduced by the change.
* [ ] Test-only exports.
* [ ] Unrelated edits.
* [ ] Secrets or sensitive data.
* [ ] Naming inconsistent with project style.
* [ ] Hardcoded values that should have been generalized.

---

## Coverage guidance

Do not chase a number blindly. Instead verify that new logic has meaningful coverage for:

* Happy path.
* Important negative path.
* Boundary or edge case.
* Regression case, if fixing a bug.

If the project enforces coverage thresholds, meet them. Otherwise, prioritize behavior coverage over line coverage.

---

## Verification summary

Use this format:

```text
Verification:
- Red: <failure observed>
- Green: <targeted command passed>
- Regression: <broader command passed or not run with reason>
- Diff review: <summary>
```

If a check could not be run, say why and report the risk.

