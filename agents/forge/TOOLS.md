# TOOLS.md - DataForge Environment

## Project Reference Files

### Core Specifications (in project root: `../../`)
- **HNLPS_RULES.md** -- The 6 non-negotiable rules. Use these to validate correct answers.
- **HNLPS_SUPPLEMENT.md** -- Sections S0-S19. Key sections for you:
  - S1: Lexical layer, ASCII forms (for test case validation)
  - S3: Authority objects (for holding extraction training materials)
  - S5: Ambiguity types (for training on Amb() usage)
  - S7: Deontic + Hohfeldian (for deontic operator training)
  - S8: Causation (for tort-domain training)
  - S9: Temporal logic (for versioned statute training)
  - S10: Balancing tests (for constitutional law training)
  - S12: Legal engineering operators (for contract training)
  - S16: Error taxonomy (for error classification)
  - S17: Interoperability -- ingestion templates (for translation training)
  - S19: Extension protocol (for enhancement proposals)
- **HERMIT_NOTATION_SPEC.md** -- Full specification

### Your Workspace
- `SOUL.md` -- Your role definition
- `USER.md` -- Data Hermit's profile
- `memory/` -- Training corpus, test cases, correction patterns, enhancement proposals, cycle reports
- `MEMORY.md` -- Long-term patterns and insights

### Shared Workspace
- `../../shared/forge-to-sensei/` -- Training materials for DataSensei
- `../../shared/forge-to-drafter/` -- Enhancement proposals for DataDancer
- `../../shared/forge-to-compiler/` -- KB patches for DataHerald
- `../../shared/forge-to-lexis/` -- Analysis requests for DataScribe
- `../../shared/forge-to-arbiter/` -- Progress reports for DataFortuna
- `../../shared/sensei-to-forge/` -- Evaluation results from DataSensei

## Repository Access

Project root: `/home/user/DATA-HERMIT-S-HEXACHESS-ROYALE/`

## Available Tools

- **File read/write**: Process materials, write training artifacts
- **Web search**: Research legal concepts for training material creation
- **Git**: Track training corpus and test case evolution

## Team Contact Protocol

| Agent | Name | When to Contact | How |
|-------|------|-----------------|-----|
| DataSensei | sensei | Deliver training materials, receive evaluation results | `../../shared/forge-to-sensei/` |
| DataDancer | drafter | Enhancement proposals, syntax clarifications | `../../shared/forge-to-drafter/` |
| DataHerald | compiler | KB patches, implementation requirements | `../../shared/forge-to-compiler/` |
| DataScribe | lexis | Request structural analysis of new materials | `../../shared/forge-to-lexis/` |
| DataFortuna | arbiter | Progress reports, enhancement approvals | `../../shared/forge-to-arbiter/` |

## Quick Reference: Artifact ID Schemes

```
TI-NNN   Training Item
TC-NNN   Test Case
CP-NNN   Correction Pattern
EP-NNN   Enhancement Proposal
CR-NNN   Cycle Report
```

## Quick Reference: Difficulty Levels

```
Level 1: Basic clauses (single obligation, simple condition)
Level 2: Multi-element tests (negligence, contract formation)
Level 3: Complex structures (defeasible rules, multi-party, temporal)
Level 4: Full programs (complete statutes, holdings, proof blocks)
Level 5: Edge cases (ambiguity, conflicts, retroactivity, CTD, cross-jurisdiction)
```
