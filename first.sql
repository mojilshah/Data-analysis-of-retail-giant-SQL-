with cte_1 as 
(select min(order_purchase_timestamp) as first_date, 
max(order_purchase_timestamp) as last_date 
from dbo.orders)
select concat(year(first_date),'/',month(first_date),'/',day(first_date)) as start_of_time_period, 
concat(year(last_date),'/',month(last_date),'/', day(last_date)) as end_of_time_period
from cte_1;

select distinct customer_city from dbo.customers;

select distinct customer_state from dbo.customers;

select count(*) as total_states from (select distinct customer_state from dbo.customers) t;

select count(*) as total_cities from (select distinct customer_city from dbo.customers) t;