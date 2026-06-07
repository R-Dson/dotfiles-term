---
name: code-quality
description: Applies maintainability standards when writing, reviewing, refactoring, or evaluating code. Use for code generation, code review, refactoring, architecture cleanup, test quality checks, or questions like "is this good practice?" Apply proactively for non-trivial code.
disable-model-invocation: false
---

# Code quality

## Purpose

Produce code future maintainers can understand, modify, test, and trust. Prefer clear, boring, idiomatic code over cleverness. Improve incrementally without changing behavior unless requested.

## When to use

Use when asked to write non-trivial code, review quality, refactor, evaluate maintainability, improve structure/naming/tests/error handling, or decide whether code is clean enough to ship.

Do not use as the primary guide for security audits, performance benchmarking, API docs, commit messages, or architecture planning beyond local code structure.

## Operating workflow

1. **Understand intent** — identify required behavior, nearby conventions, tests, types, and error patterns.
2. **Design for change** — keep responsibilities small, boundaries explicit, and abstractions justified.
3. **Implement clearly** — use intention-revealing names, focused functions, explicit validation, and visible side effects.
4. **Verify** — add/update meaningful tests and run relevant checks when available.
5. **Report** — summarize improvements, verification, tradeoffs, and follow-up risks.

## Core rules

### Naming

- Names reveal purpose without comments.
- Use consistent terms for one concept.
- Use full words unless abbreviation is standard (`id`, `url`, `http`, `api`).
- Boolean names usually start with `is`, `has`, `can`, `should`, or `supports`.
- Include units when type does not express them, such as `timeoutMilliseconds`.
- Function names reveal side effects; query-like names should not write state.

### Functions and structure

- One function = one responsibility at one abstraction level.
- Prefer guard clauses over deep nesting.
- Keep parameter lists short; use options/domain objects when needed.
- Keep side effects explicit and close to system boundaries.
- Separate business logic from I/O, framework, persistence, and external services when practical.
- Avoid circular dependencies, god modules, and global mutable state unless architecture requires them.

### Duplication and abstraction

- Remove duplication when it represents the same rule, constant, or behavior.
- Do not abstract code that only looks similar but serves different purposes.
- Replace unclear magic values with named constants.
- Prefer composition/interfaces/protocols over deep inheritance.
- Use domain types for important concepts and make invalid states hard to represent when the language allows it.

### Comments and docs

- Comments explain why, not what.
- Confusing-code comments are refactoring signals.
- Delete commented-out code.
- Update or remove stale comments when changing behavior.
- Public interfaces should document constraints, units, errors, and non-obvious behavior when types do not.

### Errors and sensitive data

- Validate input at trust boundaries: APIs, forms, parsers, CLIs, queues, and integrations.
- Use the project’s idiomatic error pattern.
- Include enough log context to debug without exposing secrets.
- Do not swallow errors silently or use exceptions for normal control flow.
- Never hardcode or log secrets, tokens, passwords, private keys, cookies, or sensitive personal data.

## Testing rules

- New behavior should have appropriate tests: unit, integration, component, or end-to-end.
- Cover happy paths, important error paths, and boundary conditions.
- Tests should be deterministic, isolated, behavior-focused, and meaningful.
- Avoid implementation-detail assertions and coverage-only tests.
- A hard-to-test function may indicate a design problem.

## Refactoring rules

Refactoring means changing structure without changing observable behavior.

Safe sequence:

1. Confirm current behavior with existing or added tests.
2. Make one structural change.
3. Run relevant verification.
4. Keep behavior changes separate from refactors where practical.

Good targets: unclear names, complex conditions, long functions, dead code, duplicated logic, primitive obsession, and side effects mixed with core logic.

Do not mix large refactors with feature changes unless requested and risk is explained.

## Dependency rules

- Prefer standard library or existing utilities.
- Add a dependency only when it materially reduces complexity or risk.
- Use lockfile-managed versions according to the project package manager.
- Avoid unclear maintenance, licensing, or security posture.
- Do not add a dependency for a small standard-library function.

## Review checklist

Before finishing non-trivial code, verify:

- Names, units, boolean naming, and side effects are clear.
- Functions are focused and nesting is readable.
- Boundaries between domain logic and infrastructure are clear.
- Inputs are validated and error paths are explicit.
- Logs contain useful context without secrets.
- Tests cover changed behavior and important edges.
- No accidental behavior change during refactor.
- Duplication, magic values, dead code, and dependencies are intentional.
- Formatter, linter, typecheck, build, or tests pass when available.

## Output contract

When writing or refactoring code:

```text
Changed:
- <files or areas changed>

Why:
- <maintainability reason>

Verified:
- <tests, lint, typecheck, build, or inspection performed>

Notes:
- <tradeoffs, assumptions, or follow-up risks>
```

When reviewing code:

```text
Findings:
- <location>: <issue> — <impact> → <specific fix>

Verdict:
- <ship / ship after fixes / do not ship>
```

Do not report formatter issues, speculative concerns, style preferences, or unrelated rewrites.
