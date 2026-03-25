# ═══════════════════════════════════════════════════════════════════
# OpenClaw + Claw3D + Telegram — Full Install & Launch (Windows)
# Run: powershell -ExecutionPolicy Bypass -File install.ps1
# ═══════════════════════════════════════════════════════════════════

$ErrorActionPreference = "Stop"

$GATEWAY_PORT = 18789
$CLAW3D_PORT = 3000
$STUDIO_TOKEN = "9be097544762f49a3a637d14a2569d54919ba44d68b3c598"
$TELEGRAM_BOT_TOKEN = "8757185435:AAEXfKEXfNKXVjJYAKTTLrYwiVmKoWCZTF8"
$REPO_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path
$CLAW3D_DIR = "$env:USERPROFILE\.openclaw\Claw3D"

function Log($msg) { Write-Host "`n[$((Get-Date).ToString('HH:mm:ss'))] $msg" -ForegroundColor Cyan }
function Ok($msg)  { Write-Host "  ✓ $msg" -ForegroundColor Green }
function Fail($msg) { Write-Host "  ✗ $msg" -ForegroundColor Red }

# ── 1. Check Node.js ─────────────────────────────────────────────
Log "Checking Node.js..."
try {
    $nodeVer = (node -v 2>$null)
    if (-not $nodeVer) { throw "not found" }
    $major = [int]($nodeVer -replace 'v(\d+)\..*', '$1')
    if ($major -lt 20) {
        Fail "Node.js $nodeVer found, but 20+ is required."
        Write-Host "  Download: https://nodejs.org" -ForegroundColor Yellow
        exit 1
    }
    Ok "Node.js $nodeVer"
} catch {
    Fail "Node.js not found."
    Write-Host "  Download and install from: https://nodejs.org" -ForegroundColor Yellow
    Write-Host "  Then re-run this script." -ForegroundColor Yellow
    exit 1
}

# ── 2. Install OpenClaw ──────────────────────────────────────────
Log "Installing OpenClaw..."
try {
    $ocVer = (openclaw --version 2>$null)
    if ($ocVer) {
        Ok "OpenClaw already installed: $ocVer"
    } else { throw "not found" }
} catch {
    Write-Host "  Installing openclaw via npm..." -ForegroundColor Yellow
    npm install -g openclaw@latest
    Ok "OpenClaw installed"
}

# ── 3. Write OpenClaw config ─────────────────────────────────────
Log "Configuring OpenClaw..."
$openclawDir = "$env:USERPROFILE\.openclaw"
New-Item -ItemType Directory -Force -Path $openclawDir | Out-Null
New-Item -ItemType Directory -Force -Path "$openclawDir\agents\main\sessions" | Out-Null
New-Item -ItemType Directory -Force -Path "$openclawDir\logs" | Out-Null

$timestamp = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ss.000Z")
$workspacePath = $REPO_DIR -replace '\\', '/'

$config = @"
{
  "meta": {
    "lastTouchedVersion": "2026.3.23-2",
    "lastTouchedAt": "$timestamp"
  },
  "wizard": {
    "lastRunAt": "$timestamp",
    "lastRunVersion": "2026.3.23-2",
    "lastRunCommand": "onboard",
    "lastRunMode": "local"
  },
  "agents": {
    "defaults": {
      "workspace": "$workspacePath",
      "memorySearch": {
        "enabled": false
      }
    }
  },
  "tools": {
    "profile": "coding"
  },
  "commands": {
    "native": "auto",
    "nativeSkills": "auto",
    "restart": true,
    "ownerDisplay": "raw"
  },
  "session": {
    "dmScope": "per-channel-peer"
  },
  "channels": {
    "telegram": {
      "enabled": true,
      "dmPolicy": "pairing",
      "botToken": "$TELEGRAM_BOT_TOKEN",
      "groupPolicy": "allowlist",
      "streaming": "partial"
    }
  },
  "gateway": {
    "port": $GATEWAY_PORT,
    "mode": "local",
    "bind": "loopback",
    "controlUi": {
      "allowedOrigins": [
        "http://localhost:$GATEWAY_PORT",
        "http://127.0.0.1:$GATEWAY_PORT",
        "http://localhost:$CLAW3D_PORT",
        "http://127.0.0.1:$CLAW3D_PORT"
      ]
    },
    "auth": {
      "mode": "token",
      "token": "dd6ad597dd24cb916fd3e29a1dbb20128a3d6f8af50945ec"
    },
    "tailscale": {
      "mode": "off",
      "resetOnExit": false
    }
  }
}
"@

Set-Content -Path "$openclawDir\openclaw.json" -Value $config -Encoding UTF8
Ok "Config written to ~/.openclaw/openclaw.json"

# Init session store
$sessFile = "$openclawDir\agents\main\sessions\sessions.json"
if (-not (Test-Path $sessFile)) {
    Set-Content -Path $sessFile -Value "{}" -Encoding UTF8
}

