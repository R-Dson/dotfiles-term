---
name: writing-plans
description: Creates TDD-first, atomic implementation plans for multi-step technical work before code changes begin. Use when the user provides requirements, specs, bugs, or feature requests that need structured implementation planning. Do not use for trivial one-step edits.
disable-model-invocation: false
---

# Writing plans

## Purpose

Create implementation plans that a skilled developer or agent can execute task by task without needing extra codebase context. Plans must be atomic, test-driven, verifiable, and safe to execute incrementally.

## When to use

Use this skill before touching code when the task involves:

- A new feature.
- A non-trivial bug fix.
- Refactoring across multiple files.
- API, schema, or state-management changes.
- Multiple implementation steps.
- Any request where execution order matters.

Do not use this skill for:

- Simple typo fixes.
- One-line configuration changes.
- Documentation-only edits.
- Small changes where the user explicitly asks to edit directly.

---

## Required reference

When reviewing a completed plan, load:

```text
plan-document-reviewer-prompt.md
````

Use it to dispatch or simulate a plan-review pass before implementation begins.

---

## Planning workflow

1. **Inspect**

   * Read the spec or user request.
   * Inspect relevant files, tests, package scripts, and existing patterns.
   * Confirm the package manager and test commands.
   * Check current Git state before planning file changes.

2. **Scope**

   * Define one testable goal.
   * Split the work if the request spans unrelated subsystems.
   * Keep each plan to 15 tasks or fewer.
   * If more tasks are required, split into phases or separate plans.

3. **Map files**

   * List files to create.
   * List files to modify.
   * List files to read for context.
   * Keep names, types, and functions consistent across all tasks.

4. **Write tasks**

   * Start with a baseline verification task.
   * Use a TDD loop for each implementation task.
   * Keep each task atomic, unambiguous, and verifiable.
   * Include exact commands and expected outcomes.

5. **Review**

   * Search for placeholders, vague steps, missing definitions, and unsupported references.
   * Verify that each task can be completed independently.
   * Ensure the final task performs end-to-end verification.

6. **Save**

   * Save the plan to:

```text
docs/superpowers/plans/YYYY-MM-DD-<feature-name>.md
```

7. **Handoff**

   * Offer implementation options:

     * Subagent-driven execution: one fresh worker per task.
     * Inline execution: execute tasks in the current session using the execution skill.

---

## Plan format

Use this structure for every plan.

````markdown
# <Feature name> implementation plan

> For agentic workers: implement this plan task by task. Complete one task, verify it, then move to the next.

**Goal:** <one-sentence outcome>
**Architecture:** <2-3 sentences describing approach, boundaries, and integration points>
**Tech stack:** <relevant libraries, frameworks, test tools, package manager>

---

## File map

### Create

- `<path>` — <single responsibility>

### Modify

- `<path>` — <what changes and why>

### Read for context

- `<path>` — <why it matters>

---

## Baseline verification

- [ ] Run existing relevant tests

  Command:

  ```bash
  <test command>
````

Expected result:

```text
<current passing result or known failure to preserve>
```

---

## Tasks

### Task 1: <short task title>

**Files:** `<path>`, `<path>`

* [ ] Write failing test

  ```<language>
  <exact test code>
  ```

* [ ] Verify failure

  ```bash
  <test command>
  ```

  Expected failure:

  ```text
  <specific failing assertion, error, or snapshot change>
  ```

* [ ] Implement minimal change

  ```<language>
  <exact or highly specific implementation>
  ```

* [ ] Verify pass

  ```bash
  <test command>
  ```

  Expected result:

  ```text
  <specific passing result>
  ```

* [ ] Commit

  ```bash
  git add <files>
  git commit -m "<type>(<scope>): <imperative summary>"
  ```

---

## End-to-end verification

* [ ] Run full relevant test suite

  ```bash
  <command>
  ```

* [ ] Run lint, typecheck, or build if available

  ```bash
  <command>
  ```

* [ ] Confirm final Git state

  ```bash
  git status --short
  ```

````

---

## Atomic task rules

Each task must be:

- **Atomic:** one logical change.
- **Unambiguous:** no major decisions left to the implementer.
- **Verifiable:** clear command and expected result.
- **Small:** intended to fit in one focused work session.
- **Green-preserving:** repository should return to passing state after the task.

A task fails review if it contains:

- `TBD`, `TODO`, `later`, or placeholder text.
- “Add appropriate error handling” without exact behavior.
- “Write tests” without actual test cases or test intent.
- References to functions, types, files, or commands not introduced or verified.
- Broad tasks that mix unrelated changes.
- Steps that require guessing project conventions.
- Commits without explicit staged files and a valid commit message.

---

## TDD task loop

Use this loop for implementation tasks:

1. Write or update the failing test.
2. Run the test and verify the expected failure.
3. Implement the smallest change that passes the test.
4. Run the test and verify the pass.
5. Commit the atomic change.

Use non-TDD tasks only for setup, inspection, mechanical file moves, generated files, or final verification. Mark those tasks clearly.

---

## Commit rules

Use Conventional Commits:

```text
<type>[optional scope]: <description>
````

Common types:

* `feat`
* `fix`
* `refactor`
* `test`
* `docs`
* `chore`
* `build`
* `ci`

Examples:

```text
feat(auth): add email validation
fix(api): reject invalid pagination cursor
test(ui): cover disabled submit state
refactor(config): isolate environment parsing
```

---

## Red-flag review

Before saving, check:

```bash
grep -RniE "TBD|TODO|later|appropriate|as needed|etc\\.|placeholder" docs/superpowers/plans/
```

Also verify:

* First task establishes current baseline.
* Last task performs end-to-end verification.
* Every created or modified file is listed in the file map.
* Task names match file, function, and test names used later.
* Test commands match the detected package manager.
* No task depends on hidden context.
* No implementation step silently skips validation.

---

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
1. Subagent-driven execution — implement one task per fresh worker.
2. Inline execution — implement tasks in this session using the execution skill.
```
