#!/usr/bin/env bash
# orient.sh - compact orientation of the current project.
# Usage: bash orient.sh [path]   (defaults to the git root or cwd)
set -u

start="${1:-.}"
cd "$start" 2>/dev/null || { echo "cannot cd to $start"; exit 1; }
root="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$root" || exit 1

echo "== Repo: $root"

if git rev-parse --git-dir >/dev/null 2>&1; then
  echo "-- branch: $(git branch --show-current 2>/dev/null)"
  echo "-- status (first 20):"
  git status --short | head -20
  echo "-- recent commits:"
  git log --oneline -n 8 2>/dev/null
else
  echo "-- not a git repository"
fi

echo
echo "== Stack detection"
found=0
has() { if [ -e "$1" ]; then echo "  [x] $2"; found=1; fi; }
has package.json "Node project (package.json)"
has pnpm-lock.yaml "package manager: pnpm"
has yarn.lock "package manager: yarn"
has package-lock.json "package manager: npm"
has bun.lockb "package manager: bun"
for f in next.config.js next.config.mjs next.config.ts; do has "$f" "Next.js ($f)"; done
if [ -f package.json ] && grep -q '"react"' package.json; then echo "  [x] React dependency"; found=1; fi
has tsconfig.json "TypeScript (tsconfig.json)"
has vite.config.js "Vite"
has vite.config.ts "Vite"
has composer.json "PHP project (composer.json)"
has phpunit.xml "PHPUnit config"
has phpunit.xml.dist "PHPUnit config"
has firebase.json "Firebase (firebase.json)"
has .firebaserc "Firebase project (.firebaserc)"
has firestore.rules "Firestore rules"
has storage.rules "Storage rules"
has vitest.config.ts "Vitest"
has vitest.config.js "Vitest"
has jest.config.js "Jest"
has jest.config.ts "Jest"
has Dockerfile "Docker"
has .env "WARNING: .env present (never commit; never print its values)"
has .env.example ".env.example present"
php_count=$(find . -maxdepth 3 -name '*.php' -not -path './vendor/*' -not -path './node_modules/*' 2>/dev/null | wc -l | tr -d ' ')
if [ "$php_count" -gt 0 ]; then echo "  [x] $php_count PHP files (depth<=3)"; found=1; fi
if [ "$found" -eq 0 ]; then echo "  (no known project markers found)"; fi

echo
if [ -f package.json ]; then
  echo "== package.json scripts"
  if command -v node >/dev/null 2>&1; then
    node -e 'try{const p=require("./package.json");const s=p.scripts||{};const k=Object.keys(s);if(!k.length)console.log("  (none)");k.forEach(n=>console.log("  "+n+": "+s[n]))}catch(e){console.log("  (could not parse)")}'
  else
    sed -n '/"scripts"/,/}/p' package.json | sed 's/^/  /'
  fi
  [ -d node_modules ] || echo "  NOTE: node_modules missing - dependencies not installed (ask before installing; connection may be metered)"
  echo
fi

echo "== Docs and agent instructions"
for f in README.md README AGENTS.md CLAUDE.md CONTRIBUTING.md; do [ -f "$f" ] && echo "  $f"; done

echo
echo "== Layout (depth<=2)"
find . -maxdepth 2 \
  -not -path './.git' -not -path './.git/*' \
  -not -path './node_modules' -not -path './node_modules/*' \
  -not -path './vendor' -not -path './vendor/*' \
  -not -path './.next' -not -path './.next/*' \
  -not -path './dist' -not -path './dist/*' \
  2>/dev/null | sed 's|^\./||' | sort | head -60
exit 0
