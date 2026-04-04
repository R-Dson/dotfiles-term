# Troubleshooting Pytest

## ModuleNotFoundError
If pytest cannot find your source code, ensure there is an `__init__.py` in your folders or run via:
`python -m pytest`

## Fixture Not Found
Ensure fixtures are defined in the same file or in a `conftest.py` file within the same directory tree.

## Swallowing Output
If you need to see `stdout` during a successful test for debugging, run with the `-s` flag:
`pytest -s`
