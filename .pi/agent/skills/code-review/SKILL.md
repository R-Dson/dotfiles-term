---
name: code-review
description: Provides an evidence-first rubric for reviewing pull requests, diffs, new code, bug fixes, and codebase audits. Use when asked to review code, analyze a PR, check for bugs, audit implementation quality, or classify findings by severity. Prioritizes actionable feedback and avoids speculative noise.
disable-model-invocation: false
---

# Code review

## Purpose

Review code like a senior engineer: identify real risks, classify severity consistently, and provide actionable feedback without noise. Improve correctness, reliability, security, and maintainability without blocking on personal preference.

## When to use

Use this skill when asked to:

- Review a PR, diff, new code, bug fix, or implementation against a spec.
- Check for bugs or regressions.
- Audit code quality.
- Classify findings by severity.
- Decide whether code is ready to ship.

Do not use as the primary guide for full security audits, performance benchmarking without runtime data, style-only formatting passes, or product/UX copy review.

## Optional reference

Load `references/examples.md` only when severity calibration, finding wording, or review-output examples are needed.

## Review workflow

1. **Understand scope** — identify review target and read relevant spec, issue, tests, and surrounding code.
2. **Inspect evidence** — trace user input, data flow, error paths, auth boundaries, persistence, concurrency, and external calls.
3. **Classify findings** — assign severity from observed impact and likelihood; downgrade speculative issues.
4. **Write actionable feedback** — each finding needs location, issue, evidence, impact, and fix.
5. **Give a verdict** — ship, ship after fixes, or do not ship.

Review changed behavior, not isolated lines. Avoid comments that formatters, linters, or type checkers already handle.

## Severity levels

### 🔴 Critical — must fix

Use for production failure, data loss, security compromise, privacy exposure, corrupted state, or clearly incorrect user-visible behavior. Block shipping.

Examples: SQL injection, auth bypass, broken authorization, data corruption, secret exposure, common-path crash, incorrect billing/payment/permission behavior, unsafe migration, race condition causing irreversible side effects.

Requires concrete code path, plausible trigger, and clear user/business/security/data impact.

### 🟡 Important — should fix

Use for issues that meaningfully degrade reliability, maintainability, security posture, performance, or future change safety. Usually fix before merge unless accepted explicitly.

Examples: missing validation on external input, missing error handling for important calls, N+1 on likely hot path, incomplete tests for changed behavior, flaky tests, misleading abstraction, resource leak, unbounded loop, migration without verification, important edge case missed.

Requires a real scenario, reason to address now/soon, and specific remediation.

### 🔵 Minor — nice to have

Use for clarity or local maintainability improvements that do not affect correctness, reliability, security, or meaningful performance. Do not block shipping.

Examples: clearer naming, small helper extraction, simpler control flow, better local comment, clearer test name, non-critical duplication.

Limit minor findings; summarize if there are many.

## Triage rules

- Report only findings supported by code, diff, tests, or documented requirements.
- Omit pure speculation, personal style preferences, formatter issues, and hypothetical performance concerns without scale/runtime evidence.
- Do not request alternative architecture unless the current approach is clearly unsafe or more complex than needed.
- When in doubt, downgrade or omit.
- Mark a finding blocking only when it is 🔴 Critical or a 🟡 Important issue required for correctness, safety, or spec compliance before merge.

Security severity uses likelihood × impact. Increase severity for attacker-controlled input, easy exploitation, sensitive data, auth/authz/tenant/payment/privacy boundaries, or broad blast radius. Downgrade when access is unrealistic, path is trusted/internal, impact is limited/recoverable, or controls prevent abuse.

## Review categories

Check categories relevant to the change:

- **Correctness:** requirement fit, edge cases, null/empty/malformed/duplicate input, state transitions, error paths.
- **Security/privacy:** authn/authz, validation/encoding, secrets/PII exposure, tenancy isolation, safe logs, dependency/dynamic execution safety.
- **Reliability:** timeouts, retries, fallbacks, cascading failures, clear errors, migration safety, concurrency.
- **Performance:** supported hot-path regressions, multiplied queries/loops/network calls/renders; avoid micro-optimizations without evidence.
- **Maintainability:** understandable project style, necessary abstractions, duplication risk, module boundaries, simpler safer alternatives.
- **Tests:** changed behavior covered, meaningful regression tests, deterministic tests, behavior assertions over implementation details.

## Finding format

Full form:

```markdown
- **<file>:<line or range> — <short title>**
  - **Issue:** <what is wrong>
  - **Evidence:** <specific code path, input, condition, or missing case>
  - **Impact:** <why it matters>
  - **Fix:** <specific remediation>
```

Compact form:

```markdown
- **<file>:<line> — <short title>:** <issue and impact>
  → Fix: <specific remediation>
```

## Output contract

Omit empty severity sections. Always end with a one-sentence verdict.

```markdown
### 🔴 Critical
- **<file>:<line> — <title>** ...

### 🟡 Important
- **<file>:<line> — <title>** ...

### 🔵 Minor
- **<file>:<line> — <title>:** ...
  → Fix: ...

### ✅ Looks good
- <specific verified strength, if useful>

**Verdict:** <ship / ship after fixes / do not ship, with one concise reason>
```

If there are no findings:

```markdown
### ✅ Looks good
- No correctness, security, reliability, performance, or maintainability issues found in the reviewed scope.

**Verdict:** Ship it.
```

## Tone rules

- Be direct, specific, and respectful.
- Critique code, not author.
- Avoid hedging when evidence is clear.
- Avoid vague phrasing such as “you might want to maybe consider.”
- Use “nit” or 🔵 Minor only for genuinely non-blocking comments.
- Include praise only when specific and verified.

## What not to report

Do not report formatting, import ordering, semicolon/trailing-comma/whitespace preferences, personal naming preferences without impact, speculative future problems, architecture alternatives without a current defect, missing comments when code is clear, test implementation details that do not reduce confidence, or unrelated rewrites.
