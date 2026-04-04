# STRIDE Reference for Agents

| Threat | Security Property | Definition | Agent Context |
|:---|:---|:---|:---|
| **S**poofing | Authenticity | Pretending to be something/someone else | Malicious skills pretending to be "official" tools. |
| **T**ampering | Integrity | Modifying code or data | A skill modifying the agent's `MEMORY.md` to persist an attack. |
| **R**epudiation | Non-repudiability | Claiming you didn't do an action | Agents performing actions without audit logs. |
| **I**nfo Disclosure | Confidentiality | Leaking sensitive data | Plaintext API keys in the LLM context window. |
| **D**enial of Service | Availability | Breaking the system | Recursive agent loops that consume all API credits/CPU. |
| **E**levation of Privilege | Authorization | Gaining unauthorized access | Using an agent's shell tool to read `~/.ssh/id_rsa`. |
