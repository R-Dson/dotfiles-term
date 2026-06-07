---
name: planning
description: Creates TDD-first, atomic implementation plans for multi-step technical work before code changes begin. Use when the user provides requirements, specs, bugs, or feature requests that need structured implementation planning. Do not use for trivial one-step edits.
disable-model-invocation: false
---

# Planning

## Purpose

Create implementation plans that a skilled developer or agent can execute task by task without extra codebase context. Plans must be atomic, test-driven, verifiable, and safe to execute incrementally.

## When to use

Use this skill before touching code when the task involves:

- A new feature.
- A non-trivial bug fix.
- Refactoring across multiple files.
- API, schema, state-management, or integration changes.
- Multiple implementation steps or order-dependent work.

Do not use for simple typo fixes, one-line config changes, documentation-only edits, or small changes where the user explicitly asks to edit directly.

## Required references

When reviewing a completed plan, load:

```text
plan-document-reviewer-prompt.md
```

For the full plan skeleton, load:

```text
assets/implementation-plan-template.md
```

## Planning workflow

1. **Inspect**
   - Read the user request or spec.
   - Inspect relevant files, tests, package scripts, and existing patterns.
   - Confirm package manager, test commands, and current Git state.
   - Ask one clarifying question before planning if ambiguity affects architecture, external contracts, data shape, or irreversible work.

2. **Scope**
   - Define one testable goal.
   - Split unrelated subsystems into separate plans.
   - Keep each plan to 15 tasks or fewer; otherwise split into phases.

3. **Map files**
   - List files to create, modify, and read for context.
   - Keep names, types, and functions consistent across all tasks.

4. **Write tasks**
   - Start with baseline verification.
   - Use a TDD loop for implementation tasks.
   - Include exact commands and expected outcomes.
   - End with end-to-end verification.

5. **Review**
   - Check for placeholders, vague steps, missing definitions, and unsupported references.
   - Verify each task can be completed independently.
   - Run or simulate the plan-review pass with `plan-document-reviewer-prompt.md`.

6. **Save and hand off**
   - Save to `docs/superpowers/plans/YYYY-MM-DD-<feature-name>.md`.
   - Offer subagent-driven or inline execution.

## Plan requirements

Every plan must include:

- Goal, architecture, and tech stack.
- File map: create, modify, read for context.
- Baseline verification.
- Atomic tasks with test, implementation, verification, and commit steps.
- End-to-end verification.
- Explicit commands and expected results.

Each task must be:

- **Atomic:** one logical change.
- **Unambiguous:** no major decisions left to the implementer.
- **Verifiable:** clear command and expected result.
- **Small:** intended to fit in one focused work session.
- **Green-preserving:** repo should return to passing state after the task.

A task fails review if it contains:

- `TBD`, `TODO`, `later`, placeholder text, or vague words like `appropriate`, `as needed`, or `etc.`.
- “Write tests” without exact test intent or cases.
- References to files, functions, types, or commands not introduced or verified.
- Broad steps that mix unrelated changes.
- Commits without explicit staged files and valid Conventional Commit messages.

## TDD task loop

Use this loop for implementation tasks:

1. Write or update the failing test.
2. Run the test and verify expected failure.
3. Implement the smallest change that passes.
4. Run the test and verify pass.
5. Commit the atomic change.

Use non-TDD tasks only for setup, inspection, mechanical file moves, generated files, or final verification. Mark those tasks clearly.

## Commit rules

Use Conventional Commits:

```text
<type>[optional scope]: <description>
```

Common types: `feat`, `fix`, `refactor`, `test`, `docs`, `chore`, `build`, `ci`.

## Red-flag review

Before saving, check the plan for vague placeholders:

```bash
grep -RniE "TBD|TODO|later|appropriate|as needed|etc\\.|placeholder" docs/superpowers/plans/
```

Also verify:

- First task establishes current baseline.
- Last task performs end-to-end verification.
- Every created or modified file is listed in the file map.
- Task names match file, function, and test names used later.
- Test commands match the detected package manager.
- No task depends on hidden context.
- No implementation step skips validation.

## Output contract

After saving the plan, report:

```text
Plan saved:
- <plan path>

Scope:
- <one-sentence summary>

Validation:
- <review checks performed>

Next options:
1. Subagent-driven execution — one fresh worker per task.
2. Inline execution — implement tasks in this session.
```
