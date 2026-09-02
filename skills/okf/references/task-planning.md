# OKF implementation planning

> **Use when:** creating an implementation plan, task DAG, or
> one-document-per-task work breakdown. **Do not use when:** documenting the
> current project or architecture without planning work.
>
> **Start with:** Artifact layout, Source of truth, then the templates.
> **Search terms:** `depends_on`, task tracker, scenario, acceptance,
> follow-ups, not yet specified.

This reference produces an execution plan, not implementation.

## Ground rules

- Base scope, dependencies, and acceptance criteria on repository evidence; cite
  repository-relative paths and symbols.
- Use YAML front matter for machine-readable metadata and Markdown for the body.
- Use stable task IDs in the form `T-<nnn>`.
- Do not invent dates, repository behavior, or completion status. Use `TBD`
  where needed.
- Make every prerequisite an explicit task ID; do not conceal dependencies in prose.
- A plan may be partial. Only `ready` tasks must be fully specified. Work you
  cannot yet state precisely goes under `Not yet specified` in the plan index,
  not into a vague task.
- Decisions get resolved during planning and recorded in the plan index. A
  worker task never has "decide X" as its deliverable. A prototype task is fine
  when it has an observable outcome (a spike that proves an API shape works).

## Boundedness gate

Each executable task has one primary behavioral or architectural invariant and
one coherent validation surface. Split tasks that combine independently
reviewable risk surfaces, especially vendor integration, public API design,
persistence protocol, process interruption, schema migration, concurrency, and
end-to-end validation. Create a prerequisite design or prototype task when the
implementation still requires choosing authority, state ownership, promotion
ordering, recovery behavior, or compatibility policy.

A durability or concurrency task must name the authoritative, candidate,
completed, and published states that apply; every freshness, generation, or
revision value and which operation owns its mutation; material interruption
points and concurrent interleavings; and the deterministic test for each
boundary. Such a task keeps two or more coupled risks only when they cannot be
delivered and reviewed independently, and flags itself as high-complexity in
its Context section so the executor briefs its worker accordingly.

## Artifact layout

Follow a repository-provided location and template when present. Otherwise use:

```text
.tasks/okf/<initiative-slug>/
  plan.okf.md
  tasks.okf.md
  tasks/
    T-001-<slug>.okf.md
    T-002-<slug>.okf.md
  task-logs/
    T-001-log.okf.md
```

The planning stage writes a plan index, a task tracker, and one document for
every task. The execution stage creates one task log when each task starts.

## Source of truth

Task front matter is the truth for a task's status and dependencies.
`tasks.okf.md` is a derived index: its rows restate front matter so a reader can
see the whole initiative at a glance. When they disagree, front matter wins and
the tracker row gets corrected. Nothing else restates status: no dependency
diagram, no execution-order list, no per-task change log. Order is the tracker
row order plus `depends_on`.

## Plan index template

```md
---
okf: 1
kind: plan
project: <project name>
status: active | completed | blocked
last_verified: YYYY-MM-DD
sources:
  - path: <repo-relative path>
    purpose: <what this plan is based on>
---

# <Initiative> plan

## Objective
<Measurable outcome.>

## Scope
- In: <...>
- Out: <...>

## Decisions
- <decision>. Why: <one line>.

## Constraints
- <constraint and its evidence>

## Cross-task acceptance criteria
- <end-to-end criterion>

## Not yet specified
<In-scope work that hangs on open questions or on tasks not yet executed.
Written as loosely as the view allows. Graduates into tasks on re-planning.
Leave empty when the way is fully clear.>

## Out of scope
- <work consciously ruled outside this initiative, and why>

## Risks
| ID | Statement | Affected tasks | Mitigation |
| --- | --- | --- | --- |

## Follow-ups
<Discoveries during execution that fall outside any task's scope. Execution
appends here instead of expanding a task. Empty at planning time.>

## Change log
| Date | Change |
| --- | --- |
```

## Task tracker template

```md
---
okf: 1
kind: task-tracker
plan: plan.okf.md
last_verified: YYYY-MM-DD
---

# <Initiative> tasks

| ID | Task | Status | Depends on | Document | Log |
| --- | --- | --- | --- | --- | --- |
| T-001 | <title> | ready | none | [T-001](tasks/T-001-<slug>.okf.md) | pending |

## Status rules
- `dependent`: approved work waiting on incomplete dependencies.
- `ready`: approved work with all dependencies completed.
- `in_progress`: work actively being executed.
- `blocked`: work with a specific blocker and next step.
- `completed`: work with recorded validation evidence.
- `cancelled`: approved work that will not be executed.
```

