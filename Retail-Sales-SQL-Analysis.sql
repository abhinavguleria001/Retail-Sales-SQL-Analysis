-- Retail Sales SQL Project
-- Author: Abhinav Guleria
-- Database: MySQL


create database retail_sales;
use retail_sales;
describe retail_sales;

-- Check for records with missing Quantity or List Price
SELECT *
FROM retail_sales
WHERE Quantity IS NULL
   OR List_Price IS NULL;

-- Check for duplicate Order IDs
SELECT
    Order_Id,
    COUNT(*) AS Duplicate_Count
FROM retail_sales
GROUP BY Order_Id
HAVING COUNT(*) > 1;

-- Create the Products table containing unique product information
CREATE TABLE products AS
SELECT DISTINCT Product_Id,Category,Sub_Category,cost_price,List_Price
FROM retail_sales;

-- Create the Orders table containing transaction details
CREATE TABLE orders AS
SELECT
    Order_Id,Order_Date,Ship_Mode,Country,City,State,Postal_Code,Region,
    Product_Id,Quantity,Discount_Percent
FROM retail_sales;

-- Display all tables in the current database
SHOW TABLES;

-- INNER JOIN
SELECT
    o.Order_Id,o.Order_Date,p.Product_Id,p.Category,
    p.Sub_Category,p.List_Price,o.Quantity
FROM orders o
INNER JOIN products p
ON o.Product_Id = p.Product_Id
LIMIT 10;

-- BUSINESS ANALYSIS

-- Total revenue
select sum(List_Price * Quantity) AS Total_Revenue
from retail_sales;

-- Count total orders
select count(distinct Order_Id) as Total_orders 
from retail_sales;

-- Sales by region
select Region, sum(List_Price * Quantity) as total_sales
from retail_sales
group by Region
order by total_sales desc;

-- Top 10 Best Selling Products
SELECT
    Product_Id,SUM(Quantity) AS Total_Quantity
FROM orders
GROUP BY Product_Id
ORDER BY Total_Quantity DESC
LIMIT 10;

-- Top 10 Revenue Generating Products
SELECT
    Product_Id,SUM(List_Price * Quantity) AS Total_Revenue
FROM retail_sales
GROUP BY Product_Id
ORDER BY Total_Revenue DESC
LIMIT 10;

-- Top 10 states by revenue
select State, sum(List_Price * Quantity) as total_sales
from retail_sales
group by State
order by total_sales desc limit 10;

-- Total Revenue by Category
SELECT
    Category, SUM(List_Price * Quantity) AS Total_Revenue
FROM retail_sales
GROUP BY Category
ORDER BY Total_Revenue DESC;


-- Monthly sales trend
SELECT MONTH(`Order_Date`) AS month,
       SUM(`List_Price` * Quantity) AS total_sales
FROM retail_sales
GROUP BY MONTH(`Order_Date`)
ORDER BY month;

-- Average Discount by Category
SELECT
    Category,ROUND(AVG(Discount_Percent),2) AS Avg_Discount
FROM retail_sales
GROUP BY Category;
-- Revenue from West region
SELECT
    State,SUM(List_Price * Quantity) AS Total_Revenue
FROM retail_sales
WHERE Region = 'West'
GROUP BY State
ORDER BY Total_Revenue DESC;

-- total quantity by product id
select Product_Id ,sum(Quantity) as total_quantity
from retail_sales
group by Product_Id
order by total_quantity DESC
limit 10;

-- SUBQUERY
-- Products priced above average list price
SELECT Product_Id,
       Category,List_Price
FROM products
WHERE List_Price >
(
    SELECT AVG(List_Price)
    FROM products
)
ORDER BY List_Price DESC;

-- Create a view to store product-wise revenue summary
CREATE VIEW product_revenue_summary AS
SELECT
    Product_Id,SUM(List_Price * Quantity) AS Total_Revenue
FROM retail_sales
GROUP BY Product_Id;

-- Display top 10 revenue-generating products using the view
SELECT *
FROM product_revenue_summary
ORDER BY Total_Revenue DESC
LIMIT 10;

-- CASE WHEN
-- Categorize products based on discount percentage
SELECT
    Product_Id,Discount_Percent,
    CASE
        WHEN Discount_Percent >= 30 THEN 'High Discount'
        WHEN Discount_Percent >= 15 THEN 'Medium Discount'
        ELSE 'Low Discount'
    END AS Discount_Category
FROM retail_sales;

-- Window Function
SELECT
    Product_Id, SUM(Quantity) AS Total_Quantity,
    RANK() OVER(ORDER BY SUM(Quantity) DESC) AS Product_Rank
FROM retail_sales
GROUP BY Product_Id;

-- Dense Rank
SELECT
Product_Id,SUM(Quantity) AS Total_Quantity,
DENSE_RANK() OVER(ORDER BY SUM(Quantity) DESC) AS Product_Rank
FROM retail_sales
GROUP BY Product_Id;





