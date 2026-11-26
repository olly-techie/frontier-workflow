# Refactoring safely

Refactoring changes structure without changing behaviour. If behaviour changes, it is not a refactor.

1. **Have a safety net.** Make sure tests cover the area. If not, write characterization tests that pin down current behaviour first.
2. **Separate concerns.** Never mix a refactor and a feature or bug fix in the same commit.
3. **Tiny steps.** Rename, extract, inline, move: one at a time; run tests after each; commit when green.
4. **Keep the public surface stable** (function signatures, routes, exported names, DB columns) unless the task is to change it. If it must change, update every caller in the same change.
5. **Find all usages** with search before renaming or deleting (include strings, config, docs, and dynamic usages).
6. **Stop at the goal.** Note extra cleanup opportunities as follow-ups instead of doing them.

## Common safe moves
- Extract function / module when a block has a clear name and single purpose.
- Replace magic values with named constants.
- Flatten nesting with early returns.
- Remove duplication only when the copies are truly the same concept (three similar lines are fine).
- Delete dead code you have proven unreachable.

## Red flags
- Diff touches many unrelated files.
- Tests had to be changed to pass (ask: did behaviour change?).
- You are "improving" code the task did not mention.
