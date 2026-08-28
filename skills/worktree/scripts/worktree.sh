#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage: worktree.sh <branch-or-task-name>

Creates a git worktree under <repo-root>/.worktrees/<slug>, publishes the
branch with upstream tracking, and installs dependencies when a known lockfile
is present.

Examples:
  worktree.sh fix-login-race
  worktree.sh horton/add-schedule-tools
  worktree.sh "investigate issue 1599"
USAGE
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

if [[ $# -eq 0 ]]; then
  echo "error: missing branch/worktree name" >&2
  usage >&2
  exit 64
fi

RAW_NAME="$*"
BRANCH_NAME="$(printf '%s' "$RAW_NAME" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
if [[ -z "$BRANCH_NAME" ]]; then
  echo "error: branch/worktree name is empty after trimming" >&2
  exit 64
fi

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null)" || {
  echo "error: not inside a git repository" >&2
  exit 128
}
cd "$REPO_ROOT"

WORKTREE_SLUG="$(printf '%s' "$BRANCH_NAME" \
  | sed -E 's#[/[:space:]]+#-#g; s#[^A-Za-z0-9._-]##g; s#-+#-#g; s#^-+##; s#-+$##')"

if [[ -z "$WORKTREE_SLUG" ]]; then
  echo "error: worktree slug is empty after sanitizing '$BRANCH_NAME'" >&2
  exit 64
fi

WORKTREE_REL=".worktrees/$WORKTREE_SLUG"
WORKTREE_PATH="$REPO_ROOT/$WORKTREE_REL"

printf 'Repo root: %s\n' "$REPO_ROOT"
printf 'Branch: %s\n' "$BRANCH_NAME"
printf 'Worktree: %s\n' "$WORKTREE_PATH"

echo "Fetching latest refs..."
git fetch --all --prune

if [[ -e "$WORKTREE_PATH" ]]; then
  echo "error: worktree path already exists: $WORKTREE_PATH" >&2
  echo "Choose a new name or inspect/reuse the existing worktree." >&2
  exit 73
fi

# If the branch is already checked out in another worktree, git worktree add
# would fail. Report the checked-out path directly so the caller can reuse it.
CHECKED_OUT_PATH="$(git worktree list --porcelain \
  | awk -v branch="refs/heads/$BRANCH_NAME" '
      /^worktree / { path = substr($0, 10) }
      /^branch / && substr($0, 8) == branch { print path; found = 1 }
      END { exit found ? 0 : 1 }
    ' || true)"

if [[ -n "$CHECKED_OUT_PATH" ]]; then
  echo "error: branch is already checked out in another worktree: $CHECKED_OUT_PATH" >&2
  exit 75
fi

LOCAL_BRANCH_EXISTS=0
REMOTE_BRANCH_EXISTS=0
if git show-ref --verify --quiet "refs/heads/$BRANCH_NAME"; then
  LOCAL_BRANCH_EXISTS=1
fi
if git show-ref --verify --quiet "refs/remotes/origin/$BRANCH_NAME"; then
  REMOTE_BRANCH_EXISTS=1
fi

mkdir -p .worktrees

BASE_USED=""
PUSH_NEEDED=1
if [[ "$LOCAL_BRANCH_EXISTS" -eq 1 ]]; then
  BASE_USED="existing local branch"
  echo "Creating worktree from existing local branch..."
  git worktree add "$WORKTREE_REL" "$BRANCH_NAME"
elif [[ "$REMOTE_BRANCH_EXISTS" -eq 1 ]]; then
  BASE_USED="origin/$BRANCH_NAME"
  echo "Creating local branch from existing remote branch..."
  git worktree add -b "$BRANCH_NAME" "$WORKTREE_REL" "origin/$BRANCH_NAME"
else
  if ! git show-ref --verify --quiet refs/remotes/origin/main; then
    echo "error: origin/main does not exist; refusing to fall back to current HEAD" >&2
    exit 78
  fi
  BASE_USED="origin/main"
  echo "Creating new branch from origin/main..."
  # --no-track: without it the new branch tracks origin/main, and with
  # push.default=upstream/tracking a later bare "git push" targets main.
  git worktree add --no-track -b "$BRANCH_NAME" "$WORKTREE_REL" origin/main
fi

# Publish the branch and set upstream. The fully-qualified refspec pins the
# destination ref regardless of push.default or any inherited upstream.
echo "Publishing branch and setting upstream..."
git -C "$WORKTREE_PATH" push -u origin "refs/heads/$BRANCH_NAME:refs/heads/$BRANCH_NAME"
PUSH_NEEDED=0
PUSH_STATUS="succeeded"

UPSTREAM="$(git -C "$WORKTREE_PATH" rev-parse --abbrev-ref '@{u}' 2>/dev/null || echo 'none')"
if [[ "$UPSTREAM" != "origin/$BRANCH_NAME" ]]; then
  echo "error: upstream is '$UPSTREAM', expected 'origin/$BRANCH_NAME'" >&2
  exit 70
fi

INSTALL_STATUS="skipped (no recognized lockfile)"
if [[ -f "$WORKTREE_PATH/pnpm-lock.yaml" ]]; then
  echo "Installing dependencies with pnpm..."
  (cd "$WORKTREE_PATH" && pnpm install)
  INSTALL_STATUS="pnpm install succeeded"
elif [[ -f "$WORKTREE_PATH/package-lock.json" ]]; then
  echo "Installing dependencies with npm..."
  (cd "$WORKTREE_PATH" && npm install)
  INSTALL_STATUS="npm install succeeded"
elif [[ -f "$WORKTREE_PATH/yarn.lock" ]]; then
  echo "Installing dependencies with yarn..."
  (cd "$WORKTREE_PATH" && yarn install)
  INSTALL_STATUS="yarn install succeeded"
fi

cat <<SUMMARY

Worktree setup complete.
- worktree path: $WORKTREE_PATH
- branch name: $BRANCH_NAME
- base used: $BASE_USED
- upstream: origin/$BRANCH_NAME ($PUSH_STATUS)
- dependencies: $INSTALL_STATUS
SUMMARY
