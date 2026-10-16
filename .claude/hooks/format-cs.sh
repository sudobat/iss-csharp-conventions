#!/usr/bin/env bash
# PostToolUse (Edit|Write|MultiEdit): format the edited .cs file with
# `dotnet format whitespace` in folder mode, honouring .editorconfig.
# Folder mode needs no project/solution load, so it stays fast.
# Never blocks: formatting failures are reported but do not stop Claude.

source "$(dirname "$0")/_lib.sh"

file="$(normalize_path "$(json_field '.tool_input.file_path' file_path)")"
case "$file" in
  *.cs) ;;
  *) exit 0 ;;
esac
[ -f "$file" ] || exit 0
command -v dotnet >/dev/null 2>&1 || exit 0

root="$(normalize_path "${CLAUDE_PROJECT_DIR:-$(pwd)}")"
rel="${file#"$root"/}"

if ! out="$(cd "$root" && dotnet format whitespace . --folder --include "$rel" 2>&1)"; then
  echo "dotnet format failed on $rel (non-blocking):" >&2
  echo "$out" | tail -n 20 >&2
fi

exit 0
