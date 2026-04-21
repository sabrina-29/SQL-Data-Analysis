--q.1 
SELECT * FROM Sales.InvoiceLines 
SELECT * FROM Sales.Invoices
GO

WITH YearlySales AS (
    SELECT 
        YEAR(i.InvoiceDate) AS InvoiceYear,
        SUM(il.ExtendedPrice - il.TaxAmount) AS IcomePerYear,
        COUNT(DISTINCT MONTH(i.InvoiceDate)) AS NumberOfDistincrMonths, 
        SUM(il.ExtendedPrice - il.TaxAmount) / COUNT(DISTINCT MONTH(i.InvoiceDate)) * 12 AS YearlyLinearIcome
    FROM Sales.Invoices i
    JOIN Sales.InvoiceLines il ON i.InvoiceID = il.InvoiceID
    GROUP BY YEAR(i.InvoiceDate)
),
Growth AS (
    SELECT *,
           LAG(YearlyLinearIcome) OVER (ORDER BY InvoiceYear) AS PrevYearRevenue
    FROM YearlySales
)
SELECT 
    InvoiceYear,
    FORMAT(IcomePerYear,'N2') AS IcomePerYear,
    NumberOfDistincrMonths,
    FORMAT(YearlyLinearIcome,'N2') AS LinearAnnualRevenue,
    FORMAT(
        (YearlyLinearIcome - PrevYearRevenue) / PrevYearRevenue * 100
        ,'N2'
    ) AS GrowthRatePercent
FROM Growth
ORDER BY InvoiceYear;

--q.2
SELECT * FROM Sales.Invoices
SELECT * FROM Sales.InvoiceLines
SELECT * FROM Sales.Customers

SELECT
    TheYear,
    TheQuarter,
    CustomerName,
    IncomePerQuarterYear,
    DNR
FROM (
    SELECT
        YEAR(i.InvoiceDate) AS TheYear,
        DATEPART(QUARTER, i.InvoiceDate) AS TheQuarter,
        c.CustomerName,
        SUM(il.ExtendedPrice - il.TaxAmount) AS IncomePerQuarterYear,
        DENSE_RANK() OVER (
            PARTITION BY 
                YEAR(i.InvoiceDate), 
                DATEPART(QUARTER, i.InvoiceDate)
            ORDER BY 
                SUM(il.ExtendedPrice - il.TaxAmount) DESC
        ) AS DNR
    FROM Sales.Invoices i
    JOIN Sales.InvoiceLines il 
        ON i.InvoiceID = il.InvoiceID
    JOIN Sales.Customers c 
        ON i.CustomerID = c.CustomerID
    GROUP BY 
        YEAR(i.InvoiceDate),
        DATEPART(QUARTER, i.InvoiceDate),
        c.CustomerName
) AS T
WHERE DNR <= 5
ORDER BY 
    TheYear,
    TheQuarter,
    DNR;

--q.3 
SELECT * from  Sales.InvoiceLines
SELECT * FROM Warehouse.StockItems
   
SELECT TOP(10)
    ws.StockItemID,
    ws.StockItemName,
    SUM(si.ExtendedPrice - si.TaxAmount) AS TotalProfit
FROM Sales.InvoiceLines si
JOIN Warehouse.StockItems ws
    ON si.StockItemID = ws.StockItemID
GROUP BY ws.StockItemID, ws.StockItemName
ORDER BY TotalProfit DESC;

--q.4 
SELECT * from Warehouse.StockItems 

SELECT
    ROW_NUMBER() OVER (ORDER BY (ws.RecommendedRetailPrice - ws.UnitPrice) DESC) AS RN,
    ws.StockItemID,
    ws.StockItemName,
    ws.UnitPrice,
    ws.RecommendedRetailPrice,
    (ws.RecommendedRetailPrice - ws.UnitPrice) AS NominalProductProfit,
    ROW_NUMBER() OVER (ORDER BY (ws.RecommendedRetailPrice - ws.UnitPrice) DESC) AS DNR
FROM Warehouse.StockItems ws
WHERE ws.LastEditedBy IS NOT NULL;

--q.5 
SELECT * FROM Warehouse.StockItems_Archive
SELECT * FROM Purchasing.Suppliers

