#!/usr/bin/env bash
set -euo pipefail

# ═══════════════════════════════════════════════════════════════════
# OpenClaw + Claw3D + Telegram — Full Install & Launch
# Run: bash install.sh
# ═══════════════════════════════════════════════════════════════════

GATEWAY_PORT=18789
CLAW3D_PORT=3000
STUDIO_TOKEN="9be097544762f49a3a637d14a2569d54919ba44d68b3c598"
TELEGRAM_BOT_TOKEN="8757185435:AAEXfKEXfNKXVjJYAKTTLrYwiVmKoWCZTF8"
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAW3D_DIR="$HOME/.openclaw/Claw3D"

log()  { printf "\n\033[1;36m[%s]\033[0m %s\n" "$(date +%H:%M:%S)" "$*"; }
ok()   { printf "\033[1;32m  ✓\033[0m %s\n" "$*"; }
fail() { printf "\033[1;31m  ✗\033[0m %s\n" "$*" >&2; }

# ── 1. Check Node.js ─────────────────────────────────────────────
log "Checking Node.js..."
if ! command -v node &>/dev/null; then
  fail "Node.js not found. Install Node 22+ first: https://nodejs.org"
  exit 1
fi
NODE_VER=$(node -v | sed 's/v//' | cut -d. -f1)
if (( NODE_VER < 22 )); then
  fail "Node.js $NODE_VER found, but 22+ is required."
  exit 1
fi
ok "Node.js $(node -v)"

# ── 2. Install OpenClaw ──────────────────────────────────────────
log "Installing OpenClaw..."
if command -v openclaw &>/dev/null; then
  ok "OpenClaw already installed: $(openclaw --version 2>/dev/null || echo 'unknown')"
else
  npm install -g openclaw@latest
  ok "OpenClaw installed: $(openclaw --version)"
fi

# ── 3. Write OpenClaw config ─────────────────────────────────────
log "Configuring OpenClaw..."
mkdir -p "$HOME/.openclaw"

# Get local LAN IP for allowed origins
LAN_IP=$(hostname -I 2>/dev/null | awk '{print $1}' || echo "127.0.0.1")

