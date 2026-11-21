# Debugging playbook

Debugging is hypothesis testing, not guessing. The loop:

## 1. Reproduce
- Get a reliable, minimal reproduction (exact steps, input, environment).
- If it is intermittent, find what varies: timing, data, ordering, environment, caching.
- If you cannot reproduce it, say so, and add logging or instrumentation instead of speculating.

## 2. Read the evidence
- Read the **entire** error message and stack trace, top to bottom. Note file and line of your own code in the trace.
- Check the browser console, network tab, server logs, and the actual response body, not just the status code.
- Look at what changed recently: `git log -p`, `git diff`, `git bisect` for regressions.

## 3. Isolate
- Bisect the system: which layer (UI, network, server, database) first has the wrong value?
- Bisect the code: disable or stub parts until the bug disappears.
- Reduce the input until it is the smallest case that still fails.

## 4. Hypothesize and test
- Write the hypothesis down: "I think X because Y; if true, then Z should happen."
- Test it with a log, assertion, breakpoint or a tiny script. One variable at a time.
- If the hypothesis is wrong, that is progress. Record what it rules out.

## 5. Fix
- Fix the **cause**, not the symptom (no blanket try/catch, no `setTimeout` band-aids, no "retry until it works").
- Keep the fix minimal. Add a regression test that fails before the fix and passes after.
- Ask: where else could the same mistake exist? Search for similar patterns.

## 6. Know when to stop and reset
After **two** failed fixes in a row:
1. Stop editing.
2. Re-read the error and the relevant code from scratch.
3. List your assumptions and verify each one with evidence (print the actual values).
4. Check the boring causes: wrong file edited, stale build or cache, wrong environment, env var missing, dependency version mismatch, typo.

## Common culprits by stack
- **JS**: `undefined` from async code not awaited; stale closures; mutating shared state; CORS; wrong `this`.
- **PHP**: undefined index/variable notices hidden by config; output before headers; session not started; relative include paths; character encoding.
- **Firebase**: security rules denying (check the exact rule in the Rules Playground / emulator); missing composite index; listener never unsubscribed; reading before auth state resolves.
- **Next.js/React**: server vs client component mix-ups; hydration mismatch; env var missing `NEXT_PUBLIC_`; effect dependency arrays; cached fetch results.
