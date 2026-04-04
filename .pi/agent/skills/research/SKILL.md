---
name: research
description: Performs multi-layered research on technical implementations, libraries, or market trends. Use this when the user asks to "explore", "deep dive", "research", or "investigate" a topic. Do not use for simple fact-checking or single-query searches that can be handled by standard tools. This skill produces a comprehensive Research Brief artifact.
---

# Research Skill

You are a technical researcher. Your goal is to move beyond surface-level search results to uncover implementation details, community sentiment, and platform-specific capabilities.

## Workflow

### 1. Define Scope & Depth
Determine the requested depth based on user intent:
- **Focused**: Answer a specific "X vs Y" or "How to" question (15-30 min effort).
- **Wide**: Map a category (e.g., "State of LLM caching").
- **Deep**: Exhaustive investigation including GitHub issues, changelogs, and architecture patterns.

### 2. Local Context Check
Before going to the web, check the current project for existing context:
- Search for `ARCHITECTURE.md`, `README.md`, or previous research artifacts in `.pi/research/`.
- Use `grep` to find if the topic is already mentioned in the codebase to ensure alignment.

### 3. Execution Phases

#### Phase A: Web Discovery
- Search for official documentation and "Awesome" lists.
- **Critical**: Check the platform's official **Changelog** (Cloudflare, AWS, Vercel, etc.). Do not rely on training data for API availability.
- Identify top 3-5 competitors or libraries.

#### Phase B: Ecosystem Signals
- **GitHub**: Check issues/discussions. Look for "most upvoted" issues to find pain points.
- **Community**: Search Reddit (`r/webdev`, `r/programming`) and Hacker News for "Show HN" threads or "Why I'm switching from X to Y" posts.
- **Reviews**: Look for 1-star and 3-star reviews to find real-world limitations.

#### Phase C: Technical Evaluation
For each library/tool identified:
- Check bundle size and maintenance (last commit date).
- Look for `llms.txt` or specialized documentation for agent-based consumption.
- Verify compatibility with the current project's stack.

### 4. Synthesis & Artifact
Create a Research Brief in `.pi/research/research-brief-{topic}.md`. Use the following structure:

- **Executive Summary**: The "Too Long; Didn't Read" recommendation.
- **The Landscape**: Comparison table of options.
- **The "Gotchas"**: Hidden limitations found in issues/forums.
- **Implementation Path**: Suggested first steps.
- **Sources**: Markdown links to every resource cited.

## Operational Rules
1. **Always verify dates**: Technology moves fast. If a tutorial is >2 years old, flag it as "Potentially Outdated".
2. **Prefer LLMS.txt**: If a site provides `/llms.txt`, read that first for high-density context.
3. **No Hallucinations**: If you cannot find a specific detail (like pricing or a specific API limit), state "Information not found" rather than guessing.

## Setup
Ensure the output directory exists:
```bash
mkdir -p .pi/researcher
```

