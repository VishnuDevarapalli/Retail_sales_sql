select * from retail_sales;
SELECT transactions_id FROM retail_sales;

select *,row_number()over(partition by transactions_id,sale_date,sale_time,customer_id,gender,age,category,quantiy,price_per_unit,cogs,total_sale) as row_num
from retail_sales;

with duplicate_cte as(
select *,row_number()over(partition by transactions_id,sale_date,sale_time,customer_id,gender,age,category,quantiy,price_per_unit,cogs,total_sale) as row_num
from retail_sales
)
select * from duplicate_cte 
where row_num>1;
select * from retail_sales
where transactions_id is null or sale_date is null or sale_time is null or customer_id is null or gender is null or age is null or category is null or quantiy is null or price_per_unit is null or cogs is null or total_sale is null;
select sale_date from retail_sales;
select sale_date, STR_TO_DATE(sale_date,'%Y-%m-%d') as date from retail_sales;

update retail_sales
set sale_date=STR_TO_DATE(sale_date,'%Y-%m-%d');

alter table retail_sales
modify column sale_date date;
select sale_time, STR_TO_DATE(sale_time,'%H:%i:%s')as time from retail_sales;
update retail_sales
set sale_time=STR_TO_DATE(sale_time,'%H:%i:%s');
alter table retail_sales
modify column sale_time time;

select count( *) from retail_sales;

select count(distinct customer_id) from retail_sales;
select * from retail_sales
where sale_date='2022-11-05';

select category,sum(total_sale) from retail_sales
group by category;


select * from retail_sales
where category='clothing'and MONTH(sale_date)=11 and YEAR(sale_date)=2022 and quantiy>=4;

select category,avg(age) from retail_sales
where category='beauty';

select * from retail_sales
where total_sale>1000;

select category,gender,count(transactions_id) from retail_sales
group by category,gender
order by 1;

select YEAR(sale_date) as sale_year,MONTH(sale_date) as sale_month ,avg(total_sale) as avg_sale from retail_sales
group by YEAR(sale_date),MONTH(sale_date)
order by 1;

with monthly_avg as (
select YEAR(sale_date) as sale_year,MONTH(sale_date) as sale_month ,avg(total_sale) as avg_sale from retail_sales
group by YEAR(sale_date),MONTH(sale_date)
),ranked_month as
(
select *,rank()over(partition by sale_year order by avg_sale DESC) as top_avg_sale_rank
from monthly_avg
)
select sale_year,sale_month,avg_sale ,top_avg_sale_rank from ranked_month
where top_avg_sale_rank=1;

select customer_id,sum(total_sale) from retail_sales
group by customer_id
order by 2 desc
 limit 5;
 
 WITH maxsale_cte as(
 select customer_id,sum(total_sale) as high_total from retail_sales
group by customer_id
order by 2 DESC
),ranked_customer as(
select *,rank()over( order by high_total DESC) as customer_rank
from maxsale_cte
)
select customer_id,high_total,customer_rank from ranked_customer
LIMIT 5;

SELECT count(distinct customer_id),category from retail_sales
group by category
;
select transactions_id,sale_time,
case 
	when HOUR(sale_time)<12 then 'morning shift'
    when HOUR(sale_time) between 12 and 17 then 'afternoon shift'
    when HOUR(sale_time) between 17 and 00 then 'evening shift'
end as shift
from retail_sales
;

with hourly_sale as(
select transactions_id,sale_time,
case 
	when HOUR(sale_time)<12 then 'morning shift'
    when HOUR(sale_time) between 12 and 17 then 'afternoon shift'
    when HOUR(sale_time)>17  then 'evening shift'
end as shift
from retail_sales
)
select shift,count(transactions_id) from hourly_sale
group by shift;


 





































