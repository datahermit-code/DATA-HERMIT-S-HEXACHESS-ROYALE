# TOOLS.md - DataFortuna Environment

## Project Reference Files

### Core Specifications (in project root: `../../`)
- **HNLPS_RULES.md** -- The 6 non-negotiable rules. You are the ultimate enforcer of these rules across the team.
- **HNLPS_SUPPLEMENT.md** -- Sections S0-S19. You need ALL sections:
  - S1-S2: Lexical layer, namespaces (for design review)
  - S3: Authority objects, bindingness, holding extraction (for legal accuracy review)
  - S4: Interpretive frameworks (for ambiguity resolution)
  - S5: Ambiguity types and clarification (for ambiguity resolution)
  - S6: Procedural posture, burdens (for translation review)
  - S7: Deontic + Hohfeldian (for normative conflict review)
  - S8: Causation (for tort translation review)
  - S9: Temporal logic (for temporal accuracy review)
  - S10: Balancing tests (for constitutional law review)
  - S11: Probabilistic operators (for standard-of-proof review)
  - S12: Legal engineering operators (for contract review)
  - S13: Provenance (for audit trail review)
  - S14: Governance, patch model (for KB update review)
  - S15: LLM integration rules (for AI-assisted workflow review)
  - S16: Error taxonomy (for implementation review)
  - S17: Interoperability (for standards compliance)
  - S19: Extension protocol (for new operator review)
- **HERMIT_NOTATION_SPEC.md** -- Full original specification

### Standards for Compliance
- **LegalXML** -- XML-based legal document standards
- **Akoma Ntoso** -- UN standard for legislative documents
- **LegalRuleML** -- Rule Interchange Format for legal rules
- Where HNLPS diverges from these, you document why

### Your Workspace
- `SOUL.md` -- Your role definition
- `USER.md` -- Data Hermit's profile
- `memory/` -- Daily logs, ADR archive, roadmap, review queue
- `MEMORY.md` -- Key decisions and project wisdom

### Shared Workspace
- `../../shared/lexis-to-arbiter/` -- Ambiguity escalations from DataScribe
- `../../shared/drafter-proposals/` -- Design proposals from DataDancer
- `../../shared/compiler-to-arbiter/` -- Architecture decisions from DataHerald
- `../../shared/analyst-to-arbiter/` -- Translations from DataDaemon for review
- `../../shared/arbiter-to-lexis/` -- Your directives to DataScribe
- `../../shared/arbiter-to-drafter/` -- Your decisions to DataDancer
- `../../shared/arbiter-to-compiler/` -- Your decisions to DataHerald
- `../../shared/arbiter-to-analyst/` -- Your corrections to DataDaemon
- `../../shared/arbiter-to-sensei/` -- Your quality standard updates to DataSensei
- `../../shared/arbiter-to-forge/` -- Your enhancement approvals to DataForge
- `../../shared/sensei-to-arbiter/` -- Quality questions from DataSensei
- `../../shared/forge-to-arbiter/` -- Progress reports from DataForge

## Repository Access

Project root: `/home/user/DATA-HERMIT-S-HEXACHESS-ROYALE/`

## Available Tools

- **File read/write**: Read all team outputs, write reviews and decisions
- **Web search**: Research legal standards, check citations, verify legal accuracy
- **Git**: Review project history, track spec changes

## Team Contact Protocol

| Agent | Name | Role | You Review |
|-------|------|------|------------|
| DataScribe | lexis | Legal research | Structural analyses, ambiguity flags |
| DataDancer | drafter | Language design | Syntax proposals, grammar extensions, new operators |
| DataHerald | compiler | Implementation | Architecture decisions, spec contradictions |
| DataDaemon | analyst | Translation/testing | HNLP translations, gap reports |
| DataSensei | sensei | Training overseer | Curriculum design, scoring rubrics, quality standards |
| DataForge | forge | Training processor & language refiner | Enhancement proposals, training corpus, cycle reports |

## ADR Template

```markdown
## ADR-NNN: [Title]

**Date**: YYYY-MM-DD
**Status**: Accepted / Rejected / Deferred / Superseded by ADR-XXX
**Decider**: DataFortuna (with Data Hermit veto if applicable)

### Context
[Why this decision was needed]

### Decision
[What was decided]

### Rationale
- Legal fidelity: [assessment]
- Readability: [assessment]
- Implementability: [assessment]
- Consistency: [assessment]
- Extensibility: [assessment]

### Consequences
[What follows from this decision]

### Alternatives Considered
[What else was evaluated and why it was rejected]
```
