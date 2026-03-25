# Install ALL possible skill dependencies for Windows
# Run: powershell -ExecutionPolicy Bypass -File setup-all-skills.ps1

$ErrorActionPreference = "Continue"

function Log($msg) { Write-Host "`n[skills] $msg" -ForegroundColor Cyan }
function Ok($msg)  { Write-Host "  [OK] $msg" -ForegroundColor Green }
function Skip($msg) { Write-Host "  [SKIP] $msg" -ForegroundColor Yellow }
function Info($msg) { Write-Host "  [INFO] $msg" -ForegroundColor Gray }

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  OpenClaw Full Skills Installer" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# ── winget installs (system tools) ──────────────────────────────

Log "Installing system tools via winget..."

$wingetPackages = @(
    @{ id="jqlang.jq";              name="jq (session-logs skill)" },
    @{ id="FFmpeg.FFmpeg";           name="ffmpeg (video-frames, summarize skills)" },
    @{ id="yt-dlp.yt-dlp";          name="yt-dlp (summarize skill)" },
    @{ id="GitHub.cli";             name="GitHub CLI (github, gh-issues skills)" },
    @{ id="GnuPG.GnuPG";           name="GnuPG (security/signing)" },
    @{ id="tmux.tmux";             name="tmux (tmux skill)" }
)

foreach ($pkg in $wingetPackages) {
    Log "Installing $($pkg.name)..."
    $result = winget install --id $pkg.id --accept-source-agreements --accept-package-agreements --silent 2>&1 | Out-String
    if ($result -match "already installed|No applicable|no package found") {
        Ok "$($pkg.name) - already installed or not available"
    } else {
        Ok "$($pkg.name)"
    }
}

# ── npm global installs ─────────────────────────────────────────

Log "Installing npm global tools..."

$npmPackages = @(
    @{ pkg="clawhub";          name="ClawHub CLI (skill manager)" },
    @{ pkg="nano-pdf";         name="nano-pdf (PDF editing skill)" },
    @{ pkg="@anthropic-ai/claude-code"; name="Claude Code (coding-agent skill)" },
    @{ pkg="gemini-cli";       name="Gemini CLI (gemini skill)" },
    @{ pkg="himalaya";         name="Himalaya (email skill)" },
    @{ pkg="obsidian-cli";     name="Obsidian CLI (obsidian skill)" },
    @{ pkg="blogwatcher";      name="Blogwatcher (blog monitoring skill)" },
    @{ pkg="gifgrep";          name="Gifgrep (GIF search skill)" },
    @{ pkg="mcporter";         name="MCPorter (MCP server skill)" },
    @{ pkg="oracle-cli";       name="Oracle CLI (prompt bundling skill)" }
)

foreach ($pkg in $npmPackages) {
    Log "Installing $($pkg.name)..."
    $check = npm list -g $($pkg.pkg) 2>&1 | Out-String
    if ($check -match "$($pkg.pkg)@") {
        Ok "$($pkg.name) - already installed"
    } else {
        $result = npm install -g $($pkg.pkg) 2>&1 | Out-String
        if ($result -match "added|updated|up to date") {
            Ok "$($pkg.name)"
        } else {
            Skip "$($pkg.name) - install may have failed, check manually"
        }
    }
}

# ── ClawHub skills (workspace skills) ──────────────────────────

Log "Installing ClawHub workspace skills..."

$clawSkills = @(
    "github-skill",
    "code-review",
    "markdown-writer",
    "git-workflow",
    "project-planner",
    "file-organizer",
    "web-research",
    "document-analyzer",
    "test-runner",
    "typescript-expert",
    "todo",
    "legal-research",
    "formal-language-design",
    "parser-builder",
    "proof-checker",
    "knowledge-base"
)

foreach ($skill in $clawSkills) {
    Log "Installing skill: $skill..."
    $result = clawhub install $skill 2>&1 | Out-String
    if ($result -match "already|success|installed|up.to.date") {
        Ok "$skill"
    } elseif ($result -match "not found|404|error") {
        Skip "$skill (not found on ClawHub)"
    } else {
        Ok "$skill"
    }
}

