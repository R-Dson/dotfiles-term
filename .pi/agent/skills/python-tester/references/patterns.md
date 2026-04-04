# Advanced Python Testing Patterns

## Mocking External Dependencies
Always prefer `patch` as a decorator or context manager to keep tests clean.

```python
from unittest.mock import patch

@patch('module.ClassName.method_name')
def test_external_call(mock_method):
    mock_method.return_value = {"status": "success"}
    # ... execution and assertion
```

## Snapshot Testing (Dagster Pattern)
For complex dictionary or JSON outputs, use snapshot testing to prevent brittle assertions.

## Handling Side Effects
Use `.side_effect` to simulate exceptions:
```python
mock_obj.side_effect = Exception("Connection Timeout")
```

## Pytest Fixture Scopes
- `function`: Default, setup/teardown every test.
- `module`: Setup/teardown once per file.
- `session`: Setup once for the entire test run (useful for DB migrations).
