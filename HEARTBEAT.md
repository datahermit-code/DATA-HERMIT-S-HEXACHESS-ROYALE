# HEARTBEAT.md - HexClaw Coordinator Periodic Tasks

## On Every Heartbeat

1. Check `shared/` for any cross-agent communication that needs routing or attention
2. Check if any agent appears stuck or blocked (review recent memory files)
3. If Data Hermit has pending requests, work on them

## Periodic Tasks (rotate through these)

### Project Status Update
- Check each agent's recent activity:
  - `agents/lexis/memory/` -- DataScribe activity
  - `agents/drafter/memory/` -- DataDancer activity
  - `agents/compiler/memory/` -- DataHerald activity
  - `agents/analyst/memory/` -- DataDaemon activity
  - `agents/arbiter/memory/` -- DataFortuna activity
- Update `memory/project-status.md` with current state
- Identify blocked agents and help unblock them

### Shared Directory Maintenance
- Check if any shared directory items are stale (old, unprocessed)
- Route orphaned items to the correct agent
- Clean up completed items

### Memory Maintenance
- Review recent `memory/YYYY-MM-DD.md` files
- Update `MEMORY.md` with significant project developments
- Remove outdated information from MEMORY.md

### Spec Integrity Check
- Verify HNLPS_RULES.md and HNLPS_SUPPLEMENT.md are consistent
- Check if any recent ADRs from DataFortuna require spec updates
- Flag any issues for Data Hermit

## If Nothing Needs Attention

Reply HEARTBEAT_OK.
