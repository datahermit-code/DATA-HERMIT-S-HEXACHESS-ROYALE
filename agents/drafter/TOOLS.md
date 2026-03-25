# TOOLS.md - DataDancer Environment

## Project Reference Files

### Core Specifications (in project root: `../../`)
- **HNLPS_RULES.md** -- The 6 non-negotiable rules. Your designs must comply with ALL of them.
- **HNLPS_SUPPLEMENT.md** -- Sections S0-S19. Key sections for you:
  - S1: Lexical layer, tokenization, precedence table, reserved namespaces (HN., KB., JUR., AUTH., TEST., PROC.)
  - S2: Namespaces, modules, imports, aliasing, scopes
  - S3: Authority objects schema (what operators reference)
  - S4: Interpretive framework semantics (Txt, Purp, Orig, Len proof obligations)
  - S7: Deontic + Hohfeldian modeling, CTD (contrary-to-duty)
  - S10: Balancing tests (TestSchema, ApplyTest, factor schemas)
  - S11: Probabilistic operators (Prob, standards as thresholds)
  - S12: Legal engineering operators (Req, Null, Fict, Disc, Est, Wav, CondPrec)
  - S16: Error taxonomy (E001-E005, A101-A104, B201-B203, S301-S304)
  - S19: Extension protocol (how to add new operators)
- **HERMIT_NOTATION_SPEC.md** -- Full original HN specification with complete operator inventory

### Your Workspace
- `SOUL.md` -- Your role definition
- `USER.md` -- Data Hermit's profile
- `memory/` -- Daily logs, grammar changelog, design decisions
- `MEMORY.md` -- Long-term design wisdom

### Shared Workspace
- `../../shared/lexis-to-drafter/` -- Incoming analyses from DataScribe
- `../../shared/drafter-to-compiler/` -- Your grammar specs for DataHerald
- `../../shared/drafter-to-analyst/` -- Your syntax proposals for DataDaemon to test
- `../../shared/drafter-proposals/` -- Your design proposals for DataFortuna review

## Repository Access

Project root: `/home/user/DATA-HERMIT-S-HEXACHESS-ROYALE/`

## Available Tools

- **File read/write**: Read specs, write proposals and grammar files
- **Web search**: Research programming language design patterns, formal grammar techniques
- **Git**: Track changes to specs and grammar

## Team Contact Protocol

| Agent | Name | When to Contact | How |
|-------|------|-----------------|-----|
| DataScribe | lexis | Need deeper legal analysis for a construct | `../../shared/drafter-to-lexis/` |
| DataHerald | compiler | Delivering grammar specs for implementation | `../../shared/drafter-to-compiler/` |
| DataDaemon | analyst | Syntax proposals for translation testing | `../../shared/drafter-to-analyst/` |
| DataFortuna | arbiter | Design proposals needing approval | `../../shared/drafter-proposals/` |

## Quick Reference: Operator Precedence (S1.4)

1. Prefix: NOT / negation
2. Quantifiers: FORALL, EXISTS
3. Unary modalities: NEC, POSS, OBL, PERM, FORB, RIGHT, POW, IMM
4. Multiplicative set ops
5. AND
6. OR
7. XOR
8. -> (right-associative)
9. <-> (non-associative, must parenthesize chains)

## Quick Reference: Type Taxonomy

```
World claims:  NA(P) -- empirical, needs evidence
Legal claims:  NN(P) -- institutional, needs authority + proof
Entities:      Party, Authority, Standard, Proposition
Deontic:       Obligation, Permission, Prohibition, Right, Power, Immunity
Structural:    Condition, Exception, Remedy, Clause, Document
```
