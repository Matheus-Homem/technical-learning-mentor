#!/usr/bin/env bash
# Installs the technical-learning-mentor skill into the current project, for Claude Code or Cursor.
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/Matheus-Homem/technical-learning-mentor/main/install.sh | bash -s -- claude
#   curl -fsSL https://raw.githubusercontent.com/Matheus-Homem/technical-learning-mentor/main/install.sh | bash -s -- cursor
#
# Run from the root of the project you want the skill installed into.
# Defaults to "claude" if no tool is given.
#
# What this does, per tool, and why it differs:
#
#   claude  Claude Code auto-discovers a skill placed at .claude/skills/<name>/SKILL.md
#           and reads it into context based on its `description` frontmatter. This is
#           full native support: no extra step needed for the skill itself. Commands are
#           copied to .claude/commands/ so the /mentor-* slash commands work.
#
#   cursor  Cursor has no equivalent auto-discovery of a SKILL.md-style skill folder as
#           of this writing. The skill is installed under .cursor/skills/<name>/ for
#           reference and for the commands to point at, commands go to .cursor/commands/,
#           and an alwaysApply rule is added at .cursor/rules/technical-learning-mentor.md
#           so the model is told the skill exists and where to read it from at session
#           start.

set -euo pipefail

TOOL="${1:-claude}"
NAME="technical-learning-mentor"
REPO_URL="https://github.com/Matheus-Homem/technical-learning-mentor.git"

if [[ ! "$TOOL" =~ ^(claude|cursor)$ ]]; then
  echo "Usage: $0 <claude|cursor>" >&2
  exit 1
fi

if ! command -v git >/dev/null 2>&1; then
  echo "error: git is required" >&2
  exit 1
fi

case "$TOOL" in
  claude) SKILL_DIR=".claude/skills/$NAME"; COMMANDS_DIR=".claude/commands" ;;
  cursor) SKILL_DIR=".cursor/skills/$NAME"; COMMANDS_DIR=".cursor/commands" ;;
esac

mkdir -p "$(dirname "$SKILL_DIR")" "$COMMANDS_DIR"

if [ -d "$SKILL_DIR/.git" ]; then
  echo "$NAME already installed at $SKILL_DIR — updating..."
  git -C "$SKILL_DIR" pull --ff-only
else
  rm -rf "$SKILL_DIR"
  echo "cloning $NAME into $SKILL_DIR..."
  git clone --depth 1 "$REPO_URL" "$SKILL_DIR"
fi

echo "linking commands into $COMMANDS_DIR..."
cp "$SKILL_DIR"/commands/*.md "$COMMANDS_DIR"/

if [[ "$TOOL" == "cursor" ]]; then
  mkdir -p ".cursor/rules"
  cat > ".cursor/rules/$NAME.md" << EOF
---
description: Points the model at the $NAME skill. Cursor does not auto-load skill folders, so this rule exists to surface it.
alwaysApply: true
---

A skill called \`$NAME\` is installed at \`$SKILL_DIR/SKILL.md\`.
It governs how learning/mentoring requests and any \`/mentor-*\` command should be handled
in this repo. Read \`$SKILL_DIR/SKILL.md\` before acting on any request that matches its
description, and follow the referenced command/reference files as instructed there.
EOF
  echo "rule pointer -> .cursor/rules/$NAME.md (alwaysApply: true)"
  echo "NOTE: Cursor has no native skill auto-discovery. This rule is what makes the"
  echo "      model aware the skill exists. Verify project rules are enabled in your"
  echo "      Cursor settings."
fi

echo
echo "done. commands available: $(cd "$COMMANDS_DIR" && ls mentor-*.md | sed 's/\.md$//' | tr '\n' ' ')"
echo "run /mentor-map after your spec skill produces plan/design/tasks for a new activity."
