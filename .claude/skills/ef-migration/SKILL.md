---
name: ef-migration
description: Create, review and script an Entity Framework Core migration after model changes. Use when entities, DbContext configuration or the database schema change. Only applies to projects that use EF Core.
argument-hint: <MigrationName> [description of the schema change]
---

# EF Core migration

Migration: $ARGUMENTS

## 0. Preconditions

- Confirm the solution uses EF Core (`Microsoft.EntityFrameworkCore.*`
  package). If not, stop and tell the user.
- Check the tool is available: `dotnet ef --version`. If missing, ask the
  user to install it (`dotnet tool restore` if a tool manifest exists,
  otherwise `dotnet tool install --global dotnet-ef`).
- Identify the migrations project (where `Migrations/` lives) and the
  startup project (the host). Check `CLAUDE.md`/`ARCHITECTURE.md` first;
  otherwise find them in the solution. With several `DbContext`s, ask which.

## 1. Model change

Apply the entity/configuration changes, then `dotnet build`.

## 2. Generate

```bash
dotnet ef migrations add <MigrationName> \
  --project <MigrationsProject> --startup-project <StartupProject> \
  [--context <DbContext>]
```

Never write or edit migration files or the `*ModelSnapshot.cs` by hand
(the protect-generated hook blocks snapshot edits). To redo a migration
that has not been applied anywhere, ask the user before running
`dotnet ef migrations remove`.

## 3. Review the generated migration

Read the new migration and flag:

- `DropColumn`/`DropTable`/`RenameColumn` emitted as drop + add (data loss).
- Non-nullable columns added to existing tables without a default.
- Column type or length reductions (truncation).
- Missing indexes on new foreign keys or frequently filtered columns.
- Large-table operations that may lock (index creation, type changes).

Report the risks to the user with suggested mitigations (e.g. a data
migration step, `defaultValue`, splitting into several migrations).

## 4. Script

Produce an idempotent SQL script for review:

```bash
dotnet ef migrations script --idempotent \
  --project <MigrationsProject> --startup-project <StartupProject> \
  -o artifacts/migrations/<MigrationName>.sql
```

## 5. Apply (only on request)

`dotnet ef database update` requires explicit user approval and only against
a local/dev database. Never apply to shared environments.
