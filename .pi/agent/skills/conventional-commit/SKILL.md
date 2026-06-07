---
name: conventional-commit
description: Creates clear Conventional Commit messages from staged or intended Git changes. Use when writing commit messages, preparing atomic commits, formatting Git history, splitting changes into commits, or validating commit-message quality.
license: MIT
metadata:
  version: "1.1.0"
---

# Conventional commit

## Purpose

Create commit messages that are accurate, atomic, reviewable, and compatible with the Conventional Commits specification.

Use this skill to describe what changed and why, not to perform broad Git safety checks. For destructive Git operations, branch management, resets, or pushes, use the Git safety skill.

## When to use

Use this skill when:

- Writing a commit message.
- Reviewing a proposed commit message.
- Splitting staged or unstaged changes into atomic commits.
- Choosing a commit type or scope.
- Writing breaking-change footers.
- Formatting revert commits.
- Preparing history for review.

Do not use this skill for:

- General shell safety.
- Branch cleanup.
- Rebasing strategy.
- Release-note writing beyond commit-message scope.
- PR description writing unless the user asks for commit-derived text.

---

## Workflow

1. **Inspect the change**
   - Review staged changes first.
   - If nothing is staged, review the intended diff before proposing commits.
   - Identify whether the change is one logical unit or multiple unrelated changes.

2. **Choose atomic commit boundaries**
   - One commit should represent one logical change.
   - Split unrelated behavior, refactoring, tests, and docs when practical.
   - Do not mix behavior changes with pure refactors unless the refactor is required for the behavior change.

3. **Select type and scope**
   - Pick the type from the actual change, not from the file location alone.
   - Use a scope when it clarifies the affected area.
   - Omit the scope when it adds no value.

4. **Write the message**
   - Use a concise imperative subject.
   - Add a body when motivation, tradeoffs, or previous behavior matter.
   - Add footers for issues, breaking changes, or metadata.

5. **Validate**
   - Confirm the message matches the diff.
   - Confirm the subject is specific and not generic.
   - Confirm breaking changes are explicitly marked.

---

## Inspect before writing

Use these commands when available:

```bash
git status --short
git diff --staged
git diff --staged --name-only
````

If no files are staged:

```bash
git diff
git diff --name-only
```

Do not invent details that are not visible in the diff or provided by the user.

---

## Format

Use this structure:

```text
<type>[optional scope][!]: <description>

[optional body]

[optional footer(s)]
```

Examples:

```text
fix(api): handle null user response
feat(alerts): add Slack thread replies
refactor(auth): extract token validation
docs(readme): clarify installation steps
```

The header is required. Body and footers are optional.

---

## Types

Use these common types:

| Type       | Use when                                         |
| ---------- | ------------------------------------------------ |
| `feat`     | Adds user-facing or API-facing functionality     |
| `fix`      | Fixes a bug                                      |
| `docs`     | Changes documentation only                       |
| `style`    | Changes formatting without behavior change       |
| `refactor` | Restructures code without behavior change        |
| `perf`     | Improves performance                             |
| `test`     | Adds or updates tests                            |
| `build`    | Changes build system, packaging, or dependencies |
| `ci`       | Changes CI configuration                         |
| `chore`    | Performs maintenance not covered by another type |
| `revert`   | Reverts a previous commit                        |

Project-specific types such as `deps` are allowed only if the repository already uses them. Otherwise prefer `build` or `chore` for dependency updates.

---

## Scope rules

Use a scope when it helps readers locate the change.

Good scopes:

```text
auth
api
ui
billing
docs
deps
config
parser
```

Avoid scopes that are too broad or redundant:

```text
app
code
misc
changes
src
```

Examples:

```text
fix(auth): reject expired refresh tokens
feat(billing): add invoice export
test(parser): cover escaped delimiter handling
```

---

## Subject rules

The subject must:

* Use imperative mood.
* Be specific.
* Be lowercase after the colon unless the project convention differs.
* Avoid a trailing period.
* Prefer 50 characters or fewer.
* Stay under 70 characters unless clarity requires more.

Good:

```text
fix(api): return 404 for missing users
```

Bad:

```text
fix: fixed stuff.
```

Avoid vague subjects:

```text
chore: update files
fix: resolve issue
refactor: clean up code
```

Prefer concrete subjects:

```text
chore(deps): update eslint config
fix(auth): handle missing refresh token
refactor(api): isolate pagination parsing
```

---

## Body rules

Add a body when the commit needs context.

Use the body to explain:

* Why the change was needed.
* What behavior changed.
* Previous behavior, if relevant.
* Tradeoffs or constraints.
* Migration notes.

Do not use the body to restate the diff line by line.

Example:

```text
fix(api): handle null user response

