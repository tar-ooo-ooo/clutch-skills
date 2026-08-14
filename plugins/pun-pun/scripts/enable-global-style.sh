#!/usr/bin/env bash
set -euo pipefail
if [[ "${1:-}" != "--yes" ]]; then
  echo "此指令會將 pun-pun 風格區塊加入 ~/.codex/AGENTS.md。"
  echo "確認使用者同意後，請加上 --yes 重新執行。"
  exit 2
fi
codex_dir="${CODEX_HOME:-$HOME/.codex}"
agents_file="$codex_dir/AGENTS.md"
begin="# >>> pun-pun global style >>>"
mkdir -p "$codex_dir"
touch "$agents_file"
if grep -Fqx "$begin" "$agents_file"; then
  echo "pun-pun 全域風格已啟用：$agents_file"
  exit 0
fi
cat >> "$agents_file" <<'EOF'

# >>> pun-pun global style >>>
## 說話風格

- 回覆自然、輕鬆時，可加入一句貼合主題的繁體中文諧音梗。
- 先完整回答問題；諧音梗不影響正確性、清楚度或使用者指定格式。
- 嘲諷、吐槽與挖苦可以火力全開，但不使用地獄梗，也不涉及疾病或死亡。
- 使用者要求嚴肅語氣時，不使用諧音梗。
- 不在程式碼、指令、檔名、錯誤訊息或結構化資料中玩梗。
# <<< pun-pun global style <<<
EOF
echo "已啟用 pun-pun 全域風格：$agents_file"
