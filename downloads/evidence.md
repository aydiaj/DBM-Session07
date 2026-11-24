# Sessions 07–08 — Evidence sheet

Name / Group:

Database: DBM_Session0708_Shop

Practice category ID:

Practice supplier ID:

Spare item ID (created using seed category 1):

AddRange item IDs (keep both until Step 12):

## Session 07

- [ ] Option 1 baseline: verified table names and initial records (or noted existing extra rows).
- [ ] Options 2–3: correct search and projected category report.
- [ ] Option 12: show first, middle and last page (10 rows per full page), an out-of-range page, total matches/pages, and SQL preview. Try a combined category + price filter as well.
- [ ] Option 13: category summary; explain why a category without items has no group.
- [ ] Options 9, 10, 6, 5, 7 and 14: record generated keys and show two newly created items.

## Session 08

- [ ] Option 19: joined report includes category and supplier names.
- [ ] Options 20–21: changed CategoryId, invalid key handling and blocked in-use category deletion.
- [ ] Options 11, 15: both records updated; explain tracking versus UpdateRange.
- [ ] Option 16: inactive row still exists but is absent from active search; reactivated.
- [ ] Option 17: stored price after the two-context update.
- [ ] Option 18: NO leaves both rows unchanged; YES removes them. Option 21 deletes only the empty practice category.

## Short explanations

1. Which lines execute the browser query? Why count before paging?
2. Why is it safer to re-read an item in the save context and change only the required property?
3. What is the difference between deactivation and hard deletion? Why can an in-use category not be deleted?

Submit the solution ZIP (no build output folders) and this completed evidence. Submit screenshots or short terminal text only where needed. Do not include passwords.
