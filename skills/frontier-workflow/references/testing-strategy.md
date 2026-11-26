# Testing strategy

## Principles
- Test behaviour, not implementation details.
- A test you have not seen fail is a test you cannot trust: run it red first.
- Prefer many fast unit tests, a few integration tests, and very few end-to-end tests.
- Every bug fix gets a regression test.

## Red -> green -> refactor
1. Write the smallest failing test that expresses the behaviour. Run it; confirm it fails **for the right reason**.
2. Write the minimal code to pass.
3. Run it; confirm green.
4. Refactor with tests green. Commit.

## What to test
- Happy path, plus boundaries: empty, null/undefined, zero, max, duplicates, wrong types, malformed input.
- Failure modes: network error, timeout, permission denied, missing record.
- Business rules and anything involving money, auth, permissions or dates/timezones.

## If there is no test harness
Do not skip verification; downgrade it:
1. Add the lightest harness that fits the stack (Vitest for JS/TS, PHPUnit for PHP, or `node --test` / plain assert scripts if you must avoid dependencies).
2. Otherwise write a throwaway smoke script (`curl` calls, a Node script, or a PHP CLI script) and show its output.
3. For UI, write a short manual checklist and execute it. State clearly in the report that it was manual.
Ask before adding a new dev dependency if bandwidth is limited.

## Stack tools
| Stack | Tool |
|---|---|
| Vanilla JS / Node | Vitest or `node --test` |
| React / Next.js | Vitest + Testing Library; Playwright for critical flows |
| PHP | PHPUnit; `curl` smoke scripts for endpoints |
| Firebase | Emulator Suite; rules unit-testing library |

## Test quality checks
- Does each test fail if the feature is broken? (Try breaking the code on purpose.)
- Are tests independent and order-agnostic? No shared mutable state.
- Is the failure message clear enough to diagnose without a debugger?
- Mock only at the boundaries (network, clock, randomness); do not mock the code under test.
