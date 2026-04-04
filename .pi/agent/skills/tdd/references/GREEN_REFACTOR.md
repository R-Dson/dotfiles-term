# Green & Refactor Phase Procedures

## 1. The Green Phase (Implementation)
The goal is to move from Red to Green as quickly as possible.

### Tactics:
- **Minimalism**: Write only the code required to make the test pass. If you can make it pass by returning a hardcoded value (and that satisfies the current test), do it. You will generalize it with the next test.
- **Stay in Scope**: Do not fix unrelated bugs or add extra features you "know" you will need later.
- **Verification**: Run the specific test command frequently.

### Transition:
Once the test passes, you are in the "Green" state. Do not move to the next feature until you have Refactored.

---

## 2. The Refactor Phase (Cleanup)
The goal is to improve the internal structure of the code without changing its external behavior.

### Rules:
- **Always Green**: If a test fails during refactoring, you have broken the behavioral contract. Undo and try a smaller step.
- **DRY (Don't Repeat Yourself)**: Look for duplication introduced during the "Green" phase.
- **Naming**: Ensure variable and function names clearly describe their intent.
- **Consistency**: Ensure the new code matches the project's existing patterns (e.g., error handling style, async/await vs promises).

### Red Flags (What to remove):
- Hardcoded values used for "faking it" in the Green phase.
- Comments that explain "what" the code does (the code should be self-explanatory).
- Large functions that can be broken into smaller, testable units.

## 3. Git Checkpoint
After achieving a clean Green state:
- Stage your changes: `git add .`
- Commit with a descriptive message: `feat: implement <feature_name> and refactor logic`
