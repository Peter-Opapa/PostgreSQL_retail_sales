#Retail Sales Analysis PostgreSQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Level**: Beginner  
**Database**: `PostgreSQL_Sales_Project`

In this project, I have demonstrated my PostgreSQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries.
## Objectives

1. **To Set up a retail sales database**: I Created and populated a retail sales database with the provided sales data.
2. **To Clean Data**: I Identified and removed all records with missing or null values.
3. **To utilize Exploratory Data Analysis (EDA)**: I Performed basic exploratory data analysis to understand the dataset.
4. **To analyse Sales and Revenue**: I used PostgreSQL to answer specific business questions and derived insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: I created a database named `PostgreSQL_Sales_Project`.
- **Table Creation**: I created a table named `retail_sales` to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit,cogs(Cost of goods), and total sale amount.

```sql
CREATE DATABASE p1_retail_db;

CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);
```

### 2. Data Exploration & Cleaning
-**Checking for successful importation**:I checked if every data in the table was loaded from Excel(CSV file)
-**Renaming Columns**:I changed two column names for ease
- **Null Value Check**: I Checked for any null values in the dataset and deleted the records with missing data.
- **Total number of Sales**: Determine the total number of sales in the dataset.
- **Customer Count**: I wrote a query to find out how many unique customers are in the dataset.
- **Category Count**: I Identified all unique product categories in the dataset.
- **Average Order per customer**:I identified avarage order per customer
- **Summary of Total Product sold per category**: Found out total products grouped by category


```sql
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
```

### 3. Data Analysis & Findings

I developed the following PostgreSQL queries to analyze Sales & Revenue:

1. **Total Revenue**:
```sql
SELECT SUM(total_sale)AS Total_Revenue FROM retail_sales
```

2. **Total Revenue by Product**:
```sql
SELECT category,SUM(total_sale)AS Total_revenue 
FROM retail_sales 
GROUP BY category
```

3. **Total Revenue by Month**:
```sql
SELECT EXTRACT(MONTH FROM sale_date)AS Month,SUM(total_sale)AS revenue 
FROM retail_sales
GROUP BY Month
ORDER BY Month ASC
```

4. **Top Products by Revenue**:
```sql
SELECT category,SUM(total_sale) Total_revenue 
FROM retail_sales
GROUP BY category 
ORDER BY Total_revenue DESC
```

5. **Total Sales by each day/week/month**:
```sql
SELECT sale_date,SUM(total_sale)AS revenue
FROM retail_sales
GROUP BY sale_date
```

6. **Top 5 days when most sales occured**:
```sql
SELECT sale_date, SUM(total_sale) AS revenue 
FROM retail_sales 
GROUP BY sale_date
ORDER BY revenue DESC 
LIMIT 5;
```

7. **Quantity of Product Sold by Category**:
```sql
SELECT category,SUM(quantity)AS quantity_sold
FROM retail_sales
GROUP BY category
```

8. **Number of transactions made by each gender by each category
```sql
SELECT category,gender,COUNT(*)AS transactions
FROM retail_sales
GROUP BY gender,category
ORDER BY 1
```

9. **Best seller Month per year**:
```sql
SELECT year,month,average_sale
FROM(
SELECT EXTRACT(YEAR FROM sale_date)AS Year,
EXTRACT(MONTH FROM sale_date)AS Month,
ROUND(AVG(total_sale),2)AS average_sale,
RANK() OVER( PARTITION BY  EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale)DESC)AS rank
FROM retail_sales
GROUP BY year,Month)sub
WHERE rank=1
```

10. **Time of the Day when orders occur and number of orders(ie Morning<12,Afternoon between 12&17, Evening>17)**:
```sql
SELECT *,
   CASE
       WHEN EXTRACT(HOUR FROM sale_time)<12 THEN 'Morning'
	   WHEN EXTRACT(HOUR FROM sale_time)>12 AND EXTRACT(HOUR FROM sale_time)<17 THEN 'Afternoon'
	   ELSE 'Evening'
	END AS shift
FROM retail_sales
```
11. **Total sales by time of the day ranked in descending order**:
   ```sql
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
``` 
 

## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Electronics,Clothing and Beauty.
- **High-Value Transactions**:Most sales occured in the afternoon across both years.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Behavior**: The analysis identifies the top-spending customers and the most popular product categories.

## Reports

- **Sales & Revenue Analysis**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Time-Based Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Behavior**: Reports on top customers and unique customer counts per category.

## Conclusion

This retail sales analysis project was conducted using PostgreSQL to perform structured data exploration and uncover key business insights. By writing optimized SQL queries, I was able to:
.Analyze revenue trends across products, customers, and time periods

.Identify top-performing products and high-value customers

.Extract average customer spending and segment purchase behaviors

.Perform data cleaning and transformation directly in SQL

This project demonstrates my ability to work with relational databases, write efficient SQL queries, and use SQL as a tool for real-world data analysis. It also showcases foundational skills in data wrangling, aggregation, and business-focused insights — essential for data analyst and data engineering roles

## Author - Peter Opapa@2025
