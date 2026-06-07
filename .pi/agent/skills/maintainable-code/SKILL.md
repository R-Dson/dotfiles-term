---
name: maintainable-code
description: Applies maintainability standards when writing, reviewing, refactoring, or evaluating code. Use for code generation, code review, refactoring, architecture cleanup, test quality checks, or questions like "is this good practice?" Apply proactively for non-trivial code.
disable-model-invocation: false
---

# Maintainable code

## Purpose

Produce code that future maintainers can understand, modify, test, and trust. Prefer clear, boring, idiomatic code over cleverness. Improve code incrementally without changing behavior unless the task explicitly requires a behavior change.

## When to use

Use this skill when asked to:

- Write non-trivial code.
- Review code quality.
- Refactor existing code.
- Evaluate maintainability.
- Improve structure, naming, tests, or error handling.
- Decide whether code is clean enough to ship.

Do not use this skill as the primary guide for:

- Security-specific audits.
- Performance benchmarking.
- API documentation.
- Commit message formatting.
- Architecture planning beyond local code structure.

---

## Operating workflow

1. **Understand intent**
   - Identify the behavior the code must provide.
   - Read nearby code to match project conventions.
   - Check existing tests, types, and error-handling patterns.

2. **Design for change**
   - Keep responsibilities small.
   - Keep boundaries explicit.
   - Prefer simple composition over inheritance or hidden coupling.
   - Avoid abstractions until the pattern is real.

3. **Implement clearly**
   - Use intention-revealing names.
   - Keep functions focused.
   - Validate at trust boundaries.
   - Handle error paths explicitly.
   - Remove duplication when it represents the same concept.

4. **Verify**
   - Add or update meaningful tests.
   - Run relevant test, lint, typecheck, or build commands when available.
   - Confirm no secrets, dead code, or accidental behavior changes were introduced.

5. **Report**
   - Summarize maintainability improvements.
   - Mention verification performed.
   - Call out any tradeoffs or follow-up risks.

---

## Core rules

### Naming

- Names must reveal purpose without requiring a comment.
- Use full words unless the abbreviation is standard in the domain, such as `id`, `url`, `http`, or `api`.
- Use one term consistently for one concept.
- Boolean names should usually start with `is`, `has`, `can`, `should`, or `supports`.
- Include units in names when the type does not express them, such as `timeoutMilliseconds`.
- Function names must reveal side effects. A query-like name such as `getUser` or `isValid` should not write state.
- Avoid look-alike names that differ only by case, one character, or an underscore.

### Functions

- A function should do one thing at one level of abstraction.
- If a function needs section comments, extract named helper functions instead.
- Prefer guard clauses over deep nesting.
- Keep parameter lists short; introduce an options object or domain type when parameters become hard to read.
- Keep side effects explicit and close to the boundary where they occur.
- Do not swallow errors silently.

### Duplication

- Remove duplication when two pieces of code represent the same business rule, constant, or behavior.
- Do not create premature abstractions for code that only looks similar but serves different purposes.
- Extract shared concepts once the naming and behavior are stable.
- Replace unclear magic values with named constants.
- Keep shared constants in one central place when used across files.

### Comments and documentation

- Comments should explain why, not restate what the code does.
- A comment that explains confusing code is often a refactoring signal.
- Delete commented-out code.
- Update or remove stale comments when changing behavior.
- Public interfaces should document constraints, units, errors, and non-obvious behavior when the type system does not make them clear.

### Error handling

- Validate input at system boundaries: API handlers, UI forms, file parsers, CLI inputs, queues, and external integrations.
- Use the project’s idiomatic error pattern: exceptions, result types, error codes, or typed failures.
- Include enough context in logs to debug the failure without exposing secrets.
- Do not use exceptions for normal control flow.
- Do not return `null` or `undefined` as an error signal unless that is the established project convention and the caller handles it explicitly.

### Secrets and sensitive data

- Never hardcode API keys, tokens, passwords, certificates, private keys, or production credentials.
- Do not log secrets, session cookies, authorization headers, or sensitive personal data.
- Use the project’s approved configuration or secrets-management mechanism.
- Treat accidental secret exposure as a blocking issue.

---

## Design rules

### Responsibility and boundaries

- Each module, class, and function should have one clear reason to change.
- Keep business logic separate from I/O, framework code, persistence, and external services when practical.
- High-level logic should depend on interfaces or abstractions, not concrete infrastructure.
- Avoid circular dependencies.
- Keep public APIs small and intentional.

### Composition

