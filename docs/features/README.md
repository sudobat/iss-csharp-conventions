# Features

One folder per feature, created by `/intake-requirements`. Each folder is the
full paper trail from stakeholder meeting to merged code.

```
docs/features/<slug>/
  README.md          Status and phase gates (who approved what, when)
  sources/           Raw inputs, verbatim: meeting minutes, transcripts, emails
  requirements.md    R-xxx: requirements extracted from sources, each with a citation
  qa-log.md          Q-xxx: every question asked and its answer (append-only)
  prototype.md       S-xx: prototype screens and link (UI features only)
  spec.md            AC-xxx: approved specification
  tasks.md           T-xxx: implementation tasks and their TDD status
```

## Flow

| # | Phase | Command | Gate (human) |
|---|-------|---------|--------------|
| 1 | Requirements intake + Q&A | `/intake-requirements <slug>` | Supervisor confirms understanding is complete |
| 2 | Visual prototype (UI only) | `/prototype <slug>` | Stakeholder approves prototype |
| 3 | Specification | `/write-spec <slug>` | Each spec item approved one by one |
| 4 | Tasks | `/plan-tasks <slug>` | Task list and estimates approved |
| 5 | RED: end-to-end tests | `/tdd-task <slug> <T-id>` | Tests approved as the executable spec |
| 6 | GREEN: implementation | (same command) | Automatic: tests pass, tests untouched |
| 7 | REFACTOR + docs | (same command) | Review findings resolved, docs updated |

`/feature-flow <slug>` shows where a feature is and what comes next.

## Identifiers and traceability

- `R-001` requirement → cites `sources/<file>#L<n>` or `Q-xxx`.
- `Q-001` question → answered by a named person, dated.
- `S-01` prototype screen.
- `AC-001` acceptance criterion → references `R-xxx` (and `S-xx` for UI).
- `T-001` task → covers `AC-xxx`.
- Tests name the `AC-xxx` they verify (trait/category or test name).

Nothing enters `requirements.md` or `spec.md` without a citation. Anything
the AI cannot cite becomes a question in `qa-log.md`.
