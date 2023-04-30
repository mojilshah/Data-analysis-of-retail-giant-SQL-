-- 1.	Get % increase in cost of orders from 2017 to 2018 (include months between Jan to Aug only) - 
--		You can use “payment_value” column in payments table
-- Get month wise average order value of 2017 and 2018
with cte_1 as (select * from (select p.payment_value, year(o.order_purchase_timestamp) as Year, 
month(o.order_purchase_timestamp) as Month from dbo.orders o
join dbo.payments p on o.order_id = p.order_id
where year(o.order_purchase_timestamp) in ('2017','2018') 
and month(o.order_purchase_timestamp) in ('1','2','3','4','5','6','7','8')
)t1
pivot (
avg(payment_value) for Year in ([2017],[2018]))pvt)
select * from cte_1 order by Month;

-- Get average order value in 2017 and 2018
select distinct avg(p.payment_value) over(partition by year(o.order_purchase_timestamp)) as order_value, 
year(o.order_purchase_timestamp) as Year from dbo.orders o
join dbo.payments p on o.order_id = p.order_id
where year(o.order_purchase_timestamp) in ('2017','2018') 
and month(o.order_purchase_timestamp) in ('1','2','3','4','5','6','7','8');

-- Get percent increase in order value from 2017 to 2018
with cte as (select distinct avg(p.payment_value) over(partition by 
year(o.order_purchase_timestamp)) as order_value, 
year(o.order_purchase_timestamp) as Year from dbo.orders o
join dbo.payments p on o.order_id = p.order_id
where year(o.order_purchase_timestamp) in ('2017','2018') 
and month(o.order_purchase_timestamp) in ('1','2','3','4','5','6','7','8')),
cte1 as (select ((order_value - lag(order_value) over(order by Year))/lag(order_value) 
over(order by Year))*100 as percent_increase from cte)
select * from cte1 where percent_increase is not null;
---------------------------------------------------------------------------------------------------------------------------------------------------
--2.	Mean & Sum of price and freight value by customer state

select c.customer_state, avg(oi.price) as mean_price, sum(oi.price) as sum_price, 
avg(oi.freight_value) as mean_freight, sum(oi.freight_value) as sum_freight from customers c
join orders o on c.customer_id = o.customer_id
join order_items oi on o.order_id = oi.order_id
group by c.customer_state
order by customer_state;


