# Security checklist

Apply to any code touching input, auth, data, files or third-party services.

## Secrets
- Never hardcode secrets, tokens, keys or passwords. Use environment variables or a secret manager.
- `.env` must be in `.gitignore`; commit only `.env.example` with placeholder values.
- Never print secret values in logs, errors or your own output.
- If a secret was committed, treat it as compromised: rotate it. Removing it from history is not enough.
- Never put server-only secrets in client bundles (`NEXT_PUBLIC_*`, front-end JS, Firebase client config for admin credentials).

## Input and output
- Treat all external input as hostile: query params, bodies, headers, cookies, uploaded files, webhooks.
- Validate on the server (type, length, range, allow-list). Client-side checks are only UX.
- SQL: parameterized queries / prepared statements only.
- HTML: escape output; avoid `innerHTML` with dynamic data; use `textContent`.
- Files: validate size and type server-side, generate your own filenames, store outside the web root where possible.

## Authentication and authorization
- Hash passwords with a slow hash (`password_hash` in PHP, bcrypt/argon2 elsewhere).
- Check authorization on every request on the server (or in Firebase security rules), not only in the UI.
- Use CSRF protection for cookie-based sessions; set `HttpOnly`, `Secure`, `SameSite` on cookies.
- Rate-limit login, reset and other abusable endpoints.
- Avoid user enumeration in login and reset responses.

## Data and dependencies
- Collect and log the minimum personal data needed.
- Prefer well-maintained packages; pin versions; question any new dependency.
- Use HTTPS everywhere; set sensible CORS (no `*` with credentials).

## Firebase specifics
- Default-deny security rules; allow only what each role needs.
- Test rules with the Emulator Suite, including the "should be denied" cases.
- Server-side admin SDK keys never go to the client.
