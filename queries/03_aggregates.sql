-- 03_aggregates.sql
-- Database: Umgeni Fresh Produce (SQLite)
-- Topics: AVG, HAVING, strftime (dates), CASE WHEN


-- Q1: What is the average unit price in each product category?
SELECT category, ROUND(AVG(unit_price), 2) AS avg_price
FROM products
GROUP BY category
ORDER BY avg_price DESC;


-- Q2: Which customers have 10 or more delivered orders?
-- HAVING filters groups after they are calculated, WHERE filters rows before grouping.
SELECT c.customer_name, COUNT(o.order_id) AS num_orders
FROM customers AS c
JOIN orders AS o ON c.customer_id = o.customer_id
WHERE o.status = 'Delivered'
GROUP BY c.customer_name
HAVING COUNT(o.order_id) >= 10
ORDER BY num_orders DESC;


-- Q3: What is the monthly revenue trend (delivered orders only)?
-- strftime turns a date like 2025-03-15 into 2025-03 so we can group by month.
SELECT strftime('%Y-%m', o.order_date) AS month,
       ROUND(SUM(oi.quantity * p.unit_price), 2) AS revenue
FROM order_items AS oi
JOIN orders AS o ON oi.order_id = o.order_id
JOIN products AS p ON oi.product_id = p.product_id
WHERE o.status = 'Delivered'
GROUP BY month
ORDER BY month;


-- Q4: Group products into price bands.
SELECT product_name, unit_price,
       CASE
         WHEN unit_price < 15 THEN 'Budget'
         WHEN unit_price < 30 THEN 'Mid-range'
         ELSE 'Premium'
       END AS price_band
FROM products
ORDER BY unit_price;


-- Q5: What is the average quantity per order item for each customer type?
SELECT c.customer_type,
       ROUND(AVG(oi.quantity), 2) AS avg_quantity
FROM order_items AS oi
JOIN orders AS o ON oi.order_id = o.order_id
JOIN customers AS c ON o.customer_id = c.customer_id
GROUP BY c.customer_type
ORDER BY avg_quantity DESC;


-- Q6: Which product categories have more than R20,000 in revenue (delivered orders)?
SELECT p.category,
       ROUND(SUM(oi.quantity * p.unit_price), 2) AS revenue
FROM order_items AS oi
JOIN orders AS o ON oi.order_id = o.order_id
JOIN products AS p ON oi.product_id = p.product_id
WHERE o.status = 'Delivered'
GROUP BY p.category
HAVING SUM(oi.quantity * p.unit_price) > 20000
ORDER BY revenue DESC;


-- Q7: Label each customer as Frequent or Occasional based on delivered orders.
-- Frequent = 10 or more delivered orders. Customers with no delivered orders do not appear.
SELECT c.customer_name,
       COUNT(o.order_id) AS num_orders,
       CASE
         WHEN COUNT(o.order_id) >= 10 THEN 'Frequent'
         ELSE 'Occasional'
       END AS customer_label
FROM customers AS c
JOIN orders AS o ON c.customer_id = o.customer_id
WHERE o.status = 'Delivered'
GROUP BY c.customer_name
ORDER BY num_orders DESC;
