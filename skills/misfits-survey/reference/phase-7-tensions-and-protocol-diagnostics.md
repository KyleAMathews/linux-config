# Phase 7: Tensions and Protocol Diagnostics

## Goal

Extract design positions and unresolved tensions from validated decomposition. Diagnose protocol surfaces, hardness, legibility, and fault lines.

## Design Positions, Not Topic Clusters

Do not cluster by topics like docs/API/performance as the final analysis. Ask what coherent design philosophies the evidence implies.

Examples:

- Make the system transparent and inspectable.
- Keep the core protocol opaque and minimal.
- Optimize for new contributor approachability.
- Optimize for long-term maintainer control and conceptual integrity.

## Tensions to Steward

A tension is a persistent tradeoff plus conflict. Many OSS tensions are ongoing conditions to steward, not defects to eliminate.

Ask:

> Is this a finite tradeoff to decide now, or an ongoing tension to steward?

Common frontiers:

- speed vs. correctness;
- contributor friendliness vs. maintainer capacity;
- automation vs. human judgment;
- backward compatibility vs. cleanup;
- local fix vs. architectural coherence;
- thorough evidence gathering vs. survey cost;
- legibility for newcomers vs. power for experts.

Record dynamic range: what options remain open, what positions are currently emphasized, and what conditions would justify moving along the frontier later.

## Constraint Diagnostics

For each major tension or subproblem, diagnose documented or directly evidenced constraints only:

- **Documented rule/design constraint**: docs, CI, labels, branch rules, release checklists, governance docs, tests, type/API boundaries, or explicit maintainer statements.
- **Legibility**: can relevant actors understand or navigate this rule, workflow, API, or norm?
- **Hardness**: how costly is it to change?
- **Deviation cost**: what happens when someone bypasses it?
- **Path dependence**: what past decisions, dependencies, or expectations make this hard?
- **Review capacity impact**: does this increase or decrease scarce maintainer review load?

## Fault Lines

Repeated stress reveals constraints and fault lines. Look for:

- repeated issue labels;
- repeated PR review comments;
- stale PR clusters;
- recurring contributor confusion;
- release blockers;
- bypassed documented contribution norms;
- review capacity bottlenecks.

Illegibility is not automatically bad, but do not speculate about tacit practice. Record only documented or maintainer-confirmed constraints.

## Optional Centers Check

Use this only as practical OSS language, not metaphysics. A center is a coherent part of the project people rely on: test suite, release process, review flow, documentation, contributor path, governance, architecture boundary, issue tracker, or maintainer attention.

Ask:

- Which centers does this misfit weaken?
- Which centers would a repair strengthen?
- Which center might it overload?

## Failure Modes

- **Hyperefficiency**: closure metrics, dashboards, automation, and categorization crush judgment.
- **Hyperthoroughness**: evidence gathering, design analysis, or review becomes endless and action never happens.
- **Spin cycles**: the project switches poles too often without commitment.
- **Context traps**: a protocol style that fit one situation is applied where it no longer fits.

## Readability Requirement

Tensions should be written as discussion material, not only tables. For each important tension, include a short paragraph explaining why it matters, links/quotes that surfaced it, and what decision or posture is needed from the maintainer.

## Completion Output

Produce:

### Design Positions and Tensions

| Tension | Position A | Position B | Current posture | Dynamic range | Maintainer judgment needed |
|---|---|---|---|---|---|

### Constraint Diagnostics

| Item | Documented rule/design constraint | Legibility | Hardness | Deviation cost | Review capacity impact |
|---|---|---|---|---|---|

Then ask: **"May I proceed to Phase 8: Triage Guide and Design Memory?"**

Only proceed when the maintainer gives explicit permission.
