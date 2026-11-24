-- Workshop only. Separate database, safe rerun, deterministic seed data.
USE master;
GO
IF DB_ID(N'DBM_Session0708_Shop') IS NULL
    EXEC(N'CREATE DATABASE [DBM_Session0708_Shop];');
GO
USE [DBM_Session0708_Shop];
GO
IF DB_NAME() <> N'DBM_Session0708_Shop'
    THROW 50000, 'Wrong database.', 1;

-- Install all tables together. Existing records are preserved on later runs.
IF OBJECT_ID(N'dbo.Categories', N'U') IS NULL
   AND OBJECT_ID(N'dbo.Suppliers', N'U') IS NULL
   AND OBJECT_ID(N'dbo.Items', N'U') IS NULL
BEGIN
    SET XACT_ABORT ON;
    BEGIN TRANSACTION;
    CREATE TABLE dbo.Categories
    (
        Id int IDENTITY(1,1) PRIMARY KEY,
        Name nvarchar(100) NOT NULL
    );
    CREATE TABLE dbo.Suppliers
    (
        Id int IDENTITY(1,1) PRIMARY KEY,
        Name nvarchar(100) NOT NULL,
        City nvarchar(100) NOT NULL
    );
    CREATE TABLE dbo.Items
    (
        Id int IDENTITY(1,1) PRIMARY KEY,
        Name nvarchar(100) NOT NULL,
        UnitPrice decimal(10,2) NOT NULL CHECK (UnitPrice >= 0),
        Stock int NOT NULL CHECK (Stock >= 0),
        IsActive bit NOT NULL,
        CategoryId int NOT NULL REFERENCES dbo.Categories(Id),
        SupplierId int NOT NULL REFERENCES dbo.Suppliers(Id)
    );
    SET IDENTITY_INSERT dbo.Categories ON;
    INSERT dbo.Categories(Id, Name) VALUES
        (1, N'Stationery'),
        (2, N'Electronics'),
        (3, N'Accessories'),
        (4, N'Art Supplies'),
        (5, N'Lab Supplies'),
        (6, N'Clearance');
    SET IDENTITY_INSERT dbo.Categories OFF;
    SET IDENTITY_INSERT dbo.Suppliers ON;
    INSERT dbo.Suppliers(Id, Name, City) VALUES
        (1, N'Alpha Supplies', N'Gaza'),
        (2, N'Bright Tech', N'Gaza'),
        (3, N'Campus Goods', N'Khan Younis'),
        (4, N'Creative Source', N'Deir al-Balah'),
        (5, N'Lab Essentials', N'Rafah'),
        (6, N'Reserve Supplier', N'Gaza');
    SET IDENTITY_INSERT dbo.Suppliers OFF;
    SET IDENTITY_INSERT dbo.Items ON;
    INSERT dbo.Items(Id, Name, UnitPrice, Stock, IsActive, CategoryId, SupplierId) VALUES
        (1, N'Notebook', 4.50, 30, 1, 1, 1),
        (2, N'Graph Notebook', 6.00, 10, 1, 1, 1),
        (3, N'Pen', 1.20, 50, 1, 1, 1),
        (4, N'Calculator', 25.00, 8, 1, 2, 2),
        (5, N'USB Drive', 12.00, 0, 1, 2, 2),
        (6, N'Keyboard', 20.00, 5, 1, 2, 2),
        (7, N'Mouse', 15.00, 7, 1, 2, 2),
        (8, N'Headphones', 35.00, 2, 0, 2, 2),
        (9, N'Backpack', 30.00, 4, 1, 3, 3),
        (10, N'Pencil Case', 5.00, 12, 1, 3, 3),
        (11, N'Water Bottle', 8.50, 6, 1, 3, 3),
        (12, N'Folder', 3.00, 20, 0, 1, 1),
        (13, N'Blue Ballpoint Pen', 5.50, 13, 1, 1, 2),
        (14, N'Black Ballpoint Pen', 16.00, 20, 1, 1, 1),
        (15, N'Red Gel Pen', 2.50, 27, 1, 1, 1),
        (16, N'HB Pencil', 13.00, 34, 1, 1, 2),
        (17, N'Mechanical Pencil', 23.50, 41, 1, 1, 1),
        (18, N'Pencil Leads', 10.00, 0, 1, 1, 1),
        (19, N'Highlighter Yellow', 20.50, 14, 1, 1, 2),
        (20, N'Highlighter Green', 7.00, 21, 1, 1, 1),
        (21, N'Sticky Notes', 17.50, 28, 1, 1, 1),
        (22, N'Index Cards', 4.00, 35, 0, 1, 2),
        (23, N'A4 Copy Paper', 14.50, 1, 1, 1, 1),
        (24, N'A5 Notepad', 1.00, 8, 1, 1, 1),
        (25, N'Binder Clips', 11.50, 15, 1, 1, 2),
        (26, N'Paper Clips', 22.00, 22, 1, 1, 1),
        (27, N'Stapler', 8.50, 0, 1, 1, 1),
        (28, N'Staples', 19.00, 36, 1, 1, 2),
        (29, N'Document Wallet', 5.50, 2, 1, 1, 1),
        (30, N'Ring Binder', 16.00, 9, 1, 1, 1),
        (31, N'Correction Tape', 2.50, 16, 1, 1, 2),
        (32, N'Desk Organizer', 13.00, 23, 1, 1, 1),
        (33, N'Wireless Keyboard', 17.00, 33, 0, 2, 3),
        (34, N'Wireless Mouse', 27.50, 40, 1, 2, 2),
        (35, N'USB-C Cable', 14.00, 6, 1, 2, 2),
        (36, N'HDMI Cable', 24.50, 0, 1, 2, 3),
        (37, N'USB Hub', 11.00, 20, 1, 2, 2),
        (38, N'Webcam', 21.50, 27, 1, 2, 2),
        (39, N'Portable Charger', 8.00, 34, 1, 2, 3),
        (40, N'Memory Card', 18.50, 41, 1, 2, 2),
        (41, N'Card Reader', 29.00, 7, 1, 2, 2),
        (42, N'Laptop Stand', 15.50, 14, 1, 2, 3),
        (43, N'Wireless Headset', 26.00, 21, 1, 2, 2),
        (44, N'Desk Speaker', 12.50, 28, 0, 2, 2),
        (45, N'Charging Adapter', 23.00, 0, 1, 2, 3),
        (46, N'Ethernet Cable', 9.50, 1, 1, 2, 2),
        (47, N'Flash Drive 64GB', 20.00, 8, 1, 2, 2),
        (48, N'Power Strip', 30.50, 15, 1, 2, 3),
        (49, N'Screen Cleaning Kit', 17.00, 22, 1, 2, 2),
        (50, N'Bluetooth Adapter', 27.50, 29, 1, 2, 2),
        (51, N'Digital Timer', 14.00, 36, 1, 2, 3),
        (52, N'Laptop Sleeve', 16.50, 5, 1, 3, 4),
        (53, N'Canvas Tote', 3.00, 12, 1, 3, 3),
        (54, N'ID Card Holder', 13.50, 0, 1, 3, 3),
        (55, N'Lanyard', 24.00, 26, 0, 3, 4),
        (56, N'Travel Mug', 10.50, 33, 1, 3, 3),
        (57, N'Lunch Box', 21.00, 40, 1, 3, 3),
        (58, N'Insulated Bottle', 7.50, 6, 1, 3, 4),
        (59, N'Umbrella', 18.00, 13, 1, 3, 3),
        (60, N'Key Ring', 4.50, 20, 1, 3, 3),
        (61, N'Cable Pouch', 15.00, 27, 1, 3, 4),
        (62, N'Phone Stand', 25.50, 34, 1, 3, 3),
        (63, N'Tablet Sleeve', 12.00, 0, 1, 3, 3),
        (64, N'Mouse Pad', 22.50, 7, 1, 3, 4),
        (65, N'Wrist Rest', 9.00, 14, 1, 3, 3),
        (66, N'Travel Case', 19.50, 21, 0, 3, 3),
        (67, N'Storage Box', 6.00, 28, 1, 3, 4),
        (68, N'Safety Vest', 16.50, 35, 1, 3, 3),
        (69, N'Reusable Shopping Bag', 3.00, 1, 1, 3, 3),
        (70, N'Drawstring Bag', 13.50, 8, 1, 3, 4),
        (71, N'Document Case', 24.00, 15, 1, 3, 3),
        (72, N'Clip Badge', 10.50, 0, 1, 3, 3),
        (73, N'Sketch Pad', 20.00, 32, 1, 4, 5),
        (74, N'Drawing Pencils', 6.50, 39, 1, 4, 4),
        (75, N'Charcoal Set', 17.00, 5, 1, 4, 4),
        (76, N'Watercolor Set', 3.50, 12, 1, 4, 5),
        (77, N'Paint Brushes', 14.00, 19, 0, 4, 4),
        (78, N'Acrylic Paint', 24.50, 26, 1, 4, 4),
        (79, N'Colored Pencils', 11.00, 33, 1, 4, 5),
        (80, N'Oil Pastels', 21.50, 40, 1, 4, 4),
        (81, N'Canvas Board', 8.00, 0, 1, 4, 4),
        (82, N'Mixing Palette', 18.50, 13, 1, 4, 5),
        (83, N'Craft Glue', 5.00, 20, 1, 4, 4),
        (84, N'Scissors', 15.50, 27, 1, 4, 4),
        (85, N'Craft Knife', 2.00, 34, 1, 4, 5),
        (86, N'Glue Sticks', 12.50, 41, 1, 4, 4),
        (87, N'Colored Cardstock', 23.00, 7, 1, 4, 4),
        (88, N'Tracing Paper', 9.50, 14, 0, 4, 5),
        (89, N'Masking Tape', 20.00, 21, 1, 4, 4),
        (90, N'Drawing Compass', 6.50, 0, 1, 4, 4),
        (91, N'Fine Liner Set', 17.00, 35, 1, 4, 5),
        (92, N'Art Marker Set', 3.50, 1, 1, 4, 4),
        (93, N'Erasable Marker', 14.00, 8, 1, 4, 4),
        (94, N'Stencils', 24.50, 15, 1, 4, 5),
        (95, N'Foam Sheets', 11.00, 22, 1, 4, 4),
        (96, N'Clay Pack', 21.50, 29, 1, 4, 4),
        (97, N'Safety Glasses', 26.50, 39, 1, 5, 1),
        (98, N'Lab Coat', 13.00, 5, 1, 5, 5),
        (99, N'Nitrile Gloves', 23.50, 0, 0, 5, 5),
        (100, N'Measuring Cylinder', 10.00, 19, 1, 5, 1),
        (101, N'Beaker 100mL', 20.50, 26, 1, 5, 5),
        (102, N'Beaker 250mL', 7.00, 33, 1, 5, 5),
        (103, N'Test Tube Rack', 17.50, 40, 1, 5, 1),
        (104, N'Test Tubes', 4.00, 6, 1, 5, 5),
        (105, N'Plastic Pipettes', 14.50, 13, 1, 5, 5),
        (106, N'Lab Timer', 25.00, 20, 1, 5, 1),
        (107, N'Digital Thermometer', 11.50, 27, 1, 5, 5),
        (108, N'pH Strips', 22.00, 0, 1, 5, 5),
        (109, N'Measuring Spoon', 8.50, 41, 1, 5, 1),
        (110, N'Sample Container', 19.00, 7, 0, 5, 5),
        (111, N'Magnifying Glass', 5.50, 14, 1, 5, 5),
        (112, N'Petri Dishes', 16.00, 21, 1, 5, 1),
        (113, N'Funnel', 26.50, 28, 1, 5, 5),
        (114, N'Wash Bottle', 13.00, 35, 1, 5, 5),
        (115, N'Lab Tray', 23.50, 1, 1, 5, 1),
        (116, N'Forceps', 10.00, 8, 1, 5, 5),
        (117, N'Awareness Poster', 20.50, 0, 1, 5, 5),
        (118, N'Safety Apron', 7.00, 22, 1, 5, 1),
        (119, N'Cleaning Cloth', 17.50, 29, 1, 5, 5),
        (120, N'Specimen Labels', 4.00, 36, 1, 5, 5);
    SET IDENTITY_INSERT dbo.Items OFF;
    COMMIT TRANSACTION;
END
ELSE IF OBJECT_ID(N'dbo.Categories', N'U') IS NULL
     OR OBJECT_ID(N'dbo.Suppliers', N'U') IS NULL
     OR OBJECT_ID(N'dbo.Items', N'U') IS NULL
    THROW 50001, 'Partial setup. Ask your instructor; do not drop anything.', 1;
GO
SELECT COUNT(*) AS ItemCount FROM dbo.Items;
SELECT * FROM dbo.Categories ORDER BY Id;
SELECT * FROM dbo.Suppliers ORDER BY Id;
SELECT * FROM dbo.Items ORDER BY Id;
