create database customer_segmentation_and_LTV_analysis;
create table users(
	user_id varchar(36) not null primary key,
    signup_date date not null,
    acquisition_channel varchar(250) not null,
    country varchar(250) not null
);

create table subscriptions(
	subscription_id varchar(36) not null primary key,
    user_id varchar(36) not null,
    plan_type varchar(250) not null,
    start_date date not null,
    end_date date,
    
    constraint fk_user
		foreign key (user_id)
        references users(user_id)
);

create table product_events(
	product_event_id varchar(36) not null primary key,
    user_id varchar(36) not null,
    event_date date not null,
    event_type varchar(250) not null,
    
    constraint fk2_user
    foreign key (user_id)
    references users(user_id)
);

alter table subscriptions
add `status` varchar(20) not null default 'active',
add created_at datetime not null default current_timestamp;

create table payments(
	payment_id varchar(36) not null primary key,
    subscription_id varchar(36) not null,
    user_id varchar(36) not null,
    
    payment_date date not null,
    amount decimal(10,2),
    currency char(3) not null default 'ZAR',
    
    payment_status varchar(25),
    payment_method varchar(30),
    invoice_period_start date,
    invoice_period_end date,
    
    constraint fk3_user
    foreign key (user_id)
    references users(user_id),
    
    constraint fk4_user
    foreign key (subscription_id)
    references subscriptions(subscription_id)
);

create INDEX idx_payments_user_date on payments(user_id,payment_date);
drop INDEX idx_payment_user_date on payments;
create index idx_payments_sub_date on payments(subscription_id,payment_date);
create index idx_subscription_user on subscriptions(subscription_id);
create index idx_events_user_date on product_events(user_id,event_date);

select u.user_id, 
sum(case when p.payment_status = 'paid' then p.amount else 0 end) -
sum(case when p.payment_status in ('refunded','chargeback') then p.amount else 0 end)
as lifetime_value
from users as u left join payments p
on u.user_id = p.user_id
group by u.user_id;

select u.acquisition_channel, 
round(avg(p.amount),2) as avg_payment,
round(sum(p.amount),2) as total_revenue
from users as u
join payments as p on u.user_id = p.user_id
where p.payment_status = 'paid'
group by u.acquisition_channel
order by total_revenue desc;