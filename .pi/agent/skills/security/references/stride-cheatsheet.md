# STRIDE cheatsheet

Use STRIDE to identify architecture-level threats across components, data flows, trust boundaries, and agentic tool interactions.

| Threat | Security property | Definition | Questions to ask | Example mitigations |
|---|---|---|---|---|
| Spoofing | Authenticity | Pretending to be another user, service, tenant, tool, or identity | Can an attacker impersonate a user, service, webhook, package, skill, or model response? | Strong authentication, signed webhooks, service identity, token audience/issuer checks |
| Tampering | Integrity | Unauthorized modification of data, code, configuration, prompts, artifacts, or logs | Can input alter database records, configs, generated files, memory, prompts, or build artifacts? | Authorization checks, integrity checks, signed artifacts, input validation, immutable logs |
| Repudiation | Non-repudiation | Denying an action because it was not logged or attributable | Are sensitive actions audited with actor, time, target, and result? | Audit logs, request IDs, append-only logs, signed events |
| Information disclosure | Confidentiality | Exposing secrets, private data, tenant data, or internal context | Can users access another tenant’s data, logs, secrets, prompts, stack traces, or internal files? | Access control, redaction, encryption, least privilege, safe error handling |
| Denial of service | Availability | Exhausting resources or disabling service | Can attackers trigger expensive queries, infinite loops, large uploads, queue floods, or API quota burn? | Rate limits, quotas, timeouts, pagination, circuit breakers, resource caps |
| Elevation of privilege | Authorization | Gaining privileges beyond what was granted | Can a low-privilege user access admin routes, tools, filesystem, shell, or cross-tenant operations? | Server-side authorization, least privilege, scoped tokens, sandboxing, policy checks |

## STRIDE workflow

1. Identify components.
2. Identify data flows.
3. Identify trust boundaries.
4. Apply each STRIDE category to each boundary.
5. Record threats with attacker, entry point, target, impact, and mitigation.
6. Prioritize by exploitability and impact.

## Agentic-system prompts

Ask these additional questions for agents, skills, tools, and plugins:

- Can untrusted content become instructions?
- Can tool outputs override system or developer intent?
- Can a skill load remote instructions?
- Can the agent read secrets and also send network requests?
- Can generated files persist malicious instructions?
- Can memory, config, hooks, or startup scripts be modified?
- Are tool permissions scoped to the task?
- Are destructive actions gated by confirmation?

## Finding format

```text
Threat:
STRIDE category:
Asset:
Entry point:
Trust boundary:
Impact:
Mitigation:
Residual risk:
````

