# Phase 1: Repo Framing

## Goal

Build a concise inferred repo framing before looking at issue/PR signals. This helps readers understand later clusters without turning the memo into design analysis.

## Steps

1. Read README, contributing docs, architecture docs, release notes, package docs, examples, and existing design memory inside the survey boundary.
2. Summarize what the repo/system is trying to be. Keep this concise: a design constitution, not a full spec.
3. Identify apparent design centers and public promises: abstractions, workflows, docs structure, APIs, tests, package boundaries, and documented contribution/release rules.
4. Record apparent invariants/tradeoffs only if directly documented or clearly inferable. Label them as inferred and maintainer-correctable.
5. Keep this concise. Do not start diagnosing issues or proposing design changes.

## Completion Output

Produce a draft **Repo Framing** with:

- project purpose;
- apparent design centers/public promises;
- documented rules/design constraints noticed;
- invariants;
- apparent tradeoffs, if directly supported;
- notes that inferred material is maintainer-correctable.

Then ask: **"May I proceed to Phase 2: Open-Item Census and Evidence Gathering?"**

Only proceed when the maintainer gives explicit permission.
