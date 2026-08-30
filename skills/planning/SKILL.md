---
name: planning
description: Build a repository-scoped implementation plan with durable OKF artifacts, dependency-aware tasks, tests, and verification. Use for implementation plans, task breakdowns, and execution handoffs. Run on a strong reasoning model (Fable, high reasoning).
---

# Planning

Create a plan that another agent can execute without recovering requirements from the planning conversation. This skill produces planning artifacts only. Use `execute-plan` to implement them.

Run this skill on a strong reasoning model (Fable, high reasoning). Planning quality gates everything downstream: the executor's workers are low-reasoning Codex sessions that do exactly what the task documents say, so every judgment call must be settled here.

Scope note: these artifacts are durable handoff documents for the `execute-plan` loop, not conversational plans. The global preference for extremely concise plans applies to interactive plan-mode replies; OKF artifacts are deliberately explicit.

## Clarify the work

Inspect the repository before writing the plan. Resolve material ambiguity about scope, behavior, constraints, acceptance criteria, and architectural choices with the user. A plan can record a genuine blocker, but it cannot turn an unresolved product decision into an implementation task.

## Store the plan

Use the repository's existing planning convention when it has one. Otherwise store each plan under the repository's ignored `.tasks` directory:

```text
.tasks/okf/<initiative-slug>/
  plan.okf.md
  tasks.okf.md
  tasks/
    T-001-<slug>.okf.md
  task-logs/
    T-001-log.okf.md
```

The planning stage creates `plan.okf.md`, `tasks.okf.md`, and the files under `tasks/`. The `execute-plan` skill creates each file under `task-logs/` when execution starts.

Before writing, run `git check-ignore -q .tasks`. If `.tasks` is not ignored, ask before changing an ignore file. Keep a handoff plan in the repository rather than a temporary directory. If no repository exists, use a stable user-managed planning directory and report its location.

Use a lowercase, hyphenated initiative slug. Reuse an existing initiative directory for the same work instead of creating a competing plan.

## Build the artifacts

Read the `okf` skill's `references/task-planning.md` before creating or revising the artifacts. Keep task metadata, links, dependency edges, execution order, and tracker rows consistent.

Write each task as a bounded execution packet for a lower-cost worker. Include exact code landmarks, decided behavior, ordered implementation steps, edge cases, non-goals, and acceptance criteria. Each task must have one governing invariant and one coherent validation surface. Split work that still needs broad discovery, unresolved judgment, or independent reviews.

Give every task an initial status: `ready` when it has no prerequisites, `dependent` when it waits on other tasks via `depends_on`.

Every task must include both a test plan and verification:

- Name the tests to add or update and the behavior each test proves.
- Cover the task's material success, boundary, and failure cases.
- Give exact verification commands or repeatable procedures with expected results.
- For work without an automated test harness, define a repeatable manual test and explain why automation is unavailable.

For stateful, concurrent, recovery, or migration work, include a failure and concurrency matrix. Name state ownership, version or freshness fields, interruption points, interleavings, and the test for each material boundary. If the design is not settled, create a preceding design or prototype task with an observable outcome.

## Check the handoff

Before completion, confirm that:

- Every tracker row links to exactly one task document.
- Every dependency ID resolves, reciprocal `blocks` fields agree, and the graph has no unapproved cycle.
- Every ready task includes scope, a governing invariant, tests, verification, acceptance criteria, risks, and a completion-record placeholder.
- A worker can execute each ready task from the plan artifacts and cited repository sources.

Return the repository root, the paths to `plan.okf.md` and `tasks.okf.md`, the next ready task ID and document path, and any blocker. Tell the user to invoke `execute-plan` for implementation.
