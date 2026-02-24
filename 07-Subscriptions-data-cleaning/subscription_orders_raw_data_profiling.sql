-- data validation and cleanup
select database();

select * from subscription_orders_raw;

select count(order_id_raw) from subscription_orders_raw;
select count(customer_id) from subscription_orders_raw;
select count(signup_ts_raw) from subscription_orders_raw;
select count(order_ts_raw) from subscription_orders_raw;

select SUM(
	CASE WHEN order_id_raw IS NULL OR TRIM(lower(order_id_raw)) IN ('','n/a', '-','null') 
		then 1 
        else 0 end) as order_id_count,
	sum(
    CASE WHEN customer_id IS NULL OR TRIM(LOWER(customer_id)) IN ('', 'n/a','-','null')
		then 1
        else 0 end) as customer_id_count,
    sum(
    CASE WHEN signup_ts_raw IS NULL OR TRIM(LOWER(signup_ts_raw)) IN ('','n/a','-','null')
		then 1
        else 0 end) as signup_ts_count,
    sum(
    CASE WHEN order_ts_raw IS NULL OR TRIM(LOWER(order_ts_raw)) IN ('','n/a','-','null')
		then 1
        else 0 end) as order_ts_count,
    sum(
    CASE WHEN plan_raw IS NULL OR TRIM(LOWER(plan_raw)) IN ('','n/a','-','null')
		then 1
        else 0 end) as plan_count,
	sum(
    CASE WHEN status_raw IS NULL OR TRIM(LOWER(status_raw)) IN ('','n/a','-','null')
		then 1
        else 0 end) as status_count,
	sum(
    CASE WHEN order_amount_raw IS NULL OR TRIM(LOWER(order_amount_raw)) IN ('','n/a','-','null')
		then 1
        else 0 end) as order_amount_count,
    sum(
    CASE WHEN currency_raw IS NULL OR TRIM(LOWER(currency_raw)) IN ('','n/a','-','null')
		then 1
        else 0 end) as currency_count,
    sum(
    CASE WHEN quantity_raw IS NULL OR TRIM(LOWER(quantity_raw)) IN ('','n/a','-','null')
		then 1
        else 0 end) as quantity_count,
    sum(
    CASE WHEN discount_raw IS NULL OR TRIM(LOWER(discount_raw)) IN ('','n/a','-','null')
		then 1
        else 0 end) as discount_count,
    sum(
    CASE WHEN tax_rate_raw IS NULL OR TRIM(LOWER(tax_rate_raw)) IN ('','n/a','-','null')
		then 1
        else 0 end) as tax_rate_count,
    sum(
    CASE WHEN payment_method_raw IS NULL OR TRIM(LOWER(payment_method_raw)) IN ('','n/a','-','null')
		then 1
        else 0 end) as payment_count,
    sum(
    CASE WHEN marketing_channel_raw IS NULL OR TRIM(LOWER(marketing_channel_raw)) IN ('','n/a','-','null')
		then 1
        else 0 end) as marketing_count,
    sum(
    CASE WHEN device_raw IS NULL OR TRIM(LOWER(device_raw)) IN ('','n/a','-','null')
		then 1
        else 0 end) as device_raw_count,
    sum(
    CASE WHEN customer_email_raw IS NULL OR TRIM(LOWER(customer_email_raw)) IN ('','n/a','-','null')
		then 1
        else 0 end) as customer_email_count,
    sum(
    CASE WHEN customer_phone_raw IS NULL OR TRIM(LOWER(customer_phone_raw)) IN ('','n/a','-','null')
		then 1
        else 0 end) as customer_phone_count,
    sum(
    CASE WHEN customer_country_raw IS NULL OR TRIM(LOWER(customer_country_raw)) IN ('','n/a','-','null')
		then 1
        else 0 end) as customer_country_count,
    sum(
    CASE WHEN customer_city_raw IS NULL OR TRIM(LOWER(customer_city_raw)) IN ('','n/a','-','null')
		then 1
        else 0 end) as customer_city_count,
    sum(
    CASE WHEN customer_age_raw IS NULL OR TRIM(LOWER(customer_age_raw)) IN ('','n/a','-','null')
		then 1
        else 0 end) as customer_age_count,
    sum(
    CASE WHEN notes_raw IS NULL OR TRIM(LOWER(notes_raw)) IN ('','n/a','-','null')
		then 1
        else 0 end)as notes_count
