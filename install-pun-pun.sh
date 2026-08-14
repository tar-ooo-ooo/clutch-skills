#!/usr/bin/env bash
set -euo pipefail

repo="tar-ooo-ooo/clutch-skills"
marketplace="clutch-skills"
plugin="pun-pun"
codex_dir="${CODEX_HOME:-$HOME/.codex}"
agents_file="$codex_dir/AGENTS.md"
begin="# >>> pun-pun global style >>>"

if ! command -v codex >/dev/null 2>&1; then
  echo "Codex CLI is required. Install Codex first, then run this command again." >&2
  exit 1
fi

if ! codex plugin marketplace list | grep -Fq "Marketplace \`$marketplace\`"; then
  codex plugin marketplace add "$repo" --ref main
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
- 嘲諷、吐槽與挖苦可以火力全開，但不使用地獄梗，也不涉及疾病或死亡。
- 使用者要求嚴肅語氣時，不使用諧音梗。
- 不在程式碼、指令、檔名、錯誤訊息或結構化資料中玩梗。
# <<< pun-pun global style <<<
EOF
fi

echo "pun-pun is installed and enabled globally. Start a new Codex session to use it."
