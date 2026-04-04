# Red Phase Procedures

## 1. Requirement Analysis
- Identify the "Happy Path" and at least two edge cases.
- If requirements are ambiguous, log an `ASSUMPTION: [text]` line in your plan.

## 2. Test Authoring (Subagent Mode)
If the user or system supports subagents, use the role `tdd_test_writer`:
- **Task**: Write tests only. Do not modify `src/` (except for necessary exports).
- **Goal**: Produce a failing test that captures the specific bug or feature.

## 3. The RED Handoff Template
Once the test is written and confirmed failing, output this block to signal the "Contract":

---
## TDD RED PHASE COMPLETE
- **Subagent**: [tdd_test_writer / manual]
- **Test Files**: `[path/to/test]`
- **Verification Command**: `[exact shell command]`
- **Failure Reason**: `[Expected X, got Y]`

### Implementation Contract
1. **Immutable**: Do not modify these tests during the Green phase.
2. **Scope**: Implement changes only in: `[paths]`
3. **Completion Gate**: Task is done only when `[command]` passes with no test weakening.
---
