CREATE TABLE ProductInventorySummary (ProductID INT
                                     , TotalQuantity INT)

CREATE PROCEDURE CountProductInventorySummary
AS
BEGIN
    DECLARE @Counter INT
    SELECT @Counter = MIN(ProductID) FROM Production.ProductInventory
    DECLARE @TotalQuantity INT

    WHILE @Counter IS NOT NULL
	BEGIN
    INSERT INTO ProductInventorySummary (ProductID, TotalQuantity) VALUES (@Counter, @TotalQuantity)
    SELECT @TotalQuantity = SUM(Quantity) FROM Production.ProductInventory WHERE ProductID = @Counter
    SELECT @Counter = MIN(ProductID) FROM Production.ProductInventory
    WHERE ProductID > @Counter
    END
END

EXEC CountProductInventorySummary

SELECT * FROM ProductInventorySummary