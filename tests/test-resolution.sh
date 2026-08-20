#!/usr/bin/env bash
# Checks the resolution oracle against the hand-written gabarito in
# tests/fixtures/expected.md. The gabarito was derived by hand from
# references/knowledge-model.md and references/task-matrix.md, before the
# oracle existed. If these disagree, the prose is the authority.
set -uo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
python3 "$ROOT/tests/compare.py" "$ROOT"
