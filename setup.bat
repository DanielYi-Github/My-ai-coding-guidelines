@echo off
REM =============================================================================
REM setup.bat  AI Coding Guidelines: Windows Setup Script
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
    if exist AGENTS.md del /F /Q AGENTS.md
    if exist .windsurfrules del /F /Q .windsurfrules
    if exist .clinerules del /F /Q .clinerules
    if exist .github\copilot-instructions.md del /F /Q .github\copilot-instructions.md
    if exist .cursor\rules\ai-guidelines.mdc del /F /Q .cursor\rules\ai-guidelines.mdc
    if exist .agents\rules\antigravity-rtk-rules.md del /F /Q .agents\rules\antigravity-rtk-rules.md
    if exist .kilocode\rules\ai-guidelines.md del /F /Q .kilocode\rules\ai-guidelines.md

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
    copy /Y CLAUDE.md AGENTS.md
    copy /Y CLAUDE.md .windsurfrules
    copy /Y CLAUDE.md .clinerules
    if not exist .github mkdir .github
    copy /Y CLAUDE.md .github\copilot-instructions.md
    if not exist .cursor\rules mkdir .cursor\rules
    copy /Y CLAUDE.md .cursor\rules\ai-guidelines.mdc
    if not exist .agents\rules mkdir .agents\rules
    copy /Y CLAUDE.md .agents\rules\antigravity-rtk-rules.md
    if not exist .kilocode\rules mkdir .kilocode\rules
    copy /Y CLAUDE.md .kilocode\rules\ai-guidelines.md
    echo NOTE: Files were copied, not symlinked. If you edit CLAUDE.md,
    echo       run setup.bat again to sync changes to other tool files.
)

echo.
echo =============================================================================
echo Configuring AnySearch API Key...
echo =============================================================================

REM Check if .env.local exists, create from template if not
if not exist ".env.local" (
    if exist ".env.example" (
        echo Creating .env.local from template...
        copy /Y .env.example .env.local >nul
        echo.
        echo ^! Please edit .env.local with your API key:
        echo   notepad .env.local
        echo.
        echo Then run this script again.
        echo.
        pause
        exit /b 0
    )
)

REM Read .env.local and extract ANYSEARCH_API_KEY using PowerShell
for /f "tokens=*" %%A in ('powershell -NoProfile -Command "if (Test-Path '.env.local') { $content = Get-Content '.env.local' | Where-Object { $_ -match '^ANYSEARCH_API_KEY=' }; $content -replace 'ANYSEARCH_API_KEY=', '' }"') do (
    set ANYSEARCH_API_KEY=%%A
)

if not defined ANYSEARCH_API_KEY (
    echo.
    echo Warning: ANYSEARCH_API_KEY not set in .env.local
    echo Please edit .env.local and fill in your API key, then run setup.bat again.
    echo.
    pause
    exit /b 1
) else (
    REM Set environment variable in current session
    setx ANYSEARCH_API_KEY "%ANYSEARCH_API_KEY%"
    echo.
    echo [OK] ANYSEARCH_API_KEY has been set in Windows environment variables
    echo      You will need to restart your terminal/IDE for changes to take effect
)

echo.
echo Done! All AI tools in this project will now use CLAUDE.md as their rule source.
pause
