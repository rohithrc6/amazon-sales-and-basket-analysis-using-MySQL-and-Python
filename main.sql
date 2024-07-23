-- Create a table for products

CREATE TABLE IF NOT EXISTS products(
SELECT product_code, MIN(product_name) as product_name
FROM purchases
GROUP BY product_code
);

-- Exploratory Data Analysis --

-- I. Revenue Analysis

-- 1. Revenue by users

SELECT SUM(price_per_unit * quantity) as Revenue, survey_response_id as "User Id"
FROM purchases
GROUP BY survey_response_id
ORDER BY Revenue DESC;

-- 2. Revenue by day

SELECT SUM(price_per_unit * quantity) as Revenue, day as "Day"
FROM purchases
GROUP BY day
ORDER BY Revenue DESC;

-- 3. Revenue by year

SELECT SUM(price_per_unit * quantity) as Revenue, year as "Year"
FROM purchases
GROUP BY year
ORDER BY Revenue DESC;

-- 4. Revenue by month

SELECT SUM(price_per_unit * quantity) as Revenue, month as "Month"
FROM purchases
GROUP BY month
ORDER BY Revenue DESC;

-- 5. Revenue by product

SELECT SUM(pu.price_per_unit * pu.quantity) as Revenue, pu.product_code as `Product Code`, pr.product_name as `Product Name`
FROM purchases pu
LEFT JOIN products pr
ON pu.product_code = pr.product_code
GROUP BY pu.product_code, pr.product_name
ORDER BY Revenue DESC;

-- 6. Revenue by state

SELECT SUM(price_per_unit * quantity) as Revenue, shipping_state as `Shipping State`
FROM purchases
GROUP BY shipping_state
ORDER BY Revenue DESC;

-- 7. Revenue by product category

SELECT SUM(price_per_unit * quantity) as Revenue, product_category as "Product Category"
FROM purchases
GROUP BY product_category
ORDER BY Revenue DESC;

-- 8. Revenue by top 5 products for each month and year

WITH ranked_products AS (
    SELECT 
		SUM(quantity*price_per_unit) as Revenue,
        product_code,
        month_number,
        year,
        ROW_NUMBER() OVER (PARTITION BY year, month_number ORDER BY SUM(quantity*price_per_unit) DESC) AS rn
    FROM purchases
    GROUP BY product_code, month_number, year
)
SELECT
	rp.Revenue,
    rp.product_code AS `Product Code`,
    pr.product_name AS `Product Name`,
    rp.month_number AS Month,
    rp.year AS Year
FROM ranked_products rp
LEFT JOIN products pr
ON pr.product_code = rp.product_code
WHERE rn <= 5
ORDER BY Year, Month, rn ASC;

-- 9. Top 10 days with highest revenue 

SELECT
	order_date AS `Order Date`,
    SUM(price_per_unit * quantity) AS `Revenue`
FROM purchases
GROUP BY order_date
ORDER BY Revenue DESC
LIMIT 10;

-- 10. Average revenue per order

SELECT 
	ROUND(AVG(Revenue), 2) AS `Average Revenue per order`
FROM(
SELECT
	survey_response_id AS `User Id`,
    order_date AS `Order Date`,
	SUM(price_per_unit * quantity) AS `Revenue`
FROM purchases
GROUP BY survey_response_id, order_date
) AS sq;

-- II. Product Analysis by Volume --

-- 1. Sales by product

SELECT SUM(quantity) as Volume, product_name as "Product Name", product_code as "Product Code"
FROM purchases
GROUP BY product_name, product_code
ORDER BY Volume DESC;

-- 2. Sales by product category

SELECT SUM(quantity) as Volume, product_category as "Product Category"
FROM purchases
GROUP BY product_category
ORDER BY Volume DESC;

-- 3. Top 5 product sales for each month and year

WITH ranked_products AS (
    SELECT 
        product_code,
        month_number,
        year,
        SUM(quantity) AS Volume,
        ROW_NUMBER() OVER (PARTITION BY year, month_number ORDER BY SUM(quantity) DESC) AS rn
    FROM purchases
    GROUP BY product_code, month_number, year
)
SELECT
    rp.product_code AS `Product Code`,
    pr.product_name AS `Product Name`,
    rp.Volume,
    rp.month_number AS Month,
    rp.year AS Year
FROM ranked_products rp
LEFT JOIN products pr
ON pr.product_code = rp.product_code
WHERE rn <= 5
ORDER BY Year, Month, rn ASC;

-- 4. Top 5 product categories for each month and year

