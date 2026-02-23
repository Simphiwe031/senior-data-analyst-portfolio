-- Data cleaning
use world_layoffs;
select * from layoffs;

-- remove duplicates
-- standardize the data
-- null or blank values
-- removes unnecessary rows or columns

create table layoffs_staging
like layoffs;

insert layoffs_staging
select * from layoffs;

select * from layoffs_staging;
-- to avoid making mistakes on the raw data.

select *, row_number() 
over(partition by company, industry, total_laid_off, percentage_laid_off, `date`) 
from layoffs_staging;

with CTE_duplicates as 
(
select *, row_number() 
over(partition by company, industry, total_laid_off, 
percentage_laid_off, `date`, location, 
stage, country, funds_raised_millions) as row_num
from layoffs_staging
)
select * from CTE_duplicates
where row_num > 1;

-- checking if these are actually duplicates 
select * from layoffs_staging where company = 'Casper';
select * from layoffs_staging where company = 'Casper';


CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select * from layoffs_staging2;

insert into layoffs_staging2
select *, row_number() 
over(partition by company, industry, total_laid_off, 
percentage_laid_off, `date`, location, 
stage, country, funds_raised_millions) as row_num
from layoffs_staging;
-- 1 means unique values

SET SQL_SAFE_UPDATES = 0;
delete 
from layoffs_staging2
where row_num > 1;
SET SQL_SAFE_UPDATES = 1;

-- checking if query worked
select * from layoffs_staging2 where row_num > 1; 

select * from layoffs_staging2;

-- standardizing data

select distinct(trim(company)) from layoffs_staging2; -- trim for removing spaces before and after text

select company, trim((company)) from layoffs_staging2;

-- to update we use the update function 
update layoffs_staging2 
set company = trim(company); 

select distinct industry from layoffs_staging2 order by 1;

select * from layoffs_staging2 where industry like 'crypto%';

SET SQL_SAFE_UPDATES = 0;
update layoffs_staging2
set industry = 'Crypto'
where industry like 'Crypto%';
SET SQL_SAFE_UPDATES = 1;

select * from layoffs_staging2 where industry like 'crypto%';

select distinct location from layoffs_staging2 order by 1;

select distinct country from layoffs_staging2 order by 1;

select distinct country, trim(Trailing '.' from country) from layoffs_staging2
order by 1;

SET SQL_SAFE_UPDATES = 0;
update layoffs_staging2
set country = trim(Trailing '.' from country)
where country like 'United states';
SET SQL_SAFE_UPDATES = 1;

select `date`, 
str_to_date(`date`,'%m/%d/%Y')
from layoffs_staging2;

SET SQL_SAFE_UPDATES = 0;
update layoffs_staging2
set `date` = str_to_date(`date`,'%Y/%m/%d');
SET SQL_SAFE_UPDATES = 1;

select `date` from layoffs_staging2;

alter table layoffs_staging2
modify column `date` date;

select * from layoffs_staging2;

-- null and blanks
select * from layoffs_staging2
where total_laid_off is null and percentage_laid_off is null;

select * from layoffs_staging2 where industry is null 
or industry = '';

Select * from layoffs_staging2 where company = 'Airbnb';

Select * from layoffs_staging2 where company like 'Bally%';

select * from layoffs_staging2 t1
join layoffs_staging t2 
	on t1.company = t2.company
    and t1.location = t2.location
where (t1.industry is null or t1.industry = '')
and t2.industry is not null;

select t1.industry, t2.industry from layoffs_staging2 t1
join layoffs_staging t2 
	on t1.company = t2.company
    and t1.location = t2.location
where (t1.industry is null or t1.industry = '')
and t2.industry is not null;

-- set blanks to nulls

SET SQL_SAFE_UPDATES = 0;
update layoffs_staging2
set industry = null 
where industry = '';

select t1.industry, t2.industry from layoffs_staging2 t1
join layoffs_staging t2 
	on t1.company = t2.company
    and t1.location = t2.location
where (t1.industry is null or t1.industry = '')
and t2.industry is not null;

update layoffs_staging2 t1
join layoffs_staging2 t2 
	on t1.company = t2.company
set t1.industry = t2.industry
where (t1.industry is null )
and t2.industry is not null;

Select * from layoffs_staging2 where company = 'Airbnb';

select * from layoffs_staging2
where total_laid_off is null and percentage_laid_off is null;

delete 
from layoffs_staging2
where total_laid_off is null and percentage_laid_off is null;

select * from layoffs_staging2;

alter table layoffs_staging2
drop column row_num;

