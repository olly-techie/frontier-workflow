# Stack notes

Read the section that matches the code you are touching.

## Vanilla JavaScript
- Use ES modules; avoid globals. Prefer `const` and small pure functions.
- `async/await` with `try/catch`. With `fetch`, always check `response.ok` before parsing.
- Never put user data into `innerHTML`. Use `textContent` or build nodes.
- Use event delegation for dynamic lists. Clean up listeners and timers you create.
- Handle loading, empty and error states in every UI that fetches data.
- Debounce input handlers that hit the network; disable submit buttons while a request is in flight.
- Accessibility basics: labels on inputs, keyboard focus, sufficient contrast, semantic elements.
- Test: Vitest (or `node --test`) for logic; a manual checklist for UI.

## PHP
- `declare(strict_types=1);` at the top of new files.
- Database: PDO with prepared statements, always. Never concatenate user input into SQL.
- Passwords: `password_hash` / `password_verify`. Never store or log plaintext.
- Output: escape with `htmlspecialchars` when rendering HTML. Return JSON with the right `Content-Type` and HTTP status codes.
- Forms and sessions: CSRF tokens on state-changing requests; `session_regenerate_id(true)` on login.
- File uploads: validate size and type server-side; never trust the client MIME type or filename.
- Production: log errors, do not display them. Keep config and credentials out of the web root.
- Test: PHPUnit for logic; `curl` smoke scripts for endpoints; `php -l` for syntax.

## Firebase
- **Security rules are the real authorization.** Client-side checks are only UX. Write rules for every collection and test them with the Emulator Suite before deploying.
- Use the modular SDK (v9+) imports to keep bundles small.
- Never ship admin credentials or service-account keys to the client. The web config object is public, which is exactly why rules must be tight.
- Control reads and cost: use `limit`, paginate, unsubscribe listeners on teardown, avoid listening to whole collections.
- Use transactions or batched writes when several documents must change together.
- Plan composite indexes early; the console error usually links to the exact one needed.
- Wait for auth state before reading protected data.
- Test: Firebase Emulator Suite plus the rules unit-testing library.

## React / Next.js
- Default to server components; add `'use client'` only where state, effects or browser APIs are needed.
- Fetch data on the server where possible. Always render loading and error states.
- Only variables prefixed `NEXT_PUBLIC_` reach the browser, so never put secrets in them.
- Validate input in route handlers (for example with `zod`) and return proper status codes.
- Avoid `useEffect` for derived state; compute it during render. Use stable keys in lists.
- Mind caching: know whether a fetch or route is static or dynamic before debugging "stale" data.
- Test: Vitest + Testing Library for components; Playwright for the critical user flow.

## General
- Prefer boring, well-known patterns over clever ones.
- Keep functions small and names honest. Comment the why, not the what.
- If a task needs a new dependency, justify it in one sentence and prefer small, maintained packages.
