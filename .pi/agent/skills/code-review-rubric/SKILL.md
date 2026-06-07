---
name: code-review-rubric
description: Provides an evidence-first rubric for reviewing pull requests, diffs, new code, bug fixes, and codebase audits. Use when asked to review code, analyze a PR, check for bugs, audit implementation quality, or classify findings by severity. Prioritizes actionable feedback and avoids speculative noise.
disable-model-invocation: false
---

# Code review rubric

## Purpose

Review code like a senior engineer: identify real risks, classify severity consistently, and provide actionable feedback without noise. The goal is to improve code health, correctness, reliability, security, and maintainability without blocking on personal preference.

## When to use

Use this skill when asked to:

- Review a pull request or diff.
- Analyze new or changed code.
- Check for bugs or regressions.
- Audit code quality.
- Review implementation against a spec.
- Classify review findings by severity.
- Decide whether code is ready to ship.

Do not use this skill as the primary guide for:

- Full security audits requiring specialized threat modeling.
- Performance benchmarking without runtime data.
- Style-only formatting passes.
- Product or UX copy review.

---

## Review workflow

1. **Understand scope**
   - Identify the requested review target: diff, files, PR, feature, bug fix, or full audit.
   - Read the relevant spec, issue, tests, and surrounding code when available.
   - Prefer reviewing changed behavior, not isolated lines.

2. **Inspect evidence**
   - Look for concrete failure modes in the code as written.
   - Trace user input, data flow, error paths, auth boundaries, persistence, concurrency, and external calls.
   - Check tests for meaningful coverage of changed behavior.

3. **Classify findings**
   - Assign severity from observed impact and likelihood.
   - Downgrade speculative or low-evidence concerns.
   - Do not inflate severity to force attention.

4. **Write actionable feedback**
   - Each finding must include location, issue, evidence, impact, and fix.
   - Prefer precise fixes over broad advice.
   - Avoid comments that a formatter, linter, or type checker already handles.

5. **Give a verdict**
   - End with a one-sentence merge recommendation.
   - State whether the change should ship, ship after fixes, or not ship.

---

## Severity levels

### 🔴 Critical — must fix

Use for issues that can cause production failure, data loss, security compromise, privacy exposure, corrupted state, or clearly incorrect user-visible behavior.

Block shipping.

Examples:

- SQL injection.
- Auth bypass.
- Broken authorization check.
- Data corruption or irreversible deletion.
- Secret or token exposure.
- Crash on a common production path.
- Incorrect billing, payment, permission, or access-control behavior.
- Migration that can destroy or mis-shape production data.
- Race condition that can duplicate money, inventory, access, or irreversible side effects.

Critical findings require:

- A concrete code path.
- A plausible trigger.
- Clear user, business, security, or data impact.

### 🟡 Important — should fix

Use for issues that do not immediately block all shipping but meaningfully degrade reliability, maintainability, security posture, performance, or future change safety.

Usually fix before merge unless the team explicitly accepts the tradeoff.

Examples:

- Missing validation on externally controlled input.
- Missing error handling on important external calls.
- N+1 query on a likely hot path.
- Incomplete test coverage for changed behavior.
- Flaky or order-dependent tests.
- Misleading abstraction or dead code that will cause future bugs.
- Resource leak, retry storm, or unbounded loop.
- Migration without rollback or verification path.
- Important edge case not handled.

Important findings require:

- A real scenario where the issue matters.
- A reason it should be addressed in this change or soon after.
- A specific remediation.

### 🔵 Minor — nice to have

Use for clarity, maintainability, local simplification, or small improvements that do not affect correctness, reliability, security, or meaningful performance.

Do not block shipping.

Examples:

- Clearer variable or function name.
- Small helper extraction.
- More direct control flow.
- Better local comment or docstring.
- Slightly clearer test name.
- Non-critical duplication.
- Micro-optimization without measured impact.

Minor findings should be limited. If there are many, summarize them instead of listing every detail.

---

## Triage rules

### Evidence first

Report only findings supported by the code, diff, tests, or documented requirements.

Do not report:

- Pure speculation.
- Personal style preferences.
- Formatting issues handled by tooling.
- Hypothetical performance concerns without scale or runtime evidence.
- Alternative designs that are not clearly safer or simpler.
- Requests to rewrite working code just because another pattern is preferred.

### When in doubt, downgrade

If an issue “could theoretically be a problem” but has no concrete trigger or impact, classify it as 🔵 Minor or omit it.

Reserve 🔴 Critical for demonstrably broken, exploitable, unsafe, or user-impacting behavior.

### Security severity

For security-sensitive findings, consider:

