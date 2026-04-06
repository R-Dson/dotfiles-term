---
name: maintainable-code
description: >
  Apply this skill when asked to write, review, refactor, or evaluate any code
  for quality, clarity, or maintainability. Triggers include: "review my code",
  "refactor this", "is this good practice", "how should I structure this",
  "write clean code for...", or any code generation task where maintainability
  is implied. Also apply proactively whenever you generate non-trivial code —
  these rules are defaults, not optional.
---

# Maintainable Code Skill

## Purpose

Produce code that the next reader can understand, modify, and trust — without needing to ask the original author. Apply every rule below when writing or reviewing code. When refactoring, apply them incrementally without breaking behavior.

---

## Core Rules (Apply Always)

### 1. Naming

- Every identifier must answer: *what is it, what does it do, why does it exist* — without a comment
- Use full words. No abbreviations unless they are universally understood in the domain (`url`, `id`, `http`)
- Single-letter names only in loop indices (`i`, `j`, `k`) or very short closures with obvious types
- One word per concept, used consistently everywhere. Never mix synonyms for the same thing (`fetch`/`get`/`retrieve` for the same operation)
- Boolean identifiers: prefix with `is`, `has`, `can`, `should`
- Constants: name for *purpose*, not *value* (`MAX_RETRY_COUNT = 3`, not `THREE = 3`)
- Encode units of measure in names when not captured by types: `timeoutMilliseconds`, `distanceMeters`
- Names must be honest: if a function has side effects, the name must reveal them
- Never create look-alike names differing only in case, one character, or an underscore

### 2. Function Design

- One function, one responsibility. If you cannot describe it in one sentence without "and", split it
- Target 5–20 lines per function. Exceed this only with justification
- If a function requires section-dividing comments, extract each section into a named function instead
- No hidden side effects in functions named as queries (`isValid`, `getUser` should not write to a database)
- Validate inputs at the top with guard clauses; fail fast with a clear error
- Handle every error path explicitly. Swallowing errors is never acceptable without a comment explaining why

### 3. No Duplication (DRY)

- Every fact, constant, and piece of logic exists in exactly one place
- Extract shared logic before the second use, not the third
- Magic numbers and magic strings become named constants at first use
- Do not force premature abstractions. Two similar pieces of code serving different purposes may legitimately stay separate until the pattern is stable

### 4. Comments

- Comments explain *why*, never *what* (the code explains what)
- A comment explaining what the code does is a signal to refactor the code, not to keep the comment
- Stale comments are bugs. Update or delete them when you change the code
- Never leave commented-out code. Delete it; version control preserves history
- Document every public interface: parameters (with units and constraints), return value, errors/exceptions raised, preconditions

### 5. Error Handling

- Every error path is intentional and explicit
- Use the language's idiomatic error type (typed exceptions, Result/Either types, error codes) — never `null` as a signal
- Log errors with context: what was attempted, what the inputs were, what the error was
- Never use exceptions for normal control flow
- Validate at system boundaries (API, UI, file parser), not deep inside business logic

### 6. No Magic Numbers or Strings

- Replace every literal number or string with a named constant or enumeration at its first use
- Group related constants into enumerations or namespaced objects
- If a constant appears in more than one file, it must be defined centrally

---

## Design Rules (Apply When Structuring Modules and Classes)

### 7. Single Responsibility

- Every module, class, and function has exactly one reason to change
- When a class is doing unrelated things, split it

### 8. Encapsulation

- Default to the most restrictive visibility available; widen only when there is an explicit external need
- Never expose internal state directly through public fields
- Design interfaces from the caller's perspective, not the implementer's

### 9. Prefer Composition Over Deep Inheritance

- Limit inheritance to 2–3 levels. Deeper hierarchies almost always indicate a design problem
- Use interfaces, protocols, or traits to share behavior without creating inheritance dependencies
- Avoid God classes. A class that knows everything about the system is a single point of fragility

### 10. Dependency Direction

- High-level modules (business logic) depend on abstractions, not on concrete low-level implementations
- Low-level modules (infrastructure, I/O, external services) implement the abstractions defined by high-level modules
- This makes the core logic testable without real infrastructure

---

## Testing Rules (Apply When Writing or Reviewing Tests)

### 11. Test Coverage

- New code is accompanied by tests at the appropriate level (unit, integration, end-to-end)
- Test the happy path, the error paths, and the boundary conditions
- A function that is hard to test is probably poorly designed — redesign before adding workarounds

### 12. Test Quality

- Every test asserts a specific, meaningful behavior — not just that a line was executed
- Tests must be deterministic. A test that sometimes fails is worse than no test; it trains developers to ignore failures
- Do not write tests to hit a coverage number. Empty assertions are noise

### 13. Test Structure

- Follow Arrange / Act / Assert (or Given / When / Then) within every test
- One behavior per test. If a test needs a long name joined by "and", split it
- Tests should not share mutable state; each test sets up its own preconditions

