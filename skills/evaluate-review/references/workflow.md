# Evaluate External Review

Evaluate an external pull-request review against the current code and preserve
every useful claim it contains. Judge both the findings and the reviewer.
For behavioral findings, the objective is to close the entire bug class under
the accepted contract. Inventory the subsystem's guarantees, discover the
reusable laws the review implicates, check their interactions, and make the
relevant oracles enforce them across distinguishing legal histories. A passing
reproduction and an accounted-for ledger are not sufficient.

## Repository prerequisites

Read applicable `AGENTS.md` instructions and the required subsystem documents
before judging a behavioral finding or designing its repair. When a repository
glossary exists, read it in full before naming states, actions, boundaries, or
observations. Use its canonical terms across production, models, tests, and the
review report. Declare model abstractions that combine or split those concepts.

After a handoff or compaction, reopen required sources whose relevant contents
are absent from the current context. A prior agent's claim to have read them
does not supply their definitions. Give delegated reviewers the required source
paths and require the reading relevant to each review scope.

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
- For behavioral findings, also track the law and its authority, the test gap,
  oracle owner, legal histories, observation checkpoints, calibration evidence,
  and remaining gaps. Several findings may share a law without merging their IDs.
- Record sibling violations found while testing the law separately from the raw
  review items. Their repair obligations remain even when every raw item has a
  disposition.
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
- `accepted-design`, only for behavior explicitly covered by an approved contract;
  cite the decision and preserve any separate coverage gap
- `deferred`, only under the rare-exception requirements below
- `design-decision`, with the exact ambiguity
- `duplicate`, linked to the canonical item without losing unique details

## Deferral is a rare exception

Default to completing confirmed, authorized, in-scope repairs and their oracle
coverage. A ledger disposition does not grant permission to postpone that work.
Low severity, a green CI run, an existing follow-up note, implementation effort,
or hypothetical compatibility concerns do not justify deferral by themselves.

Every proposed deferral must record all of the following:

- The exact unresolved law or work, with evidence of the blocker or scope limit.
- Why completing it now is inappropriate or impossible, including why a narrower
  repair or oracle improvement cannot resolve it within the authorized scope.
- The remaining user-visible risk and whether the PR can safely proceed with it.
- A durable destination, an accountable owner, and a concrete condition for
  resuming the work. Do not invent an owner or treat a vague future task as one.
- The user's explicit agreement to postpone authorized in-scope work. Existing
  instructions can supply that agreement; a reporting category cannot.

Without that justification, keep the item `confirmed-open`; use
`design-decision` when a real product choice prevents progress. Complete
unaffected work. Ask for the missing decision, not renewed permission for
routine fixes already authorized. An approved product limitation is
`accepted-design`, not deferred implementation. In review-only work, identify
needed repairs without expanding permission to edit; they remain open.

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

## Plan oracle changes for the whole review first (REQUIRED)

After you create the ledger, and before you work on any single finding, look
at every behavioral finding together. Findings that seem separate often share
a missing history dimension, lane crossing, driver path, or observation. One
oracle change can then reveal all of them, and also siblings that no reviewer
reported.

1. Group the findings by the state, boundary, history dimension, or
   observation they share.
2. For each finding, name the oracle change that would have generated it: a
   grammar action or weight, a crossing of existing lanes, a driver path, an
   observation, or a reach state. State why the current oracle missed it.
3. Choose the smallest set of oracle changes that would generate every
   finding. Prefer one dimension that reaches several findings and their
   nearby histories over a separate pinned witness for each finding.
4. Make those changes first. Follow the repository's oracle-authoring rules.
   Run the extended oracle against unchanged production. Record which findings
   it reproduces, which it misses, and any new counterexamples. Treat a miss as
   a gap in the plan, and revise the plan before you change production.
5. Then repair production. Use the extended oracle as feedback on all findings
   at once. Use a separate probe only for a finding the oracle cannot yet
   express, and record why.

Skip this step only when the review has no behavioral findings.

## Discover and enforce the laws (REQUIRED)

For each behavioral finding, reason beyond the reported trace. What must remain
true across the relevant legal histories, and why did a green test suite allow
this violation? Inventory the neighboring guarantees that share its state,
boundary, or observation cut; check whether the proposed law is suitable and
whether enforcing it could violate another promise. Keep a proposed contract
revision distinct from a defect under the accepted contract. Apply the
repository's oracle guide, glossary, architecture, and coverage map when
present. Find the primary executable owner and read its limits before extending
or introducing a model.

1. **State the law and authority.** Derive it from the public contract, established
   promise, or an explicit design decision. Name the boundary and distinguish
   proposed policy from discovered obligations. Existing production behavior is
   evidence, not authority. Do not promote an implementation tactic into the
   product law.
2. **Diagnose the test gap.** Identify the wrong model rule, lost distinction,
   missing generator dimension, unreachable transition, permissive classifier,
   incorrect driver boundary, or absent observation that allowed the bug.
   Say when the existing oracle correctly enforced a narrower law and the
   failure came from claiming more than that law covered.
