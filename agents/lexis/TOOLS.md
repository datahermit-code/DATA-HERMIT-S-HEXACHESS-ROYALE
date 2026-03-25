# TOOLS.md - DataScribe Environment

## Project Reference Files

These are your primary sources of truth. Read them before starting any analysis.

### Core Specifications (in project root: `../../`)
- **HNLPS_RULES.md** -- The 6 non-negotiable rules. Memorize these. Every analysis must comply.
- **HNLPS_SUPPLEMENT.md** -- Sections S0-S19. Key sections for you:
  - S1: Lexical layer, tokenization, canonical forms (ASCII vs Unicode)
  - S3: Authority objects, bindingness computation, holding extraction
  - S4: Interpretive frameworks (Txt, Purp, Orig, Len)
  - S5: Common terms, ambiguity types (AmbLex, AmbSyn, AmbScope, AmbDoctr, AmbVague)
  - S6: Procedural posture, burdens, standards, evidence objects
  - S7: Deontic logic, Hohfeldian incidents, normative conflict detection
  - S8: Causation operators (ButFor, SubstantialFactor, ProxCause, Causes)
  - S9: Temporal logic, versioned statutes
  - S12: Legal engineering operators (Req, Null, Fict, Disc, Est, Wav, CondPrec)
  - S13: Provenance and data references
- **HERMIT_NOTATION_SPEC.md** -- Full original HN specification with operator inventory

### Your Workspace
- `SOUL.md` -- Your role definition
- `USER.md` -- Data Hermit's profile
- `memory/` -- Your daily logs and pattern library
- `MEMORY.md` -- Your long-term curated memory

### Shared Workspace (for inter-agent communication)
- `../../shared/lexis-to-drafter/` -- Your analyses for DataDancer
- `../../shared/lexis-to-arbiter/` -- Your escalations for DataFortuna

## Repository Access

The project lives at: `/home/user/DATA-HERMIT-S-HEXACHESS-ROYALE/`

You can browse the full repository to find examples, prior analyses, and reference materials. Use `git log` to see project history.

## Available Tools and Skills

- **File read/write**: Read any file in the workspace, write analyses and memory files
- **Web search**: Research legal concepts, find case citations, look up statutes (when available)
- **Git**: Check project status, view history of changes
- **Inter-agent messaging**: Write to shared directories for other agents to pick up

## Team Contact Protocol

| Agent | Name | When to Contact | How |
|-------|------|-----------------|-----|
| HexClaw | Coordinator | When you need Data Hermit's input | Write to `../../shared/` or respond directly |
| DataDancer | drafter | Completed analyses ready for syntax design | Write to `../../shared/lexis-to-drafter/` |
| DataHerald | compiler | Edge cases in legal language that affect parsing | Write to `../../shared/lexis-to-compiler/` |
| DataDaemon | analyst | Collaborate on document structure before translation | Write to `../../shared/lexis-to-analyst/` |
| DataFortuna | arbiter | Ambiguity escalation, legal accuracy questions | Write to `../../shared/lexis-to-arbiter/` |

## Quick Reference: Key HNLPS Operators You Map To

```
Deontic:     O() P() F() R() Pow() I()
Context:     Dm() LG() JCtx() AsOf()
Terms:       ToA() CT() DefTerm() RfnTerm() OS() CS()
Authority:   aleph() section() wp() Reg() Hrc()
Logic:       -> <-> AND OR NOT XOR
Evidence:    NA() NN() Evid() BProd() BPers()
Temporal:    Before After Until Since During AsOf VersionOf Effective
Ambiguity:   Amb() AmbLex() AmbSyn() AmbScope() AmbDoctr() AmbVague() Clar()
Causation:   ButFor() SubstantialFactor() ProxCause() Causes() CausalChain()
Procedural:  Stage() EItem() EvidFrom()
Interpretive: Txt() Purp() Orig() Len()
Legal Eng:   Req() Null() Fict() Disc() Est() Wav() CondPrec()
```
