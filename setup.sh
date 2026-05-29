#!/usr/bin/env bash
# =============================================================================
# setup.sh — AI Coding Guidelines: Symlink Setup Script
# Run this once after cloning to wire up all AI tool rule files.
# =============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "🔗 Setting up AI coding guidelines symlinks..."

# --- Root-level symlinks ---
ln -sf CLAUDE.md AGENTS.md       && echo "  ✓ AGENTS.md          → CLAUDE.md  (Codex)"
ln -sf CLAUDE.md .windsurfrules  && echo "  ✓ .windsurfrules     → CLAUDE.md  (Windsurf)"
ln -sf CLAUDE.md .clinerules     && echo "  ✓ .clinerules        → CLAUDE.md  (Cline / Roo Code)"

# --- .github ---
mkdir -p .github
ln -sf ../CLAUDE.md .github/copilot-instructions.md \
  && echo "  ✓ .github/copilot-instructions.md  → CLAUDE.md  (GitHub Copilot)"

# --- Cursor ---
mkdir -p .cursor/rules
ln -sf ../../CLAUDE.md .cursor/rules/ai-guidelines.mdc \
  && echo "  ✓ .cursor/rules/ai-guidelines.mdc  → CLAUDE.md  (Cursor)"

# --- Google Antigravity ---
mkdir -p .agents/rules
ln -sf ../../CLAUDE.md .agents/rules/antigravity-rtk-rules.md \
  && echo "  ✓ .agents/rules/antigravity-rtk-rules.md  → CLAUDE.md  (Google Antigravity)"

# --- Kilo Code ---
mkdir -p .kilocode/rules
ln -sf ../../CLAUDE.md .kilocode/rules/ai-guidelines.md \
  && echo "  ✓ .kilocode/rules/ai-guidelines.md  → CLAUDE.md  (Kilo Code)"

echo ""
echo "✅ Done! All AI tools in this project will now use CLAUDE.md as the single source of truth."
echo ""
echo "💡 Optional: Install RTK for 60–90% token savings on shell commands:"
echo "   brew install rtk         # macOS"
echo "   rtk init -g              # Claude Code / Copilot"
echo "   rtk init --agent antigravity  # Google Antigravity"
