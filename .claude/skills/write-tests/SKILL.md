---
name: write-tests
description: Add or extend unit/integration tests for C# code using the solution's existing test framework and conventions. Use when the user asks for tests, when new behaviour lacks coverage, or to reproduce a bug with a failing test.
argument-hint: <class, method, file or bug description>
---

# Write tests

Target: $ARGUMENTS

Delegate to the `test-writer` agent with:

- the target above,
- whether this is new coverage or a bug reproduction (a reproduction must
  fail before the fix),
- any constraints from the user (e.g. "integration tests only").

When the agent returns:

1. Re-run the reported `dotnet test` command yourself and confirm the result.
2. Skim the new tests: each one must assert real behaviour. Reject tests that
   only check "does not throw" unless that is the behaviour under test.
3. Report the files changed, the scenarios covered and the test result.
