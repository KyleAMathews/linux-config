---
description: Use when monitoring pull request or branch CI failures, pending checks, failed workflows, or recurring status checks
---

Monitor CI for the current branch until it is green. Make straightforward, low-risk fixes for failures you can confidently resolve, but pause and discuss any design decisions, ambiguous trade-offs, or risky changes with the user.

## Inputs

Use any text after `/ci-loop` as optional context, such as a PR number, branch name, CI provider, or specific workflow to watch. If no input is provided, infer the current branch and PR from the local git checkout.

Examples:

- `/ci-loop`
- `/ci-loop PR 123`
- `/ci-loop watch the deploy preview checks too`

## Workflow

1. **Identify the target**

   Run:

   ```bash
   git branch --show-current
   git status --short
   gh pr view --json number,url,headRefName,statusCheckRollup
   ```

   If there is no PR, use the current branch's latest pushed commit and explain what target you are watching. If GitHub CLI is unavailable or unauthenticated, stop and ask the user how they want CI checked.

2. **Check CI status**

   Prefer GitHub CLI when available:

   ```bash
   gh pr checks --watch=false
   ```

   If a PR number was provided:

   ```bash
   gh pr checks <PR_NUMBER> --watch=false
   ```

   Also inspect failed run details as needed:

   ```bash
   gh run list --branch "$(git branch --show-current)" --limit 10
   gh run view <RUN_ID> --log-failed
   ```

3. **If CI is pending or queued**

   **Never run `sleep` or a blocking wait.** Schedule a wake-up for yourself in 60 seconds using the `send` tool with `self: true` and `afterMs: 60000`, then end your turn. The scheduled message must include enough context to resume the loop, including the repo path, branch or PR number, and the fact that this is a CI-loop continuation.

   Example scheduled payload:

   ```json
   {
     "text": "Continue /ci-loop: cd /path/to/repo, check PR <number> or branch <branch>, inspect CI status, fix straightforward failures or schedule another 60s wake if still pending."
   }
   ```

   On wake, continue from step 2. If checks are still pending, schedule another 60-second wake the same way.

4. **If CI fails**

   Diagnose the failure from logs. Classify it before changing code:

   ### Straightforward fixes — do these directly

   Make the fix without asking when it is clearly mechanical and low-risk, such as:

   - formatting or lint failures
   - type errors with obvious local fixes
   - missing imports, unused variables, or simple renames
   - test expectation updates that clearly match existing intended behavior
   - flaky test timing where the existing codebase has an established pattern
   - dependency install or lockfile drift caused by local changes

   After each fix:

   ```bash
   git status --short
   # run the smallest relevant local verification command
   git add <changed-files>
   git commit -m "Fix CI failure"
   git push
   ```

   Then return to checking CI every 60 seconds.

   ### Design decisions — pause and ask

   Do **not** decide alone when the fix involves:

   - changing public API, protocol behavior, or persisted data formats
   - altering product behavior or UX
   - choosing between multiple reasonable implementation strategies
   - weakening tests, deleting coverage, or broadening assertions
   - changing security, auth, permissions, or data-loss behavior
   - large refactors beyond the failed area
   - force-pushes, resets, destructive operations, or reverting others' work

   Present:

   - the failing check and relevant log excerpt
   - the likely root cause
   - the options you see
   - your recommendation, clearly labeled

   Then wait for the user's decision.

5. **Loop until green**

   Continue the cycle:

   ```text
   check CI → if pending schedule self-wake in 60s and end turn → if failed diagnose/fix or ask → push → check CI
   ```

   Stop only when:

   - all required CI checks are green, or
   - you need a human decision, credentials, or external action, or
   - the user tells you to stop.

6. **Report completion**

   When CI is green, report:

   - PR/branch watched
   - final CI status
   - fixes committed and pushed, if any
   - local verification commands run
   - anything intentionally left unchanged

## Safety rules

- Never force-push, reset hard, delete branches, drop data, or remove tests without explicit user approval.
- Prefer the smallest targeted fix over broad refactors.
- Do not hide uncertainty. If the cause is unclear after inspecting logs, say so and ask before guessing.
- If local verification cannot be run, say why and rely only on CI after telling the user.
- Never use `sleep`, `gh pr checks --watch`, or any long-running blocking wait. Use the `send` tool with `self: true` and `afterMs: 60000` for every CI polling delay.
