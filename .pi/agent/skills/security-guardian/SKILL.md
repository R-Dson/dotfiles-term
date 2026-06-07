---
name: security-guardian
description: Performs application security reviews, OWASP-style vulnerability checks, STRIDE threat modeling, secret exposure checks, and supply-chain risk assessments. Use when asked to audit a repo, review a PR for vulnerabilities, check security risks, threat model a feature, or find exploitable security flaws. Do not use for generic bug fixing, style linting, or non-security code review.
disable-model-invocation: false
---

# Security guardian

## Purpose

Identify real, exploitable security risks in code, configuration, architecture, and dependencies. Prioritize findings by attacker reachability, business impact, and evidence. Avoid speculative noise.

## When to use

Use this skill for:

- Repository security audits.
- Pull request vulnerability reviews.
- Threat modeling.
- Authentication and authorization review.
- Input validation and injection review.
- Secret exposure checks.
- Dependency and supply-chain review.
- Agentic tool, plugin, or skill security review.
- Data-flow review from untrusted input to sensitive sink.

Do not use this skill for:

- Generic bug fixing.
- Style or formatting review.
- Performance tuning unless it creates denial-of-service risk.
- Full compliance certification.
- Penetration testing claims unless actual testing was performed.

---

## Required references

Load these references as needed:

