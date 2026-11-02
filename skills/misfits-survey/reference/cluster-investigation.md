# Investigate selected survey clusters

Use this optional workflow when the user requests deeper investigation. The
default survey remains a bounded inventory. Keep investigation reports separate
from that inventory, and include important standalone items in the requested
scope. A grouping is a lead, not evidence of a common cause.

The objective is to distinguish defects under accepted promises, incomplete
oracle enforcement, instrument defects, proposed features, and unresolved
contracts. Prioritize accepted-law defects and instrument integrity before
feature implementation. Do not infer priority from issue count alone.

## Dispatch

Declare the mode and scope:

- `investigate`: read sources, run experiments, improve accepted-law oracles and
  their drivers, and use recorded temporary mutants. No production repairs.
- `repair`: also repair confirmed accepted-law violations, after the repository's
  pre-edit evidence requirements. A new or revised promise needs a product
  decision; continue independent enforcement work while that decision is open.

Freeze a fresh repository baseline for the wave. Give each writing investigator
an isolated worktree and a source packet containing full reports and comments,
retained extraction and relevant historical evidence. Record hashes, source
capture dates, dependency/runtime versions, and unavailable sources. Read
contracts from that worktree; the main checkout can differ. Follow dated
maintainer decisions when a coverage note conflicts with a later contract.

Delegate by cluster or coherent law boundary when authorized. Before overlapping
edits, reconcile a registry of primary oracle owners, writer files, receiving
paths, dependencies and shared host/provider resources. Assign one writer per
shared owner. Separate worktrees do not justify competing reference models.
Other workers contribute witness inputs and read-only evidence. Release heavy
execution slots during reading and reporting; four concurrent heavy commands is
a useful initial limit, adjustable to the host. Do not wait for unrelated
clusters before starting an urgent, reconciled investigation.

Each worker reads applicable repository instructions and relevant contracts
before designing experiments. Read the glossary, oracle guide, coverage map and
owner limits where the repository supplies them; follow its required reading.
Load local oracle-authoring/review skills when present. An absent document does
not itself block investigation: record the missing authority or ownership and
seek independent evidence. An oracle's prose is a starting point; follow its
authority to the public contract and neighboring promises.

## Lossless claims

Read every assigned source in full before experiments or edits. Create an
append-only ledger with stable IDs. Split observations, cause hypotheses,
downstream consequences and proposed remedies; preserve qualifications and
cross-reference duplicates. Record newly discovered siblings separately.

Use these canonical `category` values, keeping source wording in another field:

| Category | Evidence needed |
| --- | --- |
| `product-bug` | An accepted promise applies, and executed evidence shows a wrong public observation on the stated path and checkpoint. |
| `coverage-gap` | An accepted law lacks adequate model, history, path, observation, comparison or calibration. A product violation need not be established. |
| `model-harness-defect` | The model, grammar, driver, recorder, comparison or replay makes an incorrect claim. |
| `feature-request` | The capability needs a new or stronger promise. |
| `contract-decision` | Authority is missing, conflicting or does not select between material outcomes. |
| `non-behavioral` | Documentation, maintenance or retained source context; use a `recordKind` to distinguish these. |

Missing written oracle law is not automatically a feature. Show whether an
accepted promise entails it. Existing implementation behavior is not authority.
A reproduced symptom can remain a contract question. Separate current behavior
from historical API/version claims and from a suggested new API remedy.

Keep technical validity, category, action, durable value and evidence strength
separate. Use dispositions `unverified`, `confirmed-open`, `already-fixed`,
`stale`, `refuted`, `accepted-design`, `design-decision`, `duplicate`, or
`fixed-now`. Deferral needs the user's agreement and the repository's required
justification; a ledger label does not authorize it. A report complete in
investigation mode can leave a product defect confirmed-open.

Use a small common schema before fan-out. For example, creation and verdict
events share `id`, `event`, `source`, `baseline`, `category`,
`technicalValidity` (report/current), `disposition`, `action`, `durableValue`,
`evidenceStrength` and `evidence`. Creation also preserves `claim`,
`qualifications`, `recordKind` and `proposedRemedy`. Verdicts append rather than
rewrite earlier events. The coordinator retains events and computes an effective
latest-state projection. Count context records separately from actionable claims;
claim totals are not independent bug totals.

Do not mark a broad claim fixed by naming only its completed portion. Record
partial completion and keep missing in-scope work open. In particular, “other
views unaffected” cannot silently become “rows and status unaffected” while
shared health changes.

## Laws before repairs

Plan evidence for the whole cluster before handling findings one at a time.
Several reports can share a missing history dimension; one report can involve
several independent laws. For each law/path/checkpoint, trace:

