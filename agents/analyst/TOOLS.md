# TOOLS.md - DataDaemon Environment

## Project Reference Files

### Core Specifications (in project root: `../../`)
- **HNLPS_RULES.md** -- The 6 non-negotiable rules. Every translation MUST comply.
- **HNLPS_SUPPLEMENT.md** -- Sections S0-S19. Key sections for you:
  - S1: Lexical layer, ASCII canonical forms (your translations should use ASCII form)
  - S3: Authority objects, holding extraction (how to encode case law)
  - S4: Interpretive frameworks (when translations involve statutory interpretation)
  - S5: Ambiguity management (CT, Amb, Clar, meaning-set mechanics)
  - S6: Procedural posture, burdens, evidence objects (for case translations)
  - S7: Deontic + Hohfeldian (for obligation/right/power/immunity translations)
  - S8: Causation operators (for tort translations)
  - S9: Temporal logic, versioned statutes (for statute translations)
  - S10: Balancing tests (for constitutional law translations)
  - S12: Legal engineering operators (for contract translations)
  - S17: Interoperability -- ingestion templates for statutes, cases, contracts, motions/briefs
- **HERMIT_NOTATION_SPEC.md** -- Full original specification with all operators

### Translation Templates (from S17)

The supplement defines ingestion patterns for:
- **Statutes**: section structure, conditions, exceptions, penalties
- **Cases**: holdings, reasoning chains, procedural posture, dicta
- **Contracts**: obligations, conditions precedent, remedies, definitions
- **Motions/Briefs**: legal arguments, authority chains, relief requested

### Your Workspace
- `SOUL.md` -- Your role definition
- `USER.md` -- Data Hermit's profile
- `memory/` -- Daily logs, test index, gap tracker, usability notes
- `MEMORY.md` -- Translation patterns and lessons learned

### Shared Workspace
- `../../shared/lexis-to-analyst/` -- Structural analyses from DataScribe
- `../../shared/drafter-to-analyst/` -- Syntax proposals from DataDancer to test
- `../../shared/compiler-to-analyst/` -- Tools from DataHerald
- `../../shared/analyst-gaps/` -- Your gap reports
- `../../shared/analyst-to-arbiter/` -- Translations for DataFortuna review
- `../../shared/analyst-to-compiler/` -- Bug reports for DataHerald
- `../../shared/analyst-to-lexis/` -- Analysis requests for DataScribe

## Repository Access

Project root: `/home/user/DATA-HERMIT-S-HEXACHESS-ROYALE/`

Look for example translations in `../../examples/` or `../../tests/` if they exist.

## Available Tools

- **File read/write**: Read legal documents and specs, write HNLP translations
- **Web search**: Look up statutes, cases, legal text for translation source material
- **Git**: Track translation versions
- **HNLP toolchain** (if built by DataHerald): `hn parse`, `hn check`, `hn validate`

## Team Contact Protocol

| Agent | Name | When to Contact | How |
|-------|------|-----------------|-----|
| DataScribe | lexis | Need structural analysis before translating | `../../shared/analyst-to-lexis/` |
| DataDancer | drafter | Language gap -- can't express a legal construct | `../../shared/analyst-gaps/` |
| DataHerald | compiler | Tool bug or validation issue | `../../shared/analyst-to-compiler/` |
| DataFortuna | arbiter | Translation ready for legal accuracy review | `../../shared/analyst-to-arbiter/` |

## Quick Reference: Translation Patterns

### Negligence (Dm(TortLaw))
```hnlp
(NA(Duty(Def,Pl)) AND NA(Breach(Def)) AND NA(Causes(Breach(Def),Injury(Pl))) AND NA(Damages(Pl)))
  -> NN(Negligence(Def)))^{wp(StateX_NegligenceCase)};
```

### Strict Scrutiny (Dm(ConstitutionalLaw))
```hnlp
ApplyTest(TEST.StrictScrutiny,
  inputs = { law=section(X), interest=CompellingInterest, tailoring=NarrowlyTailored }
) -> NN(Constitutional(section(X)));
```

### Contract Formation (Dm(ContractLaw))
```hnlp
(NA(Offer(P1,P2)) AND NA(Acceptance(P2)) AND NA(Consideration(P1,P2)))
  -> NN(ValidContract(P1,P2));
```

### Defeasible Rule with Exception
```hnlp
NA(Possession(D, Contraband)) => NN(Guilty(D, PossessionOffense));
Exc(NA(ValidPrescription(D)), NN(Guilty(D, PossessionOffense)));
```
