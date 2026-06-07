# Python pytest patterns

## Test levels

| Level | Use for | Notes |
|---|---|---|
| Unit | Pure logic, validation, parsing, small services | Fast, isolated, minimal mocking |
| Integration | Database, API route, service boundary | Use real collaborators when cheap and controlled |
| End-to-end | Critical user journey | Fewer tests, higher confidence, slower feedback |
| Regression | Known bug reproduction | Must fail before the fix and pass after |

---

## Parametrization

Use `pytest.mark.parametrize` when the same behavior should hold across multiple inputs.

```python
import pytest

@pytest.mark.parametrize(
    ("email", "expected"),
    [
        ("user@example.com", True),
        ("missing-at-symbol", False),
        ("", False),
    ],
)
def test_is_valid_email(email, expected):
    assert is_valid_email(email) is expected
````

Use readable case IDs for complex cases:

```python
@pytest.mark.parametrize(
    ("payload", "expected_status"),
    [
        pytest.param({"email": "user@example.com"}, 201, id="valid email"),
        pytest.param({"email": ""}, 400, id="empty email"),
    ],
)
def test_create_user_validation(client, payload, expected_status):
    response = client.post("/users", json=payload)

    assert response.status_code == expected_status
```

---

## Fixtures

Use fixtures for reusable setup, not for hiding important test behavior.

```python
import pytest

@pytest.fixture
def user_payload():
    return {"email": "user@example.com", "name": "Example User"}

def test_create_user(client, user_payload):
    response = client.post("/users", json=user_payload)

    assert response.status_code == 201
```

Keep fixtures:

* Small.
* Explicit.
* Named after the object or state they provide.
* Close to the tests unless shared broadly.
* In `conftest.py` only when shared across files.

---

## Fixture scopes

Use the narrowest practical scope.

| Scope      | Use when                                                     |
| ---------- | ------------------------------------------------------------ |
| `function` | Default; safest isolation                                    |
| `class`    | Shared setup for methods in one class                        |
| `module`   | Expensive setup shared in one file                           |
| `package`  | Expensive setup shared in one package                        |
| `session`  | Very expensive global setup, such as test database lifecycle |

Avoid session-scoped mutable objects unless they are reset between tests.

---

## Fixture cleanup

Use `yield` fixtures for setup and teardown.

```python
import pytest

@pytest.fixture
def temp_user(db):
    user = db.create_user(email="user@example.com")
    yield user
    db.delete_user(user.id)
```

Prefer built-in temporary path fixtures for filesystem tests.

```python
def test_write_report(tmp_path):
    report_path = tmp_path / "report.txt"

    write_report(report_path, "ok")

    assert report_path.read_text() == "ok"
```

---

## Environment variables

Use `monkeypatch` for environment changes.

```python
def test_reads_api_url(monkeypatch):
    monkeypatch.setenv("API_URL", "https://example.com")

    assert read_api_url() == "https://example.com"
```

Remove environment variables explicitly when testing missing config:

```python
def test_missing_api_url(monkeypatch):
    monkeypatch.delenv("API_URL", raising=False)

    with pytest.raises(ConfigError):
        read_api_url()
```

---

## Mocking with `unittest.mock`

Patch where the object is looked up by the code under test, not necessarily where it is originally defined.

```python
from unittest.mock import patch

def test_fetch_profile_returns_user():
    with patch("app.profile.http_client.get") as mock_get:
        mock_get.return_value.json.return_value = {"id": "user_123"}

        profile = fetch_profile("user_123")

    assert profile.id == "user_123"
    mock_get.assert_called_once_with("/users/user_123")
```

Use `side_effect` for exceptions or sequential results.

```python
from unittest.mock import patch

def test_fetch_profile_handles_timeout():
    with patch("app.profile.http_client.get") as mock_get:
        mock_get.side_effect = TimeoutError("request timed out")

        with pytest.raises(ProfileUnavailable):
            fetch_profile("user_123")
```

---

## Mocking with `pytest-mock`

If the project already uses `pytest-mock`, prefer the `mocker` fixture for concise patching.

```python
def test_fetch_profile_returns_user(mocker):
    mock_get = mocker.patch("app.profile.http_client.get")
    mock_get.return_value.json.return_value = {"id": "user_123"}

    profile = fetch_profile("user_123")

    assert profile.id == "user_123"
    mock_get.assert_called_once_with("/users/user_123")
```

Do not add `pytest-mock` as a new dependency unless it matches project conventions.

---

## Time and randomness

Avoid real time and randomness in tests.

```python
def test_token_expires_after_deadline(monkeypatch):
    monkeypatch.setattr("app.tokens.now", lambda: datetime(2026, 1, 1))

    assert is_token_expired(token) is True
```

For randomness, inject a seeded generator or patch the random source.

---

## Logging

Use `caplog` to assert logs when logs are part of behavior.

```python
import logging

def test_logs_failed_import(caplog):
    with caplog.at_level(logging.WARNING):
        import_users([])

    assert "no users to import" in caplog.text
```

Do not assert exact log formatting unless formatting is the behavior under test.

---

## stdout and stderr

Use `capsys` when printed output is part of behavior.

```python
def test_cli_prints_success(capsys):
    main(["--version"])

    captured = capsys.readouterr()
    assert "version" in captured.out.lower()
```

Do not rely on `print` debugging in committed tests.

---

## Warnings

Use `pytest.warns` for expected warnings.

```python
import pytest

def test_deprecated_option_warns():
    with pytest.warns(DeprecationWarning):
        parse_args(["--old-option"])
```

---

## Temporary files

Use `tmp_path` for modern `pathlib.Path`-based temp paths.

```python
def test_load_config(tmp_path):
    config = tmp_path / "config.toml"
    config.write_text("enabled = true")

    assert load_config(config).enabled is True
```

Use `tmp_path_factory` for expensive session-level temp data.

---

## Database tests

For database tests:

* Use transactions or isolated test databases.
* Reset state between tests.
* Avoid relying on test order.
* Use factories instead of large shared fixtures.
* Test constraints and rollback behavior when relevant.

---

## Async tests

If the project uses `pytest-asyncio` or another async plugin, follow its existing convention.

Example:

```python
import pytest

@pytest.mark.asyncio
async def test_fetch_user_returns_profile():
    profile = await fetch_user("user_123")

    assert profile.id == "user_123"
```

Do not introduce a new async test plugin without checking project conventions.

---

## Snapshot testing

Use snapshot testing sparingly.

Good for:

* Stable generated documents.
* Large structured outputs with intentional review flow.
* Serialization formats.

Avoid snapshots for:

* Highly dynamic output.
* Broad UI or object dumps.
* Behavior that should be asserted with specific fields.

When using snapshots, keep them reviewed, stable, and intentionally updated.