3. **Audit the complete chain.** Compare contract prose, independent model,
   legal history grammar, real production driver, and refinement assertions.
   Every claimed model output must reach an assertion at the promised checkpoint.
   Check intermediate observations when the law concerns ordering, settlement,
   atomicity, readiness, or lifecycle authority. Final-state equality can hide
   a transient violation.
4. **Challenge the rule.** Reach the original trace and neighboring legal
   histories that distinguish the law from plausible wrong designs, including a
   narrow patch that fixes only the reported example. Cross interacting laws
   where their shared state or timing matters. Inspect exclusions for valid
   cases accidentally removed from scope. Check that the recorder can represent
   relevant omissions, duplicates, partial results and ordering, rather than
   normalizing them away.
5. **Repair the primary oracle first.** Before production edits, inventory the
   materially affected public receiving paths and their promised observation
   cuts. Required real-host receiving witnesses belong in this gate, alongside
   controlled core comparisons. Run them on unchanged production: record the
   defect's RED result and the neighboring guarantees' results. A setup failure
   or missing required witness blocks production edits; fix the test path first.
   Require reach separately for each receiving path. Retrospective verification
   or a documented process gap does not satisfy this gate.
   Before you create or edit any oracle,
   load the repository's oracle-authoring guidance, such as
   `.agents/skills/oracle-authoring/SKILL.md` and the oracle guide it names.
   A review repair is still an oracle edit. When the same law must hold in a
   controlled and a real environment, add a driver to the existing oracle
   rather than a separate test with its own expected results.
   When changes are authorized, extend the primary oracle's
   model, grammar, driver or observations before changing production. If no
   oracle owns the law, create the smallest independent judgment that can enforce
   it; explain when a focused test is sufficient instead. Preserve useful
   regressions as replay witnesses. Add a separate owner only for a boundary
   requiring a different independent judgment. Keep contract prose, model and
   assertions consistent; do not rewrite expectations merely to match
   production output.
6. **Prove enforcement.** Show the relevant comparison rejecting the original
   implementation or a plausible hostile mutant at the intended checkpoint,
   then passing the repair. Calibrate against a plausible narrow fix when it
   could pass the reported trace but break the wider law. Distinguish assertion
   failures from timeouts, setup errors, unreached paths and surviving mutants.
   Test conditional laws on both the triggering premise and a distinguishing
   neighboring case. When controlled premises support a real-provider claim,
   identify the receiving witness.
7. **Account for the whole claim.** Report coverage as law × legal histories ×
   production paths × public observations at named checkpoints. A known reachable
   in-scope counterexample or unenforced part of the law keeps the item open.
   Do not manufacture closure by narrowing scope to the passing reproduction.
   State finite bounds and genuine external limits; random green is not proof
   of every possible history.

For each law, explicitly answer: **Is it fully encoded in the model and reachable
histories? Is it enforced by assertions at every required observation cut? What
wrong implementation proves those assertions are sensitive? Which neighboring
guarantees does the repair preserve?** Any missing link is remaining work, not
evidence supplied by a neighboring green test.

Use the evidence appropriate to non-behavioral findings. Documentation, build
configuration and API cleanup may need source, build or declaration checks
instead of a state model. Explain that choice. A documentation edit that merely
acknowledges broken promised behavior does not close the behavioral finding.

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

1. Reproduce the failure and extend the relevant oracle under the law audit
   above. Run it before the production fix and record the exact RED result.
2. If the user authorized changes, apply the simplest production change that
   enforces the law across its in-scope histories.
3. Run the same oracle and relevant surrounding tests for GREEN.
4. Test the proposed classifier or expected-failure gate against collateral
   corruption. A broad waiver is not a valid fix.
5. Mark the item `fixed-now` only when both the implementation repair and the
   applicable law coverage are complete within the justified scope. If only the
   reported trace is repaired, record that progress and keep the gap open.
6. For each confirmed bug with an applicable primary oracle, name the grammar
   dimension or observation that would have generated it. `fixed-now` requires
   that dimension in the oracle. A pinned example or focused regression alone
   does not satisfy an applicable oracle law; explain when no oracle is practical.

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
5. Recheck every behavioral law and newly discovered sibling violation against
   the final model, histories, driver, observation cuts and calibration.
   Identify any gap hidden by a passing final snapshot, excluded valid history,
   or documentation-only correction.
6. Verify every deferral meets all rare-exception requirements. Preserve a
   durable destination for still-useful stale/refuted ideas as well.
7. Report ledger totals by disposition and name every evidence or coverage gap.
   Distinguish an accounting-complete evaluation from completed implementation
   and oracle work. Neither ledger totals nor green CI erase open obligations.

The loss accounting is complete only when:

