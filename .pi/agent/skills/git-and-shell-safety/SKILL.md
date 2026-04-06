---
name: git-and-shell-safety
description: Enforces safety protocols for shell commands and standards for Git operations. Use this skill when executing bash commands, managing branches, or formatting conventional commit messages to ensure repository integrity, clean history, and efficient context usage.
disable-model-invocation: false
---

# Git & Shell Safety Standards

You are a cautious and organized developer. Your goal is to interact with the system safely and maintain a professional, standardized repository history.

## 1. Safe Bash Protocols

**Read Before Write:** Before modifying any state (files, configs, database), read the current state to understand the context.
```bash
# Example: Check current scripts before adding a new one
cat package.json | jq '.scripts'
```

**Dry-Run Destructive Actions:** Always verify what will be affected before executing deletions or resets.
```bash
# Example: Verify files to be removed
find . -name "*.log" -mtime +30 
# Only then:
find . -name "*.log" -mtime +30 -delete
```

**Output Filtering:** Never return raw, unformatted bash output to the context window. Filter to relevant lines using `grep`, `head`, or `jq`.
```bash
# ✅ Good: Returns only the first 20 TypeScript files
find . -name "*.ts" | grep -v node_modules | head -20
```

**Forbidden Actions:**
- `rm -rf` without explicit user confirmation.
- `git push` or `git reset --hard` unless specifically requested by the user.
- Commands that start long-running processes (e.g., `npm start`) as they block the agent session.
- Writing to files outside the project root.

## 2. Git Standards

### Branch Naming
Before starting work, ensure you are on a feature branch. Pattern: `<type>/<short-description>`.
*   ✅ `feat/add-user-auth`
*   ✅ `fix/null-pointer-handler`

### Conventional Commits
All commits must follow the [Conventional Commits](https://www.conventionalcommits.org/) spec:
`<type>(<optional-scope>): <subject>`

**Common Types:**
- `feat`: A new feature (correlates with MINOR version).
- `fix`: A bug fix (correlates with PATCH version).
- `docs`: Documentation changes.
- `refactor`: Code change that neither fixes a bug nor adds a feature.
- `test`: Adding or correcting tests.
- `chore`: Maintenance (deps, build config).

**Subject Line Rules:**
- Use imperative, present tense ("Add" not "Added").
- No period at the end. Max 70 characters.
- Use `!` after the type/scope for **BREAKING CHANGES** (e.g., `feat(api)!: remove v1`).

## 3. High-Signal Git Retrieval
Use these commands to gather context without bloat:
```bash
git log --oneline -10                     # Get recent history
git diff HEAD -- path/to/file.ts          # See changes in a specific file
git blame -L 10,30 -- file.ts             # See who modified specific lines
git show HEAD:path/to/file.ts             # View file content at current HEAD
```

## Execution Examples

**Example 1: Safe Modification**
*Task:* Update the version in `package.json`.
1. `cat package.json | jq '.version'` (Read)
2. `sed` or `npm version` (Write)
3. `git diff package.json` (Verify)

**Example 2: Conventional Commit**
*Input:* "I fixed the login button bug and updated the docs."
*Action:* Create two atomic commits.
1. `fix(ui): correct login button click handler`
2. `docs(readme): update installation steps`

**Example 3: Safe Search**
*Input:* "Find all occurrences of 'API_KEY'."
*Action:* `grep -r "API_KEY" . --exclude-dir=node_modules | head -n 20`
