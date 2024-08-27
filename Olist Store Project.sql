create database olist_e_Commerce;

use olist_e_Commerce;


													# Olist Store Ecommerce analysis Project | Mysql

	#KPI 1 :Weekday Vs Weekend (order_purchase_timestamp) Payment Statistics
	#KPI 2 :Number of Orders with review score 5 and payment type as credit card.
	#KPI 3 :Average number of days taken for order_delivered_customer_date for pet_shop
	#KPI 4 :Average price and payment values from customers of sao paulo city
	#KPI 5:Relationship between shipping days (order_delivered_customer_date - order_purchase_timestamp) Vs review scores.
 
 
											#KPI 1 :Weekday Vs Weekend (order_purchase_timestamp) Payment Statistics
 
select * from orders;
select * from order_payments; 


ALTER TABLE orders ADD COLUMN order_day_type ENUM('Weekday', 'Weekend');


UPDATE orders
SET order_day_type = 
    CASE 
        WHEN DAYOFWEEK(order_purchase_timestamp) IN (1, 7) THEN 'Weekend'
        ELSE 'Weekday'
    END;
    
    
SELECT 
    order_day_type, 
    COUNT(*) AS number_of_orders, 
    SUM(payment_value) AS total_payment,
    AVG(payment_value) AS avg_payment_value,
    concat((SUM(payment_value) / (SELECT SUM(payment_value) FROM order_payments) * 100), '%') AS payment_percentage
FROM orders
JOIN order_payments ON orders.order_id = order_payments.order_id
GROUP BY order_day_type;


									# KPI 2 :Number of Orders with review score 5 and payment type as credit card.

SELECT count(*) No_of_Orders FROM order_payments op JOIN order_reviews ordr
on op.order_id = ordr.order_id
WHERE op.payment_type ='credit_card'
AND ordr.review_score = 5 ;   

SELECT count(order_id) FROM orders;
SELECT count(order_id) FROM order_payments;

# Method 2 

SELECT COUNT(o.order_id) AS number_of_orders
FROM orders o
JOIN order_reviews r ON o.order_id = r.order_id
JOIN order_payments p ON o.order_id = p.order_id
WHERE r.review_score = 5
  AND p.payment_type = 'credit_card';


									# KPI 3 :Average number of days taken for order_delivered_customer_date for pet_shop
   
SELECT AVG(DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp)) AS average_delivery_days
FROM orders o JOIN order_items oi 
ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE p.product_category_name = 'pet_shop';


									#KPI 4 :Average price and payment values from customers of sao paulo city
                                    
select * from order_items;
select * from order_payments;
select * from orders;
select * from customers;
select * from order_reviews;

select avg(op.payment_value) Average_Payment_Values , avg(oi.price) Average_Price
From order_payments op join order_items oi
on op.order_id = oi.order_id 
join orders o on oi.order_id = o.order_id
join customers c on o.customer_id = c.customer_id
where c.customer_city = 'sao paulo';


						#KPI 5 :Relationship between shipping days (order_delivered_customer_date - order_purchase_timestamp) Vs review scores.


SELECT ore.review_score Review_Score ,AVG(DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp))  average_delivery_days
from orders o join order_reviews ore
on o.order_id = ore.order_id 
group by Review_Score
order by Review_Score;

