# Supply Chain Vetting Criteria & Risk Patterns

Use this reference to evaluate the health of third-party dependencies and agentic skills.

## 1. High-Risk Maintainer Profiles
Flag dependencies that meet these "Red Flag" criteria:
- **Anonymous Maintainers:** Accounts with no linked real-world identity, professional website, or history in the ecosystem.
- **Recent Ownership Transfers:** Packages that have suddenly changed maintainers in the last 6 months (potential "backstabber" pattern).
- **Single Point of Failure:** Packages with only one maintainer and no organizational backing (e.g., not under Apache, PSF, or a verified corporate org).
- **Inactivity:** No commits or releases in >24 months while having a high number of open security issues.

## 2. Technical "Toxic" Indicators (The Lethal Trifecta)
A dependency or skill is considered "High Risk" if it combines two or more of the following:
1. **FFI / Native Code:** Uses Foreign Function Interfaces (FFI) or pre-compiled binaries that bypass high-level language security.
2. **Network Access:** Requests `fetch`, `curl`, or socket access in a context where it should be a pure utility.
3. **Execution Context:** Uses `eval()`, `exec()`, or dynamic `import()` on data derived from external/untrusted sources.

## 3. The "Vetted" Exceptions (Low Risk)
Maintainers who are prolific and verified. While they should still be audited, they are considered "community-vetted":
- **Individual:** `sindresorhus`, `tj`, `lucas-clemente`, `mafintosh`.
- **Organizations:** `google`, `facebook`, `microsoft`, `ant-design`, `vercel`, `trailofbits`.

## 4. Supply Chain Check Procedure
1. **Identify:** Extract all direct dependencies from the manifest (`package.json`, etc.).
2. **Query:** Use `npm view [pkg] author` or `gh repo view` to check metadata.
3. **Analyze:** Check if the package implements "Sharp Edges" like custom deserialization or shell execution.
4. **Compare:** Verify against known malicious patterns (e.g., typosquatting `request` vs `requesst`).
