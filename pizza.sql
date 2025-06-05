use pizza;
CREATE TABLE updated_pizza_sales (
    order_details_id INT,
    order_id INT,
    pizza_id VARCHAR(50),
    quantity INT,
    order_date VARCHAR(20),         -- <- changed from DATE
    order_time TIME,
    unit_price DECIMAL(10,2),
    total_price DECIMAL(10,2),
    pizza_size VARCHAR(5),
    pizza_category VARCHAR(50),
    pizza_ingredients TEXT,
    pizza_name VARCHAR(100),
    Day INT,
    Month INT,
    Year INT,
    formatted_date VARCHAR(20)      -- <- changed from DATE
);
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Updated_Pizza_Sales.csv'
INTO TABLE updated_pizza_sales
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(order_details_id, order_id, pizza_id, quantity, order_date, order_time, unit_price, total_price, pizza_size, pizza_category, pizza_ingredients, pizza_name, Day, Month, Year, formatted_date);

ALTER TABLE updated_pizza_sales
ADD COLUMN order_date_parsed DATE,
ADD COLUMN formatted_date_parsed DATE;

UPDATE updated_pizza_sales
SET 
    order_date_parsed = STR_TO_DATE(order_date, '%d-%m-%Y'),
    formatted_date_parsed = STR_TO_DATE(formatted_date, '%d-%m-%Y');

select * from updated_pizza_sales;

 -- 1. What are the top 5 busiest days based on total orders?
SELECT 
    formatted_date, COUNT(DISTINCT order_id) AS total_orders
FROM
    updated_pizza_sales
GROUP BY formatted_date
ORDER BY total_orders DESC
LIMIT 5;


 -- 2. How many pizzas are we making during peak periods?
SELECT 
    HOUR(order_time) AS hour, SUM(quantity) AS total_pizzas
FROM
    updated_pizza_sales
GROUP BY hour
ORDER BY total_pizzas DESC;

 --  3. What are our 5 best and worst-selling pizzas?
SELECT 
    pizza_name, SUM(quantity) AS total_sold
FROM
    updated_pizza_sales
GROUP BY pizza_name
ORDER BY total_sold DESC
LIMIT 5; -- best pizzas

 SELECT 
    pizza_name, SUM(quantity) AS total_sold
FROM
    updated_pizza_sales
GROUP BY pizza_name
ORDER BY total_sold ASC
LIMIT 5;  --  worst pizzas

--  4. What's our average order value?
SELECT 
    ROUND(SUM(total_price) / COUNT(DISTINCT order_id),
            2) AS average_order_value
FROM
    pizza_sales;
--  5. What is the busiest hour of the day for orders?
SELECT 
    HOUR(order_time) AS hour_of_day,
    COUNT(DISTINCT order_id) AS total_orders
FROM
    pizza_sales
GROUP BY hour_of_day
ORDER BY total_orders DESC
LIMIT 5;


