---
name: implement-feature
description: End-to-end workflow for implementing a feature or behaviour change in a C#/.NET solution - explore, plan, test, implement, verify, review. Use when the user asks to build, add or change functionality.
argument-hint: <feature description or ticket>
---

# Implement a feature

Feature: $ARGUMENTS

## 1. Understand

- Read `CLAUDE.md` and `ARCHITECTURE.md`.
- Locate the code involved (entry points, domain types, persistence, tests).
  Find an existing feature with a similar shape and use it as the template.
- If acceptance criteria are ambiguous, ask the user before writing code.

## 2. Plan

- List the files to create/change, per project/layer.
- For structural changes (new project, new package, new layer dependency),
  run the `architecture-guardian` agent on the plan first.
- Share the plan with the user when the change touches more than a few files.

## 3. Test first

- Use the `write-tests` skill (or `test-writer` agent) to add tests that
  describe the new behaviour. Confirm they fail for the right reason.

## 4. Implement

- Follow the patterns of the template feature found in step 1.
- Keep the change minimal; no unrelated refactors.
- Propagate `CancellationToken` through async call chains.
- Generated artefacts (migrations, clients) are produced with their tools,
  never written by hand. For schema changes use the `ef-migration` skill.

## 5. Verify

```bash
dotnet build
dotnet test
```

If the build fails, use the `fix-build` skill. All tests must pass;
report any pre-existing failures separately instead of hiding them.

## 6. Review

- Run the `csharp-reviewer` agent on the diff and address critical/major
  findings.
- Run the `architecture-guardian` agent if the change added projects,
  references or packages.

## 7. Report

Summarise what changed (files), how it was verified (commands and results),
and any open questions or follow-ups.
