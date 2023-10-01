CREATE DATABASE IF NOT EXISTS salesdatawalmart;

SHOW DATABASES;

USE Salesdatawalmart;

CREATE TABLE IF NOT EXISTS  sales (
Invoice_ID	varchar(30) primary key ,
Branch varchar(30) not null,
City	varchar(30) not null,
Customer_type	varchar(30) not null,
Gender	varchar(30) not null,
Product_line	varchar(30) not null,
Unit_price	float not null,
Quantity	int not null,
Tax float not null,
Total	float not null,
Date	datetime not null,
Time	time not null,
Payment	varchar(30) not null,
cogs	float not null,
gross_margin_percentage	float not null,
gross_income	float not null,
Rating float not null);

SELECT * FROM SALES;

------------   NOW LOAD THE DATA INTO TABLE --------------------------

LOAD DATA INFILE  "D:/pw skills/WalmartSalesData.csv" INTO TABLE sales 
FIELDS TERMINATED BY ","
LINES TERMINATED BY "\n"
IGNORE 1 ROWS;

--------- CONFIRM THE DATA IS LOADED ON RIGHT PLACE ------------------

select * from sales;

---------- FEATURE ENGINEERING ---------------------------------------

-- TIME OF THE DAY 

SELECT
	TIME ,
    (CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
		WHEN `time` BETWEEN"12:01:00" AND"16:00:00" THEN "Afternoon"
		ELSE "Evening"    
    END) Time_OF_Day
FROM sales;

ALTER TABLE  sales ADD COLUMN Time_of_day VARCHAR(30) NOT NULL ;

UPDATE sales 
SET time_of_day =(
	CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
		WHEN `time` BETWEEN"12:01:00" AND"16:00:00" THEN "Afternoon"
		ELSE "Evening"    
    END
);

SELECT * FROM SALES;

--- DAY NAME 

SELECT 
	DATE,
    dayname(`DATE`) 
FROM SALES;

ALTER TABLE  sales ADD COLUMN `Day` varchar(15); 

UPDATE sales 
SET DAY = dayname(`Date`) ;

--- MONTH NAME ----

SELECT 
	DATE ,
    monthname(`date`)
FROM sales;

ALTER TABLE  sales ADD COLUMN  Month_Name varchar(15);

UPDATE sales
SET Month_Name = monthname(`Date`);

------------------------------- GENERIC QUESTIONS -----------------------------------

-- How many unique cities does the data have?

SELECT 
	distinct(city) 
FROM sales;

-- In which city is each branch?
SELECT 
	distinct(city) , branch
FROM sales;

-----------------------------  Product based questions -------------------

-- How many unique product lines does the data have?

SELECT 
	distinct(product_line) 
FROM  sales;

-- What is the most common payment method?

SELECT  
	payment , 
    count(payment) count_of_payment 
FROM sales
GROUP BY (payment) 
ORDER BY  2 DESC;

-- What is the most selling product line?

SELECT  
	product_line , 
    count(product_line) Count_OF_SELLING  
FROM sales 
GROUP BY product_line 
ORDER BY 2 DESC;

-- What is the total revenue by month?

SELECT 
	month , 
    sum(total) Total_revenue 
FROM sales
GROUP BY (month)
ORDER BY  2 DESC;

-- What month had the largest COGS?

SELECT 
	month, 
    round(sum(cogs),2) Total_Cogs 
FROM sales 
GROUP BY `month`
ORDER BY Total_Cogs DESC ;

-- What product line had the largest revenue?

SELECT
	product_line , 
    round(sum(total ),2) total_revenue
FROM sales 
GROUP BY 1
ORDER BY total_revenue DESC;

-- What is the city with the largest revenue?

SELECT 
	city , 
    round(sum(total ),2) total_revenue 
FROM sales 
GROUP BY  1
ORDER BY total_revenue DESC;

-- What product line had the largest VAT?

SELECT 
	product_line , 
    avg(tax) Vat
FROM sales
GROUP BY 1
ORDER BY 2 DESC;

-- Which branch sold more products than average product sold?

SELECT 
	branch ,
    sum(quantity) quantity
FROM SALES 
GROUP BY branch 
HAVING QUANTITY > (SELECT avg(quantity) FROM SALES)
ORDER BY 2 DESC;

-- What is the most common product line by gender?
SELECT 
	gender ,
    Product_line,
    count(GENDER)
FROM SALES 
GROUP BY 1,2
ORDER BY 1 DESC;

-- What is the average rating of each product line?

SELECT 
	product_line,
    round(avg(rating),2)avg_rating
FROM sales
GROUP BY  product_line
ORDER BY 2 DESC;

----------------------------- SALES BASED QUESTIONS ------------------------
-- Number of sales made in each time of the day per weekday

SELECT 
	time_of_day,
    count(*) NO_OF_SALES
FROM sales 
GROUP BY 1;

-- Which of the customer types brings the most revenue?
SELECT * FROM SALES;

SELECT 
	customer_type,
    sum(total) Total_revenue
FROM sales 
GROUP BY customer_type;

-- Which city has the largest tax percent/ VAT (Value Added Tax)?
 SELECT 
	 CITY,
     round(avg(tax),2) total_tax
FROM sales 
GROUP BY city
order by 2 desc; 

-- Which customer type pays the most in VAT?
SELECT 
	 CUSTOMER_TYPE,
     avg(tax) total_tax
FROM sales 
GROUP BY 1;

-------------------------------- CUSTOMER BASED QUESTIONS --------------------------

-- How many unique customer types does the data have?
SELECT 
	distinct(customer_type)
FROM sales;

-- How many unique payment methods does the data have?
SELECT 
	distinct(payment)
FROM sales;

-- What is the most common customer type?
SELECT 
	customer_type,
    COUNT(*) total
FROM sales
GROUP BY 1
ORDER BY TOTAL desc;

-- Which customer type buys the most?
SELECT 
	customer_type,
    COUNT(quantity) total
FROM sales
GROUP BY 1
ORDER BY TOTAL desc;

-- What is the gender of most of the customers?
SELECT 
	gender ,
    count(gender)
FROM sales
GROUP BY GENDER
ORDER BY 2 DESC;

-- What is the gender distribution per branch?
SELECT 
	GENDER, 
    BRANCH,
    COUNT(*)
FROM sales 
GROUP BY 1,2
ORDER BY 1;


-- Which time of the day do customers give most ratings?

SELECT 
	time_of_day ,
    avg(rating) total_ratings
FROM sales 
GROUP BY time_of_day;

-- Which time of the day do customers give most ratings per branch?

SELECT 
	time_of_day ,
    branch,
    avg(rating) total_ratings
FROM sales 
GROUP BY time_of_day,2;

-- Which day of the week has the best avg ratings?

SELECT 
	day,
    avg(rating) avg_ratings
FROM SALES
GROUP BY DAY 
ORDER BY 2 desc;

-- Which day of the week has the best average ratings per branch?
SELECT 
	day,
    branch,
    avg(rating) avg_ratings
FROM SALES
GROUP BY 1,2
ORDER BY 2 desc;