## Task document template

Omit the failure and concurrency matrix unless the task is stateful,
concurrent, recovery, or migration work. Every other section is required.

```md
---
okf: 1
kind: task
id: T-001
title: <short imperative title>
status: dependent | ready | in_progress | blocked | completed | cancelled
depends_on: []
last_verified: YYYY-MM-DD
sources:
  - path: <repo-relative path>
    purpose: <what this task is based on>
---

# T-001: <title>

## Objective
<Single outcome this task delivers.>

## Context
<Relevant architecture, decisions, and repository evidence. Name exact files,
symbols, interfaces, and conventions the worker should inspect, and any
contract this task changes.>

## Scope
- In: <specific files, components, or behavior>
- Out: <explicit exclusions>

## Implementation steps
1. <Concrete, verifiable step.>
2. <Concrete, verifiable step.>

## Acceptance
| ID | Scenario | Test | Command | Expected |
| --- | --- | --- | --- | --- |
| A1 | WHEN <condition> THEN <observable outcome> | `<test file::name>` to add or update | `<exact command>` | <passing output> |
| A2 | WHEN <condition> THEN <observable outcome> | manual: <repeatable procedure> | none | <what the person or verifier sees> |

<Every material success, boundary, and failure case gets a row. A row whose
test is `manual` records why automation is unavailable.>

## Edge cases and constraints
- <Behavior at a boundary or failure condition.>
- <Constraint or non-goal that prevents scope drift.>

## Governing invariant
<The single primary invariant this task establishes or preserves.>

## Failure and concurrency matrix
| Boundary or interleaving | Authoritative state | Candidate/completed/published state | Expected recovery or rejection | Validation |
| --- | --- | --- | --- | --- |

## Risks and decisions
| ID | Statement | Resolution |
| --- | --- | --- |

## Completion record
- Completed: TBD
- Evidence: TBD
- Unverified: TBD
- Deviations from plan: TBD
- Follow-ups: TBD
```

## Task log template

`execute-plan` creates the log when execution starts. The log is the durable
record of what happened to the task, and the resume point if execution is
interrupted.

```md
---
okf: 1
kind: task-log
task: T-001
task_document: ../tasks/T-001-<slug>.okf.md
status: implementing | reviewing | repairing | completed | blocked | needs_input | iteration_limit
iteration: 1
last_verified: YYYY-MM-DD
---

# T-001 execution log

## Summary
- State: <current state>
- Next action: <one concrete action, precise enough to resume from>
- Open blocker: none

## Evidence
| Iteration | Check | Command or procedure | Result |
| --- | --- | --- | --- |

## Findings
| ID | Iteration | Severity | Status | Finding | Resolution |
| --- | --- | --- | --- | --- | --- |

## Events
| Time | Iteration | Agent | Event |
| --- | --- | --- | --- |
```

Severity is `blocking` (breaks behavior, violates the invariant, or misses an
acceptance row) or `nit` (style, naming, minor structure). Only blocking
findings earn a repair round; nits go to the plan's Follow-ups. Finding status
is `open`, `resolved`, or `accepted` with evidence; findings are never erased.
Worker decisions and handoffs are events.

## Dependency and status rules

- `depends_on` lists all prerequisite task IDs.
- A task is `ready` only when every dependency is `completed`, except for a
  documented, approved exception.
- Set a tracker row's `Log` value to `pending` during planning. When execution
  creates the task log, replace `pending` with its repository-relative link.
- Use `blocked` only with a specific blocker and next step.
- Mark a task `completed` only after every acceptance row has recorded
  evidence or is listed as unverified in the completion record.
- Prefer thin vertical slices. Split tasks with independent invariants,
  deliverables, risks, or validation; do not split merely to increase task
  count.
- Make each ready task executable by a lower-cost worker without recovering
  context from the planning conversation: exact code landmarks, decided
  behavior, ordered steps, edge cases, and acceptance rows with commands.
  Work that still needs broad discovery or unresolved judgment is not ready;
  it belongs under `Not yet specified` until it is.

## Before handoff

Check that every tracked task has exactly one document, every `depends_on` ID
resolves without cycles, tracker rows match task front matter, links are valid
and repository-relative, and each ready task has scope, ordered steps, an
acceptance table with commands, a governing invariant, and a completion record.
Reject a ready task that spans multiple independent invariants or leaves a
durability or concurrency state model implicit.
