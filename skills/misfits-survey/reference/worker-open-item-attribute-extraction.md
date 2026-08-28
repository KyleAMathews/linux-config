# Worker: Open Item Attribute Extraction

## Purpose

Process exactly one script-generated GitHub batch JSON file and write structured signal files to disk. Do not cluster. Do not diagnose. Do not propose fixes. Do not summarize the whole repo.

The orchestrator should give you:

- the batch JSON path to read;
- the output directory to write into;
- whether the batch contains `issues` or `prs`.

## Required Inputs

1. Read this worker reference file fully.
2. Read the assigned batch JSON file fully.
3. Process every item in that batch. No sampling.

If an item is malformed or unreadable, still add a ledger row for it with `Disposition=unreadable` and explain why.

## Required Outputs

Write these two files:

```text
<out>/analysis/<kind>/batch-NNN-ledger.md
<out>/analysis/<kind>/batch-NNN-attributes.jsonl
```

Optionally write this file if useful quotes exist:

```text
<out>/analysis/<kind>/batch-NNN-snippets.md
```

Your chat response to the orchestrator must be short and contain only:

```text
Batch: <kind> batch NNN
Input: <path>
Ledger: <path>
Attributes: <path>
Snippets: <path or none>
Items assigned: <n>
Items accounted for: <n>
Relevant signals: <n>
Unreadable items: <numbers or none>
Blockers: <none or details>
```

Do not paste the full ledger, JSONL, item bodies, or long quotes into chat.

## Ledger Format

Write one row per assigned item:

```markdown
| Item | Type | Title | Disposition | Evidence extracted? | Reason | Citation token |
|---|---|---|---|---|---|---|
```

Allowed dispositions:

- `relevant-signal`
- `possibly-relevant`
- `standalone-high-signal-candidate`
- `stale-or-duplicate-looking`
- `routine-support`
- `routine-maintenance`
- `not-survey-relevant`
- `unclear`
- `unreadable`

## Attribute JSONL Format

Write one JSON object per assigned item. Use `unknown` when the artifact does not support an attribute. Do not invent values.

Required object shape:

```json
{
  "number": 123,
  "type": "issue|pr",
  "title": "...",
  "state": "OPEN|CLOSED|MERGED|unknown",
  "url": "...",
  "labels": ["..."],
  "createdAt": "ISO or unknown",
  "updatedAt": "ISO or unknown",
  "closedAt": "ISO or unknown",
  "mergedAt": "ISO or unknown",
  "commentsCount": 0,
  "reactions": {
    "+1": 0,
    "-1": 0,
    "laugh": 0,
    "hooray": 0,
    "confused": 0,
    "heart": 0,
    "rocket": 0,
    "eyes": 0,
    "total": 0
  },
  "signalStrength": {
    "manyReactions": false,
    "manyComments": false,
    "recentActivity": false,
    "linkedDuplicateOrRepeatedReport": false,
    "linkedPRorFixAttempt": false,
    "maintainerDiscussion": false
  },
  "repoArea": ["unknown"],
  "packagesOrAdapters": ["unknown"],
  "apisSymbolsDocsExamples": ["unknown"],
  "userFacingWorkflow": ["unknown"],
  "environmentRuntimeFrameworkBackend": ["unknown"],
  "reportedConditionOrSetup": "unknown",
  "desiredOutcomeOrExpectation": "unknown",
  "observedFrictionOrFailureMode": "unknown",
  "artifactType": "bug report|feature request|docs confusion|adapter/runtime report|performance report|maintenance PR|design/API proposal|support question|stale-looking/duplicate-looking|unclear",
  "formTouched": ["code|API|docs|tests|package|process|release|CI|example|unknown"],
  "contextDemand": ["framework/runtime constraint|user workflow expectation|backend/source integration|type-safety expectation|persistence/offline expectation|performance expectation|contribution/release demand|unknown"],
  "explicitRelatedIssuesPRs": [123],
  "possibleClusterKeywords": ["..."],
  "stalenessOrDuplicateHint": "unknown",
  "representativeQuotes": [
    {
      "quote": "short exact quote",
      "citation": "URL or item URL plus comment/body marker"
    }
  ],
  "factualSummary": "one or two factual sentences, no diagnosis",
  "uncertaintyNotes": "unknown or concise note"
}
```

## Extraction Rules

- Extract attributes from title, labels, body, comments/reviews if present in the batch JSON.
- Preserve exact API/package names when visible.
- Prefer short exact quotes over paraphrase for representative snippets.
- A cluster keyword should be a factual token: API name, package name, adapter name, label, runtime, framework, repeated phrase, or linked issue/PR number.
- Mark high signal mechanically: many comments/reactions, explicit duplicates/links, recent activity, maintainer participation, or linked fix attempts.
- Separate frequency from loudness. One high-reaction item can be standalone-high-signal without being a cluster.

## Hard No's

Do not:

- cluster items;
- infer root causes;
- propose fixes;
- recommend closing issues/PRs;
- write design analysis;
- use Alexander terms in the output;
- omit assigned items;
- leave required JSON fields out;
- paste large output into chat.