from subscription_orders_raw;

select count(*) from subscription_orders_raw;

-- percentage missingness
select round(100*SUM(
	CASE WHEN order_id_raw IS NULL OR TRIM(lower(order_id_raw)) IN ('','n/a', '-','null') 
		then 1 
        else 0 end)/count(*),2) as order_id_pct,
	round(100*sum(
    CASE WHEN customer_id IS NULL OR TRIM(LOWER(customer_id)) IN ('', 'n/a','-','null')
		then 1
        else 0 end)/count(*),2) as customer_id_pct,
    round(100* sum(
    CASE WHEN signup_ts_raw IS NULL OR TRIM(LOWER(signup_ts_raw)) IN ('','n/a','-','null')
		then 1
        else 0 end)/count(*),2) as signup_ts_pct,
    round(100* sum(
    CASE WHEN order_ts_raw IS NULL OR TRIM(LOWER(order_ts_raw)) IN ('','n/a','-','null')
		then 1
        else 0 end)/count(*),2) as order_ts_pct,
    round(100* sum(
    CASE WHEN plan_raw IS NULL OR TRIM(LOWER(plan_raw)) IN ('','n/a','-','null')
		then 1
        else 0 end)/count(*),2) as plan_pct,
	round(100* sum(
    CASE WHEN status_raw IS NULL OR TRIM(LOWER(status_raw)) IN ('','n/a','-','null')
		then 1
        else 0 end)/count(*),2) as status_pct,
	round(100* sum(
    CASE WHEN order_amount_raw IS NULL OR TRIM(LOWER(order_amount_raw)) IN ('','n/a','-','null')
		then 1
        else 0 end)/count(*),2) as order_amount_pct,
    round(100* sum(
    CASE WHEN currency_raw IS NULL OR TRIM(LOWER(currency_raw)) IN ('','n/a','-','null')
		then 1
        else 0 end)/count(*),2) as currency_pct,
    round(100* sum(
    CASE WHEN quantity_raw IS NULL OR TRIM(LOWER(quantity_raw)) IN ('','n/a','-','null')
		then 1
        else 0 end)/count(*),2) as quantity_pct,
    round(100* sum(
    CASE WHEN discount_raw IS NULL OR TRIM(LOWER(discount_raw)) IN ('','n/a','-','null')
		then 1
        else 0 end)/count(*),2) as discount_pct,
    round(100* sum(
    CASE WHEN tax_rate_raw IS NULL OR TRIM(LOWER(tax_rate_raw)) IN ('','n/a','-','null')
		then 1
        else 0 end)/count(*),2) as tax_rate_pct,
    round(100* sum(
    CASE WHEN payment_method_raw IS NULL OR TRIM(LOWER(payment_method_raw)) IN ('','n/a','-','null')
		then 1
        else 0 end)/count(*),2) as payment_pct,
    round(100* sum(
    CASE WHEN marketing_channel_raw IS NULL OR TRIM(LOWER(marketing_channel_raw)) IN ('','n/a','-','null')
		then 1
        else 0 end)/count(*),2) as marketing_pct,
    round(100* sum(
    CASE WHEN device_raw IS NULL OR TRIM(LOWER(device_raw)) IN ('','n/a','-','null')
		then 1
        else 0 end)/count(*),2) as device_raw_pct,
    round(100* sum(
    CASE WHEN customer_email_raw IS NULL OR TRIM(LOWER(customer_email_raw)) IN ('','n/a','-','null')
		then 1
        else 0 end)/count(*),2) as customer_email_pct,
    round(100* sum(
    CASE WHEN customer_phone_raw IS NULL OR TRIM(LOWER(customer_phone_raw)) IN ('','n/a','-','null')
		then 1
        else 0 end)/count(*),2) as customer_phone_pct,
    round(100* sum(
    CASE WHEN customer_country_raw IS NULL OR TRIM(LOWER(customer_country_raw)) IN ('','n/a','-','null')
		then 1
        else 0 end)/count(*),2) as customer_country_pct,
    round(100* sum(
    CASE WHEN customer_city_raw IS NULL OR TRIM(LOWER(customer_city_raw)) IN ('','n/a','-','null')
		then 1
        else 0 end)/count(*),2) as customer_pct,
    round(100*sum(
    CASE WHEN customer_age_raw IS NULL OR TRIM(LOWER(customer_age_raw)) IN ('','n/a','-','null')
		then 1
        else 0 end)/count(*),2) as customer_pct,
    round(100* sum(
    CASE WHEN notes_raw IS NULL OR TRIM(LOWER(notes_raw)) IN ('','n/a','-','null')
		then 1
        else 0 end)/count(*),2) as notes_pct
