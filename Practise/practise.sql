-- Distinct

SELECT DISTINCT titles FROM Employees


-- Counting unique birth dates
SELECT COUNT(DISTINCT birth_date) from employees

/*
* DB: World
* Table: country
* Question: Can I get a list of distinct life expectancy ages
* Make sure there are no nulls
*/

SELECT DISTINCT lifeexpectancy FROM country
WHERE lifeexpectancy IS NOT NULL
ORDER BY lifeexpectancy;

-- sorting by name
Select first_name, last_name from employees order By first_name, last_name desc

-- sorting by age
select age(birth_date) from employees order by age

-- sort by name starting with 'k' by hire_date
SELECT * FROM employees where first_name like 'K%' Order By hire_date
--------------------------------------
-- MULTI TABLE SELECT --
SELECT * from employees

SELECT a.emp_no, concat(a.first_name, a.last_name) as "Name", b.salary From employees as a, salaries as b where a.emp_no = b.emp_no

select a.emp_no, concat(a.first_name, a.last_name) as "Name", b.salary From employees as a inner join salaries as b on a.emp_no = b.emp_no order by a.emp_no