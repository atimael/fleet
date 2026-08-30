# Sources

Where each imported skill came from, for future update checks. To check for
upstream changes, diff the skill's upstream directory between the imported
commit and current `main`. Skills marked **adapted** were modified after
import (de-Cursored: transcript paths, subagent/model wiring, references to
uninstalled skills) — merge upstream changes manually, don't overwrite.

All imports below: repo [cursor/plugins](https://github.com/cursor/plugins),
imported 2026-08-22 at commit [`4612556`](https://github.com/cursor/plugins/tree/46125561306434d8a1d7745d540d8932ab0cd2a2).

| Skill | Upstream path | Local changes |
|---|---|---|
| unslop | [pstack/skills/unslop](https://github.com/cursor/plugins/tree/main/pstack/skills/unslop) | none |
| typescript-best-practices | [pstack/skills/typescript-best-practices](https://github.com/cursor/plugins/tree/main/pstack/skills/typescript-best-practices) | none |
| why | [pstack/skills/why](https://github.com/cursor/plugins/tree/main/pstack/skills/why) | none |
| reflect | [pstack/skills/reflect](https://github.com/cursor/plugins/tree/main/pstack/skills/reflect) | **adapted**: transcript paths, subagent/model wiring, `create-skill` dependency replaced with direct drafting in this repo, backlog → `BACKLOG.md` |
| blast-radius | [pstack/skills/blast-radius](https://github.com/cursor/plugins/tree/main/pstack/skills/blast-radius) | **adapted**: `arena` step → generic subagent fan-out |
| how | [pstack/skills/how](https://github.com/cursor/plugins/tree/main/pstack/skills/how) | **adapted**: subagent/model wiring, dropped `interrogate` reference |
| principle-boundary-discipline | [pstack/skills/principle-boundary-discipline](https://github.com/cursor/plugins/tree/main/pstack/skills/principle-boundary-discipline) | auto-invoke enabled¹ |
| principle-encode-lessons-in-structure | [pstack/skills/principle-encode-lessons-in-structure](https://github.com/cursor/plugins/tree/main/pstack/skills/principle-encode-lessons-in-structure) | auto-invoke enabled¹ |
| principle-experience-first | [pstack/skills/principle-experience-first](https://github.com/cursor/plugins/tree/main/pstack/skills/principle-experience-first) | auto-invoke enabled¹ |
| principle-fix-root-causes | [pstack/skills/principle-fix-root-causes](https://github.com/cursor/plugins/tree/main/pstack/skills/principle-fix-root-causes) | auto-invoke enabled¹ |
| principle-laziness-protocol | [pstack/skills/principle-laziness-protocol](https://github.com/cursor/plugins/tree/main/pstack/skills/principle-laziness-protocol) | auto-invoke enabled¹ |
| principle-minimize-reader-load | [pstack/skills/principle-minimize-reader-load](https://github.com/cursor/plugins/tree/main/pstack/skills/principle-minimize-reader-load) | auto-invoke enabled¹, dropped `guard-the-context-window` link |
| principle-model-the-domain | [pstack/skills/principle-model-the-domain](https://github.com/cursor/plugins/tree/main/pstack/skills/principle-model-the-domain) | auto-invoke enabled¹ |
| principle-prove-it-works | [pstack/skills/principle-prove-it-works](https://github.com/cursor/plugins/tree/main/pstack/skills/principle-prove-it-works) | auto-invoke enabled¹, dropped `show-me-your-work` mention |
| principle-subtract-before-you-add | [pstack/skills/principle-subtract-before-you-add](https://github.com/cursor/plugins/tree/main/pstack/skills/principle-subtract-before-you-add) | auto-invoke enabled¹ |
| principle-type-system-discipline | [pstack/skills/principle-type-system-discipline](https://github.com/cursor/plugins/tree/main/pstack/skills/principle-type-system-discipline) | auto-invoke enabled¹ |

¹ Removed `disable-model-invocation: true` so agents apply the principle
automatically when its trigger description matches.

Original skills with no upstream: `validate-idea`, `codex-computer-use`,
`init-project`.

Imported 2026-08-30 from a user-provided bundle (no public upstream):
`planning`, `okf`, and `execute-plan` (renamed from `execute-plan-opencode`).
**Adapted**: OpenCode worker types replaced with Codex CLI workers
(gpt-5.6-sol low) under a Fable-low secretary, `planned` status renamed
`dependent`, `execute-task`/"Ralph" references fixed, commits switched to
conventional format.

Evaluated and not adopted (in local `.staging/`, gitignored):
`principle-build-the-lever`, `principle-sequence-verifiable-units`,
`principle-make-operations-idempotent`, `principle-separate-before-serializing-shared-state`,
`principle-migrate-callers-then-delete-legacy-apis`, `principle-outcome-oriented-execution`,
`principle-foundational-thinking`, `principle-redesign-from-first-principles`,
`principle-exhaust-the-design-space`, `principle-never-block-on-the-human`,
`principle-guard-the-context-window`.
