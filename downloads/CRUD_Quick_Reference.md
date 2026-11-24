# EF Core 10 — CRUD and Change Tracking

| Objective | Normal pattern |
|---|---|
| Read for display by key | `await db.Items.AsNoTracking().SingleOrDefaultAsync(i => i.Id == id)`; check null. |
| Read to modify/delete by key | `var item = await db.Items.FindAsync(id);` Check null. A regular LINQ entity query is tracked by default too. |
| Insert | `db.Items.Add(item); await db.SaveChangesAsync();` Read generated `item.Id`. |
| Update | Find tracked item; check null; assign changed properties; `await db.SaveChangesAsync();`. No explicit Update required. |
| Delete | Find; check null; confirm; `db.Items.Remove(item); await db.SaveChangesAsync();`. |
| Read-only list | `db.Items.AsNoTracking().ToListAsync()`; changed object values alone are not saved. Use `Select` for only the needed fields. |

Choose by purpose. Find is for a primary-key lookup with tracking; use LINQ for other conditions, no-tracking reads and projection. `SingleOrDefaultAsync` means at most one match; `FirstOrDefaultAsync` chooses one when several may match. In the usual web pattern, the later save request has its own context and reloads the entity with tracking before editing permitted properties. The tracker does not persist between requests.

## Five states

Detached → not tracked; Added → INSERT when saved; Unchanged → no pending write; Modified → UPDATE when saved; Deleted → DELETE when saved.

The change tracker belongs to one DbContext. With ordinary snapshot tracking, change detection compares original and current property values. Entry inspection may detect changes; SaveChangesAsync normally detects automatically. After normal successful saving, Added/Modified become Unchanged; Deleted becomes Detached. Its return value counts state entries written. Disposing a context does not save.

SQL Server is the persistent storage; a CLR object lives in application memory. A generated identity value is available after saving; don't guess it. Schema changes through migrations are separate from data changes through SaveChanges.

## Scope of tracking and Unit of Work

- The ChangeTracker belongs to EF Core's DbContext, not to the SQL Server provider. One instance has one tracker for all its entity sets.
- DbSet is not an in-memory collection of every database row. When a normal entity query reads two of many rows, the two returned entities are tracked; an AsNoTracking result is still an object but has no tracked entry in this context. A row not retrieved has no object in this example.
- `FindAsync` checks this context's tracked entities by key first, then queries SQL Server only if needed. Repeated Find of the same tracked key returns the same object. `Entries().Count()` and an executed SQL log let us verify this in TODO 01B. A regular tracking LINQ query can still issue SQL and reuse an already tracked entity.
- `FindAsync` may return a locally edited, unsaved value. In TODO 03, a separate `AsNoTracking()` query shows the actual stored value before and after the save. It does not replace the existing tracked object.
- A tracked object can be Unchanged. Only pending Added, Modified and Deleted entries require writes during normal SaveChanges.
- A unit of work groups related changes in one short-lived context. One SaveChangesAsync call saves all pending tracked changes in that context, even across multiple DbSets. Another context has a separate tracker; its changes are not saved by this call.

Book: Gorman Ch. 4, Table 4-3 (p. 127) and pp. 144–145; Smith Ch. 3, §3.1 (p. 62).

References: Gorman, *Practical Entity Framework Core 10*, Ch. 6 (Activity 6-1); Smith, *Entity Framework Core in Action*, Ch. 3 §3.1–3.3, §3.5.
