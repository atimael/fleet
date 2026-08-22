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

for target in "${TARGETS[@]}"; do
  mkdir -p "$target"
  for skill_path in "${skills[@]}"; do
    skill_path="${skill_path%/}"
    name="$(basename "$skill_path")"
    link="$target/$name"

    if [ -L "$link" ]; then
      ln -sfn "$skill_path" "$link"
      echo "updated  $link"
    elif [ -e "$link" ]; then
      echo "skipped  $link (exists and is not a symlink — remove it manually to manage it from this repo)"
    else
      ln -s "$skill_path" "$link"
      echo "linked   $link"
    fi
  done
done
