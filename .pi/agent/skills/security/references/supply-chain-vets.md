# Supply-chain vetting criteria

Use this reference to evaluate dependencies, build tools, CI actions, containers, agentic skills, plugins, MCP servers, and other third-party components.

## Review targets

Check:

- Package manifests.
- Lockfiles.
- Build scripts.
- Install scripts.
- CI/CD workflows.
- Docker images.
- GitHub Actions.
- Binary downloads.
- Agent skills and plugins.
- MCP servers and tool integrations.

## High-risk patterns

Flag for review when a dependency or tool has one or more of these patterns.

### Maintainer and project risk

- Unknown or anonymous maintainer with little ecosystem history.
- Recent ownership transfer.
- Single maintainer for critical package.
- No releases or commits for more than 24 months while issues remain active.
- Many unresolved security issues.
- Sudden major behavior change in a minor or patch release.
- Repository archived or package deprecated.
- Package name resembles a popular package.

### Install and build risk

- `postinstall`, `preinstall`, or install-time scripts.
- Downloads binaries during install.
- Runs shell commands during install.
- Uses obfuscated, minified, or generated code in source package.
- Build artifacts differ from source without explanation.
- Missing or changed lockfile.
- Unpinned dependencies in production or CI.

### Runtime risk

- Native code, FFI, or precompiled binaries.
- Dynamic code execution with `eval`, `Function`, `exec`, dynamic import, or shell commands.
- Network access in a package that should be local-only.
- Filesystem access outside expected paths.
- Credential, token, or environment-variable access.
- Deserialization of untrusted data.
- Telemetry or analytics not documented.

### Agentic risk

- Remote instruction loading.
- Prompt templates pulled from untrusted sources.
- Tool definitions with broad filesystem, shell, browser, email, calendar, or network permissions.
- Ability to read secrets and exfiltrate data.
- Self-modifying skills or memory files.
- Hidden persistence through generated config, hooks, or startup scripts.

---

## Lethal trifecta

Treat a component as high risk when it combines these capabilities:

1. Access to sensitive data or secrets.
2. Ability to transform instructions into tool actions or code execution.
3. Ability to exfiltrate data through network, logs, email, webhooks, artifacts, or PR comments.

For dependencies, also flag combinations of:

1. Native code or FFI.
2. Network access.
3. Execution context such as `eval`, `exec`, dynamic import, shell, or plugin loading.

---

## Vetting procedure

1. **Identify**
   - Extract direct dependencies from manifests and lockfiles.
   - Identify added, removed, or version-changed packages.

2. **Classify**
   - Runtime dependency.
   - Development dependency.
   - Build or CI dependency.
   - Transitive dependency.
   - Agentic tool or plugin.

3. **Check metadata**
   - Maintainer.
   - Repository.
   - Release cadence.
   - Recent ownership changes.
   - Known advisories.
   - License.
   - Download/install behavior.

4. **Inspect capabilities**
   - Search for native bindings, install scripts, network calls, dynamic execution, filesystem access, and secret access.

5. **Assess reachability**
   - Determine whether vulnerable or risky code is used in production, build, CI, or only unused paths.

6. **Report**
   - Confirmed reachable issue: security finding.
   - Plausible but unconfirmed issue: supply-chain risk.
   - Low-impact hygiene issue: hardening recommendation.

---

## Useful commands

Use the project’s package manager and ecosystem tools when available.

### JavaScript and TypeScript

```bash
npm audit
npm view <package> repository maintainers time version
npm view <package> scripts
pnpm audit
yarn npm audit
````

### Python

```bash
pip-audit
python -m pip show <package>
pip index versions <package>
```

### Go

```bash
go list -m all
govulncheck ./...
```

### Rust

```bash
cargo audit
cargo tree
```

### GitHub repository checks

```bash
gh repo view <owner>/<repo>
gh issue list --repo <owner>/<repo> --state open --label security
```

---

## Severity hints

| Pattern                                                          | Typical severity       |
| ---------------------------------------------------------------- | ---------------------- |
| Known exploited vulnerability in reachable production dependency | 🔴 Critical or 🟠 High |
| Malicious package or typosquat in dependency tree                | 🔴 Critical            |
| Install script with unexplained network download                 | 🟠 High                |
| Native binary in critical package without provenance             | 🟡 Medium or 🟠 High   |
| Abandoned package with no reachable vulnerability                | 🔵 Low or 🟡 Medium    |
| Missing lockfile                                                 | 🟡 Medium              |
| Minor outdated package without known vulnerability               | 🔵 Low                 |

Severity still depends on reachability and impact.

