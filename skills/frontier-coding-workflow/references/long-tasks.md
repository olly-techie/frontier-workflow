# Long and risky tasks

For work that spans many files, many steps, or more context than fits comfortably in one session.

## Keep a working log
Maintain a small `NOTES.md` (or the task tracker the project uses) with:
- Goal and "done means"
- Plan with checkboxes
- Decisions made and why
- Open questions
- What you just verified and what is next

Update it after each step. Delete or ignore it before committing unless the user wants it kept.

## Checkpoint
- Commit (or stash) after each working step so you can roll back.
- Re-run `scripts/verify.sh` at each checkpoint, not only at the end.
- Summarize progress to the user at natural milestones; surface decisions that need their input early.

## Manage context
- Read only what you need; search rather than opening whole directories.
- Do not paste large files or logs back into the conversation; quote the relevant lines.
- When the session gets long, write a handoff (`assets/handoff-template.md`) capturing state, so a fresh session can continue without re-discovery.

## Risky changes (data, auth, payments, migrations, deletion)
1. Show the plan and get approval first.
2. Make destructive operations reversible (backup, soft delete, dry run flag).
3. Test on non-production data or an emulator first.
4. Migrate in stages: add new -> write both -> backfill -> switch reads -> remove old.
5. State exactly what could go wrong and how to roll back.

## Subagents or parallel work
If the tool supports delegating, give each subtask a self-contained brief (goal, files, constraints, "done means"), and review each result against the spec before merging it in.
