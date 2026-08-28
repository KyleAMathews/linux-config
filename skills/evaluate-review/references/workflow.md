# Evaluate External Review

Evaluate an external pull-request review against the current code and preserve
every useful claim it contains. Judge both the findings and the reviewer.

## Core rule: verdicts must be lossless

Do not let prioritization, finding caps, overlap, stale code, or a concise final
answer erase a review item. A claim can be wrong as stated yet still reveal a
valuable missing test or design question.

Keep three judgments separate for every item:

1. **Technical validity** — is the claim true on the reviewed or current commit?
2. **PR action** — fix now, already fixed, defer, ask for a design decision, or
   take no action?
3. **Durable value** — does the review expose a test idea, invariant, cleanup,
   documentation need, or future investigation worth preserving?

## Finding ledger (REQUIRED)

Before testing or editing, create an append-only ledger from the raw review.

- Give every explicit finding, footnote, capped item, non-blocking comment,
  deferred suggestion, and broader testing idea a stable source-order ID.
- Preserve the original claim and proposed fix. Do not merge or drop items
  because they overlap; cross-reference them instead.
- Record file/line references, severity, and the commit or HEAD being checked.
- Track technical verdict, evidence, PR action, durable value, and destination.
- A reporting or severity cap may change ordering only. It must never remove an
  item from the ledger.
- If the review is long, parallel, or likely to span compaction, keep the ledger
  in a task-local scratch file or an existing user-requested todo file. Do not
  commit that file unless asked.

Use these dispositions; do not use a vague `skip`:

- `fixed-now`
- `confirmed-open`
- `already-fixed` or `stale`, with the surviving idea recorded separately
- `refuted`, with evidence
- `deferred`, with a named durable destination
- `design-decision`, with the exact ambiguity
- `duplicate`, linked to the canonical item without losing unique details

## Evaluation criteria

### Reviewer quality

Assess:

- Technical accuracy
- Depth of analysis
- Signal-to-noise ratio
- Prioritization
- Quality of proposed fixes
- Ability to distinguish a product bug, test-integrity flaw, coverage gap,
  maintainability issue, and design choice

Give a clear hire recommendation with evidence.

### Finding quality

For every ledger item, determine:

- Whether it is real
- Its severity
- Whether the proposed fix is correct and idiomatic
- What edge cases or adjacent regimes the reviewer missed
- Whether any part remains valuable if the main claim is stale or false

## Evidence and RED/GREEN verification (REQUIRED)

Do not accept or reject behavioral claims from code reading alone. Use the
evidence form that matches the claim:

- **Product correctness:** reproduce the wrong public behavior with a failing
  test or focused executable probe.
- **Test-integrity/classifier:** use an adversarial or mutated subject that the
  current test wrongly accepts.
- **Generator coverage:** sample or instrument the arbitrary and prove the
  claimed regime is unreachable or statistically absent.
- **Async/lifecycle:** use controlled promises, signals, events, or counters;
  avoid timing-only evidence when a semantic seam exists.
- **Performance/work:** use deterministic counters or cardinality laws rather
  than elapsed time where possible.
- **Docs/maintainability:** use direct source evidence and a focused validation;
  do not invent a product RED test for a non-behavioral claim.

For a confirmed behavioral issue:

1. Run the probe before the fix and record the exact RED result.
2. If the user authorized changes, apply the narrow fix.
3. Run the same probe and relevant surrounding tests for GREEN.
4. Test the proposed classifier or expected-failure gate against collateral
   corruption. A broad waiver is not a valid fix.

If the current code passes, do not immediately call the review useless. Check:

- Whether the review targeted an older commit
- Whether the repro missed a required pipeline or lifecycle precondition
- Whether a recent fix changed the failure into another bug
- Whether the proposed test still covers a valuable boundary

If the claim still cannot be reproduced after checking the commit, path, and
preconditions, seek clarification instead of declaring it refuted. Give the
reviewer or user the exact probe, observed result, commit, and suspected missing
precondition, and ask for the smallest failing fixture or sequence. Keep the
ledger item `confirmed-open` with an evidence gap until the clarification is
resolved. Mark it `refuted` only when a same-path probe reaches every stated
precondition and disproves the claim.

Do not claim that a passing test refutes a review unless the test reaches the
same path and preconditions.

## Branch movement and parallel work

- Record the starting commit.
- If HEAD changes during evaluation, mark earlier evidence stale and rerun the
  affected items against the new HEAD.
- Consolidate parallel-agent results into the one ledger. Agent summaries are
  evidence inputs, not a substitute for reconciliation.
- Do not treat `tests pass` as proof that every review item was examined.

## Final loss audit (REQUIRED)

After fixes and before the final verdict:

1. Return to the raw review, not a summary.
2. Account for every original item in the ledger.
3. Recheck capped findings, footnotes, prose outside finding lists,
   non-blocking suggestions, and items killed during verification.
4. Compare each item with the final diff and current HEAD.
5. Ensure every `deferred` or still-useful stale/refuted idea has a durable
   destination. If none exists, report it as unresolved rather than dropping
   it.
6. Report ledger totals by disposition and name any item that lacks evidence.

The audit is complete only when:

`raw items = fixed + confirmed-open + already-fixed/stale + refuted + deferred + design-decision + duplicates`

## Output format

### Reviewer assessment

Accuracy, depth, signal-to-noise, fix quality, and hire recommendation.

### Finding ledger

| ID | Claim | Evidence | Technical verdict | PR action | Durable value/destination |
|---|---|---|---|---|---|

Include every item. Keep entries concise; do not omit lower-severity rows.

### Changes and GREEN results

List only changes actually made and the exact verification.

### Refutations and stale findings

State the path/preconditions tested and preserve any surviving useful idea.

### Deferred and design decisions

Name the destination or the exact question requiring user input.

### Loss audit

Report disposition totals, current commit, and any unresolved evidence gap.

---

**Paste the external review below this line:**

$ARGUMENTS
