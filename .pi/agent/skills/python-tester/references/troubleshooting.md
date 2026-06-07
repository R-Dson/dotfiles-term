# Troubleshooting pytest

## Start with the first meaningful failure

Run a focused command:

```bash
python -m pytest tests/test_example.py::test_case -q
````

Then inspect:

* Failure message.
* Traceback location.
* Captured stdout/stderr.
* Fixture setup errors.
* Import errors before assertions.

Do not fix later failures until the first root cause is understood.

---

## `ModuleNotFoundError`

Symptoms:

```text
ModuleNotFoundError: No module named 'app'
```

Likely causes:

* Package not installed in editable mode.
* Running pytest with a different Python interpreter.
* Incorrect `src/` layout configuration.
* Missing project configuration.
* Running tests from the wrong directory.

Try:

```bash
python -m pytest
python -c "import sys; print(sys.executable); print(sys.path)"
python -m pip install -e .
```

Do not add random `sys.path.append(...)` in tests unless the project already uses that pattern.

---

## `fixture 'x' not found`

Symptoms:

```text
fixture 'client' not found
```

Check:

* Fixture name spelling.
* Fixture defined in same file or reachable `conftest.py`.
* `conftest.py` is under the correct directory tree.
* Plugin providing the fixture is installed and configured.
* Test file is collected by pytest.

Useful command:

```bash
python -m pytest --fixtures -q
```

---

## Test not collected

Check:

* File name matches `test_*.py` or `*_test.py`, unless configured otherwise.
* Test function starts with `test_`.
* Test class name starts with `Test`.
* Test class has no custom `__init__`.
* The path is included by pytest config.

Command:

```bash
python -m pytest --collect-only -q
```

---

## Assertion fails

Ask:

* Is the expected value correct?
* Did setup create the intended state?
* Is the assertion checking behavior or implementation?
* Is the failure caused by order, time, randomness, or shared state?
* Did the production behavior change intentionally?

Use pytest’s assertion diff before adding debug output.

---

## Mock does not apply

Likely cause: patching the wrong import path.

Patch where the code under test looks up the object.

If code does:

```python
from app.client import get
```

Patch:

```python
patch("app.service.get")
```

not:

```python
patch("app.client.get")
```

Also check:

* Patch lifetime ended too early.
* Fixture returned instead of yielded while patch context closed.
* Async function requires `AsyncMock`.
* The code cached a reference before patching.

---

## Mock leaks between tests

Use context managers, decorators, `mocker`, or `yield` fixtures so cleanup happens automatically.

Avoid module-level patches.

Good:

```python
@pytest.fixture
def mock_get():
    with patch("app.service.get") as mocked:
        yield mocked
```

---

## Flaky tests

Common causes:

* Real time.
* Randomness.
* Network calls.
* Shared mutable state.
* Test order dependency.
* Async race.
* Sleep-based waits.
* Filesystem collisions.
* Database state leakage.

Fix by:

* Mocking or injecting time.
* Seeding randomness.
* Isolating state per test.
* Using `tmp_path`.
* Awaiting deterministic signals.
* Resetting database state.
* Removing dependency on test order.

---

## Seeing stdout

Prefer assertions over print debugging. If needed temporarily:

```bash
python -m pytest -s
```

Remove debug output before finalizing.

---

## Dropping into debugger

For local debugging:

```bash
python -m pytest --pdb
```

or place temporarily:

```python
breakpoint()
```

Remove breakpoints before completion.

---

## Slow tests

Find slow tests with:

```bash
python -m pytest --durations=20
```

Improve by:

* Reducing fixture scope only when safe.
* Replacing real network calls.
* Using factories instead of expensive shared setup.
* Moving broad integration tests out of unit-test paths.
* Avoiding sleeps.

---

## Skipped or xfailed tests

A skip or xfail must have a clear reason.

Good:

```python
@pytest.mark.skip(reason="requires external Oracle test database")
```

Bad:

```python
@pytest.mark.skip
```

Do not introduce skips to hide failures unless the user explicitly accepts the risk.

---

## Coverage issues

If the project uses coverage, run the configured command.

Common commands:

```bash
python -m pytest --cov
python -m pytest --cov=src --cov-report=term-missing
```

Coverage is a signal, not a goal by itself. Prefer meaningful behavior coverage over line coverage.

