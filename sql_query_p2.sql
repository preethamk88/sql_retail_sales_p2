--SQL Retail Sales Analysis - P1
CREATE DATABASE sql_project_p2;


--Create Table 
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
			(
				transactions_id	INT PRIMARY KEY,
				sale_date	DATE,
				sale_time	TIME,
				customer_id	INT,
				gender	VARCHAR(15),
				age	INT,
				category VARCHAR(15),	
				quantiy FLOAT,
				price_per_unit FLOAT,	
				cogs	FLOAT,
				total_sale FLOAT
            );
			
SELECT * FROM retail_sales
LIMIT 10

SELECT 
	COUNT(*) 
FROM retail_sales

--DATA CLEANING
SELECT * FROM retail_sales
WHERE transactions_id is NULL


SELECT * FROM retail_sales
WHERE SALE_DATE is NULL

SELECT * FROM retail_sales
WHERE SALE_TIME is NULL


SELECT * FROM retail_sales
WHERE 
	transactions_id is NULL
	OR
	sale_date is NULL
	OR
	sale_time is NULL
	OR 
	gender IS NULL
	OR
	category IS NULL
	OR 
	quantiy IS NULL
	OR
	cogs IS NULL
	OR 
	total_sale IS NULL;

--
DELETE FROM retail_sales
WHERE 
	transactions_id is NULL
	OR
	sale_date is NULL
	OR
	sale_time is NULL
	OR 
	gender IS NULL
	OR
	category IS NULL
	OR 
	quantiy IS NULL
	OR
	cogs IS NULL
	OR 
	total_sale IS NULL;

--DATA EXPLORATION 

--HOW MANY SALES WE HAVE?
SELECT 
	COUNT(*) AS TOTAL_SALE 
FROM retail_sales

--HOW MANY UNIQUE CUSTOMERS WE HAVE?
SELECT 
	COUNT(DISTINCT CUSTOMER_ID) AS TOTAL_SALE 
FROM retail_sales

SELECT DISTINCT CATEGORY FROM RETAIL_SALES

--DATA ANALYSIS & BUSINESS KEY PROOBLEM & ANSWERS

--1.WRITE A SQL QUERY TO RETRIEVE ALL COLUMNS FOR SALE MADE ON "2022-11-05"

SELECT * FROM RETAIL_SALES 
WHERE SALE_DATE ='2022-11-05';

-- WRITE A SQL QUERY TO RETRIEVE ALL TRANSACTIONS WHERE THE CATEGORY IS 'CLOTHING ' AND THE QUANTIY SOLD IS MORE THAN 4 IN THE MONTH OF NOV-2022
SELECT *
FROM RETAIL_SALES 
WHERE CATEGORY ='Clothing'
AND
TO_CHAR(SALE_DATE, 'YYYY-MM')='2022-11'
and
quantiy >=4

--3.write a sql query to calculate the total sales (total_sale) for each category.

SELECT 
	CATEGORY,
	SUM(total_sale) AS NET_SALE,
	COUNT(*) AS TOTAL_ORDERS
FROM RETAIL_SALES
GROUP BY 1

--4. write a sql query to find the average age of customers who purchased item from the 'Beauty ' category?

SELECT 
	ROUND(AVG(age),2 ) as avg_age
FROM RETAIL_SALES
WHERE CATEGORY = 'Beauty'

--5. write a sql query to find all transactions where the total_sale is greater than 1000.

SELECT* FROM RETAIL_SALES
WHERE total_sale >1000

--6. write a sql query to find the total number of transactions (transaction_id ) made by each gender in each category.

SELECT 
	CATEGORY,
	GENDER,
	COUNT(*) AS TOTAL_TRANS
FROM RETAIL_SALES
GROUP 
	BY
	CATEGORY,
	GENDER
ORDER BY 1

--7. WRITE A SQL QUERY TO CALCULATE AVERAGE SALE OF EACH MONTH.FIND OUT BEST SELLING MONTH IN EACH YEAR.

SELECT 
	YEAR,
	MONTH,
	AVG_SALE
FROM 
(
SELECT 
	EXTRACT (YEAR FROM SALE_DATE ) AS YEAR,
	EXTRACT (MONTH FROM SALE_DATE) AS MONTH ,
	AVG(total_sale) as avg_sale,
	RANK() OVER(PARTITION BY EXTRACT(YEAR FROM SALE_DATE)ORDER BY AVG(TOTAL_SALE)DESC) AS RANK 
FROM RETAIL_SALES
GROUP BY 1, 2)
AS T1
WHERE RANK=1
--ORDER BY 1, 3 DESC

--8. WRITE A QUERY TO FIND TOP 5 CUSTOMERS BASED ON THE HIGHEST TOTAL SALES

SELECT 
	CUSTOMER_ID,
	SUM(TOTAL_SALE) AS TOTAL_SALE
	FROM RETAIL_SALES
	GROUP BY 1
	ORDER BY 2 DESC
	LIMIT 5

--9. WRITE A SQL QUERY TO FIND THE NUMBER OF UNIQUE CUSTOMERS WHO PURCHASED ITEMS FROM EACH CATEGORY 

SELECT 
	CATEGORY,
	COUNT(DISTINCT CUSTOMER_ID) AS CNT_UNIQUE_CS
	FROM RETAIL_SALES
	GROUP BY CATEGORY 

--10. WRITE A SQL QUERY TO CREATE EACH SHIFT AND NUMBER OF ORDERS (EXAMPLE MORNING <12),AFTERNOON BETWEEN 12&17,EVENING >17;

WITH hourly_sale
AS
(
SELECT * ,
	CASE
	WHEN EXTRACT (HOUR FROM SALE_TIME)<=12 THEN 'MORNING' 
	WHEN EXTRACT (HOUR FROM SALE_TIME)BETWEEN 12 AND 17 THEN 'AFTERNOON'
	ELSE 'EVENING'
	END AS SHIFT 
FROM RETAIL_SALES
)
SELECT 
	shift,
	COUNT(*)AS TOTAL_ORDERS 
FROM hourly_sale
GROUP BY SHIFT

-- END OF PROJECT