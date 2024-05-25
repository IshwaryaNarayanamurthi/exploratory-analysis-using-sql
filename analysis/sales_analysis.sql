CREATE TABLE customer_information (
 customer_id INT PRIMARY KEY,
 customer_name VARCHAR(255),
 location VARCHAR(255)
);
CREATE TABLE date details (
date DATE,
year INT,
month INT,
day INT,
weekday varchar(45),
quarter  varchar(45)
);
CREATE TABLE product_details (
  product_id INT PRIMARY KEY,
  product_name VARCHAR(255),
  category VARCHAR(255)
);
CREATE TABLE sales_analysis (
transaction_id INT PRIMARY KEY,
product_id INT,
customer_id INT,
quantity INT,
price INT,
date DATE,
total_amount INT,
CONSTRAINT fk_product_id FOREIGN KEY (product_id) REFERENCES product_details(product_id),
CONSTRAINT fk_customer_id FOREIGN KEY (customer_id) REFERENCES customer_information(customer_id)
);
-- Assuming the secure file directory is /var/lib/mysql-files
change path based on your secure file directory

LOAD DATA INFILE '/var/lib/mysql-files/sales_analysis.csv'
INTO TABLE sales_analysis
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES;


LOAD DATA INFILE '/var/lib/mysql-files/products_details.csv'
INTO TABLE products_details
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES;


LOAD DATA INFILE '/var/lib/mysql-files/customers_information.csv'
INTO TABLE customers_information
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

1. Aggregate Sales Data
Total Sales:
To calculate total sales, you can sum up the sales amounts.


SELECT SUM(amount) AS total_sales
FROM sales_analysis;

Average Sales:
To calculate the average sales amount.

SELECT AVG(amount) AS average_sales
FROM sales_analysis;

2. Identify Top-Performing Products
Top Products by Sales Amount:
To identify the top-performing products based on sales amount.
SELECT 
    s.product_id,
    p.product_name,
    SUM(s.quantity * s.price) AS total_sales_amount
FROM 
    sales_analysis s
JOIN 
    product_details p
ON 
    s.product_id = p.product_id
GROUP BY 
    s.product_id, p.product_name
ORDER BY 
    total_sales_amount DESC;
Top Products by Quantity Sold:
To identify the top-performing products based on the number of units sold.
SELECT 
    product_id,
    product_name,
    SUM(quantity) AS total_quantity_sold
FROM 
    sales_analysis
JOIN 
    product_information 
ON 
    sales_analysis.product_id = product_information.product_id
GROUP BY 
    product_id, product_name
ORDER BY 
    total_quantity_sold DESC;

3. Analyze Seasonal Effects
Monthly Sales Trends:
To analyze sales trends by month.
SELECT 
    YEAR(date) AS sales_year,
    MONTH(date) AS sales_month,
    SUM(quantity * price) AS total_sales_amount
FROM 
    sales_analysis
GROUP BY 
    sales_year, sales_month
ORDER BY 
    sales_year, sales_month;

Weekly Sales Trends:
SELECT 
    YEAR(date) AS sales_year,
    WEEK(date) AS sales_week,
    SUM(quantity * price) AS total_sales_amount
FROM 
    sales_analysis
GROUP BY 
    sales_year, sales_week
ORDER BY 
    sales_year, sales_week;


Sales Comparison by Year:
To compare sales year over year.
SELECT 
    YEAR(date) AS sales_year,
    SUM(quantity * price) AS total_sales_amount
FROM 
    sales_analysis
GROUP BY 
    sales_year
ORDER BY 
    sales_year;

4. Customer Insights
Top Customers by Sales:
SELECT 
    customer_id,
    customer_name,
    SUM(quantity * price) AS total_sales_amount
FROM 
    sales_analysis
JOIN 
    customer_information 
ON 
    sales_analysis.customer_id = customer_information.customer_id
GROUP BY 
    customer_id, customer_name
ORDER BY 
    total_sales_amount DESC;


5. Joining Data from Different Tables
SELECT 
    s.transaction_id,
    s.date,
    p.product_name,
    c.customer_name,
    s.quantity,
    s.price
FROM 
    sales_analysis s
JOIN 
    product_details p
ON 
    s.product_id = p.product_id
JOIN 
    customer_information c
ON 
    s.customer_id = c.customer_id
ORDER BY 
    s.date;

