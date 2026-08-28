# Phase 4: Historical Enrichment by Cluster

## Goal

For each Phase 3 open-item cluster, gather bounded historical context from closed issues/PRs and merged/abandoned work. This enriches the signal inventory without boiling the ocean.

Historical related items are context only. They are not evidence that current behavior is broken.

## Inputs

- Phase 3 probable clusters.
- Phase 3 `cluster-keywords.json`.
- Open-item ledgers and evidence snippets.

## Method

Dispatch one subagent per cluster, or one subagent per small group of clusters. These searches are independent; run them in parallel when tool/runtime limits allow. The orchestrator should only merge the returned file paths/counts/caveats into the final memo inputs.

Each subagent searches closed/merged GitHub artifacts using the cluster's factual terms:

- issue/PR numbers explicitly linked from open items;
- package/API names;
- labels;
- repeated phrases from titles/bodies;
- obvious repo area terms.

Prefer:

- closed items explicitly linked from open items;
- merged PRs that appear to fix or reshape the area;
- old issues/PRs with high reactions/comments;
- repeated reports with similar wording;
- abandoned PRs with useful discussion.

Avoid:

- scanning all historical issues/PRs globally;
- claiming old fixed items are current bugs;
- solving or diagnosing the cluster;
- closure recommendations;
- red-test or reproduction work unless the user explicitly asked for it outside this inventory.

## Bounds

Use caps to keep enrichment representative:

- default max 10 historical related items per cluster;
- default max 3 representative quotes per cluster;
- prefer high signal by reactions/comments/explicit links/recency;
- if more history exists, note “more historical items found; capped at N.”

## Output Files

Each enrichment subagent writes:

```text
<out>/historical-enrichment/<cluster-slug>.md
```

Recommended shape:

```markdown
# Historical enrichment: <cluster label>

Search terms used: ...
Caps: ...

## Related closed/merged items

| Item | Title | State | Reactions/upvotes | Comments | Closed/Merged | Why related |
|---|---|---|---:|---:|---|---|

## Representative historical snippets

- [#123](url): “short quote”

## Caveats

- <coverage limits, ambiguous search terms, capped results>
```

Subagent chat response must be short:

```text
Cluster: <label>
Output: <path>
Closed/merged items recorded: <n>
Representative snippets: <n>
Capped: yes/no
Blockers: <none or details>
```

## Completion Output

Report:

- historical enrichment file paths;
- clusters enriched;
- clusters skipped and why;
- cap/blocker notes;
- source coverage caveats.

Then ask: **"May I proceed to Phase 5: Write the Signal Inventory Memo?"**

Only proceed when the maintainer gives explicit permission.
