# fleet

A single repo collecting all my AI skills.

## Cheatsheet

**Auto** skills kick in on their own when the conversation matches their
trigger; **manual** ones you invoke by typing `/<name>` (they never fire
on their own).

### Workflow skills

| Skill | In a nutshell | Invoke |
|---|---|---|
| `how` | Explains how a piece of the codebase works — fans out explorer subagents over a subsystem and writes an onboarding-style walkthrough. Also has a critique mode that hunts for architectural problems. | auto — ask "how does X work?" |
| `why` | Digs up *why* the code is the way it is — searches git history, PRs, tickets, docs, and any connected MCPs, then answers with citations. | auto — ask "why is X like this?" |
| `blast-radius` | Before a risky change ships: finds what it could break *beyond* the obvious callers, pins down the one fact the change's safety depends on, and proves it by running real code. | manual — `/blast-radius` |
| `reflect` | End-of-session retrospective: three reviewer subagents mine the conversation for durable lessons, and (with your approval) the lessons get written back into the skills in this repo. | manual — `/reflect` |
| `unslop` | Strips AI-sounding patterns from any writing and pushes toward a human voice. | auto — on any writing task |
| `typescript-best-practices` | House rules for TypeScript code. | auto — on any `.ts`/`.tsx` work |

### Principles

Small engineering-values cards. All **auto** — the agent pulls one in
when the situation matches; you never invoke them yourself (though
`/principle-<name>` works if you want to point at one).

| Principle | In a nutshell |
|---|---|
| `fix-root-causes` | When debugging, trace to the real cause — no nil-check band-aids that silence the crash. |
| `prove-it-works` | Before saying "done", verify against the real thing: run the feature, read the actual output. "It compiles" doesn't count. |
| `type-system-discipline` | Make the type checker do the work: illegal states unrepresentable, branded IDs, no lying casts, exhaustive matches. |
| `boundary-discipline` | Validate data once, at the edges (config, network, CLI). Inside, trust the types and keep logic in pure functions. |
| `model-the-domain` | Lots of branching or paired booleans? Reach for a structure instead: state machine, discriminated union, lookup table. |
| `laziness-protocol` | Smallest change that solves the problem. Prefer deleting code. No speculative layers. |
| `minimize-reader-load` | Optimize for the next reader: collapse one-caller wrappers, shrink mutable scope, cut indirection. |
| `subtract-before-you-add` | Remove dead weight first, then build on the simpler base. |
| `encode-lessons-in-structure` | Recurring correction? Turn it into a lint rule / script / check instead of writing the instruction again. |
| `experience-first` | The product is the experience — fewer polished features over many rough ones; sweat the details. |

## Layout

```
skills/
  <skill-name>/
    SKILL.md        # frontmatter (name, description) + instructions
    ...             # optional supporting files (scripts, references)
```

Each skill is a self-contained directory under `skills/`, following the
[Agent Skills](https://docs.claude.com/en/docs/agents-and-tools/agent-skills) format:
a `SKILL.md` with YAML frontmatter (`name`, `description`) and the skill
instructions as the body. The same format is understood by Claude Code,
Codex CLI, and other agents — one skill directory works everywhere.

## Installing

```sh
./install.sh
```

Symlinks every skill in `skills/` into each tool's discovery directory:

| Tool | Location |
|---|---|
| Claude Code | `~/.claude/skills/` |
| Codex CLI | `~/.codex/skills/` |
| Universal layout (Codex, Cursor, Gemini CLI, Copilot, …) | `~/.agents/skills/` |

T3 Code needs no separate install — it drives CLI agents underneath and
picks up whatever skills they discover.

Because installs are symlinks, this repo stays the single source of truth:
edit or `git pull` here and every tool sees the change immediately.
Re-run `./install.sh` only when adding a new skill. Existing non-symlink
directories at a target location are never overwritten (the script skips
them and tells you).
