/*
������ 1.
����������� ����� ���������� ������� � ������� ����� ������ �� ������� ����. 
�������� ������ �� ����, ��� ������� ����� ������ ��������� 2000. 
�������� ���������: "High Demand" ��� ��� � ����� ��� 500 ��������, "Medium Demand" ��� ��� � 300-500 �������� � "Low Demand" ��� ���������. 
������� ����, ���������� �������, ������� ����� ������ � ���������.
����������� ������� Sales.SalesOrderHeader
*/

--SELECT * FROM Sales.SalesOrderHeader

SELECT YEAR(OrderDate) AS [YEAR]
       , Count(1) AS CountOrder
	   , AVG(TotalDue) AS Total
	   , CASE
         WHEN Count(1) > 500 
		 THEN 'High Demand'
         WHEN Count(1) BETWEEN 300 AND 500 
		 THEN 'Medium Demand'
         ELSE 'Low Demand'
         END AS Category
FROM Sales.SalesOrderHeader
GROUP BY YEAR(OrderDate)
HAVING AVG(TotalDue) > 2000



/*
������ 2.
������� ����� ����� ������ � ������� ������� ������ �� ������ ��������� ��������. 
�������� ������ ���������, ��� ����� ����� ������ ��������� 50,000. 
�������� ���������: "Top Category" ��� ��������� � ������ ������ ����� 200,000, 
"Mid Category" ��� ��������� � ������ �� 100,000 �� 200,000 � "Low Category" ��� ���� ���������. 
������� ���������, ����� ����� ������, ������� ������� ������ � ��������� ������ ������.
����������� ������� Sales.SalesOrderDetail, Production.Product, Production.ProductSubcategory, � Production.ProductCategory.
*/

--SELECT * FROM Sales.SalesOrderDetail od
--SELECT * FROM Production.Product pp
--SELECT * FROM Production.ProductSubcategory sc
--SELECT * FROM Production.ProductCategory pc

SELECT pc.Name AS ProductCategoryName
      , SUM(od.LineTotal) AS SalesTotal
	  , AVG(od.UnitPriceDiscount) AS AvgDiscount
	  , CASE
	    WHEN SUM(od.LineTotal) > 200000 
		THEN 'Top Category'
        WHEN SUM(od.LineTotal) BETWEEN 100000 AND 200000 
		THEN 'Mid Category'
        ELSE 'Low Category'
        END AS LevelCategory
FROM Sales.SalesOrderDetail od
JOIN Production.Product pp ON pp.ProductID = od.ProductID
JOIN Production.ProductSubcategory sc ON sc.ProductSubcategoryID = pp.ProductSubcategoryID
JOIN Production.ProductCategory pc ON pc.ProductCategoryID = sc.ProductCategoryID
GROUP BY pc.Name
HAVING SUM(od.LineTotal) > 50000



/*
������ 3.
����������� ������� ��������� ������ � ����� ���������� ������� �� ������� ������� (StateProvince). 
�������� ������ �������, ��� ������� ��������� ������ ��������� 1500. 
�������� ���������: "Expensive" ��� �������� �� ������� ���������� ������ ���� 3000, "Moderate" ��� ��������� �� 2000 �� 3000 � "Affordable" ��� ���������. 
������� ������, ������� ��������� ������, ���������� ������� � ���������.
����������� ������� Sales.SalesOrderHeader, Person.Address, � Person.StateProvince.
*/

SELECT * FROM Sales.SalesOrderHeader soh
SELECT * FROM Person.Address pa
SELECT * FROM Person.StateProvince psp

SELECT psp.Name
       , AVG(TotalDue) AS AvgSales
	   , COUNT (1) AS CountOrder
	   , CASE
         WHEN AVG(TotalDue) > 3000 
		 THEN 'Expensive'
         WHEN AVG(TotalDue) BETWEEN 2000 AND 3000 
		 THEN 'Moderate'
         ELSE 'Affordable'
         END AS Category
FROM Sales.SalesOrderHeader soh
JOIN Person.Address pa ON pa.AddressID = soh.BillToAddressID
JOIN Person.StateProvince psp ON psp.TerritoryID = soh.TerritoryID
GROUP BY psp.Name
HAVING AVG(TotalDue) > 1500


/*
������ 4.
������� ������� ������� ������ � ���������� ������� ��� ������� ��� ������. 
�������� ������ �� ���, ��� ���������� ������� ��������� 100. 
�������� ���������: "Peak Day" ��� ���� � ����� ��� 300 ��������, "High Traffic" ��� 200-300 ������� � "Regular" ��� ���������. 
������� ���� ������, ������� ������� ������, ���������� ������� � ���������.
����������� ������� Sales.SalesOrderHeader � Sales.SalesOrderDetail.
*/

SELECT * FROM Sales.SalesOrderHeader soh
SELECT * FROM Sales.SalesOrderDetail sod

SELECT soh.OrderDate
       , AVG (sod.UnitPriceDiscount) AS AvgDiscount
	   , COUNT (sod.OrderQty) AS OrderCount
	   , CASE
	     WHEN COUNT (sod.OrderQty) > 300 
		 THEN 'Peak Day'
         WHEN COUNT (sod.OrderQty) BETWEEN 200 AND 300 
		 THEN 'High Traffic'
         ELSE 'Regular'
         END AS Category
FROM Sales.SalesOrderDetail sod
JOIN Sales.SalesOrderHeader soh ON soh.SalesOrderID = sod.SalesOrderID
GROUP BY soh.OrderDate
HAVING COUNT (sod.OrderQty) > 100
ORDER BY soh.OrderDate
