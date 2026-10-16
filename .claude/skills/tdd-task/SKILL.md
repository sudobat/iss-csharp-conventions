---
name: tdd-task
description: Phases 5–7 of the feature flow for one task. RED - end-to-end tests (API and/or UI) written from the task's acceptance criteria and approved by a human; GREEN - minimal code to make them pass without touching the tests; REFACTOR - align with house conventions, review, and update the docs. Use after /plan-tasks is approved, one task at a time.
argument-hint: <feature-slug> [T-id | next]
---

# Implement one task with TDD

Feature and task: $ARGUMENTS (no task or `next` = the first `todo` task
whose dependencies are `done`).

## 0. Preconditions

- `docs/features/<slug>/README.md`: phase 4 `approved`.
- The task's dependencies in `tasks.md` are `done`.
- No other task is in progress: `.claude/state/tdd-lock` must not exist. If
  it does, ask whether to resume that task or abandon it (abandoning removes
  the lock).
- Read the task section in `tasks.md`, the spec items it covers in
  `spec.md`, the screens in `prototype.md`, and the template feature.

Set phase 5–7 to `in-progress` in `README.md` if it is the first task.

## 1. RED — end-to-end tests

Launch the `e2e-test-writer` agent with: feature folder, task ID, the exact
text of the covered `AC`/`BR`/`NFR` items and the referenced screens.

When it returns:

1. Run the reported test command yourself. Every new test must **fail for
   the right reason**: a missing endpoint (404), a wrong response, a missing
   UI element, a failed assertion. Not acceptable: compile errors,
   infrastructure errors (container or browser did not start), tests that
   pass already. Send it back to the agent if so.
2. Check every covered criterion has at least one test, and that each test
   is tagged with its criterion ID.
3. **Human gate.** Show a table `criterion → test name → why it fails now`,
   and the test files. Ask the user to approve the tests as the executable
   spec. Changes → back to the agent.
4. On approval, lock the tests:

   ```bash
   mkdir -p .claude/state
   sha256sum <test files…> > .claude/state/tdd-lock
   ```

   The `protect-red-tests` hook now blocks edits to those files. Record the
   test files under "RED tests" in the task section and set the task
   `Status` to `red`.

## 2. GREEN — make them pass

Launch the `implementer` agent with: the task, the covered criteria, the
locked test files and the command to run them, the template feature.

When it returns:

1. `sha256sum -c .claude/state/tdd-lock` must pass. If a locked test
   changed, revert that change and send the work back.
2. `dotnet build` and the task's tests pass. Then the full `dotnet test`:
   no previously passing test may fail.
3. Set the task `Status` to `green`.

If the implementer reports that a test is wrong or contradicts the spec,
stop and ask the user. Fixing a test means unlocking it explicitly (remove
its line from `.claude/state/tdd-lock`), changing it, getting the user's
approval again, and re-locking.

## 3. REFACTOR — house standards

1. Launch the `refactorer` agent on the files changed by this task.
2. Then run `csharp-reviewer` and `architecture-guardian` in parallel on the
   task's diff. Fix every `critical`/`major` finding (yourself or by sending
   it back to `refactorer`); list `minor` ones for the user.
3. Re-verify: `sha256sum -c .claude/state/tdd-lock`, `dotnet build`, full
   `dotnet test`.

## 4. Docs and close

1. Run `/update-docs <slug> <T-id>`.
2. Remove `.claude/state/tdd-lock`.
3. Set the task `Status` to `done`. If it was the last task, set phase
   5–7 to `approved` only after the user confirms the feature is complete.
4. Report: criteria covered, test files, production files changed, review
   verdicts, test results (commands and counts), docs updated, minor
   findings left. Suggest a commit message; commit only if the user asks.

Next step: `/tdd-task <slug> next`.
