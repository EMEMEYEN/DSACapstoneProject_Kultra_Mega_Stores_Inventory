-- Orders table has been set up in Kultra_CaseScenario1.sql file
USE Kultra;
SELECT * FROM Orders

--6. Most valuable customers & what they purchase
	-- Top 5 customers by profit
SELECT TOP 5
  CustomerName,
  SUM(Sales) AS TotalSales,
  SUM(Sales - ShippingCost) AS Profit,
  STRING_AGG(Category, ', ') AS CategoriesPurchased,
  STRING_AGG(ProductName, ', ') AS ProductBought
FROM Orders
GROUP BY CustomerName
ORDER BY Profit DESC;


--7. Small business customer with highest sales
SELECT TOP 1
  CustomerName,
  SUM(Sales) AS TotalSales
FROM Orders
WHERE CustomerSegment = 'Small Business'
GROUP BY CustomerName
ORDER BY TotalSales DESC;


--8. Corporate customer with the most orders (2009–2012)
SELECT TOP 1
  CustomerName,
  COUNT(OrderID) AS OrderCount
FROM Orders
WHERE CustomerSegment = 'Corporate'
  AND OrderDate BETWEEN '2009-01-01' AND '2012-12-31'
GROUP BY CustomerName
ORDER BY OrderCount DESC;

--9. Most profitable consumer customer
SELECT TOP 1
  CustomerName,
  SUM(Sales - ShippingCost) AS Profit
FROM Orders
WHERE CustomerSegment = 'Consumer'
GROUP BY CustomerName
ORDER BY Profit DESC;

-- 10. Who returned items & what segment
SELECT DISTINCT
  CustomerName,
  CustomerSegment
FROM Orders
WHERE Returned = 1;


-- 11. Did they spend shipping costs appropriately?
	-- Short Answer: No
		-- Critical priority orders, were frequently shipped using Delivery Truck. This likely caused delays.
		-- On the other hand, Low priority orders were often shipped via Express Air, the most expensive option, unnecessarily increasing costs.

SELECT 
  ShippingMethod,
  OrderPriority,
  COUNT(*) AS OrderCount,
  AVG(ShippingCost) AS AvgShippingCost
FROM Orders
GROUP BY ShippingMethod, OrderPriority
ORDER BY OrderPriority, AvgShippingCost DESC;

