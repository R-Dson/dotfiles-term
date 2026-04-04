# Security Audit Report: [Project Name]
**Date:** [Current Date]
**Assessor:** Security Guardian (pi-agent)

## Executive Summary
[Brief overview of the security posture. Highlight the "Lethal Trifecta" if found.]

## Critical Findings
| ID | Vulnerability | Location | Severity |
|:---|:---|:---|:---|
| 01 | [e.g., Remote Code Execution] | `src/api/` | Critical |

## Detailed Analysis

### [Finding ID: Name]
- **Description:** [What is the risk?]
- **Impact:** [What can an attacker achieve?]
- **PoC/Evidence:**
  ```javascript
  // Line 45: Insecure use of eval() on user input
  eval(req.body.command);
- Remediation: [Step-by-step fix]

## Supply Chain & Dependencies

- [ ] No typosquatted packages found.
- [ ] No remote instruction loading detected.
- [ ] All high-risk dependencies flagged.
