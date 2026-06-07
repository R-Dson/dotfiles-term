---
name: commits
description: Creates clear Conventional Commit messages from staged or intended Git changes. Use when writing commit messages, preparing atomic commits, formatting Git history, splitting changes into commits, or validating commit-message quality.
license: MIT
metadata:
  version: "1.1.0"
---

# Commits

## Purpose

Create commit messages that are accurate, atomic, reviewable, and compatible with the Conventional Commits specification.

Use this skill to describe what changed and why. For destructive Git operations, branch management, resets, or pushes, use the Git safety skill.

## When to use

Use this skill when:

- Writing or reviewing a commit message.
- Splitting staged or unstaged changes into atomic commits.
- Choosing commit type, scope, body, or footers.
- Marking breaking changes or reverts.
- Preparing history for review.

Do not use for general shell safety, branch cleanup, rebase strategy, release notes, or PR descriptions unless the user asks for commit-derived text.

## Workflow

1. **Inspect the change**
   - Review staged changes first.
   - If nothing is staged, review the intended diff.
   - If no diff/context is available, ask for it or mark the message `[not verified]`.
   - Do not invent details not visible in the diff or supplied by the user.

2. **Choose atomic boundaries**
   - One commit = one logical change.
   - Split unrelated behavior, refactors, tests, and docs when practical.
   - Keep tests with the implementation when they directly verify the same behavior.

3. **Select type and scope**
   - Pick type from the actual change, not file location alone.
   - Use scope only when it clarifies the affected area.

4. **Write and validate**
   - Use concise imperative subject.
   - Add body when motivation, tradeoffs, or previous behavior matter.
   - Add footers for issues, breaking changes, or metadata.
   - Confirm the message matches the diff and marks breaking changes explicitly.

## Inspect before writing

Use when available:

```bash
git status --short
git diff --staged
git diff --staged --name-only
```

If no files are staged:

```bash
git diff
git diff --name-only
```

## Format

```text
<type>[optional scope][!]: <description>

[optional body]

[optional footer(s)]
```

Header is required. Body and footers are optional.

Examples:

```text
fix(api): handle null user response
feat(alerts): add Slack thread replies
refactor(auth): extract token validation
docs(readme): clarify installation steps
```

## Type rules

| Type | Use when |
|---|---|
| `feat` | Adds user/API-facing functionality |
| `fix` | Fixes a bug |
| `docs` | Changes documentation only |
| `style` | Formatting only |
| `refactor` | Restructures code without behavior change |
| `perf` | Improves performance |
| `test` | Adds or updates tests |
| `build` | Changes build system, packaging, or dependencies |
| `ci` | Changes CI configuration |
| `chore` | Maintenance not covered by another type |
| `revert` | Reverts a previous commit |

Project-specific types such as `deps` are allowed only if the repo already uses them. Otherwise prefer `build` or `chore` for dependency updates.

## Scope rules

Use scope when it helps locate the change: `auth`, `api`, `ui`, `billing`, `docs`, `deps`, `config`, `parser`.

Avoid broad or redundant scopes: `app`, `code`, `misc`, `changes`, `src`.

Omit scope when it adds no value.

## Subject rules

The subject must:

- Use imperative mood.
- Be specific.
- Be lowercase after the colon unless project convention differs.
- Avoid a trailing period.
- Prefer 50 characters or fewer; stay under 70 unless clarity requires more.

Good:

```text
fix(api): return 404 for missing users
```

Bad:

```text
fix: fixed stuff.
```

## Body and footer rules

Add a body when the commit needs context: why the change was needed, what behavior changed, previous behavior, tradeoffs, or migration notes.

Do not restate the diff line by line.

Use footers for issue references, breaking changes, and metadata:

```text
Refs: #123
Closes: #456
Reviewed-by: Jane Doe
```

Footers belong at the bottom after a blank line.

## Breaking changes

Mark breaking changes with `!`, a `BREAKING CHANGE:` footer, or both if project convention requires both.

```text
feat(api)!: remove v1 endpoints

Remove endpoints deprecated in version 23.1. Clients must migrate to v2.

BREAKING CHANGE: v1 endpoints are no longer available.
```

A breaking change can use any type.

## Revert commits

```text
revert: <original commit subject>

This reverts commit <hash>.

Reason: <why the revert is needed>
```

## Atomic commit rules

Split independent changes:

```text
fix(auth): handle missing refresh token
docs(auth): document refresh-token behavior
```

Keep implementation and tests together when the tests directly verify the same behavior.

Do not mix unrelated work:

```text
feat(auth): add password reset and update footer styles
```

## Commit command rules

Prefer committing intentionally staged files.

```bash
git add <files>
git diff --staged
git commit -m "<type>(<scope>): <description>"
```

For bodies, use a message file or multiple `-m` flags.

Do not commit if the staged diff contains unrelated changes; propose a split instead.

## Validation checklist

Before finalizing, verify:

- Type matches the actual change.
- Scope is useful or omitted.
- Subject is imperative, specific, and has no trailing period.
- Body explains why when context is needed.
- Breaking changes are marked explicitly.
- Footers are at the bottom.
- Commit is atomic.
- Message matches the staged diff.

## Output contract

One commit message:

```text
Commit message:

<message>
```

Multiple commits:

```text
Suggested commit split:

1. <type>(<scope>): <description>
   Files:
   - <file>
   Why:
   - <reason>
```

Commit-message review:

```text
Verdict:
- Valid | Needs changes

Issues:
- <specific issue>

Suggested message:
<corrected message>
```
