# Documentation style guide

Applies to everything under `docs/` and is enforced by `/update-docs`.
TODO: adjust tone and structure to the team's preferences.

## Language and tone

- English, plain and direct. Short sentences, active voice, present tense
  ("The API returns 409", not "The API will return a 409 error").
- Write for a new team member who knows .NET but not this domain.
- No marketing language, no filler, no emojis.
- Use the glossary terms from the feature's `requirements.md`; define a
  term the first time it appears in a page.

## Structure

```
docs/
  STYLE.md                 This guide
  features/<slug>/         Process trail (requirements, Q&A, spec, tasks). Not living docs.
  product/<area>.md        What the system does, by functional area (living)
  api/<area>.md            Endpoints, contracts, errors (living)
  operations/              Configuration, deployment, runbooks (living)
  decisions/NNNN-title.md  Architecture decision records
```

TODO: confirm or adapt the areas above.

## Living pages

Every page outside `features/` starts with:

```markdown
---
sources: [features/<slug>/spec.md#AC-001, src/Path/To/Code.cs]
last-verified: YYYY-MM-DD
---
```

- `sources` lists the spec items and code paths the page describes, so
  `/update-docs --check` can tell when the page may be stale.
- `last-verified` is the date someone (human or AI) last checked the page
  against the code.

## Content rules

- Describe behaviour that exists in the code, not plans. Plans live in
  `features/`.
- Prefer one example over a paragraph: request/response pairs, screenshots
  of the approved prototype screens, tables of rules.
- Error behaviour is documented as a table: situation → status/message.
- Link to the spec item (`AC-xxx`) rather than repeating it word for word
  when the reader needs the full detail.
