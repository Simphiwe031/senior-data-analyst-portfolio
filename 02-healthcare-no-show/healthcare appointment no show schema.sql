-- healthcare appointment no show schema
create database Health_care_appointment_no_show;
create table medical_appointment_no_show(
	Appointment_ID Bigint primary key,
	Patient_ID int not null,
    Appointment_date date,
    Scheduled_date date not null,
    age int not null check (age >=0),
    gender varchar(1) not null,
    SMS_received Boolean not null,
    No_show_flag Boolean not null

);
