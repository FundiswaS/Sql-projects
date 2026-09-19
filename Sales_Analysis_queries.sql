-- Create the sales table
CREATE TABLE sales (
    sales_id INT,
    sales_date DATE,
    product VARCHAR(50),
    customer_name VARCHAR(100),
    region VARCHAR(50),
    quantity INT,
    unit_price DECIMAL(10,2),
    amount DECIMAL(10,2)
);

--Check whether the sales table is created
DESCRIBE sales;

-- Check whether all the data imported correctly
SELECT *
FROM sales;

-- Which product is selling more?
SELECT product, COUNT(*)
FROM sales
GROUP BY product;

-- Given that all the products were sold equally, which product made more revenue?
SELECT product, SUM(amount) AS revenue
FROM sales
GROUP BY product
ORDER BY revenue DESC;

-- Given that the monitor is the product brining in more revenue than the other products, which province bought more monitors?
SELECT region, SUM(amount) AS monitor_revenue
FROM sales
WHERE product = 'Monitor'
GROUP BY region
ORDER BY monitor_revenue DESC;

-- In general, which province brings in more revenue?
SELECT region, SUM(amount) AS total_revenue
FROM sales
GROUP BY region
ORDER BY total_revenue DESC;

-- Which customer bought more than once?
SELECT customer_name, COUNT(*) AS num_of_times_bought
FROM sales
GROUP BY customer_name
HAVING COUNT(*) > 1
ORDER BY num_of_times_bought;