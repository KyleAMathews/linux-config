---
description: Create or update a PR body that explains why the change matters and how it works at progressive levels of depth
---

# PR body workflow

Create or update the pull request yourself unless the user asks only for a
draft. The body must primarily help humans and agents understand why the change
matters, what behavior changes, and how the change works. Review navigation,
verification, and file lists are supporting material, not the main narrative.

Do not force every PR into one template. Choose an explanatory form that fits
the actual shape of the change.

## Gather the source material

1. Fetch the latest target branch, normally with `git fetch origin main`.
2. Read the current PR title and body when a PR exists. Record content that must
   survive, especially issue-closing references, manual test steps, deployment
   or migration notes, related links, and reviewer mentions.
3. Find issues linked from the user request, branch name, PR title or body, and
   commit messages. Read each materially related issue and relevant follow-up
   discussion when it is accessible. Extract concrete failing or usage examples,
   user-visible impact, project terminology, expected behavior, and constraints.
   Treat the issue as original context, not as the final truth. Compare it with
   the completed change and record whether the PR fulfills, narrows, widens, or
   redirects the issue. Do not imply that the PR resolves the issue exactly as
   proposed when the final behavior differs. If an issue is unavailable, do not
   invent its contents.
4. Compare the branch with the fetched target branch. Inspect the commit history,
   changed files, tests, and relevant surrounding code.
5. Establish the final behavior, not merely the sequence of commits. Identify:
   - the reader-visible change and why it matters;
   - the causal or conceptual model needed to understand it;
   - genuinely connected and independent change threads;
   - important limits, invariants, fallbacks, and non-goals;
   - concrete code that would explain an obscure change better than prose; and
   - verification facts supported by actual evidence.

Do not copy claims from commit messages or an existing PR body without checking
them against the final diff.

Use concrete issue examples when they still describe the final behavior and
orient the reader better than abstract prose. When the PR materially changes
the issue's scope or direction, explain that difference at the depth where it
first matters.

## Select the explanatory form

Before writing prose, privately generate three or four candidate outlines. The
candidates must differ in explanatory organization, not only in headings,
wording, or detail level. Hybrid forms are allowed.

Useful starting models include:

- **Causal repair:** failing behavior or symptom, significance, cause, repair,
  deeper mechanism, and boundaries.
- **Capability walkthrough:** new capability or outcome, minimal usage example,
  mental model, important behavior, and limits.
- **Braided system change:** shared outcome, relationship among connected
  threads, each thread's explanation, their interaction, and cross-cutting
  rules.
- **Honest portfolio:** a clear scope statement followed by short independent
  explanations. Use this when the changes do not share one causal story.

These are models, not mandatory templates. Add or combine a model when the diff
has a different shape. Do not invent a root cause or unifying story for a
feature, mechanical change, or grab-bag PR.

Compare the candidates qualitatively. Select the one with the best overall fit.
Name its decisive advantage and principal loss in your working notes. Do not use
an arithmetic score. Reject a candidate when:

- its opening does not give a useful general understanding;
- its organization misrepresents how the changes relate;
- it changes topics before it finishes, parks, or links the current question;
- a reader who stops after an early section would misunderstand the PR;
- it buries a clearer code example behind abstract prose; or
- it turns the body into a file list, review checklist, or test report.

## Write with progressive depth

Start with a short opening that lets a busy reader understand the general change
and why it matters. Prefer a concrete behavior, outcome, capability, or honest
scope statement over a compressed inventory of implementation facts.

Then add depth in the order that supports understanding:

1. Explain the principal behavior or idea.
2. Develop each causal or conceptual thread.
3. Explain important interactions among threads.
4. Preserve narrower rules, limits, fallbacks, trade-offs, and non-goals.
5. Add a short implementation trailhead when it helps a reader or future agent
   enter the diff.
6. Add required verification and repository-template material.

Each level must permit a graceful exit: a reader can stop there with a coherent,
if less detailed, understanding. A later section earns its place when it adds
causal precision, answers the next likely reader question, or preserves useful
context for future work. It need not interest every reader.

Preserve local continuity. Before changing topics, complete the current
explanation, explicitly park it, or state how the next topic relates.

### Use code as an explanatory anchor

Use a small code sample when it communicates the changed behavior more directly
than prose. Good uses include:

- code that previously failed;
- a subtle invalid form that the new code rejects;
- a before-and-after API example; or
- the smallest usage example that makes a new capability concrete.

Introduce the point the sample demonstrates. Keep only the lines needed for
that point, and verify the sample against the final code or tests. Place it where
it first improves understanding; do not automatically bury it in implementation
details. Omit code when prose is clearer.

## Supporting material

Include supporting sections only when they contain real information:

- invariants, fallbacks, trade-offs, non-goals, or scope boundaries;
- migration, deployment, compatibility, or release notes;
- verification results and commands;
- a compact implementation map grouped by concept rather than an exhaustive
  file-by-file inventory; and
- repository-required checklist items.

Deep technical material can appear late. It remains valuable to future agents
and maintainers even when many readers stop earlier.

## Preserve existing content

Preserve issue references and closing keywords exactly enough for GitHub to keep
their meaning, including `fixes #N`, `closes #N`, `resolves #N`, and other `#N`
references. Put closing references at the end when that matches repository
convention.

Also preserve unique manual test instructions, deployment or migration notes,
related links, reviewer mentions, and repository-mandated sections. Integrate
them at the appropriate depth instead of placing everything in the opening.

## Final check and publication

Before publication, verify that:

- the opening gives the general gist without enumerating every fix;
- the structure matches the change rather than a preferred template;
- connected threads have an explicit relationship and independent threads do
  not receive a false one;
- topic transitions preserve local continuity;
- code samples are accurate, minimal, and explanatory;
- later detail adds understanding or durable reference value;
- claims and verification results are supported by the final diff and evidence;
- linked-issue examples remain accurate and any material scope change is clear;
- required existing content survived; and
- the implementation trailhead remains secondary to the explanation.

Run the ASD-STE100 structural linter and correct all hard violations.

If a PR exists, update it with `gh pr edit`. Otherwise, create it with
`gh pr create`. Do not mutate GitHub when the user asks for a draft, comparison,
or other non-publishing result.
