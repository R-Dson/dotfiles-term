---
name: security
description: Performs application security reviews, OWASP-style vulnerability checks, STRIDE threat modeling, secret exposure checks, and supply-chain risk assessments. Use when asked to audit a repo, review a PR for vulnerabilities, check security risks, threat model a feature, or find exploitable security flaws. Do not use for generic bug fixing, style linting, or non-security code review.
disable-model-invocation: false
---

# Security

## Purpose

Identify real, exploitable security risks in code, configuration, architecture, dependencies, and agentic workflows. Prioritize by attacker reachability, business impact, and evidence. Avoid speculative noise.

## When to use

Use for repository security audits, PR vulnerability reviews, threat modeling, authn/authz review, input validation and injection review, secret exposure checks, dependency/supply-chain review, agentic tool/skill security review, and untrusted-input data-flow review.

Do not use for generic bug fixing, style review, performance tuning unless it creates denial-of-service risk, compliance certification, or penetration-testing claims unless actual testing was performed.

## Required references

Load as needed:

```text
references/stride-cheatsheet.md
references/supply-chain-vets.md
```

For full audit reports, use:

```text
assets/security-report.md
```

## Core rules

- Do not output raw secrets, tokens, passwords, cookies, private keys, credentials, production connection strings, authorization headers, or webhook secrets. Replace values with `[REDACTED]`.
- Report vulnerabilities only with a reachable path from entry point to sink or a concrete unsafe configuration/dependency/secret exposure.
- Do not mark theoretical issues as Critical.
- Separate confirmed findings from risks, assumptions, and hardening recommendations.
- Provide actionable remediation for every finding.
- Never provide exploit instructions beyond what is needed to demonstrate impact safely.

## Operating workflow

1. **Discover** — identify languages, frameworks, dependency managers, deployment targets, manifests, CI, Docker/IaC, auth, data stores, jobs, integrations, and tool permissions.
2. **Map attack surface** — locate entry points, trust boundaries, sensitive data, and privileged operations.
3. **Trace dangerous flows** — follow untrusted input to execution, persistence, network calls, auth decisions, deserialization, templates, logs, or external tools.
4. **Audit vulnerabilities** — check relevant OWASP categories, STRIDE risks, dependencies, build tooling, and agent/tool permissions.
5. **Assign severity** — classify by exploitability, impact, privileges required, user interaction, and blast radius; downgrade unrealistic or unreachable issues.
6. **Report** — use the report template for full audits; for PRs, provide concise severity-grouped findings with evidence, impact, and remediation.

## Tactical checklist

Check categories relevant to the scope; do not report categories as clean unless a full checklist report is requested.

- **Access control/auth:** missing route authorization, IDOR, tenant isolation failure, UI-only role checks, session/token weaknesses, predictable/reusable password-reset/invite/magic-link tokens.
- **Injection/execution:** SQL/NoSQL/LDAP/template/shell injection, unsafe `eval`/`Function`/`exec`/`spawn`/dynamic imports, unsafe template rendering, missing parameterization, unsafe path construction.
- **SSRF/network:** server-side fetches to user URLs, missing allowlists, metadata/localhost/private-IP access, redirect validation bypasses, risky importers/previewers/image processors/webhooks.
- **Data protection/crypto:** secrets or PII in logs/errors/API responses, weak password hashing, missing TLS where relevant, hardcoded crypto keys, weak randomness, missing rotation.
- **Deserialization/integrity:** unsafe `pickle`, unsafe `yaml.load`, Java/PHP object injection equivalents, unsigned plugins/updates/artifacts/model files, remote dynamic code loading.
- **Misconfiguration:** production debug mode, credentialed CORS with broad origins, public admin routes, verbose errors, missing rate limits on sensitive/expensive endpoints, exposed `.git`/backups/build artifacts.
- **Agentic/tool risks:** prompt injection reaching tools, untrusted content influencing filesystem/shell/browser/email/network actions, tool results treated as instructions, skills/plugins reading secrets with exfiltration paths, remote instruction loading, hidden persistence.

## STRIDE review

Use STRIDE for architecture-level reviews and new integrations:

```text
Spoofing: Can attackers impersonate users, services, tenants, tools, or skills?
Tampering: Can they modify data, code, config, prompts, artifacts, or logs?
Repudiation: Are sensitive actions auditable and attributable?
Information disclosure: Can secrets, PII, tenant data, or internal context leak?
Denial of service: Can they exhaust CPU, memory, storage, quota, or workers?
Elevation of privilege: Can low privilege gain higher privilege or tool access?
```

Load `references/stride-cheatsheet.md` for detailed prompts.

## Supply-chain review

Load `references/supply-chain-vets.md` when reviewing new dependencies, lockfile changes, build scripts, package manager config, CI/CD actions, Docker images, agent skills, plugins, MCP servers, or tool integrations.

Check typosquatting, dependency confusion, unknown/recently transferred maintainers, suspicious install scripts, native binaries/FFI, dynamic code execution, unnecessary network access, abandoned packages, missing lockfiles/unpinned deps, and unexpected CI/package permissions.

## Severity model

| Severity | Use when | Action |
|---|---|---|
| 🔴 Critical | Directly exploitable with severe impact and little/no chaining: auth bypass, reachable SQLi/RCE, cross-tenant data exposure, hardcoded production credential with impact, arbitrary file read/write, payment/admin compromise | Block release/merge |
| 🟠 High | Realistic exploitation with meaningful impact but conditions/privileges/chaining: SSRF to internal services, stored XSS in privileged workflow, auth-gated insecure deserialization, broad sensitive logs, severe reachable dependency vuln | Fix before release/merge unless risk accepted |
| 🟡 Medium | Valid weakness with constrained exploitability, limited impact, or prerequisites: lower-risk missing rate limit, verbose limited error, unconfirmed dependency reachability, low-impact CSRF | Fix soon or track with owner/date |
| 🔵 Low | Defense-in-depth or hygiene: minor header improvement, local-only debug detail, low-risk dependency maintenance, documentation/policy gap | Fix opportunistically |

Assign severity by exploitability × impact, not keyword matching.

## Evidence requirements

Each finding must include:

```text
Entry point:
Sink or vulnerable behavior:
Reachability:
Impact:
Evidence:
Remediation:
Severity:
Confidence:
```

Do not report a finding if you cannot identify a reachable vulnerable path or concrete unsafe configuration/dependency/secret exposure. Use “Risk” or “Hardening recommendation” for plausible but unconfirmed issues.

## Safe reporting

If a secret appears in code, report the file and variable name, not the value. Use placeholders such as `[REDACTED_SECRET]`, `[REDACTED_TOKEN]`, or `[REDACTED_PRIVATE_KEY]`. Recommend rotation/revocation and history cleanup when a real secret may have been committed.

Avoid raw exploit payloads unless explicitly needed for an authorized safe proof. Prefer sanitized demonstrations.

## Output contract

Concise PR security review:

```text
Security findings:

### 🔴 Critical
- <finding>

### 🟠 High
- <finding>

### 🟡 Medium
- <finding>

### 🔵 Low
- <finding>

No findings:
- <areas checked>

Verdict:
- <ship / ship after fixes / do not ship>
```

For full audits, use `assets/security-report.md`. Every finding must include location, evidence, impact, and remediation.
