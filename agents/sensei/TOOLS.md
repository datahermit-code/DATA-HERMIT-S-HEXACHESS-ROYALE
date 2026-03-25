# TOOLS.md - DataSensei Environment

## Project Reference Files

### Core Specifications (in project root: `../../`)
- **HNLPS_RULES.md** -- The 6 non-negotiable rules. These are the foundation of your scoring rubric.
- **HNLPS_SUPPLEMENT.md** -- Sections S0-S19. Key sections for evaluation:
  - S1: Lexical layer, ASCII canonical forms (for structural correctness scoring)
  - S3: Authority objects, bindingness (for authority accuracy scoring)
  - S4: Interpretive frameworks (for legal fidelity scoring)
  - S5: Ambiguity types (for completeness scoring)
  - S6: Procedural posture, burdens (for legal fidelity scoring)
  - S7: Deontic + Hohfeldian (for operator correctness scoring)
  - S8: Causation operators (for operator correctness scoring)
  - S16: Error taxonomy (for error classification alignment)
- **HERMIT_NOTATION_SPEC.md** -- Full specification for operator reference

### Your Workspace
- `SOUL.md` -- Your role definition
- `USER.md` -- Data Hermit's profile
- `memory/` -- Training metrics, curriculum, error patterns
- `MEMORY.md` -- Long-term training insights

### Shared Workspace
- `../../shared/sensei-to-analyst/` -- Training exercises for DataDaemon
- `../../shared/sensei-to-forge/` -- Results for DataForge
- `../../shared/sensei-to-arbiter/` -- Quality questions for DataFortuna
- `../../shared/sensei-to-drafter/` -- Syntax questions for DataDancer
- `../../shared/forge-to-sensei/` -- Training materials from DataForge

## Repository Access

Project root: `/home/user/DATA-HERMIT-S-HEXACHESS-ROYALE/`

## Available Tools

- **File read/write**: Read translations, write evaluations and training exercises
- **Git**: Review DataDaemon's translation history

## Team Contact Protocol

| Agent | Name | When to Contact | How |
|-------|------|-----------------|-----|
| DataDaemon | analyst | Deliver exercises, request translations to evaluate | `../../shared/sensei-to-analyst/` |
| DataForge | forge | Send results, receive training materials | `../../shared/sensei-to-forge/` |
| DataDancer | drafter | Verify correct HN syntax when uncertain | `../../shared/sensei-to-drafter/` |
| DataFortuna | arbiter | Quality standard questions, curriculum approval | `../../shared/sensei-to-arbiter/` |

## Quick Reference: Scoring Rubric

```
Dimension           | Rule Basis      | Weight
--------------------|-----------------|-------
Structural (0-10)   | Rules 1, 2      | Phase order, declarations
Legal Fidelity (0-10)| Domain knowledge| Accurate legal mapping
HNLPS Compliance (0-10)| Rules 3-6   | Type discipline, jurisdiction, temporal, defeasible
Completeness (0-10) | Full spec       | All concepts captured, ambiguities flagged
Readability (0-10)  | Design goals    | Lawyer-understandable
TOTAL: /50          |                 | Pass threshold: 40/50
```

## Quick Reference: Error Taxonomy

```
E-PHASE    Phase ordering violation
E-DECL     Missing declaration (ToA, authority, JCtx)
E-TYPE     NA/NN confusion
E-OP       Wrong operator choice
E-AUTH     Wrong authority or binding status
E-STD      Wrong standard of proof/review
E-TEMPORAL Time scoping error
E-DEFEAS   Strict/defeasible confusion
E-COMPLETE Missing legal concepts
E-READ     Poor readability
```
