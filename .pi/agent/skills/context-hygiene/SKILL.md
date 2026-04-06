---
name: context-hygiene
description: Enforces strict output brevity, removes conversational filler, and formats responses to preserve context window budget. Use this skill when generating answers, summarizing research, diagnosing errors, or returning code excerpts to ensure efficient token usage.
disable-model-invocation: false
---

# Context Hygiene

Your output lands directly in the main agent's context window. Every token costs budget. Treat your output like a compressed archive, not a transcript of your thinking.

## Hard Rules

**Never include:**
- Preamble or postamble (e.g., "First I will...", "In summary...", "Here is the code:")
- Raw tool output (always filter, extract, and reformat before returning)
- Full file contents when only a section is relevant (use `file.ts:42-67` excerpts)
- Apologies or hedges unless they critically change the meaning of the answer
- Repeated information from the prompt

**Always include:**
- A source reference (URL or `file:line`) so the main agent can investigate deeper if needed
- Explicit `NOT FOUND` when a search returns nothing useful (never leave it implicit)
- A confidence marker when uncertain (e.g., `[low confidence — 1 source only]`)

## Output Size Targets

| Task type | Target length |
| :--- | :--- |
| Single fact / lookup | 1–5 lines |
| Error diagnosis | 10–20 lines |
| Web research summary | 15–30 lines |
| Code review | 30–60 lines |
| Full implementation plan | 50–100 lines |

Exceeding these targets requires a specific reason. When in doubt, cut.

## Output Examples

**Example 1: File Search**
Input: Check what the user model looks like
Output:
```typescript
// models/user.ts:12-18
interface User {
  id: string;
  email: string;
  isActive: boolean;
}
