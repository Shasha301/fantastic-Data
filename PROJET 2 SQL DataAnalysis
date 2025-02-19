--QUESTION NUMBER ONE:

WITH CTE1
AS (
    SELECT 
        YEAR(so.OrderDate) AS "Year"
        ,SUM(sl.ExtendedPrice - sl.TaxAmount) AS "IncomePerYear"
        ,COUNT(DISTINCT MONTH(so.OrderDate)) AS "NumberOfDistinctMonths"
        ,(CAST(SUM(sl.ExtendedPrice - sl.TaxAmount) / COUNT(DISTINCT MONTH(so.OrderDate)) * 12 AS MONEY)) AS "YearlyLinearIncome"
    FROM Sales.InvoiceLines sl 
		JOIN Sales.Invoices si 
		ON si.InvoiceID = sl.InvoiceID
		JOIN Sales.Orders so 
		ON so.OrderID = si.OrderID
    GROUP BY Year(so.OrderDate)
    ),
CTE2
AS (
     SELECT Year
       ,IncomePerYear
	   ,NumberOfDistinctMonths
       ,YearlyLinearIncome
        ,CASE 
            WHEN LAG("YearlyLinearIncome")OVER(ORDER BY "Year") IS NOT NULL THEN 
				ROUND("YearlyLinearIncome" - LAG("YearlyLinearIncome")OVER(ORDER BY "Year"),2) * 100.0 / LAG("YearlyLinearIncome")OVER(ORDER BY "Year")*100 /100 
            ELSE 
                NULL
        END AS "GrowthRate"  
    FROM 
        CTE1
    )
SELECT Year
       ,FORMAT(IncomePerYear,'C','en-US') AS "IncomePerYear"
	   ,NumberOfDistinctMonths
       ,FORMAT(YearlyLinearIncome,'C','en-US') AS "YearlyLinearIncome"
	   ,(CAST(ROUND(GrowthRate ,2) AS MONEY)) AS "GrowthRate%"
FROM CTE2
ORDER BY "Year";

--QUESTION NUMBER TWO:

WITH CTE1
AS (
   SELECT YEAR(so.OrderDate) AS "TheYear"
          ,DATEPART(QUARTER, so.orderDate) AS "TheQuarter"
          ,sc.CustomerName AS "CustomerName"
          ,SUM(sl.ExtendedPrice - sl.TaxAmount) AS "IncomePerYear"
		  ,DENSE_RANK()OVER(PARTITION BY YEAR(so.OrderDate), DATEPART(QUARTER, so.orderDate)ORDER BY SUM(sl.ExtendedPrice - sl.TaxAmount) DESC) AS "DNR"
    FROM Sales.Customers sc
	JOIN Sales.Orders so
    ON sc.CustomerID = so.CustomerID
    JOIN sales.Invoices si
	ON so.OrderID = si.OrderID
    JOIN sales.InvoiceLines sl
    ON si.InvoiceID = sl.InvoiceID
   GROUP BY YEAR(so.OrderDate)
           ,DATEPART(QUARTER, so.orderDate)
           ,sc.CustomerName
   )
SELECT TheYear
       ,TheQuarter
	   ,CustomerName
	   ,FORMAT(CTE1.IncomePerYear, 'C', 'en-US') AS "IncomePerYear"
	   ,DNR
FROM CTE1 
WHERE DNR <= 5
ORDER BY "TheYear", "TheQuarter", "DNR";

--QUESTION NUMBER THREE:

SELECT TOP 10 StockItemID
           ,StockItemName
		   ,TotalProfit
FROM (SELECT ws.StockItemID AS "StockItemID"
           ,ws.StockItemName AS "StockItemName"
      ,SUM(sl.ExtendedPrice - sl.TaxAmount) AS "TotalProfit_num"
      ,FORMAT(SUM(sl.ExtendedPrice - sl.TaxAmount), 'C', 'en-US') AS "TotalProfit"
      FROM Warehouse.StockItems ws 
	  JOIN Sales.InvoiceLines sl
      ON ws.StockItemID = sl.StockItemID
      GROUP BY ws.StockItemID, ws.StockItemName) T
ORDER BY "TotalProfit_num" DESC;

--QUESTION NUMBER FOUR:

SELECT RN, StockItemID, StockItemName, UnitPrice
         ,RecommendedRetailPrice, NominalProductProfit, DNR
