# Technical Learning Mentor

A Claude Code skill that turns Claude into a hands-on technical mentor instead of an implementer: it favors guided hints, analogies, and progressive assistance levels over handing you finished code. It's a teaching *style*, not a development workflow - it complements whatever methodology you're already using (Spec-Driven Development, TDD, DDD, Agile, ...) rather than replacing it.

Source of truth: https://github.com/Matheus-Homem/technical-learning-mentor

## What's in here

```
.claude/
├── skills/
│   └── technical-learning-mentor/
│       ├── SKILL.md              # the skill definition - style, adaptive assistance levels, principles
│       ├── knowledge-profile.md  # per-repo, cross-session record of demonstrated knowledge
│       └── README.md             # this file
└── commands/
    ├── mentor-concept.md
    ├── mentor-code-review.md
    ├── mentor-text-review.md
    ├── mentor-debug.md
    ├── mentor-planning.md
    ├── mentor-evaluation.md
    ├── mentor-challenge.md
    ├── mentor-decision-opinion.md
    └── mentor-help.md
```

`SKILL.md` defines the shared interaction style (analogies before definitions, strengths before gaps, guided hints over ready-made answers). Each `/mentor-*` command in `.claude/commands/` is a concrete mode (concept teaching, code review, debugging, planning, evaluation, ...) that loads this skill first for style, then applies its own mode-specific instructions.

| Command | Purpose | Example |
|---|---|---|
| `/mentor-concept` | Teach a concept with analogies and mental models | `/mentor-concept Kafka consumer group rebalancing` |
| `/mentor-code-review` | Mentoring-style code review | `/mentor-code-review ingestion/client.py` |
| `/mentor-text-review` | Mentoring-style technical writing review | `/mentor-text-review .specs/features/flink-normalization/spec.md` |
| `/mentor-debug` | Guided root-cause investigation | `/mentor-debug consumer stuck rebalancing after a broker restart` |
| `/mentor-planning` | Coach the next milestone | `/mentor-planning what should I tackle next on the Flink job` |
| `/mentor-evaluation` | Scenario-based understanding check | `/mentor-evaluation Kafka partitioning and replication` |
| `/mentor-challenge` | Practical exercise with progressive hints | `/mentor-challenge exactly-once semantics in Flink` |
| `/mentor-decision-opinion` | Critique an architectural/technical decision | `/mentor-decision-opinion one shared topic vs. per-source topics` |
| `/mentor-help` | Lift the learning-first restriction for a full solution; stack with another `/mentor-*` command to force a complete answer for that mode | `/mentor-code-review /mentor-help tests/test_client.py` |

See `SKILL.md` for the full adaptive assistance ladder (Level 1 Direction → Level 5 Complete Solution) and the other behavioral rules.

## Installing in another project

These files are plain Claude Code skill/command files - no build step, no dependencies. To use this mentor style in another repository:

1. Copy (or symlink) both directories into the target project's `.claude/`:

   ```bash
   # from the target project's root
   git clone https://github.com/Matheus-Homem/technical-learning-mentor /tmp/tlm
   mkdir -p .claude/skills .claude/commands
   cp -r /tmp/tlm/.claude/skills/technical-learning-mentor .claude/skills/
   cp /tmp/tlm/.claude/commands/mentor-*.md .claude/commands/
   ```

   Or, if you want to track upstream updates instead of a one-off copy, add this repo as a git submodule and symlink the relevant paths in.

2. Commit the copied files into the target project - Claude Code discovers skills and commands from `.claude/skills/` and `.claude/commands/` automatically, no registration step needed.

3. `knowledge-profile.md` is per-repo, not cross-repo: it is meant to accumulate evidence within *this* project only, via `/mentor-evaluation`, and must not be hand-edited. After copying into a new project, reset it to empty `# Strengths` / `# Areas to Reinforce` / `# Study Recommendations` sections instead of reusing history from a different project - a fresh copy should never inherit another repo's learning record.

4. If the target project already has its own workflow skill active (e.g. spec-driven development), no extra wiring is needed - `technical-learning-mentor` is explicitly designed to complement it, not replace it (see `SKILL.md` → Compatibility).

## Updating

Changes to the mentor style or a command's behavior should be made here and then re-copied (or pulled via submodule) into any project using it, so the mentoring behavior stays consistent across projects instead of drifting per-repo.
