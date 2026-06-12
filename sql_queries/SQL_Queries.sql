-- Created Database ONLINE_FOOD_DEL

-- Create tables(cust --> res --> menu --> order --> order_det)

-- Customer Table
CREATE TABLE customers
	(
		customer_id INT PRIMARY KEY,
		customer_name VARCHAR(60),
		email VARCHAR(60),
		city VARCHAR(60),
		signup_date DATE
	);

SELECT * FROM customers;


-- Restaurant Table
CREATE TABLE restaurant
	(
		restaurant_id INT PRIMARY KEY,
		restaurant_name	VARCHAR(60),
		city VARCHAR(60),
		registration_date DATE
	);

SELECT * FROM restaurant;

-- Menu Table
CREATE TABLE menu_item
	(
		item_id	INT PRIMARY KEY,
		restaurant_id INT,
		item_name VARCHAR(60),	
		price DECIMAL(10,2),
CONSTRAINT fk_menu_rest
FOREIGN KEY (restaurant_id)
REFERENCES restaurant(restaurant_id)
);

SELECT * FROM menu_item;




-- Order table
CREATE TABLE orders
	(
		order_id INT PRIMARY KEY,
		customer_id	INT,
		restaurant_id INT,
		order_date DATE,
		
CONSTRAINT fk_cust_order
FOREIGN KEY (customer_id)
REFERENCES customers (customer_id),

CONSTRAINT fk_res_order
FOREIGN KEY (restaurant_id)
REFERENCES restaurant (restaurant_id)
	);

SELECT * FROM orders;


-- Order Details Table
CREATE TABLE order_details
	(
		order_detail_id	INT PRIMARY KEY,
		order_id INT,
		item_id	INT,
		quantity INT,

CONSTRAINT fk_order
FOREIGN KEY (order_id)
REFERENCES orders (order_id),

CONSTRAINT fk_menu_order
FOREIGN KEY (item_id)
REFERENCES menu_item (item_id)
	);

SELECT * FROM order_details;	

-- DAY 2
-- Q1. Find name and price of all food items costing more than 300?
SELECT item_name , price
FROM menu_item
WHERE price > 300;


-- Q2. List top 5 cheapest food items?
SELECT item_name , price
FROM menu_item
ORDER BY price ASC
LIMIT 5;


-- Q3. List all restaurants located in Delhi?
SELECT restaurant_name , city
FROM restaurant
WHERE city = 'Delhi';


-- Q4. Show top 3 most expensive menu items?
SELECT item_name , price
FROM menu_item
ORDER BY price DESC
LIMIT 3;


-- Q5. List order IDs where quantity > 2?
SELECT order_id , quantity
FROM order_details
WHERE quantity > 2;



--DAY 3

-- List all customers along with their city who placed an order on or after '2023-01-01'?
SELECT c.customer_name , c.city , o.order_id, o.order_date
FROM
customers c JOIN orders o
ON c.customer_id = o.customer_id
WHERE order_date >= '2023-01-01'
ORDER BY order_date ASC;


-- Q2. Show restaurant names and order IDs for orders placed from restaurants in Mumbai?
SELECT r.restaurant_name, o.order_id
FROM
restaurant r JOIN orders o
ON r.restaurant_id = o.restaurant_id
WHERE city = 'Mumbai';



--Q3. Customers who have ordered from a specific restaurant- (any name of my choice)?
SELECT c.customer_id,c.customer_name, r.restaurant_name
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN restaurant r
ON o.restaurant_id = r.restaurant_id
WHERE r.restaurant_name = 'Golden Bistro';


-- DAY 4

--Q1. Find the total number of times each food items was ordered?
SELECT m.item_name, SUM(od.quantity) AS total_orders
FROM order_details od
JOIN menu_item m
ON od.item_id = m.item_id
GROUP BY m.item_name;


