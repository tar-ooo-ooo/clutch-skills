#!/usr/bin/env bash
set -euo pipefail
if [[ "${1:-}" != "--yes" ]]; then
  echo "This command removes only the pun-pun block from ~/.codex/AGENTS.md."
  echo "Review and confirm with the user, then rerun with --yes."
  exit 2
fi
codex_dir="${CODEX_HOME:-$HOME/.codex}"
agents_file="$codex_dir/AGENTS.md"
begin="# >>> pun-pun global style >>>"
end="# <<< pun-pun global style <<<"
if [[ ! -f "$agents_file" ]] || ! grep -Fqx "$begin" "$agents_file"; then
  echo "pun-pun global style is not enabled in $agents_file"
  exit 0
fi
tmp_file="$(mktemp "${TMPDIR:-/tmp}/pun-pun-agents.XXXXXX")"
awk -v begin="$begin" -v end="$end" '
  $0 == begin { removing = 1; next }
  $0 == end { removing = 0; next }
  !removing { print }
' "$agents_file" > "$tmp_file"
mv "$tmp_file" "$agents_file"
echo "Disabled pun-pun global style in $agents_file"
