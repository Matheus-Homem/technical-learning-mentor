#!/usr/bin/env python3
"""Compare the resolution oracle's output against the hand-written gabarito."""
import subprocess, sys
from pathlib import Path

root = Path(sys.argv[1] if len(sys.argv) > 1 else ".")


def tables(text):
    """{section title: [row cell-lists]} from markdown, ignoring separators/headers."""
    out, cur = {}, None
    for line in text.splitlines():
        s = line.strip()
        if s.startswith("## "):
            cur = s[3:].strip()
            out[cur] = []
        elif s.startswith("|") and cur is not None:
            cells = [c.strip() for c in s.strip("|").split("|")]
            if set("".join(cells)) <= set("-: "):
                continue
            if cells[0].lower() in ("node", "task"):
                continue
            out[cur].append(cells)
    return out


proc = subprocess.run([sys.executable, str(root / "tests/resolve.py"), str(root / "tests/fixtures")],
                      capture_output=True, text=True)
if proc.returncode != 0:
    print("FAIL  oracle exited non-zero\n" + proc.stderr)
    sys.exit(1)

actual = tables(proc.stdout)
expected = tables((root / "tests/fixtures/expected.md").read_text(encoding="utf-8"))

fail = 0
for section in ("Node resolution", "Task aggregation"):
    a, e = actual.get(section, []), expected.get(section, [])
    # the gabarito's task table carries an extra `why` column the oracle does not
    # emit; compare only the columns both sides have.
    width = min(len(r) for r in a + e) if a and e else 0
    akeys = sorted(tuple(r[:width]) for r in a)
    ekeys = sorted(tuple(r[:width]) for r in e)
    if akeys == ekeys:
        print(f"  PASS  {section} ({len(akeys)} rows, {width} cols)")
        continue
    fail = 1
    print(f"  FAIL  {section}")
    for row in sorted(set(ekeys) - set(akeys)):
        print("        expected but missing: " + " | ".join(row))
    for row in sorted(set(akeys) - set(ekeys)):
        print("        produced unexpectedly: " + " | ".join(row))

print()
print("=== resolution matches the gabarito ===" if not fail else "=== MISMATCH ===")
sys.exit(fail)