SELECT 
    CONCAT(ps.SupplierID, ' - ', ps.SupplierName) AS SupplierInfo,
    STRING_AGG(CONVERT(NVARCHAR(MAX), ws.StockItemID) + ' ' + CONVERT(NVARCHAR(MAX), ws.StockItemName) + ' /,', '') 
        WITHIN GROUP (ORDER BY ws.StockItemID) AS ProductDetails
FROM 
    Purchasing.Suppliers ps
INNER JOIN 
    Warehouse.StockItems_Archive ws
    ON ws.SupplierID = ps.SupplierID
GROUP BY 
    ps.SupplierID, ps.SupplierName
ORDER BY 
    ps.SupplierID;


--q.6 
SELECT * FROM Sales.Customers --Customerid  
SELECT * FROM  Sales.InvoiceLines -- Quantity, UnitPrice
SELECT * FROM Application.Countries --countryid,countryname,continent, region 
SELECT * FROM Application.Cities --Cityname 
SELECT * FROM Sales.Invoices --Customerid 
SELECT * FROM Sales.InvoiceLines-- ExtendedPrice
SELECT * FROM Sales.CustomerTransactions--Customerid ,InvoiceID,ExtendedPrice

SELECT TOP 5
    customers.CustomerID,
    cities.CityName,
    countries.CountryName,
    countries.Continent,
    countries.Region,
    FORMAT(SUM(invoiceLines.ExtendedPrice), 'N2') AS TotalExtendedPrice
FROM Sales.Invoices AS invoices
JOIN Sales.InvoiceLines AS invoiceLines
    ON invoices.InvoiceID = invoiceLines.InvoiceID
JOIN Sales.Customers AS customers
    ON invoices.CustomerID = customers.CustomerID
JOIN Application.Cities AS cities
    ON customers.DeliveryCityID = cities.CityID
JOIN Application.StateProvinces AS states
    ON cities.StateProvinceID = states.StateProvinceID
JOIN Application.Countries AS countries
    ON states.CountryID = countries.CountryID
GROUP BY 
    customers.CustomerID,
    cities.CityName,
    countries.CountryName,
    countries.Continent,
    countries.Region
ORDER BY SUM(invoiceLines.ExtendedPrice) DESC;

--q.7!!!!
SELECT * FROM Sales.Invoices
SELECT * FROM Sales.InvoiceLines

SELECT 
    InvoiceYear,
    InvoiceMonthDisplay AS InvoiceMonth,
    FORMAT(MonthlyTotal, 'N2') AS MonthlyTotal,
    FORMAT(CumulativeTotal, 'N2') AS CumulativeTotal
FROM (
    SELECT 
        YEAR(i.InvoiceDate) AS InvoiceYear,
        CAST(MONTH(i.InvoiceDate) AS VARCHAR(2)) AS InvoiceMonthDisplay,
        SUM(il.ExtendedPrice - il.TaxAmount) AS MonthlyTotal,
        SUM(SUM(il.ExtendedPrice - il.TaxAmount)) 
            OVER (PARTITION BY YEAR(i.InvoiceDate) ORDER BY MONTH(i.InvoiceDate)) AS CumulativeTotal,
        MONTH(i.InvoiceDate) AS SortOrder
    FROM Sales.Invoices i
    JOIN Sales.InvoiceLines il
        ON i.InvoiceID = il.InvoiceID
    GROUP BY YEAR(i.InvoiceDate), MONTH(i.InvoiceDate)

    UNION ALL

    SELECT 
        YEAR(i.InvoiceDate) AS InvoiceYear,
        'Grand Total' AS InvoiceMonthDisplay,
        SUM(il.ExtendedPrice - il.TaxAmount) AS MonthlyTotal,
        SUM(il.ExtendedPrice - il.TaxAmount) AS CumulativeTotal,
        13 AS SortOrder
    FROM Sales.Invoices i
    JOIN Sales.InvoiceLines il
        ON i.InvoiceID = il.InvoiceID
    GROUP BY YEAR(i.InvoiceDate)
) AS Final
ORDER BY InvoiceYear, SortOrder;

--q.8
SELECT * FROM Sales.Orders

