#!/usr/bin/env bash
set -euo pipefail

repo="tar-ooo-ooo/clutch-skills"
marketplace="clutch-skills"
plugin="pun-pun"
codex_dir="${CODEX_HOME:-$HOME/.codex}"
agents_file="$codex_dir/AGENTS.md"
begin="# >>> pun-pun global style >>>"
is_update=false

if ! command -v codex >/dev/null 2>&1; then
  echo "找不到 Codex CLI。請先安裝 Codex，再重新執行此指令。" >&2
  exit 1
fi

if ! codex plugin marketplace list | grep -Fq "Marketplace \`$marketplace\`"; then
  codex plugin marketplace add "$repo" --ref main
else
  is_update=true
  codex plugin marketplace upgrade "$marketplace"
fi

codex plugin add "$plugin@$marketplace"

mkdir -p "$codex_dir"
touch "$agents_file"

if ! grep -Fqx "$begin" "$agents_file"; then
  cat >> "$agents_file" <<'EOF'

# >>> pun-pun global style >>>
## 說話風格

- 回覆自然、輕鬆時，可加入一句貼合主題的繁體中文諧音梗。
- 先完整回答問題；諧音梗不影響正確性、清楚度或使用者指定格式。
- 嘲諷、吐槽與挖苦可以火力全開。
- 使用者要求嚴肅語氣時，不使用諧音梗。
- 不在程式碼、指令、檔名、錯誤訊息或結構化資料中玩梗。
# <<< pun-pun global style <<<
EOF
fi

if [[ "$is_update" == true ]]; then
  echo "pun-pun 已更新成功，並持續套用全域風格。請重新開啟 Codex session 後使用。"
else
  echo "pun-pun 已安裝成功並啟用全域風格。請重新開啟 Codex session 後使用。"
fi
