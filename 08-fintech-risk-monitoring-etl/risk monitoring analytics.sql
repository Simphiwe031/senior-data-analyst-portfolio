drop table if exists customers_staging;
create table customers_staging as
select * from customers;

select * from customers_staging;

create table fraud_flags_staging as
select * from fraud_flags;

select * from fraud_flags_staging;

drop table if exists transactions_staging;
create table transactions_staging as 
select * from transactions;

select * from transactions_staging;

-- data profiling checking missingness
with base as (
	select * from customers_staging
),
u as (
	select 'customers_staging' as table_name,
		'customer_id' as column_name,
        customer_id as val from base
	union all select 'customers_staging', 
		'signup_date',
        signup_date from base
	union all select 'customers_staging',
		'country',
        country from base
	union all select 'customers_staging',
		'age',
        age from base
	union all select 'customers_staging',
		'employment_status',
        employment_status from base
	union all select 'customers_staging',
		'plan_type',
        plan_type from base
	union all select 'customers_staging',
		'risk_segment',
        risk_segment from base
) 
select 
	table_name,
    column_name,
    sum(case when val is null or lower(trim(val)) in ('','-','null','n/a','missing') then 1 else 0 end) as count_missing
from u
group by table_name, column_name
order by count_missing desc;

with base as (
	select * from fraud_flags_staging
),
u as (
	select
		'fraud_flags' as table_name,
		'transaction_id' as column_name,
        transaction_id as val
        from base
	union all select 
		'fraud_flags',
        'fraud_flag',
        fraud_flag from base
)
select 
	table_name,
    column_name,
    sum(case when val is null or lower(trim(val)) in ('','-','null','n/a','missing') then 1 else 0 end) as count_missing
from u
group by table_name, column_name
order by count_missing desc;

with base as (
	select * from transactions_staging
),
u as (
	select 'transactions' as table_name,
		'transaction_id' as column_name,
        transaction_id as val
        from base
	union all select 
		'transactions',
        'customer_id',
        customer_id from base
	union all select 
		'transactions',
        'timestamp',
        timestamp from base
	union all select 
		'transactions',
        'amount',
		amount from base
	union all select 
		'transactions',
        'merchant_category',
        merchant_category from base
	union all select 
		'transactions',
        'channel',
        channel from base
	union all select 
		'transactions',
		'device_type',
        device_type from base
	union all select 
		'transactions',
        'city',
        city from base
)
select 
	table_name,
    column_name,
    sum(case when val is null or lower(trim(val)) in ('','-','null','missing','n/a') then 1 else 0 end) as count_missing
from u
group by table_name, column_name
order by count_missing;    

-- finding duplicates

with customer_dups as (
	select 
		*,
        row_number() over(partition by customer_id, signup_date, country, age, employment_status, plan_type, risk_segment) as row_num
	from customers_staging
)
select 
	*
from customer_dups
where row_num >1;

with fraud_flags_dups as (
	select
		*,
        row_number() over(partition by transaction_id, fraud_flag) as row_num
	from fraud_flags_staging
)
select * from fraud_flags_dups where row_num > 1;

with transaction_dups as (
	select 
		*,
        row_number() over(partition by customer_id, timestamp, amount, merchant_category,channel,device_type, city) as row_num
	from transactions_staging
)
select 
	*
from transaction_dups 
where row_num > 1;

select 
	transaction_id,
    count(*) as tot_count
from transactions_staging
group by transaction_id
having count(*) > 1
order by tot_count desc
limit 50;

select 
	customer_id,
    count(*) as tot_count
from customers_staging
group by customer_id
having count(*) > 1
order by tot_count desc
limit 50;

select 
	transaction_id,
    count(*) as tot_count
from fraud_flags_staging
group by transaction_id
having count(*) > 1
order by tot_count desc
limit 50;

select count(*) as num_transaction_ids_with_dups
from (
	select transaction_id
    from transactions_staging
    group by transaction_id
    having count(*) > 1
) x;

select max(cnt) as max_dups_for_one_transaction_id
from (
	select transaction_id, count(*) as cnt
    from transactions_staging
    group by transaction_id
) t;

select count(*) as missing_customer_id_rows
from transactions_staging
where customer_id is null or trim(customer_id)='';

drop table if exists clean_customers;
create table clean_customers as
select 
	trim(customer_id) as customer_id,
    nullif(trim(signup_date), '') as signup_date,
    upper(trim(country)) as country,
    case
		when age is null or trim(age) = '' then NULL
        when trim(age) regexp '^[0-9]+(\\.[0-9]+)?$' then
			case 
				when cast(age as decimal(10,2)) < 18 or cast(age as decimal(10,2)) > 100 then null
                else cast(cast(age as decimal(10,2)) as signed)
			end
		else null
	end as age,
    nullif(lower(trim(employment_status)),'') as employment_status,
    nullif(lower(trim(plan_type)),'') as plan_type,
    nullif(lower(trim(risk_segment)), '') as risk_segment
from customers_staging
where customer_id is not null and trim(customer_id) <> '';

select * from clean_customers;

select count(*) as row_clean_customers from clean_customers;

select sum(age is null) as null_ages_after_clean from clean_customers;

-- cleaning transactions
drop table if exists clean_transactions;

