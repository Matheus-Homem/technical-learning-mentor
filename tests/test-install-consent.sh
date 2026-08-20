#!/usr/bin/env bash
# Consent tests for install.sh's DESIGN pairing rule. Run from anywhere: bash tests/test-install-consent.sh
set -uo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ROOT="$(mktemp -d)"
PASS=0; FAIL=0

ok()   { echo "  PASS  $1"; PASS=$((PASS+1)); }
bad()  { echo "  FAIL  $1"; FAIL=$((FAIL+1)); }
check(){ if [ "$2" == "$3" ]; then ok "$1"; else bad "$1 (expected '$3', got '$2')"; fi; }

# fresh project with a pre-existing CLAUDE.md
setup() {
  local d="$ROOT/$1"; rm -rf "$d"; mkdir -p "$d"; cd "$d"
  printf '# My project\n\nSome existing rules the user wrote.\n' > CLAUDE.md
  cp "$SRC/install.sh" ./install-local.sh
  md5sum CLAUDE.md | cut -d' ' -f1 > "$ROOT"/baseline.$1
}
run() { MENTOR_REPO_URL="$SRC" bash ./install-local.sh claude "$@" 2>&1; }

echo "T1: answering N leaves CLAUDE.md untouched"
setup t1
out=$(printf 'n\n' | script -qec "MENTOR_REPO_URL=$SRC bash ./install-local.sh claude" /dev/null 2>&1)
check "  CLAUDE.md unchanged" "$(md5sum CLAUDE.md | cut -d' ' -f1)" "$(cat "$ROOT"/baseline.t1)"
check "  pairing file absent" "$([ -f .claude/mentor-design-pairing.md ] && echo yes || echo no)" "no"
check "  prompt was shown"    "$(grep -qc 'Install the DESIGN pairing rule' <<<"$out" && echo yes || echo no)" "yes"
check "  skill still installed" "$([ -f .claude/skills/technical-learning-mentor/SKILL.md ] && echo yes || echo no)" "yes"

echo "T2: answering y installs the block and preserves prior content"
setup t2
out=$(printf 'y\n' | script -qec "MENTOR_REPO_URL=$SRC bash ./install-local.sh claude" /dev/null 2>&1)
check "  pairing file created" "$([ -f .claude/mentor-design-pairing.md ] && echo yes || echo no)" "yes"
check "  marker present"       "$(grep -c 'BEGIN technical-learning-mentor' CLAUDE.md)" "1"
check "  import line present"  "$(grep -c '^@.claude/mentor-design-pairing.md$' CLAUDE.md)" "1"
check "  prior content intact" "$(grep -c 'Some existing rules the user wrote.' CLAUDE.md)" "1"
check "  heading intact"       "$(head -1 CLAUDE.md)" "# My project"

echo "T3: prompt reaches the user through a pipe (the curl | bash case)"
setup t3
out=$(script -qec "MENTOR_REPO_URL=$SRC bash -c 'cat install-local.sh | bash -s -- claude' < /dev/null" /dev/null 2>&1 </dev/null)
# with a pty attached but stdin of the script being the script itself, /dev/tty must still work
check "  notice shown"         "$(grep -qc 'OPTIONAL: DESIGN pairing rule' <<<"$out" && echo yes || echo no)" "yes"

echo "T4: no TTY -> skip, warn, write nothing"
setup t4
out=$(run < /dev/null)
check "  CLAUDE.md unchanged" "$(md5sum CLAUDE.md | cut -d' ' -f1)" "$(cat "$ROOT"/baseline.t4)"
check "  pairing file absent" "$([ -f .claude/mentor-design-pairing.md ] && echo yes || echo no)" "no"
check "  warned about tty"    "$(grep -qc 'no terminal available' <<<"$out" && echo yes || echo no)" "yes"

echo "T5: twice with y -> idempotent, no re-ask"
setup t5
printf 'y\n' | script -qec "MENTOR_REPO_URL=$SRC bash ./install-local.sh claude" /dev/null >/dev/null 2>&1
first=$(md5sum CLAUDE.md | cut -d' ' -f1)
out=$(run < /dev/null)   # second run, no tty at all
check "  marker not duplicated" "$(grep -c 'BEGIN technical-learning-mentor' CLAUDE.md)" "1"
check "  import not duplicated" "$(grep -c '^@.claude/mentor-design-pairing.md$' CLAUDE.md)" "1"
check "  file unchanged"        "$(md5sum CLAUDE.md | cut -d' ' -f1)" "$first"
check "  did not re-ask"        "$(grep -qc 'Install the DESIGN pairing rule' <<<"$out" && echo yes || echo no)" "no"
check "  reported refresh"      "$(grep -qc 'already installed' <<<"$out" && echo yes || echo no)" "yes"

echo "T6: flags skip the prompt"
setup t6a
out=$(run --no-design-pairing < /dev/null)
check "  --no: nothing written" "$(md5sum CLAUDE.md | cut -d' ' -f1)" "$(cat "$ROOT"/baseline.t6a)"
check "  --no: said skipped"    "$(grep -qc 'skipped (--no-design-pairing)' <<<"$out" && echo yes || echo no)" "yes"
setup t6b
out=$(run --with-design-pairing < /dev/null)
check "  --with: installed"     "$(grep -c 'BEGIN technical-learning-mentor' CLAUDE.md)" "1"
check "  --with: no prompt"     "$(grep -qc 'Install the DESIGN pairing rule' <<<"$out" && echo yes || echo no)" "no"

echo "T7: no pre-existing CLAUDE.md"
d="$ROOT/t7"; rm -rf "$d"; mkdir -p "$d"; cd "$d"; cp "$SRC/install.sh" ./install-local.sh
out=$(run --with-design-pairing < /dev/null)
check "  CLAUDE.md created"    "$([ -f CLAUDE.md ] && echo yes || echo no)" "yes"
check "  contains only block"  "$(grep -c 'technical-learning-mentor' CLAUDE.md)" "2"

echo
echo "=== $PASS passed, $FAIL failed ==="
cd /; rm -rf "$ROOT"
[ "$FAIL" -eq 0 ]
