#!/usr/bin/env bash
# Install the frontier-coding-workflow skill.
#
# Usage:
#   ./install.sh                 # install to ~/.claude/skills (read by Claude Code AND opencode)
#   ./install.sh --opencode      # install to ~/.config/opencode/skills
#   ./install.sh --agents        # install to ~/.agents/skills (generic agent-compatible location)
#   ./install.sh --project DIR   # install into DIR/.claude/skills (project-local)
#   ./install.sh --agents-md DIR # append the condensed AGENTS.md to DIR/AGENTS.md (tools without skills support)
#   ./install.sh --link          # symlink instead of copy (handy while editing the skill)
#   ./install.sh --uninstall     # remove from the selected target(s)
# Flags can be combined, e.g. ./install.sh --claude --opencode
set -eu

NAME="frontier-coding-workflow"
HERE="$(cd "$(dirname "$0")" && pwd)"
SRC="$HERE/skills/$NAME"
[ -d "$SRC" ] || { echo "skill source not found: $SRC" >&2; exit 1; }

targets=()
link=0
uninstall=0
agents_md_dir=""

while [ $# -gt 0 ]; do
  case "$1" in
    --claude)    targets+=("$HOME/.claude/skills") ;;
    --opencode)  targets+=("${XDG_CONFIG_HOME:-$HOME/.config}/opencode/skills") ;;
    --agents)    targets+=("$HOME/.agents/skills") ;;
    --project)   shift; [ $# -gt 0 ] || { echo "--project needs a directory" >&2; exit 1; }
                 targets+=("$1/.claude/skills") ;;
    --agents-md) shift; [ $# -gt 0 ] || { echo "--agents-md needs a directory" >&2; exit 1; }
                 agents_md_dir="$1" ;;
    --link)      link=1 ;;
    --uninstall) uninstall=1 ;;
    -h|--help)   sed -n '2,13p' "$0"; exit 0 ;;
    *) echo "unknown option: $1" >&2; exit 1 ;;
  esac
  shift
done

if [ "${#targets[@]}" -eq 0 ] && [ -z "$agents_md_dir" ]; then
  targets+=("$HOME/.claude/skills")
fi

for t in "${targets[@]:-}"; do
  [ -n "$t" ] || continue
  dest="$t/$NAME"
  if [ "$uninstall" -eq 1 ]; then
    rm -rf "$dest"; echo "removed $dest"; continue
  fi
  mkdir -p "$t"
  rm -rf "$dest"
  if [ "$link" -eq 1 ]; then
    ln -s "$SRC" "$dest"; echo "linked  $dest -> $SRC"
  else
    cp -R "$SRC" "$dest"; echo "installed $dest"
  fi
  chmod +x "$dest"/scripts/*.sh 2>/dev/null || true
done

if [ -n "$agents_md_dir" ]; then
  f="$agents_md_dir/AGENTS.md"
  marker="<!-- frontier-coding-workflow -->"
  if [ "$uninstall" -eq 1 ]; then
    echo "to uninstall AGENTS.md content, remove the section starting at '$marker' in $f"
  elif [ -f "$f" ] && grep -qF "$marker" "$f"; then
    echo "AGENTS.md already contains the workflow section: $f"
  else
    mkdir -p "$agents_md_dir"
    sep=""
    [ -s "$f" ] && sep="yes"
    { [ -n "$sep" ] && echo; echo "$marker"; cat "$HERE/AGENTS.md"; } >> "$f"
    echo "appended workflow to $f"
  fi
fi

echo "Done. Restart your agent (opencode / Claude Code) so it rediscovers skills."