Deleted accounts can return a null user from the identity service.
Return a 404 before building the dashboard payload so the route does
not crash on missing user properties.
```

---

## Footer rules

Use footers for issue references, breaking changes, and metadata.

Examples:

```text
Refs: #123
Closes: #456
Reviewed-by: Jane Doe
```

Footers belong at the bottom after a blank line.

---

## Breaking changes

Mark breaking changes with `!` in the header, a `BREAKING CHANGE:` footer, or both if the project requires both.

Header form:

```text
feat(api)!: remove v1 endpoints
```

Footer form:

```text
BREAKING CHANGE: v1 endpoints are no longer available.
```

Recommended full form:

```text
feat(api)!: remove v1 endpoints

Remove endpoints deprecated in version 23.1. Clients must migrate to
the v2 API before upgrading.

BREAKING CHANGE: v1 endpoints are no longer available.
```

A breaking change can use any type.

Examples:

```text
fix(config)!: require explicit config file path
refactor(auth)!: replace session token format
chore(deps)!: drop Node.js 18 support
```

---

## Revert commits

Use `revert` when undoing a previous commit.

Format:

```text
revert: <original commit subject>

This reverts commit <hash>.

Reason: <why the revert is needed>
```

Example:

```text
revert: feat(api): add bulk user import

This reverts commit abc123def456.

Reason: The import job caused database lock contention in production.
```

---

## Atomic commit rules

Create separate commits when changes are independent.

Split when the diff includes multiple unrelated categories:

```text
fix(auth): handle missing refresh token
test(auth): cover missing refresh token
docs(auth): document refresh-token behavior
```

Keep together when tests directly verify the same behavior change:

```text
fix(auth): handle missing refresh token
```

This commit may include both the implementation and its tests.

Do not create commits that mix unrelated work:

```text
feat(auth): add password reset and update footer styles
```

Split into:

```text
feat(auth): add password reset
style(ui): update footer spacing
```

---

## Commit command rules

Prefer committing staged files intentionally.

```bash
git add <files>
git diff --staged
git commit -m "<type>(<scope>): <description>"
```

For commits with a body, use a commit message file or multiple `-m` flags.

```bash
git commit \
  -m "fix(api): handle null user response" \
  -m "Deleted accounts can return a null user from the identity service. Return a 404 before building the dashboard payload."
```

Do not commit if the staged diff contains unrelated changes. Propose a split instead.

---

## Validation checklist

Before finalizing a commit message, verify:

* [ ] The type matches the actual change.
* [ ] The scope is useful or omitted.
* [ ] The subject is imperative and specific.
* [ ] The subject has no trailing period.
* [ ] The body explains why when context is needed.
* [ ] Breaking changes are marked explicitly.
* [ ] Footers are at the bottom.
* [ ] The commit is atomic.
* [ ] The message does not mention files or implementation details unless useful.
* [ ] The message matches the staged diff.

---

## Output contract

When generating one commit message:

```text
Commit message:

<message>
```

When proposing multiple commits:

```text
Suggested commit split:

1. <type>(<scope>): <description>
   Files:
   - <file>
   Why:
   - <reason>

2. <type>(<scope>): <description>
   Files:
   - <file>
   Why:
   - <reason>
```

When reviewing a commit message:

```text
Verdict:
- Valid | Needs changes

Issues:
- <specific issue>

Suggested message:
<corrected message>
```

---

## Examples

### Simple fix

```text
fix(api): handle null response in user endpoint

Deleted accounts can return null from the user API. Return a 404 before
accessing user properties so the dashboard route does not crash.
```

### Feature

```text
feat(alerts): add Slack thread replies

Post alert updates and resolution notices as replies to the original
Slack thread so related notifications stay grouped.
```

### Refactor

```text
refactor(validation): extract shared request validator

Move duplicate validation logic from the user and project endpoints into
a shared validator. No behavior change.
```

### Dependency update

```text
build(deps): update eslint packages
```

Use `chore(deps)` instead if that is the repository convention.

### Breaking change

```text
feat(api)!: remove deprecated v1 endpoints

Remove endpoints deprecated in version 23.1. Clients must migrate to v2
before upgrading.

BREAKING CHANGE: v1 endpoints are no longer available.
```

### Revert

```text
revert: feat(api): add bulk user import

This reverts commit abc123def456.

Reason: The import job caused database lock contention in production.
```
