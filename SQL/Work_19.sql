/*
Задача 1.
Подсчитайте общее количество заказов и среднюю сумму заказа по каждому году. 
Включите только те годы, где средняя сумма заказа превышает 2000. 
Добавьте категорию: "High Demand" для лет с более чем 500 заказами, "Medium Demand" для лет с 300-500 заказами и "Low Demand" для остальных. 
Укажите дату, количество заказов, среднюю сумму заказа и категорию.
Используйте таблицу Sales.SalesOrderHeader
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
Задача 2.
Найдите общую сумму продаж и средний процент скидки по каждой категории продукта. 
Выберите только категории, где общая сумма продаж превышает 50,000. 
Добавьте категорию: "Top Category" для категорий с суммой продаж более 200,000, 
"Mid Category" для категорий с суммой от 100,000 до 200,000 и "Low Category" для всех остальных. 
Укажите категорию, общую сумму продаж, средний процент скидки и категорию уровня продаж.
Используйте таблицы Sales.SalesOrderDetail, Production.Product, Production.ProductSubcategory, и Production.ProductCategory.
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
Задача 3.
Подсчитайте среднюю стоимость заказа и общее количество заказов по каждому региону (StateProvince). 
Включите только регионы, где средняя стоимость заказа превышает 1500. 
Добавьте категорию: "Expensive" для регионов со средней стоимостью заказа выше 3000, "Moderate" для стоимости от 2000 до 3000 и "Affordable" для остальных. 
Укажите регион, среднюю стоимость заказа, количество заказов и категорию.
Используйте таблицы Sales.SalesOrderHeader, Person.Address, и Person.StateProvince.
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
Задача 4.
Найдите средний процент скидки и количество заказов для каждого дня недели. 
Включите только те дни, где количество заказов превышает 100. 
Добавьте категорию: "Peak Day" для дней с более чем 300 заказами, "High Traffic" для 200-300 заказов и "Regular" для остальных. 
Укажите день недели, средний процент скидки, количество заказов и категорию.
Используйте таблицы Sales.SalesOrderHeader и Sales.SalesOrderDetail.
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
