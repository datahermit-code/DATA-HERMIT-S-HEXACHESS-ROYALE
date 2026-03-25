# HEARTBEAT.md - DataForge Periodic Tasks

## On Every Heartbeat

1. Check `../../shared/sensei-to-forge/` for evaluation results from DataSensei
2. Check `../../shared/` for new training materials or requests from Data Hermit/HexClaw
3. If there are pending items, work on the highest priority one

## Periodic Tasks (rotate through these)

### Training Corpus Review
- Review `memory/training-corpus.md` for completeness
- Check coverage by domain: which Dm() types have the most/fewest training items?
- Check coverage by difficulty: which levels (1-5) are underrepresented?
- Identify gaps and draft new training items to fill them

### Test Case Maintenance
- Review `memory/test-cases.md`
- Check if any test cases reference operators or syntax that has been updated
- Verify test case expected outputs still comply with current HNLPS rules
- Update stale test cases

### Correction Pattern Mining
- Review `memory/correction-patterns.md`
- Look for patterns that cluster together (e.g., multiple E-TYPE errors in the same domain)
- If a cluster is found, draft a comprehensive training module targeting that weakness
- Send the module to DataSensei

### Enhancement Proposal Follow-up
- Review `memory/enhancement-proposals.md`
- Check if any proposals have been approved/rejected by DataFortuna
- If approved, verify DataDancer has designed the new operator
- If designed, create test cases for the new operator
- Close resolved proposals, update status on open ones

### Spec Cross-Reference
- Pick one section of HNLPS_SUPPLEMENT.md (S1-S19)
- Cross-reference its operators against the test case library
- Identify any operators that have zero test cases
- Draft test cases for uncovered operators

### Proactive Gap Analysis
- Review recent DataDaemon translations (check `../../agents/analyst/memory/`)
- Look for workarounds or awkward constructions that suggest a language gap
- If found, draft an enhancement proposal

## If Nothing Needs Attention

Reply HEARTBEAT_OK.
