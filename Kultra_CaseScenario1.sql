USE Kultra;


-- Orders Table Creation
CREATE TABLE Orders (
    OrderID INT,
    OrderDate DATE,
    CustomerID INT,
    CustomerName NVARCHAR(100),
    CustomerSegment NVARCHAR(50),
    ProductID INT,
    ProductName NVARCHAR(100),
    Category NVARCHAR(50),
    Quantity INT,
    UnitPrice DECIMAL(10,2),
    Sales DECIMAL(10,2),
    Region NVARCHAR(50),
    ShippingMethod NVARCHAR(50),
    OrderPriority NVARCHAR(20),
    ShippingCost DECIMAL(10,2),
    Returned BIT
);

SELECT * FROM Orders -- Empty right now

-- Imported KMS Sql Case Study.csv (Orders_Imported table) and Order_Status.csv (Order_Status table)

--Cleaned Orders_Imported table and then imserted clean data into Orders table I created, query below

INSERT INTO Orders (
  OrderID, OrderDate, CustomerID, CustomerName, CustomerSegment,
  ProductID, ProductName, Category, Quantity, UnitPrice,
  Sales, Region, ShippingMethod, OrderPriority, ShippingCost, Returned
)

SELECT
  oi.Order_ID AS OrderID,
  TRY_CAST(oi.Order_Date AS DATE) AS OrderDate,
  NULL AS CustomerID,  -- Missing in source
  oi.Customer_Name AS CustomerName,
  oi.Customer_Segment AS CustomerSegment,
  NULL AS ProductID,   -- Missing in source
  oi.Product_Name AS ProductName,
  oi.Product_Category AS Category,
  oi.Order_Quantity AS Quantity,
  oi.Unit_Price AS UnitPrice,
  oi.Sales AS Sales,
  oi.Region AS Region,
  oi.Ship_Mode AS ShippingMethod,
  oi.Order_Priority AS OrderPriority,
  oi.Shipping_Cost AS ShippingCost,
  CASE WHEN os.Status = 'Returned' THEN 1 ELSE 0 END AS Returned
FROM
  Orders_Imported oi
LEFT JOIN
  Order_Status os
  ON oi.Order_ID = os.Order_ID;


--After filling Orders table, answered Case Scenario 1 questions

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
WHERE Category = 'Appliances'
  AND Region = 'Ontario';


--4. How to increase revenue from bottom 10 customers
	-- Get bottom 10 customers by total sales
SELECT TOP 10 
  CustomerName,
  SUM(Sales) AS TotalSales
FROM Orders
GROUP BY CustomerName
ORDER BY TotalSales ASC;

--5. Which shipping method incurred the most shipping cost
SELECT 
  ShippingMethod,
  SUM(ShippingCost) AS TotalShippingCost
FROM Orders
GROUP BY ShippingMethod
ORDER BY TotalShippingCost DESC;

-- Case Scenario 2 questions answered on Kultra_CaseScenrio2.sql file to avoid messy sql file
