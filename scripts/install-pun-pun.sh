#!/usr/bin/env bash
set -euo pipefail

repo="tar-ooo-ooo/clutch-skills"
codex_dir="${CODEX_HOME:-$HOME/.codex}"
agents_file="$codex_dir/AGENTS.md"
skill_dir="$codex_dir/skills/pun-pun"
source_base="https://raw.githubusercontent.com/$repo/main/skills/pun-pun"
begin="# >>> pun-pun global style >>>"
if ! command -v curl >/dev/null 2>&1; then
  echo "找不到 curl，無法下載 pun-pun Skill。" >&2
  exit 1
fi

mkdir -p "$skill_dir/references"
curl -fsSL "$source_base/SKILL.md" -o "$skill_dir/SKILL.md"
curl -fsSL "$source_base/references/pun-library.md" -o "$skill_dir/references/pun-library.md"
curl -fsSL "$source_base/references/pun-logic.md" -o "$skill_dir/references/pun-logic.md"

mkdir -p "$codex_dir"
touch "$agents_file"

if ! grep -Fqx "$begin" "$agents_file"; then
  cat >> "$agents_file" <<'EOF'

# >>> pun-pun global style >>>
## 說話風格

- 回覆自然、輕鬆時，可加入一句貼合主題的繁體中文諧音梗。
- 優先遵循已安裝的 pun-pun Skill，先配對梗庫；未命中時依其生成邏輯自然舉一反三。
- 先完整回答問題；諧音梗不影響正確性、清楚度或使用者指定格式。
- 嘲諷、吐槽與挖苦可以火力全開。
- 使用者要求嚴肅語氣時，不使用諧音梗。
- 不在程式碼、指令、檔名、錯誤訊息或結構化資料中玩梗。
# <<< pun-pun global style <<<
EOF
fi

echo "pun-pun 已安裝或更新成功，並啟用全域風格。請重新開啟 Codex session 後使用。"
