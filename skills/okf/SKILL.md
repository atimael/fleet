---
name: okf
description: Create and maintain OKF (Operational Knowledge Format) Markdown artifacts for evidence-based project documentation or dependency-aware implementation plans.
---

# OKF

OKF is a local Markdown profile for durable engineering knowledge. It is not the
Open Knowledge Foundation or Frictionless Data Package standard. If the target
repository supplies an OKF schema, template, or validator, use that definition
instead and mention any material difference from this profile.

First identify the requested deliverable, then read **only** its reference:

- For an implementation plan, task decomposition, dependencies, execution order,
  or separate task documents, read
  [references/task-planning.md](references/task-planning.md).
- For project documentation, architecture, system context, components, runtime or
  data flows, decisions, and operational context, read
  [references/project-documentation.md](references/project-documentation.md).

Read both references only when the user explicitly requests both a plan and
project documentation. Each reference starts with a routing header and contents;
scan those headings, then read only the sections required for the deliverable.
Do not use a fixed line-count cutoff. Inspect relevant repository material before
writing; distinguish source-backed facts from assumptions and open questions.
