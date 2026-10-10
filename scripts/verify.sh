#!/usr/bin/env bash
# verify.sh — the single pass/fail gate: build + lint + tests for server and client.
# Usage: ./scripts/verify.sh [server|client]   (no argument = both)
# Output is short on purpose; full logs are kept in $LOG_DIR and printed only on failure.
set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOG_DIR="${VERIFY_LOG_DIR:-${TMPDIR:-/tmp}/justina-verify}"
TARGET="${1:-all}"
mkdir -p "$LOG_DIR" && LOG_DIR="$(cd "$LOG_DIR" && pwd)"  # absolute: the script cd's into each part

FAILED=0
SUMMARY_SERVER=""
SUMMARY_CLIENT=""

# run <label> <log-file> <command...>: runs quietly, returns the command's exit code.
run() {
  local label="$1" log="$2"; shift 2
  local start=$SECONDS
  if "$@" >"$log" 2>&1; then
    echo "  ✅ $label ($((SECONDS - start))s)"
    return 0
  fi
  echo "  ❌ $label ($((SECONDS - start))s) — excerpt of $log:"
  if grep -q '^\[ERROR\]' "$log"; then
    # Maven: keep the meaningful [ERROR] lines, drop the generic help footer.
    grep '^\[ERROR\]' "$log" \
      | grep -vE '^\[ERROR\] *$|Help 1|re-run|-e switch|-X switch|For more information|full stack trace|surefire-reports for the individual' \
      | cut -c1-220 | head -n 15 | sed 's/^/     │ /'
  else
    tail -n 25 "$log" | sed 's/^/     │ /'
  fi
  return 1
}

verify_server() {
  echo "server:"
  cd "$ROOT/server" || return 1
  local build="✅ build" tests
  # 'verify' compiles, runs the tests and (once configured) the coverage check.
  if run "mvnw clean verify" "$LOG_DIR/server.log" ./mvnw -B -q clean verify; then
    tests="✅ tests"
  else
    FAILED=1
    if grep -q "COMPILATION ERROR\|BUILD FAILURE.*compile" "$LOG_DIR/server.log"; then build="❌ build"; fi
    tests="❌ tests"
  fi
  local reports=(target/surefire-reports/*.txt)
  if [ -e "${reports[0]}" ]; then
    local counts
    counts=$(grep -h "Tests run:" target/surefire-reports/*.txt \
      | awk -F'[ ,]+' '{r+=$3; f+=$5; e+=$7; s+=$9} END {printf "%d run, %d failed, %d errors, %d skipped", r, f, e, s}')
    tests="$tests ($counts)"
  fi
  SUMMARY_SERVER="server: $build $tests"
}

verify_client() {
  echo "client:"
  cd "$ROOT/client" || return 1
  local deps lint test build
  if run "npm ci" "$LOG_DIR/client-install.log" npm ci --no-audit --no-fund; then deps="✅ deps"; else deps="❌ deps"; FAILED=1; fi
  if run "npm run lint" "$LOG_DIR/client-lint.log" npm run lint; then
    lint="✅ lint"
  else
    lint="❌ lint ($(grep -oE '[0-9]+ problems?' "$LOG_DIR/client-lint.log" | head -1))"
    FAILED=1
  fi
  if grep -q '"test"' package.json; then
    if run "npm test" "$LOG_DIR/client-test.log" npm test; then test="✅ tests"; else test="❌ tests"; FAILED=1; fi
  else
    test="⚠️ tests (no 'test' script yet)"
  fi
  if run "npm run build" "$LOG_DIR/client-build.log" npm run build; then build="✅ build"; else build="❌ build"; FAILED=1; fi
  SUMMARY_CLIENT="client: $deps $lint $test $build"
}

case "$TARGET" in
  server) verify_server ;;
  client) verify_client ;;
  all) verify_server; verify_client ;;
  *) echo "usage: $0 [server|client]"; exit 2 ;;
esac

echo "────────"
[ -n "$SUMMARY_SERVER" ] && echo "$SUMMARY_SERVER"
[ -n "$SUMMARY_CLIENT" ] && echo "$SUMMARY_CLIENT"
echo "logs: $LOG_DIR"
if [ "$FAILED" -ne 0 ]; then echo "RESULT: ❌ FAIL"; exit 1; fi
echo "RESULT: ✅ PASS"
