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

-------------------------------------------------
-- INNER JION----
select a.emp_no, concat(a.first_name, a.last_name) as "Name", b.salary, b.from_date, c.title
 From employees as a inner join salaries as b on a.emp_no = b.emp_no 
 inner Join titles as c on c.emp_no = a.emp_no and (b.from_date + interval '2 days') = c.from_date
 Order by a.emp_no, b.from_date

select a.emp_no, concat(a.first_name, a.last_name) as "Name", b.salary, b.from_date, c.title
 From employees as a inner join salaries as b on a.emp_no = b.emp_no 
 inner Join titles as c on c.emp_no = a.emp_no and ((b.from_date + interval '2 days') = c.from_date or b.from_date = c.from_date)
 Order by a.emp_no, b.from_date

 ---------------------------------------------
 -- lEFT JION --
 select a.emp_no,
    concat(a.first_name, a.last_name) as "Name",
    b.salary,
    COALESCE(b.from_date:: text , '-') as "Title taken on",
    COALESCE(c.title, 'No title change')
 From employees as a 
 INNER JOIN salaries as b on a.emp_no = b.emp_no 
 LEFT JOIN titles as c on c.emp_no = a.emp_no and ((b.from_date + interval '2 days') = c.from_date or b.from_date = c.from_date)
 Order by a.emp_no, b.from_date

 
 ---- Practise on INNER JOIN -------
/*
* DB: Store
* Table: orders
* Question: Get all orders from customers who live in Ohio (OH), New York (NY) or Oregon (OR) state
* ordered by orderid
*/

select a.customerid, a.state, b.orderid 
from customers as a 
inner join orders as b on a.customerid = b.customerid
where a.state in ('OH','NY', 'OR')


/*
* DB: Store
* Table: products
* Question: Show me the inventory for each product
*/
SELECT a.prod_id, a.title, a.category, b.quan_in_stock, b.sales
FROM products as a
inner join inventory as b on a.prod_id = b.prod_id


/*
* DB: Employees
* Table: employees
* Question: Show me for each employee which department they work in
*/ 
SELECT e.emp_no, e.first_name, dp.dept_name
FROM employees AS e
INNER JOIN dept_emp AS de ON de.emp_no = e.emp_no
INNER JOIN departments AS dp ON dp.dept_no = de.dept_no
order by e.emp_no

--------------------------------------------------
------ GROUP BY ----------
/*
*  How many people were hired on did we hire on any given hire date?
*  Database: Employees
*  Table: Employees
*/

SELECT hire_date, COUNT(emp_no) as "amount"
FROM employees
GROUP BY hire_date
ORDER BY "amount" DESC;

/*
*  Show me all the employees, hired after 1991 and count the amount of positions they've had
*  Database: Employees
*/

SELECT e.emp_no, count(t.title) as "amount of titles"
FROM employees as e
JOIN titles as t USING(emp_no)
WHERE EXTRACT (YEAR FROM e.hire_date) > 1991
GROUP BY e.emp_no
ORDER BY e.emp_no;

/*
*  Show me all the employees that work in the department development and the from and to date.
*  Database: Employees
*/
SELECT e.emp_no, de.from_date, de.to_date
FROM employees as e
JOIN dept_emp AS de USING(emp_no)
WHERE de.dept_no = 'd005'
GROUP BY e.emp_no, de.from_date, de.to_date