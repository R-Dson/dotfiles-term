---
name: context
description: Enforces concise, high-signal responses that preserve context-window budget. Use when generating answers, summarizing research, diagnosing errors, reviewing code, returning excerpts, or handing information to another agent.
disable-model-invocation: false
---

# Context

## Purpose

Produce compact, high-signal output without losing accuracy, evidence, required caveats, or user decision points. Treat output as a compressed handoff, not a transcript.

## When to use

Use for summaries, tool results, excerpts, diagnostics, code reviews, implementation notes, and context-constrained answers.

Do not remove information needed for correctness, safety, citations, or user decisions.

## Core rules

Remove:

- Conversational filler, long preambles, apologies, and repeated prompt content.
- Raw tool output and long logs.
- Full files when a focused excerpt is enough.
- Duplicate explanations and empty “in summary” sections.
- Hedging that does not change the meaning.

Keep:

- Direct answer.
- Required caveats.
- File paths, line numbers, exact commands, errors, and identifiers when relevant.
- Evidence or source references for claims that need grounding.
- `NOT FOUND` when inspection/search found nothing useful.
- Confidence markers when evidence is weak: `[low confidence]`, `[partial]`, `[not verified]`.

## Source rules

Include compact source references for claims based on web research, repository files, logs, tool output, version-specific facts, or high-stakes topics.

Examples:

```text
file.ts:42-67
docs/api.md#authentication
<source citation>
```

For pure reasoning, source references are optional.

## Compression workflow

1. Identify the user’s actual question.
2. Extract only facts needed to answer it.
3. Replace raw output with a structured summary.
4. Include sources or file locations.
5. Add uncertainty only when it changes how the answer should be used.
6. Stop after the answer is complete.

## Output size targets

| Task type | Target length |
|---|---:|
| Single fact or lookup | 1–5 lines |
| Error diagnosis | 10–20 lines |
| Web research summary | 15–30 lines |
| Code review | 30–60 lines |
| Implementation plan | 50–100 lines |
| Full audit/report | As short as completeness allows |

Exceed targets only when accuracy, safety, or user-requested detail requires it.

## Formatting rules

- Use headings only when they improve scanning.
- Prefer short bullets over paragraphs.
- Use tables only for dense comparison.
- Use code blocks only for commands, code, logs, or exact output.
- Trim logs to the smallest useful excerpt.
- Do not wrap ordinary prose in code blocks.

## Code and tool output

When returning code, include path and line range when available:

```typescript
// models/user.ts:12-18
interface User {
  id: string;
  email: string;
}
```

Summarize tool output instead of pasting raw output:

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

For failed searches:

```text
NOT FOUND

Checked:
- <queries or locations>

Best next step:
- <specific follow-up>
```

## Output contract

For reviews, report only actionable findings:

```text
Findings:
- <location>: <issue> — <impact> → <fix>

Verdict:
- <ship / ship after fixes / do not ship>
```

## Final check

Before responding, ask:

- Can any sentence be deleted without losing meaning?
- Are sources included where needed?
- Is raw output summarized?
- Is the answer complete enough to act on?
