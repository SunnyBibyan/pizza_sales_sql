


# Pizza Hut Database and Analytics Queries

This project demonstrates how to design and query a relational database for managing and analyzing pizza sales data. It includes table creation scripts, sample queries for retrieving insights, and SQL techniques for business analytics.

---

## Table of Contents
- [Overview](#overview)
- [Database Structure](#database-structure)
- [Features](#features)
- [SQL Queries](#sql-queries)
- [Usage](#usage)
- [Future Enhancements](#future-enhancements)
- [Contributing](#contributing)


---

## Overview
This project is designed to manage and analyze data related to pizza orders. By using SQL, you can perform business analytics, calculate key performance indicators (KPIs), and generate insights about sales, customer preferences, and revenue distribution.

---

## Database Structure
The database consists of four tables:

### 1. `orders`
Tracks information about customer orders.
```sql
CREATE TABLE orders (
    order_id INT NOT NULL,
    order_date DATE NOT NULL,
    order_time TIME NOT NULL,
    PRIMARY KEY (order_id)
);
```

### 2. `order_details`
Tracks details of items in each order.
```sql
CREATE TABLE order_details (
    order_details_id INT NOT NULL,
    order_id INT NOT NULL,
    pizza_id TEXT NOT NULL,
    quantity INT NOT NULL,
    PRIMARY KEY (order_details_id)
);
```

### 3. `pizzas`
Stores information about individual pizzas.
```sql
CREATE TABLE pizzas (
    pizza_id TEXT NOT NULL,
    pizza_type_id INT NOT NULL,
    size TEXT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (pizza_id)
);
```

### 4. `pizza_types`
Stores categories and types of pizzas.
```sql
CREATE TABLE pizza_types (
    pizza_type_id INT NOT NULL,
    name TEXT NOT NULL,
    category TEXT NOT NULL,
    PRIMARY KEY (pizza_type_id)
);
```

---

## Features
The project includes:
1. Database setup scripts for creating tables and inserting data.
2. Analytical queries to:
   - Retrieve total orders placed.
   - Calculate total revenue from sales.
   - Identify top-performing pizzas and sizes.
   - Analyze order patterns (e.g., hourly, daily, by category).
3. Advanced SQL techniques like `JOIN`, `GROUP BY`, window functions, and aggregate functions for meaningful insights.

---

## SQL Queries
Some key queries included in this project are:

1. **Total Orders Placed**  
   ```sql
   SELECT COUNT(order_id) AS total_orders FROM orders;
   ```

2. **Total Revenue Generated**  
   ```sql
   SELECT 
       ROUND(SUM(od.quantity * p.price), 2) AS total_revenue
   FROM
       order_details od
   JOIN
       pizzas p ON od.pizza_id = p.pizza_id;
   ```

3. **Top 5 Most Ordered Pizza Types**  
   ```sql
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
   ```

4. **Cumulative Revenue Over Time**  
   ```sql
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
   ```

The full list of queries can be found in the [`queries.sql`](./queries.sql) file.

---

## Usage
To use this project:
1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/pizza_sales_sql.git
   cd pizza_sales_sql
   ```
2. Set up the database using your preferred SQL client (e.g., MySQL, PostgreSQL).
3. Execute the `create_tables.sql` script to create the database and tables.
4. Use the queries in `queries.sql` to generate insights.

---

## Future Enhancements
Potential improvements include:
- Adding data for customers and delivery details.
- Incorporating a dashboard using Python and a library like **Streamlit** or **Dash** for visualizing insights.
- Automating daily revenue and order reports.
- Integrating with a backend for dynamic data entry.

---


