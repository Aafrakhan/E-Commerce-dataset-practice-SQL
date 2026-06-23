-- Here are 15 beginner-level questions, framed the way they'd actually come up in a business/interview setting — using your customers, products, and orders tables.
-- Basic SELECT & Filtering

-- List all customers from Mumbai.
SELECT * FROM customers 
Where city = 'Mumbai';

-- Find all products under the "Electronics" category priced above ₹2000.
SELECT * FROM products
WHERE category = 'Electronics' AND price > 2000;

-- Show all orders that were "Cancelled" or "Returned".
SELECT * FROM orders
WHERE order_status = 'Cancelled' OR 'Returned';

SELECT * FROM orders
WHERE order_status IN ('Cancelled', 'Returned');

-- Get the names and emails of all female customers who signed up after January 1, 2026.
SELECT customer_name, email, signup_date FROM customers
WHERE gender = 'Female' AND signup_date > '2026-01-01';

-- Find all orders placed using "UPI" as the payment method.
SELECT * FROM orders
WHERE payment_method = 'UPI';

-- Sorting & Limiting

-- Show the top 5 most expensive products.
SELECT product_name, price FROM products
ORDER BY price DESC
LIMIT 5;

SELECT product_name, category, price FROM products
ORDER BY price DESC
LIMIT 5;

-- List the 10 most recent orders (by order_date).
SELECT order_id, order_date FROM orders
ORDER BY order_date DESC
LIMIT 10;

SELECT products.product_name, orders.order_date
FROM 
products JOIN orders ON products.product_id = orders.product_id
ORDER BY orders.order_date DESC
LIMIT 10;

SELECT customers.customer_name, products.product_name, products.price, total_amount, quantity, order_status, orders.order_date
FROM 
customers 
JOIN orders ON customers.customer_id = orders.customer_id
JOIN products ON products.product_id = orders.product_id
ORDER BY orders.order_date DESC
LIMIT 10;

-- Aggregations

-- What is the total revenue generated from all "Delivered" orders?
SELECT SUM(total_amount) AS Total_revenue
FROM orders;

SELECT SUM(total_amount) AS delivered_Total_revenue
FROM orders
WHERE order_status = 'Delivered';

SELECT order_status, SUM(total_amount) AS delivered_Total_revenue
FROM orders
WHERE order_status = 'Delivered'
GROUP BY order_status;

SELECT order_status, ROUND(SUM(total_amount)) AS delivered_Total_revenue
FROM orders
WHERE order_status = 'Delivered'
GROUP BY order_status;

-- How many orders has each payment method been used for? (Group by payment_method)
SELECT payment_method, COUNT(*) AS total_orders
FROM orders
GROUP BY payment_method
ORDER BY total_orders DESC;

SELECT payment_method, COUNT(order_id) as no_of_order_id
FROM orders
GROUP BY payment_method;

SELECT payment_method, COUNT(order_id) as no_of_order_id
FROM orders
GROUP BY payment_method
ORDER BY no_of_order_id DESC;

-- What is the average order value (total_amount) across all orders?
SELECT AVG(total_amount) AS Avg_order_value
FROM 
orders;

SELECT ROUND(AVG(total_amount)) AS Avg_order_value
FROM 
orders;

-- Which category has the highest total stock_quantity?
SELECT category, SUM(stock_quantity) AS total_stock
FROM products
GROUP BY category
ORDER BY total_stock DESC
LIMIT 1;

-- Joins (the classic interview test)

-- Show the customer name along with the product name for every order they placed.
SELECT customers.customer_name, products.product_name, orders.quantity, orders.order_date
FROM 
orders
JOIN customers ON customers.customer_id = orders.customer_id
JOIN products ON products.product_id = orders.product_id;

SELECT c.customer_name, p.product_name, o.quantity, o.order_date, order_id
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN products p ON o.product_id = p.product_id
ORDER BY order_id;

-- Find the total amount spent by each customer (join orders with customers, group by customer).
SELECT c.customer_name, SUM(o.total_amount) AS total_spent
FROM
orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_name
ORDER BY total_spent;

SELECT c.customer_name, SUM(o.total_amount) AS total_spent
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_spent DESC;

-- List all products that have never been ordered (hint: this needs a LEFT JOIN or NOT IN).
SELECT p.product_id, p.product_name
FROM products p
LEFT JOIN orders o ON p.product_id = o.product_id
WHERE o.order_id IS NULL;

-- Business-style "real" questions

-- Which city has generated the highest total order revenue? (Join customers + orders, group by city)
SELECT c.city, SUM(o.total_amount) AS total_order_revenue
FROM 
orders o
JOIN customers c ON c.customer_id = o.customer_id
GROUP BY c.city
LIMIT 5;

SELECT c.city, SUM(o.total_amount) AS total_revenue
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.city
ORDER BY total_revenue DESC
LIMIT 1;
