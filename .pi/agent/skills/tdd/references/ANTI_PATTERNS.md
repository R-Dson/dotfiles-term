# Testing Anti-Patterns (The "Don'ts")

Avoid these to prevent brittle, useless, or misleading test suites:

- **The Inspector**: Asserting on private state or local variables. If you change the internal variable name, the test shouldn't break as long as the output stays the same.
- **The Mock-Everything**: Mocking internal logic or helpers. Only mock external boundaries (APIs, Database, Clock).
- **The Local Hero**: Using hardcoded `/Users/name/path` or env-specific values. Tests must be portable.
- **The Flake**: Using `Math.random()` or `Date.now()` without a fixed seed or a mocked clock.
- **The Liar**: Writing a test that passes even if the logic is broken (e.g., catching errors but not asserting on them).
- **The Giant**: One test function that tests 10 different things. Split them for clearer failure messages.
- **Test-Only Exports**: Adding `export const _private = ...` just for tests. Use standard public APIs.
