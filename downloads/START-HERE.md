# DBM Sessions 07–08 — Campus Supply Shop

One project, one practice database, two connected sessions. **90 + 60 = 150 minutes of practice, plus a separate 15-minute quiz (165 minutes total).** Prepare the database and restore packages before scheduled learning time if possible.

## Before class

1. Extract the ZIP. Use Visual Studio with the .NET 10 SDK and your local SQL Server instance.
2. In SSMS, execute `setup-shop.sql`. It creates `DBM_Session0708_Shop` and its three tables only on first setup; the older 12-item database is untouched. Existing data is not reset. Run `verify-shop.sql` and check 6 categories, 6 suppliers, 120 items and 97 available items on a fresh database.
3. Open `EF10InventoryManager.sln`. Set `EF10_InventoryManager` as Startup Project.
4. In its `appsettings.json`, replace YOUR_SERVER with your SQL Server instance (escape a backslash in JSON). Keep the database name. Do not share credentials.
5. Restore, build and run. Option 1 shows the inventory; other supplied options provide working examples. In the student starter, TODO methods show reminders until implemented.

CLI alternative: `dotnet restore EF10InventoryManager.sln`, `dotnet build EF10InventoryManager.sln`, `dotnet run --project EF10_InventoryManager`.

The three-project design and pinned packages carry forward. Item has CategoryId and SupplierId; both point at existing parent IDs. Mapping is supplied. This is not the Code First/migrations lesson.

## A. Session 07 (90 minutes: 30 live + 60 independent)

| Step | Minutes | What to do |
|---|---:|---|
| 01 | 10 | Run option 1. Inspect three tables, compare ID and foreign keys. |
| 02 | 15 | Tasks 01–02: search (option 2) and category top-three projection (option 3). |
| 03 | 25 | Task 11 / option 12: optional filters, count, paging with 10 rows per page, SQL preview. First 5 minutes live. |
| 04 | 15 | Option 4 (worked example). Task 12 / option 13: grouping and aggregates. |
| 05 | 25 | Options 9 and 10: create a practice category and supplier. Use option 6 to create one spare item with seed category 1, then option 5 and 7 to read and update it. Task 13 / option 14: create two items in your new category/supplier with AddRange. |

Record category ID, supplier ID and both AddRange item IDs. Do not delete them before Session 08. Options 4–11 are implemented worked examples from the original Session 07 practice design; former TODOs 03–10 are now supplied so the new skills fit the time. TODO numbering is preserved.

## B. Session 08 (60 minutes of practice)

Before the second block: Step 06, a separate 15-minute instructor quiz on Sessions 04–07.

| Step | Minutes | What to do |
|---|---:|---|
| 07 | 12 | Task 18 / option 19: joins and projection across three tables. |
| 08 | 10 | Task 19 / option 20: move one of your two items to seed category 2. Task 20 / option 21: attempt to delete your original practice category while the other item references it; expect blocked. |
| 09 | 10 | Option 11: tracked update of both practice items, single save. Task 14 / option 15: explicit UpdateRange using a fresh read of complete untracked records. |
| 10 | 8 | Task 15 / option 16: deactivate one pair item, verify active search excludes it and option 1 still lists it, then reactivate. |
| 11 | 12 | Task 16 / option 17: edit with two contexts; verify stored price. |
| 12 | 8 | Task 17 / option 18: cancel deletion with NO, then confirm YES for the same two practice items. Verify both absent. Try option 21 again to delete your now-empty practice category; preserve the spare item. Finish evidence. |

## Task index

| TODO | Option | File |
|---|---:|---|
| 01 | 2 | QueryTasks.cs |
| 02 | 3 | QueryTasks.cs |
| 11 | 12 | WorkshopTasks.cs |
| 12 | 13 | WorkshopTasks.cs |
| 13 | 14 | WorkshopTasks.cs |
| 18 | 19 | WorkshopTasks.cs |
| 19 | 20 | WorkshopTasks.cs |
| 20 | 21 | WorkshopTasks.cs |
| 14 | 15 | WorkshopTasks.cs |
| 15 | 16 | WorkshopTasks.cs |
| 16 | 17 | WorkshopTasks.cs |
| 17 | 18 | WorkshopTasks.cs |

Replace only statements inside each TODO START / END marker. Try first, then use the codelab hint or reference solution. All write operations are restricted in this lab to your own local database; seed Items 1–120 and Categories 1–6 must remain intact. Do not guess generated IDs. Never run this lab against a shared production database.

## Seed checks (before inserting practice records)

- Option 2, Notebook: Notebook then Graph Notebook.
- Option 3, category 2: Power Strip, Card Reader, Wireless Mouse. Category 6: no results.
- Option 4, supplier 1: 25 items, stock 515. Supplier 6: zero items, stock zero.
- Option 12, keyword blank/category 0/supplier 0/maximum blank/available Y: 97 matches across 10 pages (10 items per full page). Page 1 starts A5 Notepad, Pen, Craft Knife; page 2 starts Specimen Labels, Notebook, Key Ring. Page 10 ends with seven rows; page 11 is empty. Available N: 120 matches across 12 full pages. Category 2, max 20 and available Y: 11 matches across two pages.
- Option 13: categories 1–5 have 24 rows each and stock totals of 475, 404, 367, 493, 470. This counts all stored item rows including inactive items. Category 6 has no group.
- Option 19: Notebook belongs to Stationery and Alpha Supplies. All seed FKs are valid, so all 120 items appear on a fresh setup.

After creation, results naturally change. Don't rerun setup to restore a seed count. Verify with the actual generated IDs and intended rows.

## Submission

See `evidence.md`. Submit only completed source (exclude bin, obj, .vs) plus short evidence. The quiz is administered separately.
