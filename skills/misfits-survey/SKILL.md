---
name: misfits-survey
description: Use when gathering a bounded signal inventory memo for an open source repository so maintainers can dispatch follow-up investigation work
---

# Misfits Survey — Signal Inventory Memo

Run a bounded signal inventory for an open source repository or repo area.

The output is a **short maintainer memo** that gathers available signals into one place. Maintainers should be able to point humans or agents at the memo and say: “read this, then investigate cluster X.”

This skill is **not** a design-analysis workflow. It does not solve clusters, propose architecture, run a validation ceremony, or decide issue closure.

## Operating Principle

The agent does signal assembly: repo framing, source enumeration, metadata capture, quote extraction, light clustering, and bounded historical enrichment.

The orchestrator should mostly coordinate. Phase 2 batch extraction, Phase 3 attribute-based clustering/merge work, and Phase 4 historical enrichment are highly parallelizable and should be farmed out to subagents that write files to disk. The orchestrator reads manifests, counts, paths, and final concise outputs; it should not ingest large issue/PR corpora into chat.

The maintainer uses the memo to choose where to send follow-up work.

Agent output is testimony, not evidence. Every substantive claim needs a citation token: issue/PR URL, file path, command output, exported message reference, or maintainer statement.

## Hard Boundaries

Do:

- parallelize independent source batches, cluster assignment work, and historical enrichment subagents;
- account for every open in-scope GitHub issue/PR;
- preserve standalone high-signal items even if they do not cluster;
- use descriptive cluster labels, not diagnostic claims;
- include upvotes/reactions/comments/recency where available;
- include historical closed/merged items only as bounded context for already-identified open-item clusters;
- write detailed ledgers to files and keep chat responses short;
- require Phase 2 batch workers to read `reference/worker-open-item-attribute-extraction.md` before processing their assigned batch.

Do **not**:

- perform Alexander decomposition;
- produce tensions, design positions, forces, or constructive subproblems;
- propose architecture/design solutions;
- write a full triage guide;
- decide or execute issue/PR closure;
- require maintainer validation as a formal ceremony;
- require red tests or deep reproduction;
- claim a cluster is a real design problem unless the evidence directly says so;
- turn every issue into a “misfit.”

## Memo Shape

`docs/misfits-survey.md` should be a Signal Inventory Memo with these sections:

1. Reader's Guide — “this is a signal inventory, not design analysis.”
2. Repo Framing — concise, inferred, maintainer-correctable.
3. Source Coverage — sources, counts, date/window, unavailable sources.
4. Probable Clusters — descriptive groupings rooted in open items.
5. Standalone High-Signal Items — important open items that do not clearly cluster.
6. Unclustered / Maintenance / Unclear — coverage honesty buckets.
7. Ledger Paths — full ledgers and enrichment files.

Cluster entries include only:

- descriptive label;
- factual grouping rule;
- open issue/PR table with number, title, URL, status, labels, reactions/upvotes, comments, updated date;
- representative quotes/snippets;
- capped historical related items table.

No recommendations or next-step prompts inside cluster entries.

## Phases

1. Read `reference/phase-0-orientation-and-living-document.md`, execute it, then stop for explicit maintainer permission.
2. Read `reference/phase-1-positive-design-summary.md`, execute it, then stop for explicit maintainer permission.
3. Read `reference/phase-2-source-access-and-evidence-gathering.md`, execute it, then stop for explicit maintainer permission.
4. Read `reference/phase-3-evidence-condensation-and-aging.md`, execute it, then stop for explicit maintainer permission.
5. Read `reference/phase-4-ground-truth-validation.md`, execute it, then stop for explicit maintainer permission.
6. Read `reference/phase-5-maintainer-validation-hard-stop.md`, execute it, then stop.

Phases 6–9 from older versions are intentionally obsolete and must not be run for this skill.

## First Action

If the user supplied arguments, treat them as the repo, repo area, package, API, release, issue set, PR set, or source boundary to inventory. If not, ask for the inventory boundary.

Then begin Phase 0 by reading `reference/phase-0-orientation-and-living-document.md`.
