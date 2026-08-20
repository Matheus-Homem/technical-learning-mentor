# Profile

<!-- Created by /mentor-sync on first run. Config for this project's mentoring.
     Everything here is English; see references/knowledge-model.md. -->

## Config

- `spec_artifacts`: <path or glob to the plan/design/task files produced by the planning skill>
- `active_feature`: <slug>
- `gemini_notebook_id`: <notebook id or share link — which notebook holds the knowledge ledger>
- `gemini_notebook_transport`: manual
- `snapshot_max_age_days`: 14

<!-- gemini_notebook_transport: `manual` (paste or point at an exported ledger) or `mcp:<server>`.
     `manual` always works and is the default; see references/gemini-notebook-contract.md.
     /mentor-sync probes for a known MCP once, right after this file is created —
     never on an ordinary run. Confirmed with you before it's ever written here.
     Changed your mind, or set one up later? `/mentor-sync --detect-mcp` re-checks
     on demand. Editing this line by hand works too.
     snapshot_max_age_days: after this, /mentor-map warns that the snapshot is stale.
     It warns and continues — it never blocks. -->

## Notes

<!-- Anything about how this project should be mentored that does not fit above.
     Free text. -->
