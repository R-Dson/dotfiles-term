# Green and refactor phase

## Purpose

Move from a meaningful failing test to a passing test with the smallest useful implementation, then improve the design without changing behavior.

---

## Green phase

### Goal

Make the failing test pass with minimal production code.

### Rules

- Implement only the behavior covered by the current failing test.
- Stay inside the scope defined by the Red handoff unless a small supporting change is necessary.
- Avoid unrelated cleanup, features, or opportunistic fixes.
- Do not weaken or rewrite the test to make it pass.
- Run the narrow test command frequently.
- Stop once the test passes.

### Minimal implementation guidance

Minimal does not mean careless. It means:

- No speculative options.
- No unused extension points.
- No broad rewrites.
- No premature abstraction.
- No unrelated behavior.

A hardcoded value is acceptable only when it expresses the current test’s simplest behavior and will be generalized by the next test. Remove or generalize hardcoded behavior once additional tests require it.

### Green completion

Green is complete when:

```text
- The Red test passes.
- The implementation is scoped to the behavior.
- No test was weakened.
- No unrelated behavior was added.
````

---

## Refactor phase

### Goal

Improve internal structure while preserving external behavior.

### Rules

* Keep tests green.
* Make one structural improvement at a time.
* Run the relevant test after meaningful changes.
* Do not add behavior during refactor.
* Revert or shrink the step if tests fail.

### Good refactor targets

* Rename unclear variables or functions.
* Extract duplicated logic.
* Split large functions.
* Replace confusing conditionals with named helpers.
* Align with project error-handling style.
* Move code to a more appropriate module.
* Remove temporary hardcoding introduced during Green.
* Delete obsolete comments or debug output.

### Stop refactoring when

* The code is clear enough for the current change.
* Further cleanup would expand scope.
* More refactoring needs a separate task.
* Tests are green and the implementation is maintainable.

---

## Git checkpoint

Commit only when requested or when the current workflow expects commits.

Before committing:

```bash
git status --short
git diff
git diff --staged
```

Use an atomic Conventional Commit message:

```bash
git add <files>
git commit -m "feat(<scope>): add <behavior>"
```

For bug fixes:

```bash
git commit -m "fix(<scope>): handle <case>"
```

Do not use a generic message such as:

```bash
git commit -m "feat: implement feature and refactor logic"
```

