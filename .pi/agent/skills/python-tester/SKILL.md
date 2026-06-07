---
name: python-tester
description: Writes, runs, fixes, and reviews Python tests using pytest. Use when the user asks to add tests, debug failing pytest suites, improve test coverage, apply TDD in Python, test edge cases, or isolate Python code with fixtures, monkeypatching, or mocks. Do not use for non-Python languages or general feature implementation without a testing focus.
disable-model-invocation: false
---

# Python tester

## Purpose

Create reliable, maintainable Python tests with `pytest`. Prefer behavior-focused tests, clear assertions, isolated side effects, and fast feedback.

## When to use

Use this skill when:

- Writing Python tests.
- Running or fixing `pytest` failures.
- Adding regression tests.
- Applying TDD to Python code.
- Testing edge cases and exceptions.
- Mocking external dependencies.
- Improving test structure, fixtures, or parametrization.
- Debugging flaky tests.
- Reviewing Python test quality.

Do not use this skill for:

- Non-Python test suites.
- General feature implementation without a testing goal.
- Performance benchmarking unless framed as test behavior.
- Security audits, except for security regression tests.

---

## Required references

Load these references as needed:

```text
references/patterns.md
references/troubleshooting.md
````

---

## Operating workflow

1. **Inspect**

   * Identify the Python project layout.
   * Find test config: `pytest.ini`, `pyproject.toml`, `setup.cfg`, `tox.ini`, or CI config.
   * Detect existing tests in `tests/`, `test_*.py`, or `*_test.py`.
   * Identify the test command used by the project.
   * Read the source code under test before writing assertions.

2. **Analyze behavior**

   * Identify inputs, outputs, side effects, exceptions, and state changes.
   * Find external boundaries: database, network, filesystem, environment, clock, queues, subprocesses, or third-party APIs.
   * Choose the right test level: unit, integration, or end-to-end.

3. **Write or update tests**

   * Use descriptive `test_` function names.
   * Follow Arrange / Act / Assert where it improves clarity.
   * Use fixtures for reusable setup.
   * Use `pytest.mark.parametrize` for repeated behavior with multiple cases.
   * Use `pytest.raises` for expected exceptions.
   * Mock only true external boundaries or expensive nondeterministic dependencies.

4. **Run targeted tests**

   * Run the smallest relevant test first.
   * Confirm failure reason when doing TDD.
   * Read tracebacks from the first meaningful failure.

5. **Iterate**

   * Fix the test if the test is wrong.
   * Fix production code if the test correctly exposes a bug.
   * Re-run until targeted tests pass.

6. **Verify**

   * Run broader relevant tests.
   * Run lint, typecheck, or coverage only when available and relevant.
   * Remove debug prints, skipped tests without reason, and placeholder assertions.

7. **Report**

   * Summarize tests added or fixed.
   * Include commands run and results.
   * Mention any checks that could not be run.

---

## Environment and discovery

Prefer project-defined commands.

Check for commands in:

```text
pyproject.toml
pytest.ini
setup.cfg
tox.ini
noxfile.py
Makefile
Taskfile.yml
justfile
CI workflow files
```

Common commands:

```bash
python -m pytest
python -m pytest tests/
python -m pytest tests/test_example.py
python -m pytest tests/test_example.py::test_specific_case
python -m pytest -q
```

Prefer `python -m pytest` when import paths are unclear because it runs pytest through the active Python interpreter.

If `pytest` is missing, do not install dependencies without user approval unless the environment expects dependency installation. Instead report:

```text
pytest is not installed in the active environment.
Suggested install: python -m pip install pytest
```

---

## Test quality rules

### Good tests

Good tests are:

* Behavior-focused.
* Deterministic.
* Isolated from external services.
* Easy to understand from the test name.
* Specific about expected outputs, errors, or side effects.
* Fast enough for normal development feedback.
* Consistent with existing project patterns.

### Avoid

Avoid:

* `assert True`.
* Empty tests.
* Tests that only execute code without asserting behavior.
* Broad snapshots for complex behavior.
* Testing private implementation details.
* Test-only exports.
* Real network calls in unit tests.
* Real sleeps or uncontrolled time.
* Shared mutable state across tests.
* Over-mocking internal helpers.
* Catching exceptions without asserting them.
* Skipping tests without a reason and follow-up.

---

## Test naming

Use names that describe behavior and condition.

Good:

```python
def test_calculate_total_returns_zero_for_empty_cart():
    ...
