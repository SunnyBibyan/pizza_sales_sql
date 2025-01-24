-- Create the 'pizzhut' database
CREATE DATABASE pizzhut;

-- Use the 'pizzhut' database
USE pizzhut;

-- Create the 'orders' table
CREATE TABLE orders (
    order_id INT NOT NULL,
    order_date DATE NOT NULL,
    order_time TIME NOT NULL,
    PRIMARY KEY (order_id)
);

-- Create the 'order_details' table
CREATE TABLE order_details (
    order_details_id INT NOT NULL,
    order_id INT NOT NULL,
    pizza_id TEXT NOT NULL,
    quantity INT NOT NULL,
    PRIMARY KEY (order_details_id)
);

-- Retrieve the total number of orders placed
SELECT COUNT(order_id) AS total_orders 
FROM orders;

-- Calculate the total revenue generated from pizza sales
SELECT 
    ROUND(SUM(od.quantity * p.price), 2) AS total_revenue
FROM
    order_details od
JOIN
    pizzas p ON od.pizza_id = p.pizza_id;

-- Identify the highest-priced pizza
SELECT 
    pt.name, 
    p.price
FROM
    pizza_types pt
JOIN
    pizzas p ON pt.pizza_type_id = p.pizza_type_id
ORDER BY p.price DESC
LIMIT 1;

-- Identify the most common pizza size ordered
SELECT 
    p.size,
    COUNT(od.order_details_id) AS order_count
FROM
    pizzas p
JOIN
    order_details od ON p.pizza_id = od.pizza_id
GROUP BY p.size
ORDER BY order_count DESC
LIMIT 1;

-- List the top 5 most ordered pizza types along with their quantities
SELECT 
    pt.name, 
    SUM(od.quantity) AS total_quantity
FROM
    pizza_types pt
JOIN
    pizzas p ON pt.pizza_type_id = p.pizza_type_id
JOIN
    order_details od ON od.pizza_id = p.pizza_id
GROUP BY pt.name
ORDER BY total_quantity DESC
LIMIT 5;

-- Find the category-wise distribution of pizzas
SELECT 
    pt.category, 
    COUNT(pt.name) AS total_pizzas
FROM
    pizza_types pt
GROUP BY pt.category;

-- Group the orders by date and calculate the average number of pizzas ordered per day
SELECT 
    ROUND(AVG(total_quantity), 0) AS avg_pizzas_per_day
FROM
    (SELECT 
         o.order_date,
         SUM(od.quantity) AS total_quantity
     FROM
         orders o
     JOIN order_details od ON o.order_id = od.order_id
     GROUP BY o.order_date) daily_orders;

-- Determine the distribution of orders by hour of the day
SELECT 
    HOUR(o.order_time) AS order_hour, 
    COUNT(o.order_id) AS total_orders
FROM
    orders o
GROUP BY HOUR(o.order_time);

-- Find the total quantity of each pizza category ordered
SELECT 
    pt.category,
    SUM(od.quantity) AS total_quantity
FROM
    pizza_types pt
JOIN
    pizzas p ON pt.pizza_type_id = p.pizza_type_id
JOIN
    order_details od ON od.pizza_id = p.pizza_id
GROUP BY pt.category
ORDER BY total_quantity DESC;

-- Determine the top 3 most ordered pizza types based on revenue
SELECT 
    pt.name, 
    SUM(od.quantity * p.price) AS total_revenue
FROM
    pizza_types pt
JOIN
    pizzas p ON pt.pizza_type_id = p.pizza_type_id
JOIN
    order_details od ON od.pizza_id = p.pizza_id
GROUP BY pt.name
ORDER BY total_revenue DESC
LIMIT 3;

-- Calculate the percentage contribution of each pizza type to total revenue
SELECT 
    pt.name,
    (SUM(od.quantity * p.price) / (SELECT SUM(od.quantity * p.price)
                                   FROM order_details od
                                   JOIN pizzas p ON od.pizza_id = p.pizza_id)) * 100 AS revenue_percentage
FROM
    pizza_types pt
JOIN
    pizzas p ON pt.pizza_type_id = p.pizza_type_id
JOIN
    order_details od ON od.pizza_id = p.pizza_id
GROUP BY pt.name
ORDER BY revenue_percentage DESC;

-- Analyze the cumulative revenue generated over time
SELECT 
    o.order_date,
    SUM(SUM(od.quantity * p.price)) OVER (ORDER BY o.order_date) AS cumulative_revenue
FROM
    orders o
JOIN 
    order_details od ON o.order_id = od.order_id
JOIN 
    pizzas p ON od.pizza_id = p.pizza_id
GROUP BY o.order_date
ORDER BY o.order_date;
