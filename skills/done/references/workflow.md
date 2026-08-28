---
description: End-of-session summary — captures decisions, context, and follow-ups into a markdown file
---

Generate an end-of-session summary document capturing everything discussed during this conversation.

## Process

1. **Gather context**: Run these in parallel:
   - `git branch --show-current` to get the branch name
   - `git log origin/main..HEAD --oneline` to see commits made this session
   - `git diff --stat origin/main` to see files changed

2. **Generate the summary** covering:
   - **What was done**: High-level summary of work completed (1-3 sentences)
   - **Key decisions**: Architectural or design choices made and why
   - **Changes made**: Brief description of each file touched and what changed
   - **Open questions**: Anything unresolved or needing follow-up
   - **Follow-ups / TODOs**: Next steps, known issues, things to revisit
   - **Context for next session**: Anything a future session would need to know to pick up where we left off

3. **Determine the repo name**: Run `gh repo view --json nameWithOwner -q '.nameWithOwner'` or parse from `git remote get-url origin` (extract `owner/repo` from the URL, e.g. `TanStack/db`)

4. **Write the file** to `~/programs/claude-sessions/<repo-name>/<date>--<branch-name>.md`
   - Create the directory if it doesn't exist (`mkdir -p`)
   - Use the repo name (e.g. `TanStack-db`) as the subfolder — replace `/` with `-`
   - Date format: `YYYY-MM-DD` (sorts chronologically)
   - Example: `~/programs/claude-sessions/TanStack-db/2026-02-20--claude-fix-livequery-isnull-bug.md`

## Output Format

```markdown
# Session Summary

**Branch**: `<branch-name>`
**Date**: <YYYY-MM-DD>

## What Was Done

<1-3 sentence summary>

## Key Decisions

- **<Decision>**: <Rationale>

## Changes Made

| File | Change |
|------|--------|
| `path/to/file` | Brief description |

## Open Questions

- <Question or unresolved item>

## Follow-ups / TODOs

- [ ] <Action item>

## Context for Next Session

<Anything needed to resume work>
```

## Guidelines

- Be concise but complete — this is a reference document, not a narrative
- Focus on decisions and rationale over implementation details
- Include specific file paths and line numbers where relevant
- Capture things that would be hard to reconstruct from git history alone (the "why", not just the "what")
- If there were dead ends or failed approaches, note them briefly so they aren't repeated
