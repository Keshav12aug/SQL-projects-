-- SELECT * from customers;
-- SELECT * from order_items;
-- SELECT * from orders;
-- SELECT * from products;
-- SELECT * from payments;


-- TOTAL REVENUE 

SELECT SUM(amount) AS total_revenue FROM payments;

-- revenue of product  


SELECT p.product_name, SUM(oi.quantity * p.price) AS revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_status = "Delivered"
GROUP BY p.product_name
ORDER BY revenue DESC;


-- top spending customers 

SELECT c.name,
		SUM(p.amount) AS total_spent
FROM customers c 
JOIN orders o ON c.customer_id = o.customer_id
JOIN payments p ON o.order_id = p.order_id
GROUP BY c.name
order by total_spent DESC;

-- BEST SELLING PRODUCTS 

SELECT p.product_name, 
      SUM(oi.quantity) AS total_sold
FROM order_items oi
JOIN products p on oi.product_id = p.product_id
GROUP BY product_name
ORDER BY total_sold DESC;


-- CANCELLED ORDER COUNT 

SELECT COUNT(*) AS cancelled_orders
FROM orders
WHERE order_status = 'Cancelled';


	        



