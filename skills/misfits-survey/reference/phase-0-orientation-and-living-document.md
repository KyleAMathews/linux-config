# Phase 0: Orientation and Memo Setup

## Goal

Locate or create the signal inventory memo and establish the inventory boundary.

## Steps

1. Restate the operating principle: the agent gathers and organizes signals; maintainers use the memo to dispatch follow-up work.
2. Determine the inventory boundary from `$ARGUMENTS` or ask the maintainer for it. The boundary may be a repo, repo area, package, API, release, issue set, PR set, community channel, or design question.
3. Locate an existing signal inventory memo. Search likely paths: `docs/misfits-survey.md`, `docs/misfits/<area>.md`, `.claude/misfits-survey.md`, `docs/signal-inventory.md`, and maintainer-provided paths.
4. If no document exists, propose creating one and ask where it should live. Do not create it until the maintainer confirms the path.
5. Determine mode:
   - **Baseline inventory**: no memo exists or maintainer wants a reset.
   - **Next-run time-window pass**: continue from the memo's `last surveyed through` date.
   - **Targeted pass**: inventory a package, API, release, issue set, PR set, or topic.
6. If continuing a memo, read prior source coverage, cluster assignments, ledger paths, and known gaps before gathering new evidence.
7. Define the inventory boundary: what repo area, source types, issue/PR states, and date windows are in scope.
8. Do not gather evidence yet. Phase 0 only orients the inventory work.

## Completion Output

Report:

- inventory boundary;
- memo path or proposed path;
- mode;
- sources that appear likely to matter;
- prior memo context read, if any;
- current phase result.

Then ask: **"May I proceed to Phase 1: Repo Framing?"**

Only proceed when the maintainer gives explicit permission.
