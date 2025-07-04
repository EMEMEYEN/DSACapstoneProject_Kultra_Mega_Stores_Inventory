USE Kultra; -- DB Name

-- Orders Table Creation
CREATE TABLE Orders (
    OrderID INT NOT NULL PRIMARY KEY,
    OrderDate DATE,
	ShipDate DATE,
    CustomerName NVARCHAR(100),
    CustomerSegment NVARCHAR(50),
    ProductName NVARCHAR(100),
    Category NVARCHAR(50),
    OrderQuantity INT,
    UnitPrice DECIMAL(10,2),
    Sales DECIMAL(10,2),
	Discount DECIMAL(5,2),
	Profit DECIMAL(10,2),
    Region NVARCHAR(50),
	Province NVARCHAR(50),
    ShippingMethod NVARCHAR(50),
    OrderPriority NVARCHAR(20),
    ShippingCost DECIMAL(10,2),
	ProductBaseMargin DECIMAL(5,2),
    Returned BIT
);

SELECT * FROM Orders -- Empty right now

-- Imported KMS Sql Case Study.csv (KMS_Sql_Case_Study table) and Order_Status.csv (Order_Status table)

--Cleaned KMS_Sql_Case_Study table table and then imserted clean data into Orders table I created, query below

-- Check for duplicates:
SELECT Order_ID, COUNT(*) AS Occurrences 
FROM KMS_Sql_Case_Study
GROUP BY Order_ID
HAVING COUNT(*) > 1;

-- Insert only the first occuring OrderID into the Orders table to remove duplicates
WITH RankedOrders AS (
  SELECT *,
         ROW_NUMBER() OVER (PARTITION BY Order_ID ORDER BY TRY_CAST(Order_Date AS DATE)) AS rn
  FROM KMS_Sql_Case_Study
)
INSERT INTO Orders (
     OrderID, OrderDate, ShipDate, CustomerName, CustomerSegment, 
	ProductName, Category, OrderQuantity,
    UnitPrice, Sales, Discount, Profit,
    Region, Province, ShippingMethod, OrderPriority,
    ProductBaseMargin, ShippingCost, Returned
)

SELECT
	ro.Order_ID AS OrderID,
  TRY_CAST(ro.Order_Date AS DATE) AS OrderDate,
  TRY_CAST(ro.Ship_Date AS DATE) AS ShipDate,
  ro.Customer_Name AS CustomerName,
  ro.Customer_Segment AS CustomerSegment,
  ro.Product_Name AS ProductName,
  ro.Product_Category AS Category,
  ro.Order_Quantity AS OrderQuantity,
  ro.Unit_Price AS UnitPrice,
  ro.Sales AS Sales,
  ro.Discount,
  ro.Profit,
  ro.Region,
  ro.Province,
  ro.Ship_Mode AS ShippingMethod,
  ro.Order_Priority AS OrderPriority,
  ro.Product_Base_Margin,
  ro.Shipping_Cost AS ShippingCost,
  CASE WHEN os.Status = 'Returned' THEN 1 ELSE 0 END AS Returned
FROM
  RankedOrders ro
LEFT JOIN
  Order_Status os
  ON ro.Order_ID = os.Order_ID
WHERE ro.rn = 1;

--- (5496 rows affected)

-- Duplicates removed from Orders table, check:
SELECT OrderID, COUNT(*) AS Occurrences
FROM Orders
GROUP BY OrderID
HAVING COUNT(*) > 1; 

--After filling and cleaning Orders table, answered Case Scenario 1 questions

--1. Product category with highest sales
SELECT Category, SUM(Sales) AS TotalSales
FROM Orders
GROUP BY Category
ORDER BY TotalSales DESC;

--2. Top 3 and Bottom 3 regions by sales
	-- Top 3
SELECT TOP 3 Region, SUM(Sales) AS TotalSales
FROM Orders
GROUP BY Region
ORDER BY TotalSales DESC;

	-- Bottom 3
SELECT TOP 3 Region, SUM(Sales) AS TotalSales
FROM Orders
GROUP BY Region
ORDER BY TotalSales ASC;

--3. Total sales of appliances in Ontario
SELECT SUM(Sales) AS TotalApplianceSales
FROM Orders
WHERE Category = 'Appliance' AND Province = 'Ontario';


--4. How to increase revenue from bottom 10 customers
	-- To advise management, first understand the customer a bit more by running queries like this:
		-- Get bottom 10 customers by total sales
		-- Targeted promotions: These customers may need discount offers or loyalty rewards to increase their engagement.
		-- Offer complementary products to what they previously bought
		-- If most are 'Consumers', introduce tailored bundles

SELECT TOP 10 
  CustomerName,
  CustomerSegment,
  SUM(Sales) AS TotalSales
FROM Orders
GROUP BY CustomerName, CustomerSegment
ORDER BY TotalSales ASC;


--5. Which shipping method incurred the most shipping cost
SELECT 
  ShippingMethod,
  SUM(ShippingCost) AS TotalShippingCost
FROM Orders
GROUP BY ShippingMethod
ORDER BY TotalShippingCost DESC;

-- Case Scenario 2 questions answered on Kultra_CaseScenrio2.sql file to avoid messy sql file
