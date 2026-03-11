USE AdventureWorks2022;
GO
 
CREATE SCHEMA Training AUTHORIZATION dbo;
GO
 
CREATE TABLE Training.ProductPriceAudit (
    AuditID INT IDENTITY PRIMARY KEY,
    ProductID INT,
    OldPrice MONEY,
    NewPrice MONEY,
    ChangedBy NVARCHAR(100),
    ChangeDate DATETIME DEFAULT GETDATE()
);
 
CREATE TABLE Training.SchemaChangeLog (
    LogID INT IDENTITY PRIMARY KEY,
    EventType NVARCHAR(100),
    ObjectName NVARCHAR(100),
    PerformedBy NVARCHAR(100),
    EventDate DATETIME DEFAULT GETDATE()
);

 
CREATE TRIGGER trg_Product_PriceAudit
ON Production.Product
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
 
    INSERT INTO Training.ProductPriceAudit (ProductID, OldPrice, NewPrice, ChangedBy)
    SELECT d.ProductID, d.ListPrice, i.ListPrice, SUSER_SNAME()
    FROM deleted d
    JOIN inserted i ON d.ProductID = i.ProductID
    WHERE d.ListPrice <> i.ListPrice;
END;
GO

 
UPDATE Production.Product SET ListPrice = ListPrice * 1.05 WHERE ProductID = 707;
SELECT * FROM Training.ProductPriceAudit;

CREATE TRIGGER trg_Product_PreventDelete
ON Production.Product
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;
 
    IF EXISTS (
        SELECT 1 FROM deleted d
        JOIN Sales.SalesOrderDetail s ON s.ProductID = d.ProductID
    )
    BEGIN
        PRINT 'Cannot delete products linked to existing sales orders.';
        RETURN;
    END
 
    DELETE p
    FROM Production.Product p
    JOIN deleted d ON p.ProductID = d.ProductID;
END;
GO

CREATE TRIGGER trg_Database_SchemaLog
ON DATABASE
FOR CREATE_TABLE, ALTER_TABLE, DROP_TABLE
AS
BEGIN
    SET NOCOUNT ON;
 
    INSERT INTO Training.SchemaChangeLog (EventType, ObjectName, PerformedBy)
    SELECT EVENTDATA().value('(/EVENT_INSTANCE/EventType)[1]', 'NVARCHAR(100)'),
           EVENTDATA().value('(/EVENT_INSTANCE/ObjectName)[1]', 'NVARCHAR(100)'),
           SUSER_SNAME();
END;
GO

CREATE TABLE Training.TempTest (ID INT);
DROP TABLE Training.TempTest;
SELECT * FROM Training.SchemaChangeLog;

EXEC sp_configure 'nested triggers', 1;
RECONFIGURE;

EXEC sp_configure 'nested triggers', 0;
RECONFIGURE;