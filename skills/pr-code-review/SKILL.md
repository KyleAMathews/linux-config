---
name: pr-code-review
description: Wrapper around the built-in code-review skill that always reviews from a clean worktree checked out from origin, so the diff base is never a stale or dirty local checkout. Use for reviewing a PR number, branch, or the current changes when you want the review isolated from local working state.
---

# pr-code-review

This skill wraps the built-in `code-review` skill and forces one behavior the
built-in leaves optional: **the review always runs in a clean git worktree
checked out from `origin`.** This exists because reviewing against a stale or
dirty local checkout has produced scope artifacts — changes already merged to
`origin/main` showing up as in-scope, or local edits contaminating the diff.

## What to do

1. Take the arguments the user passed to this skill verbatim (effort level such
   as `low`/`medium`/`high`/`max`, a PR number / branch / path target, and any
   focus instructions like "focus on code size").

2. **If the target is a PR number**, this is the critical case this wrapper
   exists for. A bare "in a clean worktree from origin" is NOT enough: when the
   review runs while the shell sits in some other branch's checkout, the
   built-in has been observed to diff the ambient `HEAD` instead of the PR's
   branch, silently reviewing the wrong code. Delegating the worktree setup to
   the forked `code-review` skill has failed repeatedly, so **you — the main
   agent — must create and verify the worktree yourself before invoking
   `code-review`.** Do not hand this step to the forked skill. Concretely:

   a. Determine `<repo>` from the PR URL if one was given, else the current
      repo's `origin`.

   b. Create a fresh git worktree branched from `origin`'s default branch, then
      run `gh pr checkout <N>` inside that worktree (or fetch and check out the
      PR's head ref) so its `HEAD` is the PR's head branch. Never reuse the
      directory you were launched from.

   c. Verify the worktree yourself before going further: confirm
      `git branch --show-current` (run in the worktree) equals the PR's head
      branch, and that `git diff <the PR's base ref>...HEAD --name-only` matches
      the PR's actual changed files (`gh pr diff <N> --name-only`). If either
      check does not match, **stop and report the mismatch to the user — do not
      invoke `code-review` and do not review anything.**

   d. Only once the worktree is confirmed correct, invoke the built-in
      `code-review` skill pointed at that worktree, passing the original
      effort/focus args unchanged and telling it the review directory is the
      worktree you prepared (an absolute path). Instruct it to review the diff
      there and not to create its own worktree or re-checkout anything.

3. **If the target is a branch, path, or the current diff** (no PR number),
   append `in a clean worktree from origin` unless the arguments already say so.
   Do not drop or reword any argument the user gave.

4. Invoke the built-in `code-review` skill with the original arguments plus the
   worktree path (step 2) or appended instruction (step 3). Let the built-in do
   the review itself: gathering the diff in the prepared worktree, running its
   finder angles at the requested effort, deduping, and reporting findings. Do
   not re-implement its review recipe here — your added responsibility is only
   the worktree setup and verification.

5. If the user passed no effort level, pass none through — the built-in reuses
   the last level typed, and this wrapper must not change that.

## What not to do

- Do not review in the current working directory or against local `HEAD`/local
  `main`; the whole point of this wrapper is the clean-from-origin base.
- For a PR-number target, do not trust a review that did not check out the PR's
  head branch. If the diffed files do not match the PR's changed files, the
  review is invalid — surface that, do not relay its findings.
- Do not add, remove, or reinterpret findings — relaying and follow-up are the
  built-in skill's job and the caller's.
- For a PR-number target, do not delegate worktree creation or verification to
  the forked `code-review` skill. That has failed repeatedly; the main agent
  sets up the worktree and confirms the branch and changed files match before
  invoking the review.
