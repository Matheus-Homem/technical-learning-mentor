#!/usr/bin/env python3
"""Test oracle for the v3 resolution rules.

NOT part of the skill runtime. The skill is prose; `references/knowledge-model.md`
and `references/task-matrix.md` are normative. This exists so those rules can be
checked mechanically — if this disagrees with the prose, the prose wins and this
is the thing that gets fixed.
"""
import json, re, sys
from pathlib import Path

NODE_RE = re.compile(r"^[A-Z][A-Za-z0-9]*(\.[A-Z][A-Za-z0-9]*){0,3}$")
RANK = {"delegated": 0, "paired": 1, "own": 2}


def rows(path):
    """Yield cell lists from a markdown table, skipping header/separator/comments."""
    out = []
    for line in Path(path).read_text(encoding="utf-8").splitlines():
        line = line.strip()
        if not line.startswith("|"):
            continue
        cells = [c.strip() for c in line.strip("|").split("|")]
        if not cells or set("".join(cells)) <= set("-: "):
            continue
        out.append(cells)
    return out[1:]  # drop header


def prefixes(node):
    """All prefixes of a node, longest first."""
    parts = node.split(".")
    return [".".join(parts[:i]) for i in range(len(parts), 0, -1)]


def load_domain(path):
    return {r[0]: r[1] for r in rows(path) if r[0]}


def load_nodes(path):
    return {r[0]: {"application": r[1], "source": r[2]} for r in rows(path) if r[0]}


def load_snapshot(path):
    d = json.loads(Path(path).read_text(encoding="utf-8"))
    return {n["node"]: n for n in d["nodes"]}


def resolve_domain(node, decls):
    """Longest prefix with a declaration wins. No declaration anywhere -> developing."""
    for p in prefixes(node):
        if p in decls:
            origin = "explicit" if p == node else f"inherited:{p}"
            return decls[p], origin
    return "developing", "default"


def resolve_comprehension(node, snap):
    """Absence IS unknown. Comprehension never inherits, in either direction."""
    entry = snap.get(node)
    if not entry:
        return "unknown"
    v = entry.get("comprehension")
    return v if v in ("yes", "no") else "unknown"


def classify(domain, comprehension, application):
    """One row of the matrix in references/task-matrix.md."""
    if domain == "waived":
        return "excluded", []
    if domain == "mastered":
        if comprehension == "yes":
            return "paired", []
        if comprehension == "no":
            return "paired", ["contested"]
        return "paired", ["unverified"]
    # developing
    if application == "practical":
        return "own", ([] if comprehension == "yes" else ["class-first"])
    return "paired", []


def resolve_node(node, decls, snap, nodes):
    domain, origin = resolve_domain(node, decls)
    comp = resolve_comprehension(node, snap)
    app = nodes.get(node, {}).get("application", "")
    verdict, flags = classify(domain, comp, app)
    return {"node": node, "domain": domain, "domain_origin": origin,
            "comprehension": comp, "application": app,
            "verdict": verdict, "flags": flags}


def aggregate(required, decls, snap, nodes):
    """Waived nodes drop out; the most demanding survivor wins. Empty -> delegated."""
    resolved = [resolve_node(n, decls, snap, nodes) for n in required]
    active = [r for r in resolved if r["verdict"] != "excluded"]
    if not active:
        return "delegated", None, resolved
    best = max(active, key=lambda r: RANK[r["verdict"]])
    return best["verdict"], best["node"], resolved


def main():
    fx = Path(sys.argv[1] if len(sys.argv) > 1 else "tests/fixtures")
    decls = load_domain(fx / "domain.md")
    nodes = load_nodes(fx / "nodes.md")
    snap = load_snapshot(fx / "snapshot.json")

    bad = [n for n in list(decls) + list(nodes) + list(snap) if not NODE_RE.match(n)]
    if bad:
        print("INVALID NODE IDS:", bad, file=sys.stderr)
        return 2

    print("## Node resolution\n")
    print("| node | domain | domain origin | comprehension | application | verdict | flags |")
    print("|---|---|---|---|---|---|---|")
    for n in nodes:
        r = resolve_node(n, decls, snap, nodes)
        print(f"| {r['node']} | {r['domain']} | {r['domain_origin']} | {r['comprehension']} "
              f"| {r['application']} | {r['verdict']} | {' '.join(r['flags'])} |")

    print("\n## Task aggregation\n")
    print("| task | verdict | deciding node |")
    print("|---|---|---|")
    for row in rows(fx / "tasks.md"):
        task = row[0]
        required = [x.strip() for x in (row[1] if len(row) > 1 else "").split(",") if x.strip()]
        verdict, deciding, _ = aggregate(required, decls, snap, nodes)
        print(f"| {task} | {verdict} | {deciding or ''} |")
    return 0


if __name__ == "__main__":
    sys.exit(main())