# ── 4. Create workspace dirs ─────────────────────────────────────
Log "Setting up workspace..."
New-Item -ItemType Directory -Force -Path "$REPO_DIR\memory" | Out-Null
New-Item -ItemType Directory -Force -Path "$REPO_DIR\.openclaw" | Out-Null
Ok "Workspace ready: $REPO_DIR"

# ── 5. Clone & build Claw3D ──────────────────────────────────────
Log "Setting up Claw3D Mission Control..."
if (Test-Path "$CLAW3D_DIR\.next") {
    Ok "Claw3D already built"
} else {
    if (-not (Test-Path $CLAW3D_DIR)) {
        git clone https://github.com/iamlukethedev/Claw3D.git $CLAW3D_DIR
    }

    # Patch layout.tsx to use system fonts
    $layoutContent = @'
import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "Claw3D",
  description: "Focused operator studio for the OpenClaw gateway.",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en" suppressHydrationWarning>
      <head>
        <style
          dangerouslySetInnerHTML={{
            __html: `
              :root {
                --font-display: Impact, Haettenschweiler, "Arial Narrow Bold", sans-serif;
                --font-sans: system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
                --font-mono: ui-monospace, SFMono-Regular, "SF Mono", Menlo, Consolas, "Liberation Mono", monospace;
              }
            `,
          }}
        />
        <script
          dangerouslySetInnerHTML={{
            __html:
              "(function(){try{var t=localStorage.getItem('theme');var m=window.matchMedia('(prefers-color-scheme: dark)').matches;var d=t?t==='dark':m;document.documentElement.classList.toggle('dark',d);}catch(e){}})();",
          }}
        />
      </head>
      <body className="antialiased">
        <main className="h-screen w-screen overflow-hidden bg-background">{children}</main>
      </body>
    </html>
  );
}
'@
    Set-Content -Path "$CLAW3D_DIR\src\app\layout.tsx" -Value $layoutContent -Encoding UTF8

    # Patch next.config.ts
    $nextConfig = @'
import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  serverExternalPackages: ["openclaw"],
};

export default nextConfig;
'@
    Set-Content -Path "$CLAW3D_DIR\next.config.ts" -Value $nextConfig -Encoding UTF8
    Ok "Claw3D patched (system fonts + external packages)"

    Push-Location $CLAW3D_DIR
    npm install --no-audit --no-fund
    Ok "Dependencies installed"

    npm run build
    Ok "Claw3D built"
    Pop-Location
}

# Write Claw3D .env
$envContent = @"
NEXT_PUBLIC_GATEWAY_URL=ws://127.0.0.1:$GATEWAY_PORT
DEBUG=true
PORT=$CLAW3D_PORT
HOST=127.0.0.1
STUDIO_ACCESS_TOKEN=$STUDIO_TOKEN
"@
Set-Content -Path "$CLAW3D_DIR\.env" -Value $envContent -Encoding UTF8
Ok "Claw3D .env written"

# ── 6. Desktop shortcut ──────────────────────────────────────────
Log "Creating desktop shortcut..."
$desktopPath = [Environment]::GetFolderPath("Desktop")
$shortcutPath = "$desktopPath\OpenClaw HexChess.lnk"

$startScript = "$REPO_DIR\start-services.ps1"

# Create the Windows start script
$startPs1 = @"
`$ErrorActionPreference = "Continue"
`$GATEWAY_PORT = $GATEWAY_PORT
`$CLAW3D_PORT = $CLAW3D_PORT
`$CLAW3D_DIR = "$($CLAW3D_DIR -replace '\\', '\\')"
`$STUDIO_TOKEN = "$STUDIO_TOKEN"

Write-Host "Stopping existing services..." -ForegroundColor Cyan
Get-Process -Name "node" -ErrorAction SilentlyContinue | Where-Object { `$_.CommandLine -match "openclaw|claw3d|server/index" } | Stop-Process -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 1

Write-Host "Starting OpenClaw Gateway..." -ForegroundColor Cyan
Start-Process -NoNewWindow -FilePath "openclaw" -ArgumentList "gateway","--port","`$GATEWAY_PORT" -RedirectStandardOutput "`$env:TEMP\openclaw-gateway.log" -RedirectStandardError "`$env:TEMP\openclaw-gateway-err.log"
Start-Sleep -Seconds 3
Write-Host "  Gateway running on port `$GATEWAY_PORT" -ForegroundColor Green

Write-Host "Starting Claw3D Mission Control..." -ForegroundColor Cyan
`$env:HOST = "127.0.0.1"
`$env:PORT = "`$CLAW3D_PORT"
`$env:STUDIO_ACCESS_TOKEN = "`$STUDIO_TOKEN"
`$env:NEXT_PUBLIC_GATEWAY_URL = "ws://127.0.0.1:`$GATEWAY_PORT"
Push-Location "`$CLAW3D_DIR"
Start-Process -NoNewWindow -FilePath "node" -ArgumentList "server/index.js" -RedirectStandardOutput "`$env:TEMP\claw3d.log" -RedirectStandardError "`$env:TEMP\claw3d-err.log"
Pop-Location
Start-Sleep -Seconds 4
Write-Host "  Claw3D running on port `$CLAW3D_PORT" -ForegroundColor Green

Write-Host "`nOpening Claw3D in browser..." -ForegroundColor Cyan
Start-Process "http://127.0.0.1:`$CLAW3D_PORT/office"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  OpenClaw HexChess - READY" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Office:   http://127.0.0.1:`$CLAW3D_PORT/office"
Write-Host "  Agents:   http://127.0.0.1:`$CLAW3D_PORT/agents"
Write-Host "  Builder:  http://127.0.0.1:`$CLAW3D_PORT/office/builder"
Write-Host "  Gateway:  http://127.0.0.1:`$GATEWAY_PORT"
Write-Host "  Telegram: DM your bot to pair!"
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Press any key to stop services and exit..."
`$null = `$Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

Write-Host "Stopping services..." -ForegroundColor Yellow
Get-Process -Name "node" -ErrorAction SilentlyContinue | Where-Object { `$_.CommandLine -match "openclaw|claw3d|server/index" } | Stop-Process -Force -ErrorAction SilentlyContinue
openclaw gateway stop 2>`$null
Write-Host "Done." -ForegroundColor Green
"@

Set-Content -Path $startScript -Value $startPs1 -Encoding UTF8
Ok "start-services.ps1 created"

# Create .lnk shortcut
$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($shortcutPath)
$Shortcut.TargetPath = "powershell.exe"
$Shortcut.Arguments = "-ExecutionPolicy Bypass -File `"$startScript`""
$Shortcut.WorkingDirectory = $REPO_DIR
$Shortcut.Description = "Launch OpenClaw Gateway + Claw3D Mission Control"
$Shortcut.Save()
Ok "Desktop shortcut: $shortcutPath"

# ── 7. Stop existing, launch everything ───────────────────────────
Log "Stopping any existing services..."
Get-Process -Name "node" -ErrorAction SilentlyContinue | Where-Object { $_.CommandLine -match "openclaw|claw3d|server/index" } | Stop-Process -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 2

Log "Starting OpenClaw Gateway..."
Start-Process -NoNewWindow -FilePath "openclaw" -ArgumentList "gateway","--port","$GATEWAY_PORT" -RedirectStandardOutput "$env:TEMP\openclaw-gateway.log" -RedirectStandardError "$env:TEMP\openclaw-gateway-err.log"
Start-Sleep -Seconds 3

# Check gateway
try {
    $health = openclaw health 2>&1
    Ok "Gateway running"
    if ($health -match "Telegram") {
        Ok "Telegram channel active — DM your bot to pair!"
    }
} catch {
    Fail "Gateway may not be running. Check: openclaw health"
}

Log "Starting Claw3D..."
$env:HOST = "127.0.0.1"
$env:PORT = "$CLAW3D_PORT"
$env:STUDIO_ACCESS_TOKEN = $STUDIO_TOKEN
$env:NEXT_PUBLIC_GATEWAY_URL = "ws://127.0.0.1:$GATEWAY_PORT"
Push-Location $CLAW3D_DIR
Start-Process -NoNewWindow -FilePath "node" -ArgumentList "server/index.js" -RedirectStandardOutput "$env:TEMP\claw3d.log" -RedirectStandardError "$env:TEMP\claw3d-err.log"
Pop-Location
Start-Sleep -Seconds 4
Ok "Claw3D running on port $CLAW3D_PORT"

# ── 8. Open browser ──────────────────────────────────────────────
Log "Opening Claw3D in your browser..."
Start-Process "http://127.0.0.1:$CLAW3D_PORT/office"

Write-Host ""
Write-Host "╔═══════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║           🦞  OpenClaw HexChess — READY  🦞              ║" -ForegroundColor Cyan
Write-Host "╠═══════════════════════════════════════════════════════════╣" -ForegroundColor Cyan
Write-Host "║                                                           ║" -ForegroundColor Cyan
Write-Host "║  Office:   http://127.0.0.1:$CLAW3D_PORT/office               ║" -ForegroundColor Cyan
Write-Host "║  Agents:   http://127.0.0.1:$CLAW3D_PORT/agents               ║" -ForegroundColor Cyan
Write-Host "║  Builder:  http://127.0.0.1:$CLAW3D_PORT/office/builder       ║" -ForegroundColor Cyan
Write-Host "║  Gateway:  http://127.0.0.1:$GATEWAY_PORT                     ║" -ForegroundColor Cyan
Write-Host "║                                                           ║" -ForegroundColor Cyan
Write-Host "║  Telegram: DM your bot to pair!                           ║" -ForegroundColor Cyan
Write-Host "║                                                           ║" -ForegroundColor Cyan
Write-Host "╚═══════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""
