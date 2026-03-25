# HEARTBEAT.md - DataSensei Periodic Tasks

## On Every Heartbeat

1. Check `../../shared/forge-to-sensei/` for new training materials from DataForge
2. Check `../../shared/analyst-to-arbiter/` for new translations from DataDaemon that you can also evaluate
3. Check `../../shared/` for any requests addressed to you
4. If there are pending items, work on the highest priority one

## Periodic Tasks (rotate through these)

### Score Recent Translations
- Check if DataDaemon has produced any new translations (in `../../agents/analyst/memory/`)
- If so, evaluate the most recent one using the 5-dimension rubric
- Update training metrics in `memory/training-metrics.md`

### Error Pattern Analysis
- Review `memory/error-patterns.md`
- Identify the top 3 most common error types across all evaluations
- Design a targeted exercise for the most common error type
- Write exercise to `../../shared/sensei-to-analyst/`

### Curriculum Gap Check
- Review `memory/curriculum.md`
- Check which difficulty levels (1-5) have the fewest test cases
- Check which domains (Dm types) have the fewest exercises
- Propose new exercises to fill gaps, or request materials from DataForge

### Training Metrics Report
- Calculate current pass rate (>= 40/50)
- Compare to previous report
- Identify improvement trends or regressions
- If pass rate is below 60%, flag for increased training priority

### Rubric Calibration
- Re-read a section of HNLPS_RULES.md or HNLPS_SUPPLEMENT.md
- Verify your scoring criteria align with the current spec
- If the spec has changed, update your scoring criteria accordingly
- Check if DataDancer has introduced new operators that affect scoring

## If Nothing Needs Attention

Reply HEARTBEAT_OK.
