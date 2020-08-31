-- Creating tables for retiring employees
SELECT e.emp_no,e.first_name,e.last_name,
       ti.title, ti.from_date,
	   s.salary
INTO emp_title_salary
FROM employees AS e
INNER JOIN titles AS ti
ON (e.emp_no = ti.emp_no)
INNER JOIN salaries AS s
ON (e.emp_no = s.emp_no)
ORDER BY e.emp_no ASC;

-- Creating tables for retiring employees with birth date between 1952 and 1955
SELECT e.emp_no,e.first_name,e.last_name,
       ti.title, ti.from_date,
	   s.salary
INTO emp_title_salary_retirees
FROM employees AS e
INNER JOIN titles AS ti
ON (e.emp_no = ti.emp_no)
INNER JOIN salaries AS s
ON (e.emp_no = s.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
ORDER BY e.emp_no ASC;

-- Creating tables for count of employee title sorted by from date and title
SELECT stemp.from_date,stemp.title, COUNT(stemp.title)
INTO emp_title_count
FROM
(SELECT emp_no,first_name,last_name, 
       title,from_date,salary 
FROM
  (SELECT emp_no,first_name,last_name, 
   title,from_date,salary,
     ROW_NUMBER() OVER 
(PARTITION BY (emp_no) ORDER BY from_date DESC) rn
   FROM emp_title_salary
  ) tmp WHERE rn = 1) AS stemp
GROUP BY stemp.from_date,stemp.title;


-- Creating tables for count of titles of all employees retiring sorted by from date and title
SELECT stemp.from_date,stemp.title, COUNT(stemp.title)
INTO emp_title_retirees_count_fromdateorder
FROM
(SELECT emp_no,first_name,last_name, 
       title,from_date,salary 
FROM
  (SELECT emp_no,first_name,last_name, 
   title,from_date,salary,
     ROW_NUMBER() OVER 
(PARTITION BY (emp_no) ORDER BY from_date DESC) rn
   FROM emp_title_salary_retirees
  ) tmp WHERE rn = 1) AS stemp
GROUP BY stemp.from_date,stemp.title;


-- Creating tables for count of titles of all employees retiring sorted by title
SELECT stemp.title, COUNT(stemp.title)
INTO emp_title_retirees_count_bytitle
FROM
(SELECT emp_no,first_name,last_name, 
       title,from_date,salary 
FROM
  (SELECT emp_no,first_name,last_name, 
   title,from_date,salary,
     ROW_NUMBER() OVER 
(PARTITION BY (emp_no) ORDER BY from_date DESC) rn
   FROM emp_title_salary_retirees
  ) tmp WHERE rn = 1) AS stemp
GROUP BY stemp.title;

-- Creating tables for potential mentor's employee number, first and last name, their title, employment dates 
-- whose birth date is between Jan 1, 1965 and Dec 31, 1965
SELECT e.emp_no,e.first_name,e.last_name,
       ti.title, ti.from_date, ti.to_date
INTO emp_titles_subset
FROM employees AS e
INNER JOIN titles AS ti
ON (e.emp_no = ti.emp_no)
WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
AND ti.to_date = '9999-01-01'
ORDER BY e.emp_no ASC;