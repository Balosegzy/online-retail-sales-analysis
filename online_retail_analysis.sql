
-- SECTION 1 — DATA EXPLORATION & DATA QUALITY 

-- Count Invoice Numbers
SELECT COUNT(invoiceno) AS Invoice_Count FROM online_retail;

-- Transaction Records by Country
SELECT country, COUNT(*) AS Transaction_Record FROM online_retail 
  GROUP BY country ORDER BY Transaction_Record DESC; 

-- Top Stockcodes by Total Quantity
SELECT stockcode, SUM(quantity) AS Total_Quantity FROM online_retail 
  GROUP BY stockcode ORDER BY Total_Quantity DESC LIMIT 10; 

-- Total Number of Records
SELECT COUNT(*) AS Total_Records FROM online_retail;

-- Number of Unique Countries
SELECT COUNT(DISTINCT country) AS Unique_Countries FROM online_retail;

-- Number of Unique Stockcodes
SELECT COUNT(DISTINCT stockcode) AS Unique_Stockcodes FROM online_retail;

-- Number of Unique Customers
SELECT COUNT(DISTINCT customerid) AS Unique_Customers FROM online_retail; 

-- NULL Customer IDs
SELECT COUNT(*) AS Null_CustomerID FROM online_retail WHERE customerid IS NULL;

-- NULL Descriptions
SELECT COUNT(*) AS Null_Description FROM online_retail WHERE description IS NULL;

-- Negative Quantities
SELECT COUNT(*) AS Negative_Quantity FROM online_retail WHERE quantity < 0;

-- Zero Quantities
SELECT COUNT(*) AS Zero_Quantity FROM online_retail WHERE quantity = 0;

-- Zero or Negative Unit Prices
SELECT COUNT(*) AS Invalid_UnitPrice FROM online_retail WHERE unitprice <= 0;

-- Cancelled Invoice Records
SELECT COUNT(*) AS Cancelled_Records FROM online_retail WHERE invoiceno LIKE 'C%';;


-- SECTION 2 — COUNTRY ANALYSIS

-- Transaction Records by Country
SELECT country, COUNT(*) AS Transaction_Records FROM online_retail
  GROUP BY country ORDER BY Transaction_Records DESC;

-- Unique Orders by Country
SELECT country,COUNT(DISTINCT invoiceno) AS Unique_Orders FROM online_retail 
  GROUP BY country ORDER BY Unique_Orders DESC; 

-- Total Quantity by Country
SELECT country, SUM(quantity) AS Total_Quantity FROM online_retail
  GROUP BY country ORDER BY Total_Quantity DESC;

-- Revenue by Country
SELECT country, SUM(quantity*unitprice) AS Total_Revenue FROM online_retail 
  GROUP BY country ORDER BY Total_Revenue DESC; 

-- Average Revenue per Transaction Record by Country
SELECT country, AVG(quantity*unitprice) AS Avg_Revenue_Per_Record FROM online_retail 
  GROUP BY country ORDER BY Avg_Revenue_Per_Record DESC;


-- SECTION 3 — PRODUCT ANALYSIS

-- Top 10 Highest Total Quantity by Stockcode
SELECT stockcode, SUM(quantity) AS Total_Quantity FROM online_retail 
  GROUP BY stockcode ORDER BY Total_Quantity DESC LIMIT 10;

-- Top 10 Highest Product Revenue
SELECT stockcode, SUM(quantity*unitprice) AS Total_Revenue FROM online_retail
  GROUP BY stockcode ORDER BY Total_Revenue DESC LIMIT 10; 

-- Highest Single Recorded Quantity
SELECT stockcode, MAX(quantity) AS Highest_Single_Quantity FROM online_retail 
  GROUP BY stockcode ORDER BY Highest_Single_Quantity DESC LIMIT 10;

-- Highest Single Line-Item Revenue
SELECT stockcode, description, quantity, unitprice, quantity*unitprice AS Line_Revenue FROM online_retail 
  ORDER BY Line_Revenue DESC LIMIT 10;

-- Product Quantity and Revenue Together
SELECT stockcode, description, SUM(quantity) AS Total_Quantity, SUM(quantity*unitprice) AS Total_Revenue FROM online_retail 
  GROUP BY stockcode, description ORDER BY Total_Revenue DESC LIMIT 10; 

-- DOT Product Investigation
SELECT stockcode, description, SUM(quantity) AS Total_Quantity, SUM(quantity * unitprice) AS Total_Revenue FROM online_retail 
  WHERE stockcode = 'DOT' GROUP BY stockcode, description; 

-- World War 2 Gliders Investigation
SELECT stockcode, description, SUM(quantity) AS Total_Quantity, SUM(quantity * unitprice) AS Total_Revenue FROM online_retail 
  WHERE stockcode = '84077' GROUP BY stockcode, description; 

-- World War 2 Gliders Investigation II
SELECT stockcode,description,quantity, unitprice, quantity*unitprice AS Line_Revenue FROM online_retail
  WHERE stockcode = 84077; 


-- SECTION 4 — CUSTOMER ANALYSIS