FROM (SELECT ROW_NUMBER()OVER(ORDER BY SUM(wt.RecommendedRetailPrice - wt.UnitPrice) DESC) AS "RN"
       ,wt.StockItemID
	   ,wt.StockItemName
	   ,FORMAT(wt.UnitPrice,'C','en-US') AS "UnitPrice"
	   ,FORMAT(wt.RecommendedRetailPrice,'C','en-US') AS "RecommendedRetailPrice" 
	   ,SUM(wt.RecommendedRetailPrice - wt.UnitPrice) AS "NominalProductProfit_num"
	   ,FORMAT(SUM(wt.RecommendedRetailPrice - wt.UnitPrice), 'C', 'en-US') AS "NominalProductProfit"
	   ,DENSE_RANK()OVER(ORDER BY wt.unitprice DESC) AS "DNR"
      FROM Warehouse.StockItems wt
      GROUP BY wt.StockItemID
	   ,wt.StockItemName
	   ,wt.UnitPrice
	   ,wt.RecommendedRetailPrice
	   ) T
ORDER BY "NominalProductProfit_num" DESC;

--QUESTION NUMBER FIVE:

WITH CTE1
AS (
   SELECT CONCAT_WS('-',ps.SupplierID,ps.SupplierName) AS "SupplierDetails"
          ,CONCAT_WS(' ', si.StockItemID, si.StockItemName) AS "ProductDetails" 
          ,ps.SupplierID
   FROM Purchasing.Suppliers ps
   JOIN Warehouse.StockItems si
   ON ps.SupplierID = si.SupplierID
   GROUP BY ps.SupplierID
          ,ps.SupplierName
		  ,si.StockItemID
		  ,si.StockItemName
   )
SELECT SupplierDetails 
,STRING_AGG(ProductDetails, '/,') WITHIN GROUP(ORDER BY SupplierDetails) AS "ProductDetails" 
FROM CTE1
GROUP BY SupplierDetails ,SupplierID
ORDER BY "SupplierID";

--QUESTION NUMBER SIX:

SELECT TOP 5 CustomerID ,CityName ,CountryName
          ,Continent ,Region ,TotalExtendedPrice
FROM (SELECT sc.CustomerID ,ac.CityName ,act.CountryName
          ,act.Continent ,act.Region 
		  ,SUM(sl.ExtendedPrice) AS "TotalExtendedPrice_num" 
		  ,FORMAT(SUM(sl.ExtendedPrice), 'C', 'en-US') AS "TotalExtendedPrice"
		  FROM Sales.Customers sc JOIN Sales.Orders so
          ON sc.CustomerID = so.CustomerID
          JOIN Sales.Invoices si
          ON so.OrderID = si.OrderID
          JOIN Sales.InvoiceLines sl
          ON si.InvoiceID = sl.InvoiceID
          JOIN Application.Cities ac
          ON sc.DeliveryCityID = ac.CityID
          JOIN Application.StateProvinces ap
          ON ac.StateProvinceID = ap.StateProvinceID
          JOIN Application.Countries act
          ON ap.CountryID = act.CountryID
        GROUP BY sc.CustomerID ,ac.CityName ,act.CountryName
              ,act.Continent ,act.Region) T
ORDER BY "TotalExtendedPrice_num" DESC;

--QUESTION NUMBER SEVEN:

WITH CTE1
AS (
     SELECT YEAR(so.OrderDate) AS "OrderYear"
	       ,MONTH(so.OrderDate) AS "OrderMonth"
		   ,SUM(sl.UnitPrice * sl.Quantity) AS "MonthlyTotal"
           FROM Sales.Orders so JOIN Sales.Invoices si
           ON so.OrderID = si.OrderID
           JOIN Sales.InvoiceLines sl
           ON si.InvoiceID = sl.InvoiceID
           GROUP BY YEAR(so.OrderDate), MONTH(so.OrderDate)
	 ),
CTE2
AS (
    SELECT SUM(MonthlyTotal) AS "MonthlyTotal", OrderYear
	FROM CTE1
	GROUP BY OrderYear
	),
