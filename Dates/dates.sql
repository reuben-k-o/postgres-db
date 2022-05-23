-- selecting age of > 50
SELECT AGE(birth_date) FROM employees WHERE (EXTRACT (YEAR FROM AGE(birth_date)) > 50)