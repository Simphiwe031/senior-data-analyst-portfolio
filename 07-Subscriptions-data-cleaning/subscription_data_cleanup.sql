-- subscriptions orders data quality cleanup
create database subscriptions_data_cleanup;

create table subscriptions_raw(
	order_id_raw varchar(50),
    customer_id varchar(25),
    signup_ts text,
    order_ts text,
    plan_raw text,
    status_raw text,
    order_amount text,
    currency text,
    quantity text,
    discount text,
    tax_rate text,
    payment_method text,
    marketing_chanel text,
    device text,
    customer_email text,
    customer_phone text,
    customer_country text,
    customer_city text,
    customer_age text,
    notes text
) 