---
name: fix-build
description: Diagnose and fix C#/.NET build errors (and optionally warnings) until `dotnet build` succeeds. Use when a build fails, after the build-on-stop hook blocks, or when the user asks to fix compilation errors.
argument-hint: [solution or project path] [--warnings]
---

# Fix the build

Target: $ARGUMENTS (default: the solution at the repo root)

## Loop

1. Build and capture only diagnostics:

   ```bash
   dotnet build <target> -nologo -v q -clp:ErrorsOnly
   ```

   With `--warnings`, use `-clp:Summary` and also treat warnings in
   changed files as work items.

2. Group errors by root cause, not by line. Fix the earliest cause first:
   a missing type or `using` often produces dozens of follow-on errors.
   - `NU*` errors → package restore/version problem: run `dotnet restore`,
     check `PackageReference` versions and central package management
     (`Directory.Packages.props`).
   - `CS0246`/`CS0234` → missing `using`, `ProjectReference` or package.
     Before adding a reference, check `ARCHITECTURE.md` allows it.
   - `CS8600`–`CS8629` (nullability) → fix the null flow; do not silence
     with `!` or `#nullable disable` unless the value is provably non-null.
3. Rebuild. Repeat until clean. Stop and ask the user if the same error
   survives three attempts or the fix requires a design decision.

## Rules

- Never delete code, tests or files just to make the build pass.
- Never add `<NoWarn>`, `#pragma warning disable` or `TreatWarningsAsErrors=false`
  without the user's agreement.
- After a clean build, run `dotnet test` for the affected projects.

Report the root causes found, the fixes applied and the final build result.
