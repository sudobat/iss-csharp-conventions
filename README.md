# ISS C# — Claude Code template

Base artefacts for working on ISS C#/.NET projects with Claude Code.
Copy them into a project's repository root and fill in the project-specific
parts.

## Contents

```
CLAUDE.md                     Project memory, loaded every session (imports ARCHITECTURE.md)
ARCHITECTURE.md               Architecture rules; enforced by architecture-guardian
docs/
  STYLE.md                    Documentation style guide (tone, structure, front matter)
  features/README.md          The feature flow: phases, gates, artefacts, IDs
.gitignore                    Ignores personal Claude Code overrides (merge into yours)
.claude/
  settings.json               Shared permissions + hooks
  hooks/
    _lib.sh                   JSON helpers (jq if present, sed fallback)
    protect-generated.sh      PreToolUse: blocks edits to bin/obj, *.Designer.cs, *.g.cs,
                              EF snapshots, .env, keys, lock files
    format-cs.sh              PostToolUse: dotnet format whitespace on the edited .cs file
    build-on-stop.sh          Stop: dotnet build if C# changed; blocks on errors
    protect-red-tests.sh      PreToolUse: blocks edits to RED tests locked by /tdd-task
  agents/
    csharp-reviewer.md        Reviews diffs for bugs, async, DI, EF, security
    test-writer.md            Writes tests with the solution's existing framework
    architecture-guardian.md  Checks changes against ARCHITECTURE.md
    spec-auditor.md           Flags invented, untraced, vague or uncovered spec content
    e2e-test-writer.md        RED: failing API (WebApplicationFactory) / UI (Playwright) tests
    implementer.md            GREEN: minimal code to pass locked tests
    refactorer.md             REFACTOR: align new code with house conventions
  skills/
    feature-flow/             /feature-flow — status board and next step of a feature
    intake-requirements/      /intake-requirements — minutes → cited requirements + Q&A loop
    prototype/                /prototype — visual prototype with the design system
    write-spec/               /write-spec — testable spec, audited, approved item by item
    plan-tasks/               /plan-tasks — spec → estimated vertical-slice tasks
    tdd-task/                 /tdd-task — RED → GREEN → REFACTOR → docs for one task
    update-docs/              /update-docs — keep docs/ in sync with code (or --check)
    implement-feature/        /implement-feature — explore → plan → test → implement → verify → review
    write-tests/              /write-tests
    fix-build/                /fix-build
    ef-migration/             /ef-migration — generate, review and script EF Core migrations
```

## Adopting in a project

1. Copy `CLAUDE.md`, `ARCHITECTURE.md` and `.claude/` to the repo root.
   Merge `.gitignore` entries into the project's `.gitignore`.
2. Fill in the TODO sections of `CLAUDE.md` and `ARCHITECTURE.md`.
3. If the repo root has more than one `.sln`/`.slnx`, or the solution lives
   in a subfolder, set the build target in `.claude/settings.json`:

   ```json
   "env": { "ISS_BUILD_TARGET": "src/MySolution.sln" }
   ```

4. Fill in the TODOs of `docs/STYLE.md`.
5. Commit everything except `.claude/settings.local.json` and `.claude/state/`.

## Feature flow

```
minutes ─► /intake-requirements ─► /prototype ─► /write-spec ─► /plan-tasks ─► /tdd-task × N
           R-xxx + Q&A log          S-xx (UI)     AC-xxx         T-xxx          RED → GREEN → REFACTOR → docs
           gate: supervisor         gate: stake-  gate: each     gate: task     gate: tests approved
           confirms understanding   holder        item approved  list approved  before coding
```

Details in `docs/features/README.md`. Start with `/feature-flow`.

## Requirements

- .NET SDK (`dotnet format` ships with the SDK since .NET 6).
- Bash: native on Linux/macOS; on Windows, Git for Windows (Claude Code uses
  Git Bash to run hooks).
- `jq` optional; hooks fall back to `sed` parsing without it.
- `dotnet-ef` only for the `ef-migration` skill.

## Customising

- **Disable the build-on-stop hook** for a session or machine: set
  `ISS_SKIP_BUILD_ON_STOP=1` (e.g. in `.claude/settings.local.json` `env`).
- **Personal overrides** go in `.claude/settings.local.json` and
  `CLAUDE.local.md` (both git-ignored).
- **Project-specific skills/agents**: add them next to the base ones. Keep
  base files unchanged where possible so template updates are easy to merge.
