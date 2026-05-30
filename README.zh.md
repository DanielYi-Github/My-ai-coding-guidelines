# AI 程式編碼指引 — 通用 AI Vibe Coding 規則集

> **一份文件，適用所有 AI 開發工具，Clone 後零設定。**

[English](./README.md) | 繁體中文

---

## 這是什麼？

這個 Repository 是一份 **AI 編碼行為的單一真相來源**，整合了四套經過實戰驗證的開源系統：

- **[Karpathy Guidelines](https://github.com/multica-ai/andrej-karpathy-skills)** — 行為準則，源自 Andrej Karpathy 對 LLM 編碼缺陷的觀察：寫程式前先思考、保持簡潔、精準修改、定義可驗證的目標。
- **[RTK（Rust Token Killer）](https://github.com/rtk-ai/rtk)** — Token 優化規則，在常用 Shell 指令上將 LLM context 消耗降低 60–90%。
- **[superpowers](https://github.com/obra/superpowers)** — 方法論層：結構化工作流程、TDD 紀律、多 agent 協作框架。
- **[gstack](https://github.com/garrytan/gstack)** — 23 個專用 slash command，覆蓋從產品策略到部署監控的完整開發生命週期。

所有規則都存放在 `CLAUDE.md` 這一個檔案中。其他工具專用的設定檔全都是指向它的符號連結，所以你只需要編輯一個地方。

---

## 支援的 AI 開發工具

| 工具 | 設定檔位置 | 方式 |
|---|---|---|
| **Claude Code** | `CLAUDE.md` | 自動讀取 |
| **GitHub Copilot（VS Code）** | `.github/copilot-instructions.md` | 符號連結 |
| **Codex（OpenAI）** | `AGENTS.md` | 符號連結 |
| **Cursor** | `.cursor/rules/ai-guidelines.mdc` | 符號連結 |
| **Windsurf** | `.windsurfrules` | 符號連結 |
| **Cline / Roo Code** | `.clinerules` | 符號連結 |
| **Google Antigravity** | `.agents/rules/antigravity-rtk-rules.md` | 符號連結 |
| **Kilo Code** | `.kilocode/rules/ai-guidelines.md` | 符號連結 |
| **Claude Desktop** | `CLAUDE.md` | 自動讀取 |

---

## 快速開始

### 方法 A — 使用此 Repo 作為 Template

在 GitHub 上點選 **「Use this template」**，Clone 你的新 Repo。所有符號連結已預先設定好，不需要任何額外操作。

### 方法 B — 加入現有專案

```bash
# 1. 下載 CLAUDE.md 到你的專案根目錄
curl -o CLAUDE.md https://raw.githubusercontent.com/<your-username>/ai-coding-guidelines/main/CLAUDE.md

# 2. 執行安裝腳本，建立所有符號連結
curl -o setup.sh https://raw.githubusercontent.com/<your-username>/ai-coding-guidelines/main/setup.sh
chmod +x setup.sh && ./setup.sh

# 3. （可選但強烈建議）安裝 RTK 以獲得真實的 Token 節省
brew install rtk               # macOS
rtk init -g                    # Claude Code / Copilot
rtk init --agent antigravity   # Google Antigravity
```

### Windows 使用者

```bat
# 以「系統管理員」身份執行 setup.bat 可建立符號連結
# 一般使用者執行則會改為複製檔案
setup.bat
```

---

## AnySearch：自動網路搜尋

本專案預設整合了 **[AnySearch](https://www.anysearch.com/docs)** 作為所有 AI 工具的搜尋引擎。當 AI 需要查詢網路資訊時，會自動使用 AnySearch，而非直接呼叫 WebFetch——拿到的是預先融合、品質評分的精煉摘要，節省 60–80% Token。

**不需要任何提示詞**。行為規則已寫入 `CLAUDE.md`，MCP 設定已預先配置在專案檔案中。

### 已預設配置的檔案

| 檔案 | 工具 | 方式 |
|---|---|---|
| `.claude/settings.json` | Claude Code | Streamable HTTP（原生支援）|
| `.cursor/mcp.json` | Cursor | stdio 透過 `mcp-remote` |
| `.vscode/mcp.json` | VS Code Copilot | stdio 透過 `mcp-remote` |
| `~/.codeium/windsurf/mcp_config.json` | Windsurf | SSE（由 `setup.sh` 寫入）|
| `~/.claude/skills/anysearch` | Claude Code | SKILL 套件 |
| `.skills/anysearch` | Cursor / Windsurf | SKILL 套件 |

### API Key 設定（可選，建議設定）

無 Key 時自動使用匿名存取（IP 限流），足夠日常開發。要提高限額：

```bash
# 加入 ~/.zshrc 或 ~/.bashrc
export ANYSEARCH_API_KEY=your_key_here
```

在 [anysearch.com](https://www.anysearch.com) 申請 Key。

### 手動 MCP 設定（未使用 setup.sh 時）

**Windsurf** — 需要先啟動 SSE Proxy：
```bash
npx -y supergateway \
  --streamableHttp https://api.anysearch.com/mcp \
  --outputTransport sse --port 8000 \
  --oauth2Bearer $ANYSEARCH_API_KEY

# ~/.codeium/windsurf/mcp_config.json
{
  "mcpServers": {
    "anysearch": { "serverUrl": "http://localhost:8000/sse" }
  }
}
```

**Codex / Factory Droid / Gemini CLI / OpenCode** — 請參照 [anysearch.com/docs](https://www.anysearch.com/docs) 的各平台 MCP 安裝說明，完成後 `CLAUDE.md` 的行為規則會自動觸發。

---

## 系統開發流程

本專案定義了一套 **9-Phase 開發生命週期**，建立在三層架構之上：

| 層次 | 工具 | 職責 |
|---|---|---|
| 方法論層 | [superpowers](https://github.com/obra/superpowers) | 如何思考與工作——決策框架、TDD 紀律、多 agent 協作 |
| 工具層 | [gstack](https://github.com/garrytan/gstack) | 每個階段用什麼——23 個專用 slash command |
| 基礎設施層 | [anthropics/skills](https://github.com/anthropics/skills) | 技能格式標準——封裝並分發可重用工作流程 |

**核心原則**：在任何兩者共存的 Phase 中，**superpowers 先執行（決策）→ gstack 後執行（行動）**。兩者互補，不可互換。

### 安裝工作流程三層工具

#### Claude Code（完整支援）

```bash
# superpowers
/plugin install superpowers@claude-plugins-official

# gstack
git clone --single-branch --depth 1 https://github.com/garrytan/gstack.git ~/gstack
cd ~/gstack && ./setup

# anthropics/skills
/plugin marketplace add anthropics/skills
```

#### Codex CLI

```bash
# superpowers — 開啟 plugin 介面
/plugins  # 搜尋 "superpowers" → 安裝

# gstack
git clone --single-branch --depth 1 https://github.com/garrytan/gstack.git ~/gstack
cd ~/gstack && ./setup --host codex
```

#### Cursor

```bash
# superpowers
/add-plugin superpowers
# 或在 plugin marketplace 搜尋 "superpowers"

# gstack
git clone --single-branch --depth 1 https://github.com/garrytan/gstack.git ~/gstack
cd ~/gstack && ./setup --host cursor
```

#### Gemini CLI

```bash
# superpowers
gemini extensions install https://github.com/obra/superpowers

# gstack（自動偵測）
git clone --single-branch --depth 1 https://github.com/garrytan/gstack.git ~/gstack
cd ~/gstack && ./setup
```

#### GitHub Copilot CLI

```bash
# superpowers
copilot plugin marketplace add obra/superpowers-marketplace
copilot plugin install superpowers@superpowers-marketplace

# gstack
git clone --single-branch --depth 1 https://github.com/garrytan/gstack.git ~/gstack
cd ~/gstack && ./setup
```

#### Factory Droid

```bash
# superpowers
droid plugin marketplace add https://github.com/obra/superpowers
droid plugin install superpowers@superpowers

# gstack
git clone --single-branch --depth 1 https://github.com/garrytan/gstack.git ~/gstack
cd ~/gstack && ./setup --host factory
```

> **Windsurf / Cline / Roo Code**：superpowers 目前無官方整合。請將下方 9-Phase 流程表當作 checklist 手動執行。

---

### 9-Phase 開發生命週期

每個 Phase 都有隱含的驗收標準，完成後才進入下一個。

| Phase | 目標 | superpowers 指令 | gstack 指令 |
|---|---|---|---|
| **0. 工作空間** | 隔離分支，不污染主線 | `using-git-worktrees` | — |
| **1. 產品策略** | 確認解決正確問題 | `brainstorming` | `/office-hours` → `/plan-ceo-review` |
| **2. 技術架構** | 鎖定架構決策，拆解任務 | `writing-plans` | `/plan-eng-review` → `/plan-devex-review` |
| **3. 設計** | 視覺與 UX 在寫 code 前定案 | — | `/plan-design-review` → `/design-consultation` → `/design-shotgun` → `/design-html` |
| **4. 安全前置** | 建構前先知道所有風險 | — | `/cso`（OWASP + STRIDE）|
| **5. 實作（TDD）** | RED → GREEN → REFACTOR 循環 | `test-driven-development` `subagent-driven-development` `dispatching-parallel-agents` `systematic-debugging` | `/investigate`（卡住時）|
| **6. Code Review** | Spec 合規 + 程式碼品質，兩段式驗證 | `requesting-code-review` `receiving-code-review` | `/review` |
| **7. QA & 效能** | 功能正確 + 效能基線 + 設計落地 | — | `/qa` → `/benchmark` → `/devex-review` → `/design-review` |
| **8. Ship** | 乾淨合併、部署、上線監控 | `finishing-a-development-branch` | `/ship` → `/land-and-deploy` → `/canary` |
| **9. 知識沉澱** | 把本次 pattern 變成下次的可重用資產 | `writing-skills` | `/document-release` → `/document-generate` → `/retro` |

#### 四條不可妥協的規則

1. **安全在建構前，不是上線後** — Phase 4 `/cso` 必須在 Phase 5 開始**之前**完成
2. **TDD 是強制的** — Phase 5 的每一行 code 都必須對應一個先存在的失敗測試
3. **superpowers 先於 gstack** — 在同一 Phase 中，先跑 superpowers 決策框架，再用 gstack 執行
4. **永遠關閉迴圈** — Phase 9 `writing-skills` + `anthropics/skills` 的 `SKILL.md` 格式，將本次模式轉為可分發的技能

---

## 規則說明

### 行為準則（Karpathy Guidelines）

這四個原則解決了 AI 編碼中最常見的問題：

**1. 寫程式前先思考（Think Before Coding）**
明確說明假設，有疑問先問而不是猜。在寫第一行程式碼之前，先點出所有取捨。

**2. 以簡為先（Simplicity First）**
只寫解決問題所需的最少量程式碼。不加推測性功能，不做不必要的抽象化。50 行能搞定的，不要寫 200 行。

**3. 精準修改（Surgical Changes）**
只動必要的地方，不要「順手改進」旁邊的程式碼，維持原有風格，只清理自己造成的亂。

**4. 目標導向執行（Goal-Driven Execution）**
把任務轉換成可驗證的目標。不要說「修這個 bug」，而是說「寫一個重現 bug 的測試，然後讓它通過」。明確的成功標準讓 AI 可以獨立迴圈執行直到完成。

### Token 優化規則（RTK）

告知 AI 在安裝 RTK 的環境下優先使用 `rtk` 前綴指令，讓常用操作的 Token 消耗降低 60–90%：

| 操作 | 未使用 RTK | 使用 RTK | 節省 |
|---|---|---|---|
| `git status` × 10 | ~3,000 tokens | ~600 tokens | -80% |
| `cat` / `read` × 20 | ~40,000 tokens | ~12,000 tokens | -70% |
| `cargo test` × 5 | ~25,000 tokens | ~2,500 tokens | -90% |
| **30 分鐘工作階段合計** | **~118,000** | **~23,900** | **-80%** |

即使沒有安裝 RTK，規則也會指示 AI 主動壓縮輸出（只顯示失敗的測試、git log 使用 `--oneline`、略過樣板輸出）。

---

## 專案結構

```
ai-coding-guidelines/
├── CLAUDE.md                              ← 單一真相來源（只需編輯這個）
├── AGENTS.md                              → 符號連結 CLAUDE.md（Codex）
├── .windsurfrules                         → 符號連結 CLAUDE.md（Windsurf）
├── .clinerules                            → 符號連結 CLAUDE.md（Cline/Roo）
├── .claude/
│   ├── settings.json                     ← AnySearch MCP（Claude Code，已 commit）
│   └── settings.local.json              ← 本地權限設定（不 commit）
├── .cursor/
│   ├── mcp.json                          ← AnySearch MCP（Cursor）
│   └── rules/
│       └── ai-guidelines.mdc            → 符號連結 ../../CLAUDE.md
├── .vscode/
│   └── mcp.json                          ← AnySearch MCP（VS Code Copilot）
├── .skills/
│   └── anysearch/                        ← AnySearch SKILL（由 setup.sh 安裝）
├── .github/
│   └── copilot-instructions.md          → 符號連結 ../CLAUDE.md
├── .agents/
│   └── rules/
│       └── antigravity-rtk-rules.md     → 符號連結 ../../CLAUDE.md
├── .kilocode/
│   └── rules/
│       └── ai-guidelines.md             → 符號連結 ../../CLAUDE.md
├── setup.sh                              ← macOS / Linux 安裝腳本（含 AnySearch）
├── setup.bat                             ← Windows 安裝腳本
├── README.md                             ← 英文說明
└── README.zh.md                          ← 本檔案（繁體中文）
```

---

## 如何更新規則

只需編輯 `CLAUDE.md`。由於所有其他檔案都是符號連結，所有工具會立即取得更新，不需要任何同步操作。

---

## 如何判斷規則有效

以下是規則正確運作的信號：

- ✅ Diff 中只有你要求的變動——不再有「順手」的重構
- ✅ 澄清問題在實作**之前**出現，不是錯誤之後
- ✅ 程式碼第一次就寫得夠簡單，減少重寫次數
- ✅ `rtk gain` 顯示持續的 Token 節省趨勢（需安裝 RTK）

---

## 致謝

- [Andrej Karpathy](https://x.com/karpathy) — LLM 編碼缺陷的原始觀察
- [multica-ai/andrej-karpathy-skills](https://github.com/multica-ai/andrej-karpathy-skills) — Karpathy 指引實作（MIT 授權）
- [rtk-ai/rtk](https://github.com/rtk-ai/rtk) — RTK Token 優化工具（Apache 2.0 授權）
- [garrytan/gstack](https://github.com/garrytan/gstack) — 23 個 AI 開發 slash command（MIT 授權）
- [obra/superpowers](https://github.com/obra/superpowers) — AI coding agent 的軟體開發方法論
- [anthropics/skills](https://github.com/anthropics/skills) — Agent Skills 規格標準與範例庫
- [AnySearch](https://www.anysearch.com) — AI 搜尋基礎設施，統一多源搜尋 API

---

## 授權

MIT
