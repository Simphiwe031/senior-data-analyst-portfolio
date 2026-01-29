USE customer_segmentation_and_LTV_analysis;

select * from product_events;
select * from payments;
select * from subscriptions;
select * from users;

select * from subscriptions where end_date is null;
select count(*) from users where user_id is null or user_id='';

-- checking for duplicates

with Subscriptions_dups as (
	select *, row_number()
    over(partition by subscription_id, user_id, plan_type, start_date, end_date, `status`, created_at)
    as row_num from subscriptions
) select * from subscriptions_dups where row_num > 1;

with product_events_dups as (
	select *, row_number()
    over(partition by product_event_id, user_id, event_date, event_type)
    as row_num from product_events
) select * from product_events_dups where row_num >1;

with payments_dups as (
	select *, row_number()
    over(partition by payment_id, subscription_id, user_id, payment_date, amount,
			currency, payment_status, payment_method, invoice_period_start, invoice_period_end)
	as row_num from payments
) select * from payments_dups where row_num > 1;

with users_dups as (
select *, row_number()
over(partition by user_id, signup_date, acquisition_channel, country)
as row_num from users
) select * from users_dups where row_num > 1;

select user_id, count(*) 
from users 
group by user_id
having count(*) > 1;

select subscription_id, count(*)
from subscriptions
group by subscription_id
having count(*) > 1;

select product_event_id, count(*)
from product_events
group by product_event_id
having count(*) > 1;

select payment_id, count(*)
from payments
group by payment_id
having count(*) > 1;

-- verifying foreign keys
select count(*) as bad_payments
from payments p
left join subscriptions s on p.subscription_id = s.subscription_id
where s.subscription_id is null;

select count(*) as bad_subscriptions
from subscriptions as s
left join users as u on s.user_id = u.user_id
where u.user_id is null;

select distinct payment_status from payments;
select distinct plan_type from subscriptions;

select count(*) as bad_sub_dates
from subscriptions
where end_date is not null and end_date < start_date;

select count(*) as bad_invoice_peroids
from payments
where invoice_period_end <= invoice_period_start;

select count(*) as bad_payment_dates
from payments
where payment_date < invoice_period_start
or payment_date > invoice_period_end;

select count(*) as negative_amounts
from payments
where amount<0;

select payment_status, min(amount), max(amount)
from payments
group by payment_status;

select
  (select count(*) from users) as users,
  (select count(*) from subscriptions) as subscriptions,
  (select count(*) from payments) as payments,
  (select count(*) from product_events) as product_events,
  (select count(*) from payments p left join subscriptions s on p.subscription_id=s.subscription_id where s.subscription_id is null) as bad_payments_fk,
  (select count(*) from subscriptions s left join users u on s.user_id=u.user_id where u.user_id is null) as bad_subscriptions_fk;

select * from users limit 20;
select * from subscriptions limit 20;
select * from product_events limit 20;
select * from payments limit 20;