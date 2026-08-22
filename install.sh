#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_DIR="$REPO_DIR/skills"

TARGETS=(
  "$HOME/.claude/skills"
  "$HOME/.codex/skills"
  "$HOME/.agents/skills"
)

shopt -s nullglob
skills=("$SKILLS_DIR"/*/)

if [ ${#skills[@]} -eq 0 ]; then
  echo "No skills found in $SKILLS_DIR"
  exit 0
fi

link_into() {
  local src="$1" link="$2"
  if [ -L "$link" ]; then
    ln -sfn "$src" "$link"
    echo "updated  $link"
  elif [ -e "$link" ]; then
    echo "skipped  $link (exists and is not a symlink — remove it manually to manage it from this repo)"
  else
    ln -s "$src" "$link"
    echo "linked   $link"
  fi
}

for target in "${TARGETS[@]}"; do
  mkdir -p "$target"
  for skill_path in "${skills[@]}"; do
    link_into "${skill_path%/}" "$target/$(basename "$skill_path")"
  done
done

mkdir -p "$HOME/.claude"
link_into "$REPO_DIR/config/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
