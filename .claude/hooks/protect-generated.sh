#!/usr/bin/env bash
# PreToolUse (Edit|Write|MultiEdit): block edits to generated or sensitive files.
# Exit 2 blocks the tool call and feeds stderr back to Claude.

source "$(dirname "$0")/_lib.sh"

file="$(normalize_path "$(json_field '.tool_input.file_path' file_path)")"
[ -z "$file" ] && exit 0

reason=""
case "$file" in
  */bin/*|*/obj/*)                 reason="build output (bin/obj)" ;;
  *.Designer.cs|*.designer.cs)     reason="designer-generated file" ;;
  *.g.cs|*.g.i.cs)                 reason="source-generated file" ;;
  *ModelSnapshot.cs)               reason="EF Core model snapshot; use 'dotnet ef migrations add/remove'" ;;
  */.env|*/.env.*)                 reason="environment/secrets file" ;;
  *.pfx|*.snk)                     reason="key/certificate file" ;;
  */packages.lock.json)            reason="NuGet lock file; use 'dotnet restore --force-evaluate'" ;;
esac

if [ -n "$reason" ]; then
  echo "Blocked edit to '$file': $reason. Regenerate it with the proper tool or ask the user." >&2
  exit 2
fi

exit 0
