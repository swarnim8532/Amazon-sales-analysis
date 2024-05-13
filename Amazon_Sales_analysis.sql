-- Amazon_Sales_Analysis Project

-- Q1. Find out the top 5 customers who made the highest profits.

-- We will use ORDER BY DESC to order the result in descending order.
-- We need top 5 customer hence we are using LIMIT 5
-- To get highest profit we will use SUM(sales)
-- To distribute profit amoung customers we have used GROUP BY on customer_id


SELECT 
     customer_id,
	 SUM(sale) AS total_sales
FROM orders
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;


-- Q2. Find out the average quantity ordered per category.

-- To find avg qty we use AVG function
-- We will use GROUP BY on category column

SELECT 
    category,
	AVG(quantity) AS avg_qty
FROM orders
GROUP BY 1;


-- Q3. Identify the top 5 products that have generated the highest revenue.

-- We will use ORDER BY DESC to order the result in descending order.
-- We need top 5 products hence we are using LIMIT 5
-- To get highest revenue we will use SUM(sale)
-- We will use GROUP BY on product_id column


SELECT 
	product_id,
	SUM(sale) AS revenue
FROM orders
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;



-- Q4. Determine the top 5 products whose revenue has decreased compared to the previous year.

-- We will use CTE for calculating last year sale (2022) and current sale (2023)
-- We will JOIN above two CTE's together to get the desired result using INNER JOIN
-- We will use EXTRACT function to extract the year from order_date column
-- For calculating revenue we will use SUM(sale)



WITH last_year_sale
AS
(
    SELECT 
        product_id,
        SUM(sale) as total_sale
    FROM orders
    WHERE order_date BETWEEN '2022-01-01' AND '2022-12-31'   
    -- WHERE EXTRACT(YEAR FROM order_date) = EXTRACT(YEAR FROM CURRENT_DATE) -2   
    GROUP BY product_id
),
current_year_sale
AS
(    
    SELECT 
        product_id,
        SUM(sale) as total_sale
    FROM orders
    WHERE order_date BETWEEN '2023-01-01' AND '2023-12-31'   
    -- WHERE EXTRACT(YEAR FROM order_date) = EXTRACT(YEAR FROM CURRENT_DATE) -2   
    GROUP BY product_id    
)

SELECT 
    ls.product_id as ls_product_id,
    ls.total_sale as last_year_sale,
    -- cs.product_id as cs_product_id,
    cs.total_sale as cs_year_sale,
    ls.total_sale - cs.total_sale  as change_diff
    
FROM last_year_sale as ls
JOIN 
current_year_sale as cs
ON ls.product_id = cs.product_id
WHERE cs.total_sale < ls.total_sale
ORDER BY 4 DESC
LIMIT 5;   


-- Q5. Identify the highest profitable sub-category.

-- To calculate profit we will use SUM(sale)
-- We will use GROUP BY on sub_category column
-- We will use ORDER BY DESC to order the result in descending order.
-- We will use LIMIT 1 to get highest profitable sub-category



SELECT 
     sub_category,
	 SUM(sale) AS profit
FROM orders
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;


-- Q6. Find out the state with the highest total orders.

-- WE will COUNT function to calculate total number of orders.
-- We will use GROUP BY on state column to divide total orders in each state.
-- We will use ORDER BY DESC to order the result in descending order.
-- To get state with the highest total orders we will use LIMIT 1.


SELECT 
     state,
	 COUNT(*) AS total_orders
FROM orders
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;


-- Q7. Determine the month with the highest number of orders.

-- To Extract month from order_date, we will use EXTRACT function.
-- We will use COUNT function to determine the total number of orders.
-- Ues GROUP BY on month column to divide the total number of order in groups based on months.
-- We will use ORDER BY DESC to order the result in descending order.
-- To  get the highest number of orders we will use LIMIT 1.



SELECT
    EXTRACT(MONTH FROM order_date) AS Month,
    COUNT(*) AS Orders
FROM orders
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;


-- Q8. Calculate the profit margin percentage for each sale (Profit divided by Sales)

-- To calculate profit margin percentage we will use ((revenue-COGS)/revenue)*100

    
SELECT 
      product_id,
	  ((price - cogs)/price) * 100 AS profit
FROM products;


-- Q9. Calculate the percentage contribution of each sub-category.
-- To get total sales we will use SUM(sale)
-- To calculate we will divide total sales of each category by SUM of total sales.


SELECT 
    SUM(sale) AS total_sale,
	sub_category,
	(SUM(sale)/(SELECT SUM(sale) FROM orders))*100 AS percentage_contibution
FROM orders
GROUP BY 2



-- Q10. Identify the top 2 categories that have received maximum returns and their return percentage.
-- We will join returns table and order table by using INNER JOIN
-- To get return percentage we will divide count of returns for each category by total count of orders.


SELECT
    o.category,
	COUNT(r.return_id) AS total_returns,
	(COUNT(r.return_id)*100) / (SELECT COUNT(return_id) FROM returns) AS return_percentage
FROM orders AS o
JOIN returns AS r
ON o.order_id = r.order_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 2;
	




-- END OF PROJECT
