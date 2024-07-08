--bai1
SELECT 
count(Distinct user_id) as total_user,
count(Distinct order_id) as total_order, 
FORMAT_DATE('%y-%m', created_at) AS formatted_date
FROM bigquery-public-data.thelook_ecommerce.orders
WHERE 
    DATE(created_at) BETWEEN DATE('2019-01-01') AND DATE('2022-04-30')
GROUP BY formatted_date
--bai2
SELECT 
avg(sale_price) as avg_price,
count(DISTINCT user_id),
FORMAT_DATE('%y-%m', created_at) AS formatted_date
FROM bigquery-public-data.thelook_ecommerce.order_items
WHERE 
    DATE(created_at) BETWEEN DATE('2019-01-01') AND DATE('2022-04-30')
GROUP BY formatted_date
ORDER BY avg_price
--Bai3
--b1:list OUTPUT
SELECT 
    first_name,
    last_name, 
    gender,
    age
FROM 
    bigquery-public-data.thelook_ecommerce.users
WHERE 
    DATE(created_at) BETWEEN DATE('2019-01-01') AND DATE('2022-04-30')
    AND (age = (SELECT MIN(age) 
    FROM bigquery-public-data.thelook_ecommerce.users 
    WHERE DATE(created_at) BETWEEN DATE('2019-01-01') AND DATE('2022-04-30'))
         OR age = (SELECT MAX(age) 
         FROM bigquery-public-data.thelook_ecommerce.users WHERE DATE(created_at) 
         BETWEEN DATE('2019-01-01') AND DATE('2022-04-30')))
ORDER BY 
    gender, age

--b2: 
WITH CTE1 AS (SELECT 
    id,
    first_name,
    last_name, 
    gender,
    age
FROM 
    bigquery-public-data.thelook_ecommerce.users
WHERE 
    DATE(created_at) BETWEEN DATE('2019-01-01') AND DATE('2022-04-30')
    AND (age = (SELECT MIN(age) 
    FROM bigquery-public-data.thelook_ecommerce.users 
    WHERE DATE(created_at) BETWEEN DATE('2019-01-01') AND DATE('2022-04-30'))
         OR age = (SELECT MAX(age) 
         FROM bigquery-public-data.thelook_ecommerce.users WHERE DATE(created_at) 
         BETWEEN DATE('2019-01-01') AND DATE('2022-04-30')))
ORDER BY 
    gender, age)

    SELECT 
    DISTINCT gender,
    age,
    COUNT(id) OVER (PARTITION BY gender ORDER BY age) AS so_luong
FROM 
    CTE1
ORDER BY 
    gender, age;

--Bai4:


WITH CTE1 AS (
SELECT *FROM bigquery-public-data.thelook_ecommerce.order_items AS a
JOIN bigquery-public-data.thelook_ecommerce.products as b 
on a.id=b.id),

CTE2 AS (SELECT 
product_id,
name,
cost,
retail_price,
(retail_price - cost) as profit,
FORMAT_DATE('%y-%m', created_at) AS formatted_date
FROM CTE1)

SELECT *FROM (SELECT
product_id,
name,
cost,
retail_price,
profit,
RANK() OVER(PARTITION BY formatted_date ORDER BY profit DESC) AS stt
FROM CTE2)
WHERE stt<=5
    
    
--bai5 
WITH CTE1 AS (
SELECT *FROM bigquery-public-data.thelook_ecommerce.order_items AS a
JOIN bigquery-public-data.thelook_ecommerce.products as b 
on a.id=b.id)

SELECT 
DISTINCT category, 
FORMAT_DATE('%y-%m-%d',created_at) AS dates, 
SUM(retail_price) OVER(PARTITION BY category) as revenue
FROM CTE1
WHERE 
DATE(created_at) BETWEEN DATE('2022-01-15') AND DATE('2022-04-15')
ORDER BY dates

   

    
    