from subscription_orders_raw;

select distinct plan_raw, count(*) as cnt
from subscription_orders_raw
group by plan_raw
order by cnt desc;
select distinct status_raw, count(*) as cnt
from subscription_orders_raw
group by status_raw
order by cnt desc;
select distinct currency_raw, count(*) as cnt
from subscription_orders_raw
group by currency_raw
order by cnt desc;
select distinct device_raw, count(*) as cnt
from subscription_orders_raw
group by device_raw
order by cnt desc;
select distinct marketing_channel_raw, count(*) as cnt
from subscription_orders_raw
group by marketing_channel_raw
order by cnt desc;
select distinct customer_country_raw, count(*) as cnt
from subscription_orders_raw
group by customer_country_raw
order by cnt desc;

with dups as (
select *, row_number() over(
		partition by order_id_raw,customer_id, signup_ts_raw, order_ts_raw,
        plan_raw, status_raw, order_amount_raw, currency_raw, quantity_raw,
        discount_raw, tax_rate_raw, payment_method_raw, marketing_channel_raw, device_raw,
        customer_email_raw, customer_phone_raw, customer_country_raw,customer_city_raw,
        customer_age_raw,notes_raw) as row_num
from subscription_orders_raw
) 
select * from dups
where row_num > 1;

select lower(trim(order_id_raw)) as order_id_std, count(*) as cnt
from subscription_orders_raw
where order_id_raw is not null AND TRIM(order_id_raw) <> ''
  AND TRIM(LOWER(order_id_raw)) NOT IN ('n/a','-','null')
group by order_id_std
having cnt>1
order by cnt desc;

drop table if exists subscription_orders_staging;

create table subscription_orders_staging as 
select * from subscription_orders_raw;

set SQL_SAFE_UPDATES = 0;
update subscription_orders_staging
set order_id_raw = null
WHERE TRIM(LOWER(order_id_raw)) IN ('','n/a','-','null');

update subscription_orders_staging
set customer_id = null
WHERE TRIM(LOWER(customer_id)) IN ('','n/a','-','null');

update subscription_orders_staging
set signup_ts_raw = null
WHERE TRIM(LOWER(signup_ts_raw)) IN ('','n/a','-','null');

update subscription_orders_staging
set order_ts_raw = null
WHERE TRIM(LOWER(order_ts_raw)) IN ('','n/a','-','null');

update subscription_orders_staging
set plan_raw = null
WHERE TRIM(LOWER(plan_raw)) IN ('','n/a','-','null');

update subscription_orders_staging
set status_raw = null
WHERE TRIM(LOWER(status_raw)) IN ('','n/a','-','null');

update subscription_orders_staging
set order_amount_raw = null
WHERE TRIM(LOWER(order_amount_raw)) IN ('','n/a','-','null');

update subscription_orders_staging
set currency_raw = null
WHERE TRIM(LOWER(currency_raw)) IN ('','n/a','-','null');

update subscription_orders_staging
set quantity_raw = null
WHERE TRIM(LOWER(quantity_raw)) IN ('','n/a','-','null');

