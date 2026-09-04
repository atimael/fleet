---
name: execute-plan
description: Execute an OKF implementation plan as a dependency-ordered loop; a secretary agent schedules tasks, Codex CLI workers implement them, and every result is test-verified and committed per task. Use when an initiative has `plan.okf.md`, `tasks.okf.md`, and linked task documents.
---

# Execute an OKF plan

Execute a completed planning handoff as a loop: pick up the next ready task, hand it to a worker, verify the result with real commands, log everything, commit, repeat. This skill is self-contained. Do not load another execution skill.

## Roles and models

This table is the single record of which model runs each role. Retune here, nowhere else.

| Role | What it needs | Model | How it runs |
|---|---|---|---|
| Planner | Strongest reasoning available; its packets are executed by low-effort workers | `gpt-5.6-sol`, high | the `planning` skill, before this one |
| Secretary | Long context for every log and diff in the plan; an independent code review | `gpt-5.6-luna`, medium | the main agent running this skill |
| Implementer | Follows a stand-alone packet in a fresh session | Codex CLI, `gpt-5.6-sol`, low | `codex exec`, fresh session per task |
| Fixer | Reasons about a failure it caused; low effort tends to retry the same thing | Codex CLI, `gpt-5.6-sol`, medium | `codex exec`, one session per repair round |
| UI verifier | Computer use | Codex default | the `codex-computer-use` skill |

The secretary is the only writer of plan-owned files and task logs, the only agent that runs test and verification commands, and the only agent that commits. Workers implement; the secretary proves. Workers may run typechecks or focused tests for their own feedback, but only the secretary's recorded runs count as evidence.

## Establish the plan state

1. Find the repository root and read its instructions. Read `plan.okf.md`, `tasks.okf.md`, and every linked task document.
2. Confirm that every tracked task has one document, that tracker rows match task front matter, that every `depends_on` ID resolves without cycles, and that each ready task has scope, ordered steps, an acceptance table with commands, a governing invariant, and a completion record. Stop with `status=needs_input` for a broken link, unresolved requirement, dependency cycle, ambiguous acceptance row, or missing architectural or product decision.
3. If a task is already `in_progress`, this is a resume. Read its log's Next action. A dirty worktree whose changes belong to that task is a worker result: skip to the inspect-and-test step of the loop below. A dirty worktree with unrelated changes stops with `status=blocked` and lists every changed path. Otherwise require a clean worktree and index and record the current branch and commit.
4. Find the baseline test command in checked-in repository instructions and build configuration. Run it on the starting commit; stop with `status=blocked` and its failure summary if it fails. Record the exact command and result. Greenfield exception: when the repository has no test harness and the first executable task is the plan's scaffold task, skip this step. That task's own verification establishes the baseline, and its recorded commands govern every later task. Stop with `status=needs_input` only when the command is missing with no scaffold task to create it.
5. Derive a lowercase, hyphen-separated initiative slug from its title or ID. Create and switch to `feature/<initiative-slug>` from the recorded commit. On a resume, stay on that branch. If the branch exists and nothing is `in_progress`, ask the user before reusing it. Stop with `status=needs_input` if the checkout is not a Git repository, branch creation fails, or reuse is not confirmed.

Keep approved plan scope fixed. Report a scope gap instead of expanding a task.

## Schedule tasks

Keep one task active at a time. A `dependent` task becomes executable only when every task in `depends_on` is `completed`. Never execute a `blocked` or `cancelled` task, or a task with an incomplete dependency.

Select the first `ready` or dependency-satisfied `dependent` task in tracker order. Repeat the task procedure below until no executable task remains.

## Start the selected task

1. Confirm that the worktree and index are clean.
2. Set the task's front matter status to `in_progress` and mirror it in its `tasks.okf.md` row.
3. Create `task-logs/T-<nnn>-log.okf.md` from the task-log template in the `okf` skill's `references/task-planning.md`, and replace the task's `pending` log value in `tasks.okf.md` with a repository-relative link.

The secretary is the only task-log writer. Keep the Summary current, append events before and after each worker handoff, and read the log before every handoff. Never erase findings; mark each `open`, `resolved`, or `accepted` with evidence.

## Hand a task to a worker

Run each worker as a fresh Codex CLI session. Use `model_reasoning_effort=medium` for a fixer:

```bash
codex exec \
  -m gpt-5.6-sol \
  -c model_reasoning_effort=low \
  --sandbox workspace-write \
  -C <repo-root> \
  -o /tmp/okf-<initiative>/T-<nnn>-worker-<iteration>.md \
  "<task packet>"
```

