---
name: subagent-dad
description: 「Subagent 的爸爸」：在每一個會修改檔案或外部狀態的工具或 API 呼叫前，顯示主 Agent 與所有已知 subagent 的實際狀態，以及有來源的最近指派項目。適用於程式、設定、資料、Git、PR、Issue、訊息、排程與部署等 mutation；純讀取或一般問答不套用。
---

# Subagent 的爸爸

在執行任何 mutation 前，讓使用者看見這次 runtime 實際回傳的 agent 狀態與可追溯的工作指派。agent 名稱、數量與狀態必須來自目前的 agent inventory，不可猜測、沿用前一次結果或寫死角色；inventory 沒有提供的執行項目也不可自行補完。

## 何時觸發

在下列每一個會變更狀態的工具或 API 呼叫之前觸發，不可把多個寫入包成一個 batch 後只顯示一次：

- 建立、修改、移動或刪除檔案與設定。
- 格式化、產生檔案、安裝或移除套件、執行會寫入的 migration。
- Git add、commit、push、建立或修改 PR／Issue。
- 傳送訊息、建立或修改排程、部署，或任何會持久化外部系統狀態的動作。

純粹讀取、搜尋、規劃、解釋或診斷不需要觸發。

## 資料定義

- **實際狀態**：在該 mutation 前即時查詢 agent inventory 所得的狀態，並記錄查詢來源與時間。
- **本次 agent 清單**：本次 inventory 回傳的每一個 agent。快照必須逐一列出它們的原始名稱；不可加入 inventory 沒有回傳的角色，也不可省略已回傳的 agent。
- **最近明確指派項目**：最後一次由使用者、主 Agent 或該 subagent 明確傳達的工作；要附上來源與記錄時間。它不是由 inventory 推斷出的「目前正在做什麼」。
- inventory 若沒有可靠的工作項目資料，或沒有可追溯的明確指派，工作項目一律寫 `unknown`。

## 執行方式

1. **每一個 mutation 前**，以目前環境提供的 agent inventory 查詢工具取得實際狀態與本次 agent 清單，例如 `collaboration.list_agents`。不要重用上一個 mutation 的快照，即使它們在同一個 shell command、批次或回覆中。
2. 對 inventory 回傳的每一個 agent，查找其最近一次可追溯的明確指派，例如使用者請求、主 Agent 的指派訊息或 agent 自己回報的工作項目；不要從 agent 名稱、角色、過去範例或狀態推論目的。
3. 在 commentary 逐一顯示本次 agent 清單中的名稱、實際狀態、最近明確指派項目、指派來源和查詢／記錄時間。agent inventory 或指派資料缺少時，顯示 `unknown`；只有這次 inventory 明確沒有 subagent 時才顯示 `subagents: none`。
4. 狀態查詢失敗、不可用或結果無法辨識時，回報原因並暫停該 mutation；不要假裝沒有 subagent 後繼續寫入。
5. 若由 subagent 執行 mutation，subagent 必須先把要執行的**單一、明確 mutation**交由主 Agent；主 Agent 取得新快照、在 commentary 顯示後，才可授權該 subagent 執行那一個動作。下一個 mutation 必須重新走完此流程。無法取得主 Agent 授權時，subagent 只能做讀取與分析，不能寫入共享 workspace 或外部系統。
6. 每次 mutation 完成後，下一個 mutation 仍要重新查詢；若 spawn、完成、阻擋或中斷 agent，該資訊也必須反映在下一張快照。
7. mutation 完成時，若本次有 agent 參與，在最終回覆附上精簡狀態快照。

## 回報格式

使用簡短、可掃讀的格式，不輸出原始工具結果、prompt 內容或秘密值：

```text
Agent status — pre-mutation
inventory: <查詢工具> at <查詢時間>
- <inventory 回傳的主 Agent 名稱>: <實際狀態> — assignment: <最近明確指派或 unknown> (source: <來源或 unknown>, recorded: <時間或 unknown>)
- <inventory 回傳的 subagent 名稱>: <實際狀態> — assignment: <最近明確指派或 unknown> (source: <來源或 unknown>, recorded: <時間或 unknown>)
- <為本次 inventory 的每一個其餘 agent 重複上一列>
```

沒有 subagent 時也要明確顯示：

```text
Agent status — pre-mutation
inventory: <查詢工具> at <查詢時間>
- <inventory 回傳的主 Agent 名稱>: <實際狀態> — assignment: <最近明確指派或 unknown> (source: <來源或 unknown>, recorded: <時間或 unknown>)
- subagents: none (由本次 inventory 確認)
```

狀態可用值優先使用 `running`、`done`、`blocked` 或 `idle`。不要把尚未查詢、失敗或無法判定的情況標示為 `idle`；應明確寫出 `unknown` 或 `unavailable`。
