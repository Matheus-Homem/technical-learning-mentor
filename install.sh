#!/usr/bin/env bash
# Installs the technical-learning-mentor skill into the current project, for Claude Code or Cursor.
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/Matheus-Homem/technical-learning-mentor/main/install.sh | bash -s -- claude
#   curl -fsSL https://raw.githubusercontent.com/Matheus-Homem/technical-learning-mentor/main/install.sh | bash -s -- cursor
#
# Flags (optional, skip the interactive prompt):
#   --with-design-pairing   install the DESIGN pairing rule without asking
#   --no-design-pairing     skip the DESIGN pairing rule without asking
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
#
# The DESIGN pairing rule is the one part of this installer that writes OUTSIDE the
# skill's own directory, and the one part that changes how OTHER skills behave. It is
# therefore opt-in: the installer explains it and asks, and never installs it by default.

set -euo pipefail

NAME="technical-learning-mentor"
REPO_URL="${MENTOR_REPO_URL:-https://github.com/Matheus-Homem/technical-learning-mentor.git}"
BEGIN_MARKER="<!-- BEGIN $NAME -->"
END_MARKER="<!-- END $NAME -->"

TOOL=""
PAIRING_CHOICE=""   # "", "yes", "no"

for arg in "$@"; do
  case "$arg" in
    claude|cursor)          TOOL="$arg" ;;
    --with-design-pairing)  PAIRING_CHOICE="yes" ;;
    --no-design-pairing)    PAIRING_CHOICE="no" ;;
    *)
      echo "Usage: $0 <claude|cursor> [--with-design-pairing|--no-design-pairing]" >&2
      exit 1
      ;;
  esac
done

TOOL="${TOOL:-claude}"

if ! command -v git >/dev/null 2>&1; then
  echo "error: git is required" >&2
  exit 1
fi

case "$TOOL" in
  claude) SKILL_DIR=".claude/skills/$NAME"; COMMANDS_DIR=".claude/commands"; PAIRING_DIR=".claude" ;;
  cursor) SKILL_DIR=".cursor/skills/$NAME"; COMMANDS_DIR=".cursor/commands"; PAIRING_DIR=".cursor" ;;
esac

PAIRING_FILE="$PAIRING_DIR/mentor-design-pairing.md"

# ---------------------------------------------------------------- skill + commands

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
# Remove stale mentor-* commands first. A plain copy would leave behind any
# command that was renamed or dropped upstream, as a slash command pointing at
# a procedure that no longer exists.
rm -f "$COMMANDS_DIR"/mentor-*.md
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

# ---------------------------------------------------------------- design pairing rule

# Where the loader lives, per tool. A file dropped in .claude/ is read by nothing on its
# own, so for Claude Code the rule is surfaced through a delimited import block in the
# project's CLAUDE.md. Cursor has alwaysApply rules, which do the same job natively.
case "$TOOL" in
  claude) LOADER_PATH="CLAUDE.md" ;;
  cursor) LOADER_PATH=".cursor/rules/mentor-design-pairing.md" ;;
esac

pairing_already_installed() {
  [ -f "$PAIRING_FILE" ] && [ -f "$LOADER_PATH" ] && grep -qF "$BEGIN_MARKER" "$LOADER_PATH" 2>/dev/null
}

show_pairing_notice() {
  cat <<'NOTICE'

────────────────────────────────────────────────────────────────────────
  OPTIONAL: DESIGN pairing rule

  WHAT IT DOES
    Stops any spec-driven skill from generating the design and the task
    list fully automatically. It requires you to review and approve the
    structure, and then the tasks, before the design file is written.

NOTICE
  cat <<NOTICE
  WHAT IT CHANGES IN YOUR PROJECT
    creates  $PAIRING_FILE
    edits    $LOADER_PATH  (adds 3 lines between markers, at the end)

NOTICE
  cat <<'NOTICE'
  CONSEQUENCES
    - Applies to EVERY skill in this repository, not just the mentor.
    - It is loaded every session, so the rule is always active.
    - Your DESIGN phase gains two stop points that wait on you.
    - To remove it: delete the block between the markers.
────────────────────────────────────────────────────────────────────────

NOTICE
}

