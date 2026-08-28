# Phase 8: Triage Guide and Design Memory

## Goal

Convert maintainer judgments, validated misfits, stale patterns, tradeoffs, and tensions into triage-ready design memory.

Future issue/PR/discussion triage agents should be able to read the living document and answer:

- Is this new report evidence of a known real misfit?
- Is it a stale pattern that was already fixed?
- Is it a phantom tension we have decided not to resurface without stronger evidence?
- Is it an accepted tradeoff or design invariant?
- Is it a new signal that should be added to the evidence ledger?
- Does this PR strengthen or weaken an existing center of fit?
- Does this proposal violate a recorded design invariant?
- Does this report require ground-truth reproduction before interpretation?
- Is this repeating an old issue that should be closed or redirected?

## Reader-Friendly Front Matter

Before or alongside the Triage Guide, create:

### Reader's Guide

Explain what different readers should read:

- 10-minute maintainer/colleague review: Positive Design Summary, Main Findings, Cluster Briefs, Decisions Needed.
- Issue/PR triage: Triage Guide, Known Real Misfits, Stale/Fixed Artifacts, Ground-Truth Triggers.
- Design planning: Cluster Briefs, Constructive Subproblems, Tensions to Steward, Maintainer Judgments.

### Main Findings

Write 3–7 concise findings, each with:

- why it matters;
- evidence links/quotes;
- current status;
- decision needed.

## Triage Rules

New triage evidence must be recorded with a citation token: issue/PR/discussion URL, file path, command output, reproduced result, exported message reference, or maintainer statement.

When evidence could fit multiple buckets, route in this order:

1. **Ground-truth trigger**: if the claim is behavior-like, docs/API mismatch, stale-open issue, or reproducible report, verify current reality first.
2. **Stale or fixed pattern**: if current behavior/docs/API no longer match the report, route to cleanup or closure rather than treating it as current design evidence.
3. **Known real misfit**: if verified current and matching an existing recognition rule, attach the new citation to that misfit.
4. **New candidate signal**: if verified current but not covered by existing memory, add it to the evidence ledger for a future survey pass.
5. **Maintainer judgment**: if the claim is taste, strategy, social/process friction, or accepted-tradeoff territory, ask for judgment after agent groundwork.

Docs/API mismatch default: first classify as a ground-truth trigger; verify docs currency and current API behavior; then route to stale/fixed cleanup unless supported current docs still mislead users.

## Triage Guide Sections

### Known Real Misfits

| Misfit | How to recognize new evidence | Current status | Where to route |
|---|---|---|---|

### Accepted Tradeoffs / Invariants

| Invariant or tradeoff | What it protects | Common reports that touch it | Response posture |
|---|---|---|---|

### Stale or Fixed Patterns

| Pattern | Fixed by | How to verify | Cleanup response |
|---|---|---|---|

### Stale Artifact Cleanup Queue

These issues/PRs/docs/social references appear outdated, fixed, duplicated, superseded, or no longer actionable. They require maintainer validation before closure or comment.

| Artifact | Why stale | Evidence | Suggested action | Maintainer decision |
|---|---|---|---|---|

### Phantom Tensions / Suppressed Patterns

| Pattern | Why suppressed | Resurface only if |
|---|---|---|

### Ground-Truth Triggers

| Claim type | Verification expected before interpretation |
|---|---|

## Judgment Conversion Rules

- Real misfit → known misfit recognition rule.
- Accepted tradeoff → invariant/tradeoff response posture.
- Stale/fixed → stale pattern plus verification and cleanup instruction.
- Phantom → suppression rule with resurface threshold.
- Needs more evidence → ground-truth or evidence-gathering trigger.
- Validated design move → PR evaluation criteria.

## Design Memory Rules

- Record maintainer rationale, not just verdicts.
- Record rejected interpretations so future runs do not re-raise them.
- Record uncertainty and next observation trigger.
- Preserve private-source details appropriately; publish aggregate summaries when needed.

## Completion Output

Update or draft the living document's **Triage Guide** and **Maintainer Judgment Log**.

Then ask: **"May I proceed to Phase 9: Maintainer Palette and Next Pass?"**

Only proceed when the maintainer gives explicit permission.
