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

# =============================================================================
# AnySearch Skill Installation
# =============================================================================
echo "🔍 Installing AnySearch skill..."

install_anysearch_skill() {
  local target_dir="$1"
  local label="$2"
  mkdir -p "$target_dir"
  curl -sL -o /tmp/anysearch-skill.zip \
    https://github.com/anysearch-ai/anysearch-skill/archive/refs/heads/main.zip 2>/dev/null
  if [ $? -eq 0 ] && [ -f /tmp/anysearch-skill.zip ]; then
    unzip -q -o /tmp/anysearch-skill.zip -d /tmp/anysearch-skill-extract 2>/dev/null
    mv /tmp/anysearch-skill-extract/anysearch-skill-main "$target_dir" 2>/dev/null \
      || cp -r /tmp/anysearch-skill-extract/anysearch-skill-main/. "$target_dir" 2>/dev/null
    rm -rf /tmp/anysearch-skill.zip /tmp/anysearch-skill-extract
    echo "  ✓ AnySearch skill → $target_dir  ($label)"
  else
    echo "  ⚠ AnySearch skill download skipped (network unavailable) — install manually:"
    echo "    curl -L -o anysearch-skill.zip https://github.com/anysearch-ai/anysearch-skill/archive/refs/heads/main.zip"
    echo "    unzip anysearch-skill.zip && mv anysearch-skill-main $target_dir"
  fi
}

install_anysearch_skill "$HOME/.claude/skills/anysearch"   "Claude Code"
install_anysearch_skill "$HOME/.opencode/skills/anysearch" "OpenCode"

# Cursor / Windsurf — project-level skills directory
install_anysearch_skill "$SCRIPT_DIR/.skills/anysearch" "Cursor / Windsurf"

# =============================================================================
# Windsurf MCP Configuration (user-level, requires confirmation)
# =============================================================================
WINDSURF_MCP_DIR="$HOME/.codeium/windsurf"
WINDSURF_MCP_FILE="$WINDSURF_MCP_DIR/mcp_config.json"
if [ -d "$WINDSURF_MCP_DIR" ]; then
  echo ""
  echo "🌊 Windsurf detected — configuring AnySearch MCP..."
  mkdir -p "$WINDSURF_MCP_DIR"
  if [ -f "$WINDSURF_MCP_FILE" ]; then
    echo "  ⚠ $WINDSURF_MCP_FILE already exists — skipping (add manually if needed)."
    echo "    See README.zh.md § AnySearch for the config snippet."
  else
    cat > "$WINDSURF_MCP_FILE" << 'EOF'
{
  "mcpServers": {
    "anysearch": {
      "serverUrl": "http://localhost:8000/sse"
    }
  }
}
EOF
    echo "  ✓ Windsurf MCP config written to $WINDSURF_MCP_FILE"
    echo "    Start proxy before using: npx -y supergateway --streamableHttp https://api.anysearch.com/mcp --outputTransport sse --port 8000"
  fi
fi

echo ""
echo "✅ Done! All AI tools in this project will now use CLAUDE.md as the single source of truth."
echo "   AnySearch is pre-configured: AI will automatically use it for all web searches."
echo ""
echo "💡 Optional: Set your AnySearch API key for higher rate limits:"
echo "   export ANYSEARCH_API_KEY=your_key_here   # add to ~/.zshrc or ~/.bashrc"
echo "   Get a key at: https://www.anysearch.com"
echo ""
echo "💡 Optional: Install RTK for 60–90% token savings on shell commands:"
echo "   brew install rtk         # macOS"
echo "   rtk init -g              # Claude Code / Copilot"
echo "   rtk init --agent antigravity  # Google Antigravity"
