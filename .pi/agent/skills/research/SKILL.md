---
name: research
description: Firecrawl-first research and search workflow for quick lookups, documentation discovery, error debugging, source verification, community-signal analysis, and deep technical research briefs. Use when current or niche information is needed, when searching official docs, scraping pages, mapping documentation sites, comparing tools, or producing cited research.
disable-model-invocation: false
---

# Research

## Purpose

Use Firecrawl-first research workflows to find accurate, current, high-signal information with minimal tool calls. Prefer primary sources, scrape only what is useful, cite evidence, and distinguish facts from inference.

## When to use

Use this skill when the task requires:

- Web search.
- Firecrawl search, scrape, map, crawl, or extraction.
- Official documentation lookup.
- API or library behavior.
- Version-specific behavior.
- Error-message debugging.
- Technical comparison.
- Ecosystem or community sentiment.
- Changelog, release, or deprecation checks.
- Security, legal, medical, financial, or other high-stakes verification.
- A research brief or cited recommendation.

Do not use this skill when:

- The answer can be derived entirely from user-provided text.
- The user explicitly says not to browse or search.
- The request is purely creative writing, rewriting, or translation.
- The information is stable common knowledge and no verification is needed.

---

## Research modes

Choose the smallest mode that answers the request.

### Quick lookup

Use for:

- Function signatures.
- CLI flags.
- Known error messages.
- Simple how-to questions.
- Version-specific API behavior.

Stop when one authoritative source answers the question.

### Verification

Use when:

- The user asks whether something is current or correct.
- A fact may have changed.
- The answer involves a date, version, role, price, law, policy, or release.
- The answer affects money, safety, production systems, compliance, or security.

Find the current primary source and cite it.

### Comparison

Use when comparing:

- Libraries.
- Frameworks.
- APIs.
- Tools.
- Vendors.
- Implementation approaches.

Use official docs for capabilities, changelogs for freshness, and issues/forums for pain points.

### Deep research

Use when the user asks to:

- Explore.
- Investigate.
- Deep dive.
- Survey a landscape.
- Produce a recommendation.
- Create a reusable research artifact.

Create a research brief at:

