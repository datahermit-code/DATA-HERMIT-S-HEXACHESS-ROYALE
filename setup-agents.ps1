# Setup all 8 Hermit Notation agents in OpenClaw
# Run AFTER install.ps1 and after the gateway is running
# Usage: powershell -ExecutionPolicy Bypass -File setup-agents.ps1

$ErrorActionPreference = "Continue"
$REPO_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path

function Log($msg) { Write-Host "[setup-agents] $msg" -ForegroundColor Cyan }
function Ok($msg)  { Write-Host "  [OK] $msg" -ForegroundColor Green }

$agents = @(
    @{ id="lexis";    name="DataScribe"; emoji="scales";  model="claude-sonnet-4-6"; dir="agents/lexis" },
    @{ id="drafter";  name="DataDancer"; emoji="pencil";  model="claude-sonnet-4-6"; dir="agents/drafter" },
    @{ id="compiler"; name="DataHerald"; emoji="gear";    model="claude-sonnet-4-6"; dir="agents/compiler" },
    @{ id="analyst";  name="DataDaemon"; emoji="mag";     model="claude-sonnet-4-6"; dir="agents/analyst" },
    @{ id="arbiter";  name="DataFortuna"; emoji="bank";   model="claude-opus-4-6";   dir="agents/arbiter" },
    @{ id="sensei";   name="DataSensei"; emoji="dart";    model="claude-sonnet-4-6"; dir="agents/sensei" },
    @{ id="forge";    name="DataForge";  emoji="fire";    model="claude-sonnet-4-6"; dir="agents/forge" }
)

Log "Setting up 7 Hermit Notation agents..."

foreach ($agent in $agents) {
    $ws = Join-Path $REPO_DIR $agent.dir
    $agentId = $agent.id
    $agentName = $agent.name
    $model = $agent.model

    Log "Creating agent: $agentName ($agentId)..."

    # Check if agent already exists
    $existing = openclaw agents list 2>&1 | Out-String
    if ($existing -match "- $agentId") {
        Ok "$agentName already exists"
    } else {
        openclaw agents add $agentId --workspace $ws --model $model --non-interactive 2>&1 | Out-Null
        Ok "$agentName created"
    }

    # Set identity
    openclaw agents set-identity --agent $agentId --name $agentName 2>&1 | Out-Null
    Ok "$agentName identity set"
}

# Enable inter-agent communication
Log "Enabling inter-agent communication..."
openclaw config set tools.agentToAgent.enabled true --json 2>&1 | Out-Null
Ok "Agent-to-agent communication enabled"

# Create shared communication directories
Log "Creating shared communication directories..."
$sharedDirs = @(
    "shared/lexis-to-drafter",
    "shared/lexis-to-arbiter",
    "shared/drafter-to-compiler",
    "shared/drafter-to-analyst",
    "shared/drafter-proposals",
    "shared/compiler-to-drafter",
    "shared/compiler-to-analyst",
    "shared/compiler-to-arbiter",
    "shared/analyst-gaps",
    "shared/analyst-to-compiler",
    "shared/analyst-to-arbiter",
    "shared/analyst-to-lexis",
    "shared/arbiter-decisions",
    "shared/sensei-to-analyst",
    "shared/sensei-to-forge",
    "shared/sensei-to-drafter",
    "shared/sensei-to-arbiter",
    "shared/forge-to-sensei",
    "shared/forge-to-drafter",
    "shared/forge-to-compiler",
    "shared/forge-to-lexis",
    "shared/forge-to-arbiter"
)

foreach ($dir in $sharedDirs) {
    $fullPath = Join-Path $REPO_DIR $dir
    New-Item -ItemType Directory -Force -Path $fullPath | Out-Null
}
Ok "Shared directories created"

# Verify
Log "Verifying agent team..."
openclaw agents list

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  All 8 agents ready!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host "  HexClaw (main) - coordinator" -ForegroundColor White
Write-Host "  DataScribe - legal research" -ForegroundColor White
Write-Host "  DataDancer - language design" -ForegroundColor White
Write-Host "  DataHerald - system builder" -ForegroundColor White
Write-Host "  DataDaemon - HN expert writer" -ForegroundColor White
Write-Host "  DataFortuna - project lead (Opus)" -ForegroundColor White
Write-Host "  DataSensei - training overseer" -ForegroundColor White
Write-Host "  DataForge - training processor" -ForegroundColor White
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Restart the gateway to activate:" -ForegroundColor Yellow
Write-Host "  openclaw gateway --port 18789" -ForegroundColor Yellow
Write-Host ""
Write-Host "Then open Claw3D agents page:" -ForegroundColor Yellow
Write-Host "  http://127.0.0.1:3000/agents" -ForegroundColor Yellow
Write-Host ""