- Prefer composition, interfaces, protocols, or small collaborators over deep inheritance.
- Avoid god classes and catch-all utility modules.
- Avoid global mutable state unless the project architecture explicitly requires it.

### Data modeling

- Use domain types for important concepts instead of unstructured primitives.
- Avoid passing unrelated primitive values together when an object or type would make the contract clearer.
- Make invalid states hard to represent when the language allows it.

---

## Testing rules

### Coverage

- New behavior should include tests at the appropriate level: unit, integration, or end-to-end.
- Cover happy paths, important error paths, and boundary conditions.
- A hard-to-test function may be a design smell.

### Quality

- Tests should assert meaningful behavior, not implementation details.
- Tests must be deterministic and isolated.
- Avoid tests that exist only to raise coverage numbers.
- Use Arrange / Act / Assert or Given / When / Then where it improves clarity.
- Keep one behavior per test when practical.

---

## Refactoring rules

Refactoring means changing internal structure without changing observable behavior.

Use this safe sequence:

1. Confirm current behavior with existing or added tests.
2. Make one structural change.
3. Run relevant verification.
4. Keep behavior changes separate from refactoring changes.

Good refactoring targets:

- Rename unclear identifiers.
- Extract complex conditions.
- Split long functions.
- Remove dead code.
- Replace duplicated logic with a shared function or type.
- Replace primitive obsession with a domain type.
- Isolate side effects from core logic.

Do not mix large refactors with feature changes unless the user explicitly asks and the risk is explained.

---

## Code smells and responses

| Smell | Response |
|---|---|
| Long function | Extract helpers by responsibility |
| Large class or module | Split by reason to change |
| Long parameter list | Introduce options object or domain type |
| Duplicate business logic | Extract shared rule |
| Deep nesting | Use guard clauses or extracted functions |
| Comment explains what | Rename or refactor |
| Magic value | Introduce named constant when meaning is not obvious |
| Primitive used for domain concept | Introduce domain type |
| Dead code | Delete it |
| Global mutable state | Pass state explicitly or isolate it |
| Hidden side effect | Rename or move side effect to boundary |
| Flaky test | Remove nondeterminism or isolate dependencies |

---

## Dependency rules

- Prefer standard library or existing project utilities before adding dependencies.
- Add a dependency only when it materially reduces complexity or risk.
- Use pinned or lockfile-managed versions according to the project’s package manager.
- Avoid dependencies with unclear maintenance, licensing, or security posture.
- Do not introduce a dependency for a small function the standard library already provides.

---

## Review checklist

Use this checklist when reviewing or finishing non-trivial code.

### Naming

- [ ] Names reveal intent.
- [ ] Terms are consistent across the codebase.
- [ ] Units are encoded in names or types.
- [ ] Boolean names read naturally.
- [ ] Side effects are visible from names.

### Structure

- [ ] Functions have one responsibility.
- [ ] Nesting is shallow enough to read.
- [ ] Boundaries between business logic and infrastructure are clear.
- [ ] No unnecessary abstraction was introduced.
- [ ] No circular dependency was introduced.

### Correctness and errors

- [ ] Inputs are validated at trust boundaries.
- [ ] Error paths are explicit.
- [ ] Logs include useful context without secrets.
- [ ] No behavior changed accidentally during refactoring.

### Tests

- [ ] New or changed behavior is covered.
- [ ] Error and boundary cases are covered where relevant.
- [ ] Tests are deterministic.
- [ ] Tests assert behavior, not incidental implementation.

### Maintenance

- [ ] Duplication is intentional or removed.
- [ ] Magic values are named when meaning is not obvious.
- [ ] Dead or commented-out code is removed.
- [ ] Public interfaces document non-obvious constraints.
- [ ] Dependencies are justified.

### Process

- [ ] Formatter, linter, typecheck, build, or tests pass when available.
- [ ] Refactoring and behavior changes are kept separate where practical.
- [ ] No secrets or sensitive data are present.

---

## Output contract

When writing or refactoring code, report:

```text
Changed:
- <files or areas changed>

Why:
- <maintainability reason>

Verified:
- <tests, lint, typecheck, build, or inspection performed>

Notes:
- <tradeoffs, assumptions, or follow-up risks>
````

When reviewing code, report only actionable findings:

```text
Findings:
- <location>: <issue> — <impact> → <specific fix>

Looks good:
- <specific strengths, if useful>

Verdict:
- <ship / ship after fixes / do not ship>
```

Do not report style preferences, formatter issues, speculative concerns, or rewrites that are unrelated to the requested change.
