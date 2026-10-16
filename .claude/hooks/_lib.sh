#!/usr/bin/env bash
# Shared helpers for hooks. Works on Linux, macOS and Git Bash on Windows.
# Uses jq when available, falls back to sed for flat string fields.

HOOK_INPUT="$(cat)"

# json_field <jq-path> <flat-key>
# e.g. json_field '.tool_input.file_path' file_path
json_field() {
  if command -v jq >/dev/null 2>&1; then
    printf '%s' "$HOOK_INPUT" | jq -r "$1 // empty"
  else
    printf '%s' "$HOOK_INPUT" \
      | grep -o "\"$2\"[[:space:]]*:[[:space:]]*\"[^\"]*\"" \
      | head -n1 \
      | sed -E "s/^\"$2\"[[:space:]]*:[[:space:]]*\"(.*)\"$/\1/" \
      | sed 's#\\\\#/#g'
  fi
}

# json_bool <jq-path> <flat-key>  -> prints "true" or "false"
json_bool() {
  if command -v jq >/dev/null 2>&1; then
    printf '%s' "$HOOK_INPUT" | jq -r "$1 // false"
  elif printf '%s' "$HOOK_INPUT" | grep -q "\"$2\"[[:space:]]*:[[:space:]]*true"; then
    echo true
  else
    echo false
  fi
}

# Normalise Windows separators so pattern matching is uniform.
normalize_path() {
  printf '%s' "$1" | sed 's#\\#/#g'
}
