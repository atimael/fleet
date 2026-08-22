# Personal Preferences

## Writing Style

- Before writing any prose (replies, docs, commit messages, README content), read and apply ~/.claude/skills/unslop/SKILL.md. Do this once per session, at the first prose task.

## TypeScript

- Never use 'any' unless 100% necessary or specifically instructed.

## Commands

- Don't run dev server commands (e.g., 'bun run dev") - assume it's already running.
- Don't run build commands unless specifically told to.
- Focus on checking commands like 'bun run typecheck', 'bun run lint", etc.

## Package Managers

- Use pnpm if the project already uses it, otherwise use bun.
- Never use npm or yarn.

## Tech Stack Preferences

When uncertain, prefer: Tailwind, TypeScript, Bun, React, Convex, Tanstack.

## Code Style

- Always strive for concise, simple solutions.
- If a problem can be solved in a simpler way, propose it.

## Git Workflow

- Use conventional commits: feat:, fix:, docs:, refactor:
- Keep commits atomic and focused
- Write meaningful commit messages
- Never mention or tag Claude as a contributor

## Comment Policy

### Unacceptable Comments

- Comments that repeat what code does
- Commented-out code (delete it)
- Obvious comments ("increment counter")
- Comments instead of good naming

## General preferences

- If asked to do too much work at once, stop and state that clearly.
- If computer use is helpful for completing or verifying work, shell out to gpt-5.6 with Codex for it