update subscription_orders_staging
set discount_raw = null
WHERE TRIM(LOWER(discount_raw)) IN ('','n/a','-','null');

update subscription_orders_staging
set tax_rate_raw = null
WHERE TRIM(LOWER(tax_rate_raw)) IN ('','n/a','-','null');

update subscription_orders_staging
set payment_method_raw = null
WHERE TRIM(LOWER(payment_method_raw)) IN ('','n/a','-','null');

update subscription_orders_staging
set marketing_channel_raw = null
WHERE TRIM(LOWER(marketing_channel_raw)) IN ('','n/a','-','null');

update subscription_orders_staging
set device_raw = null
WHERE TRIM(LOWER(device_raw)) IN ('','n/a','-','null');

update subscription_orders_staging
set customer_email_raw = null
WHERE TRIM(LOWER(customer_email_raw)) IN ('','n/a','-','null');

update subscription_orders_staging
set customer_phone_raw = null
WHERE TRIM(LOWER(customer_phone_raw)) IN ('','n/a','-','null');

update subscription_orders_staging
set customer_country_raw = null
WHERE TRIM(LOWER(customer_country_raw)) IN ('','n/a','-','null');

update subscription_orders_staging
set customer_city_raw = null
WHERE TRIM(LOWER(customer_city_raw)) IN ('','n/a','-','null');

update subscription_orders_staging
set customer_age_raw = null
WHERE TRIM(LOWER(customer_age_raw)) IN ('','n/a','-','null');

update subscription_orders_staging
set notes_raw = null
WHERE TRIM(LOWER(notes_raw)) IN ('','n/a','-','null');

select sum(order_id_raw is null) as null_order_id,
	sum(order_ts_raw is null) as null_order_ts,
    sum(order_amount_raw is null) as null_amount,
    sum(discount_raw is null) as null_discount
from subscription_orders_staging;

DROP TABLE IF EXISTS subscription_orders_clean;

CREATE TABLE subscription_orders_clean AS
SELECT
  UPPER(REPLACE(REPLACE(TRIM(order_id_raw),'-',''),' ','')) AS order_id,

  CASE
    WHEN order_amount_raw IS NULL THEN NULL
    ELSE
      CASE
        WHEN
          -- keep only values that look like a number after stripping symbols/text
          REGEXP_LIKE(
            REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(TRIM(order_amount_raw),
              'R',''),'$',''),'€',''),'GBP',''),'USD',''),',',''),' ', ''),
            '^-?[0-9]+(\\.[0-9]{1,2})?$'
          )
        THEN CAST(
          REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(TRIM(order_amount_raw),
            'R',''),'$',''),'€',''),'GBP',''),'USD',''),',',''),' ', '')
          AS DECIMAL(18,2)
        )
        ELSE NULL
      END
  END AS order_amount,

  CASE
    WHEN quantity_raw IS NULL THEN NULL
    WHEN REGEXP_LIKE(TRIM(quantity_raw), '^-?[0-9]+$') THEN CAST(TRIM(quantity_raw) AS SIGNED)
    ELSE NULL
  END AS quantity

FROM subscription_orders_staging;

select
	count(*) as row_total,
    sum(order_amount is null) as null_amount_after_parse,
    min(order_amount) as min_amount,
    max(order_amount) as max_amount,
    min(quantity) as min_qty,
    max(quantity) as max_qty
from subscription_orders_clean;

with percentiles as (
	select 
		percentile_cont(0.25) within group (order by order_amount) over() as q1,
        percentile_cont(0.75) within group (order by order_amount) over() as q3
	from subscription_orders_clean
    where order_amount is not null
)
select distinct
	q1,
	q3,
    q3 - q1 as IQR,
    (q1-1.5*(q3-q1)) as lower_bound,
    (q1+1.5*(q3-q1)) as upper_bound
from percentiles;

with ranked as (
	select 
		order_amount,
        ntile(4) over ( order by order_amount) as q
	from subscription_orders_clean
    where order_amount is not null
),
q1q3 as (
	select
		max(case when q=1 then order_amount end) as q1,
        max(case when q=3 then order_amount end) as q3
	from ranked
)
select 
	q1,
    q3,
    (q3-q1) as IQR,
    (q1-1.5*(q3-q1)) as lower_bound,
    (q3+1.5*(q3-q1)) as upper_bound
