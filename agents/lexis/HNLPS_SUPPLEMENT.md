# HNLPS Supplement — Additional Language Features, Semantics, Proof Rules, and System Modules

Designed to be consistent with Hermit Notation foundations: domains, language games, terms-of-art, authority hierarchy, refinement, evidentiary/procedural operators, and phased program structure.

---

## S0. What This Supplement Adds

1. **Lexical rules + precedence + canonical ASCII** (deterministic, LLM-safe)
2. **Namespaces, modules, and imports** (large jurisdictional corpora without collisions)
3. **Authority objects and holding extraction** (computable case law)
4. **Interpretive method semantics** (Txt, Purp, Orig, Len as proof-governed strategies)
5. **Procedural posture, burdens, standards** (executable proof obligations)
6. **Deontic + Hohfeldian modeling** (normative conflict detection)
7. **Temporal logic and legal effectivity** (versions, retroactivity, repeal, amendments)
8. **Balancing / multi-factor tests** (declared factor schemas, defensible evaluation)
9. **Ambiguity management** (CT, Amb, Clar, meaning-set mechanics)
10. **Provenance, quotations, data references** (auditability)
11. **Governance + update mechanics** (patches, signatures, propagation rules)
12. **LLM integration requirements** (grammar-constrained generation, citation-grounding, proof-carrying outputs)

---

## S1. Lexical Layer, Tokenization, and Canonical Forms

### S1.1 Source Encodings and Normalization

HNLPS accepts two surface forms:
- **Unicode HNLP**: `∀`, `∧`, `→`, `⊻`, `□`, etc. (human-friendly)
- **ASCII HNLP**: canonical stable form for storage, hashing, diffing, LLM output

**Rule S1.1(a)**: Every program is normalized to HNLP-ASCII before semantic/proof checking. Unicode is a frontend.

```
∀x (P(x) → Q(x))       =>  FORALL x: (P(x) -> Q(x))
A ∧ B                    =>  (A AND B)
A ⊻ B                    =>  XOR(A,B)
□(X | C)                 =>  NEC_IF(X, C)
O(X | C)                 =>  OBL_IF(X, C)
```

### S1.2 Comments
- `//` single line
- `/* ... */` multi line

### S1.3 Identifiers, Strings, and Quoting
- Identifiers: `[A-Za-z_][A-Za-z0-9_.:-]*` (allows `US.NY.AppDiv1`)
- Strings: `"..."` with escapes `\"`, `\\`, `\n`, `\t`

**Rule S1.3(a)**: Term Labels must be introduced via `ToA("...")` or `CT("...")` using string literals.

### S1.4 Operator Precedence (highest to lowest)

1. Prefix: `¬` / `NOT`
2. Quantifiers: `∀`, `∃` (bind tight to scope)
3. Unary modalities: `□`, `◇`, `O`, `P`, `F`, `R`, `Pow`, `I`
4. Multiplicative set ops
5. `∧` / `AND`
6. `∨` / `OR`
7. `⊻` / `XOR`
8. `→` / `->` (right associative)
9. `↔` / `<->` (non-associative; parentheses required if chained)

**Rule S1.4(a)**: `A ↔ B ↔ C` is rejected unless parenthesized.

### S1.5 Reserved Namespaces

- `HN.` — core language
- `KB.` — knowledge base objects
- `JUR.` — jurisdiction modules
- `AUTH.` — authority registries
- `TEST.` — standardized tests
- `PROC.` — procedural standards

---

## S2. Namespaces, Modules, and Imports

### S2.1 Module Structure
```
import JUR.US.NY;
import AUTH.US.SCOTUS;
import KB.US.NY.Tort.Negligence;
```

**Rule S2.1(a)**: Imports resolved by: pinned KB revision > jurisdiction context > as-of date.

### S2.2 Aliasing
```
import AUTH.US.SCOTUS as SC;
import KB.US.FED.CivProc as CP;
```

### S2.3 Scopes
- Global (imported KB + global authorities)
- Program (current file)
- Block (inside context/definitions/analysis/proof)
- Quantifier (variable-binding)

**Rule S2.3(a)**: `∀x` cannot capture an existing constant unless explicitly shadowed.

---

## S3. Authority Objects and Computable Case Law

### S3.1 Authority Record Schema

