---
name: python-tests
description: Writes, runs, fixes, and reviews Python tests using pytest. Use when the user asks to add tests, debug failing pytest suites, improve test coverage, apply TDD in Python, test edge cases, or isolate Python code with fixtures, monkeypatching, or mocks. Do not use for non-Python languages or general feature implementation without a testing focus.
disable-model-invocation: false
---

# Python tests

## Purpose

Create reliable, maintainable Python tests with `pytest`: behavior-focused, deterministic, isolated, clear, and fast.

## When to use

Use for writing Python tests, running/fixing `pytest` failures, regression tests, Python TDD, edge cases/exceptions, mocking boundaries, improving fixtures/parametrization, flaky-test debugging, or Python test reviews.

Do not use for non-Python tests, general feature implementation without a testing goal, performance benchmarking unless framed as behavior, or security audits except security regression tests.

## Required references

Load as needed:

```text
references/patterns.md
references/troubleshooting.md
```

## Operating workflow

1. **Inspect**
   - Identify project layout, source under test, existing tests, and test config.
   - Find project test command from `pyproject.toml`, `pytest.ini`, `setup.cfg`, `tox.ini`, `noxfile.py`, `Makefile`, `Taskfile.yml`, `justfile`, or CI.

2. **Analyze behavior**
   - Identify inputs, outputs, side effects, exceptions, and state changes.
   - Identify external boundaries: database, network, filesystem, environment, clock, queues, subprocesses, third-party APIs.
   - Choose unit, integration, or end-to-end level.

3. **Write or update tests**
   - Use descriptive `test_` names.
   - Use Arrange/Act/Assert where helpful.
   - Use fixtures for reusable setup and `pytest.mark.parametrize` for repeated cases.
   - Use `pytest.raises` for expected exceptions.
   - Mock only true external boundaries or expensive nondeterministic dependencies.

4. **Run and iterate**
   - Run the smallest relevant test first.
   - In TDD, confirm the failure is meaningful and caused by missing behavior.
   - Fix wrong tests; fix production code when a correct test exposes a bug.
   - Re-run until targeted tests pass, then run broader relevant checks.

5. **Clean and report**
   - Remove debug prints, breakpoints, placeholder assertions, and unexplained skips.
   - Summarize tests, commands, results, and checks that could not run.

## Common commands

Prefer project-defined commands. Use `python -m pytest` when import paths are unclear.

```bash
python -m pytest
python -m pytest tests/
python -m pytest tests/test_example.py
python -m pytest tests/test_example.py::test_specific_case
python -m pytest -q
```

If `pytest` is missing, do not install dependencies without approval unless the environment expects it. Report:

```text
pytest is not installed in the active environment.
Suggested install: python -m pip install pytest
```

## Test quality rules

Good tests are behavior-focused, deterministic, isolated from external services, clear from the name, specific in assertions, fast enough for development feedback, and consistent with project patterns.

Avoid:

- `assert True`, empty tests, and tests that only execute code.
- Broad snapshots for complex behavior.
- Testing private implementation details or adding test-only exports.
- Real network calls in unit tests.
- Real sleeps or uncontrolled time.
- Shared mutable state across tests.
- Over-mocking internal helpers.
- Catching exceptions without asserting them.
- Skips without reason and follow-up.

## Naming and assertions

Use names that describe behavior and condition.

```python
def test_calculate_total_returns_zero_for_empty_cart():
    ...

def test_create_user_raises_for_duplicate_email():
    ...
```

Use plain `assert` for most assertions:

```python
assert result == expected
assert user.is_active is True
assert "email is required" in str(exc_info.value)
```

Use `pytest.raises` for expected exceptions and `pytest.approx` for floating point comparisons.

## TDD workflow for Python

1. Write failing pytest test first.
2. Run the narrow test command.
3. Confirm failure is caused by missing behavior, not syntax/import/setup errors.
4. Implement the smallest production change.
5. Re-run until narrow test passes.
6. Refactor while tests stay green.
7. Run broader verification.

Meaningful Red failures look like failed assertions or missing expected exceptions. Bad Red failures such as `ModuleNotFoundError`, `SyntaxError`, missing fixtures, or missing imports must be fixed before Green.

## Mocking rules

Mock boundaries, not the function under test.

Mock network APIs, databases for unit tests, filesystem when not the behavior under test, environment variables, time/randomness, subprocesses, email, queues, object storage, and third-party services.

Do not mock simple internal helpers, data transformations that should be asserted directly, or every call in a chain just because possible.

Prefer `monkeypatch` for environment variables, attributes, and path changes. Prefer `unittest.mock.patch` or `pytest-mock` when interaction assertions are needed.

## Verification checklist

Before reporting completion, verify:

- Targeted test passes.
- Relevant broader tests pass or skipped with reason.
- TDD Red failed for the right reason.
- Tests assert behavior, not implementation details.
- External dependencies are isolated.
- Temporary files use pytest fixtures such as `tmp_path`.
- Environment changes restore automatically.
- No debug `print`, `pdb`, `breakpoint`, `pytest.set_trace()`, placeholder assertion, or unexplained skip remains.

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
