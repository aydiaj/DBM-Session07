USE DBM_Session0708_Shop;
GO
IF DB_NAME() <> N'DBM_Session0708_Shop'
    THROW 50000, 'Wrong database.', 1;
SELECT DB_NAME() AS CurrentDatabase;
SELECT COUNT(*) AS TotalItems, COUNT(CASE WHEN IsActive = 1 AND Stock > 0 THEN 1 END) AS AvailableItems
FROM dbo.Items;
SELECT * FROM dbo.Categories ORDER BY Id;
SELECT * FROM dbo.Suppliers ORDER BY Id;
SELECT * FROM dbo.Items ORDER BY Id;