---

## Process Rules (Apply at Commit and Review Time)

### 14. Commit Discipline

- Each commit is one logical change. Do not mix refactoring with behavior changes in the same commit
- Commit messages: `type: imperative summary` followed by a body explaining *why*
- Reference issue tracker tickets in the message body

### 15. No Warnings

- Code passes the project linter with zero warnings
- Code is formatted by the project formatter
- Compiler or interpreter warnings are treated as errors in CI

### 16. Secrets

- No secrets (API keys, passwords, tokens, certificates) in code or commit history, ever
- All sensitive configuration is injected via environment variables or a secrets manager

### 17. Dependencies

- Dependencies are pinned to specific versions
- Dependencies are scanned for known vulnerabilities in CI
- Standard library functions are used before rolling custom implementations

---

## Refactoring Rules (Apply When Improving Existing Code)

### 18. Boy Scout Rule

- Every time you touch a file, leave it slightly cleaner than you found it
- Rename an unclear variable, extract a complex condition, delete a stale comment — small improvements compound

### 19. Safe Refactoring Sequence

1. Confirm the code under refactoring is covered by tests
2. Make the structural change
3. Verify all tests pass
4. Commit — separate from any behavior change

### 20. Delete Dead Code

- Unused functions, unreachable branches, commented-out blocks, and orphaned modules are deleted without hesitation
- Version control preserves history. Dead code left in place is misleading noise

### 21. Recognize Code Smells and Act

| Smell | Action |
|---|---|
| Function >50 lines | Extract by responsibility |
| Class >500 lines | Apply Single Responsibility |
| Parameter list >4 items | Introduce a parameter object |
| Duplicate logic | Extract to shared function |
| Deep nesting >3 levels | Extract functions; invert conditions |
| Comment explaining *what* | Refactor until the code is self-documenting |
| Magic number or string | Replace with named constant |
| Primitive used for domain concept | Introduce a domain type |

---

## Architecture Rules (Apply When Designing Systems)

### 22. Clear Boundaries

- Every system has identifiable modules with explicit responsibilities and explicit interfaces between them
- Each module depends only on modules at the same or lower level of abstraction
- Circular dependencies are not permitted

### 23. Document Decisions

- Every significant architectural decision is recorded in an Architecture Decision Record (ADR)
- An ADR captures: context, decision, alternatives considered, and consequences
- ADRs live in the repository alongside the code they describe

### 24. Observability

- All significant operations are logged with structured, machine-parseable output
- Key operations are instrumented with metrics
- Errors are surfaced through alerts before users report them

---

## What to Avoid (Anti-Patterns from Green's Guide — Inverted)

| Green's Anti-Pattern | Correct Practice |
|---|---|
| Single-letter variables | Intention-revealing names |
| Creative misspellings | Correct, consistent spelling |
| Thesaurus synonyms for same concept | One word per concept |
| Lie in comments | Accurate comments, or no comment |
| Document the obvious; hide the important | Document *why*; make *what* self-evident in code |
| Specify facts in as many places as possible | Every fact in exactly one place (DRY) |
| Never validate inputs | Validate at every trust boundary |
| Avoid assertions | Assert preconditions; fail fast |
| Never test | Comprehensive, meaningful tests |
| Suppress compiler warnings | Zero warnings; warnings are errors in CI |
| Use global variables everywhere | Pass state explicitly; avoid globals |
| Reinvent standard library functions | Use the standard library |
| Mix refactoring with behavior changes | Separate commits for each |
| Keep secrets from colleagues | Communicate known problems immediately |
| Deep inheritance hierarchies | Composition; interfaces; 2–3 level limit |
| God classes that do everything | Small, focused classes with one responsibility |
| Magic numbers | Named constants |
| Commented-out code | Delete it; trust version control |
| Make builds undocumented and fragile | Reproducible, documented, CI-verified builds |

---

## Checklist (Use at Review Time)

**Naming**
- [ ] Every identifier reveals intent without a comment
- [ ] Consistent with project conventions and glossary
- [ ] Units encoded in names or types
- [ ] Boolean identifiers use is/has/can/should prefix

**Structure**
- [ ] Each function has one responsibility
- [ ] No function is unreasonably long
- [ ] No duplicated logic
- [ ] All magic numbers replaced by named constants
- [ ] All inputs validated at entry points
- [ ] All error paths handled explicitly

**Documentation**
- [ ] Comments explain *why*, not *what*
- [ ] All public interfaces documented
- [ ] No stale comments
- [ ] No commented-out code

**Testing**
- [ ] New behavior is covered by tests
- [ ] Error and edge cases tested
- [ ] All tests pass and are deterministic
- [ ] No tests exist solely for coverage metrics

**Process**
- [ ] Zero linter warnings
- [ ] Code is formatted
- [ ] Commit message explains what and why
- [ ] No secrets in code or history
- [ ] Dependencies pinned and scanned
