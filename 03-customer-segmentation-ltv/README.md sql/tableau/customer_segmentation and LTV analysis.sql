-- customer segmentation and LTV analysis

create or replace view v_payment_net as 
select payment_id,
user_id, subscription_id, payment_date,
invoice_period_start, invoice_period_end,
payment_status, amount,
case 
	when payment_status = 'paid' then amount
    when payment_status in ('refunded', 'chargeback') then - amount
else 0
end as net_amount
from payments;

create or replace view v_ltv_user as 
select u.user_id,
u.signup_date, u.acquisition_channel,
u.country,
coalesce(sum(p.net_amount), 0) as ltv_total,

count( distinct p.payment_id) as payment_count,
min(p.payment_date) as first_payment_date,
max(p.payment_date) as last_payment_date
from users as u
left join v_payment_net as p
	on u.user_id = p.user_id
group by 
u.user_id, u.signup_date, u.acquisition_channel, u.country;

create or replace view v_user_lifetime as 
select s.user_id,
min(s.start_date) as first_start_date,
max(coalesce(s.end_date, current_date())) as last_end_or_today,

greatest(
	timestampdiff(month, min(s.start_date), max(coalesce(s.end_date, current_date))),
    1
) as lifetime_months
from subscriptions as s
group by s.user_id;

create or replace view v_ltv_user_final as 
select l.user_id,
l.signup_date,
l.acquisition_channel,
l.country,
l.ltv_total,
lf.lifetime_months,
round(l.ltv_total / lf.lifetime_months, 2) as arpu_monthly
from v_ltv_user as l
join v_user_lifetime as lf
	on l.user_id = lf.user_id;
    
CREATE OR REPLACE VIEW v_ltv_segments AS
SELECT
  *,
  CASE
    WHEN ltv_bucket = 4 THEN 'High Value'
    WHEN ltv_bucket IN (2,3) THEN 'Medium Value'
    ELSE 'Low Value'
  END AS ltv_segment
FROM (
  SELECT
    *,
    NTILE(4) OVER (ORDER BY ltv_total) AS ltv_bucket
  FROM v_ltv_user_final
) t;

select ltv_segment, count(*) as users
from v_ltv_segments
group by ltv_segment;

select count(*) as users,
round(avg(ltv_total), 2) as avg_ltv,
round(min(ltv_total), 2) as min_ltv,
round(max(ltv_total), 2) as max_ltv
from v_ltv_user_final;

select * 
from v_ltv_user_final
order by ltv_total desc
limit 30;

select 
acquisition_channel,
count(*) as users,
round(avg(ltv_total), 2) as avg_ltv,
round(sum(ltv_total), 2) total_ltv
from v_ltv_user_final
group by acquisition_channel
order by total_ltv desc;

select s.plan_type, 
count(distinct s.user_id) as users,
round(avg(l.ltv_total), 2) as avg_ltv,
round(sum(l.ltv_total), 2) as total_ltv
from subscriptions as s
join v_ltv_user_final as l on s.user_id = l.user_id
group by s.plan_type
order by total_ltv desc;

select acquisition_channel, count(*) as users,
round(avg(ltv_total),2) as avg_ltv,
round(avg(ltv_total),2) as total_ltv
from v_ltv_segments
group by acquisition_channel
order by total_ltv desc;

select acquisition_channel,
sum(ltv_segment = 'High Value') as high_value_users,
count(*) as total_users,
round(sum(ltv_segment = 'High Value')/count(*) * 100, 2) as pct_high_value
from v_ltv_segments
group by acquisition_channel
order by pct_high_value desc;

select ltv_segment,
count(*) as users,
round(sum(ltv_total), 2) as total_ltv,
round(sum(ltv_total)/sum(sum(ltv_total)) over() * 100, 2) as revenue_share_pct,
round(avg(ltv_total), 2) as avg_ltv
from v_ltv_segments
group by ltv_segment
order by total_ltv desc;

create or replace view v_user_engagement as
select user_id, count(*) as total_events,
count(distinct event_date) as active_days
from product_events
group by user_id;

create or replace view v_ltv_engagement as 
select s.user_id,
s.acquisition_channel,
s.country,
s.ltv_total,
s.ltv_segment,
coalesce(e.total_events, 0) as total_events,
coalesce(e.active_days, 0) as active_days
from v_ltv_segments as s
left join v_user_engagement as e
on s.user_id = e.user_id;

select ltv_segment, 
round(avg(total_events), 1) as avg_events,
round(Avg(active_days), 1) as avg_active_days,
round(Avg(ltv_total), 2) as avg_ltv
from v_ltv_engagement
group by ltv_segment
order by avg_ltv desc;