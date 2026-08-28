---
description: Create or update a PR with a well-structured body following best practices for context and reviewability
---

Create or update the GitHub PR for the current branch yourself, with a well-structured PR body for the branch's changes. Do not merely write a PR body for the user to copy/paste. Follow the three-layer structure from https://sunilpai.dev/posts/context-is-the-work/

## Structure

### Layer 1: Executive Summary (30 seconds)
Start with 1-2 sentences answering:
- What changed?
- What's the user-visible impact?

### Layer 2: Reviewer Guidance (3-7 minutes)

**Root Cause** (if it's a fix)
Explain WHY the bug happened, not just what was wrong.

**Approach**
- What strategy did you take?
- Key implementation details (with code snippets if helpful)

**Key Invariants**
What properties must hold for this to be correct?

**Non-goals**
What did you explicitly choose NOT to do? This helps reviewers understand scope.

**Trade-offs**
What alternatives were considered? Why this approach?

### Layer 3: Verification & Details

**Verification**
How can someone verify this works? Include commands:
```bash
pnpm test
```

**Files changed**
Brief description of each file's changes.

## Process

1. First, fetch the latest from origin: `git fetch origin main`
2. **Check for existing PR body**: Run `gh pr view --json body,title -q '.body'` to get the current PR body (if one exists)
   - Extract and note any GitHub issue references (patterns like `fixes #123`, `closes #456`, `resolves #789`, `addresses #101`, or just `#123` references)
   - Note any other unique information worth preserving (test plans, deployment notes, reviewer mentions, etc.)
3. Analyze the diff against origin/main (local main is often stale): `git diff origin/main --stat` and `git log origin/main..HEAD --oneline`
4. Read the changed files to understand the changes
5. Draft the PR body following the structure above, **incorporating preserved content**:
   - Add a "Closes" or "Fixes" section at the end with any issue references from the original body
   - Include any other preserved unique information in appropriate sections
6. Apply the PR body yourself:
   - If a PR already exists, use `gh pr edit --body "..."` to update it.
   - If no PR exists, create one yourself with `gh pr create` using the drafted body.
   - Do **not** stop after printing the body for the user to use manually.

## Preserving Existing Content

**CRITICAL**: GitHub issue linking keywords must be preserved. Look for these patterns in the existing body:
- `fixes #N`, `fix #N`, `fixed #N`
- `closes #N`, `close #N`, `closed #N`
- `resolves #N`, `resolve #N`, `resolved #N`
- Any `#N` reference (issue or PR number)

If found, include them at the end of the new body under a dedicated section:
```
---
Fixes #123
```

Also preserve:
- Manual test instructions or steps to reproduce
- Deployment notes or migration steps
- Links to related PRs, discussions, or external resources
- Reviewer assignments or cc mentions

## Style Notes

- Be concise but complete
- Use code blocks for commands and code snippets
- Focus on transmitting engineering judgment, not just implementation details
- Write for three audiences: quick skimmers, reviewers, and future maintainers
