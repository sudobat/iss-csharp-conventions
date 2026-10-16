---
name: prototype
description: Phase 2 of the feature flow (UI features only). Builds a clickable visual prototype of the approved requirements using the project's design system, iterates on it with the stakeholder, and records the approved screens so the spec can reference them. Use after /intake-requirements is approved and the feature has a user interface.
argument-hint: <feature-slug>
---

# Visual prototype

Feature: $ARGUMENTS

## 0. Preconditions

- `docs/features/<slug>/README.md`: phase 1 must be `approved`. If not,
  stop and point to `/intake-requirements`.
- No UI in this feature? Ask the user to confirm, mark phase 2 `n/a` and
  point to `/write-spec`.
- Design system: use the one recorded in `README.md`. If it says "none",
  ask whether to prototype with a neutral style or provide one first.

## 1. Plan the screens

From `requirements.md` and `qa-log.md` list the screens and states the
prototype must show. Give each an ID (`S-01`, `S-02`, …) and map it to the
`R-xxx` it illustrates. Include empty, error and permission-denied states
when requirements mention them. Show the list to the user before building.

Anything you would need to invent to draw a screen (a field, a label, a
button, an order) is a question: log it in `qa-log.md` and ask, as in
`/intake-requirements` step 4.

## 2. Build it

Prefer, in this order:

1. **Claude Design** (when the Artifact tool offers a Design type): run
   `Artifact` `quickstart` with intent `design` and pick the project's
   design system. One prototype per feature; each `S-xx` is a named frame.
   Share the link with the stakeholder; their comments arrive on the
   artifact.
2. **Static HTML in the repo** (fallback, or if the team prefers it in the
   PR): `docs/features/<slug>/prototype/` with one HTML file per screen,
   using only the design system's tokens and components (no invented
   colours, spacing or components).

Prototype only what the requirements say. No extra features "for
completeness".

## 3. Iterate with the stakeholder

Every piece of feedback goes to `qa-log.md` with the reviewer's name and
date (source: "prototype review"). If it changes behaviour, add or update
the `R-xxx` it affects and cite the `Q-xxx`. Reopen phase 1 if feedback
contradicts an approved requirement, and say so.

## 4. Record and approve (gate)

Write `docs/features/<slug>/prototype.md`:

```markdown
# Prototype — <Feature title>

Link: <claude.ai design URL or prototype/ path>
Approved version: <artifact version label or git commit> · <date> · <approver>
Design system: <name and version/commit>

| Screen | Name | Shows | Requirements |
|--------|------|-------|--------------|
| S-01 | | | R-001, R-004 |
```

Ask who approved and when. Set phase 2 `approved` in `README.md`.

## Keeping prototype and project in sync

- `spec.md` references screens by `S-xx`. The **spec** is the source of
  truth for behaviour; the prototype is the source of truth for layout.
- Changing an approved prototype after the spec exists means updating
  `prototype.md` (new approved version) and reopening the spec items that
  reference the changed screens.
- Keep the design system itself in sync between code and claude.ai with the
  built-in `/design-sync` skill, not by hand.

Next step: `/write-spec <slug>`.