cat > "$HOME/.openclaw/openclaw.json" << JSONEOF
{
  "meta": {
    "lastTouchedVersion": "2026.3.23-2",
    "lastTouchedAt": "$(date -u +%Y-%m-%dT%H:%M:%S.000Z)"
  },
  "wizard": {
    "lastRunAt": "$(date -u +%Y-%m-%dT%H:%M:%S.000Z)",
    "lastRunVersion": "2026.3.23-2",
    "lastRunCommand": "onboard",
    "lastRunMode": "local"
  },
  "agents": {
    "defaults": {
      "workspace": "${REPO_DIR}",
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
      "botToken": "${TELEGRAM_BOT_TOKEN}",
      "groupPolicy": "allowlist",
      "streaming": "partial"
    }
  },
  "gateway": {
    "port": ${GATEWAY_PORT},
    "mode": "local",
    "bind": "lan",
    "controlUi": {
      "allowedOrigins": [
        "http://${LAN_IP}:${GATEWAY_PORT}",
        "http://localhost:${GATEWAY_PORT}",
        "http://127.0.0.1:${GATEWAY_PORT}",
        "http://localhost:${CLAW3D_PORT}",
        "http://127.0.0.1:${CLAW3D_PORT}",
        "http://${LAN_IP}:${CLAW3D_PORT}"
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
JSONEOF
ok "Config written to ~/.openclaw/openclaw.json"

# ── 4. Create workspace dirs + sessions ──────────────────────────
log "Setting up workspace..."
mkdir -p "$REPO_DIR/memory"
mkdir -p "$REPO_DIR/.openclaw"
mkdir -p "$HOME/.openclaw/agents/main/sessions"
mkdir -p "$HOME/.openclaw/logs"

# Initialize session store if missing
if [ ! -f "$HOME/.openclaw/agents/main/sessions/sessions.json" ]; then
  echo '{}' > "$HOME/.openclaw/agents/main/sessions/sessions.json"
fi
ok "Workspace ready: $REPO_DIR"

# ── 5. Clone & build Claw3D ──────────────────────────────────────
log "Setting up Claw3D Mission Control..."
if [ -d "$CLAW3D_DIR/.next" ]; then
  ok "Claw3D already built at $CLAW3D_DIR"
else
  if [ ! -d "$CLAW3D_DIR" ]; then
    git clone https://github.com/iamlukethedev/Claw3D.git "$CLAW3D_DIR"
  fi
  cd "$CLAW3D_DIR"

  # Patch layout.tsx to use system fonts (avoids Google Fonts dependency)
  cat > src/app/layout.tsx << 'LAYOUTEOF'
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
LAYOUTEOF

  # Add serverExternalPackages for openclaw module
  cat > next.config.ts << 'NEXTEOF'
import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  serverExternalPackages: ["openclaw"],
};

export default nextConfig;
NEXTEOF

  ok "Claw3D patched (system fonts + external packages)"

  npm install --no-audit --no-fund
  ok "Dependencies installed"

  npm run build
  ok "Claw3D built"
fi

# ── 6. Write Claw3D .env ─────────────────────────────────────────
cat > "$CLAW3D_DIR/.env" << ENVEOF
NEXT_PUBLIC_GATEWAY_URL=ws://127.0.0.1:${GATEWAY_PORT}
DEBUG=true
PORT=${CLAW3D_PORT}
HOST=0.0.0.0
STUDIO_ACCESS_TOKEN=${STUDIO_TOKEN}
ENVEOF
ok "Claw3D .env written"

# ── 7. Desktop shortcut ──────────────────────────────────────────
log "Creating desktop shortcut..."
DESKTOP_DIR="$HOME/Desktop"
mkdir -p "$DESKTOP_DIR"
mkdir -p "$HOME/.local/share/applications"

cat > "$DESKTOP_DIR/OpenClaw-HexChess.desktop" << DESKEOF
[Desktop Entry]
Version=1.0
Type=Application
Name=OpenClaw HexChess
Comment=Launch OpenClaw Gateway + Claw3D Mission Control
Icon=application-x-executable
Exec=bash ${REPO_DIR}/start-services.sh
Terminal=true
Categories=Development;Game;
Keywords=openclaw;claw3d;hexchess;ai;agents;
StartupNotify=true
DESKEOF

chmod +x "$DESKTOP_DIR/OpenClaw-HexChess.desktop"
cp "$DESKTOP_DIR/OpenClaw-HexChess.desktop" "$HOME/.local/share/applications/"

# Trust on GNOME
gio set "$DESKTOP_DIR/OpenClaw-HexChess.desktop" metadata::trusted true 2>/dev/null || true

ok "Desktop shortcut: ~/Desktop/OpenClaw-HexChess.desktop"

# ── 8. Shell aliases ──────────────────────────────────────────────
if ! grep -q "openclaw-launch" "$HOME/.bashrc" 2>/dev/null; then
  cat >> "$HOME/.bashrc" << 'ALIASEOF'

# OpenClaw HexChess quick launch
alias openclaw-launch='bash ~/DATA-HERMIT-S-HEXACHESS-ROYALE/start-services.sh'
alias openclaw-stop='bash ~/DATA-HERMIT-S-HEXACHESS-ROYALE/start-services.sh --stop'
ALIASEOF
  ok "Shell aliases added (openclaw-launch / openclaw-stop)"
else
  ok "Shell aliases already exist"
fi

# ── 9. Stop existing services ────────────────────────────────────
log "Stopping any existing services..."
pkill -f "openclaw gateway" 2>/dev/null || true
pkill -f "node server/index.js" 2>/dev/null || true
sleep 2

# ── 10. Launch Gateway ────────────────────────────────────────────
log "Starting OpenClaw Gateway..."
openclaw gateway --bind lan --port "$GATEWAY_PORT" &>/tmp/openclaw-gateway.log &
GATEWAY_PID=$!
sleep 3

if kill -0 "$GATEWAY_PID" 2>/dev/null; then
  ok "Gateway running on port $GATEWAY_PORT (PID $GATEWAY_PID)"
else
  fail "Gateway failed to start — check /tmp/openclaw-gateway.log"
  cat /tmp/openclaw-gateway.log
  exit 1
fi

# ── 11. Verify Telegram ──────────────────────────────────────────
log "Checking Telegram connection..."
sleep 2
TELEGRAM_STATUS=$(openclaw channels status --probe 2>&1 || true)
if echo "$TELEGRAM_STATUS" | grep -q "probe ok"; then
  ok "Telegram bot connected!"
elif echo "$TELEGRAM_STATUS" | grep -q "running"; then
  ok "Telegram channel running (pairing ready — DM your bot)"
else
  fail "Telegram status: $TELEGRAM_STATUS"
  echo "    Check: openclaw channels logs"
fi

# ── 12. Launch Claw3D ─────────────────────────────────────────────
log "Starting Claw3D Mission Control..."
cd "$CLAW3D_DIR"
HOST=0.0.0.0 \
PORT="$CLAW3D_PORT" \
STUDIO_ACCESS_TOKEN="$STUDIO_TOKEN" \
NEXT_PUBLIC_GATEWAY_URL="ws://127.0.0.1:$GATEWAY_PORT" \
node server/index.js &>/tmp/claw3d.log &
CLAW3D_PID=$!
sleep 4

if kill -0 "$CLAW3D_PID" 2>/dev/null; then
  ok "Claw3D running on port $CLAW3D_PORT (PID $CLAW3D_PID)"
else
  fail "Claw3D failed to start — check /tmp/claw3d.log"
  cat /tmp/claw3d.log
  exit 1
fi

# ── 13. Open browser ─────────────────────────────────────────────
log "Opening Claw3D in browser..."
OFFICE_URL="http://127.0.0.1:${CLAW3D_PORT}/office"
if command -v xdg-open &>/dev/null; then
  xdg-open "$OFFICE_URL" 2>/dev/null &
elif command -v open &>/dev/null; then
  open "$OFFICE_URL" 2>/dev/null &
fi

# ── Done ──────────────────────────────────────────────────────────
echo
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║           🦞  OpenClaw HexChess — READY  🦞              ║"
echo "╠═══════════════════════════════════════════════════════════╣"
echo "║                                                           ║"
echo "║  Gateway:  ws://127.0.0.1:${GATEWAY_PORT}                       ║"
echo "║  Office:   http://127.0.0.1:${CLAW3D_PORT}/office               ║"
echo "║  Builder:  http://127.0.0.1:${CLAW3D_PORT}/office/builder       ║"
echo "║  Agents:   http://127.0.0.1:${CLAW3D_PORT}/agents               ║"
echo "║                                                           ║"
echo "║  Telegram: DM your bot to pair!                           ║"
echo "║  Cookie:   studio_access=${STUDIO_TOKEN}                  ║"
echo "║                                                           ║"
echo "║  Stop:     ./start-services.sh --stop                     ║"
echo "║            or: openclaw-stop                              ║"
echo "║                                                           ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo
