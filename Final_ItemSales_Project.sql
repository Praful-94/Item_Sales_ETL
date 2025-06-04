-- 1. Create & Use ETL Project Database
CREATE DATABASE IF NOT EXISTS ETL_ItemSales;
USE ETL_ItemSales;


-- 2. Drop Staging Table if Already Exists
DROP TABLE IF EXISTS Staging_ItemSales;


-- 3. Create Staging Table (Raw CSV Import)
CREATE TABLE Staging_ItemSales(
`Customer Name` VARCHAR(255),
`Item Name` VARCHAR(255),
`Stock Code` VARCHAR(100),
`# Sold` INT,
`Category` VARCHAR(100),
`Supplier` VARCHAR(100),
`Stock Level` INT,
`Price` VARCHAR(50),
`Cost` VARCHAR(50),
`Profit` VARCHAR(50),
`Margin` VARCHAR(50),
`Markup` VARCHAR(50),
`Discounts` VARCHAR(50),
`Tax` VARCHAR(50),
`Total` VARCHAR(50),
`# Refunded` INT,
`Total_[0]` VARCHAR(50),
`Balance` VARCHAR(50));


-- 4. Create Final Clean Table (Transformed)
CREATE TABLE Final_ItemSales (
id INT AUTO_INCREMENT PRIMARY KEY,
CustomerName VARCHAR(255),
ItemName VARCHAR(255),
StockCode VARCHAR(100),
UnitsSold INT,
Category VARCHAR(100),
Supplier VARCHAR(100),
StockLevel INT,
Price DECIMAL(10,2),
Cost DECIMAL(10,2),
Profit DECIMAL(10,2),
Margin DECIMAL(7,2),
Markup DECIMAL(7,2),
Discounts DECIMAL(10,2),
Tax DECIMAL(10,2),
Total DECIMAL(10,2),
Refunded INT,
RefundedAmount DECIMAL(10,2),
Balance DECIMAL(10,2));


-- 5. Transform & Load Data from Staging to Final Table
INSERT INTO Final_ItemSales(
CustomerName, ItemName, StockCode, UnitsSold, Category, Supplier,
StockLevel, Price, Cost, Profit, Margin, Markup,
Discounts, Tax, Total, Refunded, RefundedAmount, Balance)
SELECT
`Customer Name`,
`Item Name`,
`Stock Code`,
`# Sold`,
`Category`,
`Supplier`,
`Stock Level`,
REPLACE(REPLACE(`Price`, '$', ''), ',', '') + 0,
REPLACE(REPLACE(`Cost`, '$', ''), ',', '') + 0,
CASE 
	WHEN `Profit` LIKE '%\%%' THEN NULL
	ELSE REPLACE(REPLACE(`Profit`, '$', ''), ',', '') + 0
END,
REPLACE(REPLACE(`Margin`, '%', ''), ',', '') + 0,
REPLACE(REPLACE(`Markup`, '%', ''), ',', '') + 0,
REPLACE(REPLACE(`Discounts`, '$', ''), ',', '') + 0,
REPLACE(REPLACE(`Tax`, '$', ''), ',', '') + 0,
REPLACE(REPLACE(`Total`, '$', ''), ',', '') + 0,
`# Refunded`,
REPLACE(REPLACE(`Total_[0]`, '$', ''), ',', '') + 0,
REPLACE(REPLACE(`Balance`, '$', ''), ',', '') + 0
FROM Staging_ItemSales;


-- Analysis Queries --


-- 1 Top 10 Best-Selling Items
SELECT ItemName, SUM(UnitsSold) AS TotalSold
FROM Final_ItemSales
GROUP BY ItemName
ORDER BY TotalSold DESC
LIMIT 10;

-- 2 Total Revenue
SELECT SUM(Total) AS TotalRevenue FROM Final_ItemSales;

-- 3 Total Profit
SELECT SUM(Profit) AS TotalProfit FROM Final_ItemSales;

-- 4 Top 15 Best-Selling Items
SELECT ItemName, SUM(UnitsSold) AS TotalSold
FROM Final_ItemSales
GROUP BY ItemName
ORDER BY TotalSold DESC
LIMIT 15;

-- 5 Revenue by Category
SELECT Category, SUM(Total) AS Revenue
FROM Final_ItemSales
GROUP BY Category
ORDER BY Revenue DESC;

-- 6 Profit Margin Distribution
SELECT Margin, COUNT(*) AS Count
FROM Final_ItemSales
GROUP BY Margin
ORDER BY Count DESC;

-- 7 Supplier Performance (by Profit)
SELECT Supplier, SUM(Total) AS Revenue, SUM(Profit) AS Profit
FROM Final_ItemSales
GROUP BY Supplier
ORDER BY Profit DESC;

-- 8 Items with Low Stock Level (< 10)
SELECT ItemName, StockLevel
FROM Final_ItemSales
WHERE StockLevel < 10
ORDER BY StockLevel ASC;

-- 9 Items Above Average Stock Level
SELECT StockLevel, ItemName, (SELECT AVG(StockLevel) FROM Final_ItemSales) AS Avg_Stock
FROM Final_ItemSales
WHERE StockLevel > (SELECT AVG(StockLevel) FROM Final_ItemSales)
ORDER BY StockLevel DESC;

-- 10 Items with Stock Level > 300
SELECT ItemName, StockLevel
FROM Final_ItemSales
WHERE StockLevel > 300
ORDER BY StockLevel DESC;

-- 11 Total Discounts Given
SELECT SUM(Discounts) AS TotalDiscounts FROM Final_ItemSales;

-- 12 Refunded Items Summary
SELECT ItemName, SUM(Refunded) AS UnitsRefunded, SUM(RefundedAmount) AS TotalRefunded
FROM Final_ItemSales
GROUP BY ItemName
HAVING UnitsRefunded > 0
ORDER BY UnitsRefunded DESC;

-- 13 Profit by Category
SELECT Category, SUM(Profit) AS TotalProfit
FROM Final_ItemSales
GROUP BY Category
ORDER BY TotalProfit DESC;

-- 14 Highest Margin by Item
SELECT ItemName, MAX(Margin) AS Highest_margin
FROM Final_ItemSales
GROUP BY ItemName 
HAVING Highest_margin > 0
ORDER BY Highest_margin DESC;

-- 15 Highest Discounts by Category
SELECT Category, SUM(Discounts) AS Total_Disc
FROM Final_ItemSales
GROUP BY Category
ORDER BY Total_Disc DESC;

-- 16 Stock Value Estimation
SELECT ItemName, StockLevel, (Cost / UnitsSold) AS Item_Cost, (Cost / UnitsSold) * StockLevel AS Stock_Value
FROM Final_ItemSales;

-- 17 Total Refunded Amount
SELECT SUM(RefundedAmount) AS TotalRefunds FROM Final_ItemSales;


-- 7. Drop Staging Table (Cleanup)
DROP TABLE Staging_ItemSales;
