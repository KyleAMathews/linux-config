---
description: Create a changeset file for the current branch's changes
---

Create a changeset file documenting the changes on the current branch. Changesets are used for versioning and changelog generation.

## Process

1. **Check if this repo uses changesets**: Look for `.changeset/config.json`. If it doesn't exist, this repo doesn't use changesets—inform the user and stop. Don't create a `.changeset` directory.
2. Analyze what changed: `git diff main --stat` and `git log main..HEAD --oneline`
3. Identify which packages were modified (look in `packages/` directory)
4. Determine the appropriate version bump:
   - `patch`: Bug fixes, documentation, non-breaking changes
   - `minor`: New features, backwards-compatible additions
   - `major`: Breaking changes

   **Important for pre-1.0 packages**: If the package version is < 1.0.0, use `patch` for new features and improvements. Reserve `minor` only for significant API additions. Pre-1.0 packages don't follow strict semver—patches are the norm for most changes.
5. Generate a changeset filename (use kebab-case descriptive name, e.g., `fix-query-error.md` or `add-retry-support.md`)
6. Write the changeset file to `.changeset/<filename>.md`

## Changeset Format

```markdown
---
'@tanstack/package-name': patch
---

Brief description of the change. Focus on what changed and why, not implementation details.
```

## Multiple Packages

If changes affect multiple packages, list them all:

```markdown
---
'@tanstack/db': minor
'@tanstack/react-db': minor
---

Added new feature X that affects both core and React packages.
```

## Guidelines

- Use present tense ("Add feature" not "Added feature")
- Keep descriptions concise (1-3 sentences)
- For docs-only changes, use the main package the docs relate to
- If no packages changed (e.g., CI-only), ask if a changeset is actually needed
- Don't include the changeset if it's truly infrastructure-only with no user impact

## After Creating

Always commit and push the changeset file immediately after creating it. Do not ask - just do it.

## Validation

If `scripts/check-changeset.mjs` exists in the repo root, run `GITHUB_BASE_REF=main node scripts/check-changeset.mjs` after creating the changeset to verify all affected packages are covered. If validation fails, create additional changesets for the missing packages and re-run until it passes.
