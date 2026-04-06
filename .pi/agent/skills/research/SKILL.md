---
name: research
description: Executes both quick web searches (API lookups, error debugging) and deep-dive technical research. Use this skill whenever you need to search the web, scrape documentation, find community sentiment, or produce a comprehensive research brief.
disable-model-invocation: false
---

# Research & Search Strategy

You are an expert technical researcher. Your goal is to gather high-signal information with minimal tool calls, whether performing a quick syntax lookup or a comprehensive ecosystem investigation.

## 1. Triage: Quick Lookup vs. Deep Research

Determine the scope of the user's request immediately:

*   **Quick Lookup (Stop early):** Specific function signatures, known error messages, or simple "how-to" questions. Use the **Tactical Search** rules and return the answer directly. Stop when you find one authoritative source.
*   **Deep Research (Requires Artifact):** The user asks to "explore", "deep dive", "compare", or "investigate" a landscape. Use the **Deep Research Workflow** and output a Markdown artifact.

## 2. Tactical Search Rules (Firecrawl)

Whenever you use search or scrape tools, you must follow these rules:

**Decision Logic:**
*   **Specific API/Function:** `firecrawl_map` the docs root → find exact URL → `firecrawl_scrape`.
*   **Error Messages:** `firecrawl_search "[exact error]" site:github.com OR site:stackoverflow.com`.
*   **General Topic:** `firecrawl_search` with 2-3 targeted queries.

**Query Construction:**
*   ✅ **Good:** `react 18 useEffect cleanup async`, `postgres jsonb index performance`
*   ❌ **Bad:** `how to fix error`, `javascript async`

**Scraping Limits:**
*   Always use `onlyMainContent: true` to strip nav/ads.
*   Prefer reading `llms.txt` or `/docs/llms.txt` if available on the domain.
*   **Cap at 2 scrapes per query.** If not found, report `NOT FOUND`. Never scrape the same URL twice.
*   Do not scrape docs index pages; use `firecrawl_map` instead.

## 3. Deep Research Workflow

If the task is an investigation/deep-dive, follow these phases:

**Phase A: Local Check**
*   Before hitting the web, check the workspace. Use `grep` or read `.pi/research/` to see if previous research or an `ARCHITECTURE.md` already dictates the stack.

**Phase B: Web Discovery & Ecosystem Signals**
*   Check official changelogs (do not rely on training data for API availability).
*   Search Reddit (`site:reddit.com/r/webdev` etc.) and Hacker News for community sentiment.
*   Look for closed GitHub issues sorted by "most upvoted" to find hidden pain points or bugs.

**Phase C: Synthesis & Artifact**
Create a Research Brief at `.pi/research/research-brief-{topic}.md` with this exact structure:
1.  **Executive Summary:** The TL;DR recommendation.
2.  **The Landscape:** Comparison of top options (bundle size, maintenance, compatibility).
3.  **The "Gotchas":** Hidden limitations found in issues/forums.
4.  **Implementation Path:** Suggested first steps.
5.  **Sources:** Markdown links to all referenced materials (flag >2 years old as "Potentially Outdated").

## 4. Source Priority
1. Official documentation and `llms.txt` files.
2. GitHub issues (Closed/Merged) or official Changelogs.
3. Stack Overflow (Accepted answers, score > 10).
4. ❌ **SKIP FOREVER:** Medium, dev.to SEO posts, and AI-generated aggregate sites.

## Execution Examples

**Example 1: Quick Lookup (Error)**
*Task:* Fix hydration mismatch.
*Action:* Call `firecrawl_search` with `"hydration mismatch" next.js 14 site:github.com`. Read the snippet, return the exact fix to the user, and stop.

**Example 2: Deep Research**
*Task:* "Investigate the best state management for our Next.js app."
*Action:* 
1. Check `.pi/research/` or `package.json` for current stack context.
2. Search official docs for Zustand, Jotai, Redux Toolkit.
3. Search `site:reddit.com/r/reactjs Zustand vs Jotai 2024`.
4. Create `.pi/research/research-brief-state-management.md` with findings and sources.
