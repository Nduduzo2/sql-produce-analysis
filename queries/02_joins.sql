-- 02_joins.sql
-- Database: Umgeni Fresh Produce (SQLite)
-- Topics: INNER JOIN, joining 3-4 tables, SUM, ROUND, GROUP BY, LEFT JOIN, IS NULL


-- Q1: Show each order with the name of the customer who placed it.
SELECT o.order_id, c.customer_name, o.order_date
FROM orders AS o
JOIN customers AS c ON o.customer_id = c.customer_id
LIMIT 10;


-- Q2: Calculate the line total (quantity x unit price) for each order item.
SELECT o.order_id, p.product_name, oi.quantity, p.unit_price,
       oi.quantity * p.unit_price AS line_total
FROM order_items AS oi
JOIN orders AS o ON oi.order_id = o.order_id
JOIN products AS p ON oi.product_id = p.product_id
LIMIT 10;


-- Q3: What is the total revenue from delivered orders?
-- Cancelled orders are excluded because that money was never earned.
SELECT ROUND(SUM(oi.quantity * p.unit_price), 2) AS total_revenue
FROM order_items AS oi
JOIN orders AS o ON oi.order_id = o.order_id
JOIN products AS p ON oi.product_id = p.product_id
WHERE o.status = 'Delivered';


-- Q4: Which product categories bring in the most revenue?
SELECT p.category,
       ROUND(SUM(oi.quantity * p.unit_price), 2) AS revenue
FROM order_items AS oi
JOIN orders AS o ON oi.order_id = o.order_id
JOIN products AS p ON oi.product_id = p.product_id
WHERE o.status = 'Delivered'
GROUP BY p.category
ORDER BY revenue DESC;


-- Q5: Who are the top 5 customers by revenue (delivered orders only)?
SELECT c.customer_name,
       ROUND(SUM(oi.quantity * p.unit_price), 2) AS revenue
FROM order_items AS oi
JOIN products AS p ON oi.product_id = p.product_id
JOIN orders AS o ON oi.order_id = o.order_id
JOIN customers AS c ON o.customer_id = c.customer_id
WHERE o.status = 'Delivered'
GROUP BY c.customer_name
ORDER BY revenue DESC
LIMIT 5;


-- Q6: How much revenue does each farm generate (delivered orders only)?
SELECT f.farm_name,
       ROUND(SUM(oi.quantity * p.unit_price), 2) AS revenue
FROM order_items AS oi
JOIN products AS p ON oi.product_id = p.product_id
JOIN farms AS f ON p.farm_id = f.farm_id
JOIN orders AS o ON oi.order_id = o.order_id
WHERE o.status = 'Delivered'
GROUP BY f.farm_name
ORDER BY revenue DESC;


-- Q7: Which customers have never placed an order?
-- LEFT JOIN keeps every customer; NULL in the order columns means no match.
SELECT c.customer_name, c.customer_type, c.city
FROM customers AS c
LEFT JOIN orders AS o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;
