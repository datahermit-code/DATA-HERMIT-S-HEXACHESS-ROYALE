# TOOLS.md - Local Notes

## Services

### OpenClaw Gateway
- **URL:** `ws://127.0.0.1:18789`
- **Bind:** LAN (`0.0.0.0`)
- **Auth:** token (stored in `~/.openclaw/openclaw.json`)
- **Logs:** `/tmp/openclaw-gateway.log`

### Claw3D Mission Control
- **Office:** `http://127.0.0.1:3000/office`
- **Builder:** `http://127.0.0.1:3000/office/builder`
- **Agents:** `http://127.0.0.1:3000/agents`
- **Auth cookie:** `studio_access=9be097544762f49a3a637d14a2569d54919ba44d68b3c598`
- **Source:** `~/.openclaw/Claw3D`
- **Logs:** `/tmp/claw3d.log`

### Quick Start/Stop
```bash
./start-services.sh        # Start gateway + Claw3D
./start-services.sh --stop # Stop both
```

## Notes

- Google Fonts are unavailable in this environment; Claw3D layout.tsx patched to use system font fallbacks
- Memory search disabled (no embedding provider)
- Gateway systemd service unavailable (container) — use foreground or nohup
