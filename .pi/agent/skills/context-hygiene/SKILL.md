---
name: context-hygiene
description: Enforces concise, high-signal responses that preserve context-window budget. Use when generating answers, summarizing research, diagnosing errors, reviewing code, returning excerpts, or handing information to another agent.
disable-model-invocation: false
---

# Context hygiene

## Purpose

Produce compact, high-signal output that preserves context-window budget without losing accuracy, evidence, or required caveats.

Treat output as a compressed handoff, not a transcript.

## When to use

Use this skill when:

- Summarizing research.
- Returning file or code excerpts.
- Diagnosing errors.
- Reviewing code.
- Reporting tool results.
- Producing implementation notes.
- Passing findings to another agent.
- Answering in a context-constrained workflow.

Do not use this skill to remove information that is necessary for correctness, safety, citations, or user decision-making.

---

## Core rules

### Remove

Do not include:

- Conversational filler.
- Long preambles.
- Repeated information from the prompt.
- Raw tool output.
- Full files when a focused excerpt is enough.
- Unnecessary apologies.
- Hedging that does not change the meaning.
- Duplicate explanations.
- Long logs without filtering.
- “In summary” sections that repeat the same content.

### Keep

Always keep:

- The direct answer.
- Required caveats.
- Evidence or source references for claims that need grounding.
- File paths and line numbers when discussing code.
- Exact commands, errors, or identifiers when they matter.
- `NOT FOUND` when a search or inspection found nothing useful.
- Confidence markers when evidence is weak.

Use confidence markers sparingly:

```text
[low confidence — one source only]
[partial — file not available]
[not verified — command not run]
````

---

## Source rules

Include a source reference when output depends on:

* Web research.
* Uploaded files.
* Repository files.
* Logs.
* Tool output.
* Version-specific facts.
* Security, legal, financial, medical, or safety-sensitive claims.

Use the most compact useful reference:

```text
file.ts:42-67
docs/api.md#authentication
<source citation>
```

For pure reasoning, source references are optional.

---

## Compression workflow

1. Identify the user’s actual question.
2. Extract only the facts needed to answer it.
3. Replace raw output with a short structured summary.
4. Include source references or file locations.
5. Add uncertainty only when it changes how the result should be used.
6. Stop after the answer is complete.

---

## Output size targets

These are soft targets. Exceed them only when accuracy, safety, or user-requested detail requires it.

| Task type             |                   Target length |
| --------------------- | ------------------------------: |
| Single fact or lookup |                       1–5 lines |
| Error diagnosis       |                     10–20 lines |
| Web research summary  |                     15–30 lines |
| Code review           |                     30–60 lines |
| Implementation plan   |                    50–100 lines |
| Full audit or report  | As short as completeness allows |

When in doubt, cut.

---

## Formatting rules

* Use headings only when they improve scanning.
* Prefer short bullets over paragraphs for findings.
* Use tables only for comparison or dense structured data.
* Use code blocks only for commands, code, logs, or exact output.
* Trim logs to the smallest useful excerpt.
* Use ellipses or comments to mark omitted irrelevant sections.
* Do not wrap ordinary prose in code blocks.

---

## Code and file excerpts

When returning code, include the path and line range when available.

Good:

```typescript
// models/user.ts:12-18
interface User {
  id: string;
  email: string;
  isActive: boolean;
}
```

For long files, return only relevant sections:

```typescript
// src/auth/session.ts:40-58
export function validateSession(token: string) {
  // relevant excerpt only
}
```

If line numbers are unavailable, include the path and section name.

---

## Tool output handling

Never paste raw output by default.

Compress tool output into:

```text
Command:
- <command>

Result:
- <key result>

Relevant output:
- <short excerpt>

Status:
- success | failed | partial | not found
```

For errors:

```text
Error:
- <exact error line>

Likely cause:
- <cause>

Fix:
- <action>

Source:
- <file, command, or citation>
```

---

## Search result handling

If search succeeds:

```text
Found:
- <answer>

Evidence:
- <source>

Caveat:
- <only if needed>
```

If search fails:

```text
NOT FOUND

Checked:
- <queries or locations>

Best next step:
- <specific follow-up>
```

Do not leave failed searches implicit.

---

## Review output

For reviews, report only actionable findings.

```text
Findings:
- <location>: <issue> — <impact> → <fix>

Looks good:
- <specific verified strength>

Verdict:
- <ship / ship after fixes / do not ship>
```

Omit “Looks good” if it adds no value.

---

## Anti-patterns

Avoid:

```text
I will now explain...
Here is the answer you asked for...
It is important to note that...
In conclusion...
As mentioned earlier...
Based on the information provided...
```

Prefer:

```text
Use `pnpm install`; the repo has `pnpm-lock.yaml`.
```

---

## Final check

Before responding, ask:

* Can any sentence be deleted without losing meaning?
* Is every caveat useful?
* Are sources included where needed?
* Is raw output summarized?
* Is the answer complete enough to act on?

