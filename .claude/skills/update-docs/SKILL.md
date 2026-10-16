---
name: update-docs
description: Updates the living documentation under docs/ so it matches the code after a task or feature, following docs/STYLE.md, or checks the docs for drift. Use at the end of every /tdd-task, after any behaviour change, or with --check to find stale pages.
argument-hint: <feature-slug> [T-id] | --check
---

# Update the documentation

Target: $ARGUMENTS

The repo is the source of truth. Docs are updated in the same change as the
code they describe, so they cannot fall behind.

## Update mode (`<slug> [T-id]`)

1. Read `docs/STYLE.md`. If it is missing, stop and ask the user to create
   it (a template ships with this repo).
2. Collect what changed: the covered spec items (`spec.md`, task section in
   `tasks.md`) and the code diff of the task (`git diff`, plus untracked
   files from `git status`).
3. Find the pages affected: search `docs/` (outside `features/`) for
   `sources:` entries matching the changed code paths or spec items, and
   for the functional area by name.
4. Update those pages, or create a page in the area `STYLE.md` defines if
   none covers the behaviour. Describe what the code does now, verified
   against the code, not what the spec hoped for. If they differ, stop and
   report the difference.
5. Update each touched page's `sources` and `last-verified` (today).
6. If the task made an architectural decision (new pattern, dependency,
   cross-cutting concern), propose an ADR in `docs/decisions/` and the
   matching change to `ARCHITECTURE.md`; ask before writing them.

Report the pages created/updated and one line on what changed in each.

## Check mode (`--check`)

Read-only. For every living page:

- `sources` code paths that no longer exist → `broken`.
- Code paths changed after `last-verified`
  (`git log -1 --format=%cs -- <path>`) → `possibly stale`.
- Spec items in `sources` whose approval was reset or changed after
  `last-verified` → `possibly stale`.
- Pages without front matter → `untracked`.

Output one line per page: `docs/<page> — <status> — <reason>`, then a
total. Offer to run update mode for the stale ones.