from q1q3;

alter table subscription_orders_clean
	add column is_invalid_amount tinyint default 0,
    add column is_outlier_amount tinyint default 0,
    add column is_invalid_qty tinyint default 0,
    add column is_outlier_qty tinyint default 0;
    
with bounds as (
		with ranked as (
		select 
			order_amount,
			ntile(4) over ( order by order_amount) as q
		from subscription_orders_clean
		where order_amount is not null
	),
	q1q3 as (
		select
			max(case when q=1 then order_amount end) as q1,
			max(case when q=3 then order_amount end) as q3
		from ranked
	)
    select 
		(q1 -1.5*(q3-q1)) as lb,
        (q3+1.5*(q3-q1)) as ub
	from q1q3
)
update subscription_orders_clean as c
join bounds b
set c.is_outlier_amount = 1
where c.order_amount is not null
	and (c.order_amount < b.lb or c.order_amount > b.ub);
        
-- checking impact 
select 
	count(*) as total_rows,
    sum(is_invalid_amount) as invalid_amounts,
    sum(is_outlier_amount) as stat_outliers,
    round(100.00*sum(is_outlier_amount)/count(*),2) as outlier_pct
from subscription_orders_clean;

-- outliers for qty column
with ranked as (
	select 
		quantity,
        NTILE(4) over (order by quantity) as q
	from subscription_orders_clean
    where quantity is not null
),
q1q3 as (
	select
		max(case when q=1 then quantity end) as q1,
        max(case when q=3 then quantity end) as q3
	from ranked
)
select
	q1,
    q3,
    (q3-q1) as IQR,
    (q1-1.5*(q3-q1)) as lower_bound,
    (q3+1.5*(q3-q1)) as upper_bound
from q1q3;

update subscription_orders_clean
set is_invalid_qty = 1
where is_invalid_qty is not null 
	and quantity <= 0;

update subscription_orders_clean
set is_outlier_qty = 1
where quantity is not null
	and quantity > 3;
    
-- checking impact
select 
	count(*) as total_rows,
    sum(is_invalid_qty) as invalid_qty,
    sum(is_outlier_qty) as stat_oulier_qty,
    round(100.00*sum(is_outlier_qty)/count(*),2) as outlier_pct
from subscription_orders_clean;

-- data quality report
create table data_quality_report as
select 
	count(*) as total_rows,
    sum(order_amount is null) as null_amounts,
    sum(is_invalid_amount) as invalid_amounts,
    sum(is_outlier_amount) as stat_outlier_amount,
    sum(is_invalid_qty) as invalid_qty,
    sum(is_outlier_qty) as stat_outlier_qty
from subscription_orders_clean;

select * from data_quality_report;

drop table if exists subscription_orders_dedup;

create table subscription_orders_dedup as
with ranked as (
	select 
		c.*,
        row_number() over (
			partition by order_id
            order by
				(order_amount is not null) desc,
                (quantity is not null) desc
		) as rn
        from subscription_orders_clean as c
        where order_id is not null and trim(order_id) <> ''
)
select *
from ranked
where rn= 1;

drop table if exists subscription_orders_final;
create table subscription_orders_final as
select 
	order_id,
    case
		when order_amount is null then null
        when order_amount < 0 then null
        when order_amount > 2586.57 then 2586.57
        else order_amount
	end as order_amount,
    case
		when quantity is null then null
        when quantity <=0 then null
        when quantity > 3 then 3
        else quantity
	end as quantity
    
from subscription_orders_dedup
where 
	order_amount is not null
    and quantity is not null
    and order_amount >= 0
    and quantity >0;

select count(*) as final_rows,
	min(order_amount) as min_amount,
    max(order_amount) as max_amount,
    min(quantity) as min_qty,
    max(quantity) as max_qty,
    count(distinct order_id) as distinct_orders
from subscription_orders_final;

