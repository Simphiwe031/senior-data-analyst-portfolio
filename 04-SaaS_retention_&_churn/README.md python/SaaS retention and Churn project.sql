##a database for this project is created.
## The users table is created and the user is set to be the primary key
## this is done so that we are able to link the tables to the main table
## for the other 2 tables the user_id column is used as a foreign key as it the common link to the main table
create database SaaS_Retention_and_Churn;
create table users(
user_id varchar(250) primary key,
signup_date date NOT NULL,
acquisition_channel varchar(250),
country varchar(250)

);
create table subscriptions(
subscription_id int auto_increment primary key,
user_id varchar(250) NOT NULL,
plan_type varchar(250) NOT NULL,
start_date date NOT NULL,
end_date date,
monthly_fee decimal(10,2) NOT NULL,
constraint fk_user
	foreign key (user_id)
	references users(user_id)
);
create table product_events(
product_id int auto_increment primary key,
user_id varchar(250) NOT NULL,
event_date date NOT NULL,
event_type varchar(250) NOT NULL,
constraint fk2_user
	foreign key (user_id)
    references users(user_id)

);
