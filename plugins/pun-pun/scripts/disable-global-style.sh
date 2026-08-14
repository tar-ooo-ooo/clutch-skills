#!/usr/bin/env bash
set -euo pipefail
if [[ "${1:-}" != "--yes" ]]; then
  echo "此指令只會從 ~/.codex/AGENTS.md 移除 pun-pun 的風格區塊。"
  echo "確認使用者同意後，請加上 --yes 重新執行。"
  exit 2
fi
codex_dir="${CODEX_HOME:-$HOME/.codex}"
agents_file="$codex_dir/AGENTS.md"
begin="# >>> pun-pun global style >>>"
end="# <<< pun-pun global style <<<"
if [[ ! -f "$agents_file" ]] || ! grep -Fqx "$begin" "$agents_file"; then
  echo "pun-pun 全域風格尚未啟用：$agents_file"
  exit 0
fi
tmp_file="$(mktemp "${TMPDIR:-/tmp}/pun-pun-agents.XXXXXX")"
awk -v begin="$begin" -v end="$end" '
  $0 == begin { removing = 1; next }
  $0 == end { removing = 0; next }
  !removing { print }
' "$agents_file" > "$tmp_file"
mv "$tmp_file" "$agents_file"
echo "已停用 pun-pun 全域風格：$agents_file"
