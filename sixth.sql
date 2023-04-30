-- 1.	Month over Month count of orders for different payment types

select * from (select p.order_id, payment_type, month(order_purchase_timestamp) as Month,
year(order_purchase_timestamp)as Year from payments p
join orders o on p.order_id=o.order_id
where payment_value <> 0 and year(order_purchase_timestamp) ='2017'
or (month(order_purchase_timestamp) not in('10','9') and year(order_purchase_timestamp) = '2018'))t
PIVOT (count(order_id) for payment_type in ([credit_card],[debit_card],[UPI],[voucher])) pvt
order by Year,Month;

-- 2.	Count of orders based on the no. of payment installments
select count(order_id) as no_of_orders ,payment_installments from payments
group by payment_installments
order by no_of_orders desc;