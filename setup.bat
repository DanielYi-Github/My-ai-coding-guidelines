@echo off
REM =============================================================================
REM setup.bat — AI Coding Guidelines: Windows Setup Script
REM Run as Administrator for symlink support, or it will copy files instead.
REM =============================================================================

echo Setting up AI coding guidelines...

REM Check if running as administrator (needed for symlinks on Windows)
net session >nul 2>&1
if %errorLevel% == 0 (
    echo [Admin mode] Creating symlinks...
    set MODE=SYMLINK
) else (
    echo [No admin] Copying files instead of symlinks...
    set MODE=COPY
)

if "%MODE%"=="SYMLINK" (
    mklink AGENTS.md CLAUDE.md
    mklink .windsurfrules CLAUDE.md
    mklink .clinerules CLAUDE.md
    if not exist .github mkdir .github
    mklink .github\copilot-instructions.md ..\CLAUDE.md
    if not exist .cursor\rules mkdir .cursor\rules
    mklink .cursor\rules\ai-guidelines.mdc ..\..\CLAUDE.md
    if not exist .agents\rules mkdir .agents\rules
    mklink .agents\rules\antigravity-rtk-rules.md ..\..\CLAUDE.md
    if not exist .kilocode\rules mkdir .kilocode\rules
    mklink .kilocode\rules\ai-guidelines.md ..\..\CLAUDE.md
) else (
    copy CLAUDE.md AGENTS.md
    copy CLAUDE.md .windsurfrules
    copy CLAUDE.md .clinerules
    if not exist .github mkdir .github
    copy CLAUDE.md .github\copilot-instructions.md
    if not exist .cursor\rules mkdir .cursor\rules
    copy CLAUDE.md .cursor\rules\ai-guidelines.mdc
    if not exist .agents\rules mkdir .agents\rules
    copy CLAUDE.md .agents\rules\antigravity-rtk-rules.md
    if not exist .kilocode\rules mkdir .kilocode\rules
    copy CLAUDE.md .kilocode\rules\ai-guidelines.md
    echo NOTE: Files were copied, not symlinked. If you edit CLAUDE.md,
    echo       run setup.bat again to sync changes to other tool files.
)

echo.
echo Done! All AI tools in this project will now use CLAUDE.md as their rule source.
pause
