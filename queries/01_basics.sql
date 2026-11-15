-- 01_basics.sql
-- Database: Umgeni Fresh Produce (SQLite)
-- Topics: SELECT, WHERE, ORDER BY, LIMIT, COUNT, GROUP BY, BETWEEN


-- Q1: What does the products table look like?
SELECT *
FROM products;


-- Q2: List the fruit products and their prices, most expensive first.
SELECT product_name, unit_price
FROM products
WHERE category = 'Fruit'
ORDER BY unit_price DESC;


-- Q3: How many orders were cancelled?
SELECT COUNT(*) AS cancelled_orders
FROM orders
WHERE status = 'Cancelled';


-- Q4: How many customers are there of each customer type?
SELECT customer_type, COUNT(*) AS num_customers
FROM customers
GROUP BY customer_type;


-- Q5: Which customers are based in Durban?
SELECT customer_name, customer_type
FROM customers
WHERE city = 'Durban';


-- Q6: What are the 5 most expensive products?
SELECT product_name, unit_price
FROM products
ORDER BY unit_price DESC
LIMIT 5;


-- Q7: How many orders were placed in March 2025?
SELECT COUNT(*) AS march_2025_orders
FROM orders
WHERE order_date BETWEEN '2025-03-01' AND '2025-03-31';
