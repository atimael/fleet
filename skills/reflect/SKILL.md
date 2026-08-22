---
name: reflect
description: Spawn three parallel review subagents over the active transcript, surface learnings, and route each to a concrete edit on an existing skill. Use when the user says reflect.
disable-model-invocation: true
---

# Reflect

Mine the current conversation for durable learnings, then route them into skill edits.

## When to invoke

- The user said "reflect" or "/reflect".
- A complex task (5+ tool calls) just landed cleanly and the recipe is worth keeping.
- The agent hit dead ends, found the working path, and the path generalizes.
- The user corrected the agent's approach mid-task.
- A non-trivial workflow emerged that isn't captured anywhere.

Skip when the conversation is trivial, off-topic, or already covered by an existing skill the parent followed correctly. One-offs are not learnings.

## Where skills live

Skills are managed in a source repo and symlinked into each agent's discovery directory (`~/.claude/skills/`, `~/.codex/skills/`, `~/.agents/skills/`). Resolve the source repo with `realpath` on this skill's own directory — its parent is the repo's `skills/` folder. All edits and new skills land in that repo; editing through a symlink hits the same file. After creating a new skill, run the repo's `install.sh`.

## Process

### 1. Locate the active transcript

The parent finds its own transcript file before fanning out. Look only in the current session's harness directory for this workspace; do not glob across other projects' transcript directories — that crosses workspace boundaries and reads private chats from unrelated projects.

- Claude Code (and harnesses built on the Claude Agent SDK): `~/.claude/projects/<cwd-with-slashes-as-dashes>/*.jsonl`, e.g. `~/.claude/projects/-Users-you-Dev-proj/`. Subagent transcripts sit alongside or under the session's directory.
- Codex CLI: `~/.codex/sessions/<YYYY>/<MM>/<DD>/rollout-*.jsonl`.

```bash
ls -t <transcript-dir>/*.jsonl 2>/dev/null | head -10
```

For each candidate, read the first JSONL lines and check they contain the conversation's opening user prompt. Take the matching path. If no path resolves, write a tight digest of the session and pass that instead.

### 2. Spawn three reviewers in parallel

One message, three subagent calls via the harness's subagent tool (`Agent`/`Task`, general-purpose type). Reviewers need MCP access for context lookups (tickets, chat threads, observability traces referenced in the transcript), so do not strip tools down to read-only file access if that also strips MCPs. The prompt forbids file writes; the parent applies edits.

| Lens | Model | Prompt template |
|---|---|---|
| Judgment | strongest available reasoning model | `references/judgment-reviewer.md` |
| Tooling | strongest available reasoning model | `references/tooling-reviewer.md` |
| Divergent | strongest available reasoning model | `references/divergent-reviewer.md` |

Pass each template verbatim, substituting the transcript path or digest where marked. Reviewers return findings in the subagent response body.

### 3. Synthesize

One subagent call, general-purpose type, strongest available reasoning model. The synthesizer's quality check includes spot-verifying citations, which can require MCP access. Use `references/synthesizer.md` verbatim, with each reviewer's full output inlined where marked. The synthesizer returns a structured Accepted / Rejected / Backlog list.

### 4. Structural enforcement check

Sanity-check the synthesizer's Accepted list. For any item that would be enforced more reliably by a lint rule, script, metadata flag, or runtime check, move it from Accepted to Backlog. Skill prose is for things mechanisms cannot enforce. The synthesizer already applies this criterion; this is a final pass before edits land.

### 5. Apply

Before applying any Accepted edit, present the synthesizer's full Accepted/Rejected/Backlog output to the user and wait for explicit approval. The user picks which subset to apply and may redirect routings. Skill changes affect every future session; do not auto-apply.

Backlog items append to `BACKLOG.md` at the skills source repo root automatically (create it if missing) — one bullet per item with the pattern, what was hit, and the suggested mechanism. Those are notes, not skill edits. Only the Accepted list waits for approval.

For each approved Accepted item, follow the Routing field exactly:

- Trivial existing-skill edit (a one-line bullet, a tightened sentence, a stale fact corrected): parent does directly.
- Substantive existing-skill edit (a new section, a new pattern table, more than ~10 lines): draft it, re-read the whole skill for coherence, and trim anything the addition makes redundant.
- `tune description: <skill path>` (the skill exists but didn't trigger when it should have): rewrite the skill's frontmatter `description` to front-load the trigger phrases the session actually used. Keep it one sentence of triggers plus one of action.
- `new skill: <kebab-name>`: create `skills/<kebab-name>/SKILL.md` in the source repo with `name` and `description` frontmatter, then run `install.sh`.

If your environment ships a SKILL.md validator, run it on every touched skill before declaring done. Skip this step if it doesn't.

### 6. Summarize for the user

Short list, no preamble:

- Edits applied: `<skill path>`. What changed, one line each.
- New skills created: `<skill path>`. One line each (rare).
- Backlog appended to `BACKLOG.md`: `<item title>`. One line each.
- Dropped: one line per rejected finding + reason from the synthesizer.
