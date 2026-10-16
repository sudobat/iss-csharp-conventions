#!/usr/bin/env bash
# Stop: if C# sources changed, run `dotnet build`. On failure, exit 2 so
# Claude keeps working and fixes the errors before finishing.
#
# Build target: $ISS_BUILD_TARGET if set (path to .sln/.slnx/.csproj),
# otherwise the single solution file at the project root.
# Set ISS_SKIP_BUILD_ON_STOP=1 to disable.

source "$(dirname "$0")/_lib.sh"

[ "${ISS_SKIP_BUILD_ON_STOP:-0}" = "1" ] && exit 0
# Avoid loops: if we already blocked once in this stop cycle, let it stop.
[ "$(json_bool '.stop_hook_active' stop_hook_active)" = "true" ] && exit 0
command -v dotnet >/dev/null 2>&1 || exit 0

root="${CLAUDE_PROJECT_DIR:-$(pwd)}"
cd "$root" || exit 0

# Only build when C#/project files changed (skip for pure Q&A sessions).
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  changed="$(git status --porcelain -- '*.cs' '*.csproj' '*.props' '*.targets' '*.razor' '*.sln' '*.slnx' 2>/dev/null)"
  [ -z "$changed" ] && exit 0
fi

target="${ISS_BUILD_TARGET:-}"
if [ -z "$target" ]; then
  slns=()
  for f in *.sln *.slnx; do [ -f "$f" ] && slns+=("$f"); done
  if [ "${#slns[@]}" -eq 1 ]; then
    target="${slns[0]}"
  elif [ "${#slns[@]}" -gt 1 ]; then
    echo "build-on-stop: multiple solutions found; set ISS_BUILD_TARGET in .claude/settings.local.json env." >&2
    exit 0
  else
    exit 0
  fi
fi

if ! out="$(dotnet build "$target" -nologo -v q -clp:ErrorsOnly 2>&1)"; then
  {
    echo "dotnet build failed for $target. Fix these errors before finishing:"
    echo "$out" | grep -E 'error [A-Z]+[0-9]+' | sort -u | head -n 40
  } >&2
  exit 2
fi

exit 0
