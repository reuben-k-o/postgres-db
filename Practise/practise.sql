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

-----------------------------------------------------
-- HAVING-----

SELECT d.dept_name, COUNT(e.emp_no) AS "# of Employees"
FROM employees as e
JOIN dept_emp USING (emp_no)
JOIN departments AS d USING(dept_no)
WHERE e.gender = 'F'
GROUP BY d.dept_name
HAVING count(e.emp_no) > 25000

/*
*  Show me all the employees, hired after 1991, that have had more than 2 titles
*  Database: Employees
*/
SELECT e.emp_no, count(t.title)
FROM employees AS e
JOIN titles AS t USING (emp_no)
WHERE EXTRACT (YEAR FROM hire_date) > 1991
GROUP BY e.emp_no
HAVING count(t.title) > 2
ORDER By e.emp_no


/*
*  Show me all the employees that have had more than 15 salary changes that work in the department development
*  Database: Employees
*/
SELECT e.emp_no, count(s.salary), d.dept_no
FROM employees AS e
JOIN salaries AS s USING (emp_no)
JOIN dept_emp AS d USING (emp_no)
GROUP BY e.emp_no, d.dept_no
HAVING count(s.salary) > 15
ORDER By e.emp_no
-----
SELECT e.emp_no, count(s.from_date) as "amount of raises"
FROM employees as e
JOIN salaries as s USING(emp_no)
JOIN dept_emp AS de USING(emp_no)
WHERE de.dept_no = 'd005'
GROUP BY e.emp_no
HAVING count(s.from_date) > 15
ORDER BY e.emp_no;



/*
*  Show me all the employees that have worked for multiple departments
*  Database: Employees
*/

SELECT e.emp_no, count(d.dept_no), d.dept_no
FROM employees AS e
JOIN dept_emp AS d USING (emp_no)
GROUP BY e.emp_no, d.dept_no
HAVING count(d.dept_no) > 1
ORDER By e.emp_no

---------------------------------------------
--GROUPING SETS--

SELECT EXTRACT (YEAR FROM orderdate) AS "year",
    EXTRACT (MONTH FROM orderdate) AS "month",
    EXTRACT (DAY FROM orderdate) AS "day",
    SUM(ol.quantity)
FROM orderlines AS ol 
GROUP BY
    ROLLUP (
    EXTRACT (YEAR FROM orderdate),
    EXTRACT (MONTH FROM orderdate) ,
    EXTRACT (DAY FROM orderdate)
    )

ORDER BY EXTRACT (YEAR FROM orderdate),
    EXTRACT (MONTH FROM orderdate) ,
    EXTRACT (DAY FROM orderdate)

-------------------------------------------------------
--- WINDOW FUNCTIONS----

SELECT emp_no, salary, COUNT( salary) OVER ( 
    PARTITION BY emp_no -- count the occurence
    ORDER BY emp_no -- cumulative 
)
FROM salaries

---- FRAME CLAUSE-----
SELECT DISTINCT e.emp_no,
                e.last_name,
                d.dept_name,
                LAST_VALUE(s.salary) OVER(
                    PARTITION BY e.emp_no
                    ORDER BY s.from_date
                    RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
                ) AS "current salary"
FROM salaries as s
JOIN employees as e USING (emp_no)
JOIN dept_emp as de USING (emp_no)
JOIN departments as d USING (dept_no)

ORDER BY e.emp_no


---------------

/*
*  Show the population per continent
*  Database: World
*  Table: Country
*/

SELECT DISTINCT continent, SUM(population) 0VER (
    PARTITION BY continent
)
FROM country

/*
*  To the previous query add on the ability to calculate the percentage of the world population
*  What that means is that you will divide the population of that continent by the total population and multiply by 100 to get a percentage.
*  Make sure you convert the population numbers to float using `population::float` otherwise you may see zero pop up
*  Try to use CONCAT AND ROUND to make the data look pretty
*
*  Database: World
*  Table: Country
*/

SELECT
  DISTINCT continent,
  SUM(population) OVER w1 as"continent population",
  CONCAT( 
      ROUND( 
          ( 
            SUM( population::float4 ) OVER w1 / 
            SUM( population::float4 ) OVER() 
          ) * 100    
      ),'%' ) as "percentage of population"
FROM country 
WINDOW w1 AS( PARTITION BY continent );


/*
*  Count the number of towns per region
*
*  Database: France
*  Table: Regions (Join + Window function)
*/

SELECT 
DISTINCT r.id, 
r."name", 
COUNT(t.id) OVER (
    PARTITION BY r.id
    ORDER BY r."name"
) AS "# of towns"
FROM regions AS r
JOIN departments AS d ON r.code = d.region 
JOIN towns AS t ON d.code = t.department
ORDER BY r.id;

-------------------------------------
--CONDITIONALS--


/**
* Database: Store
* Table: products
* Create a case statement that's named "price class" where if a product is over 20 dollars you show 'expensive'
* if it's between 10 and 20 you show 'average' 
* and of is lower than or equal to 10 you show 'cheap'

*/

SELECT actor, price, CASE 
        WHEN price > 20 THEN 'Expensive'
        WHEN price > 10 THEN 'Average'
        ELSE 'Cheap'
    END AS "price class"
FROM products

-------------------------------------
--NULLIF---


/*
* DB: Store
* Table: products
* Question: Show NULL when the product is not on special (0)
*/

SELECT prod_id, title, price, NULLIF(special, 1) as "special"
FROM products


----------------------------------------
--VIEWS---

/*
*  Create a view "90-95" that:
*  Shows me all the employees, hired between 1990 and 1995
*  Database: Employees
*/

CREATE VIEW "90-95" AS 
SELECT * 
FROM employees 
-- WHERE EXTRACT ( YEAR FROM hire_date) >= 1990 AND EXTRACT ( YEAR FROM hire_date) <= 1990
WHERE EXTRACT ( YEAR FROM hire_date) BETWEEN 1990 AND 1995
ORDER BY emp_no
-- ...

/*
*  Create a view "bigbucks" that:
*  Shows me all employees that have ever had a salary over 80000
*  Database: Employees
*/

CREATE VIEW "bigbucks" AS 
SELECT emp_no, CONCAT(first_name, last_name) AS "Full name" , s.salary
FROM employees
JOIN salaries as s USING (emp_no)
WHERE s.salary > 80000
ORDER BY emp_no


---------------------------------------------
--INDEX---

SELECT name, district, countrycode FROM city
WHERE countrycode IN ( 'TUN', 'BE', 'NL')

---CREATE INDEX ---

CREATE INDEX idx_countrycode ON city (countrycode)

-- HASH ALGORITHM----
CREATE INDEX idx_countrycode ON city USING hash (countrycode)

SELECT name, district, countrycode FROM city
WHERE countrycode = 'TUN' OR countrycode =  'BE' OR countrycode = 'NL'


---------------------------------------
--SUBQUERY----

SELECT title, price, (SELECT AVG(price) FROM products) AS "Global Average"
-- FROM products 
FROM (SELECT * FROM products WHERE price > 22) AS "products sub" 