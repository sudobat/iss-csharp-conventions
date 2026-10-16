---
name: plan-tasks
description: Phase 4 of the feature flow. Breaks an approved spec into small, ordered, estimated implementation tasks (vertical slices), each covering specific acceptance criteria, written to docs/features/<slug>/tasks.md. Use after /write-spec is approved.
argument-hint: <feature-slug>
---

# Plan the tasks

Feature: $ARGUMENTS

## 0. Preconditions

`docs/features/<slug>/README.md` phase 3 is `approved` and `spec.md` status
is `approved`. Otherwise stop and point to `/write-spec`.

Read `spec.md`, `prototype.md`, `CLAUDE.md`, `ARCHITECTURE.md`, and locate
the code each capability touches (entry points, domain, persistence, UI,
existing tests). Find a similar existing feature to use as the template.

## 1. Slice

- **Vertical slices**: each task delivers observable behaviour end to end
  (API and/or UI), so it can be verified by end-to-end tests in its RED
  step. Avoid "all the entities", "all the endpoints" tasks.
- Each task covers one or a few acceptance criteria. Every `AC`, `BR` and
  `NFR` in the spec is covered by exactly one task (a criterion may be
  extended later, but has one owner).
- Enabling work with no criterion of its own (project setup, test
  infrastructure, migrations) is allowed only when a slice needs it; mark
  it `enabler` and name the task it unblocks.
- Order by dependency, then by risk: the riskiest unknowns first.
- Structural changes (new project, package, layer dependency): run the
  `architecture-guardian` agent on the plan and include its verdict.

## 2. Estimate

For each task give a size and the reason, so the team can value it:

- `S`: one layer of new code following an existing pattern, few tests.
- `M`: several layers or a new pattern, a handful of tests.
- `L`: new integration, migration, or unknowns. Try to split it; if it
  cannot be split, say why.

Also note risks and open technical questions (these are for the team, not
new behaviour).

## 3. Write `tasks.md`

```markdown
# Tasks — <Feature title>

Spec version: <n>

| ID | Task | Covers | Tests (API/UI) | Depends on | Size | Status |
|----|------|--------|----------------|------------|------|--------|
| T-001 | | AC-001, AC-002 | API | – | S | todo |

Status: todo → red → green → done (or blocked).

## Coverage

| Spec item | Task |
|-----------|------|
| AC-001 | T-001 |

## T-001 — <title>

- Goal: <one sentence>
- Covers: AC-001, AC-002
- Touches: <projects / folders>
- Template feature: <path of the similar feature>
- Size: S — <reason>
- Risks: …
- RED tests: <filled during /tdd-task>
```

## 4. Approve (gate)

Show the table, the coverage matrix and the estimates. Ask the user to
approve, reorder, merge or split. Apply changes and ask again. On approval
set phase 4 `approved` in `README.md` (who, date).

Next step: `/tdd-task <slug> T-001`.
