---
name: writing-plans
description: Use this skill when you have requirements for a multi-step technical task but before touching any code. It enforces a TDD-based, atomic implementation plan saved to a markdown file to ensure the agent stays on track during execution.
disable-model-invocation: false
---

# Writing Plans (Architect Mode)

Write comprehensive, TDD-first implementation plans. Assume the implementer is a skilled developer who has zero context of this specific codebase. Your goal is to decompose the goal into atomic, verifiable tasks that keep the codebase "green" at every step.

## 1. Triage & Scope
- **Worktree:** Always run this in a dedicated worktree (e.g., created by brainstorming).
- **Decomposition:** If a spec covers multiple subsystems, suggest breaking it into separate plans. One plan = one testable, working feature.
- **Limits:** Max 15 steps per plan. If more are needed, split into "Phase 1" and "Phase 2".

## 2. Plan Structure & Location
**Save plans to:** `docs/superpowers/plans/YYYY-MM-DD-<feature-name>.md`

### Header Template
```markdown
# [Feature Name] Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use `superpowers:subagent-driven-development` (recommended) to implement this plan task-by-task.

**Goal:** [One sentence description]
**Architecture:** [2-3 sentences on approach and file boundaries]
**Tech Stack:** [Key libraries/tools]
---
```

## 3. The "Atomic" Task Rule
Each task must be **Atomic** (one action), **Unambiguous** (no decisions left to the coder), and **Verifiable** (clear success condition). 

**Each Task MUST follow this TDD loop:**
1.  **Step 1: Write the failing test.** (Include the exact code snippet).
2.  **Step 2: Run test to verify failure.** (Include the exact command and expected error).
3.  **Step 3: Minimal implementation.** (Include the exact code to pass the test).
4.  **Step 4: Verify pass.** (Include the command and expected output).
5.  **Step 5: Commit.** (Include the `git commit -m` command).

## 4. Hard Rules (No Placeholders)
The following are **Plan Failures**. Never include them:
- "TBD", "TODO", or "Implement later".
- "Add appropriate error handling" (Show the exact `try/catch` logic).
- "Write tests for the above" (Show the actual test code).
- References to functions or types not yet defined in the plan.
- Steps taking longer than 30 minutes. If it's long, split it.

## 5. File Mapping
Before listing tasks, map out the affected files:
- **Create:** New files with clear, single responsibilities.
- **Modify:** Existing files (use `path/to/file.ts:line-range` for context).
- **Stay Consistent:** Ensure function names used in Task 1 match Task 10.

## 6. Self-Review & Handoff
Before saving, search your plan for "red flag" placeholders. Ensure the first step is a "green check" (e.g., running existing tests) and the last step is an End-to-End verification.

**After saving, offer the user these choices:**
1.  **Subagent-Driven (Recommended):** Dispatch a fresh subagent per task for maximum reliability.
2.  **Inline Execution:** Execute tasks in the current session using `executing-plans`.

## Execution Example

### Task 1: Validation Logic
**Files:** `src/lib/validate.ts` (create), `tests/validate.test.ts` (create)

- [ ] **Step 1: Write failing test**
  ```typescript
  // tests/validate.test.ts
  test('should reject empty email', () => {
    expect(validateEmail('')).toBe(false);
  });
  ```
- [ ] **Step 2: Verify failure**
  Run: `npm test tests/validate.test.ts`. Expected: `ReferenceError: validateEmail is not defined`.
- [ ] **Step 3: Implementation**
  ```typescript
  // src/lib/validate.ts
  export const validateEmail = (email: string) => email.includes('@');
  ```
- [ ] **Step 4: Verify pass**
  Run: `npm test tests/validate.test.ts`. Expected: `1 passed`.
- [ ] **Step 5: Commit**
  `git commit -m "feat: add email validation logic"`
