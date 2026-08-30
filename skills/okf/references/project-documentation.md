# OKF project documentation

> **Use when:** documenting a project's architecture, system context, components,
> runtime/data flows, decisions, risks, or operations. **Do not use when:**
> creating a dependency-aware implementation plan.
>
> **Start with:** Ground rules, Artifact location, and Template. Read Diagrams and
> consistency only when documenting a nontrivial flow. **Search terms:** component
> map, runtime flow, contracts, persistence, decisions, risks, assumptions.

## Ground rules

- Inspect repository structure, manifests, entry points, runtime configuration,
  API boundaries, persistence, integrations, tests, and deployment or CI material
  relevant to the document.
- Ground each claim in evidence. Cite repository-relative paths and symbols; mark
  anything not verified from source as an assumption or open question.
- Use YAML front matter for metadata and Markdown for the body.
- Use stable IDs: `ARCH-<area>` for components, `DEC-<n>` for decisions, and
  `RISK-<n>` for risks.
- Keep `last_verified`, `sources`, and the append-only change log current.
- Do not invent owners, dates, runtime behavior, or decision status; use `TBD`
  where the repository does not establish the fact.

## Artifact location

Use the repository’s established documentation directory and conventions. If
none exist, create `docs/okf/architecture.okf.md`.

## Template

```md
---
okf: 1
kind: architecture
project: <project name>
status: draft | active | superseded
last_verified: YYYY-MM-DD
sources:
  - path: <repo-relative path>
    purpose: <what this proves>
---

# <Project> architecture

## Purpose
<Problem solved, users, and primary outcomes.>

## System context
| Actor/system | Interaction | Boundary | Evidence |
| --- | --- | --- | --- |

## Component map
| ID | Component | Responsibility | Interfaces/dependencies | Evidence |
| --- | --- | --- | --- | --- |
| ARCH-<area> | <name> | <single responsibility> | <inputs/outputs> | `<path>` |

## Runtime and data flow
1. <numbered flow with component IDs and interfaces>
2. <...>

## Key contracts and invariants
- <contract/invariant> — evidence: `<path:symbol>`

## Persistence and external integrations
| System | Data/operation | Failure/security considerations | Evidence |
| --- | --- | --- | --- |

## Configuration and operations
<Configuration, environments, observability, deployment, and recovery facts.>

## Decisions and trade-offs
| ID | Decision | Rationale | Consequences | Status |
| --- | --- | --- | --- | --- |
| DEC-001 | <decision> | <why> | <trade-off> | proposed/accepted |

## Risks, assumptions, and open questions
| ID | Type | Statement | Impact | Resolution/evidence needed |
| --- | --- | --- | --- | --- |
| RISK-001 | risk | <statement> | <impact> | <next action> |

## Change log
| Date | Change | Evidence |
| --- | --- | --- |
```

## Diagrams and consistency

Use a Mermaid diagram only when it clarifies a nontrivial relationship or flow;
keep it consistent with the component map. Before handoff, verify that every
claim has evidence or a label, component responsibilities agree with interfaces
and flows, decisions and uncertainties are explicit, and all repository paths
and links are valid.
