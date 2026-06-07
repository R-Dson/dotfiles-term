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
  ```

  Expected result:

  ```text
  <current passing result or known failure to preserve>
  ```

---

## Tasks

### Task 1: <short task title>

**Files:** `<path>`, `<path>`

- [ ] Write failing test

  ```<language>
  <exact test code or exact behavior to assert>
  ```

- [ ] Verify failure

  ```bash
  <test command>
  ```

  Expected failure:

  ```text
  <specific failing assertion, error, or snapshot change>
  ```

- [ ] Implement minimal change

  ```<language>
  <exact or highly specific implementation>
  ```

- [ ] Verify pass

  ```bash
  <test command>
  ```

  Expected result:

  ```text
  <specific passing result>
  ```

- [ ] Commit

  ```bash
  git add <files>
  git commit -m "<type>(<scope>): <imperative summary>"
  ```

---

## End-to-end verification

- [ ] Run full relevant test suite

  ```bash
  <command>
  ```

- [ ] Run lint, typecheck, or build if available

  ```bash
  <command>
  ```

- [ ] Confirm final Git state

  ```bash
  git status --short
  ```
