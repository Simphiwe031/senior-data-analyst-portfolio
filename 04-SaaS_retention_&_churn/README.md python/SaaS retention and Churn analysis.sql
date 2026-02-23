-- analysis

-- counting the number of users that were active after month end
with months as (
	select distinct last_day(start_date) as month_end
    from subscriptions
)
select m.month_end,
count(distinct s.user_id) as active_users
from months as m 
join subscriptions as s
	on s.start_date <= m.month_end
    and (s.end_date is null or s.end_date >= m.month_end)
group by m.month_end
order by m.month_end;

select last_day(end_date) as churn_month,
count(distinct user_id) as churned_users
from subscriptions
where end_date is not null 
group by churn_month
order by 1;

with monthly_active as (
	select m.month_end,
    count(distinct s.user_id) as active_users
    from (
    select distinct last_day(start_date) as month_end
    from subscriptions
    ) as m
    join subscriptions s
    on s.start_date <= m.month_end
    and (s.end_date is not null or s.end_date >= m.month_end)
    group by m.month_end
),
monthly_churn as (
	select last_day(end_date) as churn_month,
    count(distinct user_id) as churned_users
    from subscriptions
    where end_date is not null
    group by churn_month
)
select a.month_end,
a.active_users,
coalesce(c.churned_users,0) as churned_users,
round(
coalesce(c.churned_users, 0) / a.active_users,4) as churn_rate
from monthly_active as a
left join monthly_churn as c
on a.month_end = c.churn_month
order by a.month_end;

with cohorts as (
	select user_id, 
    date_format(signup_date, '%Y-%m-01') as cohort_month
    from users
),
activity as (
	select s.user_id, 
    date_format(start_date, '%Y-%m-01') as activity_month
    from subscriptions s
)
select c.cohort_month, 
a.activity_month,
count(distinct c.user_id) as retained_users
from cohorts as c
join activity as a
	on c.user_id = a.user_id
group by c.cohort_month, a.activity_month
order by c.cohort_month, a.activity_month;

-- money lost due to each churn 
select last_day(end_date) as churn_month,
sum(monthly_fee) as revenue_churned
from subscriptions
where end_date is not null
group by churn_month
order by churn_month;

-- driver of price and product decision 
select plan_type, 
count(*) as churned_users
from subscriptions
where end_date is not null
group by plan_type
order by churned_users desc;