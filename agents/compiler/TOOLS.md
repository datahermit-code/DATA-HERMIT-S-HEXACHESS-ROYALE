# TOOLS.md - DataHerald Environment

## Project Reference Files

### Core Specifications (in project root: `../../`)
- **HNLPS_RULES.md** -- The 6 non-negotiable rules. Your implementation MUST enforce all of them.
- **HNLPS_SUPPLEMENT.md** -- Sections S0-S19. Key sections for you:
  - S1: Lexical layer -- tokenization rules, Unicode/ASCII mapping, precedence table, reserved namespaces
  - S2: Namespaces, modules, imports -- scope resolution rules
  - S3: Authority objects schema -- data structures for authorities, bindingness computation
  - S6: Procedural posture, evidence objects -- EItem, EvidFrom structures
  - S10: Balancing tests -- TestSchema, ApplyTest implementation
  - S11: Probabilistic operators -- threshold computation
  - S13: Provenance -- Quote objects, proof artifacts, hashing
  - S14: KB updates, patch model -- versioning implementation
  - S15: LLM integration rules -- grammar-constrained generation
  - S16: Error taxonomy -- ALL error codes you must implement
  - S17: Interoperability -- ingestion/export formats (HNLP-ASCII, HN-Core IR JSON, ProofCertificate, AuthorityGraph)
  - S19: Extension protocol -- how new operators enter the system
- **HERMIT_NOTATION_SPEC.md** -- Full original specification

### Source Code
- Implementation lives in the project repository
- Check `../../src/` or similar for existing code
- Tests in `../../tests/` or `../../__tests__/`

### Your Workspace
- `SOUL.md` -- Your role definition
- `USER.md` -- Data Hermit's profile
- `memory/` -- Daily logs, implementation changelog, bug tracker, test coverage
- `MEMORY.md` -- Architectural decisions and lessons learned

### Shared Workspace
- `../../shared/drafter-to-compiler/` -- Incoming grammar specs from DataDancer
- `../../shared/compiler-to-drafter/` -- Your feedback to DataDancer
- `../../shared/compiler-to-analyst/` -- Tools and builds for DataDaemon
- `../../shared/compiler-to-arbiter/` -- Architecture decisions for DataFortuna

## Repository Access

Project root: `/home/user/DATA-HERMIT-S-HEXACHESS-ROYALE/`

Use git for version control. Commit working code with descriptive messages.

## Available Tools

- **File read/write**: Read specs, write source code and tests
- **Bash/Terminal**: Run TypeScript/Node.js, execute tests, build toolchain
- **Git**: Version control, branching, committing
- **Web search**: Research parser techniques, TypeScript patterns

## Team Contact Protocol

| Agent | Name | When to Contact | How |
|-------|------|-----------------|-----|
| HexClaw | Coordinator | When you need Data Hermit's input | Write to `../../shared/` or respond directly |
| DataDancer | drafter | Grammar ambiguity, impractical design, spec questions | `../../shared/compiler-to-drafter/` |
| DataScribe | lexis | Legal language edge cases affecting parsing | `../../shared/compiler-to-lexis/` |
| DataDaemon | analyst | Delivering built tools for testing | `../../shared/compiler-to-analyst/` |
| DataFortuna | arbiter | Architecture decisions, spec contradictions | `../../shared/compiler-to-arbiter/` |
| DataSensei | sensei | When training reveals toolchain issues | Respond to reports in `../../shared/` |
| DataForge | forge | When DataForge sends KB patches or implementation requirements | `../../shared/forge-to-compiler/` (incoming) |

## Quick Reference: AST Node Types

```typescript
// Core node types from the spec
CallNode        // Function calls: Dm(), LG(), ToA(), O(), P(), F(), etc.
OperatorNode    // Binary/unary: ->, <->, AND, OR, NOT, XOR
IfNode          // Conditionals
SetLiteral      // {element1, element2, ...}
Identifier      // Names and constants
StringLiteral   // "quoted strings"
SubscriptNode   // _Standard (standard of review)
SuperscriptNode // ^{Authority} (authority source)
ProofBlock      // proof Name { Asm, Derive, Conclude }
ProgramNode     // Top-level: program Name { context, definitions, analysis, outputs }
ContextBlock    // context { ... }
DefinitionsBlock // definitions { ... }
AnalysisBlock   // analysis { ... }
OutputsBlock    // outputs { ... }
```

## Quick Reference: Error Codes

```
Structural:           E001-E005 (phase violations, missing blocks)
Authority/Jurisdiction: A101-A104 (binding violations, missing JCtx)
Burden/Standard:      B201-B203 (wrong standard, missing burden)
Semantic/Legal:       S301-S304 (NA/NN violations, type mismatches)
```
