-- Data cleaning project

select * 
from layoffs_raw;

-- Create a copy of the original table
create table layoffs
like layoffs_raw;

select *
from layoffs;

insert into layoffs
select *
from layoffs_raw;

select *
from layoffs;

-- Step 1: Remove all the duplicate data

with duplicate_cte as 
(
select *,
row_number() over(partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
from layoffs
)
select *
from duplicate_cte
where row_num > 1;

-- Create a table identical to the CTE
CREATE TABLE `layoffs2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select *
from layoffs2;

insert into layoffs2
select *,
row_number() over(partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
from layoffs;

-- Delete the duplicate rows
delete
from layoffs2
where row_num > 1;

-- Step2: Standardise the data

select company, trim(company)
from layoffs2; 

update layoffs2
set company = trim(company);

select distinct location
from layoffs2
order by 1;

select distinct industry
from layoffs2
order by 1;

select *
from layoffs2
where industry like 'Crypto%';

update layoffs2
set industry = 'Crypto'
where industry like 'Crypto%';

select distinct country
from layoffs2
order by 1;

select distinct country, trim(trailing '.' from country)
from layoffs2
order by 1;

update layoffs2
set country = trim(trailing '.' from country)
where country like 'United States%';

-- Change the date column data type from string to date

select `date`
from layoffs2;

select `date`, str_to_date(`date`, '%m/%d/%Y')
from layoffs2;

update layoffs2
set `date` = str_to_date(`date`, '%m/%d/%Y');

alter table layoffs2
modify column `date` date; 

-- Step 3: Look at nulls and blanks

select * 
from layoffs2;

select *
from layoffs2
where industry is null
or industry = '';

select *
from layoffs2
where company = 'Airbnb';

-- Populate the nulls or blanks

update layoffs2
set industry = null
where industry = '';

select tb1.industry, tb2.industry
from layoffs2 tb1
join layoffs2 tb2
	on tb1.company = tb2.company
    and tb1.location = tb2.location
where (tb1.industry is null or tb1.industry = '')
and tb2.industry is not null;

update layoffs2 tb1
join layoffs2 tb2
	on tb1.company = tb2.company
    and tb1.location = tb2.location
set tb1.industry = tb2.industry
where tb1.industry is null
and tb2.industry is not null;

-- Step 4: Remove irrelevant columns or rows

select *
from layoffs2
where total_laid_off is null
and percentage_laid_off is null;

delete
from layoffs2
where total_laid_off is null
and percentage_laid_off is null;

alter table layoffs2
drop column row_num;

select *
from layoffs2;

