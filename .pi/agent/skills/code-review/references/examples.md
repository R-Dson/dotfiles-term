# Code review examples

Load this only when severity calibration, finding wording, or review-output examples are needed.

## Critical examples

```markdown
### 🔴 Critical

- **routes/invoices.ts:42 — Missing tenant check exposes invoices**
  - **Issue:** The endpoint loads invoices by `invoiceId` without checking the authenticated user's organization.
  - **Evidence:** `getInvoice(req.body.invoiceId)` runs after authentication but before any membership check.
  - **Impact:** A user who knows or guesses another invoice ID can read another tenant's billing data.
  - **Fix:** Load by both `invoiceId` and authorized `organizationId`, or check membership before returning the invoice.

**Verdict:** Do not ship; this authorization bypass must be fixed before merge.
```

Use Critical only when the path is reachable and impact is severe: auth bypass, cross-tenant data exposure, SQL injection, RCE, destructive migration, data loss, secret exposure with reachable impact, or common-path crash blocking core behavior.

## Important examples

```markdown
### 🟡 Important

- **services/profile.ts:88 — Unhandled profile API failure**
  - **Issue:** `fetchUserProfile()` is awaited without error handling.
  - **Evidence:** A rejected request escapes the route handler and returns a generic 500.
  - **Impact:** A profile-service outage can break the dashboard instead of returning a controlled 502/fallback.
  - **Fix:** Wrap the call in `try/catch`, log safe context, and return a controlled error response.

**Verdict:** Ship after fixing the external failure path.
```

Use Important for realistic issues that materially reduce reliability, safety, maintainability, or spec compliance but are not severe enough to block all shipping.

## Minor examples

```markdown
### 🔵 Minor

- **date-utils.ts:12 — Unclear local variable name:** `d` hides that the value is the current timestamp.
  → Fix: Rename it to `currentTimestamp`.

**Verdict:** Ship; the naming cleanup is non-blocking.
```

Use Minor for local clarity or maintainability improvements that do not affect correctness, reliability, security, or meaningful performance.

## Omit examples

Do not report these unless they create a real defect in context:

- Formatter-managed whitespace, semicolons, import ordering, or trailing commas.
- “I prefer another architecture” without a concrete defect.
- Hypothetical performance issues without a likely hot path or scale evidence.
- Missing comments when names and structure are already clear.
- Alternative naming that is only personal preference.
- Test implementation details that do not reduce confidence.

## Severity downgrades

Downgrade or omit when:

- The input is not attacker-controlled.
- The path is internal-only and trusted.
- Existing checks prevent realistic abuse.
- The impact is limited, recoverable, or purely local.
- The issue is possible but no concrete trigger is visible.

## Compact finding wording

Good:

```text
This endpoint accepts `organizationId` from the body but never checks membership, so an authenticated user can read another organization's invoices.
```

Bad:

```text
Maybe consider improving auth here?
```

Good findings state the exact condition, why it matters, and how to fix it.

## No-findings output

```markdown
### ✅ Looks good

- No correctness, security, reliability, performance, or maintainability issues found in the reviewed scope.

**Verdict:** Ship it.
```
