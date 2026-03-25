# HEARTBEAT.md - DataDaemon Periodic Tasks

## On Every Heartbeat

1. Check `../../shared/` for new requests, analyses, or syntax proposals addressed to you
2. Check `../../shared/drafter-to-analyst/` for new syntax from DataDancer to test
3. If there are pending items, work on the highest priority one

## Periodic Tasks (rotate through these)

### Translation Spec Compliance Test
- Pick one existing translation from your test suite
- Re-validate it against the current HNLPS_RULES.md (all 6 rules)
- Check it against any recent grammar changes from DataDancer
- Fix any compliance issues and document the changes

### Gap Tracker Review
- Review `memory/gap-tracker.md` for open gaps
- Check if DataDancer has resolved any gaps with new operators
- If so, re-attempt the translation that originally exposed the gap
- Close resolved gaps, update status on open ones

### New Domain Test Case
- Identify a legal domain (Dm) that has few or no test translations yet
- Draft a simple Level 1 translation for that domain
- This expands the language's proven coverage
- Domains to prioritize: TortLaw, ContractLaw, ConstitutionalLaw, CriminalLaw, AdminLaw, CivilProcedure

### Translation Readability Check
- Pick a recent translation
- Read it as if you were a lawyer seeing HNLP for the first time
- Can you follow the logic from context through to outputs?
- Note any confusing syntax or unclear operator usage in `memory/usability-notes.md`

### Authority Accuracy Audit
- Pick a translation that cites multiple authorities
- Verify each authority reference is correct:
  - Is it aleph() for constitutional, section() for statute, wp() for case law?
  - Is the binding status correct for the declared JCtx?
  - Is the authority effective as-of the declared AsOf date?
- Flag any errors

### Minimal Example Maintenance
- Verify the minimal valid program from HNLPS_RULES.md still works:
  ```hnlp
  program MinimalExample {
    context { JCtx(...); AsOf("..."); Dm(...); LG(...); wp(...); }
    definitions { ToA("..."); CS("..."); DefTerm("...", {...}); }
    analysis { Evid(NA(...)); proof P { Asm(...); Derive(...); Conclude(...); } }
    outputs { Check(NN(...)); C(NN(...)); }
  }
  ```
- If it has changed due to spec updates, update the example

## If Nothing Needs Attention

Reply HEARTBEAT_OK.
