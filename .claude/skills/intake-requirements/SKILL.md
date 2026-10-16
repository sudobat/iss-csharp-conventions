---
name: intake-requirements
description: Phase 1 of the feature flow. Turns stakeholder meeting minutes into cited requirements and runs the question-and-answer loop with the supervisor until nothing is left to assume. Use when a new feature starts, when new meeting minutes arrive for an existing feature, or when the user says "take the requirements".
argument-hint: <feature-slug> [path to minutes]
---

# Requirements intake

Feature: $ARGUMENTS

You turn what stakeholders said into requirements without inventing
anything. If it is not in a source or in an answer from the supervisor, it
is a question, not a requirement.

## 0. Set up the feature folder

- Folder: `docs/features/<slug>/`. If it does not exist, create it from the
  templates in this skill's `templates/` folder (`README.md`,
  `requirements.md`, `qa-log.md`) plus an empty `sources/` folder. Ask who
  the supervisor is and write the name in `README.md`.
- If it exists, read `README.md`, `requirements.md` and `qa-log.md` and
  continue from where it was left. New minutes for an existing feature
  reopen phase 1 (`reopened`).

## 1. Collect the inputs (always ask, never assume)

Ask the user for each of these. Do not continue without the first one.

1. **Meeting minutes or transcript** of the stakeholder meeting(s): a file
   path or pasted text. Save each one verbatim to
   `sources/<YYYY-MM-DD>-<short-name>.md`. Do not summarise or clean it up:
   citations point at its lines.
2. **Design system**, if one exists: link (claude.ai Design project, Figma,
   Storybook) or path in the repo. Record it in `README.md`. "None" is a
   valid answer; record that too.
3. Any other material: previous specs, emails, tickets, screenshots. Save
   them to `sources/` as well.

Read `CLAUDE.md` and `ARCHITECTURE.md`, and skim the code areas the
minutes mention, only to understand vocabulary and what already exists.
Existing code never becomes a requirement by itself; if it suggests
something, ask.

## 2. Extract requirements

Fill `requirements.md`:

- One row per requirement, atomic (one behaviour or rule per row).
- `Source` is mandatory: `sources/<file>#L<n>` (line range allowed) or
  `Q-xxx`. No source, no row.
- `confirmed` only when the source states it explicitly. Your
  interpretation of something implicit is `to-confirm` and gets a question.
- Record what stakeholders explicitly excluded as `out-of-scope`.
- Add domain terms to the glossary with their source.

## 3. Find what is missing

Go through this checklist for the whole feature and log a question for each
gap. These are the usual holes in meeting minutes:

- Actors and permissions: who can do what; what others see.
- Data: fields, formats, mandatory/optional, limits, uniqueness, where it
  comes from, retention.
- Business rules and calculations, with a worked example.
- Error and edge cases: invalid input, duplicates, concurrency, missing
  external systems, empty states.
- UI states: empty, loading, error, partial, permissions denied.
- Integrations: which systems, who owns them, contracts, failure handling.
- Non-functional: volumes, response times, availability, audit, privacy,
  accessibility, languages.
- Scope edges: what is explicitly not included in this iteration.
- Vague words in the minutes: "fast", "simple", "etc.", "and so on",
  "similar to", "should probably", "the usual". Each needs a concrete value.
- Contradictions between sources or between a source and existing code.

## 4. Question-and-answer loop

This is how the back-and-forth stays useful instead of getting lost in chat:

1. Write every question to `qa-log.md` **before** asking it (status `open`),
   with *why it matters* (which requirement or decision depends on it).
2. Ask with `AskUserQuestion`, at most 4 per round, most blocking first.
   When the sources suggest likely answers, offer them as options and cite
   them in the description. Never pre-select an answer you made up.
3. Record each answer immediately: answer text, who answered, date, status
   `answered`. Then update the affected `R-xxx` rows (cite `Q-xxx`, flip to
   `confirmed`) or add new requirements the answer introduces.
4. If the supervisor does not know, mark it `pending-stakeholder`. Do not
   guess a default. Continue with the other questions.
5. Repeat: new answers often open new questions.

## 5. Confirm understanding (gate)

When no `open` questions remain:

1. Play back your understanding in plain language: the problem, actors,
   main flows, key rules, what is out of scope. Keep it under one screen and
   cite IDs.
2. List every `to-confirm` requirement and every `pending-stakeholder`
   question. Pending questions block the spec items they affect; say which.
3. Ask the supervisor explicitly: "Is this understanding complete and
   correct?" Only an explicit yes closes the phase.
4. On yes, set phase 1 to `approved` in `README.md` with the supervisor's
   name and the date. On no, go back to step 4 with what they corrected.

If questions are `pending-stakeholder`, also write them as a short list the
user can take to the next meeting (and offer to show it).

## Rules

- Never fill a gap with a "reasonable default". Ask.
- Never edit a source file after saving it.
- Never delete or rewrite rows in `qa-log.md`; supersede them.
- Next step: `/prototype <slug>` if the feature has UI, otherwise
  `/write-spec <slug>`.
