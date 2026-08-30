---
name: init-project
description: "Scaffold a brand-new project of any stack (Swift/macOS/iOS, web, CLI, backend, anything) into a loop-ready state: git repo, canonical toolchain scaffold, test harness with one passing test, project instructions with verified commands, .tasks ignored. Use when the user says init project, new project, start a project, or scaffold X."
---

# Init project

Take an empty (or nearly empty) directory to the state the `planning` / `execute-plan` loop requires. Stack-agnostic: the deliverable is the checklist below, not any particular toolchain.

## 1. Settle the two inputs

Project name and stack. Two ways in:

- **Called from a plan's scaffold task**: the stack is already decided in `plan.okf.md`. Use it; don't relitigate.
- **Invoked directly**: if the user named the stack, use it. Otherwise derive it from what the project is (target platform, distribution, the user's tech preferences) and state the choice with one line of rationale before scaffolding — don't block on a question unless it's a genuine coin flip only the user can call.

## 2. Scaffold with the stack's canonical generator

Use the ecosystem's own init tool rather than hand-writing files it would generate:

- Swift package / CLI: `swift package init`
- macOS / iOS app: prefer a project generator available on the machine (`xcodegen`, `tuist`); if only Xcode templates work, create the minimal `project.yml`/manifest route and say so
- Web: the framework's create command (`bun create vite`, `create-next-app`, …) per user tech preferences
- Other stacks: `cargo init`, `uv init`, `go mod init`, etc.

Check the generator exists before using it; report what's missing instead of improvising a hand-rolled layout.

## 3. Make the baseline provable

- A test harness with one trivial passing test, using the stack's native runner (`swift test`, XCTest, `bun test`, `cargo test`, …).
- Run the full check set once and record that it passes. Do not declare the scaffold done on a generator's exit code alone.

## 4. Write the project instructions file

`CLAUDE.md` at the repo root (agents on other harnesses read it too via the universal conventions). Keep it short:

- Exact commands: test, build, typecheck/lint — the ones you just ran, verbatim. `execute-plan` finds its baseline command here.
- Stack and target (e.g. "SwiftUI, macOS 15+").
- Anything non-obvious the generator produced.

## 5. Git

- `git init` if needed; a `.gitignore` with the stack's canonical entries plus `.tasks/` and `.idea/`.
- Initial commit: `chore: scaffold <name> (<stack>)`.

## 6. Hand off

Report the verified commands and state the repo is loop-ready. Suggest the next step: switch to a strong reasoning model and ask for an implementation plan (the `planning` skill).
