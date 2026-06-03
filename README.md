# AI Coding Guidelines — Universal Rules for AI Vibe Coding

> **One file. Every AI coding tool. Zero per-project setup after cloning.**

English | [繁體中文](./README.zh.md)

---

## What Is This?

This repository is a **single source of truth** for AI coding behavior guidelines. It combines four battle-tested open-source systems:

- **[Karpathy Guidelines](https://github.com/multica-ai/andrej-karpathy-skills)** — Behavioral rules derived from Andrej Karpathy's observations on LLM coding pitfalls: think before coding, keep it simple, make surgical changes, and define verifiable goals.
- **[RTK (Rust Token Killer)](https://github.com/rtk-ai/rtk)** — Token optimization rules that reduce LLM context consumption by 60–90% on common shell commands.
- **[superpowers](https://github.com/obra/superpowers)** — A software development methodology layer: structured workflow, TDD discipline, and multi-agent coordination.
- **[gstack](https://github.com/garrytan/gstack)** — 23 specialized slash commands covering every phase from product strategy to post-deploy monitoring.

Everything lives in `CLAUDE.md`. All other tool-specific files are symlinks pointing back to it — so you only ever edit one file.

---

## Supported AI Coding Tools

| Tool | Config File | Method |
|---|---|---|
| **Claude Code** | `CLAUDE.md` | Auto-detected |
| **GitHub Copilot (VS Code)** | `.github/copilot-instructions.md` | Symlink |
| **Codex (OpenAI)** | `AGENTS.md` | Symlink |
| **Cursor** | `.cursor/rules/ai-guidelines.mdc` | Symlink |
| **Windsurf** | `.windsurfrules` | Symlink |
| **Cline / Roo Code** | `.clinerules` | Symlink |
| **Google Antigravity** | `.agents/rules/antigravity-rtk-rules.md` | Symlink |
| **Kilo Code** | `.kilocode/rules/ai-guidelines.md` | Symlink |
| **Claude Desktop** | `CLAUDE.md` | Auto-detected |

---

## Quick Start

### Option A — Use This Repo as a Template

Click **"Use this template"** on GitHub, then clone your new repo. All symlinks are already in place. Done.

### Option B — Add to an Existing Project

```bash
# 1. Copy CLAUDE.md to your project root
curl -o CLAUDE.md https://raw.githubusercontent.com/<your-username>/ai-coding-guidelines/main/CLAUDE.md

# 2. Run the setup script (handles symlinks + environment setup)
curl -o setup.sh https://raw.githubusercontent.com/<your-username>/ai-coding-guidelines/main/setup.sh
chmod +x setup.sh && ./setup.sh

# 3. (Optional but recommended) Install RTK for real token savings
brew install rtk          # macOS
rtk init -g               # Claude Code / Copilot
rtk init --agent antigravity   # Google Antigravity
```

### Windows

```bat
# Run setup.bat as Administrator for symlink support
# Or run as normal user — it will copy files instead
# (The script will also guide you through AnySearch API key setup)
setup.bat
```

---

## AnySearch: Automatic Web Search

This project pre-configures **[AnySearch](https://www.anysearch.com/docs)** as the default search engine for all AI tools. Whenever the AI needs to look something up online, it automatically uses AnySearch instead of raw WebFetch — getting pre-ranked, multi-source results with 60–80% fewer tokens.

**No prompting required.** The behavior is enforced in `CLAUDE.md` and the MCP servers are pre-configured in the project files.

### What's Pre-Configured

| File | Tool | Method |
|---|---|---|
| `.claude/settings.json` | Claude Code | Streamable HTTP (native) |
| `.cursor/mcp.json` | Cursor | stdio via `mcp-remote` |
| `.vscode/mcp.json` | VS Code Copilot | stdio via `mcp-remote` |
| `~/.codeium/windsurf/mcp_config.json` | Windsurf | SSE (written by `setup.sh`) |
| `~/.claude/skills/anysearch` | Claude Code | SKILL package |
| `.skills/anysearch` | Cursor / Windsurf | SKILL package |

### API Key Setup (Optional but Recommended)

Anonymous access works out of the box (IP rate-limited). For higher limits:

1. **Create and edit `.env.local`:**
   ```bash
   cp .env.example .env.local
   nano .env.local  # Edit with your API key from https://www.anysearch.com
   ```

2. **Run the setup script** (automatically reads `.env.local` and configures environment):
   ```bash
   ./setup.sh       # Linux/macOS
   # or
   setup.bat        # Windows
   ```

That's it! The setup script will handle environment variable configuration for your platform.

---

## Configuration Files

### What Is `.env.local`?

The `.env.local` file stores your AnySearch API credentials. It's **never committed to Git** and is unique to each developer's machine.

**Files explained:**
- `.env.example` — Template showing all available configuration options (this IS committed to Git)
- `.env.local` — Your personal config with actual API key (this is in `.gitignore`, NOT committed)

### Setup Workflow

1. **Copy the template:**
   ```bash
   cp .env.example .env.local
   ```

2. **Edit with your API key:**
   ```bash
   nano .env.local  # Change ANYSEARCH_API_KEY=your_key_here to your actual key
   ```

3. **Run setup script:**
   ```bash
   ./setup.sh       # Handles symlinks + sets environment variable
   ```

The setup script will:
- Set `ANYSEARCH_API_KEY` in your current shell session
- (On Linux/macOS) Optionally add it to your `~/.bashrc` or `~/.zshrc`
- (On Windows) Set it in your user environment variables via `setx`

### Supported Variables (in .env.local)

```bash
# Required: Your AnySearch API key
ANYSEARCH_API_KEY=sk_live_your_key_here

# Optional: Custom API endpoint (defaults to https://api.anysearch.com)
ANYSEARCH_API_ENDPOINT=https://api.anysearch.com

# Optional: Windsurf MCP proxy port (defaults to 8000)
ANYSEARCH_MCP_PORT=8000
```

---

### Manual MCP Setup (if not using setup.sh)

**Windsurf** — requires SSE proxy (run once before starting Windsurf):
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

**Codex / Factory Droid / Gemini CLI / OpenCode** — follow [anysearch.com/docs](https://www.anysearch.com/docs) for platform-specific MCP setup, then the `CLAUDE.md` behavior rules will auto-trigger it.

---

## Development Workflow Stack

This project defines a **9-phase development lifecycle** built on three layers:

| Layer | Tool | Role |
|---|---|---|
| Methodology | [superpowers](https://github.com/obra/superpowers) | How to think and work — decision frameworks, TDD discipline, multi-agent coordination |
| Tooling | [gstack](https://github.com/garrytan/gstack) | What to use at each phase — 23 specialized slash commands |
| Infrastructure | [anthropics/skills](https://github.com/anthropics/skills) | Skill format standard — package and distribute reusable workflows |

**Key principle**: Within any phase where both tools appear, **superpowers runs first (decide) → gstack runs second (execute)**. They are complementary, not interchangeable.

### Install the Workflow Stack

#### Claude Code (full support)

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
# superpowers — open plugin interface
/plugins  # search "superpowers" → Install

# gstack
git clone --single-branch --depth 1 https://github.com/garrytan/gstack.git ~/gstack
cd ~/gstack && ./setup --host codex
```

#### Cursor

```bash
# superpowers
/add-plugin superpowers
# or search "superpowers" in plugin marketplace

# gstack
git clone --single-branch --depth 1 https://github.com/garrytan/gstack.git ~/gstack
cd ~/gstack && ./setup --host cursor
```

#### Gemini CLI

```bash
# superpowers
gemini extensions install https://github.com/obra/superpowers

# gstack — uses universal setup (auto-detects)
git clone --single-branch --depth 1 https://github.com/garrytan/gstack.git ~/gstack
cd ~/gstack && ./setup
```

#### GitHub Copilot CLI

```bash
# superpowers
copilot plugin marketplace add obra/superpowers-marketplace
copilot plugin install superpowers@superpowers-marketplace

# gstack — universal setup
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

> **Windsurf / Cline / Roo Code**: superpowers does not have an official integration. Apply the 9-phase methodology manually using the workflow table below as a checklist.

---

### The 9-Phase Development Lifecycle

Each phase must be completed before moving to the next. Do not skip phases.

| Phase | Goal | superpowers | gstack |
|---|---|---|---|
| **0. Workspace** | Isolated branch, clean main | `using-git-worktrees` | — |
| **1. Product Strategy** | Confirm you're solving the right problem | `brainstorming` | `/office-hours` → `/plan-ceo-review` |
| **2. Architecture** | Lock decisions, break into tasks | `writing-plans` | `/plan-eng-review` → `/plan-devex-review` |
| **3. Design** | Visual and UX decisions before any code | — | `/plan-design-review` → `/design-consultation` → `/design-shotgun` → `/design-html` |
| **4. Security (upfront)** | Know the risks before building | — | `/cso` (OWASP + STRIDE) |
| **5. Implementation (TDD)** | RED → GREEN → REFACTOR | `test-driven-development` `subagent-driven-development` `dispatching-parallel-agents` `systematic-debugging` | `/investigate` (when stuck) |
| **6. Code Review** | Spec compliance + code quality, two-stage | `requesting-code-review` `receiving-code-review` | `/review` |
| **7. QA & Performance** | Functional correctness + perf baseline + design verification | — | `/qa` → `/benchmark` → `/devex-review` → `/design-review` |
| **8. Ship** | Clean merge, deploy, monitor | `finishing-a-development-branch` | `/ship` → `/land-and-deploy` → `/canary` |
| **9. Knowledge Capture** | Turn this session's patterns into reusable assets | `writing-skills` | `/document-release` → `/document-generate` → `/retro` |

#### Four Non-Negotiable Rules

1. **Security is pre-build, not post-ship** — Phase 4 `/cso` must complete before Phase 5 begins
2. **TDD is mandatory** — Every line of code in Phase 5 must correspond to a pre-existing failing test
3. **superpowers before gstack** — In any shared phase, run the superpowers decision framework first, then execute with gstack
4. **Always close the loop** — Phase 9 `writing-skills` + `anthropics/skills` SKILL.md format converts session knowledge into reusable skills

---

## What the Rules Do

### Behavioral Rules (Karpathy Guidelines)

These four principles fix the most common LLM coding mistakes:

**1. Think Before Coding** — State assumptions explicitly. Ask rather than guess. Surface tradeoffs before writing a single line.

**2. Simplicity First** — Write the minimum code that solves the problem. No speculative features, no unnecessary abstractions. If 50 lines would do, don't write 200.

**3. Surgical Changes** — Touch only what you must. Don't "improve" adjacent code. Match existing style. Clean up only the mess your changes created.

**4. Goal-Driven Execution** — Transform tasks into verifiable goals. Instead of "fix the bug", write "reproduce the bug in a test, then make it pass." Strong success criteria let the AI loop independently.

### Token Optimization Rules (RTK)

Instructs the AI to use `rtk`-prefixed commands when RTK is installed, reducing token consumption by 60–90% on common operations:

| Operation | Without RTK | With RTK | Savings |
|---|---|---|---|
| `git status` × 10 | ~3,000 tokens | ~600 tokens | -80% |
| `cat` / `read` × 20 | ~40,000 tokens | ~12,000 tokens | -70% |
| `cargo test` × 5 | ~25,000 tokens | ~2,500 tokens | -90% |
| **Total (30-min session)** | **~118,000** | **~23,900** | **-80%** |

Even without RTK installed, the rules instruct the AI to compress its own outputs (show only failing tests, use `--oneline` for git log, skip boilerplate).

---

## How to Update the Rules

Edit **only** `CLAUDE.md`. Since everything else is a symlink, all tools pick up the change immediately — no sync needed.

---

## How to Know It's Working

These guidelines are working if you see:

- ✅ Diffs contain only what you asked for — no drive-by refactoring
- ✅ Clarifying questions come **before** implementation, not after mistakes
- ✅ Code is simple the first time, fewer rewrites
- ✅ `rtk gain` shows consistent token savings (if RTK is installed)

---

## Project Structure

```
ai-coding-guidelines/
├── CLAUDE.md                              ← Single source of truth (edit only this)
├── AGENTS.md                              → symlink to CLAUDE.md  (Codex)
├── .windsurfrules                         → symlink to CLAUDE.md  (Windsurf)
├── .clinerules                            → symlink to CLAUDE.md  (Cline/Roo)
├── .claude/
│   ├── settings.json                     ← AnySearch MCP (Claude Code, committed)
│   └── settings.local.json              ← Local permissions (gitignored)
├── .cursor/
│   ├── mcp.json                          ← AnySearch MCP (Cursor)
│   └── rules/
│       └── ai-guidelines.mdc            → symlink to ../../CLAUDE.md
├── .vscode/
│   └── mcp.json                          ← AnySearch MCP (VS Code Copilot)
├── .skills/
│   └── anysearch/                        ← AnySearch SKILL (Cursor/Windsurf, created by setup.sh)
├── .github/
│   └── copilot-instructions.md          → symlink to ../CLAUDE.md
├── .agents/
│   └── rules/
│       └── antigravity-rtk-rules.md     → symlink to ../../CLAUDE.md
├── .kilocode/
│   └── rules/
│       └── ai-guidelines.md             → symlink to ../../CLAUDE.md
├── setup.sh                              ← macOS / Linux setup (symlinks + AnySearch skill)
├── setup.bat                             ← Windows setup
├── README.md                             ← This file (English)
└── README.zh.md                          ← 繁體中文說明
```

---

## Credits

- [Andrej Karpathy](https://x.com/karpathy) — original observations on LLM coding pitfalls
- [multica-ai/andrej-karpathy-skills](https://github.com/multica-ai/andrej-karpathy-skills) — Karpathy guidelines implementation (MIT)
- [rtk-ai/rtk](https://github.com/rtk-ai/rtk) — RTK token optimization (Apache 2.0)
- [garrytan/gstack](https://github.com/garrytan/gstack) — 23 AI development slash commands (MIT)
- [obra/superpowers](https://github.com/obra/superpowers) — Software development methodology for coding agents
- [anthropics/skills](https://github.com/anthropics/skills) — Agent Skills standard and examples
- [AnySearch](https://www.anysearch.com) — AI search infrastructure, unified multi-source search API

---

## License

MIT
