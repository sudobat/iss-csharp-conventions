---
name: feature-flow
description: Entry point and status board for the agentic feature flow (requirements → prototype → spec → tasks → RED/GREEN/REFACTOR). Shows where a feature is, what is blocking it, and runs the next step. Use when the user starts a new feature, asks "where are we with X", "what's next", or wants to continue a feature.
argument-hint: [feature-slug]
---

# Feature flow

Feature: $ARGUMENTS

The flow and its artefacts are described in `docs/features/README.md`.
Read it first.

## No slug given

List every folder in `docs/features/` with its phase gates (from each
`README.md`) and task progress (`done`/total from `tasks.md`). Ask which
one to continue, or whether to start a new feature (→ ask for a short
kebab-case slug and run `/intake-requirements <slug>`).

## Slug given

1. Read `docs/features/<slug>/README.md`, `qa-log.md` and, if present,
   `spec.md` and `tasks.md`.
2. Report in a few lines:
   - Phase gates and who approved them.
   - Open questions: `open` and `pending-stakeholder` in `qa-log.md`, and
     what they block.
   - Spec items not yet approved.
   - Tasks by status, and any `.claude/state/tdd-lock` in progress.
3. Name the next step, following the first phase that is not `approved`
   or `n/a`:

   | First incomplete phase | Next step |
   |------------------------|-----------|
   | 1. Requirements (or `reopened`) | `/intake-requirements <slug>` |
   | 2. Prototype | `/prototype <slug>` |
   | 3. Spec | `/write-spec <slug>` |
   | 4. Tasks | `/plan-tasks <slug>` |
   | 5–7. Implementation | `/tdd-task <slug> next` |
   | all approved | `/update-docs --check`, then close the feature |

4. Ask whether to run it now. Never skip a gate, and never mark a gate
   approved from here.
