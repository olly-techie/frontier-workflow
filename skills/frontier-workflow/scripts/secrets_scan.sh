#!/usr/bin/env bash
# secrets_scan.sh - quick scan of uncommitted changes for leaked secrets.
# Scans added lines in `git diff HEAD` plus untracked, non-ignored text files.
# Usage: bash secrets_scan.sh        Exit 1 if anything suspicious is found.
# Fast heuristic only; not a replacement for a dedicated scanner.
set -u
cd "$(git rev-parse --show-toplevel 2>/dev/null || pwd)" || exit 1

patterns=(
  'AKIA[0-9A-Z]{16}'
  '-----BEGIN ([A-Z]+ )?PRIVATE KEY-----'
  'ghp_[A-Za-z0-9]{36}'
  'github_pat_[A-Za-z0-9_]{20,}'
  'sk-[A-Za-z0-9_-]{20,}'
  'xox[baprs]-[A-Za-z0-9-]{10,}'
  'AIza[0-9A-Za-z_-]{35}'
  '"private_key"[[:space:]]*:'
  '(password|passwd|secret|api[_-]?key|token)[[:space:]]*[:=][[:space:]]*["'"'"'][^"'"'"' ]{8,}["'"'"']'
)

tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT
{
  git diff HEAD 2>/dev/null | grep -E '^\+[^+]' | sed 's/^+//' | sed 's/^/[diff] /'
  git ls-files --others --exclude-standard 2>/dev/null | while IFS= read -r f; do
    [ -f "$f" ] || continue
    [ "$(wc -c < "$f")" -gt 500000 ] && continue
    grep -Iq . "$f" 2>/dev/null || continue
    sed "s|^|[untracked:$f] |" "$f"
  done
} > "$tmp"

found=0
for p in "${patterns[@]}"; do
  hits="$(grep -E -n -e "$p" "$tmp" 2>/dev/null | head -5)"
  if [ -n "$hits" ]; then
    echo "SUSPECT pattern: $p"
    echo "$hits" | cut -c1-160 | sed 's/^/    /'
    found=1
  fi
done

for f in $( { git ls-files --others --exclude-standard 2>/dev/null; git diff --name-only HEAD 2>/dev/null; } | sort -u ); do
  base="$(basename "$f")"
  case "$base" in
    *.example|*.sample) ;;
    .env|.env.*) echo "SUSPECT file not ignored: $f"; found=1 ;;
    *serviceAccount*.json|*service-account*.json) echo "SUSPECT service-account file: $f"; found=1 ;;
  esac
done

if [ "$found" -eq 0 ]; then
  echo "secrets_scan: nothing suspicious found in uncommitted changes."
  exit 0
fi
echo
echo "Review the hits above. Firebase web API keys (AIza...) are public by design but still need tight security rules."
exit 1
