# AI 程式編碼指引 — 通用 AI Vibe Coding 規則集

> **一份文件，適用所有 AI 開發工具，Clone 後零設定。**

[English](./README.md) | 繁體中文

---

## 這是什麼？

這個 Repository 是一份 **AI 編碼行為的單一真相來源**，整合了兩套經過實戰驗證的開源規則：

- **[Karpathy Guidelines](https://github.com/multica-ai/andrej-karpathy-skills)** — 行為準則，源自 Andrej Karpathy 對 LLM 編碼缺陷的觀察：寫程式前先思考、保持簡潔、精準修改、定義可驗證的目標。
- **[RTK（Rust Token Killer）](https://github.com/rtk-ai/rtk)** — Token 優化規則，在常用 Shell 指令上將 LLM context 消耗降低 60–90%。

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
├── .github/
│   └── copilot-instructions.md           → 符號連結 ../CLAUDE.md（Copilot）
├── .cursor/
│   └── rules/
│       └── ai-guidelines.mdc             → 符號連結 ../../CLAUDE.md（Cursor）
├── .agents/
│   └── rules/
│       └── antigravity-rtk-rules.md      → 符號連結 ../../CLAUDE.md（Antigravity）
├── .kilocode/
│   └── rules/
│       └── ai-guidelines.md              → 符號連結 ../../CLAUDE.md（Kilo Code）
├── setup.sh                              ← macOS / Linux 安裝腳本
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

---

## 授權

MIT
