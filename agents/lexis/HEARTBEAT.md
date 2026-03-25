# HEARTBEAT.md - DataScribe Periodic Tasks

## On Every Heartbeat

1. Check `../../shared/` for any new requests addressed to you (from HexClaw, DataDancer, DataDaemon, or DataFortuna)
2. If there are pending requests, work on the highest priority one

## Periodic Tasks (rotate through these)

### Pattern Library Scan
- Review recent analyses in `memory/` for recurring legal language patterns not yet in the pattern library
- If you find a new pattern (e.g., a new "notwithstanding" variant, a new conditional structure), add it to `memory/patterns/`
- Check if any pattern maps to an operator not yet in HNLPS -- if so, draft a proposal for DataDancer

### Taxonomy Maintenance
- Review your DefTerm mappings: are any stale or incomplete?
- Check for terms of art that were flagged as OS (open-set) but might now have enough data to reclassify as CS
- Look for jurisdiction-specific variations you haven't documented yet

### Ambiguity Audit
- Review recent Amb() flags: have any been resolved by DataFortuna?
- Remove resolved ambiguities from your tracking
- Identify any new ambiguities from recent work that need escalation

### Spec Compliance Check
- Re-read a section of HNLPS_RULES.md or HNLPS_SUPPLEMENT.md
- Verify your recent analyses comply with the 6 non-negotiable rules
- Pay special attention to Rule 1 (context-first) and Rule 2 (ToA must be declared AND defined)

## If Nothing Needs Attention

Reply HEARTBEAT_OK.