-- Q2.Calculate the average order value for each customer city?
SELECT  c.city, ROUND(AVG(od.quantity * m.price)) as AVG_order_value
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN order_details od
ON o.order_id = od.order_id
JOIN menu_item m
ON od.item_id = m.item_id
GROUP BY c.city;


-- Q3. Find how many different food items were ordered per restaurant?
SELECT r.restaurant_name, COUNT(DISTINCT m.item_id) AS different_food_items
FROM order_details od
JOIN menu_item m
On od.item_id = m.item_id
JOIN restaurant r
ON m.restaurant_id = r.restaurant_id
GROUP BY r.restaurant_name;



-- Day 5

-- Q1. List customers who placed more than 3 orders?
SELECT c.customer_id, c.customer_name ,COUNT(o.order_id) AS total_orders
FROM customers c 
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id , c.customer_name
HAVING COUNT(o.order_id) > 3;

-- Q2. Display menu items that were ordered more than 2 times?
SELECT m.item_name, COUNT(*) AS times_ordered
FROM menu_item M
JOIN order_details od
ON m.item_id = od.item_id
GROUP BY m.item_name
HAVING COUNT(*) > 2;


-- Q3. Find restaurants with total revenue above 5000?
SELECT r.restaurant_name, SUM(od.quantity * m.price) AS total_revenue
FROM restaurant r
JOIN menu_item m
ON r.restaurant_id = m.restaurant_id
JOIN order_details od
ON m.item_id = od.item_id
GROUP BY r.restaurant_name
HAVING  SUM(od.quantity * m.price) > 5000;


--DAY 6 

-- 1. Show each food item and how much more it costs than the average
SELECT item_name,
       price, (SELECT ROUND(AVG(price)) FROM menu_item) AS avg_price,
       price - (SELECT ROUND(AVG(price)) FROM menu_item) AS difference_from_avg
FROM menu_item;


--2. List food items that cost more than the average price
SELECT item_name,
       price
FROM menu_item
WHERE price > (
    SELECT AVG(price) AS avg_price
    FROM menu_item
);


-- 3. Show customers who haven’t placed any orders?

SELECT customer_id,
       customer_name
FROM customers
WHERE customer_id NOT IN (
    SELECT customer_id
    FROM orders
);



--DAY 7
-- 1. Find total orders City Wise
Select r.city , count(o.order_id) AS total_orders
From orders o
JOIN restaurant r
on o.restaurant_id = r.restaurant_id
group by city
order by total_orders desc;


-- 2. Find Total Revenue Generated By Each Item/Dish
Select m.item_name, sum(m.price * od.quantity) AS total_revenue
From menu_item m
JOin order_details od 
on m.item_id = od.item_id
group by m.item_name
order by total_revenue desc;


--Q3. Top 5 Spending Customers
SELECT c.customer_name,
		SUM(od.quantity * m.price) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_details od ON o.order_id = od.order_id
JOIN menu_item m ON od.item_id = m.item_id
GROUP BY c.customer_name
ORDER BY total_spent DESC
LIMIT 5;

--INSIGHTS
/* 1. Muhammad Patel,Vihaan Nair,Vihaan Patel,Vihaan Patel,Sai Verma these customers can be targeted with loyalty rewards and 
exclusive offers.
2. Retaining these customers can significantly impact overall sales.
*/


-- Q4. Restaurant-wise Order Count

SELECT r.restaurant_name , COUNT(o.order_id) AS total_orders
FROM Restaurant r
JOIN orders o ON r.restaurant_id = o.restaurant_id
GROUP BY r.restaurant_name
ORDER BY total_orders DESC;

--INSIGHTS
/*
1. Golden Garden received the highest number of orders, indicating strong customer demand.
2. Low order restaurants may require promotional campaigns
3. High-demand restaurants should ensure sufficient inventory and delivery capacity.
4. Underperforming restaurants should review menu pricing, ratings, and delivery times.
*/


