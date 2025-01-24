-- Step 1: Create the database and switch to it
CREATE DATABASE pizzhut;
USE pizzhut;

-- Step 2: Create the 'orders' table
CREATE TABLE orders (
    order_id INT NOT NULL,
    order_date DATE NOT NULL,
    order_time TIME NOT NULL,
    PRIMARY KEY (order_id)
);

-- Step 3: Create the 'order_details' table
CREATE TABLE order_details (
    order_details_id INT NOT NULL,
    order_id INT NOT NULL,
    pizza_id TEXT NOT NULL,
    quantity INT NOT NULL,
    PRIMARY KEY (order_details_id)
);

-- Query 1: Retrieve the total number of orders placed
SELECT COUNT(order_id) AS total_orders 
FROM orders;

-- Query 2: Calculate the total revenue generated from pizza sales
SELECT 
    ROUND(SUM(od.quantity * p.price), 2) AS total_revenue
FROM
    order_details od
JOIN
    pizzas p ON od.pizza_id = p.pizza_id;

-- Query 3: Identify the highest-priced pizza
SELECT 
    pizza_types.name, 
    pizzas.price
FROM
    pizza_types
JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY 
    pizzas.price DESC
LIMIT 1;

-- Query 4: Identify the most common pizza size ordered
SELECT 
    pizzas.size,
    COUNT(order_details.order_details_id) AS order_count
FROM
    pizzas
JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY 
    pizzas.size
ORDER BY 
    order_count DESC
LIMIT 1;

-- Query 5: List the top 5 most ordered pizza types along with their quantities
SELECT 
    pizza_types.name, 
    SUM(order_details.quantity) AS quantity
FROM
    pizza_types
JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY 
    pizza_types.name
ORDER BY 
    quantity DESC
LIMIT 5;

-- Query 6: Find the category-wise distribution of pizzas
SELECT 
    category, 
    COUNT(name) AS count
FROM
    pizza_types
GROUP BY 
    category;

-- Query 7: Group the orders by date and calculate the average number of pizzas ordered per day
SELECT 
    ROUND(AVG(quantity), 0) AS avg_pizzas_per_day
FROM (
    SELECT 
        orders.order_date AS date,
        SUM(order_details.quantity) AS quantity
    FROM
        orders
    JOIN 
        order_details ON orders.order_id = order_details.order_id
    GROUP BY 
        orders.order_date
) AS order_qty;

-- Query 8: Determine the distribution of orders by hour of the day
SELECT 
    HOUR(order_time) AS hour, 
    COUNT(order_id) AS order_count
FROM
    orders
GROUP BY 
    HOUR(order_time);

-- Query 9: Find the total quantity of each pizza category ordered
SELECT 
    pizza_types.category,
    SUM(order_details.quantity) AS total_quantity
FROM
    pizza_types
JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY 
    pizza_types.category
ORDER BY 
    total_quantity DESC;

-- Query 10: Determine the top 3 most ordered pizza types based on revenue
SELECT 
    pizza_types.name, 
    SUM(order_details.quantity * pizzas.price) AS total_revenue
FROM
    pizza_types
JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY 
    pizza_types.name
ORDER BY 
    total_revenue DESC
LIMIT 3;

-- Query 11: Calculate the percentage contribution of each pizza type to total revenue
SELECT 
    pizza_types.name,
    (SUM(order_details.quantity * pizzas.price) / 
        (SELECT SUM(order_details.quantity * pizzas.price)
         FROM order_details
         JOIN pizzas ON order_details.pizza_id = pizzas.pizza_id)) * 100 AS revenue_percentage
FROM
    pizza_types
JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY 
    pizza_types.name
ORDER BY 
    revenue_percentage DESC;

-- Query 12: Analyze the cumulative revenue generated over time
SELECT 
    orders.order_date,
    SUM(SUM(order_details.quantity * pizzas.price)) 
        OVER (ORDER BY orders.order_date) AS cumulative_revenue
FROM
    orders 
JOIN 
    order_details ON orders.order_id = order_details.order_id
JOIN 
    pizzas ON order_details.pizza_id = pizzas.pizza_id
GROUP BY 
    orders.order_date
ORDER BY 
    orders.order_date;
