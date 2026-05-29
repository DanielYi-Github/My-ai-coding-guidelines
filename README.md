# AI Coding Guidelines — Universal Rules for AI Vibe Coding

> **One file. Every AI coding tool. Zero per-project setup after cloning.**

English | [繁體中文](./README.zh.md)

---

## What Is This?

This repository is a **single source of truth** for AI coding behavior guidelines. It combines two battle-tested open-source rule sets:

- **[Karpathy Guidelines](https://github.com/multica-ai/andrej-karpathy-skills)** — Behavioral rules derived from Andrej Karpathy's observations on LLM coding pitfalls: think before coding, keep it simple, make surgical changes, and define verifiable goals.
- **[RTK (Rust Token Killer)](https://github.com/rtk-ai/rtk)** — Token optimization rules that reduce LLM context consumption by 60–90% on common shell commands.

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

# 2. Run the setup script to create all symlinks
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
setup.bat
```

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

## Project Structure

```
ai-coding-guidelines/
├── CLAUDE.md                              ← Single source of truth (edit only this)
├── AGENTS.md                              → symlink to CLAUDE.md  (Codex)
├── .windsurfrules                         → symlink to CLAUDE.md  (Windsurf)
├── .clinerules                            → symlink to CLAUDE.md  (Cline/Roo)
├── .github/
│   └── copilot-instructions.md           → symlink to ../CLAUDE.md  (Copilot)
├── .cursor/
│   └── rules/
│       └── ai-guidelines.mdc             → symlink to ../../CLAUDE.md  (Cursor)
├── .agents/
│   └── rules/
│       └── antigravity-rtk-rules.md      → symlink to ../../CLAUDE.md  (Antigravity)
├── .kilocode/
│   └── rules/
│       └── ai-guidelines.md              → symlink to ../../CLAUDE.md  (Kilo Code)
├── setup.sh                              ← macOS / Linux setup script
├── setup.bat                             ← Windows setup script
├── README.md                             ← This file (English)
└── README.zh.md                          ← 繁體中文說明
```

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

## Credits

- [Andrej Karpathy](https://x.com/karpathy) — original observations on LLM coding pitfalls
- [multica-ai/andrej-karpathy-skills](https://github.com/multica-ai/andrej-karpathy-skills) — Karpathy guidelines implementation (MIT)
- [rtk-ai/rtk](https://github.com/rtk-ai/rtk) — RTK token optimization (Apache 2.0)

---

## License

MIT