Every authority resolves to:
- `id`, `type` (Constitution|Statute|Regulation|Case|AgencyGuidance|Treaty|LegislativeHistory|ForeignAuthority|NonLegalExpertise)
- `jurisdiction`, `court_level`, `effective_from`, `effective_to`
- `status`: good|overruled|superseded|amended|repealed|unknown
- `citation`, `source_uri`, `text_hash`
- `binding_rules` metadata

### S3.2 Bindingness Computation
```
BindStatus(auth, JCtx) : {Binding, Persuasive, NonAuthority}
```

**Rule S3.2(a)**: In `BindingOnly`, only `Binding` authorities justify proof steps.

### S3.3 Holding Extraction Object
```
Holding(
  case = ℘(CaseID),
  rule = (Premises -> Conclusion),
  scope = ScopeSpec(...),
  posture = PostureSpec(...),
  date = "YYYY-MM-DD",
  rank = BindingRank(...)
)
```

**Rule S3.3(a)**: Bare citation without extracted holding cannot discharge legal rule obligations in proof mode.

### S3.4 Dicta Handling
`Dicta(case, statement)` — never binding in BindingOnly mode.

### S3.5 Authority Conflict Resolution Order
1. Higher hierarchy (constitution > statute > regulation > guidance)
2. Higher court (same jurisdiction)
3. Later-in-time (same level, compatible domain)
4. More specific (lex specialis)
5. Express override

**Rule S3.5(a)**: Must declare `ConflictPolicy(DefaultUS)` if proof involves conflicting authorities.

---

## S4. Interpretive Frameworks as Proof-Governed Strategies

### S4.2 Textualism `Txt`
Proof obligations: QuoteObl, ParseObl, AmbiguityObl

### S4.3 Purposivism `Purp`
Proof obligations: PurposeSourceObl, FitObl, ConsistencyObl

### S4.4 Originalism `Orig`
Proof obligations: HistoricalSourceObl, MappingObl

### S4.5 Rule of Lenity `Len`
Prerequisites: `Penal(target) ∧ Amb(target) ∧ AfterTxt(target)`

**Rule S4.5(a)**: Lenity cannot be invoked unless `Amb(target)` has been proven.

### S4.6 Canon Priorities
```
InterpPolicy(
  order = [Txt, Canon("WholeAct"), Purp, Orig, Len],
  weights = { Txt:0.5, Purp:0.2, Orig:0.2, Len:0.1 }
)
```

---

## S5. Common Terms, Ambiguity, and Clarification

### S5.2 Ambiguity Types
- `AmbLex(X)` — lexical ambiguity
- `AmbSyn(phrase)` — syntactic ambiguity
- `AmbScope(expr)` — scope ambiguity
- `AmbDoctr(ToA("X"))` — doctrinal ambiguity
- `AmbVague(ToA("X"))` — vagueness

### S5.4 Label vs Substance
- `Label("X")` — string identity
- `Substance(ToA("X"), JCtx, AsOf)` — meaning set in context/time

**Rule S5.4(a)**: Term reference without JCtx + AsOf is incomplete for proof-checking.

---

## S6. Procedural Posture and Evidentiary Computation

### S6.1 Procedural Stages
`Stage(Pleading)`, `Stage(Discovery)`, `Stage(SummaryJudgment)`, `Stage(Trial)`, `Stage(Appeal)`

### S6.4 Evidence as Objects
```
EItem(e1, type=Document, source=DataRef("..."), supports=NA(P), admissible=true);
EvidFrom(NA(P), [e1]);
```

### S6.6 Burdens Split
- `BProd(party, issue)` — burden of production
- `BPers(party, issue, standard)` — burden of persuasion

### S6.9 Presumptions
```
Presume(NA(AgencyActedProperly))^{AUTH.DefaultAdminLaw};
Evid(NA(ProceduralIrregularity)) -> Rebut(NA(AgencyActedProperly));
ShiftBurden(from, to, issue)
```

---

## S7. Deontic Logic + Hohfeldian + Conflict Detection

### S7.3 Normative Conflict Detection
- Contrary obligations: `O(A)` and `O(¬A)`
- Obligation vs prohibition: `O(A)` and `F(A)`
- Permission conflicts: `P(A)` and `F(A)`

### S7.4 Contrary-to-Duty (CTD)
```
CTD(primary=O(A), violation=¬A, secondary=O(B));
```

