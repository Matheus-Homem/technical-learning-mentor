#!/usr/bin/env bash
# Installs the technical-learning-mentor skill into the current project.
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/Matheus-Homem/technical-learning-mentor/main/install.sh | bash
#
# Run from the root of the project you want the skill installed into.

set -euo pipefail

REPO_URL="https://github.com/Matheus-Homem/technical-learning-mentor.git"
SKILL_DIR=".claude/skills/technical-learning-mentor"
COMMANDS_DIR=".claude/commands"

if ! command -v git >/dev/null 2>&1; then
  echo "error: git is required" >&2
  exit 1
fi

mkdir -p "$(dirname "$SKILL_DIR")" "$COMMANDS_DIR"

if [ -d "$SKILL_DIR/.git" ]; then
  echo "technical-learning-mentor already installed at $SKILL_DIR — updating..."
  git -C "$SKILL_DIR" pull --ff-only
else
  rm -rf "$SKILL_DIR"
  echo "cloning technical-learning-mentor into $SKILL_DIR..."
  git clone --depth 1 "$REPO_URL" "$SKILL_DIR"
fi

echo "linking commands into $COMMANDS_DIR..."
cp "$SKILL_DIR"/commands/*.md "$COMMANDS_DIR"/

echo
echo "done. commands available: $(cd "$COMMANDS_DIR" && ls mentor-*.md | sed 's/\.md$//' | tr '\n' ' ')"
echo "run /mentor-map after your spec skill produces plan/design/tasks for a new activity."
