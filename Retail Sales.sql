-- Create a database.
CREATE DATABASE project_1;

-- Use the database.
USE project_1;

-- Drop table if it exists.
DROP TABLE IF EXISTS retail_sales;

-- Creating a table.
CREATE TABLE retail_sales
	(
		transactions_id	INT PRIMARY KEY,
        sale_date DATE, 
        sale_time TIME,	
        customer_id	INT,
        gender VARCHAR(15),
        age INT,	
        category VARCHAR(15),
        quantiy INT,
        price_per_unit FLOAT,	
        cogs FLOAT,
        total_sale FLOAT
    );

-- Display table.
SELECT * 
FROM retail_sales
LIMIT 10;

-- Count the number of rows.
SELECT count(*) AS number_of_rows 
FROM retail_sales;

-- Data cleaning:
-- Checking for null values.
SELECT * 
FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
    OR
	sale_time IS NULL
    OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
    OR
	category IS NULL
	OR
	quantiy IS NULL
    OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;
    
-- Checking for duplication in the data.
SELECT *, COUNT(*) AS duplication
FROM retail_sales
GROUP BY transactions_id, sale_date, sale_time, customer_id, gender, age, category,	quantiy, price_per_unit, cogs, total_sale
HAVING COUNT(*) > 1;

-- Data exploration:
-- Q1: How many sales we have?
SELECT COUNT(*) 
FROM retail_sales;

-- Q2: How many customers we have?
SELECT COUNT(customer_id) AS customers
FROM retail_sales;

-- Q3: How many unique Catagory we have?
SELECT DISTINCT category
FROM retail_sales;

-- Q4: What is the average order value?
SELECT ROUND(SUM(total_sale) / COUNT(*),2) AS average_order_sales
FROM retail_sales;

-- Q5: What is the gender distribution of customers?
SELECT gender, COUNT(*) AS transaction_count
FROM retail_sales
GROUP BY gender;

-- Data analysis & business key problems:
-- Q1: Write a SQL query to retrieve all columns for sales made on '2022-11-05'.
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

-- Q2: Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 2 in the month of Nov-2022.
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
	AND DATE_FORMAT(sale_date,'%m-%Y') = '11-2022' 
    AND quantiy > 2;
    
-- Q3: Write a SQL query to calculate the total sales for each category and the total orders.
SELECT category , SUM(total_sale) AS total_sales , COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category;
    
-- Q4: Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT ROUND(AVG(age),2) AS age
FROM retail_sales
WHERE category = 'Beauty';

-- Q5: Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT *
FROM retail_sales
WHERE total_sale > 1000;    
    
-- Q6: Write a SQL query to find the total number of transactions made by each gender in each category.
SELECT gender , category , COUNT(transactions_id) AS transaction 
FROM retail_sales
GROUP BY 1 , 2
ORDER BY 1;

-- Q7: Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.
SELECT *
FROM (
    SELECT 
        YEAR(sale_date) AS year,
        MONTH(sale_date) AS month,
        ROUND(AVG(total_sale), 2) AS avg_sale,
        RANK() OVER(PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) AS sales_rank
    FROM retail_sales
    GROUP BY YEAR(sale_date), MONTH(sale_date)
) AS t1
WHERE sales_rank = 1;

-- Q8: Write a SQL query to find the top 5 customers based on the highest total sales.
SELECT DISTINCT customer_id, SUM(total_sale) AS total_sales 
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- Q9: Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT COUNT(DISTINCT customer_id) AS customers , category
FROM retail_sales
group by 2;

-- Q10: Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17).

select * from retail_sales;

WITH hourly_sale
AS
(
	SELECT * ,
		CASE 
			WHEN HOUR(sale_time) < 12 THEN 'Morning'
			WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
			ELSE 'Evening'
		END AS shift
	FROM retail_sales
)
SELECT shift , COUNT(transactions_id) AS number_of_orders
FROM hourly_sale
GROUP BY shift
ORDER BY
	CASE 
		WHEN shift = 'Morning' THEN 1
        WHEN shift = 'Afternoon' THEN 2
        WHEN shift = 'Evening' THEN 3
	END;




