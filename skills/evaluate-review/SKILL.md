---
name: evaluate-review
description: Evaluate an external pull-request review for technical accuracy, reviewer quality, and closure of the underlying bug class through applicable oracles. Preserve every finding in a lossless audit. Use when review findings need code verification, fixes, an omission audit, or a separate PR readiness verdict.
---

# evaluate-review

Use the review to close the class of bug it reveals. For each behavioral
finding, inventory the subsystem's observable guarantees, derive the relevant
law and its authority, and challenge how that law interacts with neighboring
guarantees. When an oracle applies, encode the law over legal histories and
public observation cuts using an independent judgment. A passing reproduction
or a complete item ledger is diagnosis, not closure: show that the oracle
rejects the original behavior or a plausible wrong implementation, including
a one-trace fix when relevant. Keep any unenforced part of the law open with
its missing witness.

Before you work on findings one at a time, look at all of them together. Plan
the oracle changes that would generate every behavioral finding, make those
changes first, and run them against unchanged production.

When a review involves oracles, present the result as law, experiment,
inference, and remaining enforcement work before the item ledger. Deferral is
a rare, fully justified exception.

When asked whether a PR is ready, give a separate readiness verdict. A completed
review audit or a bounded passing oracle cannot establish whole-PR readiness.

Read [references/workflow.md](references/workflow.md) in full, then follow those instructions exactly for the current request.