`raw items = fixed + confirmed-open + already-fixed/stale + refuted + accepted-design + deferred + design-decision + duplicates`

## PR readiness gate

An evaluated review is not a verdict that the PR is ready. When the task asks
about PR quality, completion, or merge readiness, give a separate verdict on
the current head:

- `ready`: no known reachable violation of an accepted, in-scope contract or
  unresolved product decision needed for this PR; authorized repairs and their
  applicable oracle coverage are complete; required checks and intended
  integration have been verified. State the finite evidence and accepted limits.
- `not ready`: a confirmed in-scope defect remains, or a product decision needed
  to implement the promised behavior is unresolved. Name the blocker and next
  action. A coverage-map entry or green CI does not turn it into a limitation.
- `readiness unproven`: a material behavior, final-head change, or intended
  integration path lacks a decisive witness. Name the missing experiment and
  avoid claiming the PR is good merely because no current test fails.
- `not assessed`: the request was only to evaluate a review, or required PR and
  CI evidence was unavailable. Finish the review audit without implying a PR
  verdict.

Before a `ready` verdict, verify the final pushed head; revisit findings and
oracle evidence affected by later commits; and distinguish the latest external
review's covered commit from the current head. Where companion PRs are intended
to work together and change the same behavior, verify their combined tree or
state that integration remains unproven. Do not require exhaustive histories or
a new third-party review for every nonsemantic edit. An approved, documented
out-of-scope limit or fully justified deferral may coexist with readiness; a
known reachable in-scope counterexample may not.

## Output format

For a review involving an oracle or generated-history test, lead with what the
review taught us about the laws. Then give the lossless item ledger and reviewer
assessment. For a review without an oracle boundary, keep the item-led format
and omit the law table when no behavioral law applies. Match detail to the
number of distinct laws, not the number of comments.

### Implementation state

State the reviewed/current commit and whether production or oracle repairs
were actually made. Say plainly when confirmed findings remain unfixed. A
temporary probe or GREEN hostile mutant is evidence, not a branch repair.

### Law findings (oracle-related reviews)

Group related item IDs under each independent promised law. Put falsified laws
first. Use a compact table or short sections that answer:

| Law and authority | What the existing oracle actually proves | Decisive experiment | Inference about the gap | Repair and next enforcement witness |
| --- | --- | --- | --- | --- |

- State the externally observable law before discussing a production mechanism.
  Distinguish the law from the reviewer's proposed fix.
- Describe the existing contract/model, reachable history grammar, production
  driver, and asserted observation cut. Say which combinations it proves and
  which it merely suggests. An assertion about one participant does not
  prove another participant's behavior; final state does not prove an
  intermediate cut.
- Give the original RED or same-path disproof, a distinguishing neighboring
  history, and hostile-mutant calibration when applicable. Label setup failure,
  missing premise, surviving mutant, and unrun test honestly. Never present a
  mutant GREEN as the repaired branch's GREEN.
- Identify the precise reason a green suite missed the issue: wrong reference
  rule, absent participant or value dimension, unreachable history, driver
  seam, missing assertion, or overclaimed scope. Do not call a correctly
  scoped oracle wrong merely because a broader law was never encoded.
- Name the primary owner, the next decisive model/history/assertion change,
  the required public checkpoint, and any separate real-provider receiving
  witness. State whether the law is fully encoded, reached, and enforced; a
  reachable in-scope counterexample means it remains open.

Keep accepted limits and efficiency observations distinct from falsified
correctness laws. A measured work count does not by itself create a new
performance promise; an explicit contract limit does not repair an in-scope
counterexample. Explain what product decision or work budget would turn an
observation into a law.

### Finding ledger

| ID | Claim | Evidence | Technical verdict | PR action | Durable value/destination |
|---|---|---|---|---|---|

Include every raw item, including lower-severity comments, and cross-reference
the law findings without merging source-order IDs.

### Reviewer assessment

Assess accuracy, depth, signal-to-noise, prioritization, fix quality, and give
a hire recommendation with evidence. Distinguish a useful counterexample from
an incomplete proposed cure or an unproved downstream consequence.

### Changes and GREEN results

List only changes actually made and exact verification. Separate original RED,
temporary mutant GREEN, repaired-branch GREEN, and real-provider evidence.

### Refutations, accepted limits, and design decisions

State the tested path and preconditions for refutations, cite approved contracts
for accepted designs, and preserve useful ideas. For each rare deferral, give
the full justification, remaining risk, destination, owner, resumption condition,
and user agreement. State the exact unresolved choice for a design decision.

### Loss audit

Report disposition totals, current commit, and every unresolved evidence or
oracle-coverage gap. State separately whether the item accounting is complete
and whether authorized implementation and oracle repair are complete.

### PR readiness

When requested, give the readiness verdict above with its blocking defects,
missing evidence, or verified scope. Keep it separate from review accounting
and CI status.

---

**Paste the external review below this line:**

$ARGUMENTS
