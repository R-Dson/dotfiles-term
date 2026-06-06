---
name: git-and-shell-safety
description: Enforces safe shell execution, repository-aware Git workflows, branch hygiene, and Conventional Commit formatting. Use when running shell commands, modifying files, managing Git state, staging changes, creating commits, cleaning files, resetting work, or preparing repository history.
disable-model-invocation: false
---

# Git & Shell Safety

## Purpose

Safely interact with files, shell commands, and Git repositories while preserving user work, avoiding destructive mistakes, keeping terminal output concise, and maintaining clean commit history.

## When to use

Use this skill when the task involves:

- Running shell commands.
- Reading, editing, moving, creating, or deleting files.
- Inspecting repository state.
- Managing branches, staging, commits, resets, rebases, merges, cleans, or pushes.
- Writing or reviewing commit messages.
- Summarizing terminal output.

Do not use this as the primary guide for application architecture, language-specific testing, deployment strategy, or database migration planning.

---

## Operating workflow

1. **Inspect**
   - Confirm location and repository state.
   - Read before writing.
   - Check branch and working tree before Git operations.

2. **Plan**
   - Choose the smallest safe command.
   - Prefer read-only inspection before mutation.
   - Classify actions as safe, confirmation-required, or forbidden.

3. **Execute**
   - Scope commands to explicit files or directories.
   - Avoid broad filesystem operations.
   - Filter large output.

4. **Verify**
   - Inspect resulting files, diffs, status, or test output.
   - Confirm only intended files changed.

5. **Report**
   - Summarize actions, changed files, verification, and skipped risky steps.

---

## Shell safety rules

### Read before write

Before modifying state, inspect the relevant state.

```bash
pwd
git rev-parse --show-toplevel
git status --short
cat package.json | jq '.scripts'
sed -n '1,160p' path/to/file
````

### Scope commands narrowly

Prefer explicit paths.

```bash
git diff -- src/auth/login.ts
rm ./tmp/generated-report.json
```

Avoid broad commands unless previewed and confirmed.

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

For automation, prefer stable Git output.

```bash
git status --porcelain
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

Prefer:

```bash
npm run build
timeout 20s npm run dev
docker compose up -d
docker compose logs --tail=100
```

---

## Risk levels

### Safe by default

Safe when scoped:

```bash
pwd
ls
cat path/to/file
sed -n '1,120p' path/to/file
grep -R "pattern" . --exclude-dir=.git --exclude-dir=node_modules
git status --short
git status --porcelain
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
git clean -fd ...
git clean -fdx ...
git push
git push --force
git push --force-with-lease
git rebase ...
git commit --amend
git branch -D ...
git restore ...
git restore --staged ...
```

Before asking, preview the impact.

```bash
git status --short
git diff --stat
git clean -nd
git clean -ndx
find . -name "*.log" -mtime +30 -print
```

### Forbidden unless explicitly requested and confirmed

Do not perform these without direct user request and explicit confirmation:

* Delete directories with `rm -rf`.
* Hard-reset work with `git reset --hard`.
* Remove untracked files with `git clean -fd` or `git clean -fdx`.
* Force-push with `git push --force`.
* Rewrite published history.
* Delete local or remote branches.
* Modify files outside the project root.
* Run scripts that alter shell profiles, global packages, system config, credentials, or secrets.

---

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

### Branch naming

Prefer task branches over committing directly to `main`, `master`, or protected branches.

Pattern:

```text
<type>/<short-kebab-description>
```

Examples:

```text
feat/add-user-auth
fix/null-pointer-handler
docs/update-readme-installation
refactor/extract-api-client
test/add-login-coverage
chore/update-dependencies
```

Create branches with:

```bash
git switch -c feat/short-description
```

### Staging

Stage intentionally.

```bash
git add path/to/file
git add -p
```

Avoid broad staging unless the full diff was reviewed.

```bash
git add .
git add -A
```

Before committing:

```bash
git diff
git diff --staged
git status --short
```

### Commits

Create commits only when requested or clearly part of the task.

Commits should be atomic: one logical change per commit.

Good:

```text
fix(auth): reject expired refresh tokens
docs(auth): document token refresh behavior
```

Bad:

