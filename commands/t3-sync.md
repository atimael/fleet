---
description: Symlink this project's .claude/commands into user scope so the T3 Code palette sees them
allowed-tools: Bash(t3-sync:*)
---

Run `t3-sync` with the Bash tool from the current project directory and report its output verbatim: which
commands were linked, which stale links were pruned, or the error if no `.claude/commands` exists here.