-- Top 10 Customers by Revenue
SELECT customerid, SUM(quantity*unitprice) AS Total_Revenue FROM online_retail
  WHERE customerid IS NOT NULL GROUP BY customerid ORDER BY Total_Revenue DESC LIMIT 10;

-- Top 10 Customers by Unique Orders
SELECT customerid, COUNT(DISTINCT invoiceno) AS Unique_Orders FROM online_retail 
  WHERE customerid IS NOT NULL GROUP BY customerid ORDER BY Unique_Orders DESC LIMIT 10; 

-- Top 10 Customers by Total Quantity
SELECT customerid, SUM(quantity) AS Total_Quantity FROM online_retail
  WHERE customerid IS NOT NULL GROUP BY customerid ORDER BY Total_Quantity DESC LIMIT 10; 

-- Average Revenue per Order by Customer
SELECT customerid, AVG(Order_Revenue) AS Avg_Revenue_Per_Order FROM (SELECT customerid, invoiceno, SUM(quantity*unitprice) AS Order_Revenue FROM online_retail
  WHERE customerid IS NOT NULL GROUP BY customerid, invoiceno) GROUP BY customerid ORDER BY Avg_Revenue_Per_Order DESC LIMIT 10;

-- Inspect Customer 18102
SELECT customerid, unitprice, quantity FROM online_retail WHERE customerid = 18102;

-- Unique Orders for Customer 18102
SELECT customerid, COUNT(DISTINCT invoiceno) AS Unique_Orders FROM online_retail WHERE customerid = 18102 GROUP BY customerid; 

-- Inspect Customer 14911
SELECT customerid, unitprice, quantity FROM online_retail WHERE customerid = 14911;

-- Unique Orders for Customer 14911
SELECT customerid, COUNT(DISTINCT invoiceno) AS Unique_Orders FROM online_retail 
  WHERE customerid = 14911 GROUP BY customerid; 

-- Compare Selected High-Value Customers
SELECT customerid, COUNT(DISTINCT invoiceno) AS Unique_Orders, SUM(quantity) AS Total_Quantity, SUM(quantity*unitprice) AS Total_Revenue FROM online_retail 
  WHERE customerid IN (14646, 14911, 18102) GROUP BY customerid ORDER BY Total_Revenue DESC;


-- SECTION 5 — MONTHLY PERFORMANCE

-- Revenue by Year and Month
SELECT substr(invoicedate, 7, 4) AS Year, substr(invoicedate, 4, 2) AS Month, SUM(quantity*unitprice) AS Total_Revenue FROM online_retail
  GROUP BY Year, Month ORDER BY Year, Month ASC; 

-- Quantity by Year and Month
SELECT substr(invoicedate, 7, 4) AS Year, substr(invoicedate, 4, 2) AS Month, SUM(quantity) AS Total_Quantity FROM online_retail 
  GROUP BY Year,Month ORDER BY Year, Month ASC; 

-- Transaction Records by Year and Month
SELECT substr(invoicedate, 7, 4) AS Year, substr(invoicedate, 4, 2) AS Month, COUNT(*) AS Transaction_Records FROM online_retail 
  GROUP BY Year, Month ORDER BY Year, Month ASC; 

-- Average Revenue per Transaction Record by Month
SELECT substr(invoicedate, 7, 4) AS Year, substr(invoicedate, 4, 2) AS Month, AVG(quantity*unitprice) AS Avg_Revenue_Per_Record FROM online_retail 
  GROUP BY Year, Month ORDER BY Year, Month; 


-- SECTION 6 — CANCELLATION IMPACT
   
-- Distinct Cancelled Invoices
SELECT COUNT(DISTINCT invoiceno) AS Cancelled_Invoices FROM online_retail
  WHERE invoiceno LIKE 'C%'; 

-- Total Quantity Associated with Cancelled Invoices
SELECT SUM(quantity) AS Total_Cancelled_Quantity FROM online_retail
  WHERE invoiceno LIKE 'C%';

-- Cancellation Revenue Adjustment
SELECT SUM(quantity*unitprice) AS Cancellation_Revenue_Adjustment FROM online_retail 
  WHERE invoiceno LIKE 'C%';

-- Total Recorded Revenue Including Cancellation Adjustments
SELECT SUM(quantity*unitprice) AS Total_Recorded_Revenue FROM online_retail;

-- Revenue Excluding Cancellation Records
SELECT SUM(quantity*unitprice) AS Revenue_Excl_Cancellations FROM online_retail 
  WHERE invoiceno NOT LIKE 'C%';


-- SECTION 7 — IDENTIFIED CUSTOMER REVENUE

-- Revenue Attributed to Customers with Known CustomerID
SELECT SUM(quantity*unitprice) AS Identified_Customer_Revenue FROM online_retail
  WHERE customerid IS NOT NULL; 

-- Top 10 Customers as a Share of Identified Customer Revenue
SELECT SUM(Total_Revenue) AS Top_10_Customer_Revenue FROM
  (SELECT customerid, SUM(quantity*unitprice) AS Total_Revenue FROM online_retail 
  WHERE customerid IS NOT NULL GROUP BY customerid ORDER BY Total_Revenue DESC LIMIT 10);