The task packet must stand alone; the worker has no conversation context. Include:

- Repository-relative paths to `plan.okf.md`, `tasks.okf.md`, the task document, and the task log, with an instruction to read all four first.
- The repository instructions file, relevant source paths, and the baseline evidence.
- The scope fence: which files may change; plan-owned files, dependencies, other tasks, and commits are off-limits; no new package dependencies unless the task document names them; never weaken, skip, or delete a failing test, report it as a finding instead.
- The deviation rule: the worker may fix what blocks its own acceptance rows inside the scope fence. Anything else it discovers (a bug in adjacent code, a missing abstraction, a wrong assumption in the task document) goes in its report as a finding, untouched.
- Every open finding when this is a repair round, quoted in full with its evidence.
- The reporting contract: end with changed files, decisions made, deviations from the task document's steps or decided behavior, test coverage added, finding dispositions, and any blocker.

Workers implement code and tests only. The secretary runs the suite. Give the Bash call a generous timeout and run it in the background when useful.

## Run the implement-review loop

Run at most five iterations:

1. Set the log to `implementing` (or `repairing`) and record the handoff. Run the implementer (or fixer) with the packet above.
2. Read the worker's report, inspect the actual diff, and update the log. Return `status=needs_input` for an unresolved product or architectural decision. Route each discovery the worker reported: if it invalidates the plan, stop with `status=needs_input`; otherwise append it to `Follow-ups` in `plan.okf.md` and continue. Run the focused tests the worker added or changed, then every acceptance row's command. Record each exact command and result in the log. On a failure, send the full output and relevant code context to a fixer and repeat from step 1.
3. When every command passes, review the diff yourself against the task document: correctness, the governing invariant, acceptance rows, scope, regression risk, test coverage, and repository conventions. The implementation was written by a different model, so this is an independent read. Record findings with stable IDs, evidence, and a severity: `blocking` when it breaks behavior, violates the invariant, or misses an acceptance row; `nit` otherwise. Nits go to `Follow-ups` and never trigger a repair round.
4. On open blocking findings, send them all to a fixer in the next iteration, then rerun the tests and acceptance commands before reviewing again. On an unresolved blocker, record it and the smallest next step, then stop the loop with the matching result.
5. With no open blocking findings, settle the manual acceptance rows. A row that needs a running app, simulator, or browser goes to the `codex-computer-use` skill with the row's procedure and expected outcome; its verdict and evidence paths are recorded. Any other manual row, and any row the verifier returned as `BLOCKED`, is recorded as `unverified`. Never mark an acceptance row passed without recorded evidence. A task whose purpose is the manual evidence itself (a validation task, or one whose document says to block when prerequisites are missing) is `blocked` with the missing prerequisites as its next step, not completed with every row unverified. Otherwise set the log and final result to `completed`.

If the fifth iteration still has open blocking findings, set the log and result to `iteration_limit` with all open findings and the smallest next step.

If a `codex exec` run fails without a usable result, inspect its output file and the log, and retry once for a transient failure. On a second failure, record the evidence and return `status=blocked`.

## Consume the task result

Use this result shape:

```text
status=completed|blocked|needs_input|iteration_limit
task=T-<nnn>
log=<repository-relative task-log path>
summary=<single-line result>
```

On `completed`, fill the task document's completion record: the secretary-run evidence, the unverified rows, the worker's deviations from the planned steps or decided behavior, and any follow-ups. Mark the task `completed` in its front matter and `tasks.okf.md`. Stage only the task's implementation, tests, log, and plan-owned changes, so the diff and the record of how it departed from the plan land in the same commit. Review the staged diff and commit it with a conventional message: `feat: <task title> (T-<nnn>)`, or `fix:`/`refactor:` when that types the change more accurately. The commit is the task checkpoint. Start no other task until the commit succeeds and the worktree and index are clean.

On any other result, copy the blocker and next step into the task document. Mark the task `blocked` in its front matter and `tasks.okf.md`, then stop. Do not advance dependent tasks.

## Finish the plan

After each checkpoint, re-read `tasks.okf.md`, recompute dependency readiness, and continue in tracker order. After the last task:

- If every approved task is `completed` or `cancelled`, mark `plan.okf.md` `completed` and report the branch, one line per task with its commit and iterations used, every unverified acceptance row, the `Follow-ups` list, and whether `Not yet specified` still holds work that needs another planning pass.
- Otherwise mark `plan.okf.md` `blocked` and report each blocked task, its log path, blocker, and next step.
