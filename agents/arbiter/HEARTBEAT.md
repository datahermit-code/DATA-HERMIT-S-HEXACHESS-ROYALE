# HEARTBEAT.md - DataFortuna Periodic Tasks

## On Every Heartbeat

1. Check ALL shared directories for pending items addressed to you:
   - `../../shared/lexis-to-arbiter/` -- ambiguity escalations
   - `../../shared/drafter-proposals/` -- design proposals
   - `../../shared/compiler-to-arbiter/` -- architecture decisions
   - `../../shared/analyst-to-arbiter/` -- translations for review
2. If there are pending reviews, work on the highest priority one
3. Check if any agent appears blocked and needs unblocking

## Periodic Tasks (rotate through these)

### Team Progress Review
- Check each agent's recent `memory/YYYY-MM-DD.md` for activity:
  - `../../agents/lexis/memory/` -- DataScribe
  - `../../agents/drafter/memory/` -- DataDancer
  - `../../agents/compiler/memory/` -- DataHerald
  - `../../agents/analyst/memory/` -- DataDaemon
  - `../../agents/sensei/memory/` -- DataSensei
  - `../../agents/forge/memory/` -- DataForge
- Identify who is blocked, idle, or productive
- Issue priority guidance if any agent is off-track

### Quality Audit
- Pick a random recent deliverable from any agent
- Review it against the 6 non-negotiable rules
- Check it against the relevant HNLPS_SUPPLEMENT sections
- If issues found, send corrections to the responsible agent

### Roadmap Update
- Review `memory/roadmap.md`
- Update progress on active priorities
- Move completed items to the completed section
- Reprioritize if new information has emerged
- Report status to HexClaw/Data Hermit if significant changes

### ADR Review
- Review recent ADRs in `memory/decisions/`
- Check if any ADR consequences have been implemented
- Check if any ADR needs to be superseded based on new information
- Ensure the ADR archive is consistent and up to date

### Spec Consistency Check
- Re-read one section of HNLPS_RULES.md or HNLPS_SUPPLEMENT.md
- Verify it is consistent with recent team decisions (ADRs)
- If a contradiction is found, draft a resolution and notify Data Hermit

### Standards Compliance Review
- Check HNLPS features against one external standard (LegalXML, Akoma Ntoso, or LegalRuleML)
- Document where HNLPS aligns and where it diverges
- For divergences, verify the rationale is documented

### Gap Report Triage
- Review open gaps from DataDaemon in `../../shared/analyst-gaps/`
- Prioritize which gaps should be addressed first
- Assign priority guidance to DataDancer for resolution

## If Nothing Needs Attention

Reply HEARTBEAT_OK.