-- SECTION 8 — UK MARKET DEEP DIVE

-- UK Transaction Records
SELECT country, COUNT(*) AS Transaction_Records FROM online_retail 
  WHERE country = 'United Kingdom' GROUP BY country; 

-- UK Unique Orders
SELECT country, COUNT(DISTINCT invoiceno) AS Unique_Orders FROM online_retail 
  WHERE country = 'United Kingdom';

-- UK Records with Known CustomerID
SELECT country, COUNT(*) AS Identified_Customer_Records FROM online_retail
  WHERE country = 'United Kingdom' AND customerid IS NOT NULL ;

-- UK Unique Customers
SELECT country, COUNT(DISTINCT customerid) AS Unique_Customers FROM online_retail 
  WHERE country = 'United Kingdom' AND customerid IS NOT NULL; 

-- Unique Customers by Country
SELECT country, COUNT(DISTINCT customerid) AS Unique_Customers FROM online_retail 
  WHERE customerid IS NOT NULL GROUP BY country ORDER BY Unique_Customers DESC;

-- Unique Orders by Country
SELECT country, COUNT(DISTINCT invoiceno) AS Unique_Orders FROM online_retail 
  GROUP BY country ORDER BY Unique_Orders DESC;

-- Total Quantity by Country
SELECT country, SUM(quantity) AS Total_Quantity FROM online_retail 
  GROUP BY country ORDER BY Total_Quantity DESC;


-- SECTION 9 — Results/Performance Exported to Excel for Dashboard creation 

-- Customer Performance Including Average Revenue Per Order
SELECT customerid, COUNT(DISTINCT invoiceno) AS Unique_Orders, SUM(Total_Quantity) AS Total_Quantity, SUM(Order_Revenue) AS Total_Revenue, AVG(Order_Revenue) AS Avg_Revenue_Per_order FROM
  (SELECT customerid, invoiceno, SUM(quantity) AS Total_Quantity, SUM(quantity*unitprice) AS Order_Revenue FROM online_retail 
  WHERE customerid IS NOT NULL GROUP BY customerid, invoiceno) AS Order_Summary GROUP BY customerid ORDER BY Total_Revenue DESC LIMIT 10;

-- Customer Performance Excluding Average Revenue Per Order
SELECT customerid, COUNT(DISTINCT invoiceno) AS Unique_Orders, SUM(quantity) AS Total_Quantity, SUM(quantity*unitprice) AS Total_Revenue FROM online_retail
  WHERE customerid IS NOT NULL GROUP BY customerid ORDER BY Total_Revenue DESC LIMIT 10;

-- Product Performance
SELECT stockcode, description, SUM(quantity) AS Total_Quantity, SUM(quantity * unitprice) AS Total_Revenue FROM online_retail 
  GROUP BY stockcode, description ORDER BY Total_Revenue DESC LIMIT 10;

-- Monthly Performance
SELECT substr(invoicedate, 7, 4) AS Year, substr(invoicedate, 4, 2) AS Month, SUM(quantity*unitprice) AS Total_Revenue, SUM(quantity) AS Total_Quantity, COUNT(*) AS Transaction_Records, AVG(quantity*unitprice) AS Avg_Revenue_Per_Record FROM online_retail
  GROUP BY Year, Month ORDER BY Year, Month ASC;

-- Country Performance
SELECT country, SUM(quantity*unitprice) AS Total_Revenue, SUM(quantity) AS Total_Quantity , COUNT(*) AS Transaction_Records, COUNT(DISTINCT invoiceno) AS Unique_Orders , AVG(quantity*unitprice) AS Avg_Revenue_Per_Record FROM online_retail
  GROUP BY country ORDER BY Total_Revenue DESC;

-- Cancellation Analysis
SELECT COUNT(DISTINCT invoiceno) AS Total_Unique_Invoices, COUNT(DISTINCT CASE WHEN invoiceno LIKE 'C%' THEN invoiceno END) AS Cancelled_Unique_Invoices, COUNT(CASE WHEN invoiceno LIKE 'C%' THEN invoiceno END) AS Cancelled_Invoice_Records,
  SUM(CASE WHEN invoiceno LIKE 'C%' THEN quantity ELSE 0 END) AS Cancellation_Quantity, SUM(CASE WHEN invoiceno LIKE 'C%' THEN quantity*unitprice ELSE 0 END) AS Cancellation_Revenue_Adjustment FROM online_retail; 

-- Revenue Concentration Analysis
SELECT Top_10_Customer_Revenue, Identified_Customer_Revenue, ROUND(Top_10_Customer_Revenue /Identified_Customer_Revenue * 100, 2) AS Top_10_Revenue_Share_Percent FROM(SELECT (SELECT SUM(Total_Revenue) FROM ( SELECT SUM(quantity*unitprice) AS Total_Revenue FROM online_retail
  WHERE customerid IS NOT NULL GROUP BY customerid ORDER By Total_Revenue DESC LIMIT 10 )) AS Top_10_Customer_Revenue, (SELECT SUM(quantity*unitprice) FROM online_retail WHERE customerid IS NOT NULL) AS Identified_Customer_Revenue);
