# Self-review checklist

Go through `git diff` before reporting done. Be a skeptical reviewer of your own work.

**Correctness**
- Does it meet the plan's "done means"? Did you actually run it?
- Edge cases: empty input, null/undefined, large input, duplicate submits, offline or failed network, concurrent use.
- Off-by-one, timezone and encoding issues where relevant.

**Security** (see `security-checklist.md`)
- Input validated; output escaped; SQL parameterized.
- Authorization enforced on the server or in security rules, not just the UI.
- No secrets, keys or tokens in code, logs or commits (`scripts/secrets_scan.sh`).

**Errors and resilience**
- Failures are handled and surfaced usefully; nothing is silently swallowed.
- Loading, empty and error states exist in the UI.

**Scope and quality**
- Smallest reasonable diff; no unrelated changes or reformatting churn.
- Matches existing conventions; no dead code, stray `console.log`, `var_dump` or commented-out blocks.
- No new dependency unless justified.
- Names and comments make the intent clear to someone new.

**Tests**
- New behaviour has a test or a documented manual check.
- The bug fix has a regression test that failed before the fix.
- `scripts/verify.sh` passes (or you can say exactly why it was not run).

**Report**
- Be explicit about what was verified and what was not. List risks and follow-ups.