```

```python
def test_create_user_raises_for_duplicate_email():
    ...
```

Avoid:

```python
def test_works():
    ...
```

```python
def test_user_1():
    ...
```

---

## Arrange / Act / Assert

Use this shape for readability:

```python
def test_calculate_total_applies_discount():
    # Arrange
    cart = Cart(items=[Item(price=100)])
    discount = Discount(percent=10)

    # Act
    total = calculate_total(cart, discount)

    # Assert
    assert total == 90
```

Omit comments when the structure is already obvious.

---

## TDD workflow for Python

When using TDD:

1. Write the failing pytest test first.
2. Run the narrow test command.
3. Confirm the failure is caused by missing behavior.
4. Implement the smallest production change.
5. Re-run the narrow test until it passes.
6. Refactor while tests stay green.
7. Run broader verification.

Red failure should be meaningful:

```text
Expected ValidationError, but no exception was raised
Expected 404, got 200
Expected total 90, got 100
```

Bad Red failures must be fixed before Green:

```text
ModuleNotFoundError
SyntaxError
fixture 'client' not found
NameError from missing import
```

---

## Mocking rules

Use mocks to isolate external boundaries, not internal logic.

Mock:

* Network APIs.
* Databases when unit testing.
* Filesystem when not the behavior under test.
* Environment variables.
* Time and randomness.
* Subprocesses.
* Email, queues, object storage, and third-party services.

Do not mock:

* The function being tested.
* Simple internal helpers unless they are an explicit boundary.
* Data transformations that should be asserted directly.
* Every call in a call chain just because it is possible.

Prefer `monkeypatch` for environment variables, attributes, and path changes in pytest-style tests. Prefer `unittest.mock.patch` or `pytest-mock` when interaction assertions are needed.

---

## Assertion rules

Use plain `assert` for most assertions.

```python
assert result == expected
assert user.is_active is True
assert "email is required" in str(exc_info.value)
```

Use `pytest.raises` for expected exceptions:

```python
import pytest

def test_parse_config_raises_for_missing_file():
    with pytest.raises(FileNotFoundError):
        parse_config("missing.toml")
```

Use approximate assertions for floating point values:

```python
import pytest

assert result == pytest.approx(0.3)
```

---

## Verification checklist

Before reporting completion:

* [ ] Targeted test passes.
* [ ] Relevant broader tests pass or skipped with reason.
* [ ] Test fails for the right reason when doing TDD.
* [ ] Tests assert behavior, not implementation details.
* [ ] External dependencies are isolated.
* [ ] Temporary files use pytest fixtures such as `tmp_path`.
* [ ] Environment changes are restored automatically.
* [ ] No debug `print`, `pdb`, `breakpoint`, or `pytest.set_trace()` remains.
* [ ] No placeholder assertions or unexplained skips were introduced.

---

## Output contract

When adding tests:

```text
Changed:
- <test files>
- <source files, if any>

Coverage:
- <behaviors covered>

Verified:
- <commands run and results>

Notes:
- <assumptions, skipped checks, or follow-up risks>
```

When debugging failures:

```text
Failure:
- <first meaningful error>

Cause:
- <root cause>

Fix:
- <change made or recommended>

Verified:
- <command and result>
```

When unable to run tests:

```text
Not run:
- <command>

Reason:
- <why>

Risk:
- <what remains unverified>
```