```text
fix stuff
```

Never push unless explicitly requested.

---

## Conventional Commits

Use this format:

```text
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

Examples:

```text
feat(auth): add password reset flow
fix(ui): correct login button click handler
docs(readme): update installation steps
refactor(api): extract request retry helper
test(auth): add expired-token coverage
chore(deps): update eslint
```

Common types:

* `feat`: new functionality.
* `fix`: bug fix.
* `docs`: documentation only.
* `style`: formatting only.
* `refactor`: code change that neither fixes a bug nor adds a feature.
* `perf`: performance improvement.
* `test`: tests added or corrected.
* `build`: build system or dependency changes.
* `ci`: CI configuration.
* `chore`: maintenance.
* `revert`: reverts a previous commit.

Subject rules:

* Use imperative mood.
* Keep it concise.
* No trailing period.
* Prefer lowercase after the colon unless project style differs.
* Keep under 70 characters where practical.

Breaking changes:

```text
feat(api)!: remove v1 session endpoint

BREAKING CHANGE: clients must migrate to /api/v2/session.
```

Use footers for issue references:

```text
Refs: #123
Closes: #456
```

---

## High-signal Git commands

Use these to gather context without bloat.

```bash
git status --short
git status --porcelain
git branch --show-current
git log --oneline --decorate -10
git diff -- path/to/file
git diff --staged
git diff --name-only
git diff --staged --name-only
git blame -L 10,30 -- file.ts
git show HEAD:path/to/file.ts
git ls-files
git ls-files --others --exclude-standard
```

For branch comparison:

```bash
git log --oneline main..HEAD
git diff --stat main...HEAD
git diff --name-only main...HEAD
```

---

## Safer alternatives

| Risky action         | Safer first step                                        |
| -------------------- | ------------------------------------------------------- |
| `rm -rf path`        | `find path -maxdepth 2 -print`                          |
| `git clean -fd`      | `git clean -nd`                                         |
| `git clean -fdx`     | `git clean -ndx`                                        |
| `git reset --hard`   | `git diff`, then consider `git stash push -m "backup"`  |
| `git push --force`   | Confirm need, then prefer `git push --force-with-lease` |
| `git add .`          | `git add -p` or `git add path/to/file`                  |
| `git restore file`   | `git diff -- file`, then confirm                        |
| `git branch -D name` | `git branch --contains name` and inspect recent commits |

---

## Verification

After changes:

```bash
git status --short
git diff --stat
```

Before committing:

```bash
git diff
git diff --staged
git status --short
```

After committing:

```bash
git log --oneline -1
git status --short
```

For code changes, run project-appropriate checks when available.

```bash
npm test
npm run lint
npm run build
pytest
cargo test
go test ./...
```

A task is complete only when the result has been inspected or any limitation is clearly reported.

---

## Output contract

When reporting work:

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

Do not paste long logs. Summarize and include only relevant lines.

---

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

If the repository has conflicts or unexpected changes, stop and inspect before proceeding.

```bash
git status --short
git diff --name-only
```

Do not overwrite user changes unless explicitly approved.

---

## Examples

### Safe file modification

Task: update the version in `package.json`.

```bash
cat package.json | jq '.version'
# edit version
git diff -- package.json
git status --short
```

Report that the file was updated and verified. Do not commit or push unless requested.

### Safe deletion

Task: delete log files older than 30 days.

```bash
find . -name "*.log" -mtime +30 -print
```

Only after confirmation:

```bash
find . -name "*.log" -mtime +30 -delete
```

### Safe search

Task: find occurrences of `API_KEY`.

```bash
grep -R "API_KEY" . --exclude-dir=.git --exclude-dir=node_modules | head -n 20
```

Mention if results were truncated.

### Conventional commit split

Input:

```text
I fixed the login button bug and updated the docs.
```

Use separate atomic commits if the changes are independent:

```text
fix(ui): correct login button click handler
docs(readme): update installation steps
```

### Push safety

If the user asks to push:

```bash
git status --short
git branch --show-current
git log --oneline --decorate -5
```

Confirm target branch and remote before:

```bash
git push
```

If a force push is explicitly required and confirmed, prefer:

```bash
git push --force-with-lease
```
