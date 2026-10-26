---
name: ci-loop
description: Monitor pull request or branch CI until it is green, evaluate new CodeRabbit reviews, and resolve straightforward failures or findings when safe. Distinguish CI success from PR readiness. Use for pending checks, failed workflows, recurring status checks, or requests to babysit CI.
---

# ci-loop

Treat green CI and PR readiness as separate outcomes. Use the completion gate
in the workflow before describing a PR as ready.

Read [references/workflow.md](references/workflow.md) in full, then follow those instructions exactly for the current request.
