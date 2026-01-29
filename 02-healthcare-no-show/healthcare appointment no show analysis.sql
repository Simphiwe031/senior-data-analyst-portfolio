-- healthcare appointment no show analysis
set SQL_SAFE_UPDATES = 0;

 alter table medical_appointment_no_show
 add lead_time_days int;
 
 update medical_appointment_no_show
 set lead_time_days = datediff(scheduled_date, appointment_date);
 
 alter table medical_appointment_no_show
 add appointment_day varchar(10);
 
 update medical_appointment_no_show
 set appointment_day = dayname(appointment_date);
 
 alter table medical_appointment_no_show
 add appointment_month varchar(10);
 
 update medical_appointment_no_show
 set appointment_month = monthname(appointment_date);
 
 alter table medical_appointment_no_show
 add age_group varchar(20);
 
 update medical_appointment_no_show
 set age_group = case
	when age < 13 then 'Child'
    when age between 13 and 19 then 'Teen'
    when age between 20 and 35 then 'Young Adult'
    when age between 36 and 55 then 'Adult'
    else 'Senior'
end;

alter table medical_appointment_no_show
add lead_time_group varchar(20);

update medical_appointment_no_show
set lead_time_group = case
	when lead_time_days = 0 then 'Same Day'
    when lead_time_days between 1 and 7 then '1-7 Days'
    when lead_time_days between 8 and 30 then '8-30 Days'
    else '30+ Days'
end;

alter table medical_appointment_no_show
add sms_category varchar(20);

update medical_appointment_no_show
set sms_category = case
	when sms_received = 1 then 'SMS Received'
    else 'No SMS'
end;

Select count(*) from medical_appointment_no_show; 

Select No_show_flag, count(*) 
from medical_appointment_no_show
group by No_show_flag;

select count(*) as invalid_ages
from medical_appointment_no_show
where age < 0 or age >120;

select count(*) as negative_leads
from medical_appointment_no_show
where lead_time_days < 0;

select sum(Patient_ID is null) as Patient_nulls,
sum(Appointment_Date is null) as Appointment_date_nulls,
sum(Scheduled_Date is null) as Scheduled_date_nulls,
sum(No_Show_Flag is null) as no_show_nulls,
sum(age is null) as Age_nulls,
sum(gender is null) as gender_nulls,
sum(SMS_received is null) as SMS_received_nulls
from medical_appointment_no_show;

select * from medical_appointment_no_show;

-- overall no show percentage 
select count(*) as total_appointment,
round(sum(No_show_flag = 'Yes')/count(*) * 100,2) as no_show_rate_percentage
from medical_appointment_no_show;

select sms_category,
count(*) as no_of_appointments,
sum(no_show_flag = 'Yes')/count(*) as no_shows,
round(sum(No_show_flag = 'Yes')/count(*) * 100,2) as no_show_rate_percentage
from medical_appointment_no_show
group by sms_category;

select age_group, 
count(*) as appointments,
sum(no_show_flag = 'Yes')/count(*) as no_shows,
round(sum(No_show_flag = 'Yes')/count(*) * 100,2) as no_show_rate_percentage
from medical_appointment_no_show
group by age_group
order by no_show_rate_percentage desc;

select lead_time_group, 
count(*) as appointments,
sum(No_show_flag = 'Yes') as no_shows,
round(sum(No_show_flag = 'Yes')/count(*) * 100,2) as no_show_rate_percentage
from medical_appointment_no_show
group by lead_time_group
order by no_show_rate_percentage desc;

select appointment_day, 
count(*) as appointments,
sum(No_show_flag = 'Yes') as no_shows,
round(sum(No_show_flag = 'Yes')/count(*) * 100,2) as no_show_rate_percentage
from medical_appointment_no_show
group by appointment_day
order by no_show_rate_percentage desc;

select age_group, lead_time_group,
count(*) as appointments,
round(sum(No_show_flag = 'Yes')/count(*) * 100,2) as no_show_rate_percentage
from medical_appointment_no_show
group by age_group, lead_time_group
having count(*) >= 20
order by no_show_rate_percentage;