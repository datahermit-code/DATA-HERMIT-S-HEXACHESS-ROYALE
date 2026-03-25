# TOOLS.md - HexClaw Environment

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

### Telegram Channel
- **Bot:** @HexClawBot (or whatever username you chose in BotFather)
- **Mode:** polling
- **Config:** token stored in `~/.openclaw/openclaw.json` under `channels.telegram`
- **Pairing:** DM the bot in Telegram; it will respond once the gateway is running with internet access

### Desktop Shortcut
- **Location:** `~/Desktop/OpenClaw-HexChess.desktop`
- Launches gateway + Claw3D and opens the office in your browser

## Hermit Notation Project Files

### Core Specifications
- **HNLPS_RULES.md** -- The 6 non-negotiable rules for HNLPS
- **HNLPS_SUPPLEMENT.md** -- 19 supplement sections (S0-S19) with extended language features
- **HERMIT_NOTATION_SPEC.md** -- Original full HN specification

### Agent Directories
- `agents/lexis/` -- DataScribe (legal research)
- `agents/drafter/` -- DataDancer (language design)
- `agents/compiler/` -- DataHerald (implementation)
- `agents/analyst/` -- DataDaemon (translation/testing)
- `agents/arbiter/` -- DataFortuna (project lead/QA)
- `agents/sensei/` -- DataSensei (training overseer)
- `agents/forge/` -- DataForge (training processor & language refiner)

### Shared Communication Hub
- `shared/` -- Inter-agent task and result exchange (see AGENTS.md for directory structure)

## Team Communication

To delegate work to agents, write task files to the `shared/` directory. Each agent checks its incoming directories on heartbeats.

To communicate directly with an agent during a session, address them by their role directory name.

## Notes

- Google Fonts are unavailable in this environment; Claw3D layout.tsx patched to use system font fallbacks
- Memory search disabled (no embedding provider)
- Gateway systemd service unavailable (container) -- use foreground or nohup
- Telegram probe fails in container (no outbound to api.telegram.org) -- works on real machine
