# frontier-workflow

An [Agent Skill](https://opencode.ai/docs/skills/) that gives coding agents the working habits strong frontier models use on real software tasks: **orient, clarify, plan, build in small verified steps, debug by root cause, verify with real commands, review the diff, and report honestly.**

It works with any agent that supports `SKILL.md` skills (opencode, Claude Code, and others), and ships a condensed `AGENTS.md` for tools that don't.

> **What this is and isn't.** A skill steers an agent through instructions and helper scripts. It does **not** train the model or change its weights. It captures the *process* (plan, test, verify, review) that makes agents reliable, not the reinforcement-learning that makes frontier models strong at coding.

## What's inside

```
skills/frontier-workflow/
  SKILL.md                     # the workflow (loaded when a coding task is detected)
  scripts/
    orient.sh                  # repo + stack + scripts overview in one shot
    verify.sh                  # runs lint / typecheck / tests / build / php -l (never installs deps)
    secrets_scan.sh            # heuristic scan of uncommitted changes for leaked secrets
  references/                  # loaded on demand
    planning.md  debugging-playbook.md  testing-strategy.md  refactoring.md
    security-checklist.md  git-and-commits.md  long-tasks.md
    stack-notes.md  review-checklist.md
  assets/
    plan-template.md  report-template.md  handoff-template.md
AGENTS.md                      # condensed version for tools without skills support
install.sh                     # installer (copy or symlink)
evals/evals.json               # prompts + assertions for testing the skill
.github/workflows/validate.yml # frontmatter, link and shellcheck CI
```

The stack notes cover vanilla JavaScript, PHP, Firebase and React/Next.js. Edit `references/stack-notes.md` to match your own stack.

## Install

```bash
git clone https://github.com/olly-techie/frontier-workflow && cd frontier-workflow
./install.sh                 # -> ~/.claude/skills (read by Claude Code and by opencode)
```

Other targets:

```bash
./install.sh --opencode          # ~/.config/opencode/skills
./install.sh --agents            # ~/.agents/skills
./install.sh --project ./myapp   # ./myapp/.claude/skills (project-local)
./install.sh --agents-md ./myapp # append condensed rules to ./myapp/AGENTS.md
./install.sh --link              # symlink instead of copy (for editing the skill)
./install.sh --uninstall         # remove from the chosen target(s)
```

opencode discovers skills in `.opencode/skills`, `~/.config/opencode/skills`, and the Claude- and agent-compatible `.claude/skills` and `.agents/skills` locations, so one install is usually enough. Restart the agent afterwards.

Manual install: copy `skills/frontier-workflow/` into any of the directories above. The folder name must match the `name` in `SKILL.md`.

## How it works

1. The agent sees only the skill's `name` and `description` until a task matches, then loads `SKILL.md`.
2. `SKILL.md` is the short workflow. It points to `references/` and `assets/` only when needed, which keeps context small.
3. The scripts give the agent cheap, deterministic ways to orient, verify and scan, so it relies on real output instead of assumptions.

Key behaviours it enforces:
- Scale the process: trivial edits skip planning; risky changes (data, auth, payments) require a plan and approval.
- Test first where behaviour is testable; downgrade to smoke scripts or manual checklists when there is no harness, and say so.
- Two failed fixes in a row means stop and re-examine assumptions.
- No "should work": the report states exactly what was run and what wasn't verified.
- Zero-dependency preference and no automatic installs, which suits slow or metered connections.
- The repo's own `AGENTS.md` / `CLAUDE.md` always win over this skill.

## Using the scripts directly

```bash
bash skills/frontier-workflow/scripts/orient.sh
bash skills/frontier-workflow/scripts/verify.sh --no-build
bash skills/frontier-workflow/scripts/secrets_scan.sh
```

`verify.sh` exits non-zero if any executed check fails. `secrets_scan.sh` exits 1 on suspicious findings; it is a quick heuristic, not a replacement for a dedicated scanner.

## Testing the skill

`evals/evals.json` contains realistic prompts with assertions (for example: auth work must pause for a plan, a typo fix must not trigger heavy process, a leaked `.env` must lead to key rotation). Run each prompt with and without the skill installed and compare how well the assertions hold.

## Customizing

- Change the stack guidance in `references/stack-notes.md`.
- Tighten or loosen approval rules in section 0 of `SKILL.md`.
- Keep `SKILL.md` under about 500 lines; put detail in `references/`.
- Bump `metadata.version` in `SKILL.md` and add an entry to `CHANGELOG.md` when you change behaviour.

## License

MIT, see [LICENSE](LICENSE). Replace the copyright holder name as you see fit.
