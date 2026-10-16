---
name: write-spec
description: Phase 3 of the feature flow. Converts approved requirements (and the approved prototype, if any) into a concrete, testable specification with acceptance criteria, audits it for invented or vague content, and gets human approval item by item. Use after /intake-requirements (and /prototype for UI features) are approved, or when an approved spec must change.
argument-hint: <feature-slug>
---

# Write the specification

Feature: $ARGUMENTS

Goal: go from vague requirements to concrete specs. Every line of the spec
is traceable to a requirement, and every requirement to a source or an
answer. Nothing is invented.

## 0. Preconditions

Read `docs/features/<slug>/README.md`:

- Phase 1 `approved`. Phase 2 `approved` or `n/a`. Otherwise stop and name
  the missing phase.
- Read `requirements.md`, `qa-log.md`, `prototype.md` (if any) and every
  file in `sources/`.

If `spec.md` already exists, this is a change: keep approved items as they
are unless the change touches them, bump the version, and reset to
`pending` only the items you modify.

## 1. Draft

Create `spec.md` from this skill's `spec-template.md`.

- Every acceptance criterion (`AC-xxx`), business rule (`BR-xxx`) and NFR
  has a `Covers` column with the `R-xxx` it comes from. UI criteria also
  name the screen (`S-xx`).
- Every `confirmed` functional requirement is covered by at least one item.
  `to-confirm` requirements cannot be specified: go back to the Q&A loop.
- Acceptance criteria are concrete and observable end to end: real example
  values, the exact API status or UI message, no "appropriate", "valid",
  "quickly", "etc.". If the source does not give the value, ask.
- Business rules include a worked example (input → output).
- Fill section 9 with any `pending-stakeholder` questions and the items they
  block. Blocked items stay `blocked`, not `pending`.

## 2. Audit

Launch the `spec-auditor` agent on `docs/features/<slug>/`. For each
finding:

- Untraceable or invented content → remove it, or turn it into a question.
- Vague or untestable criterion → make it concrete only with values from a
  source or an answer; otherwise ask.
- Uncovered requirement → add the item or ask whether it is out of scope.

Questions follow the same loop as `/intake-requirements` step 4: logged in
`qa-log.md` first, asked with `AskUserQuestion`, answers recorded and
cited. Re-run the auditor until it reports `CLEAN`.

## 3. Approve one by one (gate)

Each spec item needs explicit human approval. Do not batch approvals.

For each item with status `pending` (AC, BR, NFR), in document order:

1. Show the item, the requirements it covers (with their source quote) and
   the screen it refers to.
2. Ask with `AskUserQuestion`: **Approve** / **Change** / **Reject**
   (options may carry a suggested rewording, never a new behaviour).
3. Approve → set the item's `Approval` to `approved` and add a row to the
   approval log (who, date). Change → apply the change, log the reason in
   `qa-log.md`, and ask again. Reject → remove the item, log why, and check
   whether a requirement is now uncovered.

You may ask up to 4 items in one `AskUserQuestion` call (one question per
item), but each item gets its own answer.

When every item is `approved` and section 9 is empty, set the spec status
to `approved` and phase 3 to `approved` in `README.md`.

## Rules

- Never mark an item approved without an explicit answer from the user.
- Never change an approved item silently. Any edit resets it to `pending`
  and needs a new approval.
- Next step: `/plan-tasks <slug>`.
