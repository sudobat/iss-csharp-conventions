#!/usr/bin/env bash
# PreToolUse (Edit|Write|MultiEdit): during /tdd-task GREEN and REFACTOR,
# block edits to the end-to-end tests approved in RED.
# Locked files are listed in .claude/state/tdd-lock (sha256sum format).

source "$(dirname "$0")/_lib.sh"

root="$(normalize_path "${CLAUDE_PROJECT_DIR:-$(pwd)}")"
lock="$root/.claude/state/tdd-lock"
[ -f "$lock" ] || exit 0

file="$(normalize_path "$(json_field '.tool_input.file_path' file_path)")"
[ -z "$file" ] && exit 0
rel="${file#"$root"/}"

# sha256sum lines: "<hash>  <path>" (binary mode: "<hash> *<path>").
while IFS= read -r line; do
  locked="$(normalize_path "$(printf '%s' "$line" | sed -E 's/^[0-9a-f]+[[:space:]]+\*?//')")"
  locked="${locked#./}"
  if [ "$rel" = "$locked" ] || [ "$file" = "$locked" ]; then
    echo "Blocked edit to '$rel': it is a locked RED test for the current /tdd-task. If the test is wrong, stop and report it; the user must approve unlocking it." >&2
    exit 2
  fi
done < "$lock"

exit 0
