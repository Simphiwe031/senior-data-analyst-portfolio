create database if not exists risk_monitoring_etl;

drop table if exists transactions;

create table transactions(
	transaction_id varchar(50) primary key,
    customer_id varchar(50),
    timestamp varchar(50),
    amount varchar(50),
    merchant_category varchar(50),
    channel varchar(50),
    device_type varchar(50),
    city varchar(50)
);

drop table if exists customers;

create table customers(
	customer_id varchar(50) primary key,
    signup_date varchar(50),
    country varchar(50),
    age varchar(20),
    employment_status varchar(50),
    plan_type varchar(50),
    risk_segment varchar(50)
);

drop table if exists fraud_flags;
create table fraud_flags(
	transaction_id varchar(50) primary key,
    fraud_flag varchar(50)
);

show variables like 'local_infile';
set global local_infile = 1;
show variables like 'local_infile';

LOAD DATA LOCAL INFILE 'C:\\Users\\Vukani\\Downloads\\customers_raw.csv'
INTO TABLE customers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

select * from customers;

Load data local infile 'C:\\Users\\Vukani\\Downloads\\fraud_flags_raw.csv'
into table fraud_flags
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 lines;

select * from fraud_flags;

Load data local infile 'C:\\Users\\Vukani\\Downloads\\transactions_raw.csv'
into table transactions
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 lines;

select * from transactions;