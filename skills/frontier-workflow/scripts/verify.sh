#!/usr/bin/env bash
# verify.sh - detect the project type and run lint / typecheck / tests / build.
# Usage: bash verify.sh [--no-build] [--no-tests]
# Never installs dependencies. Exits non-zero if any executed check failed.
set -u

run_build=1
run_tests=1
for a in "$@"; do
  case "$a" in
    --no-build) run_build=0 ;;
    --no-tests) run_tests=0 ;;
    -h|--help) sed -n '2,4p' "$0"; exit 0 ;;
  esac
done

root="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$root" || exit 1

results=()
failed=0
record() {
  results+=("$1|$2")
  if [ "$2" = "FAIL" ]; then failed=1; fi
}

has_script() {
  [ -f package.json ] || return 1
  if command -v node >/dev/null 2>&1; then
    node -e 'const p=require("./package.json");process.exit((p.scripts&&p.scripts[process.argv[1]])?0:1)' "$1" 2>/dev/null
  else
    grep -q "\"$1\"[[:space:]]*:" package.json
  fi
}

pm=npm
[ -f pnpm-lock.yaml ] && pm=pnpm
[ -f yarn.lock ] && pm=yarn
[ -f bun.lockb ] && pm=bun

run_step() {
  name="$1"; shift
  echo; echo "=== $name: $*"
  if "$@"; then record "$name" PASS; else record "$name" FAIL; fi
}

if [ -f package.json ]; then
  if [ ! -d node_modules ]; then
    echo "node_modules missing: skipping Node checks (install deps first; ask the user if bandwidth is limited)."
    record "node-checks" SKIP
  else
    if has_script lint; then run_step lint "$pm" run lint; fi
    if has_script typecheck; then
      run_step typecheck "$pm" run typecheck
    elif [ -f tsconfig.json ] && [ -x node_modules/.bin/tsc ]; then
      run_step typecheck node_modules/.bin/tsc --noEmit
    fi
    if [ "$run_tests" -eq 1 ]; then
      if has_script test; then
        export CI=1
        run_step test "$pm" run test
      else
        record test SKIP
      fi
    fi
    if [ "$run_build" -eq 1 ]; then
      if has_script build; then run_step build "$pm" run build; fi
    fi
  fi
fi

if command -v php >/dev/null 2>&1; then
  files="$( { git diff --name-only HEAD 2>/dev/null; git ls-files --others --exclude-standard 2>/dev/null; } | grep -E '\.php$' | sort -u )"
  if [ -n "$files" ]; then
    bad=0
    echo; echo "=== php -l on changed PHP files"
    for f in $files; do
      [ -f "$f" ] || continue
      if ! out="$(php -l "$f" 2>&1)"; then echo "$out"; bad=1; fi
    done
    if [ "$bad" -eq 0 ]; then echo "OK"; record "php-lint" PASS; else record "php-lint" FAIL; fi
  fi
  if [ "$run_tests" -eq 1 ] && [ -x vendor/bin/phpunit ]; then
    run_step phpunit vendor/bin/phpunit
  fi
fi

if [ -f firebase.json ]; then
  echo
  echo "NOTE: Firebase project detected. Test rules/functions with the Emulator Suite; this script does not start emulators."
fi

echo
echo "================ SUMMARY ================"
if [ "${#results[@]}" -eq 0 ]; then
  echo "No checks detected. Define a manual verification and say so in your report."
else
  for r in "${results[@]}"; do printf '  %-14s %s\n' "${r%%|*}" "${r##*|}"; done
fi
exit "$failed"
