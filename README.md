# fleet

A single repo collecting all my AI skills.

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
