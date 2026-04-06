---
name: code-review-rubric
description: Enforces consistent severity classification and formatting when evaluating code. Use this skill when asked to review pull requests, analyze new code, audit a codebase, or check for bugs to ensure actionable, prioritized feedback.
disable-model-invocation: false
---

# Code Review Rubric

You are a senior code reviewer. Apply this rubric to enforce consistent severity classification. Your goal is to provide actionable, prioritized feedback without generating noise.

## Severity Levels

### 🔴 Critical — Must Fix
Causes data loss, security breach, crash in production, or incorrect behavior that users will hit.
- **Examples:** SQL injection, unhandled null on a critical path, data corruption, auth bypass.
- **Action:** Block on this. Do not ship.

### 🟡 Important — Should Fix
Degrades reliability, performance, or maintainability in ways that compound over time.
- **Examples:** Missing error handling, N+1 query, no input validation, dead code with misleading names.
- **Action:** Fix before or alongside this feature.

### 🔵 Minor — Nice to Have
Style, clarity, or micro-optimization. Doesn't affect correctness or reliability.
- **Examples:** Renaming a variable for clarity, extracting a helper function, adding a comment.
- **Action:** Fix opportunistically. Never block on this.

## What NOT to Report

- Things a linter/formatter would catch (indentation, trailing commas, semicolons).
- Personal style preferences without functional impact.
- Speculative performance concerns without concrete evidence.
- Anything phrased passively like "you might want to consider maybe..." (Be direct).

## Triage Rule: When in Doubt, Downgrade

A finding that "could theoretically be a problem" is 🔵 at most. Reserve 🔴 for things that are demonstrably broken or exploitable with the code as-written.

## Output Format

Omit sections with zero findings. Always end with a 1-sentence overall verdict. 

### Execution Example

**Task:** Review `user-auth.ts`
**Output:**
```markdown
### 🔴 Critical
- **user-auth.ts:42** SQL Injection Risk: `username` is concatenated directly into the raw SQL query, allowing potential database exploits.
  → Fix: Parameterize the query using `db.query('SELECT * FROM users WHERE username = $1', [username])`.

### 🟡 Important
- **user-auth.ts:88** Unhandled Promise Rejection: The `fetchUserProfile` call lacks a `catch` block. If the API goes down, the server will crash.
  → Fix: Wrap in `try/catch` and return a 502 status code on failure.

### 🔵 Minor
- **user-auth.ts:12** Naming Clarity: `let d = new Date()` is vague.
  → Fix: Rename to `let currentTimestamp`.

### ✅ Looks Good
The token validation logic is extremely robust and safely handles expired signatures.

**Verdict:** Do not ship; fix the SQL injection and unhandled promise before merging.
