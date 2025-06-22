-- order details

with cte_orders as(
select
	product_name
    ,order_yearmonth
    ,sum(order_quantity) total_order
from orders_and_shipments
group by product_name
	,order_yearmonth)

-- inventory details

, cte_inventory as(
select
	product_name
    ,yearmonth
    ,sum(warehouse_inventory) as total_inventory
from inventory
group by product_name
	,yearmonth)
   
select o.product_name
	,o.order_yearmonth
    ,case
		when right(o.order_yearmonth,2) in ('01','02','03') then 'Q1'
        when right(o.order_yearmonth,2) in ('04','05','06') then 'Q2'
        when right(o.order_yearmonth,2) in ('07','08','09') then 'Q3'
        when right(o.order_yearmonth,2) in ('10','11','12') then 'Q4'
	end as quarter
    ,o.total_order
    ,i.total_inventory
    ,(o.total_order-i.total_inventory) as stock_difference
    ,case
		WHEN i.total_inventory < o.total_order * 0.80 THEN 'Under Stock'
        WHEN i.total_inventory > o.total_order * 1.20 THEN 'Over Stock'
        ELSE 'Balanced'
	end as stock_status
from cte_orders o
left join cte_inventory i
on o.product_name = i.product_name
and o.order_yearmonth = i.yearmonth