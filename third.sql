/*3.	Evolution of E-commerce orders in the Brazil region:
		1.	Get month on month orders by states
		2.	Distribution of customers across the states in Brazil
*/

with CTE_1 as(select o.order_id, c.customer_id, c.customer_state, 
year(o.order_purchase_timestamp) as year,
month(o.order_purchase_timestamp) as month
from dbo.orders o
join dbo.customers c on o.customer_id = c.customer_id
where o.order_status = 'delivered')
select distinct customer_state, year, month, 
count(*) over(partition by customer_state, year, month) as order_count 
from CTE_1 order by customer_state, year, month;

select customer_state, count(customer_unique_id) as customer_count from dbo.customers
group by customer_state;

select customer_unique_id, count(customer_id) as count_orders from dbo.customers
group by customer_unique_id
order by count_orders desc;

select *, round(cast(customer_count as float)*100/total_customers,2) as percent_of_cust from 
(select *, sum(customer_count) over() as total_customers from 
(select customer_state, count(distinct customer_unique_id) customer_count 
from dbo.customers
group by customer_state) t1) t2
order by customer_count;

/*Trying to get states as columns by using PIVOT*/

select * from (select order_id, c.customer_state, year(o.order_purchase_timestamp) as YEAR, 
month(o.order_purchase_timestamp) as MONTH from dbo.customers c 
join dbo.orders o on c.customer_id = o.customer_id) t
PIVOT (count(order_id) for customer_state in([AC],[AL],[AM],[AP],[BA],[CE],[DF],[ES],[GO],[MA],[MG],[MS],[MT],
[PA],[PB],[PE],[PI],[PR],[RJ],[RN],[RO],[RR],[RS],[SC],[SE],[SP],[TO])) as pvt 
order by pvt.YEAR, pvt.MONTH;