```text
.pi/research/research-brief-<topic>.md
````

---

## Firecrawl tool strategy

Use Firecrawl as the default web-research path.

### `firecrawl_search`

Use when:

* You need to discover pages.
* The user gives a topic, error message, library, or comparison.
* You need snippets, summaries, or top candidate sources.
* You want search results plus scraped markdown in one call.

Good for:

```text
"exact error message" next.js 15
site:react.dev useActionState
postgres jsonb gin index performance official docs
zustand jotai redux toolkit comparison github issues
```

When supported, request markdown or summary formats for high-value results.

### `firecrawl_scrape`

Use when:

* You have a specific URL.
* You need exact content from a page.
* A search result looks authoritative and relevant.
* You need clean markdown from docs, changelogs, blog posts, or public PDFs.

Default scrape behavior:

```text
formats: ["markdown"]
onlyMainContent: true
```

Use stronger cleaning or extraction only when the returned page has boilerplate, nav clutter, comments, or repeated unrelated sections.

### `firecrawl_map`

Use when:

* You have a documentation root and need the right page.
* The exact URL is unknown.
* A docs site has many nested pages.
* You need to discover API reference pages, changelogs, migration guides, or examples.

Use `map` before scraping large documentation sites.

Do not scrape a docs homepage or index page repeatedly if mapping can locate the specific page.

### `firecrawl_crawl`

Use when:

* A full section or small documentation area must be collected.
* Multiple linked pages are needed for a deep research artifact.
* You need an overview of a bounded docs subtree.

Before crawling:

* Set a narrow URL scope.
* Set sensible page limits.
* Avoid crawling an entire domain unless explicitly required.
* Prefer `map` plus targeted `scrape` when fewer pages are enough.

### Firecrawl extraction

Use structured extraction when:

* You need repeatable fields from one or more pages.
* You are collecting pricing, release metadata, API method names, changelog entries, or comparison tables.
* A research artifact needs structured evidence.

Define the desired schema before extraction.

Do not use LLM extraction when simple markdown scraping is enough.

---

## Firecrawl escalation pattern

Use the lightest operation first.

```text
search → scrape → map → crawl → extract
```

Typical flows:

### Specific API or function

```text
firecrawl_search "site:<official-docs-domain> <api/function/version>"
→ firecrawl_scrape exact docs page
→ answer with citation
```

If the exact page is hard to find:

```text
firecrawl_map official docs root
→ identify exact page
→ firecrawl_scrape exact page
```

### Known error message

```text
firecrawl_search "\"<exact error>\" <framework/library/version>"
→ prefer official docs or GitHub issue
→ scrape top authoritative result
→ answer with cause, fix, and source
```

### Documentation site discovery

```text
firecrawl_map docs root
→ scrape specific pages only
→ synthesize answer
```

### Deep research

```text
local project check
→ firecrawl_search broad landscape queries
→ firecrawl_map official docs roots when needed
→ firecrawl_scrape selected primary pages
→ scrape GitHub issues/community sources for gotchas
→ synthesize research brief
```

---

## Search query rules

Write specific queries with product, version, error, API, and context terms.

Good:

```text
react 19 useActionState official docs
next.js 15 hydration mismatch github issue
postgres jsonb gin index performance official docs
vite 6 migration guide breaking changes
```

Poor:

```text
how to fix error
javascript async problem
best framework
```

For exact errors, quote the error:

```text
"Hydration failed because the initial UI does not match" Next.js
```

For official docs, bias toward the source:

```text
site:react.dev useActionState
site:nextjs.org hydration error
site:docs.github.com code scanning alerts API
```

For GitHub issues:

```text
site:github.com <library> <error or feature> issue
```

For community sentiment:

```text
site:reddit.com/r/reactjs Zustand Jotai Redux Toolkit 2026
site:news.ycombinator.com <tool name> production
```

---

## Scraping rules

Use scraping intentionally.

Do:

* Scrape the most specific authoritative page.
* Use main-content extraction by default.
* Prefer markdown output for reading and citation.
* Scrape public PDFs when they are primary sources.
* Avoid duplicate scrapes of the same URL.
* Save or summarize only the relevant portions.

Do not:

* Scrape the same URL twice unless the first scrape was incomplete.
* Scrape a whole docs site when one page answers the question.
* Treat scraped community posts as authoritative facts.
* Include nav, footers, ads, comments, or unrelated boilerplate in the answer.
* Continue scraping after sufficient evidence is found.

Soft limit:

```text
Quick lookup: 1-2 scraped pages
Comparison: 3-6 primary pages plus selected issue/community sources
Deep research: enough sources to support the recommendation, not every available page
```

If the answer is not found after targeted search and scraping, report what was checked and say `Not found`.

---

## Documentation discovery

When researching a technical product or library:

1. Find the official docs root.
2. Check for:

   * API reference.
   * Guides.
   * Migration guide.
   * Changelog.
   * Release notes.
   * Examples.
   * `llms.txt` or `llms-full.txt`, if available.
3. Use `firecrawl_map` to locate exact docs pages when needed.
4. Scrape exact pages, not broad index pages.

Treat `llms.txt` as a navigation aid, not as a substitute for reading source pages.

Do not depend on deprecated or non-maintained Firecrawl alpha endpoints for `llms.txt` or deep research.

---

## Local-first rule for project research

Before web research for project-specific questions, inspect the workspace when available.

Check for:

```text
README.md
docs/
.pi/research/
ARCHITECTURE.md
package.json
pyproject.toml
Cargo.toml
go.mod
requirements.txt
lockfiles
```

Use local project facts to shape Firecrawl queries.

Examples:

* Detect framework and version before searching.
* Detect package manager before recommending commands.
* Check existing architecture decisions before suggesting a new stack.
* Check `.pi/research/` before creating duplicate research.

---

## Source priority

Prefer sources in this order:

1. Official documentation.
2. Official changelogs, release notes, migration guides, and API references.
3. Standards, specifications, RFCs, or vendor-maintained examples.
4. Repository source code, README files, and merged pull requests.
5. GitHub issues and discussions, especially closed or highly reacted issues.
6. Stack Overflow answers with strong votes, recent activity, and accepted status.
7. Community sources such as Reddit, Hacker News, Discord exports, and blog posts.

Avoid relying on:

* SEO content farms.
* AI-generated aggregator sites.
* Unattributed tutorials.
* Outdated blog posts.
* Medium/dev.to posts unless they provide unique firsthand evidence or are from a project maintainer.

Community sources are useful for sentiment and hidden pain points, not as the sole source for factual claims.

---

## Freshness rules

Always check publication, update, release, or commit dates when accuracy depends on time.

Treat these as freshness-sensitive:

* Package versions.
* API availability.
* Deprecations.
* Security advisories.
* Pricing.
* Laws and regulations.
* Current maintainers or company roles.
* SaaS product behavior.
* Browser, runtime, or framework support.
* Best-practice recommendations.

Flag sources older than two years as:

```text
Potentially outdated
```

unless the source is a stable specification or historical reference.

If sources disagree, cite both and explain the disagreement.

---

## Citation rules

Cite claims that are:

* Current.
* Version-specific.
* Contested.
* Surprising.
* High-impact.
* From a non-obvious source.
* Needed for a recommendation.

Do not cite every sentence. Cite the claims that carry the conclusion.

When using community sources, label them clearly:

```text
Community signal, not official guidance
```

When making an inference, say so:

```text
Inference: ...
```

Then cite the evidence that supports it.

---

## Quick lookup workflow

1. Identify the exact fact needed.
2. Use `firecrawl_search` against official or primary sources.
3. Use `firecrawl_scrape` on the most specific result.
4. Verify version or context.
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

---

## Deep research workflow

### Phase 1: Scope

Define internally:

```text
Research question:
Decision to support:
Current stack or constraints:
Must-have criteria:
Nice-to-have criteria:
Exclusions:
Freshness requirements:
```

Do not ask for clarification if a reasonable scope can be inferred.

### Phase 2: Local check

Inspect project files or previous research when available.

Look for:

* Existing decisions.
* Existing dependencies.
* Constraints.
* Prior research.
* Tests, build tooling, or architecture docs.

### Phase 3: Firecrawl discovery

Gather evidence from:

* Official docs.
* Changelogs and release notes.
* API references.
* Maintainer-authored posts.
* GitHub issues or discussions.
* Community sentiment sources.
* Benchmarks only when methodology is clear.

Use:

```text
firecrawl_search for discovery
firecrawl_map for docs navigation
firecrawl_scrape for exact evidence
firecrawl_crawl for bounded multi-page research
extract for structured fields
```

### Phase 4: Synthesis

Compare options using criteria relevant to the decision.

Possible criteria:

* Fit for current stack.
* Maintenance activity.
* API stability.
* Migration cost.
* Performance.
* Bundle size.
* Security posture.
* Ecosystem maturity.
* Compatibility.
* Learning curve.
* Failure modes.
* Known gotchas.

### Phase 5: Artifact

For deep research, create:

```text
.pi/research/research-brief-<topic>.md
```

Use this structure:

```markdown
# Research brief: <topic>

