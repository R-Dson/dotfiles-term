# Verification Gate

Before you announce "I'm done," you must complete this checklist.

## 1. Technical Check
- [ ] **Confirmed Red**: I have seen the test fail for the right reason.
- [ ] **Confirmed Green**: The specific test passes.
- [ ] **Regression Check**: The broader suite (e.g., `npm test`) passes.
- [ ] **No Placeholders**: I have removed all `expect(true).toBe(true)` or `// TODO` tests.
- [ ] **Coverage**: New logic has significant coverage (aim for 90%+ for new logic).

## 2. Intent Check
- [ ] Does the implementation solve the *actual* user problem, or did I just "game" the test assertions?
- [ ] Have I handled the "Negative Path" (e.g., what happens if the API returns 404 or input is null)?

## 3. Final Artifact Review
- Run `git diff` or review the edited files.
- Ensure no debugging `console.log` or `print()` statements are left in the code.
- Ensure naming follows the project's style guide.
