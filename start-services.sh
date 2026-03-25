#!/usr/bin/env bash
set -euo pipefail

# ── OpenClaw Gateway + Claw3D Mission Control launcher ──
# Usage: ./start-services.sh [--stop]

GATEWAY_PORT=18789
CLAW3D_PORT=3000
CLAW3D_DIR="$HOME/.openclaw/Claw3D"
STUDIO_ACCESS_TOKEN="9be097544762f49a3a637d14a2569d54919ba44d68b3c598"

log() { printf "\033[1;36m[launcher]\033[0m %s\n" "$*"; }

stop_services() {
  log "Stopping services..."
  pkill -f "openclaw gateway" 2>/dev/null || true
  pkill -f "node server/index.js" 2>/dev/null || true
  log "Services stopped."
}

if [[ "${1:-}" == "--stop" ]]; then
  stop_services
  exit 0
fi

# Stop any existing instances
stop_services
sleep 1

# Start OpenClaw Gateway
log "Starting OpenClaw Gateway on port $GATEWAY_PORT (LAN)..."
openclaw gateway --bind lan --port "$GATEWAY_PORT" &>/tmp/openclaw-gateway.log &
GATEWAY_PID=$!
sleep 2

if ! kill -0 "$GATEWAY_PID" 2>/dev/null; then
  echo "ERROR: Gateway failed to start. Check /tmp/openclaw-gateway.log"
  exit 1
fi
log "Gateway running (PID $GATEWAY_PID)"

# Start Claw3D Mission Control
log "Starting Claw3D Mission Control on port $CLAW3D_PORT..."
cd "$CLAW3D_DIR"
HOST=0.0.0.0 \
PORT="$CLAW3D_PORT" \
STUDIO_ACCESS_TOKEN="$STUDIO_ACCESS_TOKEN" \
NEXT_PUBLIC_GATEWAY_URL="ws://127.0.0.1:$GATEWAY_PORT" \
node server/index.js &>/tmp/claw3d.log &
CLAW3D_PID=$!
sleep 3

if ! kill -0 "$CLAW3D_PID" 2>/dev/null; then
  echo "ERROR: Claw3D failed to start. Check /tmp/claw3d.log"
  exit 1
fi
log "Claw3D running (PID $CLAW3D_PID)"

echo
log "All services running!"
echo "  Gateway:        http://127.0.0.1:$GATEWAY_PORT"
echo "  Claw3D Office:  http://127.0.0.1:$CLAW3D_PORT/office"
echo "  Claw3D Builder: http://127.0.0.1:$CLAW3D_PORT/office/builder"
echo "  Agents:         http://127.0.0.1:$CLAW3D_PORT/agents"
echo
echo "  Studio cookie:  studio_access=$STUDIO_ACCESS_TOKEN"
echo
echo "  Stop with: ./start-services.sh --stop"
