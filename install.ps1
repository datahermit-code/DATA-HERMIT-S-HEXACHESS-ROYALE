# OpenClaw + Claw3D + Telegram - Full Install and Launch (Windows)
# Run: powershell -ExecutionPolicy Bypass -File install.ps1

$ErrorActionPreference = "Stop"

$GATEWAY_PORT = 18789
$CLAW3D_PORT = 3000
$STUDIO_TOKEN = "9be097544762f49a3a637d14a2569d54919ba44d68b3c598"
$TELEGRAM_BOT_TOKEN = "8757185435:AAEXfKEXfNKXVjJYAKTTLrYwiVmKoWCZTF8"
$REPO_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path
$CLAW3D_DIR = "$env:USERPROFILE\.openclaw\Claw3D"

function Log($msg) { Write-Host "[setup] $msg" -ForegroundColor Cyan }
function Ok($msg)  { Write-Host "  [OK] $msg" -ForegroundColor Green }
function Fail($msg) { Write-Host "  [FAIL] $msg" -ForegroundColor Red }

# 1. Check Node.js
Log "Checking Node.js..."
$nodeVer = $null
try { $nodeVer = (node -v 2>$null) } catch {}
if (-not $nodeVer) {
    Fail "Node.js not found. Download from https://nodejs.org and re-run."
    exit 1
}
$major = [int]($nodeVer -replace 'v(\d+)\..*', '$1')
if ($major -lt 20) {
    Fail "Node.js $nodeVer found but 20+ required."
    exit 1
}
Ok "Node.js $nodeVer"

# 2. Install OpenClaw
Log "Installing OpenClaw..."
$ocVer = $null
try { $ocVer = (openclaw --version 2>$null) } catch {}
if ($ocVer) {
    Ok "OpenClaw already installed: $ocVer"
} else {
    Write-Host "  Installing openclaw via npm..." -ForegroundColor Yellow
    npm install -g openclaw@latest
    Ok "OpenClaw installed"
}

# 3. Write OpenClaw config
Log "Configuring OpenClaw..."
$openclawDir = "$env:USERPROFILE\.openclaw"
New-Item -ItemType Directory -Force -Path $openclawDir | Out-Null
New-Item -ItemType Directory -Force -Path "$openclawDir\agents\main\sessions" | Out-Null
New-Item -ItemType Directory -Force -Path "$openclawDir\logs" | Out-Null

$timestamp = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ss.000Z")
$workspacePath = $REPO_DIR -replace '\\', '/'

$configJson = '{
  "meta": {
    "lastTouchedVersion": "2026.3.23-2",
    "lastTouchedAt": "' + $timestamp + '"
  },
  "wizard": {
    "lastRunAt": "' + $timestamp + '",
    "lastRunVersion": "2026.3.23-2",
    "lastRunCommand": "onboard",
    "lastRunMode": "local"
  },
  "agents": {
    "defaults": {
      "workspace": "' + $workspacePath + '",
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
      "botToken": "' + $TELEGRAM_BOT_TOKEN + '",
      "groupPolicy": "allowlist",
      "streaming": "partial"
    }
  },
  "gateway": {
    "port": ' + $GATEWAY_PORT + ',
    "mode": "local",
    "bind": "loopback",
    "controlUi": {
      "allowedOrigins": [
        "http://localhost:' + $GATEWAY_PORT + '",
        "http://127.0.0.1:' + $GATEWAY_PORT + '",
        "http://localhost:' + $CLAW3D_PORT + '",
        "http://127.0.0.1:' + $CLAW3D_PORT + '"
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
}'

[System.IO.File]::WriteAllText("$openclawDir\openclaw.json", $configJson, [System.Text.Encoding]::UTF8)
Ok "Config written"

$sessFile = "$openclawDir\agents\main\sessions\sessions.json"
if (-not (Test-Path $sessFile)) {
    Set-Content -Path $sessFile -Value "{}" -Encoding UTF8
}

# 4. Workspace dirs
Log "Setting up workspace..."
New-Item -ItemType Directory -Force -Path "$REPO_DIR\memory" | Out-Null
New-Item -ItemType Directory -Force -Path "$REPO_DIR\.openclaw" | Out-Null
Ok "Workspace ready"

# 5. Clone and build Claw3D
Log "Setting up Claw3D Mission Control..."
if (Test-Path "$CLAW3D_DIR\.next") {
    Ok "Claw3D already built"
} else {
    if (-not (Test-Path $CLAW3D_DIR)) {
        Log "Cloning Claw3D (this may take a minute)..."
        git clone https://github.com/iamlukethedev/Claw3D.git $CLAW3D_DIR
    }

    # Patch layout.tsx - system fonts instead of Google Fonts
    $layoutTsx = @"
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
            __html: ``
              :root {
                --font-display: Impact, Haettenschweiler, Arial, sans-serif;
                --font-sans: system-ui, -apple-system, BlinkMacSystemFont, Segoe UI, Roboto, Arial, sans-serif;
                --font-mono: ui-monospace, SFMono-Regular, Menlo, Consolas, monospace;
              }
            ``,
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
"@
    # Fix the backtick escaping for JSX template literals
    $layoutTsx = $layoutTsx -replace '``', '`'
    [System.IO.File]::WriteAllText("$CLAW3D_DIR\src\app\layout.tsx", $layoutTsx, [System.Text.Encoding]::UTF8)

    # Patch next.config.ts
    $nextCfg = @"
import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  serverExternalPackages: ["openclaw"],
};

export default nextConfig;
"@
    [System.IO.File]::WriteAllText("$CLAW3D_DIR\next.config.ts", $nextCfg, [System.Text.Encoding]::UTF8)
    Ok "Claw3D patched"

    Push-Location $CLAW3D_DIR
    Log "Installing Claw3D dependencies (this may take a few minutes)..."
    npm install --no-audit --no-fund
    Ok "Dependencies installed"

    Log "Building Claw3D (this may take a few minutes)..."
    npm run build
    Ok "Claw3D built"
    Pop-Location
}

# Write .env
$envContent = "NEXT_PUBLIC_GATEWAY_URL=ws://127.0.0.1:$GATEWAY_PORT`nDEBUG=true`nPORT=$CLAW3D_PORT`nHOST=127.0.0.1`nSTUDIO_ACCESS_TOKEN=$STUDIO_TOKEN"
[System.IO.File]::WriteAllText("$CLAW3D_DIR\.env", $envContent, [System.Text.Encoding]::UTF8)
Ok "Claw3D .env written"

# 6. Desktop shortcut
Log "Creating desktop shortcut..."
$desktopPath = [Environment]::GetFolderPath("Desktop")
$shortcutPath = "$desktopPath\OpenClaw HexChess.lnk"

# Create start-services.ps1
$startScript = "$REPO_DIR\start-services.ps1"
$startContent = @"
`$ErrorActionPreference = "Continue"

Write-Host "=== OpenClaw HexChess Launcher ===" -ForegroundColor Cyan
Write-Host ""

# Stop old instances
Write-Host "Stopping old services..." -ForegroundColor Yellow
Get-Process -Name "node" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
Start-Sleep 2

# Start Gateway
Write-Host "Starting OpenClaw Gateway..." -ForegroundColor Cyan
Start-Process -FilePath "openclaw" -ArgumentList "gateway --port $GATEWAY_PORT" -WindowStyle Hidden
Start-Sleep 3
Write-Host "  Gateway running on port $GATEWAY_PORT" -ForegroundColor Green

# Start Claw3D
Write-Host "Starting Claw3D..." -ForegroundColor Cyan
`$env:HOST = "127.0.0.1"
`$env:PORT = "$CLAW3D_PORT"
`$env:STUDIO_ACCESS_TOKEN = "$STUDIO_TOKEN"
`$env:NEXT_PUBLIC_GATEWAY_URL = "ws://127.0.0.1:$GATEWAY_PORT"
Start-Process -FilePath "node" -ArgumentList "server/index.js" -WorkingDirectory "$CLAW3D_DIR" -WindowStyle Hidden
Start-Sleep 4
Write-Host "  Claw3D running on port $CLAW3D_PORT" -ForegroundColor Green

# Open browser
Start-Process "http://127.0.0.1:$CLAW3D_PORT/office"

Write-Host ""
Write-Host "=== READY ===" -ForegroundColor Green
Write-Host "  Office:   http://127.0.0.1:$CLAW3D_PORT/office"
Write-Host "  Agents:   http://127.0.0.1:$CLAW3D_PORT/agents"
Write-Host "  Telegram: DM your bot to pair!"
Write-Host ""
Write-Host "Press any key to stop services..."
`$null = `$Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
Get-Process -Name "node" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
"@
[System.IO.File]::WriteAllText($startScript, $startContent, [System.Text.Encoding]::UTF8)

# Create .lnk
$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($shortcutPath)
$Shortcut.TargetPath = "powershell.exe"
$Shortcut.Arguments = "-ExecutionPolicy Bypass -File `"$startScript`""
$Shortcut.WorkingDirectory = $REPO_DIR
$Shortcut.Description = "Launch OpenClaw Gateway and Claw3D Mission Control"
$Shortcut.Save()
Ok "Desktop shortcut created"

# 7. Stop existing services
Log "Stopping any running services..."
Get-Process -Name "node" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
Start-Sleep 2

# 8. Start Gateway
Log "Starting OpenClaw Gateway..."
Start-Process -FilePath "openclaw" -ArgumentList "gateway --port $GATEWAY_PORT" -WindowStyle Hidden
Start-Sleep 3
try {
    $health = openclaw health 2>&1
    Ok "Gateway running"
    $healthStr = $health | Out-String
    if ($healthStr -match "Telegram") {
        Ok "Telegram channel active - DM your bot to pair!"
    }
} catch {
    Fail "Gateway might not be running. Run: openclaw health"
}

# 9. Start Claw3D
Log "Starting Claw3D..."
$env:HOST = "127.0.0.1"
$env:PORT = "$CLAW3D_PORT"
$env:STUDIO_ACCESS_TOKEN = $STUDIO_TOKEN
$env:NEXT_PUBLIC_GATEWAY_URL = "ws://127.0.0.1:$GATEWAY_PORT"
Start-Process -FilePath "node" -ArgumentList "server/index.js" -WorkingDirectory $CLAW3D_DIR -WindowStyle Hidden
Start-Sleep 4
Ok "Claw3D running on port $CLAW3D_PORT"

# 10. Open browser
Log "Opening browser..."
Start-Process "http://127.0.0.1:$CLAW3D_PORT/office"

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  OpenClaw HexChess is READY" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host "  Office:   http://127.0.0.1:$CLAW3D_PORT/office" -ForegroundColor White
Write-Host "  Agents:   http://127.0.0.1:$CLAW3D_PORT/agents" -ForegroundColor White
Write-Host "  Builder:  http://127.0.0.1:$CLAW3D_PORT/office/builder" -ForegroundColor White
Write-Host "  Gateway:  http://127.0.0.1:$GATEWAY_PORT" -ForegroundColor White
Write-Host "  Telegram: DM your bot to pair!" -ForegroundColor White
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
