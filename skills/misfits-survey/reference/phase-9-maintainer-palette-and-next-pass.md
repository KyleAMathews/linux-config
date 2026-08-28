# Phase 9: Maintainer Palette and Next Pass

## Goal

Present a maintainer triage palette, record decisions, and prepare the living document for the next run.

## Palette, Not Single Recommendation

Do not force one agent-chosen recommendation. Present structurally distinct routes:

- quick fix / tracer bullet;
- small repair move / configuration;
- documentation or design clarification;
- architectural intervention;
- leave as-is because current form protects a stronger force;
- investigate with a specific evidence request;
- cleanup stale artifact: close/update issue, docs, Discord lore, or social reference;
- observe longer with a next observation trigger.

For each route separate:

- agent-suggested leverage;
- maintainer priority;
- decision;
- rationale captured for future runs.

## Design Move Shape

| Move | Context | Forces balanced | Addresses | Strengthens | Risks | Smallest useful version | Setup/ongoing cost | Validation | Maintainer priority |
|---|---|---|---|---|---|---|---|---|---|

## Candidate Reusable Patterns

Only add a candidate pattern when recurrence and evidence justify it. Do not call one-off local findings patterns.

Each candidate pattern needs:

- context;
- recurring misfit/problem;
- forces;
- repair/configuration;
- when not to use;
- evidence/examples;
- follow-up check;
- confidence.

## Decision Memory

| Item | Decision | Rationale | Future-run instruction | Next observation trigger |
|---|---|---|---|---|

## Maintainer-Approved Closure Actions

Only include actions the maintainer explicitly approved. Do not close issues/PRs automatically. Prepare exact comments for review.

| Artifact | Approved action | Draft comment | Evidence link |
|---|---|---|---|

## Survey Metadata Update

Update:

- `last surveyed through`;
- current pass window;
- sources searched;
- sources unavailable;
- source-quality caveats;
- privacy/redaction notes;
- open ground-truth tasks;
- next targeted evidence gaps;
- suppressed stale/phantom patterns;
- archived or manually pruned sections, if the maintainer chose to archive any part of the living document;
- maintainer-approved stale artifact closure/comment actions.

## Final Checks

Before ending:

1. Confirm all candidate misfits have citation tokens or are moved to Questions / Leads.
2. Confirm unresolved tensions are not framed as defects by default.
3. Confirm future triage agents have actionable recognition/routing guidance.
4. Confirm stale artifact closure/comment actions are explicitly maintainer-approved.
5. Confirm the maintainer knows what was captured as judgment vs fact vs preference.

## Completion Output

Report:

- living document path;
- decisions captured;
- design moves or routes selected;
- next-pass instructions;
- remaining open questions.

Then stop. Do not begin implementation work unless the maintainer explicitly asks for a separate implementation plan.
