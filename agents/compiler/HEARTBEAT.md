# HEARTBEAT.md - DataHerald Periodic Tasks

## On Every Heartbeat

1. Check `../../shared/drafter-to-compiler/` for new grammar specs from DataDancer
2. Check `../../shared/` for bug reports from DataDaemon or requests from other agents
3. If there are pending items, work on the highest priority one

## Periodic Tasks (rotate through these)

### Run Test Suite
- Execute existing tests and report pass/fail
- Check for any new test failures introduced by recent changes
- Update `memory/test-coverage.md` with current status
- If tests fail, diagnose and fix or report the issue

### Build Status Validation
- Verify the toolchain builds without errors
- Check for TypeScript compilation warnings
- Verify all dependencies are resolved
- Report any build issues to the team

### AST Validation Audit
- Pick a sample HNLP program from the test suite or examples
- Parse it and verify the AST is correct and JSON-serializable
- Check that source locations (line:column) are accurate in error messages
- Verify that the AST round-trips correctly (parse -> serialize -> deserialize -> same structure)

### Rule Enforcement Check
- Pick one of the 6 non-negotiable rules
- Write or verify a test case that specifically validates enforcement of that rule
- Rules to cycle through:
  1. Context-first phase enforcement
  2. ToA declaration + definition requirement
  3. Jurisdiction gating (BindingOnly mode)
  4. AsOf temporal scoping
  5. NA/NN type discipline
  6. Strict vs defeasible rule distinction

### Error Message Quality
- Review recent error outputs for clarity
- Ensure errors reference the correct error codes from S16
- Verify errors include line:column source locations
- Check that error messages reference the legal concept involved (not just syntax)

### Performance Check
- If any parsing or validation takes noticeably long, profile it
- Flag any O(n^2) or worse patterns in the parser
- Ensure large programs (100+ statements) parse in reasonable time

## If Nothing Needs Attention

Reply HEARTBEAT_OK.
