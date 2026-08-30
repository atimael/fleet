---
name: execute-plan
description: Execute an OKF implementation plan as a dependency-ordered loop; a secretary agent schedules tasks, Codex CLI workers implement them, and every result is test-verified and committed per task. Use when an initiative has `plan.okf.md`, `tasks.okf.md`, and linked task documents.
---

# Execute an OKF plan

Execute a completed planning handoff as a loop: pick up the next ready task, hand it to a worker, verify the result with real commands, log everything, commit, repeat. This skill is self-contained. Do not load another execution skill.

## Roles and models

| Role | Model | How it runs |
|---|---|---|
| Planner | Fable, high reasoning | the `planning` skill, before this one |
| Secretary | Fable, low reasoning | the main agent running this skill |
| Implementer | Codex CLI, `gpt-5.6-sol`, low reasoning | `codex exec`, fresh session per task |
| Fixer | Codex CLI, `gpt-5.6-sol`, low reasoning | `codex exec`, one session per repair round |

The secretary is the only writer of plan-owned files and task logs, the only agent that runs test and verification commands, and the only agent that commits. Workers implement; the secretary proves. Workers may run typechecks or focused tests for their own feedback, but only the secretary's recorded runs count as evidence.

## Establish the plan state

1. Find the repository root and read its instructions. Read `plan.okf.md`, `tasks.okf.md`, and every linked task document.
2. Confirm that every tracked task has one document and that task IDs, links, statuses, `depends_on`, `blocks`, the dependency graph, and execution order agree. Confirm that each task has bounded scope, acceptance criteria, a test plan, verification commands or procedures, risks, and a completion record. Stop with `status=needs_input` for a broken link, unresolved requirement, dependency cycle, ambiguous test requirement, or missing architectural or product decision.
3. Record the current branch and commit. Require a clean worktree and index. Stop with `status=blocked` and list every changed path if either is dirty.
4. Find the baseline test command in checked-in repository instructions and build configuration. Run it on the starting commit; stop with `status=blocked` and its failure summary if it fails. Record the exact command and result. Greenfield exception: when the repository has no test harness and the first executable task is the plan's scaffold task, skip this step — that task's own verification establishes the baseline, and its recorded commands govern every later task. Stop with `status=needs_input` only when the command is missing with no scaffold task to create it.
5. Derive a lowercase, hyphen-separated initiative slug from its title or ID. Create and switch to `feature/<initiative-slug>` from the recorded commit. If already on that initiative's execution branch, ask the user before reusing it. Stop with `status=needs_input` if the checkout is not a Git repository, the target branch exists, branch creation fails, or reuse is not confirmed.

Keep approved plan scope fixed. Report a scope gap instead of expanding a task.

## Schedule tasks

Keep one task active at a time. A `dependent` task becomes executable only when every task in `depends_on` is `completed`; evaluate readiness without editing plan-owned files so each task starts from a clean checkout. Never execute a `blocked` or `cancelled` task, or a task with an incomplete dependency.

Select the first `ready` or dependency-satisfied `dependent` task in tracker order. Repeat the task procedure below until no executable task remains.

## Start the selected task

1. Confirm that the worktree and index are clean. Stop with `status=blocked` and list every changed path if they are not.
2. If the task is `dependent`, record its `ready` transition in its document and `tasks.okf.md`. Then mark it `in_progress` in both files. Record the exact status-only diff. Block if that diff contains any other change.
3. Create `task-logs/T-<nnn>-log.okf.md` from the task-log template in the `okf` skill's `references/task-planning.md`, and replace the task's `pending` log value in `tasks.okf.md` with a repository-relative link.

The secretary is the only task-log writer. Replace current-summary fields and append chronological events and decisions. Write an event before and after each worker handoff. Never erase review findings; mark each `open`, `resolved`, or `accepted` with evidence. Read the current log before every handoff.

## Hand a task to a worker

Run each worker as a fresh Codex CLI session:

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
- The task's scope fence: which files may change, and that plan-owned files, dependencies, other tasks, and commits are off-limits.
- Every open finding when this is a repair round, quoted in full with its evidence.
- The reporting contract: end with changed files, decisions made, test coverage added, finding dispositions, and any blocker.

Workers implement code and tests only. The secretary runs the suite. Give the Bash call a generous timeout and run it in the background when useful.

## Run the implement-review loop

Run at most five iterations:

1. Set the log to `implementing` (or `repairing`) and record the handoff. Run the implementer (or fixer) with the packet above.
2. Read the worker's report, inspect the actual diff, and update the log. Return `status=needs_input` for an unresolved product or architectural decision. Run the focused tests the worker added or changed, then the task's required verification commands. Record every exact command and result in the log. On a failure, send the full output and relevant code context to a fixer and repeat from step 1.
3. When every check passes, review the diff yourself against the task document: correctness, the governing invariant, acceptance criteria, scope, regression risk, test coverage, and repository conventions. The review examines the diff and the recorded evidence; the implementation was written by a different model, so this is an independent read. Record findings with stable IDs and actionable evidence.
4. On findings, send all open findings to a fixer in the next iteration, then rerun focused tests and verification before reviewing again. On an unresolved blocker, record it and the smallest next step, then stop the loop with the matching result.
5. With no open findings, independently confirm every acceptance criterion, planned test, and verification result. Set the log and final result to `completed`.

If the fifth iteration still has open findings, set the log and result to `iteration_limit` with all open findings and the smallest next step.

If a `codex exec` run fails without a usable result, inspect its output file and the log, and retry once for a transient failure. On a second failure, record the evidence and return `status=blocked`.

## Consume the task result

Use this result shape:

```text
status=completed|blocked|needs_input|iteration_limit
task=T-<nnn>
log=<repository-relative task-log path>
summary=<single-line result>
```

On `completed`, confirm that the log contains passing secretary-run test and verification evidence. Copy that evidence into the task document's completion record. Mark the task `completed` in its document and `tasks.okf.md`. Stage only the task's implementation, tests, log, and plan-owned status or completion-record changes. Review the staged diff and commit it with a conventional message: `feat: <task title> (T-<nnn>)`, or `fix:`/`refactor:` when that types the change more accurately. The commit is the task checkpoint. Start no other task until the commit succeeds and the worktree and index are clean.

On any other result, copy the blocker and next step into the task document. Mark the task `blocked` in its document and `tasks.okf.md`, then stop. Do not advance dependent tasks.

## Finish the plan

After each checkpoint, re-read `tasks.okf.md`, recompute dependency readiness, and continue in tracker order. After the last task:

- If every approved task is `completed` or `cancelled`, mark `plan.okf.md` `completed` and report the branch, task checkpoints, and verification summary.
- Otherwise mark `plan.okf.md` `blocked` and report each blocked task, its log path, blocker, and next step.
