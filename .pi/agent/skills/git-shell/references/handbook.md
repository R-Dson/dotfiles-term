# Git shell handbook

Load this only when concrete shell/Git command recipes, recovery steps, or destructive-operation previews are needed.

## Principles

- Prefer pi `read` for file contents and `edit` for file changes.
- Use shell for discovery, pipelines, Git, builds/tests, and filesystem operations.
- Preview before mutation; verify after mutation.
- Scope every command to explicit paths when possible.
- Filter output before returning it to the user.

## Orientation

```bash
pwd
git rev-parse --show-toplevel
git status --short
git branch --show-current
git log --oneline --decorate -10
```

Use before commits, branch operations, destructive commands, or when user work may be present.

## High-signal search

Prefer `rg` when available:

```bash
rg -n "pattern" . -g '!node_modules' -g '!.git'
rg -n "functionName" src tests
find . -maxdepth 3 -type f | sort | head -100
```

For large output:

```bash
command | head -80
command | tail -80
command 2>&1 | tail -120
```

## Safe file deletion

Preview first:

```bash
find path -maxdepth 2 -type f -name "*.log" -print
```

After explicit confirmation:

```bash
find path -maxdepth 2 -type f -name "*.log" -delete
```

Avoid `rm -rf`; if unavoidable, require explicit user confirmation and use the narrowest path.

## Git clean/reset/restore

Preview untracked deletion:

```bash
git clean -nd
git clean -ndx
```

Ask before:

```bash
git clean -fd
git clean -fdx
git reset --hard
git restore path/to/file
git restore --staged path/to/file
```

Before discarding tracked changes:

```bash
git diff -- path/to/file
git status --short
```

Safer backup option:

```bash
git stash push -m "backup before <action>"
```

## Staging and commits

Inspect first:

```bash
git status --short
git diff
git diff --stat
```

Stage intentionally:

```bash
git add path/to/file
git add -p
```

Verify staged content:

```bash
git diff --staged
git diff --staged --name-only
```

Commit only when requested or clearly part of the task:

```bash
git commit -m "<type>(<scope>): <subject>"
```

Use the `commits` skill for message wording.

## Branch and remote checks

```bash
git branch --show-current
git branch --all --verbose
git remote -v
git log --oneline --decorate -5
git diff --stat main...HEAD
git diff --name-only main...HEAD
```

Before push:

```bash
git status --short
git branch --show-current
git log --oneline --decorate -5
```

Confirm target remote/branch before `git push`. Force-push requires explicit request and confirmation; prefer `--force-with-lease`.

## Bounded long-running commands

Avoid foreground servers unless bounded:

```bash
timeout 20s npm run dev
npm run build
npm test -- --runInBand
pytest -q
docker compose up -d
docker compose logs --tail=100
```

If a command can hang, add `timeout` or choose a non-watch mode.

## Failure triage

Do not retry blindly. Inspect the first meaningful error, then run narrow diagnostics:

```bash
pwd
ls
git status --short
which node && node --version
which python && python --version
```

Common responses:

| Symptom | Next step |
|---|---|
| Path not found | Check `pwd`, repo root, and `find`/`ls` nearby |
| Permission denied | Inspect ownership/permissions; do not sudo without approval |
| Dirty Git tree | Show `git status --short`; avoid overwrite |
| Missing dependency | Report missing tool/package; ask before installing |
| Merge conflict | Stop, inspect conflicted files, ask before resolving if intent is unclear |

## Reporting command results

Use compact summaries:

```text
Command:
- <command>

Result:
- <key outcome>

Relevant output:
- <short excerpt>

Status:
- success | failed | partial | not found
```
