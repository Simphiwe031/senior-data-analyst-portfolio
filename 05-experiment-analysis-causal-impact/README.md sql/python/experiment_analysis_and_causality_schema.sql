create database Experiment_analysis_and_causal_impact;

create table fact_experiment_user_outcomes(
	user_id bigint not null primary key,
    experiment_group enum('Control','Treatment') not null,
    signup_date date not null,
    tenure_months int not null,
    monthly_charges decimal(10,2) not null,
    post_period tinyint not null,
    churn tinyint not null,
    revenue decimal(10,2) not null default 0
);

create index idx_exp_group_post
on fact_experiment_user_outcomes( experiment_group, post_period);

create index idx_exp_group_post_churn
on fact_experiment_user_outcomes(experiment_group, post_period, churn);

alter table fact_experiment_user_outcomes
add constraint chk_tenure_nonnegative
check (tenure_months >= 0);