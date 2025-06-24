--Creating the Table
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales(
transactions_id INT PRIMARY KEY,	
sale_date DATE,
sale_time TIME,
customer_id INT,
gender VARCHAR(15),
age	INT,
category VARCHAR(15),
quantiy	INT,
price_per_unit FLOAT,	
cogs FLOAT,
total_sale FLOAT
);
--Checking if data Importation was Successful
SELECT * FROM retail_sales;
SELECT COUNT(*) FROM retail_sales;
--Renaming Columns(Data cleaning)
ALTER TABLE retail_sales RENAME COLUMN cogs TO purchasing_cost;
ALTER TABLE retail_sales RENAME COLUMN quantiy TO quantity;
--Checking for null values
SELECT * FROM retail_sales WHERE transactions_id IS NULL;
SELECT * FROM retail_sales WHERE sale_date IS NULL;
SELECT * FROM retail_sales WHERE sale_time IS NULL;
--Checking for null
SELECT * FROM retail_sales 
WHERE transactions_id IS NULL
OR sale_date IS NULL 
OR sale_time IS NULL 
OR gender IS NULL 
OR category IS NULL 
OR quantity IS NULL 
OR price_per_unit IS NULL 
OR purchasing_cost IS NULL
OR total_sale IS NULL
--Deleting nulls(Data cleaning)
DELETE FROM retail_sales
WHERE transactions_id IS NULL
OR sale_date IS NULL 
OR sale_time IS NULL 
OR gender IS NULL 
OR category IS NULL 
OR quantity IS NULL 
OR price_per_unit IS NULL 
OR purchasing_cost IS NULL
OR total_sale IS NULL
--Data Exploration
--Total sales
SELECT COUNT(*) AS Total_sales FROM retail_sales
--Total Number of Unique Customers
SELECT COUNT(DISTINCT customer_id) AS Total_customers FROM retail_sales
--Total Number of Unique Categories
SELECT COUNT(DISTINCT category) AS Total_categories FROM retail_sales
--Unique Category Names
SELECT DISTINCT category AS Unique_category FROM retail_sales
--Summary by category
SELECT category, COUNT(*) FROM retail_sales GROUP BY category;
--Customer with most purchases(Top 5)
SELECT customer_id, COUNT(*) AS purchases
FROM RETAIL_sales GROUP BY customer_id ORDER BY purchases DESC LIMIT 5;
--Average order per customer
SELECT 
  customer_id, 
  ROUND(AVG(total_sale::NUMERIC), 2) AS average_spending
FROM retail_sales
GROUP BY customer_id;
--Sales & Revenue Analysis
--Total Revenue
SELECT SUM(total_sale)AS Total_Revenue FROM retail_sales
--Revenue by Product
SELECT category,SUM(total_sale)AS Total_revenue 
FROM retail_sales 
GROUP BY category
--Revenue by Month
SELECT EXTRACT(MONTH FROM sale_date)AS Month,SUM(total_sale)AS revenue 
FROM retail_sales
GROUP BY Month
ORDER BY Month ASC
--Top Products by Revenue
SELECT category,SUM(total_sale) Total_revenue 
FROM retail_sales
GROUP BY category 
ORDER BY Total_revenue DESC
--Sales by day/week/month
SELECT sale_date,SUM(total_sale)AS revenue
FROM retail_sales
GROUP BY sale_date
--Peak Sales days
SELECT sale_date, SUM(total_sale) AS revenue 
FROM retail_sales 
GROUP BY sale_date
ORDER BY revenue DESC 
LIMIT 5;
--Most Sold Product By quantity
SELECT category,SUM(quantity)AS quantity_sold
FROM retail_sales
GROUP BY category
--Number of transactions made by each gender by each category
SELECT category,gender,COUNT(*)AS transactions
FROM retail_sales
GROUP BY gender,category
ORDER BY 1
-- Monthly rank in each year based on sales
SELECT year,month,average_sale
FROM(
SELECT EXTRACT(YEAR FROM sale_date)AS Year,
EXTRACT(MONTH FROM sale_date)AS Month,
ROUND(AVG(total_sale),2)AS average_sale,
RANK() OVER( PARTITION BY  EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale)DESC)AS rank
FROM retail_sales
GROUP BY year,Month)sub
WHERE rank=1
--Shift and number of orders(ie Morning<12,Afternoon between 12&17, Evening>17)
SELECT *,
   CASE
       WHEN EXTRACT(HOUR FROM sale_time)<12 THEN 'Morning'
	   WHEN EXTRACT(HOUR FROM sale_time)>12 AND EXTRACT(HOUR FROM sale_time)<17 THEN 'Afternoon'
	   ELSE 'Evening'
	END AS shift
FROM retail_sales	
--Time of the day when sales occur the most
SELECT shift,ROUND(AVG(total_sale),2)AS average_sale
FROM(SELECT *,
   CASE
       WHEN EXTRACT(HOUR FROM sale_time)<12 THEN 'Morning'
	   WHEN EXTRACT(HOUR FROM sale_time)>12 AND EXTRACT(HOUR FROM sale_time)<17 THEN 'Afternoon'
	   ELSE 'Evening'
	END AS shift
	FROM retail_sales)sub
	GROUP BY shift
	ORDER BY average_sale DESC
--End of Project	