SELECT OrderMonth, [2013], [2014], [2015], [2016]
FROM
(
    SELECT 
        YEAR(OrderDate)  AS OrderYear,
        MONTH(OrderDate) AS OrderMonth
    FROM Sales.Orders
    WHERE YEAR(OrderDate) BETWEEN 2013 AND 2016
) AS SourceTable
PIVOT
(
    COUNT(OrderYear)
    FOR OrderYear IN ([2013], [2014], [2015], [2016])
) AS PivotTable
ORDER BY OrderMonth;

--q.9!
SELECT* FROM Sales.Orders 
SELECT *from Sales.Customers
GO 

WITH OrdersWithLag AS (
    SELECT
        c.CustomerID,
        c.CustomerName,
        o.OrderDate,
        LAG(o.OrderDate) OVER (
            PARTITION BY c.CustomerID
            ORDER BY o.OrderDate
        ) AS PreviousOrderDate
    FROM Sales.Orders o
    JOIN Sales.Customers c
        ON o.CustomerID = c.CustomerID
),
CustomerStats AS (
    SELECT
        CustomerID,
        CustomerName,
        MAX(OrderDate) AS LastCustOrderDate,
        AVG(DATEDIFF(DAY, PreviousOrderDate, OrderDate)) AS AvgDaysBetweenOrders
    FROM OrdersWithLag
    WHERE PreviousOrderDate IS NOT NULL
    GROUP BY CustomerID, CustomerName
),
LastDateAll AS (
    SELECT MAX(OrderDate) AS LastOrderDateAll
    FROM Sales.Orders
)
SELECT
    o.CustomerID,
    o.CustomerName,
    o.OrderDate,
    o.PreviousOrderDate,
    CAST(s.AvgDaysBetweenOrders AS INT) AS AvgDaysBetweenOrders,
    s.LastCustOrderDate,
    d.LastOrderDateAll,
    DATEDIFF(DAY, s.LastCustOrderDate, d.LastOrderDateAll) AS DaysSinceLastOrder,
    CASE
        WHEN DATEDIFF(DAY, s.LastCustOrderDate, d.LastOrderDateAll)
             > 2 * s.AvgDaysBetweenOrders
        THEN 'Potential Churn'
        ELSE 'Active'
    END AS CustomerStatus
FROM OrdersWithLag o
JOIN CustomerStats s
    ON o.CustomerID = s.CustomerID
CROSS JOIN LastDateAll d
ORDER BY o.CustomerID, o.OrderDate;

--q.10
SELECT * FROM Sales.Customers
SELECT * FROM Sales.CustomerCategories

SELECT
    cc.CustomerCategoryName,
    COUNT(DISTINCT 
        CASE
            WHEN c.CustomerName LIKE 'Wingtip%' THEN 'Wingtip'
            WHEN c.CustomerName LIKE 'Tailspin%' THEN 'Tailspin'
            ELSE c.CustomerName
        END
    ) AS CustomerCOUNT,
    SUM(COUNT(DISTINCT 
        CASE
            WHEN c.CustomerName LIKE 'Wingtip%' THEN 'Wingtip'
            WHEN c.CustomerName LIKE 'Tailspin%' THEN 'Tailspin'
            ELSE c.CustomerName
        END
    )) OVER () AS TotalCustCount,
    FORMAT(
        COUNT(DISTINCT 
            CASE
                WHEN c.CustomerName LIKE 'Wingtip%' THEN 'Wingtip'
                WHEN c.CustomerName LIKE 'Tailspin%' THEN 'Tailspin'
                ELSE c.CustomerName
            END
        ) * 100.0 / SUM(COUNT(DISTINCT 
            CASE
                WHEN c.CustomerName LIKE 'Wingtip%' THEN 'Wingtip'
                WHEN c.CustomerName LIKE 'Tailspin%' THEN 'Tailspin'
                ELSE c.CustomerName
            END
        )) OVER (), 'N2'
    ) + '%' AS DistributionFactor
FROM Sales.Customers c
JOIN Sales.CustomerCategories cc
    ON c.CustomerCategoryID = cc.CustomerCategoryID
GROUP BY cc.CustomerCategoryName
ORDER BY 
    cc.CustomerCategoryName,
    CustomerCOUNT DESC;







