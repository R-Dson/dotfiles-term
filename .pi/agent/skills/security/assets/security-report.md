# Security audit report: <project name>

**Date:** <YYYY-MM-DD>  
**Assessor:** Security Guardian  
**Scope:** <repository, PR, feature, files, or system boundary>

## Executive summary

<Brief overview of the security posture, highest risks, and whether any lethal-trifecta or toxic-flow patterns were found.>

## Verdict

<Ship / ship after fixes / do not ship>

## Scope reviewed

- <files, modules, services, dependencies, or configs reviewed>

## Attack surface

### Entry points

- <API routes, webhooks, CLI args, uploads, queues, tools, plugins>

### Sensitive assets

- <secrets, PII, tokens, tenant data, payment data, files, admin actions>

### Trust boundaries

- <browser to server, public API to service, tool to shell, tenant boundary>

## Findings summary

| ID | Severity | Vulnerability | Location | Status |
|---|---|---|---|---|
| SG-001 | 🔴 Critical | <name> | `<path>` | Open |

## Detailed findings

### SG-001: <finding name>

**Severity:** 🔴 Critical | 🟠 High | 🟡 Medium | 🔵 Low  
**Confidence:** High | Medium | Low  
**Location:** `<file>:<line-range>`  
**Category:** <OWASP / STRIDE / supply-chain category>

#### Description

<What is wrong?>

#### Evidence

```text
<Sanitized code path, configuration, or dependency evidence. Do not include raw secrets.>
````

#### Reachability

```text
Entry point: <where attacker-controlled input enters>
Sink: <dangerous operation or exposed asset>
Path: <short trace from entry to sink>
```

#### Impact

<What can an attacker achieve?>

#### Remediation

<Specific secure-by-default fix. Include safe code guidance where useful.>

#### Verification

<How to confirm the fix works.>

---

## STRIDE summary

| STRIDE category        | Relevant? | Notes   |
| ---------------------- | --------: | ------- |
| Spoofing               |    Yes/No | <notes> |
| Tampering              |    Yes/No | <notes> |
| Repudiation            |    Yes/No | <notes> |
| Information disclosure |    Yes/No | <notes> |
| Denial of service      |    Yes/No | <notes> |
| Elevation of privilege |    Yes/No | <notes> |

## Supply-chain and dependencies

* [ ] Lockfiles reviewed.
* [ ] New dependencies reviewed.
* [ ] Install scripts checked.
* [ ] Native binaries or FFI checked.
* [ ] Typosquatting risk checked.
* [ ] Known vulnerable packages checked.
* [ ] Suspicious maintainer or ownership changes checked.

### Notes

* <dependency findings or “No material supply-chain findings in reviewed scope.”>

## Secrets review

* [ ] No raw secrets found in reviewed files.
* [ ] No secrets printed in logs.
* [ ] No credentials included in examples or fixtures.
* [ ] Secret-management path is documented or inferred.

### Redacted findings

* `<file>:<line>` — <description using `[REDACTED]`>

## No findings in reviewed areas

* <areas checked with no material findings>

## Assumptions and limitations

* <files not reviewed, checks not run, unavailable runtime context, or uncertainty>

## Recommended next steps

1. <highest priority fix>
2. <verification step>
3. <follow-up hardening item>

