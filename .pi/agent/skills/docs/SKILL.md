---
name: docs
version: 1.1.0
description: Creates, updates, and audits developer documentation such as READMEs, API docs, tutorials, architecture docs, runbooks, ADRs, and contribution guides. Use when the user asks to document, explain, write a guide, update docs, improve a README, create API documentation, or audit documentation quality. Do not use for inline code comments or commit messages.
---

# Docs

## Purpose

Create documentation that is accurate, concise, developer-focused, maintainable, and grounded in the current codebase.

## When to use

Use this skill for:

- `README.md` files.
- API documentation.
- Tutorials and how-to guides.
- Architecture docs.
- Runbooks and operational docs.
- ADRs.
- Contributor guides.
- Documentation audits or rewrites.
- Docs folder restructuring.

Do not use this skill for:

- Inline code comments.
- Commit messages.
- Marketing copy.
- Legal, compliance, or policy documents unless the user explicitly asks for technical editing only.

---

## Required reference

Before writing or auditing documentation, load:

```text
references/style-guide.md
```

If the file is unavailable, continue with the core workflow and note that the style guide could not be loaded.

---

## Operating workflow

1. **Inspect**

   * Read existing documentation before editing.
   * Scan the codebase for technologies, entry points, package manager, commands, configuration, and relevant paths.
   * Identify existing naming, structure, and terminology.

2. **Identify audience**

   * Determine whether the reader is an end user, contributor, API consumer, operator, DevOps engineer, or security reviewer.
   * Match depth and structure to that audience.

3. **Plan**

   * Outline first for new, large, ambiguous, or structural docs.
   * For small edits, corrections, or explicit updates, proceed directly.

4. **Draft**

   * Start with what the reader can accomplish.
   * Use concrete examples and real project paths.
   * Keep the main document high-level; move deep details to `docs/` when useful.
   * Follow `references/style-guide.md`.

5. **Validate**

   * Verify paths, commands, links, examples, package-manager usage, and references.
   * Remove secrets, fake credentials that look real, stale claims, and unsupported assumptions.

6. **Report**

   * Summarize what changed.
   * Mention validation performed.
   * List assumptions, gaps, or anything that could not be verified.

---

## Planning rules

Create an outline first when:

* The document is new.
* The request affects multiple docs.
* The audience or scope is ambiguous.
* The structure needs major rework.
* The user asks for a plan or information architecture.

Use this outline format:

```text
Goal:
Audience:
Proposed sections:
Required examples:
Required diagrams:
Validation checks:
Open questions:
```

Skip the outline for small edits such as typo fixes, path updates, one-command additions, or targeted README corrections.

---

## Validation checklist

Before finalizing documentation, verify:

* Referenced files and directories exist.
* Commands match the detected package manager.
* Internal Markdown links resolve.
* External links are current when accuracy matters.
* Code snippets use real APIs, options, imports, and paths.
* Examples are copy-pasteable where practical.
* Headings are consistent and scannable.
* No secrets, credentials, private data, or production tokens are included.
* Claims match the current codebase.
* New docs are placed in the right location.

Package-manager detection:

```text
pnpm-lock.yaml     -> pnpm
yarn.lock          -> yarn
bun.lockb          -> bun
package-lock.json  -> npm
```

When multiple lockfiles exist, report the ambiguity instead of guessing.

---

## Output contract

When returning documentation work, include:

```text
Changed:
- <files or sections changed>

Validated:
- <checks performed>

Notes:
- <assumptions, gaps, or follow-up items>
```

When the user asks for the full document, output the complete updated document in a Markdown code block.

When the user asks for a review, summarize issues first, then provide revised content.