CTE3
AS (
    SELECT OrderYear, OrderMonth AS "OrderMonth2" 
	,CAST(OrderMonth AS VARCHAR) AS "OrderMonth", MonthlyTotal
	,SUM(MonthlyTotal)OVER(PARTITION BY OrderYear ORDER BY OrderMonth) as "CumulativeTotal"
	FROM CTE1
	UNION
	SELECT OrderYear, 13, 'Grand Total', MonthlyTotal, MonthlyTotal
	FROM CTE2
   )
SELECT OrderYear, OrderMonth
,FORMAT(MonthlyTotal, 'C', 'en-US') AS "MonthlyTotal"
,FORMAT(CumulativeTotal, 'C', 'en-US') AS "CumulativeTotal"
FROM CTE3
ORDER BY "OrderYear", "OrderMonth2";

--QUESTION NUMBER EIGHT:

SELECT OrderMonth, [2013],[2014],[2015],[2016]
FROM (SELECT so.OrderID, YEAR(so.OrderDate) AS YY, MONTH(so.OrderDate) AS "OrderMonth"
FROM sales.Orders so) T
PIVOT(COUNT(orderID)FOR yy IN ([2013],[2014],[2015],[2016])) PVT
ORDER BY "OrderMonth";

--QUESTION NUMBER NINE:

WITH CTE1
AS (
     SELECT sc.CustomerID, sc.CustomerName, so.OrderDate
     ,LAG(so.OrderDate)OVER(PARTITION BY sc.CustomerName ORDER BY so.OrderDate) AS "PreviousOrderDate"
	 ,MAX(so.OrderDate)OVER(PARTITION BY sc.customerName) AS "LastOrder"
     FROM Sales.Customers sc
     JOIN Sales.Orders so
     ON sc.CustomerID = so.CustomerID
	),
CTE2
AS (
    SELECT CustomerID, CustomerName, OrderDate, PreviousOrderDate
    ,DATEDIFF(DD, LastOrder , MAX(OrderDate)OVER()) AS "DaysSinceLastOrder"
    ,AVG(DATEDIFF(DD, PreviousOrderDate, OrderDate))OVER(PARTITION BY customerName) AS "AvgDaysBetweenOrders"
	FROM CTE1
	)
SELECT CustomerID, CustomerName, OrderDate, PreviousOrderDate, DaysSinceLastOrder, AvgDaysBetweenOrders
,IIF(DaysSinceLastOrder > AvgDaysBetweenOrders * 2, 'Potential Churn', 'Active') AS "Status"
FROM CTE2
ORDER BY "CustomerID";

--QUESTION NUMBER TEN:

WITH CTE1
AS (
    SELECT CustomerCategoryName, COUNT(STAGE2) AS GroupedCustomersNum
	FROM (SELECT DISTINCT scc.CustomerCategoryName
			   ,SUBSTRING(SC.CustomerName, 0, CHARINDEX('(', SC.CustomerName)) AS "STAGE2"
		FROM Sales.CustomerCategories scc JOIN Sales.Customers sc
		ON scc.CustomerCategoryID = sc.CustomerCategoryID
		WHERE CustomerName LIKE ('Tailspin%') OR CustomerName LIKE ('Wingtip%')
	) T
	GROUP BY CustomerCategoryName
   ),
CTE2
AS (
	SELECT scc.CustomerCategoryName
	,COUNT(CustomerName) AS "UniqueCustomers"
	FROM Sales.CustomerCategories scc JOIN Sales.Customers sc
	ON scc.CustomerCategoryID = sc.CustomerCategoryID
	WHERE CustomerName NOT LIKE ('Tailspin%') AND CustomerName NOT LIKE ('Wingtip%')
	GROUP BY CustomerCategoryName
   ),
CTE3
AS (
	SELECT CTE2.CustomerCategoryName
			,ISNULL(CTE1.GroupedCustomersNum, 0) + CTE2.uniqueCustomers AS "CustomerCount"
			,SUM(ISNULL(CTE1.GroupedCustomersNum, 0) + CTE2.uniqueCustomers)OVER() AS "TotalCustCount"
		FROM CTE1 RIGHT JOIN CTE2 ON CTE1.CustomerCategoryName = CTE2.CustomerCategoryName
    )
SELECT *
,CONCAT(CAST(CustomerCount AS MONEY) / CAST(TotalCustCount AS MONEY) * 100, '%') AS "DistributionFactor"
FROM CTE3
ORDER BY "CustomerCategoryName";