---

## S8. Causation Operators

- `ButFor(A,B)` — factual causation
- `SubstantialFactor(A,B)` — alternative factual causation
- `ProxCause(A,B)` — proximate/legal cause
- `InterveningCause(C)`, `Superseding(C)`, `Foreseeable(C)`
- `Causes(A,B)` ≝ `ButFor(A,B) ∧ ProxCause(A,B)` by default
- `CausalChain([A -> E1 -> E2 -> B], doctrine=ButFor+Prox)`

---

## S9. Temporal Logic and Versioned Statutes

- `VersionOf(§(X), asOfDate)`, `Effective(§(X), interval)`
- `Amends(§(X), §(Y), date)`, `Repeals(§(X), date)`
- `Retroactive(§(X))`, `SavingsClause(§(X), clauseRef)`, `TransitionRule(§(X), interval, rule)`

**Rule S9.3(a)**: `AsOf(date)` auto-resolves `§(X)` to `VersionOf(§(X), date)`.

---

## S10. Balancing Tests (Structured)

```
TestSchema(TEST.ReasonablenessBalance,
  factors = [...],
  aggregator = WeightedSum,
  defaultWeights = {...},
  outcomeRule = (Score >= 0.5 -> NN(Reasonable))
);

ApplyTest(TEST.ReasonablenessBalance, inputs = {...}) -> NN(ReasonableSearch);
```

**Rule S10.3(a)**: Balancing outputs must carry factor contributions, evidence links, weight sources, and calculation trace.

---

## S11. Probabilistic Operators (Controlled)

- `Prob(NA(P)) = 0.72`
- Standards as thresholds (policy-defined): Preponderance >= 0.51, ClearConvincing >= 0.75, BRD >= 0.95
- Pluggable aggregation: naive weighted sum, Bayesian, Dempster-Shafer, argumentation-based

---

## S12. Legal Engineering Operators

- `Req(X)` — required element
- `Null(X)` / `∅(X)` — legal nullity
- `Fict(P) forPurpose NN(...)` — legal fiction with declared purpose
- `Disc(actor, decision)` — discretion (produces Underdetermined unless constrained)
- `Est(party, claim)` — estoppel
- `Wav(party, right)` — waiver
- `CondPrec(X, Y)` — condition precedent

---

## S13. Provenance and Data References

### Quote Objects
```
Quote(
  source = §(X) or ℘(Y),
  locator = "Section 2(b)",
  excerptHash = "sha256:...",
  text = "short excerpt"
);
```

### Proof Artifacts
Proof outputs store: normalized program, KB revision, authority IDs + versions, evidence IDs + hashes, proof certificate, diagnostics report.

---

## S14. Knowledge Base Updates and Governance

### Patch Model
```
Patch(
  id="PATCH:2026-01-28:US.NY:Tort:Negligence",
  changes=[RfnTerm("Negligence", Include("NewElement"))^{℘(CaseZ)}],
  requires=[AUTH(℘(CaseZ)).status == good],
  approvedBy=[Reviewer("...")],
  signed=true
)
```

### Safe Propagation
1. Dependency scan
2. Staleness marking
3. Re-check option

### Cloud of Meaning = Assist Layer, NOT Proof Kernel

---

## S15. LLM Integration Rules

1. **Grammar-constrained generation** — valid tokens, structure, arities only
2. **Retrieval-grounded authority linking** — resolve to canonical IDs, check validity
3. **Proof-carrying output** — LLM must propose proof skeleton
4. **Safe ambiguity handling** — emit `Amb(...)` + `Underdetermined` rather than forcing meaning

---

## S16. Error Taxonomy

### Structural: E001-E005
### Authority/Jurisdiction: A101-A104
### Burden/Standard: B201-B203
### Semantic/Legal: S301-S304

Each diagnostic includes: location, failed obligation, dependent rules, suggested fixes.

---

## S17. Interoperability

### Ingestion: Statutes, Cases, Contracts, Motions/Briefs
### Export: HNLP-ASCII, HN-Core IR JSON, ProofCertificate, AuthorityGraph

---

## S19. Extension Protocol

To add a new operator:
1. Signature (arity + types)
2. Rewrite to core primitives
3. Proof rules (intro/elimination)
4. Conflict interaction
5. Jurisdiction parameterization
6. Examples + negative tests