-- Q5. Average Order value by City
SELECT c.city, ROUND(AVG(od.quantity * m.price)) AS avg_order_value
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_details od ON o.order_id = od.order_id
JOIN menu_item m On od.item_id = m.item_id
GROUP BY c.city
ORDER BY avg_order_value DESC;

-- INSIGHTS
/*
1. Banglore has the highest avg order value, indicating higher customer spending.
2. Customers in high-value cities are more likely to purchase premium menu items.
3. Cities with lower avg order values may be more price-sensitive.
4. Discount campaingns can be more effective in low-spending cities
5. High avg order value cities generate more revenue even with fewer orders.
*/



-- DAY 8

-- Q1. Number of unique customers
SELECT city, COUNT(DISTINCT customer_id) AS unique_customers
FROM customers
GROUP BY city
ORDER BY unique_customers DESC;

--INSIGHTS
/*
1. Ahmedabad has the highest number of unique customers (58), indicating a strong customer base in the region.
2. Kolkata and Chennai follow closely with 56 customers each, demonstrating comparable market penetration.
3. Jaipur has the lowest customer count among the listed cities (39), suggesting potential opportunities for 
targeted customer acquisition campaigns.
4. Cities such as Ahmedabad, Kolkata, Chennai, and Mumbai could be prioritized for loyalty programs and 
retention strategies due to their larger customer populations
*/


-- Q2. Most Frequently ordered Items
SELECT m.item_name, SUM(od.quantity) AS total_orders
FROM menu_item m 
JOIN order_details od
ON m.item_id = od.item_id
GROUP BY m.item_name
ORDER BY total_orders DESC;

--INSIGHTS
/*
1. Momos was the most ordered item with 623 orders.
2. Fish Curry (617) and Aloo Paratha (577) were the next most popular dishes.
3. Vegetarian items such as Paneer Tikka, Paneer Butter Masala, and Dal Tadka showed strong demand.
4. Hakka Noodles and Fried Rice highlighted the popularity of Indo-Chinese cuisine.
5. Desserts like Gulab Jamun (474) and Rasgulla (301) were consistently ordered.
6. Customers showed interest in a variety of cuisines, including North Indian, South Indian, and Indo-Chinese dishes.
7. Kadai Paneer (246) had the lowest orders among the top 20 items but still maintained notable demand.
*/


--Q3. Restaurants with Order Counts(<30)
SELECT r.restaurant_name, COUNT(o.order_id) AS total_orders
FROM restaurant r 
JOIN orders o
ON r.restaurant_id = o.restaurant_id
GROUP BY r.restaurant_name HAVING COUNT(o.order_id) < 30
ORDER BY total_orders;

--INSIGHTS
/*
1. Golden Diner had the fewest orders (14), making it the lowest-performing restaurant followed by
Royal Kitchen with only 19 orders.
2. Happy Kitchen and Flavors Palace each received 22 orders, indicating weak customer demand.
3. Low order volumes may point to issues with marketing, menu appeal, pricing, location, or service quality.
4. Consistently low demand can reduce profitability and operational efficiency.
5. Introduce promotions, discounts, and marketing campaigns to attract more customers.
*/


-- Q4. Find Month Wise Orders
SELECT
    EXTRACT(MONTH FROM order_date) AS month_no,
    TRIM(TO_CHAR(order_date, 'Month')) AS month_name,
    COUNT(order_id) AS total_orders
FROM orders
GROUP BY
    EXTRACT(MONTH FROM order_date),
    TRIM(TO_CHAR(order_date, 'Month'))
ORDER BY month_no;


-- Q5. Fidn the Top 3 Cities by revenue
SELECT
    c.city,
    ROUND(SUM(m.price * od.quantity)) AS total_revenue
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN order_details od
ON o.order_id = od.order_id
JOIN menu_item m 
ON od.item_id = m.item_id
GROUP BY c.city
ORDER BY total_revenue DESC
LIMIT 3;

-- END OF PROJECT