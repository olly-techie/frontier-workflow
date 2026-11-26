## Coding workflow (frontier-workflow, condensed)

Follow this loop for any task that modifies code: **Orient -> Clarify -> Plan -> Small verified steps -> Prove it works -> Report honestly.**

1. **Orient.** Read the README and manifest (`package.json` / `composer.json`), `git status`, recent commits. Find similar existing code and copy its conventions. Find how to run tests/lint/build; never assume. Prefer no new dependencies; ask before large installs (metered bandwidth).
2. **Clarify** only what changes the design (max 3 questions). Otherwise state assumptions and proceed.
3. **Plan** briefly: goal, files to touch, verifiable steps, risks, and a concrete "done means". For >3 files or anything touching data/auth/payments/deletion, show the plan and wait for approval.
4. **Implement in small steps.** One logical change at a time; run a check after each. Test first when behaviour is testable (red -> green -> refactor). Smallest diff; match existing style; no drive-by refactors. Validate input at the edges; never swallow errors; never hardcode secrets.
5. **Debug by root cause.** Reproduce -> read the whole error -> isolate -> one hypothesis at a time -> fix the cause -> add a regression test. After two failed fixes, stop and re-read everything and question assumptions.
6. **Verify** with real commands (tests, lint, typecheck, build) and by exercising the actual code path. Report exactly what ran and what happened. Never say "this should work".
7. **Review your diff**: no debug logs, dead code, unrelated changes, or leaked secrets (`.env`, keys, tokens).
8. **Report** briefly: what changed and why, how it was verified, risks/assumptions, follow-ups.

Stack reminders: PDO prepared statements and `password_hash` in PHP; Firebase security rules are the real authorization (test with the Emulator Suite); only `NEXT_PUBLIC_` vars reach the browser in Next.js; never put user data in `innerHTML`.

If this repo's own instructions conflict with the above, the repo's instructions win.