```text
references/stride-cheatsheet.md
references/supply-chain-vets.md
````

Use this asset for security audit reports:

```text
assets/security-report.md
```

---

## Core rules

* Do not output raw secrets, tokens, passwords, cookies, private keys, or credentials. Replace them with `[REDACTED]`.
* Report vulnerabilities only when there is a reachable path from entry point to sink or a clear misconfiguration.
* Do not mark theoretical issues as Critical.
* Prefer evidence from code, configuration, dependency metadata, or documented architecture.
* Provide actionable remediation for every finding.
* Separate confirmed findings from risks, assumptions, and recommended hardening.
* Never provide exploit instructions beyond what is needed to demonstrate impact safely.

---

## Operating workflow

1. **Discover**

   * Identify languages, frameworks, dependency managers, deployment targets, and security-relevant configuration.
   * Find manifests such as `package.json`, `pnpm-lock.yaml`, `requirements.txt`, `pyproject.toml`, `go.mod`, `Cargo.toml`, `Dockerfile`, CI files, and infrastructure config.
   * Map authentication, authorization, data stores, background jobs, external integrations, and agent/tool permissions.

2. **Map attack surface**

   * Locate entry points: API routes, webhooks, forms, file uploads, CLI arguments, queues, scheduled jobs, RPC handlers, browser messages, plugins, and agent tools.
   * Identify trust boundaries.
   * Trace sensitive data: secrets, credentials, PII, payment data, tokens, session data, tenant IDs, and authorization context.

3. **Trace dangerous flows**

   * Follow untrusted input to sensitive sinks.
   * Look for “toxic flows” where input reaches execution, persistence, network calls, authorization decisions, deserialization, templates, logs, or external tools.
   * Flag “lethal trifecta” patterns where untrusted input combines with tool access and data exfiltration paths.

4. **Audit vulnerabilities**

   * Review relevant OWASP categories.
   * Apply STRIDE to architecture-level risks.
   * Review supply-chain risks for dependencies, build tooling, and agentic skills.

5. **Assign severity**

   * Classify by exploitability, impact, privileges required, user interaction, and blast radius.
   * Downgrade issues that require unrealistic conditions or lack a reachable path.

6. **Report**

   * Use the security report template for full audits.
   * For PR reviews, provide concise findings grouped by severity.
   * Include evidence, impact, and remediation for each finding.

---

## Tactical vulnerability checklist

Use this checklist during code review. Do not report categories as clean to the user unless the audit scope requires a full checklist report.

### Access control and authentication

Check for:

* Missing route or endpoint authorization.
* Horizontal privilege escalation through user-controlled IDs.
* Tenant isolation failures.
* Insecure direct object references.
* Role checks performed only in the UI.
* Session fixation or missing logout/session invalidation.
* JWTs with weak secrets, missing expiry, unsafe algorithms, or missing audience/issuer validation.
* Password reset, invite, or magic-link tokens that are predictable, reusable, or not expired.

### Injection and command execution

Check for:

* SQL, NoSQL, LDAP, template, expression-language, or shell injection.
* User input passed to `eval`, `Function`, `exec`, `spawn`, dynamic imports, or interpreters.
* Unsafe template rendering.
* Missing parameterization.
* Unsafe path construction.

### SSRF and network access

Check for:

* Server-side fetches to user-controlled URLs.
* Missing allowlists for outbound requests.
* Access to metadata services, localhost, private IP ranges, or internal admin services.
* Redirect handling that bypasses validation.
* Webhook fetchers, importers, preview generators, image processors, and URL validators.

OWASP describes SSRF as a flaw where an application fetches a remote resource without validating a user-supplied URL, letting attackers coerce server-side requests to unexpected destinations. ([OWASP Foundation][2])

### Data protection and crypto

Check for:

* Secrets, tokens, cookies, or PII in logs, errors, analytics, or API responses.
* Passwords hashed with MD5, SHA1, unsalted hashes, or reversible encryption.
* Missing TLS enforcement where relevant.
* Hardcoded crypto keys.
* Weak random number generation for security tokens.
* Missing key rotation or secret-management path.

OWASP flags cryptographic failures such as default crypto keys, weak keys, missing key management or rotation, and crypto keys checked into source repositories. ([OWASP Foundation][3])

### Deserialization and integrity

Check for:

* Unsafe deserialization of untrusted data.
* `pickle`, unsafe `yaml.load`, Java serialization, PHP object injection, or equivalent.
* Unsigned or unverified plugins, updates, artifacts, model files, or scripts.
* Dynamic code loading from remote or user-controlled sources.
* Missing integrity checks for downloaded artifacts.

### Insecure defaults and misconfiguration

Check for:

* Debug mode enabled in production.
* Credentialed CORS with broad origins.
* Public admin routes.
* Verbose error pages.
* Missing security headers where relevant.
* Open `0.0.0.0` bindings for admin services.
* Missing rate limits on login, reset, invitation, upload, or expensive endpoints.
* Directory listing, exposed `.git`, backups, or build artifacts.

### Agentic and tool-use risks

Check for:

* Prompt or instruction injection reaching tools.
* Untrusted content influencing shell, filesystem, browser, email, calendar, or network actions.
* Tool results treated as trusted instructions.
* Skills or plugins that can read secrets and exfiltrate data.
* Remote instruction loading without trust boundaries.
* Hidden persistence through memory files, config files, hooks, startup scripts, or generated skills.
* Unsafe combination of untrusted input, tool access, and outbound network access.

---

## STRIDE review

Use STRIDE for architecture-level review, especially when evaluating a new feature, integration, or agentic workflow.

Ask:

```text
Spoofing: Can an attacker pretend to be another user, service, tenant, tool, or skill?
Tampering: Can an attacker modify data, code, config, prompts, artifacts, or logs?
Repudiation: Are sensitive actions auditable and attributable?
Information disclosure: Can secrets, PII, tenant data, or internal context leak?
Denial of service: Can an attacker exhaust CPU, memory, storage, API quota, or worker capacity?
Elevation of privilege: Can a low-privilege user gain higher privileges or tool access?
```

Use `references/stride-cheatsheet.md` for the full reference.

---

## Supply-chain review

Use `references/supply-chain-vets.md` when reviewing:

* New dependencies.
* Lockfile changes.
* Build scripts.
* Package manager configuration.
* CI/CD actions.
* Docker images.
* Agent skills, plugins, MCP servers, or tool integrations.

Check for:

* Typosquatting.
* Dependency confusion.
* Unknown or recently transferred maintainers.
* Suspicious install scripts.
* Native binaries or FFI.
* Dynamic code execution.
* Unnecessary network access.
* Abandoned packages with security issues.
* Missing lockfiles or unpinned dependencies.
* Unexpected permissions in CI or package scripts.

OWASP SCVS focuses on activities, controls, and best practices for reducing software supply-chain risk, and OWASP’s Software Supply Chain Security Cheat Sheet frames software supply chains as the steps that create, transform, and assess software artifacts. ([OWASP Foundation][4])

---

## Severity model

Assign severity by exploitability and impact, not by keyword matching.

### 🔴 Critical

Directly exploitable issue with severe impact and little or no chaining required.

Examples:

* Authentication bypass.
* Authorization bypass exposing other users’ data.
* SQL injection on a reachable endpoint.
* Remote code execution.
* Hardcoded production credential with reachable impact.
* Arbitrary file read/write through a public endpoint.
* Payment, billing, or admin privilege compromise.

Action: block release or merge.

### 🟠 High

Realistic exploitation with meaningful impact, but requires some conditions, privileges, or limited chaining.

Examples:

* SSRF with access to internal services but no confirmed credential exposure.
* Stored XSS in privileged admin workflow.
* Insecure deserialization behind authentication.
* Sensitive logs exposed to broad internal audience.
* Missing tenant check on non-critical data.
* Dependency with known severe vulnerability in a reachable path.

Action: fix before release or merge unless risk is explicitly accepted.

### 🟡 Medium

Valid security weakness with constrained exploitability, limited impact, or significant prerequisites.

Examples:

* Missing rate limit on a lower-risk endpoint.
* Weak security header on non-sensitive page.
* Verbose error message with limited information.
* Dependency risk not confirmed reachable.
* CSRF risk on low-impact action.

Action: fix soon or track with owner and due date.

### 🔵 Low

Defense-in-depth issue, hardening recommendation, or low-impact hygiene problem.

Examples:

* Minor security-header improvement.
* Non-sensitive debug detail in local-only context.
* Low-risk dependency maintenance issue.
* Documentation or policy gap.

Action: fix opportunistically.

---

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

Do not report a finding if you cannot identify either:

* A reachable vulnerable path, or
* A concrete unsafe configuration, dependency, or secret exposure.

Use “Risk” or “Hardening recommendation” for issues that are plausible but not confirmed.

---

## Safe reporting rules

Do not include raw exploit payloads that enable harm unless the user explicitly needs a safe internal proof and the context is authorized. Prefer sanitized demonstrations.

Never output:

```text
API keys
Access tokens
Refresh tokens
Session cookies
Private keys
Passwords
Production connection strings
Authorization headers
Webhook signing secrets
```

Use:

```text
[REDACTED_SECRET]
[REDACTED_TOKEN]
[REDACTED_PRIVATE_KEY]
```

If a secret appears in code, report the file and variable name, not the value.

---

## Output contract

For a concise PR security review:

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

For a full audit, use:

```text
assets/security-report.md
```

Every finding must include location, evidence, impact, and remediation.
