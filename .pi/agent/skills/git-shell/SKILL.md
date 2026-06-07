---
name: git-shell
description: Enforces safe shell execution, repository-aware Git workflows, branch hygiene, and concise terminal reporting. Use when running shell commands, modifying files, managing Git state, staging, committing, cleaning files, resetting work, or preparing repository history.
disable-model-invocation: false
---

# Git shell

## Purpose

Interact with files, shell commands, and Git safely: preserve user work, avoid destructive mistakes, keep output concise, and maintain clean repository history.

## When to use

Use this skill when the task involves:

- Shell commands or terminal output.
- Reading, editing, moving, creating, or deleting files.
- Inspecting repository state.
- Managing branches, staging, commits, resets, rebases, merges, cleans, or pushes.
- Summarizing command results.

Do not use this as the primary guide for application architecture, language-specific testing, deployment strategy, or database migration planning. For detailed commit-message writing, use the `commits` skill.

## Optional reference

Load `references/handbook.md` only when concrete command recipes, recovery steps, destructive-operation previews, or Git troubleshooting details are needed.

## Operating workflow

1. **Inspect** — confirm location, repo root, branch, and working tree before mutation.
2. **Plan** — choose the smallest safe command; prefer read-only inspection first.
3. **Execute** — scope commands to explicit files/directories and filter large output.
4. **Verify** — inspect resulting files, diffs, status, or test output.
5. **Report** — summarize actions, changes, verification, and skipped risky steps.

## Shell safety rules

### Read before write

Before modifying state, inspect the relevant state. In pi, prefer the `read` tool for file contents and `edit` for file changes; use shell file readers mainly for pipelines or when tool access is unavailable.

```bash
pwd
git rev-parse --show-toplevel
git status --short
git diff -- path/to/file
```

### Scope narrowly

Prefer explicit paths.

```bash
git diff -- src/auth/login.ts
rm ./tmp/generated-report.json
```

Avoid broad filesystem operations unless previewed and confirmed.

```bash
rm -rf *
git add .
find . -delete
```

### Filter output

Do not return large raw command output. Use targeted filters.

```bash
find . -name "*.ts" -not -path "*/node_modules/*" | head -n 50
grep -R "API_KEY" . --exclude-dir=.git --exclude-dir=node_modules | head -n 20
command | tail -n 80
command | jq '.relevant.field'
```

### Avoid blocking commands

Do not run long-lived foreground processes unless explicitly needed and bounded.

Avoid:

```bash
npm start
npm run dev
python -m http.server
docker compose up
```

Prefer bounded alternatives:

```bash
npm run build
timeout 20s npm run dev
docker compose up -d
docker compose logs --tail=100
```

## Risk levels

### Safe by default when scoped

```bash
pwd
ls
grep -R "pattern" . --exclude-dir=.git --exclude-dir=node_modules
git status --short
git branch --show-current
git log --oneline --decorate -10
git diff -- path/to/file
git diff --staged
git show HEAD:path/to/file
```

### Confirmation required

Ask before actions that discard work, rewrite history, affect remotes, or make broad filesystem changes.

```bash
rm -rf ...
git reset --hard ...
git clean -fd...
git push
git push --force-with-lease
git rebase ...
git commit --amend
git branch -D ...
git restore ...
git restore --staged ...
```

Preview impact before asking:

```bash
git status --short
git diff --stat
git clean -nd
git clean -ndx
find . -name "*.log" -mtime +30 -print
```

### Forbidden unless explicitly requested and confirmed

- Delete directories with `rm -rf`.
- Hard-reset work with `git reset --hard`.
- Remove untracked files with `git clean -fd` or `git clean -fdx`.
- Force-push with `git push --force`.
- Rewrite published history.
- Delete local or remote branches.
- Modify files outside the project root.
- Run scripts that alter shell profiles, global packages, system config, credentials, or secrets.

## Git workflow

### Inspect first

Before Git operations:

```bash
git status --short
git branch --show-current
```

When relevant:

```bash
git log --oneline --decorate -10
git remote -v
```

Do not assume the branch, remote, or working tree is safe.

### Branches

Prefer task branches over protected branches. Pattern:

```text
<type>/<short-kebab-description>
```

Examples: `feat/add-user-auth`, `fix/null-pointer-handler`, `docs/update-readme-installation`.

### Staging and commits

Stage intentionally:

```bash
git add path/to/file
git add -p
```

Avoid `git add .` unless the full diff was reviewed.

Before committing:

```bash
git diff
git diff --staged
git status --short
```

Create commits only when requested or clearly part of the task. Keep commits atomic. Never push unless explicitly requested.

## Safer alternatives

| Risky action | Safer first step |
|---|---|
| `rm -rf path` | `find path -maxdepth 2 -print` |
| `git clean -fd` | `git clean -nd` |
| `git clean -fdx` | `git clean -ndx` |
| `git reset --hard` | `git diff`, then consider `git stash push -m "backup"` |
| `git push --force` | Confirm need; prefer `git push --force-with-lease` |
| `git add .` | `git add -p` or `git add path/to/file` |
| `git restore file` | `git diff -- file`, then confirm |
| `git branch -D name` | `git branch --contains name` and inspect recent commits |

## Verification

After file changes:

```bash
git status --short
git diff --stat
```

Before/after committing:

```bash
git diff --staged
git log --oneline -1
git status --short
```

For code changes, run project-appropriate checks when available: tests, lint, typecheck, build, or language-specific test commands.

A task is complete only when the result has been inspected or any limitation is reported.

## Failure handling

If a command fails:

1. Do not retry blindly.
2. Read the error.
3. Inspect path, permissions, dependencies, dirty Git state, or syntax.
4. Run a safe diagnostic command.
5. Explain the next safe option.

Useful diagnostics:

```bash
pwd
ls
git status --short
which node
node --version
```

If the repo has conflicts or unexpected changes, stop and inspect before proceeding. Do not overwrite user changes without approval.

## Output contract

```text
Changed:
- <files or areas changed>

Verified:
- <checks performed>

Skipped:
- <risky actions not taken, if any>

Notes:
- <important caveats or next steps>
```

Do not paste long logs. Summarize relevant lines only.