`authority → independent model → legal histories → production driver → recorder → comparison`

State the participant, preconditions, allowed observation, checkpoint and limits.
Identify neighboring laws and rival predictions. Ask whether the model encodes
the promise, histories reach it, the real path receives it, and the comparison
rejects a relevant wrong result while permitting lawful alternatives.

Extend the primary owner rather than creating a duplicate model. A different
boundary can need its own independent judgment; another host/provider generally
needs a receiving driver for the same law. Distinguish core controlled evidence
from proof that a real provider supplies the premise. Neither substitutes for
the other. Follow repository requirements for declared reach and generated
histories; a pinned example alone does not close a general defect class.

An existing oracle can already detect the reported defect, including through an
expected-failure test. Demonstrate its actual evidence rather than inventing a
false-green gap or forcing unnecessary edits.

## Execute and calibrate

Replay the original coordinates where practical, then test the frozen baseline.
Record exact argv, cwd, revisions, test/support fingerprints, selected/executed
test counts, seeds/paths, observation cuts, reach and raw logs. A command that
selects zero tests is not a replay. New properties need their own campaign and
replay selection plus any repository registration. Preserve budgets.

Keep these outcomes distinct: intended assertion failure, lawful control,
setup failure, timeout, runtime failure outside comparison, unreached premise,
mutant survival and scoped equivalence. A caught rejection or passing diagnostic
with no retained observations does not prove the intended path occurred.

Capture successful random seeds and reach when the runner supports it; state
when it does not. Report completed-history reach separately from failed traces
and shrink attempts. A broad temporal counter does not prove a particular
key-overlap chain at the promised cut.

On unchanged production, use distinguishing histories and required receiving
paths. Check driver assumptions about recovery, draining and quiescence: a final
comparison can demand recovery that the driver never supplied. Preserve the
first violation through shrinking and cleanup; keep cleanup diagnostics separate
instead of replacing the failure or claiming a clean process.

Calibrate the shared comparison with a plausible wrong implementation or wrong
observation and a lawful control through the same judgment. Where relevant,
challenge a one-trace fix. A coverage-only improvement may leave production
GREEN while newly rejecting a mutant; do not manufacture product RED. Restore
temporary mutants completely and verify production identity before handoff.

For authorized repair, first satisfy the repository's pre-edit evidence gate:
accepted law, sensitive independent comparison, measured reach, unchanged-code
RED and required receiving evidence. Then repair production, obtain GREEN with
the same instrument, reject the original defect or hostile mutant, and preserve
neighboring guarantees. Missing evidence blocks dependent edits, not unrelated
investigation. Never relax comparisons or exclusions to obtain GREEN.

## Freeze and challenge

Before executing final independent review, freeze the test/model/driver/support
artifacts and record hashes. Finish temporary mutants first. The reviewer uses
an isolated matching checkout or verifies hashes before and after each run;
do not execute against a file an author is mutating. Changed artifacts invalidate
affected evidence until rerun. Reports can continue separately.

A fresh reviewer receives sources, authority, patch and raw evidence without an
instruction to endorse the author's conclusion. Challenge classification,
independence, legal history, fixture premises, receiving boundary, observation
fidelity, calibration, neighboring laws and source loss. Resolve material
disagreement with a distinguishing witness or retain the exact product question.
Two agents agreeing is not evidence.

## Deliver and evaluate

Each worker returns:

```text
brief.md             baseline, sources, mode, owners and environment
claims.jsonl         append-only source and sibling events
laws.md              authority/enforcement matrix and rivals
experiments.jsonl    exact reproducible receipts and log paths
report.md            law, experiment, inference, remaining work, then item ledger
oracle.patch         test-only patch or referenced revision, when applicable
pilot-feedback.md    actual workflow friction and useful amendments
```

The coordinator owns the effective master ledger, owner registry, bug/oracle
queue, feature queue, decision queue and integration record. Return to raw
sources for the loss audit. Account for every ID, including remedies, hypotheses,
qualifications and siblings. Report source accounting, scoped law audit,
executable evidence and production closure separately. Keep missing witnesses
and conditional conclusions explicit. Random GREEN, complete accounting and an
investigation report do not establish bug-class closure or PR readiness.

Integrate patches only when requested and recheck affected evidence at the
combined head. Keep oracle-only patches with intentional REDs clearly marked
as investigation artifacts. Record remaining contract ownership and witnesses
in the repository's coverage map or a concrete reviewable amendment.

After a trial, assess new distinctions, executed evidence, source loss, false
claims caught by review, coordination cost and remaining gaps. Extend the skill
only with improvements supported by that use; keep optional investigation from
silently expanding every future inventory request.