WITH ranked_product_categories AS (
    SELECT 
        product_category,
        month_number,
        year,
        SUM(quantity) AS Volume,
        ROW_NUMBER() OVER (PARTITION BY year, month_number ORDER BY SUM(quantity) DESC) AS rn
    FROM purchases
    GROUP BY product_category, month_number, year
)
SELECT
    product_category AS `Product Category`,
    Volume,
    month_number AS Month,
    year AS Year
FROM ranked_product_categories
WHERE rn <= 5
ORDER BY Year, Month, rn ASC;

-- 5. Top 5 products for each state

WITH ranked_states AS(
SELECT 
	product_code,
    shipping_state,
    SUM(quantity) AS Volume,
    ROW_NUMBER() OVER (PARTITION BY shipping_state ORDER BY SUM(quantity) DESC) as rn
    FROM purchases
    GROUP BY product_code, shipping_state
)
SELECT
	rs.Volume AS Volume,
    rs.shipping_state as `Shipping State`,
	rs.product_code AS `Product Code`,
    pr.product_name AS `Product Name`
FROM ranked_states rs
LEFT JOIN products pr
ON pr.product_code = rs.product_code
WHERE rn <= 5
ORDER BY `Shipping State`;

-- 6. Top 5 product categories for each state

WITH ranked_product_categories AS (
    SELECT 
        product_category,
        shipping_state,
        SUM(quantity) AS Volume,
        ROW_NUMBER() OVER (PARTITION BY shipping_state ORDER BY SUM(quantity) DESC) AS rn
    FROM purchases
    GROUP BY product_category, shipping_state
)
SELECT
    product_category AS `Product Category`,
    Volume,
    shipping_state as `State`
FROM ranked_product_categories
WHERE rn <= 5
ORDER BY State, rn ASC;

-- 7. Average price of products in each category

SELECT 
	ROUND(AVG(price_per_unit),2) AS `Avg Price`,
    product_category AS `Product Category`
FROM purchases
GROUP BY product_category
ORDER BY `Avg Price` DESC;

-- 8. Top 10 sales by order date

SELECT
	order_date,
    SUM(quantity) AS `Volume`
FROM purchases
GROUP BY order_date
ORDER BY `Volume` DESC
LIMIT 10;

-- 9. Average sales per day

SELECT
	ROUND(AVG(Volume)) AS `Average Volume`
FROM (
SELECT
	order_date,
    SUM(quantity) AS `Volume`
FROM purchases
GROUP BY order_date
ORDER BY `Volume` DESC
) AS sq
;

-- III. Customer Analysis --

-- 1. Top 5 product categories by volume

WITH customer_ranking AS(
SELECT
	product_category,
	survey_response_id,
    SUM(quantity) AS `Volume`,
	ROW_NUMBER() OVER (PARTITION BY survey_response_id ORDER BY SUM(quantity) DESC) AS rn
FROM purchases
GROUP BY product_category, survey_response_id
)
SELECT
	product_category AS `Product Category`,
    survey_response_id AS `User Id`,
    Volume
FROM customer_ranking
WHERE rn <= 5
ORDER BY survey_response_id DESC
;

-- 2. Total customer expenditure for each month

SELECT
	survey_response_id AS `User Id`,
    month AS `Month`,
    SUM(quantity * price_per_unit) AS `Tota Expenses`
FROM purchases
GROUP BY survey_response_id, month
ORDER BY `Tota Expenses` DESC;
;

-- 3. Average customer expenditure per year

SELECT
	survey_response_id AS `User Id`,
    ROUND(AVG(`Total Expenses`), 2) AS `Average Expenses`
FROM(
SELECT
	survey_response_id,
    year AS `Year`,
    SUM(quantity * price_per_unit) AS `Total Expenses`
FROM purchases
GROUP BY year, survey_response_id
) AS sq
GROUP BY survey_response_id
ORDER BY `Average Expenses` DESC
;

-- 4. Top 5 products by volume for each month

WITH product_ranking AS(
SELECT
	product_code,
	survey_response_id,
    SUM(quantity) AS `Volume`,
	ROW_NUMBER() OVER (PARTITION BY survey_response_id ORDER BY SUM(quantity) DESC) AS rn
FROM purchases
GROUP BY product_code, survey_response_id
)
SELECT
	pra.survey_response_id AS `User Id`,
	pro.product_name AS `Product Name`,
    pra.Volume AS `Volume`
FROM product_ranking AS pra
JOIN products pro ON pra.product_code = pro.product_code
WHERE pra.rn <= 5
ORDER BY pra.survey_response_id DESC
;