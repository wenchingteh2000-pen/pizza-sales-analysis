--Top 5 best selling pizzas (price)
SELECT pizza_name, SUM(total_price) AS total_revenue
FROM Data_Model d 
GROUP BY d.pizza_name 
ORDER BY SUM(d.total_price) DESC
LIMIT 5;

--Top 5 best selling pizzas (quantity)
SELECT pizza_name, SUM(quantity) AS total_quantity_sold
FROM Data_Model d 
GROUP BY d.pizza_name 
ORDER BY SUM(quantity) DESC
LIMIT 5;

--Pizza size with highest revenue
SELECT pizza_size, SUM(total_price) AS total_revenue
FROM Data_Model d 
GROUP BY d.pizza_size 
ORDER BY SUM(d.total_price) DESC
LIMIT 1;

--Average order value per order
SELECT 
  SUM(total_price) AS total_revenue,
  COUNT(DISTINCT order_id) AS total_orders,
  SUM(total_price) * 1.0 / COUNT(DISTINCT order_id) AS average_order_value
FROM Data_Model d;

--To update the date format
UPDATE Data_Model
SET order_date = printf(
  '%04d-%02d-%02d',
  CAST(substr(order_date, instr(order_date, '/') + instr(substr(order_date, instr(order_date, '/') + 1), '/') + 1) AS INTEGER),
  CAST(substr(order_date, 1, instr(order_date, '/') - 1) AS INTEGER),
  CAST(substr(order_date, instr(order_date, '/') + 1, instr(substr(order_date, instr(order_date, '/') + 1), '/') - 1) AS INTEGER)
)
WHERE order_date IS NOT NULL;

--Day of week with most revenue
SELECT 
	CASE STRFTIME('%w', order_date) 
		WHEN '0' THEN 'Sunday'
		WHEN '1' THEN 'Monday' 
		WHEN '2' THEN 'Tuesday'
		WHEN '3' THEN 'Wednesday' 
		WHEN '4' THEN 'Thursday' 
		WHEN '5' THEN 'Friday' 
		WHEN '6' THEN 'Saturday'
	END AS day_of_week, 
	SUM(total_price) AS total_revenue
FROM Data_Model d 
GROUP BY day_of_week 
ORDER BY total_revenue DESC
LIMIT 1;

--Monthly total revenue
SELECT month_name, monthly_revenue
FROM (
	SELECT 
		STRFTIME('%m', order_date) AS month_number,
		CASE STRFTIME('%m', order_date) 
			WHEN '01' THEN 'January'
			WHEN '02' THEN 'February'
			WHEN '03' THEN 'March' 
			WHEN '04' THEN 'April'
			WHEN '05' THEN 'May' 
			WHEN '06' THEN 'June' 
			WHEN '07' THEN 'July' 
			WHEN '08' THEN 'August' 
			WHEN '09' THEN 'September' 
			WHEN '10' THEN 'October'
			WHEN '11' THEN 'November' 
			WHEN '12' THEN 'December' 
		END AS month_name,
		SUM(total_price) AS monthly_revenue
	FROM Data_Model d 
	GROUP BY month_number
	) AS m
ORDER BY m.month_number;

--Revenue trend over time
SELECT STRFTIME('%Y-%m', order_date) AS month, SUM(total_price) AS total_revenue
FROM Data_Model d
GROUP BY month
ORDER BY month;

--Best selling pizza category
SELECT pizza_category, SUM(total_price) AS total_revenue
FROM Data_Model d
GROUP BY pizza_category 
ORDER BY total_revenue DESC
LIMIT 1;

--To update time format
UPDATE Data_Model
SET order_time = printf('%02d:%s', 
                        CAST(substr(order_time, 1, instr(order_time, ':') - 1) AS INTEGER), 
                        substr(order_time, instr(order_time, ':') + 1))
WHERE LENGTH(order_time) < 8;

--Busiest hour of the day
SELECT STRFTIME('%H', order_time) AS time_hour, COUNT(order_id) AS total_order
FROM Data_Model 
GROUP BY time_hour
ORDER BY total_order DESC
LIMIT 1;

--Percentage of total sales per pizza size
SELECT pizza_size, 
ROUND(SUM(total_price) * 100.0 / (SELECT SUM(total_price) FROM Data_Model), 2) AS percentage_of_total_sales
FROM Data_Model d
GROUP BY pizza_size

--Single pizza with the higest total revenue
SELECT pizza_name, SUM(total_price) AS total_revenue 
FROM Data_Model d
GROUP BY pizza_name 
ORDER BY total_revenue DESC
LIMIT 1;
