# Phase 6: Alexander Decomposition

## Goal

Use Alexander's decomposition method on maintainer-validated material. Do not use unvalidated candidate misfits as settled premises.

## Spine

> positive whole → misfits → interactions → clusters → constructive subproblems → recomposed whole

## Steps

1. **State the positive whole**
   - Restate what the repo/system is trying to be.
   - Include current centers of fit, abstractions, workflows, invariants, and accepted tradeoffs.

2. **Separate validated misfits from investigation lanes**
   - Validated misfits have maintainer validation or strong ground-truth evidence.
   - Investigation lanes are plausible but still `investigate`, `needs-ground-truth`, or `needs-maintainer-judgment`.
   - Do not launder investigation lanes into validated misfits.
   - Include context force, current form, friction scenario, affected actor/workflow, citation token(s), maintainer verdict, and status.

3. **Map misfit interactions**
   - Which misfits cause, worsen, block, mask, duplicate, or trade off with each other?
   - Which share a force?
   - Which can be solved independently?
   - Which fixes would conflict?
   - Which evidence items participate in multiple misfits?

4. **Find overlapping clusters / semi-lattice edges**
   - Avoid clean topic buckets like docs, API, performance.
   - Cluster by force conflicts and cross-connections.
   - Preserve high-value singletons in a loss-audit lane.

5. **Form constructive subproblems**
   - Translate clusters into design questions.
   - Name the context, forces, and candidate configuration/design response.
   - Prefer question forms: “How can the system reveal concept X gradually without weakening expert power?”
   - Do not jump directly to solutions.

6. **Recompose into the whole**
   - Test subproblems against the positive design summary.
   - Ask whether possible moves improve local fit while preserving global fit.
   - Record accepted non-fits when changing them would damage stronger centers.

## Output Tables

### Validated Misfits

| Misfit | Context force | Current form | Friction | Evidence | Maintainer verdict |
|---|---|---|---|---|---|

### Investigation Lanes

| Lane | Why it may matter | Evidence | Missing validation | Next check |
|---|---|---|---|---|

### Interaction Map

| Misfit A | Misfit B | Interaction type | Relationship | Shared force | Risk of fixing separately |
|---|---|---|---|---|---|

### Constructive Subproblems

| Subproblem | Included misfits | Force conflict | What must be preserved |
|---|---|---|---|

### Narrative Cluster Briefs

For each major cluster or investigation lane, write a readable section for discussion:

```markdown
### <Cluster title>

**Why this matters**
<one or two paragraphs, written for maintainers/colleagues>

**Evidence**
- [#123](url) — <short context>
  > "real quote from issue/PR/discussion"
- [PR #456](url) — <short context>
  > "real quote"

**Validated**
- <what is actually validated>

**Still uncertain**
- <what remains investigation / needs ground truth>

**Maintainer judgment needed**
- <focused questions>

**Possible design responses / configurations**
- <route, not a forced recommendation>

**Maintainer capacity check**
- setup cost; ongoing cost; owner; failure mode if neglected; smallest useful version
```


## Completion Output

Report the decomposition and ask: **"May I proceed to Phase 7: Tensions and Protocol Diagnostics?"**

Only proceed when the maintainer gives explicit permission.
