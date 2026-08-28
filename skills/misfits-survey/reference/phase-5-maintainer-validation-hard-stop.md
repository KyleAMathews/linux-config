# Phase 5: Write the Signal Inventory Memo

## Goal

Write the final Signal Inventory Memo. The memo gathers repo signals into one place so maintainers can dispatch follow-up humans or agents to specific clusters or standalone items.

This is the terminal phase. Stop after writing the memo.

## Memo Principles

The memo is:

- a signal inventory;
- coverage-oriented;
- readable by maintainers and colleagues;
- useful as context for later focused investigation.

The memo is not:

- a design diagnosis;
- a solution proposal;
- a triage guide;
- a closure plan;
- a validation report;
- an Alexander decomposition.

## Required Sections

### Reader's Guide

State plainly:

- this is a signal inventory, not design analysis;
- clusters are probable groupings, not conclusions;
- historical items are context, not current-bug claims;
- use this memo by pointing a follow-up session at a cluster or standalone item.

### Repo Framing

Include the concise Phase 1 framing:

- what the repo appears to be trying to do;
- public promises;
- apparent design centers/invariants;
- package/API surfaces.

Label inferred material as inferred and maintainer-correctable.

### Source Coverage

Include:

- open issues counted;
- open PRs counted;
- enumeration timestamp/window;
- historical enrichment method and caps;
- sources included;
- sources unavailable/not collected;
- full ledger paths.

### Probable Clusters

For each cluster:

```markdown
## <Cluster label>

Grouping attributes: <factual one sentence listing concrete shared attributes>

### Current open items
| Item | Title | Status | Labels | Reactions/upvotes | Comments | Updated |
|---|---|---|---|---:|---:|---|

### Representative snippets
- [#123](url): “short quote”

### Historical related items
| Item | Title | State | Reactions/upvotes | Comments | Closed/Merged | Why related |
|---|---|---|---:|---:|---|---|
```

Do not add recommendations, solutions, design interpretation, or next-step prompts.

### Standalone High-Signal Items

Use the same factual format for important open items that do not clearly cluster.

### Unclustered / Maintenance / Unclear

Provide coverage honesty tables. These can be compact and can point to ledger paths for details.

### Ledger Paths

List all generated files:

- manifest;
- batch ledgers;
- evidence files;
- cluster assignment file;
- cluster keyword file;
- historical enrichment files.

## Final Checks

Before ending, confirm:

1. Every open in-scope item is accounted for in a ledger.
2. Memo cluster labels are descriptive, not diagnostic.
3. Every cluster lists the concrete extracted attributes used to group it; no cluster is based only on vague semantic similarity.
4. Standalone high-signal items were not forced into weak clusters.
5. Historical related items are marked as historical context only.
6. No solution recommendations, closure recommendations, tensions, forces, or design positions slipped in.
7. Source counts and ledger paths are included.

## Completion Output

Report:

- memo path;
- coverage counts;
- probable cluster count;
- standalone high-signal count;
- ledger/enrichment paths;
- any known gaps or caps.

Then stop with:

> Signal Inventory Memo written to `<path>`. Pick a cluster or standalone item for a separate follow-up investigation.
