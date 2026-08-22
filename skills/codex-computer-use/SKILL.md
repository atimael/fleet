---
name: codex-computer-use
description: "Ask Codex CLI (gpt-5.6) to run local app verification that needs computer use: browser automation, simulators, screenshots, app launching, or independent runtime inspection. This is how gpt-5.6 is invoked for computer-use work. Use when the user asks Claude to test a flow, verify UI behavior, inspect a running app, capture screenshots, or confirm implemented behavior in the real app."
---

# Codex computer use

Use Codex as a separate local verification agent when the task needs real UI interaction, screenshots, simulator/browser/device state, or an independent runtime check outside Claude's current context.

Do not use this for ordinary code reading, typechecking, linting, or tests Claude can run directly. Launching apps, simulators, or browsers to verify the requested work is fine without asking; ask first only if the run could disrupt the user's environment beyond that (closing their apps, changing system settings, acting on real accounts or data).

## Workflow

### 1. Preflight

- `command -v codex` — if missing, tell the user and stop; don't simulate the verification.
- Know what you're verifying before delegating: the exact flow, the expected behavior, and where the app runs. Assume dev servers are already running (per user preference, never start them); get the URL or simulator/app name from the project or the conversation.
- Pick an evidence directory: `/tmp/codex-verify/<short-task-slug>/`. Create it.

### 2. Compose the brief

Codex shares none of your context. The prompt must stand alone:

- What was implemented, in two or three sentences.
- How to reach it: URL, simulator and app name, or binary path, plus any test credentials already present in the project (never real accounts).
- The exact flow to walk, step by step, and the expected result of each step.
- Evidence to capture: screenshots at the named steps, saved into the evidence directory with numbered filenames (`01-login.png`, `02-dashboard.png`).
- The required final report format:

```
VERDICT: PASS | FAIL | BLOCKED
STEPS: numbered, one line each, what was done and what was observed
EVIDENCE: list of file paths
NOTES: anything unexpected, even on PASS
```

`BLOCKED` means the run couldn't complete (missing simulator, login wall, crash on launch) — report why instead of improvising.

If a reference design or before-screenshot exists, attach it with `-i <file>` so Codex compares against it.

### 3. Invoke

```bash
codex exec \
  -s danger-full-access \
  -C <project-dir> \
  -o /tmp/codex-verify/<slug>/last-message.md \
  "<brief>"
```

- `-s danger-full-access` is required for computer use: driving simulators, browsers, and `screencapture` doesn't work inside the workspace sandbox. That's the accepted tradeoff of this skill and why the disruption rule above exists.
- `-o` writes the final report to a file so it survives even if stdout is noisy.
- Add `-m <model>` only to override the user's configured Codex default; otherwise leave it alone.
- Add `--skip-git-repo-check` when the project isn't a git repo.
- UI runs are slow. Give the Bash call a generous timeout (5 to 10 minutes) and run it in the background if you have other work to do meanwhile.

### 4. Verify the artifacts yourself

Codex's summary is a self-report, not proof (see the prove-it-works principle skill). Before relaying anything:

- Read the report file, then open each screenshot and check it actually shows the claimed state — right screen, right data, no error toast in the corner.
- If evidence is missing for a claimed step, or a screenshot contradicts the verdict, treat the run as inconclusive. Re-run with a sharper brief or verify that step another way. Don't average it out.

### 5. Report to the user

- The verdict, in one line, then what was walked and what the evidence shows.
- The evidence paths, so the user can look themselves.
- Discrepancies between Codex's claims and the artifacts, if any.
- On `BLOCKED`: what's needed to unblock (a simulator to install, a login to provide), stated plainly.