write_pairing_files() {
  mkdir -p "$PAIRING_DIR"
  cp "$SKILL_DIR/templates/design-pairing.md" "$PAIRING_FILE"

  case "$TOOL" in
    claude)
      local block
      block="$BEGIN_MARKER
@$PAIRING_FILE
$END_MARKER"

      if [ -f "$LOADER_PATH" ] && grep -qF "$BEGIN_MARKER" "$LOADER_PATH"; then
        # Replace only what sits between the markers. Everything else in the
        # user's CLAUDE.md is left byte-for-byte alone.
        awk -v begin="$BEGIN_MARKER" -v end="$END_MARKER" -v file="$PAIRING_FILE" '
          $0 == begin { print; print "@" file; skip = 1; next }
          $0 == end   { print; skip = 0; next }
          !skip       { print }
        ' "$LOADER_PATH" > "$LOADER_PATH.tmp" && mv "$LOADER_PATH.tmp" "$LOADER_PATH"
        echo "design pairing rule was already installed — refreshed in $LOADER_PATH"
      else
        if [ -f "$LOADER_PATH" ] && [ -s "$LOADER_PATH" ]; then
          printf '\n' >> "$LOADER_PATH"
        fi
        printf '%s\n' "$block" >> "$LOADER_PATH"
        echo "design pairing rule -> $PAIRING_FILE (imported from $LOADER_PATH)"
      fi
      ;;
    cursor)
      mkdir -p ".cursor/rules"
      cat > "$LOADER_PATH" <<EOF
---
description: Requires the DESIGN phase of any spec-driven workflow to be paired with the user rather than fully automated.
alwaysApply: true
---

$BEGIN_MARKER
Read \`$PAIRING_FILE\` and follow it for the DESIGN phase of any spec-driven
workflow in this repository. It applies to every skill here, not just the mentor.
$END_MARKER
EOF
      echo "design pairing rule -> $PAIRING_FILE (alwaysApply rule at $LOADER_PATH)"
      ;;
  esac
}

show_pairing_diff() {
  echo "  these lines will be added to $LOADER_PATH:"
  echo
  printf '    %s\n' "$BEGIN_MARKER"
  printf '    @%s\n' "$PAIRING_FILE"
  printf '    %s\n' "$END_MARKER"
  echo
}

install_design_pairing() {
  # Already installed: refresh silently, never re-ask. Re-asking on every update
  # would train the user to say yes without reading, which defeats the prompt.
  if pairing_already_installed; then
    write_pairing_files
    return
  fi

  case "$PAIRING_CHOICE" in
    yes) write_pairing_files; return ;;
    no)  echo "design pairing rule: skipped (--no-design-pairing)"; return ;;
  esac

  show_pairing_notice

  # This script is normally run as `curl ... | bash`, so stdin is the script
  # itself, not the terminal. Reading from /dev/tty is what makes the prompt
  # actually reach the user. With no tty there is nobody to ask, and silence is
  # never taken as consent.
  if [ ! -r /dev/tty ]; then
    echo "design pairing rule: skipped — no terminal available to ask."
    echo "  re-run with --with-design-pairing to install it non-interactively."
    return
  fi

  if [ "$TOOL" == "claude" ]; then
    show_pairing_diff
  fi

  local answer=""
  printf '  Install the DESIGN pairing rule? [y/N] '
  read -r answer < /dev/tty || answer=""
  echo

  case "$answer" in
    y|Y|s|S|yes|YES|sim|SIM)
      write_pairing_files
      ;;
    *)
      echo "design pairing rule: not installed. Nothing outside the skill directory was touched."
      echo "  to add it later: re-run this installer, or with --with-design-pairing."
      ;;
  esac
}

install_design_pairing

# ---------------------------------------------------------------- done

echo
echo "done. commands available: $(cd "$COMMANDS_DIR" && ls mentor-*.md | sed 's/\.md$//' | tr '\n' ' ')"
echo "run /mentor-sync first to pull your knowledge state, then /mentor-map on a feature."
