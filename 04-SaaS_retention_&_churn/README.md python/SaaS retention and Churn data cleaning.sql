-- data cleaning
select count(*) from users;
select count(*) from subscriptions;
select count(*) from product_events;

select * from subscriptions where end_date is null limit 5;

-- data validation 
-- checking for foreign key
select count(*) as distinct_subscriptions
from subscriptions as s
left join users as u on s.user_id = u.user_id
where u.user_id is null;

select count(*) as distinct_events
from product_events as e
left join users as u on e.user_id = u.user_id
where u.user_id is null;

-- checking for nulls
select count(*) as bad_dates
from subscriptions
where start_date is null;

select count(*) as bad_dates
from product_events
where event_date is null;

-- checking the fee field
select min(monthly_fee) as min_fee,
max(monthly_fee) as max_fee
from subscriptions;

alter table subscriptions
modify monthly_fee decimal(10,2);

-- fixing the monthly fee field to be able to perform calculations

-- checking churn
select count(*) as nulls,
sum(end_date= '0000-00-00') as zero_dates,
sum(end_date= ' ') as empty_strings
from subscriptions;

select count(*) as suspected_nulls
from subscriptions 
where end_date is not null
	and end_date < '1000-01-01';

select end_date 
from subscriptions
limit 50;

select * 
from users
limit 20;

select * 
from subscriptions
limit 20;

select * 
from product_events
limit 20;
