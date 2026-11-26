# Planning

A plan is a cheap way to find out you are wrong before you have written code. Keep it short.

## What a good plan contains
1. **Goal**: one sentence in terms of user-visible behaviour.
2. **Constraints**: stack, existing patterns, performance, compatibility, "do not touch" areas.
3. **Files to touch**: each with a one-line reason.
4. **Steps**: ordered, each independently verifiable ("add route, curl returns 200" not "implement backend").
5. **Risks and unknowns**: what you have not verified yet and how you will find out.
6. **Done means**: the concrete command or interaction that proves it works.

## Heuristics
- If you cannot write the "done means" line, you do not understand the task yet. Ask or investigate.
- Put the riskiest or most uncertain step first (spike it) so surprises come early.
- Prefer a vertical slice (UI -> API -> data, thin but working) over finishing one layer completely.
- Split anything that needs more than about 30-60 minutes of work into separate verifiable steps.
- Note what is deliberately out of scope so it does not creep in.

## When to ask versus assume
Ask when the answer changes the design or is expensive to reverse (data model, public API, auth, deleting data).
Assume and state it when it is cheap to change later (naming, copy, minor UI choices).

## Example (small feature)
```
Goal: users can reset their password by email.
Files: api/reset-request.php (new), api/reset-confirm.php (new), db/migrations/004_reset_tokens.sql (new), login.html (link).
Steps:
 1. Migration + table; verify with SELECT.
 2. reset-request: generate token (random_bytes), store hash + expiry, send mail; curl returns 200 for any email (no user enumeration).
 3. reset-confirm: validate token + expiry, set new password_hash, invalidate token; test expired and reused token.
 4. Login link + minimal form; manual run-through.
Risks: mail delivery on host unknown -> test with a log mailer first.
Done means: full reset flow works end to end, expired/reused tokens are rejected, tests pass.
```
