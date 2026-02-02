-- data validation

describe fact_experiment_user_outcomes;

show index from fact_experiment_user_outcomes;

select 
	sum(tenure_months < 0) as bad_tenure,
    sum(post_period not in (0,1)) as bad_post_period,
    sum(churn not in (0,1)) as bad_churn
from fact_experiment_user_outcomes;

select experiment_group,
post_period,
count(*) as n_users
from fact_experiment_user_outcomes
group by experiment_group, post_period
order by experiment_group, post_period;

select experiment_group,
count(*) as n_users,
round(avg(churn),4) as churn_rate
from fact_experiment_user_outcomes
where post_period = 0
group by experiment_group
order by experiment_group;

select experiment_group,
count(*) as n_users,
round(avg(tenure_months),2) as avg_tenure,
round(avg(monthly_charges),2) as avg_monthly_charges
from fact_experiment_user_outcomes
where post_period = 0
group by experiment_group
order by experiment_group;

select experiment_group,
count(*) as n_users
from fact_experiment_user_outcomes
where post_period = 1
group by experiment_group;

select experiment_group,
count(*) as n_users,
round(avg(churn),2) as churn_rate
from fact_experiment_user_outcomes
where post_period = 1
group by experiment_group;

select experiment_group,
count(*) as n_users,
round(avg(tenure_months),2) as avg_tenure,
round(avg(churn),2) as avg_churn
from fact_experiment_user_outcomes
where post_period = 1
group by experiment_group
order by experiment_group;