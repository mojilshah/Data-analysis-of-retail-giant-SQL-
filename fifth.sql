-- 5. Analysis on sales, freight and delivery time
--Calculate days between purchasing, delivering and estimated delivery
--Find time_to_delivery & diff_estimated_delivery. Formula for the same given below:
--time_to_delivery = order_purchase_timestamp-order_delivered_customer_date
--diff_estimated_delivery = order_estimated_delivery_date-order_delivered_customer_date
--Group data by state, take mean of freight_value, time_to_delivery, diff_estimated_delivery
--Sort the data to get the following:
--Top 5 states with highest/lowest average freight value - sort in desc/asc limit 5
--Top 5 states with highest/lowest average time to delivery
--Top 5 states where delivery is really fast/ not so fast compared to estimated date

with cte_1 as (select o.order_id, customer_state, 
CONVERT(VARCHAR(10), order_purchase_timestamp, 111) as purchase_date, 
CONVERT(VARCHAR(10), order_delivered_customer_date, 111) as delivered_date, 
CONVERT(VARCHAR(10), order_estimated_delivery_date, 111) as estimated_date,
freight_value from orders o
join customers c on o.customer_id = c.customer_id
join order_items oi on o.order_id = oi.order_id
where order_delivered_customer_date is not null)
select top 5 customer_state, avg(freight_value) as mean_freight, 
avg(datediff(day,purchase_date,delivered_date)) as time_to_delivery,
avg(datediff(day,estimated_date,delivered_date)) as diff_estimated_delivery
from cte_1 group by customer_state
order by diff_estimated_delivery;