## Executive summary

<short recommendation and why>

## Recommendation

<recommended option or path>

## Context

<project constraints, versions, and assumptions>

## Landscape

| Option | Strengths | Weaknesses | Best fit |
|---|---|---|---|

## Evidence

<claim-level findings with citations>

## Gotchas

<hidden limitations, migration risks, open issues, or community pain points>

## Implementation path

1. <first step>
2. <second step>
3. <verification step>

## Sources

- <source title> — <why it matters> — <date or “Potentially outdated”>
```

---

## Stop rules

Stop researching when:

* An official source directly answers the question.
* Additional sources repeat the same fact.
* The remaining uncertainty is not important to the decision.
* The user asked for a quick lookup.

Continue researching when:

* Sources conflict.
* The answer affects production, security, money, law, health, or compliance.
* The user asked for a deep dive.
* The first source is old, unofficial, or incomplete.
* Version compatibility is unclear.

If the answer cannot be found, say so and summarize what was checked.

---

## Output contracts

### Quick lookup

```text
Answer:
- <direct answer>

Evidence:
- <source-backed detail>

Caveat:
- <only if relevant>
```

### Comparison

```text
Recommendation:
- <best option for the stated context>

Comparison:
| Option | Best for | Tradeoffs | Evidence |
|---|---|---|---|

Gotchas:
- <important caveats>

Sources:
- <source list or citations>
```

### Deep research handoff

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

---

## Examples

### Quick lookup: error

Task:

```text
Fix a Next.js hydration mismatch.
```

Action:

```text
firecrawl_search "\"Hydration failed because the initial UI does not match\" Next.js"
→ scrape official docs or strongest GitHub issue
→ return likely cause, fix, and source
→ stop
```

### Quick lookup: API

Task:

```text
What is the signature for React useActionState?
```

Action:

```text
firecrawl_search "site:react.dev useActionState"
→ firecrawl_scrape exact React API page
→ return signature, parameters, caveats, and source
→ stop
```

### Docs navigation

Task:

```text
Find the Vite migration guide for the current major version.
```

Action:

```text
firecrawl_map "https://vite.dev/guide/"
→ identify migration or release page
→ firecrawl_scrape exact page
→ summarize relevant breaking changes
```

### Deep research

Task:

```text
Investigate the best state management option for our Next.js app.
```

Action:

```text
inspect package.json and existing app structure
→ firecrawl_search official docs for candidate libraries
→ firecrawl_scrape docs, changelogs, and migration notes
→ firecrawl_search GitHub issues and community sentiment
→ synthesize .pi/research/research-brief-state-management.md
```
