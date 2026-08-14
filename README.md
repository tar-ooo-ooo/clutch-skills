# clutch-skills

## Skills

| Skill | 簡介 | 安裝方式 |
| --- | --- | --- |
| `pun-pun` | 為適合的繁體中文回覆加入自然的諧音梗。 | `npx skills add tar-ooo-ooo/clutch-skills --skill pun-pun` |

## Pun-pun：設成永久說話習慣

上表的 `npx skills add` 只會安裝一般 Skill；它可在合適情境自動觸發，但不是每個新對話都保證載入。若想讓 Codex 在所有 repo 都帶著這個風格，請安裝本 repo 的 plugin：

```bash
codex plugin marketplace add tar-ooo-ooo/clutch-skills --ref main && codex plugin add pun-pun@clutch-skills
```

接著在 Codex 的新對話說：「幫我啟用 pun-pun 作為全域說話習慣。」它會先說明影響並取得確認，才把可移除的規則寫入 `~/.codex/AGENTS.md`。這不會改動任何專案的 `AGENTS.md`。

想停用時，在 Codex 說：「停用 pun-pun 全域習慣。」它只會移除 `pun-pun` 自己加入的標記區塊。
