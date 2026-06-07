---
name: research
description: Firecrawl-first workflow for web search, documentation lookup, error debugging, source verification, comparisons, and cited technical research. Use when current, niche, version-specific, or externally verifiable information is needed.
disable-model-invocation: false
---

# Research

## Purpose

Find accurate, current, high-signal information with minimal browsing. Prefer primary sources, scrape only useful pages, cite evidence, and separate facts from inference.

## When to use

Use this skill for:

- Web search or Firecrawl use.
- Official documentation, API, changelog, release, or migration lookup.
- Version-specific behavior or known error messages.
- Technical comparisons and recommendations.
- Ecosystem/community-signal checks.
- Security, legal, medical, financial, production, or compliance-sensitive verification.
- Deep research briefs.

Do not use when the answer is fully contained in local/user-provided context, the user says not to browse, or the task is purely creative rewriting.

## Research modes

Choose the smallest mode that answers the request.

| Mode | Use for | Exit condition |
|---|---|---|
| Quick lookup | API signatures, CLI flags, simple how-to, known errors | One authoritative source answers it |
| Verification | Current facts, dates, versions, prices, policies, safety/security impact | Current primary source confirms it |
| Comparison | Libraries, tools, vendors, implementation options | Key tradeoffs supported by evidence |
| Deep research | Landscape survey or durable recommendation | Brief saved under `.pi/research/` |

## Local-first rule

For project-specific questions, inspect local context before browsing:

```text
README.md, docs/, .pi/research/, ARCHITECTURE.md
package.json, pyproject.toml, Cargo.toml, go.mod, requirements.txt, lockfiles
```

Use local versions, dependencies, and architecture to shape queries and avoid duplicate research.

## Firecrawl strategy

Available tools: `firecrawl_search`, `firecrawl_scrape`, `firecrawl_map`.

Use the lightest tool first:

```text
search → scrape exact page → map docs root if exact page is unknown
```

### Search

Use `firecrawl_search` to discover pages from a topic, error, library, API, or comparison.

Good query patterns:

```text
site:react.dev useActionState
"Hydration failed because the initial UI does not match" Next.js
vite 6 migration guide breaking changes
site:github.com <library> <error> issue
```

### Scrape

Use `firecrawl_scrape` when you have a specific useful URL.

Default options:

```json
{
  "formats": ["markdown"],
  "onlyMainContent": true
}
```

Scrape exact docs, changelogs, release notes, issues, or PDFs. Do not rescrape the same URL unless the first result was incomplete.

### Map

Use `firecrawl_map` for documentation roots when the exact page is unknown. Map first, then scrape only the relevant pages.

Do not crawl or scrape whole sites when one page or a small set of mapped pages is enough.

## Source priority

Prefer sources in this order:

1. Official documentation.
2. Official changelogs, release notes, migration guides, API refs.
3. Standards, specs, RFCs, or vendor-maintained examples.
4. Repository source, README, merged PRs.
5. GitHub issues/discussions with maintainer activity.
6. Stack Overflow with strong votes and recent activity.
7. Community sources for sentiment only.

Avoid SEO farms, AI aggregators, unattributed tutorials, and stale blogs unless they provide unique firsthand evidence.

## Freshness and citations

Check dates when accuracy depends on time: versions, API availability, deprecations, advisories, pricing, laws, roles, SaaS behavior, runtime/browser support, and best practices.

Flag sources older than two years as `Potentially outdated` unless they are stable specs or historical context. If sources conflict, cite both and explain the disagreement.

Cite claims that are current, version-specific, contested, surprising, high-impact, or necessary for a recommendation. Label community sources as `Community signal, not official guidance`.

## Workflows and output contracts

### Quick lookup

1. Identify the exact fact needed.
2. Search official or primary sources.
3. Scrape the most specific page.
4. Verify version/context.
5. Answer directly with citation.
6. Stop.

Output:

```text
Answer:
- <direct answer>

Evidence:
- <source-backed detail>

Caveat:
- <only if relevant>
```

### Known error

```text
search quoted exact error + framework/library/version
→ prefer official docs or high-signal GitHub issue
→ scrape authoritative result
→ return likely cause, fix, and source
```

### Comparison

1. Inspect local stack and constraints if available.
2. Gather official docs/changelogs for each serious option.
3. Add issue/community evidence only for gotchas and sentiment.
4. Compare against decision criteria such as fit, migration cost, stability, performance, security, ecosystem, and failure modes.

Output:

```text
Recommendation:
- <best option for stated context>

Comparison:
| Option | Best for | Tradeoffs | Evidence |
|---|---|---|---|

Gotchas:
- <important caveats>

Sources:
- <source list or citations>
```

### Deep research

Use when the user asks to explore, investigate, survey, deep dive, or create a durable recommendation.

1. Define scope, decision, constraints, criteria, exclusions, and freshness needs.
2. Inspect local project facts and existing `.pi/research/` briefs.
3. Search and scrape primary sources; add community sources only when useful.
4. Synthesize recommendation and evidence.
5. Save brief to `.pi/research/research-brief-<topic>.md`.

Brief structure:

```markdown
# Research brief: <topic>

## Executive summary
## Recommendation
## Context
## Landscape
## Evidence
## Gotchas
## Implementation path
## Sources
```

Output:

```text
Research brief saved:
- .pi/research/research-brief-<topic>.md

Recommendation:
- <one-sentence recommendation>

Key evidence:
- <top 2-4 findings>

Open questions:
- <remaining uncertainty, if any>
```

## Stop rules

Stop when an official source directly answers the question, additional sources repeat the same fact, remaining uncertainty does not affect the decision, or the user asked for a quick lookup.

Continue when sources conflict, the impact is high-stakes, the first source is old/unofficial/incomplete, version compatibility is unclear, or the user asked for a deep dive.

If not found or retrieval fails, say `NOT FOUND` or `[not verified]`, list what was checked, and suggest the next best search path.
