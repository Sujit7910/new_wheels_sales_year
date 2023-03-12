
 --    [Q1] What is the distribution of customers across states?
 SELECT * FROM project.customer_t;
 select state, count(customer_id) as count_of_customer from project.customer_t
 GROUP BY state
 order by count_of_customer desc;
 
 -- [Q2] What is the average rating in each quarter?
 
select quarter_number, avg(rating)
from
(
 select *,
 case 
	when customer_feedback = 'Very Bad' then 1 
	when customer_feedback = 'Bad' then 2
	when customer_feedback = 'Okay' then 3
	when customer_feedback = 'Good' then 4
  else '5'
  end as rating
  FROM project.order_t) x
  group by quarter_number
  
-- Q3] Are customers getting more dissatisfied over time?
with cte as (
SELECT customer_feedback, count(*) feedback_count 
FROM project.order_t
GROUP BY customer_feedback
)
select customer_feedback, (feedback_count / 1000) * 100 AS per
from cte
where customer_feedback = 'Very Good'



-- [Q4] What is the count of mode of ship?
SELECT ship_mode , count(*) total_order
FROM project.order_t
group by ship_mode

-- [Q5] What is the most preferred vehicle make in each state?
SELECT vehicle_maker , state, 
rank () over (order by vehicle_maker) as rnk
from
project.order_t o
join project.product_t p
on o.product_id = p.product_id
join project.customer_t c
on c.customer_id = o.customer_id
group by state


-- [Q6] What is the trend of number of orders by quarters?

SELECT quarter_number,  count(product_id) as cnt_of_product
 FROM project.order_t
 group by quarter_number

-- [Q7] Which are the top 5 vehicle makers preferred by the customer.

SELECT vehicle_maker , count(product_id) as top5
FROM project.product_t
group by vehicle_maker
order by top5 desc
limit 5 


-- [Q8] What is the trend of revenue and orders by quarters?

SELECT   quarter_number , count(order_id) as total_orders, 
sum(quantity * car_price) - discount as revenue
  FROM project.order_t
  group by quarter_number
  
 --   [Q9] What is the average discount offered for different types of credit cards?
select c.credit_card_type ,  avg(o.discount) as avg_discount 
FROM project.order_t o 
join project.customer_t c 
on o.customer_id = c.customer_id
group by c.credit_card_type

-- [Q10] What is the average time taken to ship the placed orders for each quarters?
SELECT quarter_number, avg(DATEDIFF(ship_date, order_date)) avg_days_to_ship
FROM project.order_t
GROUP BY quarter_number;