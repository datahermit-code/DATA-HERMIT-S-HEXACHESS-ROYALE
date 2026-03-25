# Install all useful skills for the Hermit Notation project
# Run: powershell -ExecutionPolicy Bypass -File setup-skills.ps1

$ErrorActionPreference = "Continue"

function Log($msg) { Write-Host "[skills] $msg" -ForegroundColor Cyan }
function Ok($msg)  { Write-Host "  [OK] $msg" -ForegroundColor Green }
function Skip($msg) { Write-Host "  [SKIP] $msg" -ForegroundColor Yellow }

Log "Installing ClawHub CLI..."
$ch = npm list -g clawhub 2>&1 | Out-String
if ($ch -match "clawhub@") {
    Ok "ClawHub CLI already installed"
} else {
    npm install -g clawhub
    Ok "ClawHub CLI installed"
}

Log "Installing GitHub CLI (gh)..."
$ghVer = $null
try { $ghVer = gh --version 2>&1 | Select-Object -First 1 } catch {}
if ($ghVer) {
    Ok "GitHub CLI already installed: $ghVer"
} else {
    Log "Installing via winget..."
    winget install --id GitHub.cli --accept-source-agreements --accept-package-agreements 2>&1
    Ok "GitHub CLI installed - run 'gh auth login' after this script"
}

# Skills to install from ClawHub
$skills = @(
    "github-skill",
    "code-review",
    "markdown-writer",
    "git-workflow",
    "project-planner",
    "file-organizer",
    "web-research",
    "document-analyzer",
    "test-runner",
    "typescript-expert"
)

Log "Installing ClawHub skills..."
foreach ($skill in $skills) {
    Log "  Installing $skill..."
    $result = clawhub install $skill 2>&1 | Out-String
    if ($result -match "already|installed|success|up.to.date") {
        Ok "$skill"
    } elseif ($result -match "not found|error|404") {
        Skip "$skill (not found on ClawHub - may need different slug)"
    } else {
        Ok "$skill"
    }
}

# Also try to install summarize dependencies
Log "Installing summarize skill dependency (yt-dlp)..."
$ytdlp = $null
try { $ytdlp = yt-dlp --version 2>&1 } catch {}
if ($ytdlp) {
    Ok "yt-dlp already installed"
} else {
    winget install --id yt-dlp.yt-dlp --accept-source-agreements --accept-package-agreements 2>&1
    Ok "yt-dlp installed (enables summarize skill)"
}

# Install nano-pdf for PDF processing
Log "Installing nano-pdf for legal PDF processing..."
$np = npm list -g nano-pdf 2>&1 | Out-String
if ($np -match "nano-pdf@") {
    Ok "nano-pdf already installed"
} else {
    npm install -g nano-pdf 2>&1
    Ok "nano-pdf installed"
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  Skills Setup Complete" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "  Installed:" -ForegroundColor White
Write-Host "    - ClawHub CLI (skill manager)" -ForegroundColor White
Write-Host "    - GitHub CLI (gh)" -ForegroundColor White
Write-Host "    - 10 ClawHub skills" -ForegroundColor White
Write-Host "    - yt-dlp (summarize skill)" -ForegroundColor White
Write-Host "    - nano-pdf (PDF processing)" -ForegroundColor White
Write-Host ""
Write-Host "  Next steps:" -ForegroundColor Yellow
Write-Host "    1. Run: gh auth login" -ForegroundColor Yellow
Write-Host "    2. Restart gateway: openclaw gateway --port 18789" -ForegroundColor Yellow
Write-Host "    3. Check skills: openclaw skills list" -ForegroundColor Yellow
Write-Host ""
