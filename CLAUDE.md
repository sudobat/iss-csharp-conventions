# CLAUDE.md

<!--
  ISS C# template. Fill in the TODO sections for this project and delete
  this comment. Keep the file short: Claude loads it on every session.
-->

## Project

TODO: one paragraph — what this service/app does and who uses it.

## Architecture

Read @ARCHITECTURE.md before making structural changes (new projects, layers,
dependencies, cross-cutting concerns).

## Commands

```bash
dotnet restore
dotnet build
dotnet test
dotnet format
```

TODO: add project-specific commands (run the app, run a single test project,
apply migrations, docker compose, etc.). Include how to run the end-to-end
tests: the API e2e project and the Playwright UI project (browser install:
`pwsh <UiTests>/bin/Debug/<tfm>/playwright.ps1 install`).

## Conventions

TODO: coding conventions specific to this project.

## Workflow

- Build and test before declaring a task done. A Stop hook runs `dotnet build`
  and blocks if it fails.
- `.cs` files are auto-formatted after each edit (`.editorconfig` applies).
- Generated code (`bin/`, `obj/`, `*.Designer.cs`, `*.g.cs`, EF migration
  snapshots) is protected from edits; regenerate it with the proper tool instead.
- New features follow the feature flow in `docs/features/README.md`:
  `/intake-requirements` → `/prototype` (UI only) → `/write-spec` →
  `/plan-tasks` → `/tdd-task` (RED → GREEN → REFACTOR) → `/update-docs`.
  `/feature-flow <slug>` shows status and the next step. Every phase ends in
  a human gate; never skip one or mark it approved without an explicit yes.
- Never invent requirements, values or behaviour. If it is not in a source
  or in an answer recorded in `qa-log.md`, ask.
- Small changes outside a feature: `/implement-feature`.
- Docs live in `docs/` and follow `docs/STYLE.md`; update them in the same
  change as the code.
- Skills available: `/feature-flow`, `/intake-requirements`, `/prototype`,
  `/write-spec`, `/plan-tasks`, `/tdd-task`, `/update-docs`,
  `/implement-feature`, `/write-tests`, `/fix-build`, `/ef-migration`.
- Agents available: `spec-auditor`, `e2e-test-writer`, `implementer`,
  `refactorer`, `csharp-reviewer`, `test-writer`, `architecture-guardian`.