create table clean_transactions as 
select
	trim(transaction_id) as transaction_id,
    nullif(trim(customer_id),'') as customer_id,
    case
		when trim(`timestamp`) regexp '^[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}$'
			 AND CAST(SUBSTRING(TRIM(`timestamp`), 6, 2) AS UNSIGNED) BETWEEN 1 AND 12
             AND CAST(SUBSTRING(TRIM(`timestamp`), 9, 2) AS UNSIGNED) BETWEEN 1 AND 31
             AND CAST(SUBSTRING(TRIM(`timestamp`), 12, 2) AS UNSIGNED) BETWEEN 0 AND 23
             AND CAST(SUBSTRING(TRIM(`timestamp`), 15, 2) AS UNSIGNED) BETWEEN 0 AND 59
             AND CAST(SUBSTRING(TRIM(`timestamp`), 18, 2) AS UNSIGNED) BETWEEN 0 AND 59
		then str_to_date(trim(`timestamp`), '%Y-%m-%d %H:%i:%s')
		else null
	end as  transaction_ts,
	case
			when amount is null or trim(amount) = '' then null
            when replace(replace(replace(lower(trim(amount)), 'r', ''), ',', ''), ' ', '') regexp '^-?[0-9]+(\\.[0-9]+)?$' 
				then cast(replace(replace(replace(lower(trim(amount)), 'r', ''), ',', ''), ' ', '') as decimal(12,2))
			else null
	end as amount,
	lower(trim(merchant_category)) as merchant_category,
	nullif(lower(trim(channel)), '') as channel,
	nullif(lower(trim(device_type)), '') as device_type,
	nullif(lower(trim(city)), '') as city
from transactions_staging
where transaction_id is not null and trim(transaction_id) <> '';

select * from clean_transactions;

select count(*) as row_clean_transactions
from clean_transactions;

select 
	sum(customer_id is null) as missing_customer_id,
    sum(transaction_ts is null) as missing_transaction_ts,
    sum(amount is null) as missing_amount
from clean_transactions;

drop table if exists rejects_transaction;

create table rejects_transaction as
select 
	*,
    case 
		when customer_id is null then 'missing_customer_id'
		when transaction_ts is null then 'invalid_timestamp'
        when amount is null then 'invalid_amount'
        else 'other'
	end as reject_reason
from clean_transactions
where customer_id is null
	or transaction_ts is null
    or amount is null;

select reject_reason, count(*) as cnt
from rejects_transaction
group by reject_reason
order by cnt desc;

-- cleaning fraud flags
select * from fraud_flags_staging;

drop table if exists clean_fraud_flags;

create table clean_fraud_flags as
select 
	trim(transaction_id) as transaction_id,
    case
		when trim(fraud_flag) in ('0','1') then cast(trim(fraud_flag) as unsigned)
        else null
	end as fraud_flag
from fraud_flags_staging
where transaction_id is not null 
	and transaction_id <> '';

select 
	count(*) as row_clean_fraud_flags,
    sum(fraud_flag is null) as null_fraud_flag_rows
from clean_fraud_flags;

-- tables for analytics
create table analytics_transactions as
select 
	t.transaction_id,
    t.customer_id,
    t.transaction_ts,
    t.amount,
    t.merchant_category,
    t.channel,
    t.device_type,
    t.city,
    coalesce(f.fraud_flag, 0) as fraud_flag
from clean_transactions as t
left join clean_fraud_flags as f
	on t.transaction_id = f.transaction_id
where t.customer_id is not null
	and t.transaction_ts is not null
    and t.amount is not null;
    
select count(*) as analytics_transaction_rows
from analytics_transactions;

drop table if exists customer_risk_features;

create table customer_risk_features as
with base as (
	select 
		customer_id,
        count(*) as total_trans,
        sum(amount) as total_spend,
        avg(amount) as avg_trans_amount,
        sum(fraud_flag) as fraud_trans_count,
        avg(fraud_flag) as fraud_rate,
        sum(case
				when transaction_ts >= now() - interval 30 day then 1
                else 0
			end) as trans_last_30_days
	from analytics_transactions
    group by customer_id
),
top_category as (
	select customer_id, merchant_category
    from (
		select
			customer_id,
            merchant_category,
            count(*) as cnt,
            row_number() over(
				partition by customer_id 
                order by count(*) desc, merchant_category
            ) as rn
		from analytics_transactions
        group by customer_id, merchant_category
    ) x
    where rn = 1
),
channel_mix as (
	select
		customer_id,
        round(avg(channel = 'wallet'), 4) as pct_wallet,
        round(avg(channel = 'card'), 4) as pct_card,
        round(avg(channel = 'bank_transfer'), 4) as pct_bank_transfer,
        round(avg(channel = 'eft'), 4) as pct_eft,
        round(avg(channel = 'mobile_money'), 4) as pct_mobile_money
	from analytics_transactions
    group by customer_id
)
select 
	c.customer_id,
    c.country,
    c.age,
    c.employment_status,
    c.plan_type,
    c.risk_segment,
    b.total_trans,
    round(b.total_spend,2) as total_spend,
    round(b.avg_trans_amount,2) as avg_trans_amount,
    b.trans_last_30_days,
    b.fraud_trans_count,
    round(b.fraud_rate, 4) as fraud_rate,
    tc.merchant_category as top_merchant_category,
    cm.pct_wallet,
    cm.pct_card,
    cm.pct_bank_transfer,
    cm.pct_eft,
    cm.pct_mobile_money
from clean_customers as c
join base as b
	on c.customer_id = b.customer_id
left join top_category as tc
	on c.customer_id = tc.customer_id
left join channel_mix as cm
	on c.customer_id = cm.customer_id;
    
select count(*) as customer_feature_rows
from customer_risk_features;

select * from customer_risk_features limit 10;

select
	round(avg(fraud_rate),4) as avg_customer_fraud_rate,
    round(avg(total_spend), 2) as avg_customer_total_send,
    round(Avg(total_trans),2) as avg_customer_total_trans
from customer_risk_features;