# ── API key prompts for optional skills ─────────────────────────

Log "Checking API-dependent skills..."

# Notion
Info "notion skill: Needs NOTION_API_KEY. Get one at https://www.notion.so/my-integrations"
Info "  Then run: openclaw configure --section notion"

# Slack
Info "slack skill: Needs Slack bot + app tokens. Create at https://api.slack.com/apps"
Info "  Then run: openclaw channels add --channel slack --bot-token xoxb-... --app-token xapp-..."

# Discord
Info "discord skill: Needs Discord bot token. Create at https://discord.com/developers/applications"
Info "  Then run: openclaw channels add --channel discord --token YOUR_TOKEN"

# Trello
Info "trello skill: Needs Trello API key + token. Get at https://trello.com/power-ups/admin"

# X/Twitter
Info "xurl skill: Needs X API credentials. Apply at https://developer.x.com"

# ElevenLabs (TTS)
Info "sag skill: Needs ELEVENLABS_API_KEY. Get at https://elevenlabs.io"

# OpenAI (Whisper API)
Info "openai-whisper-api skill: Needs OPENAI_API_KEY. Get at https://platform.openai.com"

# Spotify
Info "spotify-player skill: Needs Spotify Premium + client ID. Get at https://developer.spotify.com"

# ── macOS-only skills (cannot install on Windows) ───────────────

Log "macOS-only skills (not available on Windows):"
Skip "apple-notes - macOS only"
Skip "apple-reminders - macOS only"
Skip "bear-notes - macOS only"
Skip "imsg (iMessage) - macOS only"
Skip "things-mac - macOS only"
Skip "peekaboo - macOS only"

# ── Hardware-specific skills ────────────────────────────────────

Log "Hardware-specific skills (need specific devices):"
Skip "blucli - needs BluOS speakers"
Skip "camsnap - needs RTSP/ONVIF cameras"
Skip "eightctl - needs Eight Sleep pod"
Skip "openhue - needs Philips Hue bridge"
Skip "sonoscli - needs Sonos speakers"
Skip "bluebubbles - needs BlueBubbles server + Mac"
Skip "voice-call - needs voice-call plugin setup"
Skip "1password - needs 1Password subscription"
Skip "sherpa-onnx-tts - needs local model download"

# ── Final status ────────────────────────────────────────────────

Log "Refreshing PATH for new tools..."
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

Log "Checking final skill status..."
openclaw skills list 2>&1 | Select-String "ready"

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  Skills Installation Complete" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "  What was installed:" -ForegroundColor White
Write-Host "    - jq, ffmpeg, yt-dlp, GitHub CLI (via winget)" -ForegroundColor White
Write-Host "    - clawhub, nano-pdf, claude-code, gemini-cli," -ForegroundColor White
Write-Host "      himalaya, obsidian-cli, blogwatcher, gifgrep," -ForegroundColor White
Write-Host "      mcporter, oracle-cli (via npm)" -ForegroundColor White
Write-Host "    - 16 ClawHub workspace skills" -ForegroundColor White
Write-Host ""
Write-Host "  To enable API-dependent skills:" -ForegroundColor Yellow
Write-Host "    openclaw configure" -ForegroundColor Yellow
Write-Host "    (walks through setting API keys)" -ForegroundColor Yellow
Write-Host ""
Write-Host "  Restart gateway to activate:" -ForegroundColor Yellow
Write-Host "    openclaw gateway --port 18789" -ForegroundColor Yellow
Write-Host ""
Write-Host "  Cannot install on Windows (macOS only):" -ForegroundColor Gray
Write-Host "    apple-notes, apple-reminders, bear-notes," -ForegroundColor Gray
Write-Host "    imsg, things-mac, peekaboo" -ForegroundColor Gray
Write-Host ""
