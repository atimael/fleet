---
name: planning
description: Build a repository-scoped implementation plan with durable OKF artifacts, dependency-aware tasks, tests, and verification. Use for implementation plans, task breakdowns, and execution handoffs.
---

# Planning

Create a plan that another agent can execute without recovering requirements from the planning conversation. This skill produces planning artifacts only. Use `execute-plan` to implement them.

Run this skill on the strongest reasoning model available at high effort; the roles table in `execute-plan` records the current pick. Planning quality gates everything downstream: the executor's workers are low-reasoning Codex sessions that do exactly what the task documents say, so every judgment call must be settled here.

Scope note: these artifacts are durable handoff documents for the `execute-plan` loop, not conversational plans. The global preference for extremely concise plans applies to interactive plan-mode replies; OKF artifacts are deliberately explicit.

## Match the ceremony to the work

The loop exists for work that outlives one session or needs decisions settled before a cheap worker can act. If the request is a single bounded task with no open decisions, say so and offer to do it directly instead of generating an initiative. Typo fixes, one-file bug fixes, dependency bumps, and config changes never need a plan.

## Clarify the work

Inspect the repository before writing the plan. Resolve material ambiguity about scope, behavior, constraints, acceptance criteria, and architectural choices with the user, and record each resolution under `Decisions` in `plan.okf.md` with a one-line reason.

Do not try to resolve everything before writing anything. Specify fully the tasks whose question you can state precisely now. Write the rest under `Not yet specified` as loosely as the view allows, and list what you consciously ruled out under `Out of scope`. A worker task never has a decision as its deliverable; decisions belong to this skill. A prototype task with an observable outcome is fine when a decision genuinely needs code to react to.

Planning is re-entrant. After a slice executes, run this skill again on the same initiative: graduate what is now specifiable from `Not yet specified` into tasks, append to `Decisions`, and leave completed tasks untouched.

## Greenfield projects

When the repository is empty or has no code yet, the stack is a planning decision, not a user prerequisite. Derive it from the product requirements (target platform, distribution, user's stated tech preferences), record it under `Decisions` in `plan.okf.md`, and ask the user only when two stacks remain a genuine coin flip the user must own.

Make T-001 a scaffold task: follow the `init-project` skill's checklist with the decided stack, ending in a passing test harness and a project `CLAUDE.md` that records the verified test/build commands. Every other task depends on T-001.

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

Read the `okf` skill's `references/task-planning.md` before creating or revising the artifacts. Task front matter is the source of truth for status and dependencies; `tasks.okf.md` restates it as an index.

Write each task as a bounded execution packet for a lower-cost worker. Include exact code landmarks, decided behavior, ordered implementation steps, edge cases, non-goals, and an acceptance table. Each task must have one governing invariant and one coherent validation surface. Split work that still needs broad discovery, unresolved judgment, or independent reviews.

Give every task an initial status: `ready` when it has no prerequisites, `dependent` when it waits on other tasks via `depends_on`.

Write acceptance criteria as scenarios: WHEN a condition, THEN an observable outcome. Each row names the test that proves it, the exact command that runs it, and the passing output. A row with no possible automated test is marked `manual` with a repeatable procedure and the reason automation is unavailable. Cover the material success, boundary, and failure cases.

When writing edge cases, walk this list once and name the ones that apply: empty input, boundary values, ordering, duplicates and idempotency, concurrency, encoding and precision. Skip the rest silently.

For stateful, concurrent, recovery, or migration work, include the failure and concurrency matrix. Name state ownership, version or freshness fields, interruption points, interleavings, and the test for each material boundary. If the design is not settled, create a preceding design or prototype task with an observable outcome. Omit the matrix for everything else.

## Check the handoff

Before completion, confirm that:

- Every tracker row links to exactly one task document and matches its front matter.
- Every `depends_on` ID resolves and the graph has no unapproved cycle.
- Every ready task includes scope, ordered steps, an acceptance table with commands, a governing invariant, and a completion-record placeholder.
- A worker can execute each ready task from the plan artifacts and cited repository sources.

Return the repository root, the paths to `plan.okf.md` and `tasks.okf.md`, the next ready task ID and document path, what remains under `Not yet specified`, and any blocker. Tell the user to invoke `execute-plan` for implementation.
