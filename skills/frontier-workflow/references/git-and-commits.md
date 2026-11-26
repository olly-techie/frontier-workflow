# Git, commits and PRs

## Before starting
- `git status` and `git log --oneline -n 10`. Know the branch and whether the tree is clean.
- Do not work directly on `main` for non-trivial changes; use a short-lived branch (`feat/...`, `fix/...`).
- Do not discard or overwrite the user's uncommitted work. If the tree is dirty with unrelated changes, say so.

## Commits
- Small, logical, working commits; each should build and pass tests.
- Message format (Conventional Commits style):
  `type(scope): imperative summary` e.g. `fix(auth): reject expired reset tokens`
  Types: feat, fix, refactor, test, docs, chore, perf.
- Body (optional): why the change was needed, not a restatement of the diff.
- Never commit secrets, `.env`, build output, `node_modules`, or large binaries.
- Run `scripts/secrets_scan.sh` and `scripts/verify.sh` before committing.

## Safety rules
- No `git push --force`, `reset --hard`, `clean -fd`, or history rewriting without explicit user approval.
- Do not commit, push or open PRs unless asked, or unless the project's instructions say to.
- Never skip hooks (`--no-verify`) to get past a failing check; fix the cause.

## Pull request description
```
## What
One or two sentences.

## Why
The problem or user need.

## How verified
Commands run and results; manual steps if any.

## Risks / notes
Migrations, config changes, follow-ups.
```
