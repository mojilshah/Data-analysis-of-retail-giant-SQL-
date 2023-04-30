/*
In-depth Exploration:
1.	Is there a growing trend on e-commerce in Brazil? How can we describe a complete scenario? 
Can we see some seasonality with peaks at specific months?
2.	What time do Brazilian customers tend to buy (Dawn, Morning, Afternoon or Night)?
*/
with cte_1 as (select order_id, year(order_purchase_timestamp) as year, 
month(order_purchase_timestamp) as month
from dbo.orders where order_status <> 'canceled')
select distinct year,month, count(*) over(partition by year,month) as order_count from cte_1
order by year,month;

with cte_1 as 
(select order_id, year(order_purchase_timestamp) as year, 
month(order_purchase_timestamp) as month,
case when month(order_purchase_timestamp) in (1,2,3) then 1
when month(order_purchase_timestamp) in (4,5,6) then 2
when month(order_purchase_timestamp) in (7,8,9) then 3
when month(order_purchase_timestamp) in (10,11,12) then 4 
end as quarter from dbo.orders where order_status <> 'canceled')
select distinct year, quarter, 
count(*) over(partition by year,quarter) as order_count 
from cte_1 order by year,quarter;


with cte_2 as(select order_id, order_status, 
convert(varchar, order_purchase_timestamp, 108) as time from dbo.orders),
cte_3 as (select *,case 
when time between '04:00:00' and '05:59:59' then 'Dawn'
when time between '06:00:00' and '11:59:59' then 'Morning'
when time between '12:00:00' and '18:00:00' then 'Afternoon'
when time between '18:00:01' and '23:59:59' or time between '00:00:00' and '03:59:59' then 'Night'
end as times_of_the_day from cte_2)
select distinct times_of_the_day, count(*) over(partition by times_of_the_day) as order_count
from cte_3 order by order_count desc;