```text
Severity = likelihood × impact
````

Increase severity when:

* The input is attacker-controlled.
* Exploitation is straightforward.
* The affected data is sensitive.
* The issue crosses authentication, authorization, tenancy, payment, or privacy boundaries.
* The blast radius is broad.

Downgrade when:

* Exploitation requires unrealistic access.
* The path is internal-only and trusted.
* Impact is limited and recoverable.
* Existing controls prevent realistic abuse.

### Blocking vs non-blocking

A finding is blocking only if it is:

* 🔴 Critical.
* 🟡 Important and required for correctness, safety, or spec compliance before merge.

Mark 🔵 Minor as non-blocking.

---

## Review categories

Check the categories relevant to the change.

### Correctness

* Does the code satisfy the stated requirement?
* Are edge cases handled?
* Are null, empty, missing, malformed, and duplicate inputs handled?
* Are state transitions valid?
* Are error paths tested?

### Security and privacy

* Are authentication and authorization checks correct?
* Is user input validated or safely encoded?
* Are secrets, tokens, credentials, or private data exposed?
* Is tenant, organization, or user isolation preserved?
* Are logs free of sensitive data?
* Are dependencies or dynamic execution paths safe?

### Reliability

* Are external calls handled with timeouts, retries, or fallbacks where appropriate?
* Can failures cascade?
* Are errors surfaced clearly?
* Are migrations safe and reversible where possible?
* Are concurrency and race conditions considered?

### Performance

* Is there an obvious hot-path regression?
* Are queries, loops, network calls, or renders accidentally multiplied?
* Is the concern supported by realistic scale or known usage?
* Avoid reporting micro-optimizations without evidence.

### Maintainability

* Is the code understandable in the project’s existing style?
* Are abstractions necessary and named accurately?
* Is duplicated logic likely to diverge?
* Are boundaries between modules respected?
* Is the change smaller and safer than alternatives?

### Tests

* Do tests cover the changed behavior?
* Do they fail for the bug or requirement being addressed?
* Are important edge cases covered?
* Are tests deterministic?
* Do tests assert behavior rather than implementation details?

---

## Finding format

Use this format for every finding:

```markdown
- **<file>:<line or range> — <short title>**
  - **Issue:** <what is wrong>
  - **Evidence:** <specific code path, input, condition, or missing case>
  - **Impact:** <why it matters>
  - **Fix:** <specific change, example, or direction>
```

For short reviews, this compact form is acceptable:

```markdown
- **<file>:<line> — <short title>:** <issue and impact>
  → Fix: <specific remediation>
```

---

## Output format

Omit empty severity sections. Always end with a one-sentence verdict.

```markdown
### 🔴 Critical

- **<file>:<line> — <title>**
  - **Issue:** ...
  - **Evidence:** ...
  - **Impact:** ...
  - **Fix:** ...

### 🟡 Important

- **<file>:<line> — <title>**
  - **Issue:** ...
  - **Evidence:** ...
  - **Impact:** ...
  - **Fix:** ...

### 🔵 Minor

- **<file>:<line> — <title>:** ...
  → Fix: ...

### ✅ Looks good

- <specific verified strength, if any>

**Verdict:** <ship / ship after fixes / do not ship, with one concise reason>
```

If there are no findings:

```markdown
### ✅ Looks good

- No correctness, security, reliability, performance, or maintainability issues found in the reviewed scope.

**Verdict:** Ship it.
```

---

## Tone rules

* Be direct, specific, and respectful.
* Critique the code, not the author.
* Avoid hedging language when evidence is clear.
* Avoid passive vague phrasing such as “you might want to maybe consider.”
* Use “nit” or 🔵 Minor only for genuinely non-blocking comments.
* Include praise only when it is specific and verified.

Good:

```text
This endpoint accepts `organizationId` from the request body but never checks membership, so a user can read another organization’s invoices.
```

Bad:

```text
Maybe consider improving auth here?
```

---

## What not to report

Do not report:

* Formatting issues handled by tooling.
* Import ordering unless it breaks build or convention enforcement.
* Semicolon, trailing comma, or whitespace preferences.
* Personal naming preferences without clarity or correctness impact.
* Speculative future problems.
* Alternative architecture without a clear defect in the current approach.
* Missing comments when the code is already clear.
* Test implementation details that do not reduce confidence.
* Large rewrites unrelated to the requested change.

---

## Examples

### Critical

```markdown
### 🔴 Critical

- **user-auth.ts:42 — SQL injection in login lookup**
  - **Issue:** `username` is concatenated into a raw SQL query.
  - **Evidence:** A username like `' OR '1'='1` changes the query predicate.
  - **Impact:** An attacker can bypass lookup constraints or extract user data.
  - **Fix:** Parameterize the query: `db.query('SELECT * FROM users WHERE username = $1', [username])`.

**Verdict:** Do not ship; the SQL injection must be fixed before merge.
```

### Important

```markdown
### 🟡 Important

- **profile-service.ts:88 — Unhandled profile API failure**
  - **Issue:** `fetchUserProfile()` is awaited without error handling.
  - **Evidence:** A rejected request escapes the route handler.
  - **Impact:** A profile API outage can return a generic 500 instead of a controlled fallback or 502.
  - **Fix:** Wrap the call in `try/catch`, log a safe error, and return a controlled error response.

**Verdict:** Ship after fixing the profile API failure path.
```

### Minor

```markdown
### 🔵 Minor

- **date-utils.ts:12 — Unclear local variable name:** `d` hides that the value is the current timestamp.
  → Fix: Rename it to `currentTimestamp`.

**Verdict:** Ship; the naming cleanup is non-blocking.
```
