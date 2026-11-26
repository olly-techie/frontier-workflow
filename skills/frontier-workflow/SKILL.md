---
name: frontier-workflow
description: A disciplined end-to-end workflow for coding agents that mirrors how frontier models approach software tasks - orient in the repo, clarify, plan, implement in small verified steps, debug by root cause, verify with real commands, self-review the diff, and report honestly. Use this skill whenever the user asks to build a feature, fix a bug, refactor, add an endpoint or page, wire up Firebase, write tests, or change any code in a project, even for small changes. Especially relevant for vanilla JavaScript, PHP, Firebase, React and Next.js projects. Trigger on build, implement, fix, debug, refactor, add a feature, "why is this failing", "make this work", or any request that will modify code.
license: MIT
metadata:
  version: "1.0.0"
---

# Frontier coding workflow

Core loop: **Orient -> Clarify -> Plan -> Small verified steps -> Prove it works -> Report honestly.**

This is not ceremony. It targets the failure modes that waste the most time: coding before understanding, big unverifiable changes, guessing at bugs, and claiming "done" without evidence.

Paths below are relative to this skill's directory.

## 0. Scale the process to the task

| Task size | What to do |
|---|---|
| Trivial (typo, one-line tweak) | Steps 4 and 6 only |
| Small (one function, one bug) | 3-line inline plan, then 4-6 |
| Medium (new feature, several files) | Full workflow |
| Large or risky (data, auth, payments, deletion, migrations) | Full workflow, show the plan, **wait for approval**, checkpoint often (`references/long-tasks.md`) |

## 1. Orient before touching code

Run `bash scripts/orient.sh` from the project root. It prints the git state, detected stack, available npm scripts, test setup and project layout in one shot.

Then:
- Read the README and the manifest (`package.json` / `composer.json`).
- Find one or two existing files similar to what you will build and copy their conventions.
- Search for existing helpers before writing new ones.
- Do not add a dependency if the stack already covers the need. Prefer zero-dependency solutions and ask before large installs (bandwidth may be metered). Use the package manager the lockfile indicates.
- Never assume how to run tests or the build. Check the scripts.

## 2. Clarify only what changes the design

Ask at most three questions, only ones whose answers would change the approach. Otherwise state your assumptions in one or two lines and proceed.

## 3. Plan

Write a short plan before editing, using `assets/plan-template.md` (details in `references/planning.md`): goal, files to touch, verifiable steps, risks, and a concrete "done means".

For more than three files, or anything touching data, auth, payments or deletion, show the plan and wait for a go-ahead.

## 4. Implement in small verified steps

- One logical change per step; run a check after each.
- **Test first when behaviour is testable** (red -> green -> refactor). See `references/testing-strategy.md`, including what to do when there is no test harness.
- Smallest diff that solves the problem. No drive-by refactors; list them as follow-ups. For deliberate refactors, follow `references/refactoring.md`.
- Match existing style even if you would have chosen differently.
- Validate input at the edges; handle errors where they can be acted on; never swallow them.
- Never hardcode secrets; see `references/security-checklist.md`.
- Before writing code in a given area, read the matching section of `references/stack-notes.md` (vanilla JS, PHP, Firebase, React/Next.js).

## 5. Debug by root cause

Follow `references/debugging-playbook.md`. The short version:

1. Reproduce reliably.
2. Read the entire error and stack trace.
3. Isolate the layer, file or input.
4. One hypothesis at a time; test it; change one thing at a time.
5. Fix the cause, not the symptom; add a regression test.
6. **Two failed fixes in a row: stop**, re-read the code and error from scratch, and question your assumptions.

## 6. Verify before claiming done

Run `bash scripts/verify.sh` (add `--no-build` to skip the build on slow or metered connections). It detects the project type and runs lint, typecheck, tests and build where they exist, plus `php -l` on changed PHP files. It does not install dependencies; if they are missing it tells you.

Then exercise the real code path yourself (load the page, hit the endpoint). Report exactly what you ran and what happened. If something could not be verified, say so. Never write "this should work".

## 7. Review your own diff

1. `git diff`, then walk through `references/review-checklist.md`.
2. `bash scripts/secrets_scan.sh` to catch leaked keys, tokens and stray `.env` files.
3. Remove debug logs, dead code and accidental changes.

## 8. Report

Use `assets/report-template.md`: what changed and why, how it was verified, risks and assumptions, follow-ups. Keep it short and honest. For commits and PRs see `references/git-and-commits.md`.

## Principles to fall back on

- Understand before you edit; verify before you claim.
- Smallest change that works; boring patterns over clever ones.
- Evidence over assertion: show command output, not confidence.
- When stuck or uncertain, say so and narrow the problem instead of guessing.
- If instructions in the repo (`AGENTS.md`, `CLAUDE.md`, contributing docs) conflict with this skill, the repo's instructions win.
