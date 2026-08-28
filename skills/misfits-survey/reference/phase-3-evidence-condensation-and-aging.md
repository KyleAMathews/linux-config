# Phase 3: Light Clustering of Open Signals

## Goal

Merge Phase 2 open-item ledgers into a lightly clustered signal inventory. This phase groups signals; it does not diagnose design problems or propose fixes.

The output of Phase 3 is a set of descriptive cluster candidates, standalone high-signal items, and coverage buckets that become inputs to bounded historical enrichment.

Phase 3 is subagent-first. Dispatch bounded clustering/assignment workers over ledger groups, then dispatch a merge worker over their output files. The orchestrator should not load all item ledgers into chat or perform the full clustering itself.

## Coverage Gate

Before clustering, verify deterministic coverage for open GitHub issues/PRs in scope:

- enumeration count;
- assigned-to-batches count;
- returned-ledger-file count;
- missing item numbers;
- capped exports or incomplete pages.

If counts do not match, stop and either dispatch missing batches or report partial coverage explicitly. Do not cluster as if coverage is complete. Verify counts from ledger files, not chat summaries alone.

## Attribute-Based Clustering Rules

Clustering must be based on structured attributes extracted in Phase 2, not raw LLM theme invention.

Allowed grouping basis:

- same repo area / package / adapter;
- same API names, symbols, docs pages, examples, or commands;
- same user-facing workflow;
- same environment / runtime / framework / backend;
- same reported condition or setup;
- same desired outcome / expectation;
- same observed friction / failure mode;
- same artifact type plus another concrete overlap;
- same form touched or context demand plus another concrete overlap;
- explicit links, duplicate references, supersession references, or linked PR/fix attempts;
- shared labels plus overlapping nouns/API names.

Do not form a cluster from one weak similarity alone. Prefer at least two concrete shared attributes, or one explicit link/duplicate/supersession relationship.

Forbidden grouping basis:

- “LLM semantic similarity” without named shared attributes;
- inferred forces;
- Alexander misfit framing in the output;
- design positions;
- speculative root causes;
- solution architecture;
- “this violates invariant X” unless directly cited from docs/maintainer statement.

For every cluster, record the exact attributes used to group it.

Cluster labels must be descriptive, not diagnostic.

Good:

- `Live queries / query-driven loading`
- `Includes / nested materialization`
- `SQLite persistence / browser storage`
- `React SSR / framework lifecycle`
- `Transactions / optimistic writes`
- `Docs / examples / onboarding`

Bad:

- `Query-driven loading needs a single readiness protocol`
- `Nested materialization violates identity invariants`
- `Adapter breadth is undermining abstraction integrity`

## Required Buckets

Every open in-scope item must land in exactly one of:

- probable cluster;
- standalone high-signal item;
- unclustered / unclear;
- routine maintenance / dependency / release housekeeping;
- likely duplicate or stale-looking, without recommending closure.

Standalone high-signal items are first-class. Do not force a single heavily upvoted issue into a weak cluster.

## Subagent Use

Phase 3 should normally be farmed out.

Use two layers when the corpus is non-trivial:

1. **Assignment workers** consume bounded ledger/evidence file groups and write per-group attribute summaries, tentative cluster assignments, standalone-high-signal candidates, and unclear/maintenance buckets.
2. **Merge worker** consumes assignment outputs and writes the final cluster assignment file, probable clusters, standalone items, coverage buckets, cluster keywords, and cluster attribute basis.

Subagents write outputs to disk. Chat responses should include only paths/counts/blockers.

Recommended files:

```text
<out>/clustering/coverage-summary.md
<out>/clustering/open-item-cluster-assignments.md
<out>/clustering/probable-clusters.md
<out>/clustering/standalone-high-signal-items.md
<out>/clustering/unclustered-maintenance-unclear.md
<out>/clustering/cluster-keywords.json
<out>/clustering/cluster-attribute-basis.json
```

`cluster-keywords.json` feeds Phase 4 historical enrichment. Include only factual search terms: package names, API names, labels, issue numbers, linked PR numbers, repeated phrases.

## Cluster Entry Shape

Each cluster should be concise and factual:

```markdown
### <Descriptive cluster label>

Grouping attributes: <one factual sentence listing the concrete shared attributes, e.g. “repo area=includes/materialization; API terms=toArray/includes; workflow=nested child arrays.”>

Open items:
| Item | Title | Status | Labels | Reactions/upvotes | Comments | Updated |
|---|---|---|---|---:|---:|---|

Representative snippets:
- [#123](url): “short quote”
- [PR #456](url): “short quote”
```

Do not include “why this matters,” design interpretation, suggested next steps, or maintainer questions.

## Completion Output

Report:

- clustering output file paths;
- open issue/PR coverage counts and any missing items;
- probable cluster labels and item counts;
- standalone high-signal item count;
- unclustered/maintenance/unclear counts;
- path to `cluster-keywords.json` for historical enrichment.

Then ask: **"May I proceed to Phase 4: Historical Enrichment by Cluster?"**

Only proceed when the maintainer gives explicit permission.
