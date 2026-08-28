---
description: Run code review and simplification in parallel, then prepare changeset and PR body
---

Prepare a PR for review by running quality checks and generating documentation.

## Workflow

### Phase 1: Quality Review (Parallel)

Run these two agents in parallel using the Task tool:

1. **code-simplifier agent** (`code-simplifier:code-simplifier`)
   - Simplifies and refines code for clarity, consistency, and maintainability
   - Focuses on recently modified code (git diff against main)
   - Tell the agent to ignore Superpowers workflow artifacts under `docs/superpowers/**` and generated files such as `docs/superpowers/**/*.pdf` unless the user explicitly wants those in the PR

2. **code-review skill**
   - Comprehensive multi-agent PR review
   - Invoke using the Skill tool with skill: "code-review"
   - Tell reviewers to ignore Superpowers workflow artifacts under `docs/superpowers/**` and generated files such as `docs/superpowers/**/*.pdf` unless the user explicitly wants those in the PR

**CRITICAL**: Launch BOTH in the same message using parallel tool calls.

### Phase 2: User Confirmation

After both complete, present a summary of findings to the user:
- Key simplifications suggested or made
- Review findings and any concerns

Then walk through each suggestion **one at a time**, presenting:
- The suggestion title, priority/criticality rating, and a brief explanation
- Your assessment of the trade-off (is it worth doing? redundant? high effort vs low value?)
- Ask: "Add it or skip?"

Wait for the user's decision on each before moving to the next. Implement accepted suggestions immediately (edit code, run tests) before presenting the next one.

After all suggestions are addressed, ask: "Ready to proceed with changeset and PR body?"

### Phase 2.5: Commit Changes

Once the user approves the results, **always commit any changes from code-simplifier and code review** before proceeding:
- Stage and commit modifications from both agents, but do **not** stage or commit Superpowers workflow artifacts (`docs/superpowers/**`) or generated Superpowers files (`docs/superpowers/**/*.pdf`) unless the user explicitly asks to include them
- If Superpowers workflow artifacts were already committed earlier in the branch, remove them from the PR before continuing unless the user explicitly wants them included
- Leave untracked seed/planning files alone unless the user explicitly asks to add or delete them
- Use a clear commit message like "Apply code simplification and review fixes"

### Phase 3: PR Documentation (Parallel)

Only after user confirms, run these two skills in parallel:

1. **changeset skill** - Creates a changeset file for versioning
2. **pr-body skill** - Generates well-structured PR body

**CRITICAL**: Invoke BOTH skills in the same message using parallel Skill tool calls.

### Phase 4: CI Monitoring

After the PR has been created or updated by the pr-body skill, immediately run the **ci-loop skill** to monitor the PR until CI is green. Follow ci-loop's workflow exactly: inspect current PR checks, fix straightforward low-risk failures, schedule non-blocking 60-second wake-ups for pending checks, and stop only when CI is green or a human decision is needed.

## Important Notes

- Always fetch latest from origin first: `git fetch origin main`
- Use `git diff origin/main` for accurate comparison (local main may be stale)
- Superpowers workflow artifacts are for local agent process, not PR content by default. Do not commit `docs/superpowers/**` or generated Superpowers files such as `docs/superpowers/**/*.pdf` unless the user explicitly opts in.
- When briefing code-simplifier/code-review, explicitly tell them to ignore Superpowers workflow artifacts so they review the product/code changes rather than planning docs.
- If phase 1 finds significant issues, recommend fixing before proceeding
- When running vitest tests, limit to 2 CPUs: `pnpm vitest run --pool-options.threads.maxThreads=2`
