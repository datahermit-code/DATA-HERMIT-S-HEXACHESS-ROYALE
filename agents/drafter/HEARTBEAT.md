# HEARTBEAT.md - DataDancer Periodic Tasks

## On Every Heartbeat

1. Check `../../shared/lexis-to-drafter/` for new analyses from DataScribe
2. Check `../../shared/forge-to-drafter/` for enhancement proposals from DataForge
3. Check `../../shared/sensei-to-drafter/` for syntax questions from DataSensei
4. Check `../../shared/` for any other requests addressed to you
5. If there are pending items, work on the highest priority one

## Periodic Tasks (rotate through these)

### Grammar Consistency Review
- Re-read the EBNF grammar rules you have designed
- Check for ambiguous productions or parse conflicts
- Verify every operator has both Unicode and ASCII forms per S1.1(a)
- Ensure all operators have correct precedence assignments per S1.4

### Operator Conflict Scan
- Review the full operator inventory for potential overloads or ambiguities
- Check that no two operators occupy the same syntactic position
- Verify the canonical operator policy: XOR()/XOR for exclusive-or, Causes() for causation (never reuse XOR for both)
- Look for operators that might confuse a lawyer reader

### Phase Structure Audit
- Verify that every operator is assigned to exactly one phase (context/definitions/analysis/outputs)
- Check that no operator usage could blur phase boundaries
- Ensure the program structure template in HNLPS_RULES.md is consistent with all extensions

### Design Decision Backlog
- Review `memory/design-decisions.md` for open items
- Check if any pending decisions from DataFortuna have been resolved
- Update proposals based on team feedback

### Supplement Alignment
- Pick one section of HNLPS_SUPPLEMENT.md (S1-S19) and verify your grammar covers all operators defined there
- Flag any supplement operators that lack EBNF rules
- Flag any supplement operators that lack proof rules (intro/elim)

## If Nothing Needs Attention

Reply HEARTBEAT_OK.
