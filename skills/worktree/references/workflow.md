---
description: Set up a new git worktree under .worktrees for isolated branch work
---

Set up a new git worktree for the current repository, placing it under `.worktrees/` at the repository root. Use this when the user asks for a new worktree, an isolated checkout, a branch workspace, or a place to work on a feature/fix without disturbing the current checkout.

## Inputs

Use any text after `/worktree` as the desired branch/worktree name. If the provided text is a task description rather than a Git-valid branch name, pick a concise, sensible Git-valid branch/worktree name yourself instead of asking for clarification. Only ask the user for a name when the desired work is not clear enough to choose one. If the user did not provide any name or task description, ask for one before making changes.

Examples:

- `/worktree fix-login-race`
- `/worktree horton/add-schedule-tools`
- `/worktree pr-4527`

## Workflow

1. Choose the branch/worktree name from the user's input.
2. Run the helper script instead of issuing the setup commands one by one:

   ```bash
   skill_dir=${CLAUDE_SKILL_DIR:-$HOME/.agents/skills/worktree}
   "$skill_dir/scripts/worktree.sh" "<branch-or-worktree-name>"
   ```

   The script will:

   - find the repository root
   - fetch latest refs with `git fetch --all --prune`
   - normalize the worktree directory slug
   - stop if `.worktrees/<slug>` already exists
   - stop if the branch is already checked out in another worktree
   - create the worktree from, in order:
     - an existing local branch
     - `origin/<branch>` when only a remote branch exists
     - freshly fetched `origin/main` for brand-new branches
   - publish the branch and set upstream with `git push -u origin <branch>`
   - install dependencies using `pnpm install`, `npm install`, or `yarn install` when the corresponding lockfile exists
   - print a setup summary with the worktree path, branch, base, upstream, and dependency-install status

3. If the helper reports an error, stop and report it. Do not manually work around safety checks unless the user explicitly approves the next step.

4. Continue with the user's task.

   Creating the worktree is setup, not the whole job, when the user supplied a task description after `/worktree`. After the worktree is created, published, and dependencies are installed, continue working inside the new worktree instead of stopping.

   - Run all subsequent commands with `git -C ".worktrees/<slug>" ...` or `cd ".worktrees/<slug>" && ...`.
   - If the input is only a branch/worktree name with no task, stop after reporting setup.
   - If the input includes a task, continue the task in the new worktree.

## Report the result

When setup is complete but more task work remains, briefly mention the worktree path and then continue; do not end the turn just because the worktree exists.

When you do report setup or final task results, include:

- worktree path
- branch name
- base used (existing local branch, `origin/<branch>`, or `origin/main`)
- remote branch/upstream created (`origin/<branch>`) and whether push succeeded
- whether dependency installation ran and whether it succeeded
- what task work was completed after setup, if any

## Safety rules

- Do not delete, prune, reset, or overwrite existing worktrees without explicit confirmation.
- Do not run `git reset --hard`, `git clean`, or force operations as part of this command.
- This command is intentionally allowed to push the newly created branch and set upstream tracking, because these worktrees are expected to be pushed. Do not push any commits beyond the initial branch publication unless the user explicitly asks.
- The current checkout's branch, freshness, and uncommitted changes should not affect brand-new worktrees, because new branches are created from freshly fetched `origin/main`.
