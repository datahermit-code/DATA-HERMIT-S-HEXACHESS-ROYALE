# HNLPS — Hermit Notation Legal Programming System

## Core Operational Rules

These are the "compiler rules" that make HNLPS proof-checkable and jurisdiction-correct.
All agents MUST enforce these rules in their work.

---

## Minimal Valid HNLP Program

```hnlp
program MinimalExample {
  context {
    JCtx(juris=US.FED, forum=US.NY.SDNY, level=Trial, bindingMode=BindingOnly);
    AsOf("2026-01-28");
    Dm(TortLaw);
    LG(NegligenceJurisprudence);
    ℘(StateX_NegligenceElementsCase);
  }

  definitions {
    ToA("Negligence"); CS("Negligence");
    DefTerm("Negligence", { Duty, Breach, Causation, Damages });

    ( NA(Duty(Def,Pl)) ∧ NA(Breach(Def)) ∧ NA(Causes(Breach(Def),Injury(Pl))) ∧ NA(Damages(Pl)) )
      → NN(Negligence(Def)) )^{℘(StateX_NegligenceElementsCase)};
  }

  analysis {
    Evid(NA(Duty(Def,Pl)));
    Evid(NA(Breach(Def)));

    proof DemoProof {
      Asm(a1, NA(Duty(Def,Pl)));
      Asm(a2, NA(Breach(Def)));
      Derive(d1, NA(Duty(Def,Pl)) ∧ NA(Breach(Def)), AndIntro, [a1,a2]);
      Conclude(c1, NN(Negligence(Def)), MP, [
        ( NA(Duty(Def,Pl)) ∧ NA(Breach(Def)) → NN(Negligence(Def)) )^{℘(StateX_NegligenceElementsCase)},
        d1
      ]);
    }
  }

  outputs {
    Check(NN(Negligence(Def)));
    C(NN(Negligence(Def)));
  }
}
```

---

## The Six Non-Negotiable Rules

### Rule 1: Context First (Phase Enforcement)

Your program MUST declare in `context {}` before anything else:
- **JCtx(...)** — jurisdiction context (juris, forum, level, bindingMode)
- **AsOf("YYYY-MM-DD")** — temporal scope
- **Dm(...)** — legal domain
- **LG(...)** — language game
- **Authority sources** — any ℵ, §, ℘, Reg you will cite

If you use a term-of-art, authority, or doctrine test before declaring context, **HNLPS rejects the program**.

### Rule 2: Every Term-of-Art Must Be Declared AND Defined

If you use `ToA("X")`, you MUST also:
- Declare whether its meaning set is **open or closed** (OS/CS)
- Define a baseline meaning: `DefTerm("X", {...})`
- Or explicitly mark it open with a baseline and refinement policy

This turns vague legal words into **machine-checkable semantics**.

### Rule 3: Jurisdiction Gating Is Real

When `bindingMode=BindingOnly`, the proof checker will:
- **Compute** whether each authority is binding in the active JCtx
- **Reject** proof steps that use non-binding authorities as step-justifiers
- **Allow** non-binding authority only as "persuasive annotation"

### Rule 4: Time Scoping Is Mandatory

HNLPS treats statutes and precedents as **time-scoped**:
- `AsOf(date)` selects statute versions and term refinements in force on that date
- If an authority is not effective as-of the proof date, use triggers an **error**

### Rule 5: NA vs NN Is a Type Discipline

This is ENFORCED, not commentary:
- **NA(P)** = empirical fact claim ("world claim")
- **NN(P)** = institutional/legal status claim ("law claim")

A proof **cannot**:
- Satisfy a factual obligation using only authority citations
- Satisfy a legal-status obligation using only empirical evidence
- Unless a **bridge rule** exists

### Rule 6: Strict vs Defeasible Rules Are Explicitly Different

- `A → B` is **strict** (monotonic)
- `A ⇒ B` is **defeasible** (can be defeated)
- `Exc(cond, defeated)` defeats a rule/conclusion under conditions

This is required for real-law reasoning (exceptions, conflicts, priority).

---

## Canonical Operator Policy (No Overloads)

The original HN draft had ⊕ used as both XOR and legal cause. HNLPS resolves this:

- **⊻ / XOR(...)** = exclusive-or
- **Causes(A, B)** = legal causation

```hnlp
(Damages ⊻ SpecificPerformance);    // XOR
Causes(ActualCause, Injury(Pl));     // causation
```

If a user uses ⊕ for causation, the **linter flags it as an error**.

---

## Program Structure (Updated from HN Four Phases)

```
program ProgramName {
  context {
    // JCtx, AsOf, Dm, LG, authority declarations
  }

  definitions {
    // ToA, OS/CS, DefTerm, RfnTerm, rules with authority annotations
  }

  analysis {
    // Evid, logical reasoning, proof blocks, balancing tests
    proof ProofName {
      Asm(label, proposition);
      Derive(label, proposition, InferenceRule, [dependencies]);
      Conclude(label, proposition, InferenceRule, [dependencies]);
    }
  }

  outputs {
    // Check(), C(), Rem(), Liab(), Annotate()
  }
}
```

---

## Key HNLPS Extensions Beyond Base HN

1. **JCtx()** — Jurisdiction context with forum, level, binding mode
2. **AsOf()** — Mandatory temporal scoping
3. **Proof blocks** — Formal proof with Asm/Derive/Conclude steps
4. **Inference rules** — AndIntro, MP (modus ponens), and legal-specific rules
5. **Defeasible reasoning** — ⇒ for defeasible rules, Exc() for exceptions
6. **Causes()** — Dedicated causation operator (replaces ambiguous ⊕)
7. **⊻ / XOR()** — Unambiguous exclusive-or
8. **Binding mode enforcement** — BindingOnly vs persuasive annotation
9. **NA/NN type discipline** — Enforced at proof level
10. **Versioned authorities** — Time-scoped statute/precedent references

---

## Full Specification

The complete HNLPS manual includes:
- **Surface Grammar (EBNF)**: program structure, statements, expressions, annotations
- **HN-Core IR model**: typed AST, canonicalization rules, alias mapping
- **Full Operator Inventory** with name, symbol, ASCII alias, arity, type signature, semantics, examples
- **Proof Kernel Rules**: propositional/quantifier/set inference + legal-specific inference
- **Jurisdiction + Bindingness Engine**: JCtx requirements, binding-only vs persuasive, Hrc application
- **System-wide Update + Governance**: versioned authorities, RfnTerm patches, AI-assisted workflow
- **Translation Rules**: statutes, cases, contracts, briefs → HNLP templates
- **Worked Examples**: negligence, statute with exceptions, end-to-end
